import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type {
  PurchaseBill,
  PurchaseBillLine,
} from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  addMoney,
  cmpMoney,
  mulMoneyPercent,
  roundMoney,
} from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import { ItemsRepository } from './items.repository';
import {
  purchaseBillFilterQuerySchema,
  type PurchaseBillCreateDto,
  type PurchaseBillDto,
  type PurchaseBillLineDto,
  type PurchaseBillLineWriteDto,
  type PurchaseBillStatus,
  type PurchaseBillUpdateDto,
} from './purchase-bills.dto';
import {
  PurchaseBillsRepository,
  type PurchaseBillWithLines,
} from './purchase-bills.repository';
import { TaxCodesRepository } from './tax-codes.repository';
import { VendorsRepository } from './vendors.repository';

@Injectable()
export class PurchaseBillsService {
  constructor(
    private readonly repository: PurchaseBillsRepository,
    private readonly accountingPostingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
    private readonly vendorsRepository: VendorsRepository,
    private readonly itemsRepository: ItemsRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toLineDto(line: PurchaseBillLine): PurchaseBillLineDto {
    return {
      id: line.id,
      purchase_bill_id: line.purchase_bill_id,
      item_id: line.item_id ?? null,
      account_id: line.account_id,
      description: line.description ?? null,
      quantity: String(line.quantity),
      rate: String(line.rate),
      tax_code_id: line.tax_code_id ?? null,
      net_amount: String(line.net_amount),
      tax_amount: String(line.tax_amount),
    };
  }

  toDto(bill: PurchaseBill, lines: PurchaseBillLine[] = []): PurchaseBillDto {
    return {
      id: bill.id,
      bill_number: bill.bill_number,
      vendor_id: bill.vendor_id,
      bill_date: bill.bill_date,
      due_date: bill.due_date ?? null,
      status: bill.status as PurchaseBillStatus,
      subtotal: String(bill.subtotal),
      tax_amount: String(bill.tax_amount),
      total_amount: String(bill.total_amount),
      journal_entry_id: bill.journal_entry_id ?? null,
      row_version: bill.row_version,
      created_at: bill.created_at,
      updated_at: bill.updated_at ?? null,
      lines: lines.map((l) => this.toLineDto(l)),
    };
  }

  toDtoWithLines(bill: PurchaseBillWithLines): PurchaseBillDto {
    return this.toDto(bill, bill.lines);
  }

  private async validateVendor(vendorId: number) {
    const vendor = await this.vendorsRepository.findById(vendorId);
    if (!vendor) {
      throw new NotFoundError(`Vendor ${vendorId} was not found`);
    }
    if (!vendor.is_active) {
      throw new BusinessRuleError('Vendor is inactive');
    }
    return vendor;
  }

  private async validateItem(itemId: number) {
    const item = await this.itemsRepository.findById(itemId);
    if (!item) {
      throw new NotFoundError(`Item ${itemId} was not found`);
    }
    if (!item.is_active) {
      throw new BusinessRuleError('Item is inactive');
    }
    return item;
  }

  private async validateLineAccount(accountId: number) {
    const account = await this.accountsRepository.findById(accountId);
    if (!account) {
      throw new NotFoundError(`Account ${accountId} was not found`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError('Account is inactive');
    }
    if (account.is_control) {
      throw new BusinessRuleError('Cannot post directly to control accounts');
    }
    return account;
  }

  private async validateTaxCode(taxCodeId: number) {
    const taxCode = await this.taxCodesRepository.findById(taxCodeId);
    if (!taxCode) {
      throw new NotFoundError(`Tax code ${taxCodeId} was not found`);
    }
    if (!taxCode.is_active) {
      throw new BusinessRuleError('Tax code is inactive');
    }
    return taxCode;
  }

  private async processLines(lines: PurchaseBillLineWriteDto[]): Promise<{
    processedLines: Array<{
      item_id: number | null;
      account_id: number;
      description: string | null;
      quantity: string;
      rate: string;
      tax_code_id: number | null;
      net_amount: string;
      tax_amount: string;
    }>;
    subtotal: string;
    taxAmount: string;
    totalAmount: string;
  }> {
    if (lines.length === 0) {
      throw new BusinessRuleError('At least one purchase bill line is required');
    }

    let subtotal = '0.00';
    let taxAmount = '0.00';
    const processedLines = [];

    for (const line of lines) {
      if (line.item_id != null) {
        await this.validateItem(line.item_id);
      }

      await this.validateLineAccount(line.account_id);

      let lineTaxRate: string | null = null;
      if (line.tax_code_id != null) {
        const taxCode = await this.validateTaxCode(line.tax_code_id);
        lineTaxRate = taxCode.rate_percent;
      }

      const qty = roundMoney(line.quantity ?? '1.00');
      const rate = roundMoney(line.rate);
      const netAmount = roundMoney(Number(qty) * Number(rate));
      const lineTaxAmount =
        lineTaxRate != null ? mulMoneyPercent(netAmount, lineTaxRate) : '0.00';

      subtotal = addMoney(subtotal, netAmount);
      taxAmount = addMoney(taxAmount, lineTaxAmount);

      processedLines.push({
        item_id: line.item_id ?? null,
        account_id: line.account_id,
        description: line.description ?? null,
        quantity: qty,
        rate,
        tax_code_id: line.tax_code_id ?? null,
        net_amount: netAmount,
        tax_amount: lineTaxAmount,
      });
    }

    const totalAmount = addMoney(subtotal, taxAmount);

    return {
      processedLines,
      subtotal,
      taxAmount,
      totalAmount,
    };
  }

  async create(
    dto: PurchaseBillCreateDto,
    _currentUser?: AuthenticatedUser,
  ): Promise<PurchaseBillDto> {
    await this.validateVendor(dto.vendor_id);

    const { processedLines, subtotal, taxAmount, totalAmount } =
      await this.processLines(dto.lines);

    return runInTransaction(this.db, async () => {
      const billNumber = await this.repository.allocateBillNumber();

      const created = await this.repository.insertBill(
        {
          bill_number: billNumber,
          vendor_id: dto.vendor_id,
          bill_date: dto.bill_date,
          due_date: dto.due_date ?? null,
          status: 'draft',
          subtotal,
          tax_amount: taxAmount,
          total_amount: totalAmount,
          journal_entry_id: null,
          row_version: 1,
          created_at: new Date(),
        },
        processedLines,
      );

      return this.toDtoWithLines(created);
    });
  }

  async update(
    id: number,
    dto: PurchaseBillUpdateDto,
    _currentUser?: AuthenticatedUser,
  ): Promise<PurchaseBillDto> {
    const bill = await this.repository.findWithLines(id);
    if (!bill) {
      throw new NotFoundError(`Purchase bill ${id} was not found`);
    }

    if (bill.status !== 'draft') {
      throw new BusinessRuleError('Only draft purchase bills can be edited');
    }

    if (dto.vendor_id != null) {
      await this.validateVendor(dto.vendor_id);
    }

    return runInTransaction(this.db, async () => {
      let subtotal = bill.subtotal;
      let taxAmount = bill.tax_amount;
      let totalAmount = bill.total_amount;

      if (dto.lines != null) {
        const processed = await this.processLines(dto.lines);
        subtotal = processed.subtotal;
        taxAmount = processed.taxAmount;
        totalAmount = processed.totalAmount;

        await this.repository.replaceLines(id, processed.processedLines);
      }

      await this.repository.updateBill(id, {
        vendor_id: dto.vendor_id ?? bill.vendor_id,
        bill_date: dto.bill_date ?? bill.bill_date,
        due_date: dto.due_date !== undefined ? dto.due_date : bill.due_date,
        subtotal,
        tax_amount: taxAmount,
        total_amount: totalAmount,
        row_version: bill.row_version + 1,
        updated_at: new Date(),
      });

      const updated = await this.repository.findWithLines(id);
      if (!updated) {
        throw new NotFoundError(`Purchase bill ${id} was not found`);
      }
      return this.toDtoWithLines(updated);
    });
  }

  async getById(id: number, _currentUser?: AuthenticatedUser): Promise<PurchaseBillDto> {
    const bill = await this.repository.findWithLines(id);
    if (!bill) {
      throw new NotFoundError(`Purchase bill ${id} was not found`);
    }
    return this.toDtoWithLines(bill);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _currentUser?: AuthenticatedUser,
  ): Promise<PaginatedResponse<PurchaseBillDto>> {
    const filters = purchaseBillFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      status: filters.status,
      vendorId: filters.vendor_id,
      from: filters.from,
      to: filters.to,
      search: filters.search,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r, [])),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async post(id: number, currentUser?: AuthenticatedUser): Promise<PurchaseBillDto> {
    const bill = await this.repository.findWithLines(id);
    if (!bill) {
      throw new NotFoundError(`Purchase bill ${id} was not found`);
    }

    if (bill.status === 'posted') {
      return this.toDtoWithLines(bill);
    }

    if (bill.status === 'void') {
      throw new BusinessRuleError('Void purchase bills cannot be posted');
    }

    if (bill.status !== 'draft') {
      throw new BusinessRuleError(`Purchase bill with status "${bill.status}" cannot be posted`);
    }

    if (!bill.lines || bill.lines.length === 0) {
      throw new BusinessRuleError('Purchase bill has no lines to post');
    }

    return runInTransaction(this.db, async () => {
      let apAcc = await this.accountsRepository.findByControlRole('ap');
      if (!apAcc) {
        apAcc = await this.accountsRepository.findByCode('2000');
      }
      if (!apAcc) {
        throw new BusinessRuleError(
          'Accounts payable control account (ap / 2000) not found',
        );
      }
      const apAccountId = apAcc.id;

      let inputTaxAccountId: number | null = null;
      if (cmpMoney(bill.tax_amount, '0.00') > 0) {
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

      // DR line accounts for net_amount
      for (const line of bill.lines) {
        if (cmpMoney(line.net_amount, '0.00') > 0) {
          journalLines.push({
            accountId: line.account_id,
            debit: line.net_amount,
            credit: '0.00',
            memo: line.description ?? `Purchase bill ${bill.bill_number} line`,
            vendorId: bill.vendor_id,
          });
        }
      }

      // DR Input tax account for bill tax_amount
      if (cmpMoney(bill.tax_amount, '0.00') > 0 && inputTaxAccountId != null) {
        journalLines.push({
          accountId: inputTaxAccountId,
          debit: bill.tax_amount,
          credit: '0.00',
          memo: `Input tax for bill ${bill.bill_number}`,
          vendorId: bill.vendor_id,
        });
      }

      // CR Accounts Payable for bill total_amount
      journalLines.push({
        accountId: apAccountId,
        debit: '0.00',
        credit: bill.total_amount,
        memo: `Purchase bill ${bill.bill_number}`,
        vendorId: bill.vendor_id,
      });

      const journal = await this.accountingPostingService.postJournal({
        entryDate: bill.bill_date,
        sourceType: 'purchase_bill',
        sourceId: bill.id,
        memo: `Purchase bill ${bill.bill_number}`,
        postedByUserId: currentUser?.id ?? null,
        lines: journalLines,
      });

      await this.repository.updateBill(bill.id, {
        status: 'posted',
        journal_entry_id: journal.id,
        row_version: bill.row_version + 1,
        updated_at: new Date(),
      });

      const updated = await this.repository.findWithLines(bill.id);
      if (!updated) {
        throw new NotFoundError(`Purchase bill ${bill.id} was not found`);
      }
      return this.toDtoWithLines(updated);
    });
  }
}
