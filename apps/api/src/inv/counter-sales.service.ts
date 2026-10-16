import { Inject, Injectable } from '@nestjs/common';
import type { TaxCode } from '../platform/db/schema/accounting';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { addMoney, cmpMoney, mulMoneyPercent, mulQtyRate, subMoney } from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from '../acct/accounting-posting.service';
import { AccountsRepository } from '../acct/accounts.repository';
import { TaxCodesRepository } from '../acct/tax-codes.repository';
import { buildTaxComponentLines } from '../acct/tax-lines';
import {
  counterSaleFilterQuerySchema,
  type CounterSaleDto,
  type CounterSaleListItemDto,
  type SaleLineDto,
  type SaleWrite,
  type TenderDto,
} from './counter-sales.dto';
import {
  CounterSalesRepository,
  type CounterSaleDetail,
  type CounterSaleListRow,
  type SalePaymentMethodRow,
} from './counter-sales.repository';
import { InventoryItemsRepository, type InventoryItemRow } from './items.repository';
import { StockService } from './stock.service';

interface PreparedLine {
  item_id: number;
  item_name: string;
  quantity: string;
  rate: string;
  discount_amount: string;
  tax_code_id: number | null;
  income_account_id: number;
  inventory_tracked: boolean;
  inventory_account_id: number | null;
  cogs_account_id: number | null;
  gross: string;
  net_amount: string;
  tax_amount: string;
  /** Set after stock issue for tracked lines. */
  unit_cost: string | null;
  cost_amount: string | null;
  source_line_id: number | null;
}

interface PreparedTender {
  payment_method_id: number;
  payment_method_name: string;
  account_id: number;
  amount: string;
  reference: string | null;
}

function formatQuantity(quantity: string): string {
  const [whole, frac = ''] = quantity.split('.');
  return `${whole}.${(frac + '000').slice(0, 3)}`;
}

function quantityScale(quantity: string): number {
  return (quantity.split('.')[1] ?? '').replace(/0+$/, '').length;
}

