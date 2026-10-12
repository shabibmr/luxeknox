import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type {
  ExpenseVoucher,
  ExpenseVoucherLine,
  NewExpenseVoucher,
} from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { addMoney, cmpMoney, mulMoneyPercent, roundMoney } from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import {
  expenseFilterQuerySchema,
  type ExpenseCreateDto,
  type ExpenseLineCreateDto,
  type ExpenseStatus,
  type ExpenseUpdateDto,
  type ExpenseVoucherDto,
  type ExpenseVoucherLineDto,
} from './expenses.dto';
import { ExpensesRepository, type ExpenseVoucherWithLines } from './expenses.repository';
import { TaxCodesRepository } from './tax-codes.repository';
import { VendorsRepository } from './vendors.repository';

@Injectable()
export class ExpensesService {
  constructor(
    private readonly expensesRepository: ExpensesRepository,
    private readonly accountingPostingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
    private readonly vendorsRepository: VendorsRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toLineDto(line: ExpenseVoucherLine): ExpenseVoucherLineDto {
    return {
      id: line.id,
      expense_voucher_id: line.expense_voucher_id,
      account_id: line.account_id,
      description: line.description ?? null,
      amount: String(line.amount),
      tax_code_id: line.tax_code_id ?? null,
      tax_amount: String(line.tax_amount),
    };
  }

  toDto(voucher: ExpenseVoucher, lines: ExpenseVoucherLine[] = []): ExpenseVoucherDto {
    return {
      id: voucher.id,
      expense_number: voucher.expense_number,
      vendor_id: voucher.vendor_id ?? null,
      payee_name: voucher.payee_name ?? null,
      expense_date: voucher.expense_date,
      paid_from_account_id: voucher.paid_from_account_id ?? null,
      status: voucher.status as ExpenseStatus,
      subtotal: String(voucher.subtotal),
      tax_amount: String(voucher.tax_amount),
      total_amount: String(voucher.total_amount),
      journal_entry_id: voucher.journal_entry_id ?? null,
      row_version: voucher.row_version,
      created_at: voucher.created_at,
      updated_at: voucher.updated_at ?? null,
      lines: lines.map((l) => this.toLineDto(l)),
    };
  }

  toDtoWithLines(voucher: ExpenseVoucherWithLines): ExpenseVoucherDto {
    return this.toDto(voucher, voucher.lines);
  }

  private async validatePaidFromAccount(accountId: number) {
    const account = await this.accountsRepository.findById(accountId);
    if (!account) {
      throw new NotFoundError(`Paid-from account ${accountId} was not found`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`Paid-from account ${account.code} is inactive`);
    }
    if (!account.is_bank) {
      throw new BusinessRuleError(
        `Paid-from account ${account.code} must be a bank or cash account (is_bank = true)`,
      );
    }
    return account;
  }

  private async validateExpenseLineAccount(accountId: number) {
    const account = await this.accountsRepository.findById(accountId);
    if (!account) {
      throw new NotFoundError(`Account ${accountId} was not found`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`Account ${account.code} is inactive`);
    }
    if (account.account_type !== 'expense' && account.account_type !== 'asset') {
      throw new BusinessRuleError(
        `Expense line account must be an expense or asset account (got: ${account.account_type})`,
      );
    }
    if (account.is_control) {
      throw new BusinessRuleError(
        `Control account ${account.code} cannot be directly posted in expense lines`,
      );
    }
    return account;
  }

  private async validateTaxCode(taxCodeId: number) {
    const taxCode = await this.taxCodesRepository.findById(taxCodeId);
    if (!taxCode) {
      throw new NotFoundError(`Tax code ${taxCodeId} was not found`);
    }
    if (!taxCode.is_active) {
      throw new BusinessRuleError(`Tax code ${taxCode.code} is inactive`);
    }
    return taxCode;
  }

  private async processLines(lines: ExpenseLineCreateDto[]): Promise<{
    processedLines: Array<{
      account_id: number;
      description: string | null;
      amount: string;
      tax_code_id: number | null;
      tax_amount: string;
    }>;
    subtotal: string;
    taxAmount: string;
    totalAmount: string;
  }> {
    if (!Array.isArray(lines) || lines.length === 0) {
      throw new BusinessRuleError('Expense voucher must have at least one line');
    }

    const processedLines: Array<{
      account_id: number;
      description: string | null;
      amount: string;
      tax_code_id: number | null;
      tax_amount: string;
    }> = [];

    let subtotal = '0.00';
    let totalTax = '0.00';

    for (const line of lines) {
      await this.validateExpenseLineAccount(line.account_id);

      let lineTaxAmount = '0.00';
      if (line.tax_code_id != null) {
        const taxCode = await this.validateTaxCode(line.tax_code_id);
        lineTaxAmount = mulMoneyPercent(line.amount, taxCode.rate_percent);
      }

      const normalizedAmount = roundMoney(line.amount);
      subtotal = addMoney(subtotal, normalizedAmount);
      totalTax = addMoney(totalTax, lineTaxAmount);

      processedLines.push({
        account_id: line.account_id,
        description: line.description ?? null,
        amount: normalizedAmount,
        tax_code_id: line.tax_code_id ?? null,
        tax_amount: lineTaxAmount,
      });
    }

    const totalAmount = addMoney(subtotal, totalTax);

    return {
      processedLines,
      subtotal,
      taxAmount: totalTax,
      totalAmount,
    };
  }

  async create(dto: ExpenseCreateDto, _actor?: AuthenticatedUser): Promise<ExpenseVoucherDto> {
    if (dto.paid_from_account_id != null) {
      await this.validatePaidFromAccount(dto.paid_from_account_id);
      if (dto.vendor_id != null) {
        await this.vendorsRepository.assertActiveVendor(dto.vendor_id);
      }
    } else {
      if (dto.vendor_id == null) {
        throw new BusinessRuleError('vendor_id is required for credit expense vouchers');
      }
      await this.vendorsRepository.assertActiveVendor(dto.vendor_id);
    }

    const { processedLines, subtotal, taxAmount, totalAmount } = await this.processLines(dto.lines);

    return runInTransaction(this.db, async () => {
      const expenseNumber = await this.expensesRepository.allocateExpenseNumber();
      const now = new Date();

      const created = await this.expensesRepository.insertExpense(
        {
          expense_number: expenseNumber,
          vendor_id: dto.vendor_id ?? null,
          payee_name: dto.payee_name ?? null,
          expense_date: dto.expense_date,
          paid_from_account_id: dto.paid_from_account_id ?? null,
          status: 'draft',
          subtotal,
          tax_amount: taxAmount,
          total_amount: totalAmount,
          journal_entry_id: null,
          row_version: 1,
          created_at: now,
          updated_at: null,
        },
        processedLines,
      );

      return this.toDtoWithLines(created);
    });
  }

  async update(
    id: number,
    dto: ExpenseUpdateDto,
    _actor?: AuthenticatedUser,
  ): Promise<ExpenseVoucherDto> {
    const existing = await this.expensesRepository.findWithLines(id);
    if (!existing) {
      throw new NotFoundError(`Expense voucher ${id} was not found`);
    }

    if (existing.status !== 'draft') {
      throw new BusinessRuleError('Only draft expense vouchers can be edited');
    }

    const effectivePaidFrom =
      dto.paid_from_account_id !== undefined
        ? dto.paid_from_account_id
        : existing.paid_from_account_id;
    const effectiveVendorId =
      dto.vendor_id !== undefined ? dto.vendor_id : existing.vendor_id;

    if (effectivePaidFrom != null) {
      if (dto.paid_from_account_id !== undefined && dto.paid_from_account_id !== null) {
        await this.validatePaidFromAccount(dto.paid_from_account_id);
      }
      if (dto.vendor_id !== undefined && dto.vendor_id !== null) {
        await this.vendorsRepository.assertActiveVendor(dto.vendor_id);
      }
    } else {
      if (effectiveVendorId == null) {
        throw new BusinessRuleError('vendor_id is required for credit expense vouchers');
      }
      if (dto.vendor_id !== undefined && dto.vendor_id !== null) {
        await this.vendorsRepository.assertActiveVendor(dto.vendor_id);
      }
    }

    return runInTransaction(this.db, async () => {
      let subtotal = existing.subtotal;
      let taxAmount = existing.tax_amount;
      let totalAmount = existing.total_amount;

      if (dto.lines !== undefined) {
        const processed = await this.processLines(dto.lines);
        subtotal = processed.subtotal;
        taxAmount = processed.taxAmount;
        totalAmount = processed.totalAmount;
        await this.expensesRepository.replaceLines(id, processed.processedLines);
      }

      const patch: Partial<NewExpenseVoucher> = {
        updated_at: new Date(),
        row_version: existing.row_version + 1,
      };

      if (dto.expense_date !== undefined) patch.expense_date = dto.expense_date;
      if (dto.paid_from_account_id !== undefined) patch.paid_from_account_id = dto.paid_from_account_id;
      if (dto.vendor_id !== undefined) patch.vendor_id = dto.vendor_id;
      if (dto.payee_name !== undefined) patch.payee_name = dto.payee_name;
      if (dto.lines !== undefined) {
        patch.subtotal = subtotal;
        patch.tax_amount = taxAmount;
        patch.total_amount = totalAmount;
      }

      await this.expensesRepository.updateExpense(id, patch);
      const updated = await this.expensesRepository.findWithLines(id);
      if (!updated) {
        throw new NotFoundError(`Expense voucher ${id} was not found`);
      }
      return this.toDtoWithLines(updated);
    });
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<ExpenseVoucherDto> {
    const voucher = await this.expensesRepository.findWithLines(id);
    if (!voucher) {
      throw new NotFoundError(`Expense voucher ${id} was not found`);
    }
    return this.toDtoWithLines(voucher);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<ExpenseVoucherDto>> {
    const filters = expenseFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.expensesRepository.findMany({
      status: filters.status,
      vendorId: filters.vendor_id,
      from: filters.from,
      to: filters.to,
      search: filters.search,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async post(id: number, currentUser?: AuthenticatedUser): Promise<ExpenseVoucherDto> {
    const expense = await this.expensesRepository.findWithLines(id);
    if (!expense) {
      throw new NotFoundError(`Expense voucher ${id} was not found`);
    }

    if (expense.status === 'posted') {
      return this.toDtoWithLines(expense);
    }

    if (expense.status !== 'draft') {
      throw new BusinessRuleError(
        `Expense voucher is in status '${expense.status}' and cannot be posted`,
      );
    }

    if (expense.lines.length === 0) {
      throw new BusinessRuleError('Expense voucher has no lines to post');
    }

    return runInTransaction(this.db, async () => {
      let inputTaxAccountId: number | null = null;
      if (cmpMoney(expense.tax_amount, '0.00') > 0) {
        let inputTaxAcc = await this.accountsRepository.findByControlRole('input_tax');
        if (!inputTaxAcc) {
          inputTaxAcc = await this.accountsRepository.findByCode('1300');
        }
        if (!inputTaxAcc) {
          throw new BusinessRuleError(
            'Input tax control account (input_tax / 1300) not found',
          );
        }
        inputTaxAccountId = inputTaxAcc.id;
      }

      const journalLines: PostJournalLineInput[] = [];

      // DR line accounts
      for (const line of expense.lines) {
        journalLines.push({
          accountId: line.account_id,
          debit: line.amount,
          memo: line.description ?? null,
        });
      }

      // DR input tax
      if (inputTaxAccountId != null && cmpMoney(expense.tax_amount, '0.00') > 0) {
        journalLines.push({
          accountId: inputTaxAccountId,
          debit: expense.tax_amount,
          memo: `Input tax on ${expense.expense_number}`,
        });
      }

      // Credit side
      if (expense.paid_from_account_id != null) {
        // Cash/Bank expense credits bank account directly
        journalLines.push({
          accountId: expense.paid_from_account_id,
          credit: expense.total_amount,
          memo: `Payment for ${expense.expense_number}`,
        });
      } else {
        // Credit expense credits AP
        let apAcc = await this.accountsRepository.findByControlRole('ap');
        if (!apAcc) {
          apAcc = await this.accountsRepository.findByCode('2000');
        }
        if (!apAcc) {
          throw new BusinessRuleError(
            'Accounts payable control account (ap / 2000) not found',
          );
        }
        journalLines.push({
          accountId: apAcc.id,
          credit: expense.total_amount,
          memo: `Payable for ${expense.expense_number}`,
          vendorId: expense.vendor_id ?? null,
        });
      }

      const journal = await this.accountingPostingService.postJournal({
        entryDate: expense.expense_date,
        sourceType: 'expense_voucher',
        sourceId: expense.id,
        memo: `Expense voucher ${expense.expense_number}`,
        postedByUserId: currentUser?.id ?? null,
        lines: journalLines,
      });

      await this.expensesRepository.updateExpense(expense.id, {
        status: 'posted',
        journal_entry_id: journal.id,
        row_version: expense.row_version + 1,
        updated_at: new Date(),
      });

      const updated = await this.expensesRepository.findWithLines(expense.id);
      if (!updated) {
        throw new NotFoundError(`Expense voucher ${expense.id} was not found`);
      }
      return this.toDtoWithLines(updated);
    });
  }
}
