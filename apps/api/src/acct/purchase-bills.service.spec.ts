import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Account, Item, PurchaseBill, PurchaseBillLine, TaxCode, Vendor } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import type { ItemsRepository } from './items.repository';
import type { PurchaseBillWithLines, PurchaseBillsRepository } from './purchase-bills.repository';
import { PurchaseBillsService } from './purchase-bills.service';
import type { TaxCodesRepository } from './tax-codes.repository';
import type { VendorsRepository } from './vendors.repository';
import type { StockService } from '../inv/stock.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const CURRENT_USER: AuthenticatedUser = {
  id: 42,
  email: 'purchasing@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const VENDOR_ACTIVE: Vendor = {
  id: 10,
  name: 'Acme Gym Equipment Ltd',
  phone: '1234567890',
  email: 'sales@acme.test',
  gstin: '29ABCDE1234F1Z5',
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const VENDOR_INACTIVE: Vendor = {
  ...VENDOR_ACTIVE,
  id: 11,
  is_active: false,
};

const EXPENSE_ACCOUNT: Account = {
  id: 5010,
  name: 'Equipment Maintenance',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const CONTROL_ACCOUNT: Account = {
  id: 2000,
  name: 'Accounts Payable',
  account_type: 'liability',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'ap',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INPUT_TAX_ACCOUNT: Account = {
  id: 1300,
  name: 'Input Tax Receivable',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'input_tax',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INACTIVE_ACCOUNT: Account = {
  id: 5099,
  name: 'Old Repairs Account',
  account_type: 'expense',
  parent_id: null,
  is_active: false,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const TAX_CODE_GST18: TaxCode = {
  id: 1,
  code: 'gst_18',
  name: 'GST 18%',
  rate_percent: '18.00',
  is_active: true,
};

const TAX_CODE_INACTIVE: TaxCode = {
  ...TAX_CODE_GST18,
  id: 2,
  code: 'gst_old',
  is_active: false,
};

const INVENTORY_ACCOUNT: Account = {
  id: 1400,
  name: 'Inventory',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'inventory',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const UOM_PCS = {
  id: 1,
  code: 'PCS',
  name: 'Piece',
  decimal_places: 0,
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const UOM_KG = {
  id: 2,
  code: 'KG',
  name: 'Kilogram',
  decimal_places: 3,
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const ITEM_ACTIVE: Item = {
  id: 101,
  name: 'Treadmill Belt Replacement',
  sku: null,
  hsn_sac: null,
  item_kind: 'goods',
  category_id: null,
  uom_id: UOM_PCS.id,
  inventory_tracked: false,
  sale_rate: '100.00',
  purchase_rate: '80.00',
  reorder_level: null,
  income_account_id: 4000,
  expense_account_id: 5010,
  inventory_account_id: null,
  cogs_account_id: null,
  tax_code_id: 1,
  is_active: true,
  row_version: 1,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const ITEM_TRACKED: Item = {
  ...ITEM_ACTIVE,
  id: 103,
  name: 'Whey Protein 1kg',
  uom_id: UOM_KG.id,
  inventory_tracked: true,
  purchase_rate: '110.00',
  inventory_account_id: INVENTORY_ACCOUNT.id,
  cogs_account_id: 5050,
};

const ITEM_INACTIVE: Item = {
  ...ITEM_ACTIVE,
  id: 102,
  is_active: false,
};

describe('PurchaseBillsService', () => {
  let service: PurchaseBillsService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let accountingPostingService: { postJournal: ReturnType<typeof vi.fn> };
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let vendorsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let itemsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let taxCodesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let stockService: { receive: ReturnType<typeof vi.fn>; issue: ReturnType<typeof vi.fn> };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  const db = {} as any;

  beforeEach(() => {
    repository = {
      allocateBillNumber: vi.fn().mockResolvedValue('BIL00000001'),
      findWithLines: vi.fn(),
      listLines: vi.fn(),
      insertBill: vi.fn(),
      updateBill: vi.fn(),
      replaceLines: vi.fn(),
      findMany: vi.fn(),
      findByVendorSupplierInvoice: vi.fn().mockResolvedValue(null),
    };

    accountingPostingService = {
      postJournal: vi.fn().mockResolvedValue({
        id: 777,
        journal_number: 'JRN00000777',
        lines: [],
      }),
    };

    accountsRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === EXPENSE_ACCOUNT.id) return EXPENSE_ACCOUNT;
        if (id === CONTROL_ACCOUNT.id) return CONTROL_ACCOUNT;
        if (id === INPUT_TAX_ACCOUNT.id) return INPUT_TAX_ACCOUNT;
        if (id === INACTIVE_ACCOUNT.id) return INACTIVE_ACCOUNT;
        if (id === INVENTORY_ACCOUNT.id) return INVENTORY_ACCOUNT;
        return null;
      }),
      findByControlRole: vi.fn().mockImplementation(async (role: string) => {
        if (role === 'ap') return CONTROL_ACCOUNT;
        if (role === 'input_tax') return INPUT_TAX_ACCOUNT;
        return null;
      }),
    };

    vendorsRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === VENDOR_ACTIVE.id) return VENDOR_ACTIVE;
        if (id === VENDOR_INACTIVE.id) return VENDOR_INACTIVE;
        return null;
      }),
    };

    itemsRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === ITEM_ACTIVE.id) return ITEM_ACTIVE;
        if (id === ITEM_INACTIVE.id) return ITEM_INACTIVE;
        if (id === ITEM_TRACKED.id) return ITEM_TRACKED;
        return null;
      }),
      findUomById: vi.fn().mockImplementation(async (id: number) => {
        if (id === UOM_PCS.id) return UOM_PCS;
        if (id === UOM_KG.id) return UOM_KG;
        return null;
      }),
    };

    taxCodesRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === TAX_CODE_GST18.id) return TAX_CODE_GST18;
        if (id === TAX_CODE_INACTIVE.id) return TAX_CODE_INACTIVE;
        return null;
      }),
    };

    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };

    stockService = {
      receive: vi.fn().mockResolvedValue({
        qtyOnHand: '10.000',
        stockValue: '1000.00',
        avgCost: '100.0000',
        unitCost: '100.0000',
        value: '1000.00',
      }),
      issue: vi.fn(),
    };

    service = new PurchaseBillsService(
      repository as unknown as PurchaseBillsRepository,
      accountingPostingService as unknown as AccountingPostingService,
      accountsRepository as unknown as AccountsRepository,
      vendorsRepository as unknown as VendorsRepository,
      itemsRepository as unknown as ItemsRepository,
      taxCodesRepository as unknown as TaxCodesRepository,
      stockService as unknown as StockService,
      db,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('create (Task ACC-040)', () => {
    it('creates the bill with calculated amounts and posts it in the same call', async () => {
      const insertedBill: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: '2026-05-15',
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 10,
            purchase_bill_id: 1,
            item_id: ITEM_ACTIVE.id,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Belt replacement',
            quantity: '2.000',
            rate: '100.00',
            tax_code_id: TAX_CODE_GST18.id,
            net_amount: '200.00',
            tax_amount: '36.00',
            item_name: null,
            uom_code: null,
            inventory_tracked: false,
          },
        ],
      };

      repository.insertBill.mockResolvedValue(insertedBill);
      const postSpy = vi.spyOn(service, 'post').mockResolvedValue(
        service.toDtoWithLines({ ...insertedBill, status: 'posted', journal_entry_id: 100, row_version: 2 }),
      );

      const result = await service.create(
        {
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          supplier_invoice_no: null,
          due_date: '2026-05-15',
          lines: [
            {
              item_id: ITEM_ACTIVE.id,
              account_id: EXPENSE_ACCOUNT.id,
              description: 'Belt replacement',
              quantity: '2.00',
              rate: '100.00',
              tax_code_id: TAX_CODE_GST18.id,
            },
          ],
        },
        CURRENT_USER,
      );

      expect(repository.allocateBillNumber).toHaveBeenCalled();
      expect(repository.insertBill).toHaveBeenCalledWith(
        expect.objectContaining({
          bill_number: 'BIL00000001',
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          due_date: '2026-05-15',
          supplier_invoice_no: null,
          status: 'draft',
          subtotal: '200.00',
          tax_amount: '36.00',
          total_amount: '236.00',
        }),
        [
          expect.objectContaining({
            item_id: ITEM_ACTIVE.id,
            account_id: EXPENSE_ACCOUNT.id,
            quantity: '2.000',
            rate: '100.00',
            net_amount: '200.00',
            tax_amount: '36.00',
          }),
        ],
      );

      expect(postSpy).toHaveBeenCalledWith(1, CURRENT_USER);
      expect(result.id).toBe(1);
      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(100);
      expect(result.subtotal).toBe('200.00');
      expect(result.tax_amount).toBe('36.00');
      expect(result.total_amount).toBe('236.00');
      expect(result.lines).toHaveLength(1);
    });

    it('saves a draft without posting when draft is true', async () => {
      const draftBill: PurchaseBillWithLines = {
        id: 2,
        bill_number: 'BIL00000002',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 20,
            purchase_bill_id: 2,
            item_id: null,
            account_id: EXPENSE_ACCOUNT.id,
            description: null,
            quantity: '1.000',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '100.00',
            tax_amount: '0.00',
            item_name: null,
            uom_code: null,
            inventory_tracked: false,
          },
        ],
      };
      repository.insertBill.mockResolvedValue(draftBill);
      repository.findWithLines.mockResolvedValue(draftBill);
      const postSpy = vi.spyOn(service, 'post');

      const result = await service.create(
        {
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          supplier_invoice_no: null,
          draft: true,
          lines: [{ account_id: EXPENSE_ACCOUNT.id, quantity: '1', rate: '100.00' }],
        },
        CURRENT_USER,
      );

      expect(postSpy).not.toHaveBeenCalled();
      expect(result.status).toBe('draft');
      expect(result.journal_entry_id).toBeNull();
    });

    it('propagates a post failure so the surrounding transaction rolls back the insert', async () => {
      repository.insertBill.mockImplementation(async (header, lines) => ({
        id: 7,
        ...header,
        lines: lines.map((line: any, i: number) => ({ id: i + 1, purchase_bill_id: 7, ...line })),
      }));
      vi.spyOn(service, 'post').mockRejectedValue(new BusinessRuleError('Period is locked'));

      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [{ account_id: EXPENSE_ACCOUNT.id, quantity: '1.00', rate: '10.00' }],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow('Period is locked');
    });

    it('rejects creation if vendor is inactive', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_INACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('rejects creation if vendor does not exist', async () => {
      await expect(
        service.create(
          {
            vendor_id: 9999,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(NotFoundError);
    });

    it('rejects creation if item is inactive', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                item_id: ITEM_INACTIVE.id,
                account_id: EXPENSE_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('rejects creation if line account is inactive', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                account_id: INACTIVE_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('rejects creation if line account is a control account', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                account_id: CONTROL_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('rejects creation if tax code is inactive', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                quantity: '1.00',
                rate: '50.00',
                tax_code_id: TAX_CODE_INACTIVE.id,
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('post (Task ACC-040)', () => {
    it('posts a draft purchase bill creating DR line accounts, DR input tax, and CR accounts payable', async () => {
      const bill: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 10,
            purchase_bill_id: 1,
            item_id: ITEM_ACTIVE.id,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Maintenance services',
            quantity: '1.00',
            rate: '100.00',
            tax_code_id: TAX_CODE_GST18.id,
            net_amount: '100.00',
            tax_amount: '18.00',
            item_name: null,
            uom_code: null,
            inventory_tracked: false,
          },
        ],
      };

      const postedBill: PurchaseBillWithLines = {
        ...bill,
        status: 'posted',
        journal_entry_id: 777,
        row_version: 2,
      };

      repository.findWithLines
        .mockResolvedValueOnce(bill)
        .mockResolvedValueOnce(postedBill);

      const result = await service.post(1, CURRENT_USER);

      expect(accountingPostingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-15',
        sourceType: 'purchase_bill',
        sourceId: 1,
        memo: 'Purchase bill BIL00000001',
        postedByUserId: CURRENT_USER.id,
        lines: [
          {
            accountId: EXPENSE_ACCOUNT.id,
            debit: '100.00',
            credit: '0.00',
            memo: 'Maintenance services',
            vendorId: VENDOR_ACTIVE.id,
          },
          {
            accountId: INPUT_TAX_ACCOUNT.id,
            debit: '18.00',
            credit: '0.00',
            memo: 'Input tax for bill BIL00000001',
            vendorId: VENDOR_ACTIVE.id,
          },
          {
            accountId: CONTROL_ACCOUNT.id,
            debit: '0.00',
            credit: '118.00',
            memo: 'Purchase bill BIL00000001',
            vendorId: VENDOR_ACTIVE.id,
          },
        ],
      });

      expect(repository.updateBill).toHaveBeenCalledWith(
        1,
        expect.objectContaining({
          status: 'posted',
          journal_entry_id: 777,
          row_version: 2,
        }),
      );

      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(777);
      expect(stockService.receive).not.toHaveBeenCalled();
    });

    it('returns idempotently if bill is already posted', async () => {
      const postedBill: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'posted',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: 777,
        row_version: 2,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [],
      };

      repository.findWithLines.mockResolvedValue(postedBill);

      const result = await service.post(1, CURRENT_USER);

      expect(accountingPostingService.postJournal).not.toHaveBeenCalled();
      expect(repository.updateBill).not.toHaveBeenCalled();
      expect(stockService.receive).not.toHaveBeenCalled();
      expect(result.status).toBe('posted');
    });

    it('rejects posting if bill status is void', async () => {
      const voidBill: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'void',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 2,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [],
      };

      repository.findWithLines.mockResolvedValue(voidBill);

      await expect(service.post(1, CURRENT_USER)).rejects.toThrow(
        'Void purchase bills cannot be posted',
      );
    });

    it('rejects posting if bill has no lines', async () => {
      const billNoLines: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [],
      };

      repository.findWithLines.mockResolvedValue(billNoLines);

      await expect(service.post(1, CURRENT_USER)).rejects.toThrow(
        'Purchase bill has no lines to post',
      );
    });
  });

  describe('getById and list', () => {
    it('getById returns bill with lines', async () => {
      const bill: PurchaseBillWithLines = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [],
      };

      repository.findWithLines.mockResolvedValue(bill);

      const result = await service.getById(1, CURRENT_USER);
      expect(result.id).toBe(1);
      expect(result.bill_number).toBe('BIL00000001');
    });

    it('getById throws NotFoundError if bill does not exist', async () => {
      repository.findWithLines.mockResolvedValue(null);

      await expect(service.getById(999, CURRENT_USER)).rejects.toThrow(NotFoundError);
    });

    it('list returns paginated response', async () => {
      const bill: PurchaseBill = {
        id: 1,
        bill_number: 'BIL00000001',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
      };

      repository.findMany.mockResolvedValue({ rows: [bill], total: 1 });

      const result = await service.list({}, CURRENT_USER);
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('IL-32 purchase write path', () => {
    beforeEach(() => {
      vi.spyOn(service, 'post').mockImplementation(async (id: number) => ({ id }) as any);
    });

    it('accepts a 3dp quantity on KG and uses mulQtyRate', async () => {
      repository.insertBill.mockImplementation(async (header, lines) => ({
        id: 1,
        ...header,
        lines: lines.map((line: any, i: number) => ({
          id: i + 1,
          purchase_bill_id: 1,
          ...line,
        })),
      }));

      await service.create(
        {
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          supplier_invoice_no: null,
          lines: [
            {
              item_id: ITEM_TRACKED.id,
              quantity: '1.250',
              rate: '100.00',
            },
          ],
        },
        CURRENT_USER,
      );

      expect(repository.insertBill).toHaveBeenCalledWith(
        expect.anything(),
        [
          expect.objectContaining({
            item_id: ITEM_TRACKED.id,
            account_id: INVENTORY_ACCOUNT.id,
            quantity: '1.250',
            rate: '100.00',
            net_amount: '125.00',
            description: ITEM_TRACKED.name,
            tax_code_id: TAX_CODE_GST18.id,
          }),
        ],
      );
    });

    it('refuses a fractional quantity on PCS (uom_decimals_exceeded)', async () => {
      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: null,
            lines: [
              {
                item_id: ITEM_ACTIVE.id,
                quantity: '1.5',
                rate: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        details: [
          expect.objectContaining({
            rule: 'uom_decimals_exceeded',
            uom_code: 'PCS',
            decimal_places: 0,
          }),
        ],
      });
    });

    it('ignores client account_id on a tracked line and uses inventory_account_id', async () => {
      repository.insertBill.mockImplementation(async (header, lines) => ({
        id: 2,
        ...header,
        lines: lines.map((line: any, i: number) => ({
          id: i + 1,
          purchase_bill_id: 2,
          ...line,
        })),
      }));

      await service.create(
        {
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          supplier_invoice_no: null,
          lines: [
            {
              item_id: ITEM_TRACKED.id,
              account_id: EXPENSE_ACCOUNT.id,
              quantity: '2',
              rate: '50.00',
              tax_code_id: null,
            },
          ],
        },
        CURRENT_USER,
      );

      expect(repository.insertBill).toHaveBeenCalledWith(
        expect.anything(),
        [expect.objectContaining({ account_id: INVENTORY_ACCOUNT.id })],
      );
    });

    it('defaults untracked item account_id to expense_account_id and applies item purchase_rate', async () => {
      repository.insertBill.mockImplementation(async (header, lines) => ({
        id: 3,
        ...header,
        lines: lines.map((line: any, i: number) => ({
          id: i + 1,
          purchase_bill_id: 3,
          ...line,
        })),
      }));

      await service.create(
        {
          vendor_id: VENDOR_ACTIVE.id,
          bill_date: '2026-04-15',
          supplier_invoice_no: null,
          lines: [{ item_id: ITEM_ACTIVE.id, quantity: '2' }],
        },
        CURRENT_USER,
      );

      expect(repository.insertBill).toHaveBeenCalledWith(
        expect.anything(),
        [
          expect.objectContaining({
            account_id: EXPENSE_ACCOUNT.id,
            rate: '80.00',
            net_amount: '160.00',
            description: ITEM_ACTIVE.name,
            tax_code_id: TAX_CODE_GST18.id,
          }),
        ],
      );
    });

    it('refuses a duplicate supplier_invoice_no for the same vendor among non-void bills', async () => {
      repository.findByVendorSupplierInvoice.mockResolvedValue({
        id: 99,
        bill_number: 'BIL00000099',
        vendor_id: VENDOR_ACTIVE.id,
        supplier_invoice_no: 'INV-1',
        status: 'posted',
      });

      await expect(
        service.create(
          {
            vendor_id: VENDOR_ACTIVE.id,
            bill_date: '2026-04-15',
            supplier_invoice_no: 'INV-1',
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                quantity: '1',
                rate: '10.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        details: [
          expect.objectContaining({
            rule: 'duplicate_supplier_invoice',
            supplier_invoice_no: 'INV-1',
            existing_bill_id: 99,
          }),
        ],
      });
    });
  });

  describe('IL-33 purchase post stock receive', () => {
    it('receives stock for tracked lines and debits inventory on the journal', async () => {
      const draft: PurchaseBillWithLines = {
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '1000.00',
        tax_amount: '0.00',
        total_amount: '1000.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 50,
            purchase_bill_id: 5,
            item_id: ITEM_TRACKED.id,
            account_id: INVENTORY_ACCOUNT.id,
            description: ITEM_TRACKED.name,
            quantity: '10.000',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '1000.00',
            tax_amount: '0.00',
            item_name: ITEM_TRACKED.name,
            uom_code: 'KG',
            inventory_tracked: true,
          },
        ],
      };
      const posted: PurchaseBillWithLines = {
        ...draft,
        status: 'posted',
        journal_entry_id: 777,
        row_version: 2,
      };
      repository.findWithLines.mockResolvedValueOnce(draft).mockResolvedValueOnce(posted);

      const result = await service.post(5, CURRENT_USER);

      expect(stockService.receive).toHaveBeenCalledWith(ITEM_TRACKED.id, '10.000', '1000.00', {
        sourceType: 'purchase_bill',
        sourceId: 5,
        sourceLineId: 50,
        movementDate: '2026-04-15',
      });
      expect(accountingPostingService.postJournal).toHaveBeenCalledWith(
        expect.objectContaining({
          lines: expect.arrayContaining([
            expect.objectContaining({
              accountId: INVENTORY_ACCOUNT.id,
              debit: '1000.00',
            }),
          ]),
        }),
      );
      expect(result.lines[0]).toMatchObject({
        item_name: ITEM_TRACKED.name,
        uom_code: 'KG',
        inventory_tracked: true,
        returned_quantity: '0.000',
      });
    });

    it('does not receive again when posting an already-posted bill', async () => {
      repository.findWithLines.mockResolvedValue({
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'posted',
        subtotal: '1000.00',
        tax_amount: '0.00',
        total_amount: '1000.00',
        journal_entry_id: 777,
        row_version: 2,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 50,
            purchase_bill_id: 5,
            item_id: ITEM_TRACKED.id,
            account_id: INVENTORY_ACCOUNT.id,
            description: ITEM_TRACKED.name,
            quantity: '10.000',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '1000.00',
            tax_amount: '0.00',
            item_name: ITEM_TRACKED.name,
            uom_code: 'KG',
            inventory_tracked: true,
          },
        ],
      });

      const result = await service.post(5, CURRENT_USER);
      expect(result.journal_entry_id).toBe(777);
      expect(stockService.receive).not.toHaveBeenCalled();
      expect(accountingPostingService.postJournal).not.toHaveBeenCalled();
    });

    it('rolls back without receiving when the period is locked', async () => {
      repository.findWithLines.mockResolvedValue({
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: VENDOR_ACTIVE.id,
        bill_date: '2026-04-15',
        due_date: null,
        supplier_invoice_no: null,
        status: 'draft',
        subtotal: '1000.00',
        tax_amount: '0.00',
        total_amount: '1000.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 50,
            purchase_bill_id: 5,
            item_id: ITEM_TRACKED.id,
            account_id: INVENTORY_ACCOUNT.id,
            description: ITEM_TRACKED.name,
            quantity: '10.000',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '1000.00',
            tax_amount: '0.00',
            item_name: ITEM_TRACKED.name,
            uom_code: 'KG',
            inventory_tracked: true,
          },
        ],
      });
      accountingPostingService.postJournal.mockRejectedValue(
        new BusinessRuleError('Accounting period is locked'),
      );

      await expect(service.post(5, CURRENT_USER)).rejects.toThrow(/locked/i);
      expect(stockService.receive).not.toHaveBeenCalled();
      expect(repository.updateBill).not.toHaveBeenCalled();
    });
  });
});