@Injectable()
export class CounterSalesService {
  constructor(
    private readonly salesRepository: CounterSalesRepository,
    private readonly itemsRepository: InventoryItemsRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    private readonly accountsRepository: AccountsRepository,
    private readonly postingService: AccountingPostingService,
    private readonly stockService: StockService,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(detail: CounterSaleDetail): CounterSaleDto {
    if (detail.journal_entry_id == null || detail.journal_number == null) {
      throw new Error(`Counter sale ${detail.id} is missing its journal`);
    }
    const memberName =
      detail.member_first_name == null
        ? null
        : `${detail.member_first_name} ${detail.member_last_name ?? ''}`.trim();
    const lines: SaleLineDto[] = detail.lines.map((line) => ({
      id: line.id,
      item_id: line.item_id,
      item_name: line.item_name,
      uom_code: line.uom_code,
      quantity: String(line.quantity),
      rate: String(line.rate),
      discount_amount: String(line.discount_amount),
      tax_code_id: line.tax_code_id ?? null,
      net_amount: String(line.net_amount),
      tax_amount: String(line.tax_amount),
      line_total: addMoney(line.net_amount, line.tax_amount),
      unit_cost: line.unit_cost == null ? null : String(line.unit_cost),
      cost_amount: line.cost_amount == null ? null : String(line.cost_amount),
      returned_quantity: '0.000',
    }));
    const tenders: TenderDto[] = detail.tenders.map((tender) => ({
      id: tender.id,
      payment_method_id: tender.payment_method_id,
      payment_method_name: tender.payment_method_name,
      amount: String(tender.amount),
      reference: tender.reference ?? null,
    }));
    return {
      id: detail.id,
      sale_number: detail.sale_number,
      sale_date: detail.sale_date,
      member_id: detail.member_id ?? null,
      member_name: memberName,
      customer_name: detail.customer_name ?? null,
      status: 'posted',
      subtotal: String(detail.subtotal),
      discount_amount: String(detail.discount_amount),
      tax_amount: String(detail.tax_amount),
      total_amount: String(detail.total_amount),
      cogs_amount: String(detail.cogs_amount),
      lines,
      tenders,
      returns: [],
      journal_entry_id: detail.journal_entry_id,
      journal_number: detail.journal_number,
      row_version: detail.row_version,
      created_at: detail.created_at,
    };
  }

  toListItem(row: CounterSaleListRow): CounterSaleListItemDto {
    const sale = this.toDto({ ...row, lines: [], tenders: [] });
    return {
      id: sale.id,
      sale_number: sale.sale_number,
      sale_date: sale.sale_date,
      member_id: sale.member_id,
      member_name: sale.member_name,
      customer_name: sale.customer_name,
      status: sale.status,
      subtotal: sale.subtotal,
      discount_amount: sale.discount_amount,
      tax_amount: sale.tax_amount,
      total_amount: sale.total_amount,
      cogs_amount: sale.cogs_amount,
      journal_entry_id: sale.journal_entry_id,
      journal_number: sale.journal_number,
      row_version: sale.row_version,
      created_at: sale.created_at,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<CounterSaleListItemDto>> {
    const filters = counterSaleFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.salesRepository.findMany({
      from: filters.from,
      to: filters.to,
      memberId: filters.member_id,
      itemId: filters.item_id,
      search: filters.search,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((row) => this.toListItem(row)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<CounterSaleDto> {
    const detail = await this.salesRepository.findDetail(id);
    if (!detail) {
      throw new NotFoundError(`Counter sale ${id} was not found`);
    }
    return this.toDto(detail);
  }

  async create(dto: SaleWrite, actor?: AuthenticatedUser): Promise<CounterSaleDto> {
    const saleDate = dto.sale_date ?? new Date().toISOString().slice(0, 10);
    const memberId = dto.member_id ?? null;
    if (memberId != null) {
      const member = await this.salesRepository.findMember(memberId);
      if (!member) {
        throw new NotFoundError(`Member ${memberId} was not found`);
      }
    }

    const preparedLines = await this.prepareLines(dto);
    const preparedTenders = await this.prepareTenders(dto);
    const subtotal = preparedLines.reduce((sum, line) => addMoney(sum, line.gross), '0.00');
    const discountAmount = preparedLines.reduce(
      (sum, line) => addMoney(sum, line.discount_amount),
      '0.00',
    );
    const taxAmount = preparedLines.reduce((sum, line) => addMoney(sum, line.tax_amount), '0.00');
    const totalAmount = addMoney(subMoney(subtotal, discountAmount), taxAmount);
    const received = preparedTenders.reduce((sum, tender) => addMoney(sum, tender.amount), '0.00');
    if (cmpMoney(received, totalAmount) !== 0) {
      throw new BusinessRuleError('Tender total does not match the sale total', [
        { rule: 'tender_total_mismatch', expected: totalAmount, received },
      ]);
    }

    return runInTransaction(this.db, async () => {
      const saleNumber = await this.salesRepository.allocateSaleNumber();
      const now = new Date();
      const saleId = await this.salesRepository.insertSale(
        {
          sale_number: saleNumber,
          sale_date: saleDate,
          member_id: memberId,
          customer_name: dto.customer_name ?? null,
          subtotal,
          discount_amount: discountAmount,
          tax_amount: taxAmount,
          total_amount: totalAmount,
          cogs_amount: '0.00',
          status: 'posted',
          journal_entry_id: null,
          row_version: 1,
          created_at: now,
          updated_at: null,
        },
        preparedLines.map((line) => ({
          item_id: line.item_id,
          quantity: line.quantity,
          rate: line.rate,
          discount_amount: line.discount_amount,
          tax_code_id: line.tax_code_id,
          net_amount: line.net_amount,
          tax_amount: line.tax_amount,
          unit_cost: null,
          cost_amount: null,
        })),
        preparedTenders.map((tender) => ({
          payment_method_id: tender.payment_method_id,
          amount: tender.amount,
          reference: tender.reference,
        })),
      );

      const insertedLines = await this.salesRepository.listLineIds(saleId);
      if (insertedLines.length !== preparedLines.length) {
        throw new Error(`Counter sale ${saleId} line count mismatch after insert`);
      }

      let cogsAmount = '0.00';
      for (let i = 0; i < preparedLines.length; i++) {
        const line = preparedLines[i]!;
        const inserted = insertedLines[i]!;
        line.source_line_id = inserted.id;
        if (!line.inventory_tracked) continue;

        if (line.cogs_account_id == null || line.inventory_account_id == null) {
          throw new BusinessRuleError(
            `Tracked item ${line.item_id} is missing COGS or inventory account`,
            [{ rule: 'tracked_item_accounts_missing', item_id: line.item_id }],
          );
        }

        const issued = await this.stockService.issue(line.item_id, line.quantity, {
          sourceType: 'counter_sale',
          sourceId: saleId,
          sourceLineId: inserted.id,
          movementDate: saleDate,
        });
        line.unit_cost = issued.unitCost;
        line.cost_amount = issued.value;
        cogsAmount = addMoney(cogsAmount, issued.value);
        await this.salesRepository.updateLineCosts(inserted.id, issued.unitCost, issued.value);
      }

      if (cmpMoney(cogsAmount, '0.00') !== 0) {
        await this.salesRepository.updateCogsAmount(saleId, cogsAmount);
      }

      const journalLines = await this.buildJournalLines(
        preparedLines,
        preparedTenders,
        saleNumber,
        memberId,
      );
      const journal = await this.postingService.postJournal({
        entryDate: saleDate,
        sourceType: 'counter_sale',
        sourceId: saleId,
        memo: `Counter sale ${saleNumber}`,
        postedByUserId: actor?.id ?? null,
        lines: journalLines,
      });
      await this.salesRepository.attachJournal(saleId, journal.id);

      const detail = await this.salesRepository.findDetail(saleId);
      if (!detail) {
        throw new NotFoundError(`Counter sale ${saleId} was not found`);
      }
      return this.toDto(detail);
    });
  }

  private async prepareLines(dto: SaleWrite): Promise<PreparedLine[]> {
    const itemsById = new Map<number, InventoryItemRow>();
    const taxById = new Map<number, TaxCode>();
    const lines: PreparedLine[] = [];

    for (const line of dto.lines) {
      let item = itemsById.get(line.item_id);
      if (!item) {
        const loaded = await this.itemsRepository.findReadById(line.item_id);
        if (!loaded) {
          throw new NotFoundError(`Item ${line.item_id} was not found`);
        }
        if (!loaded.is_active) {
          throw new BusinessRuleError(`Item ${line.item_id} is inactive`, [
            { rule: 'item_inactive', item_id: line.item_id },
          ]);
        }
        item = loaded;
        itemsById.set(line.item_id, item);
      }

      if (quantityScale(line.quantity) > item.uom_decimal_places) {
        throw new BusinessRuleError(
          `Quantity for item ${item.id} has more decimals than ${item.uom_code} allows`,
          [
            {
              rule: 'uom_decimals_exceeded',
              item_id: item.id,
              uom_code: item.uom_code,
              decimal_places: item.uom_decimal_places,
            },
          ],
        );
      }

      const rate = line.rate ?? item.sale_rate;
      if (rate == null) {
        throw new BusinessRuleError(`Item ${item.id} has no sale rate`);
      }
      const discount = line.discount_amount ?? '0.00';
      const gross = mulQtyRate(line.quantity, rate);
      if (cmpMoney(discount, gross) > 0) {
        throw new BusinessRuleError('Discount cannot exceed the line gross', [
          { item_id: item.id, gross, discount_amount: discount },
        ]);
      }
      const net = subMoney(gross, discount);

      const taxCodeId = line.tax_code_id ?? item.tax_code_id ?? null;
      let taxAmount = '0.00';
      if (taxCodeId != null) {
        let taxCode = taxById.get(taxCodeId);
        if (!taxCode) {
          const loaded = await this.taxCodesRepository.findById(taxCodeId);
          if (!loaded) {
            throw new NotFoundError(`Tax code ${taxCodeId} was not found`);
          }
          if (!loaded.is_active) {
            throw new BusinessRuleError(`Tax code ${loaded.code} is inactive`);
          }
          taxCode = loaded;
          taxById.set(taxCodeId, taxCode);
        }
        taxAmount = mulMoneyPercent(net, taxCode.rate_percent);
      }

      lines.push({
        item_id: item.id,
        item_name: item.name,
        quantity: formatQuantity(line.quantity),
        rate: String(rate),
        discount_amount: discount,
        tax_code_id: taxCodeId,
        income_account_id: item.income_account_id,
        inventory_tracked: Boolean(item.inventory_tracked),
        inventory_account_id: item.inventory_account_id ?? null,
        cogs_account_id: item.cogs_account_id ?? null,
        gross,
        net_amount: net,
        tax_amount: taxAmount,
        unit_cost: null,
        cost_amount: null,
        source_line_id: null,
      });
    }

    return lines;
  }

  private async prepareTenders(dto: SaleWrite): Promise<PreparedTender[]> {
    const methods = new Map<number, SalePaymentMethodRow>();
    const tenders: PreparedTender[] = [];
    for (const tender of dto.tenders) {
      let method = methods.get(tender.payment_method_id);
      if (!method) {
        const loaded = await this.salesRepository.findPaymentMethod(tender.payment_method_id);
        if (!loaded) {
          throw new NotFoundError(`Payment method ${tender.payment_method_id} was not found`);
        }
        if (!loaded.is_active) {
          throw new BusinessRuleError(`Payment method ${tender.payment_method_id} is inactive`);
        }
        method = loaded;
        methods.set(tender.payment_method_id, method);
      }
      if (method.account_id == null) {
        throw new BusinessRuleError(`Payment method ${method.id} has no ledger account`, [
          { rule: 'payment_method_unmapped', payment_method_id: method.id },
        ]);
      }
      tenders.push({
        payment_method_id: method.id,
        payment_method_name: method.method_name,
        account_id: method.account_id,
        amount: tender.amount,
        reference: tender.reference ?? null,
      });
    }
    return tenders;
  }

  private async buildJournalLines(
    lines: PreparedLine[],
    tenders: PreparedTender[],
    saleNumber: string,
    memberId: number | null,
  ): Promise<PostJournalLineInput[]> {
    const journalLines: PostJournalLineInput[] = [];
    for (const tender of tenders) {
      journalLines.push({
        accountId: tender.account_id,
        debit: tender.amount,
        memo: `${tender.payment_method_name} ${saleNumber}`,
      });
    }
    const party = memberId != null ? { memberId } : {};
    for (const line of lines) {
      if (cmpMoney(line.net_amount, '0') > 0) {
        journalLines.push({
          accountId: line.income_account_id,
          credit: line.net_amount,
          memo: line.item_name,
          ...party,
        });
      }
      const taxLines = await buildTaxComponentLines(
        {
          taxCodesRepository: this.taxCodesRepository,
          accountsRepository: this.accountsRepository,
        },
        {
          taxCode: line.tax_code_id != null ? { id: line.tax_code_id } : null,
          taxAmount: line.tax_amount,
          side: 'credit',
          memoPrefix: `Output tax ${saleNumber}`,
          accountKind: 'output',
          ...party,
        },
      );
      journalLines.push(...taxLines);

      if (
        line.inventory_tracked &&
        line.cost_amount != null &&
        cmpMoney(line.cost_amount, '0.00') > 0 &&
        line.cogs_account_id != null &&
        line.inventory_account_id != null
      ) {
        journalLines.push({
          accountId: line.cogs_account_id,
          debit: line.cost_amount,
          memo: `COGS ${line.item_name}`,
        });
        journalLines.push({
          accountId: line.inventory_account_id,
          credit: line.cost_amount,
          memo: `Inventory out ${line.item_name}`,
        });
      }
    }
    return journalLines;
  }
}
