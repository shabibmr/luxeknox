import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { TaxCode } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { toCents } from '../platform/money/money';
import type { AccountingPostingService, PostJournalLineInput } from '../acct/accounting-posting.service';
import type { AccountsRepository } from '../acct/accounts.repository';
import type { TaxCodesRepository } from '../acct/tax-codes.repository';
import { saleWriteSchema, type SaleWrite } from './counter-sales.dto';
import type { CounterSalesRepository, CounterSaleDetail } from './counter-sales.repository';
import { CounterSalesService } from './counter-sales.service';
import type { InventoryItemRow, InventoryItemsRepository } from './items.repository';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => {
    insideTransaction = true;
    try {
      return await fn();
    } finally {
      insideTransaction = false;
    }
  },
}));

let insideTransaction = false;

const ACTOR: AuthenticatedUser = {
  id: 7,
  email: 'cashier@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const ITEM: InventoryItemRow = {
  id: 10,
  name: 'Whey Protein',
  sku: 'WHEY-1',
  hsn_sac: null,
  item_kind: 'goods',
  category_id: null,
  category_name: null,
  uom_id: 1,
  uom_code: 'PCS',
  uom_decimal_places: 0,
  sale_rate: '100.00',
  purchase_rate: null,
  tax_code_id: 3,
  income_account_id: 4250,
  expense_account_id: 5000,
  inventory_account_id: 1400,
  cogs_account_id: 5050,
  inventory_tracked: false,
  reorder_level: null,
  is_active: true,
  row_version: 1,
  created_at: new Date('2026-10-16T00:00:00.000Z'),
  updated_at: null,
};

const GST: TaxCode = {
  id: 3,
  name: 'GST 18',
  code: 'GST18',
  rate_percent: '18.00',
  is_active: true,
};

function detailFor(id: number): CounterSaleDetail {
  return {
    id,
    sale_number: 'SAL-00000001',
    sale_date: '2026-10-16',
    member_id: null,
    member_first_name: null,
    member_last_name: null,
    customer_name: 'Walk-in',
    status: 'posted',
    subtotal: '200.00',
    discount_amount: '0.00',
    tax_amount: '36.00',
    total_amount: '236.00',
    cogs_amount: '0.00',
    journal_entry_id: 77,
    journal_number: 'JRN00000077',
    row_version: 1,
    created_at: new Date('2026-10-16T08:00:00.000Z'),
    lines: [
      {
        id: 1,
        item_id: 10,
        item_name: 'Whey Protein',
        uom_code: 'PCS',
        quantity: '2.000',
        rate: '100.00',
        discount_amount: '0.00',
        tax_code_id: 3,
        net_amount: '200.00',
        tax_amount: '36.00',
        unit_cost: null,
        cost_amount: null,
      },
    ],
    tenders: [
      {
        id: 1,
        payment_method_id: 1,
        payment_method_name: 'Cash',
        amount: '100.00',
        reference: null,
      },
      {
        id: 2,
        payment_method_id: 2,
        payment_method_name: 'UPI',
        amount: '136.00',
        reference: 'UPI-1',
      },
    ],
  };
}

function sideTotals(lines: PostJournalLineInput[]): { debit: bigint; credit: bigint } {
  let debit = 0n;
  let credit = 0n;
  for (const line of lines) {
    if (line.debit != null) debit += toCents(line.debit);
    if (line.credit != null) credit += toCents(line.credit);
  }
  return { debit, credit };
}

