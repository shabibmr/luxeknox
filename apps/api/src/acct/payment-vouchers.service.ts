import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type {
  NewPaymentVoucher,
  PaymentAllocation,
  PaymentVoucher,
} from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { addMoney, cmpMoney, fromCents, roundMoney, toCents } from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import {
  paymentVoucherFilterQuerySchema,
  type PaymentAllocationDto,
  type PaymentAllocationWriteDto,
  type PaymentVoucherCreateDto,
  type PaymentVoucherDto,
  type PaymentVoucherUpdateDto,
} from './payment-vouchers.dto';
import {
  PaymentVouchersRepository,
  type PaymentVoucherWithAllocations,
} from './payment-vouchers.repository';

@Injectable()
export class PaymentVouchersService {
  constructor(
    private readonly repository: PaymentVouchersRepository,
    private readonly postingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toAllocationDto(alloc: PaymentAllocation): PaymentAllocationDto {
    return {
      id: alloc.id,
      payment_voucher_id: alloc.payment_voucher_id,
      purchase_bill_id: alloc.purchase_bill_id ?? null,
      expense_voucher_id: alloc.expense_voucher_id ?? null,
      amount: String(alloc.amount),
    };
  }

  toDto(voucher: PaymentVoucher, allocations: PaymentAllocation[] = []): PaymentVoucherDto {
    return {
      id: voucher.id,
      voucher_number: voucher.voucher_number,
      payment_date: voucher.payment_date,
      bank_account_id: voucher.bank_account_id,
      total_amount: String(voucher.total_amount),
      memo: voucher.memo ?? null,
      status: voucher.status as 'draft' | 'posted',
      journal_entry_id: voucher.journal_entry_id ?? null,
      row_version: voucher.row_version,
      created_at: voucher.created_at,
      updated_at: voucher.updated_at ?? null,
      allocations: allocations.map((a) => this.toAllocationDto(a)),
    };
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<PaymentVoucherDto> {
    const voucher = await this.repository.findWithAllocations(id);
    if (!voucher) {
      throw new NotFoundError(`Payment voucher ${id} not found`);
    }
    return this.toDto(voucher, voucher.allocations);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentVoucherDto>> {
    const filters = paymentVoucherFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      status: filters.status,
      from: filters.from,
      to: filters.to,
      bankAccountId: filters.bank_account_id,
      search: filters.search,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r, r.allocations)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(
    dto: PaymentVoucherCreateDto,
    currentUser?: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return runInTransaction(this.db, async () => {
      // 1. Validate bank account
      await this.validateBankAccount(dto.bank_account_id);

      // 2. Validate allocations exist & sum equals total_amount
      if (!dto.allocations || dto.allocations.length === 0) {
        throw new BusinessRuleError('At least one allocation is required');
      }

      const totalAllocations = dto.allocations.reduce(
        (sum, a) => addMoney(sum, a.amount),
        '0.00',
      );
      if (cmpMoney(dto.total_amount, totalAllocations) !== 0) {
        throw new BusinessRuleError('Total amount must equal the sum of allocation amounts');
      }

      // 3. Validate each allocation target and open balance
      await this.validateAllocationsList(dto.allocations);

      // 4. Allocate voucher number
      const voucherNumber = await this.repository.allocatePaymentVoucherNumber();
      const now = new Date();

      const created = await this.repository.insertVoucher(
        {
          voucher_number: voucherNumber,
          payment_date: dto.payment_date,
          bank_account_id: dto.bank_account_id,
          total_amount: roundMoney(dto.total_amount),
          memo: dto.memo ?? null,
          status: 'draft',
          journal_entry_id: null,
          row_version: 1,
          created_at: now,
          updated_at: null,
        },
        dto.allocations.map((a) => ({
          purchase_bill_id: a.purchase_bill_id ?? null,
          expense_voucher_id: a.expense_voucher_id ?? null,
          amount: roundMoney(a.amount),
        })),
      );

      return this.toDto(created, created.allocations);
    });
  }

  async update(
    id: number,
    dto: PaymentVoucherUpdateDto,
    currentUser?: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return runInTransaction(this.db, async () => {
      const voucher = await this.repository.findWithAllocations(id);
      if (!voucher) {
        throw new NotFoundError(`Payment voucher ${id} not found`);
      }
      if (voucher.status !== 'draft') {
        throw new BusinessRuleError('Only draft payment vouchers can be edited');
      }

      if (dto.bank_account_id !== undefined && dto.bank_account_id !== voucher.bank_account_id) {
        await this.validateBankAccount(dto.bank_account_id);
      }

      const effectiveTotal =
        dto.total_amount !== undefined
          ? roundMoney(dto.total_amount)
          : String(voucher.total_amount);

      let currentAllocations = voucher.allocations;

      if (dto.allocations !== undefined) {
        if (dto.allocations.length === 0) {
          throw new BusinessRuleError('At least one allocation is required');
        }

        const sumAlloc = dto.allocations.reduce(
          (sum, a) => addMoney(sum, a.amount),
          '0.00',
        );
        if (cmpMoney(effectiveTotal, sumAlloc) !== 0) {
          throw new BusinessRuleError('Total amount must equal the sum of allocation amounts');
        }

        await this.validateAllocationsList(dto.allocations, voucher.id);

        currentAllocations = await this.repository.replaceAllocations(
          voucher.id,
          dto.allocations.map((a) => ({
            purchase_bill_id: a.purchase_bill_id ?? null,
            expense_voucher_id: a.expense_voucher_id ?? null,
            amount: roundMoney(a.amount),
          })),
        );
      } else if (dto.total_amount !== undefined) {
        const sumAlloc = voucher.allocations.reduce(
          (sum, a) => addMoney(sum, a.amount),
          '0.00',
        );
        if (cmpMoney(effectiveTotal, sumAlloc) !== 0) {
          throw new BusinessRuleError('Total amount must equal the sum of allocation amounts');
        }
      }

      const patch: Partial<NewPaymentVoucher> = {
        row_version: voucher.row_version + 1,
        updated_at: new Date(),
      };
      if (dto.payment_date !== undefined) patch.payment_date = dto.payment_date;
      if (dto.bank_account_id !== undefined) patch.bank_account_id = dto.bank_account_id;
      if (dto.total_amount !== undefined) patch.total_amount = roundMoney(dto.total_amount);
      if (dto.memo !== undefined) patch.memo = dto.memo;

      const updated = await this.repository.updateVoucher(voucher.id, patch);
      return this.toDto(updated, currentAllocations);
    });
  }

  async post(id: number, currentUser?: AuthenticatedUser): Promise<PaymentVoucherDto> {
    const existing = await this.repository.findWithAllocations(id);
    if (!existing) {
      throw new NotFoundError(`Payment voucher ${id} not found`);
    }
    if (existing.status === 'posted') {
      return this.toDto(existing, existing.allocations);
    }
    if (existing.status !== 'draft') {
      throw new BusinessRuleError('Only draft payment vouchers can be posted');
    }

    return runInTransaction(this.db, async () => {
      const voucher = await this.repository.findWithAllocations(id);
      if (!voucher) {
        throw new NotFoundError(`Payment voucher ${id} not found`);
      }
      if (voucher.status === 'posted') {
        return this.toDto(voucher, voucher.allocations);
      }
      if (voucher.status !== 'draft') {
        throw new BusinessRuleError('Only draft payment vouchers can be posted');
      }

      if (!voucher.allocations || voucher.allocations.length === 0) {
        throw new BusinessRuleError('Payment voucher must have at least one allocation to be posted');
      }

      // Resolve Accounts Payable
      const apAccount =
        (await this.accountsRepository.findByControlRole('ap')) ??
        (await this.accountsRepository.findByCode('2000'));
      if (!apAccount) {
        throw new BusinessRuleError('Accounts payable account not found');
      }

      // Re-verify open balances under transaction to prevent over-allocation
      const lines: PostJournalLineInput[] = [];
      const billAllocSum = new Map<number, bigint>();
      const expenseAllocSum = new Map<number, bigint>();

      for (const alloc of voucher.allocations) {
        if (alloc.purchase_bill_id) {
          const bill = await this.repository.findPurchaseBillById(alloc.purchase_bill_id);
          if (!bill) {
            throw new NotFoundError(`Purchase bill ${alloc.purchase_bill_id} not found`);
          }
          if (bill.status !== 'posted') {
            throw new BusinessRuleError(
              `Purchase bill ${bill.bill_number ?? alloc.purchase_bill_id} is not posted`,
            );
          }

          const postedAllocations = await this.repository.sumPostedAllocationsForBill(bill.id);
          const postedDebitNotes = await this.repository.sumPostedDebitNotesForBill(bill.id);

          const openBalanceCents =
            toCents(bill.total_amount) - toCents(postedAllocations) - toCents(postedDebitNotes);
          const prev = billAllocSum.get(bill.id) ?? 0n;
          const currentTotal = prev + toCents(alloc.amount);
          billAllocSum.set(bill.id, currentTotal);

          if (currentTotal > openBalanceCents) {
            throw new BusinessRuleError('Allocation amount exceeds open balance');
          }

          lines.push({
            accountId: apAccount.id,
            debit: String(alloc.amount),
            memo: `Payment for bill ${bill.bill_number}`,
            vendorId: bill.vendor_id,
          });
        } else if (alloc.expense_voucher_id) {
          const expense = await this.repository.findExpenseVoucherById(alloc.expense_voucher_id);
          if (!expense) {
            throw new NotFoundError(`Expense voucher ${alloc.expense_voucher_id} not found`);
          }
          if (expense.status !== 'posted') {
            throw new BusinessRuleError(
              `Expense voucher ${expense.expense_number ?? alloc.expense_voucher_id} is not posted`,
            );
          }
          if (expense.paid_from_account_id !== null) {
            throw new BusinessRuleError(
              `Expense voucher ${expense.expense_number ?? alloc.expense_voucher_id} is already paid directly and cannot be allocated`,
            );
          }

          const postedAllocations = await this.repository.sumPostedAllocationsForExpense(
            expense.id,
          );
          const openBalanceCents = toCents(expense.total_amount) - toCents(postedAllocations);
          const prev = expenseAllocSum.get(expense.id) ?? 0n;
          const currentTotal = prev + toCents(alloc.amount);
          expenseAllocSum.set(expense.id, currentTotal);

          if (currentTotal > openBalanceCents) {
            throw new BusinessRuleError('Allocation amount exceeds open balance');
          }

          lines.push({
            accountId: apAccount.id,
            debit: String(alloc.amount),
            memo: `Payment for expense ${expense.expense_number}`,
            vendorId: expense.vendor_id ?? null,
          });
        }
      }

      // Credit bank account for voucher total_amount
      lines.push({
        accountId: voucher.bank_account_id,
        credit: String(voucher.total_amount),
        memo: voucher.memo ?? `Payment voucher ${voucher.voucher_number}`,
      });

      const journal = await this.postingService.postJournal({
        entryDate: voucher.payment_date,
        sourceType: 'payment_voucher',
        sourceId: voucher.id,
        memo: voucher.memo ?? `Payment voucher ${voucher.voucher_number}`,
        postedByUserId: currentUser?.id ?? null,
        lines,
      });

      const updated = await this.repository.updateVoucher(voucher.id, {
        status: 'posted',
        journal_entry_id: journal.id,
        row_version: voucher.row_version + 1,
        updated_at: new Date(),
      });

      return this.toDto(updated, voucher.allocations);
    });
  }

  private async validateBankAccount(bankAccountId: number): Promise<void> {
    const account = await this.accountsRepository.findById(bankAccountId);
    if (!account) {
      throw new NotFoundError(`Bank account ${bankAccountId} not found`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`Bank account ${bankAccountId} is inactive`);
    }
    if (!account.is_bank) {
      throw new BusinessRuleError(`Account ${bankAccountId} is not a bank account`);
    }
  }

  private async validateAllocationsList(
    allocations: Array<{
      purchase_bill_id?: number | null;
      expense_voucher_id?: number | null;
      amount: string | number;
    }>,
    excludeVoucherId?: number,
  ): Promise<void> {
    const billAllocSum = new Map<number, bigint>();
    const expenseAllocSum = new Map<number, bigint>();

    for (const alloc of allocations) {
      if (alloc.purchase_bill_id) {
        const bill = await this.repository.findPurchaseBillById(alloc.purchase_bill_id);
        if (!bill) {
          throw new NotFoundError(`Purchase bill ${alloc.purchase_bill_id} not found`);
        }
        if (bill.status !== 'posted') {
          throw new BusinessRuleError(
            `Purchase bill ${bill.bill_number ?? alloc.purchase_bill_id} is not posted`,
          );
        }

        const postedAllocations = await this.repository.sumPostedAllocationsForBill(
          bill.id,
          excludeVoucherId,
        );
        const postedDebitNotes = await this.repository.sumPostedDebitNotesForBill(bill.id);

        const openBalanceCents =
          toCents(bill.total_amount) - toCents(postedAllocations) - toCents(postedDebitNotes);
        const prev = billAllocSum.get(bill.id) ?? 0n;
        const currentTotal = prev + toCents(alloc.amount);
        billAllocSum.set(bill.id, currentTotal);

        if (currentTotal > openBalanceCents) {
          throw new BusinessRuleError('Allocation amount exceeds open balance');
        }
      } else if (alloc.expense_voucher_id) {
        const expense = await this.repository.findExpenseVoucherById(alloc.expense_voucher_id);
        if (!expense) {
          throw new NotFoundError(`Expense voucher ${alloc.expense_voucher_id} not found`);
        }
        if (expense.status !== 'posted') {
          throw new BusinessRuleError(
            `Expense voucher ${expense.expense_number ?? alloc.expense_voucher_id} is not posted`,
          );
        }
        if (expense.paid_from_account_id !== null) {
          throw new BusinessRuleError(
            `Expense voucher ${expense.expense_number ?? alloc.expense_voucher_id} is already paid directly and cannot be allocated`,
          );
        }

        const postedAllocations = await this.repository.sumPostedAllocationsForExpense(
          expense.id,
          excludeVoucherId,
        );
        const openBalanceCents = toCents(expense.total_amount) - toCents(postedAllocations);
        const prev = expenseAllocSum.get(expense.id) ?? 0n;
        const currentTotal = prev + toCents(alloc.amount);
        expenseAllocSum.set(expense.id, currentTotal);

        if (currentTotal > openBalanceCents) {
          throw new BusinessRuleError('Allocation amount exceeds open balance');
        }
      } else {
        throw new BusinessRuleError(
          'Each allocation must specify exactly one of purchase_bill_id or expense_voucher_id',
        );
      }
    }
  }
}