describe('CounterSalesService', () => {
  let salesRepository: {
    findMember: ReturnType<typeof vi.fn>;
    findPaymentMethod: ReturnType<typeof vi.fn>;
    allocateSaleNumber: ReturnType<typeof vi.fn>;
    insertSale: ReturnType<typeof vi.fn>;
    attachJournal: ReturnType<typeof vi.fn>;
    findDetail: ReturnType<typeof vi.fn>;
  };
  let itemsRepository: { findReadById: ReturnType<typeof vi.fn> };
  let taxCodesRepository: {
    findById: ReturnType<typeof vi.fn>;
    listComponents: ReturnType<typeof vi.fn>;
  };
  let accountsRepository: { findByCode: ReturnType<typeof vi.fn> };
  let postingService: { postJournal: ReturnType<typeof vi.fn> };
  let service: CounterSalesService;

  const splitSale: SaleWrite = {
    sale_date: '2026-10-16',
    customer_name: 'Walk-in',
    member_id: null,
    lines: [{ item_id: 10, quantity: '2' }],
    tenders: [
      { payment_method_id: 1, amount: '100.00', reference: null },
      { payment_method_id: 2, amount: '136.00', reference: 'UPI-1' },
    ],
  };

  beforeEach(() => {
    insideTransaction = false;
    salesRepository = {
      findMember: vi.fn(),
      findPaymentMethod: vi.fn().mockImplementation(async (id: number) => ({
        id,
        method_name: id === 1 ? 'Cash' : 'UPI',
        is_active: true,
        account_id: id === 1 ? 1000 : 1010,
      })),
      allocateSaleNumber: vi.fn().mockResolvedValue('SAL-00000001'),
      insertSale: vi.fn().mockResolvedValue(50),
      attachJournal: vi.fn().mockResolvedValue(undefined),
      findDetail: vi.fn().mockImplementation(async (id: number) => detailFor(id)),
    };
    itemsRepository = { findReadById: vi.fn().mockResolvedValue(ITEM) };
    taxCodesRepository = {
      findById: vi.fn().mockResolvedValue(GST),
      listComponents: vi.fn().mockResolvedValue([
        { name: 'CGST', rate_percent: '9.00', output_account_id: 2101, input_account_id: 1301 },
        { name: 'SGST', rate_percent: '9.00', output_account_id: 2102, input_account_id: 1302 },
      ]),
    };
    accountsRepository = { findByCode: vi.fn() };
    postingService = {
      postJournal: vi.fn().mockImplementation(async () => {
        expect(insideTransaction).toBe(true);
        return { id: 77, journal_number: 'JRN00000077', lines: [] };
      }),
    };
    service = new CounterSalesService(
      salesRepository as unknown as CounterSalesRepository,
      itemsRepository as unknown as InventoryItemsRepository,
      taxCodesRepository as unknown as TaxCodesRepository,
      accountsRepository as unknown as AccountsRepository,
      postingService as unknown as AccountingPostingService,
      {} as never,
    );
  });

  it('posts a balanced journal in the same transaction and numbers the sale SAL-…', async () => {
    const sale = await service.create(splitSale, ACTOR);

    expect(sale.sale_number).toBe('SAL-00000001');
    expect(sale.journal_entry_id).toBe(77);
    expect(sale.journal_number).toBe('JRN00000077');
    expect(sale.cogs_amount).toBe('0.00');
    expect(sale.returns).toEqual([]);
    expect(sale.lines[0]?.returned_quantity).toBe('0.000');
    expect(sale.lines[0]?.unit_cost).toBeNull();
    expect(salesRepository.allocateSaleNumber).toHaveBeenCalledOnce();
    expect(insideTransaction).toBe(false);

    const header = salesRepository.insertSale.mock.calls[0][0];
    const lines = salesRepository.insertSale.mock.calls[0][1];
    expect(header).toMatchObject({
      sale_number: 'SAL-00000001',
      subtotal: '200.00',
      discount_amount: '0.00',
      tax_amount: '36.00',
      total_amount: '236.00',
      cogs_amount: '0.00',
      status: 'posted',
    });
    expect(lines[0]).toMatchObject({
      quantity: '2.000',
      rate: '100.00',
      net_amount: '200.00',
      tax_amount: '36.00',
      unit_cost: null,
      cost_amount: null,
    });

    expect(postingService.postJournal).toHaveBeenCalledOnce();
    const posted = postingService.postJournal.mock.calls[0][0];
    expect(posted).toMatchObject({
      entryDate: '2026-10-16',
      sourceType: 'counter_sale',
      sourceId: 50,
      postedByUserId: 7,
    });
    const totals = sideTotals(posted.lines);
    expect(totals.debit).toBe(totals.credit);
    expect(totals.debit).toBe(toCents('236.00'));
    expect(posted.lines).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ accountId: 1000, debit: '100.00' }),
        expect.objectContaining({ accountId: 1010, debit: '136.00' }),
        expect.objectContaining({ accountId: 4250, credit: '200.00' }),
        expect.objectContaining({ accountId: 2101, credit: '18.00' }),
        expect.objectContaining({ accountId: 2102, credit: '18.00' }),
      ]),
    );
    expect(posted.lines.some((line: PostJournalLineInput) => line.accountId === 5050)).toBe(false);
    expect(salesRepository.attachJournal).toHaveBeenCalledWith(50, 77);
  });

  it('refuses a tender mismatch with 422 and does not post', async () => {
    const dto: SaleWrite = {
      ...splitSale,
      tenders: [{ payment_method_id: 1, amount: '200.00', reference: null }],
    };
    await expect(service.create(dto, ACTOR)).rejects.toMatchObject({
      status: 422,
      details: [{ rule: 'tender_total_mismatch', expected: '236.00', received: '200.00' }],
    });
    expect(postingService.postJournal).not.toHaveBeenCalled();
    expect(salesRepository.insertSale).not.toHaveBeenCalled();
    try {
      await service.create(dto, ACTOR);
    } catch (error) {
      expect(error).toBeInstanceOf(BusinessRuleError);
    }
  });

  it('defaults rate and tax code from the item', async () => {
    await service.create(splitSale, ACTOR);
    expect(itemsRepository.findReadById).toHaveBeenCalledWith(10);
    expect(taxCodesRepository.findById).toHaveBeenCalledWith(3);
    expect(salesRepository.insertSale.mock.calls[0][1][0]).toMatchObject({
      rate: '100.00',
      tax_code_id: 3,
    });
  });

  it('rejects an inactive item and an unmapped payment method', async () => {
    itemsRepository.findReadById.mockResolvedValue({ ...ITEM, is_active: false });
    await expect(service.create(splitSale, ACTOR)).rejects.toBeInstanceOf(BusinessRuleError);
    await expect(service.create(splitSale, ACTOR)).rejects.toMatchObject({
      details: [{ rule: 'item_inactive', item_id: 10 }],
    });

    itemsRepository.findReadById.mockResolvedValue(ITEM);
    salesRepository.findPaymentMethod.mockResolvedValue({
      id: 1,
      method_name: 'Cash',
      is_active: true,
      account_id: null,
    });
    const single: SaleWrite = {
      ...splitSale,
      tenders: [{ payment_method_id: 1, amount: '236.00', reference: null }],
    };
    await expect(service.create(single, ACTOR)).rejects.toMatchObject({
      details: [{ rule: 'payment_method_unmapped', payment_method_id: 1 }],
    });
    expect(postingService.postJournal).not.toHaveBeenCalled();
  });

  it('rejects a quantity finer than the UOM', async () => {
    const dto: SaleWrite = {
      ...splitSale,
      lines: [{ item_id: 10, quantity: '1.500' }],
      tenders: [{ payment_method_id: 1, amount: '1.00', reference: null }],
    };
    await expect(service.create(dto, ACTOR)).rejects.toMatchObject({
      details: [{ rule: 'uom_decimals_exceeded', item_id: 10, uom_code: 'PCS', decimal_places: 0 }],
    });
  });

  it('returns 404 for an unknown item', async () => {
    itemsRepository.findReadById.mockResolvedValue(null);
    await expect(service.create(splitSale, ACTOR)).rejects.toBeInstanceOf(NotFoundError);
  });
});

describe('saleWriteSchema', () => {
  it('rejects client totals and an empty sale', () => {
    expect(
      saleWriteSchema.safeParse({
        lines: [{ item_id: 1, quantity: '1', net_amount: '10.00' }],
        tenders: [{ payment_method_id: 1, amount: '10.00' }],
      }).success,
    ).toBe(false);
    expect(saleWriteSchema.safeParse({ lines: [], tenders: [] }).success).toBe(false);
  });

  it('accepts a body without rate, tax, or sale date', () => {
    const parsed = saleWriteSchema.parse({
      lines: [{ item_id: 10, quantity: 2 }],
      tenders: [{ payment_method_id: 1, amount: '236' }],
    });
    expect(parsed.sale_date).toBeUndefined();
    expect(parsed.lines[0]?.rate).toBeUndefined();
    expect(parsed.lines[0]?.quantity).toBe('2');
    expect(parsed.tenders[0]?.amount).toBe('236.00');
  });
});
