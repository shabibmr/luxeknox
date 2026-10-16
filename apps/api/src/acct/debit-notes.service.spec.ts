import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Account, DebitNote } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import type { TaxCodesRepository } from './tax-codes.repository';
import { debitNoteCreateSchema } from './debit-notes.dto';
import { DebitNotesService } from './debit-notes.service';
import type { DebitNotesRepository } from './debit-notes.repository';
import type { PurchaseBillWithLines, PurchaseBillsRepository } from './purchase-bills.repository';

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

const AP_ACCOUNT: Account = {
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

const EXPENSE_ACCOUNT_1: Account = {
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

const EXPENSE_ACCOUNT_2: Account = {
  id: 5020,
  name: 'Facility Cleaning',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

describe('DebitNotesService', () => {
  let service: DebitNotesService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let purchaseBillsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let accountingPostingService: { postJournal: ReturnType<typeof vi.fn> };
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let taxCodesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  const db = {} as any;

  beforeEach(() => {
    repository = {
      allocateDebitNoteNumber: vi.fn().mockResolvedValue('DN00000001'),
      insertDebitNote: vi.fn(),
      updateDebitNote: vi.fn(),
      findById: vi.fn(),
      findMany: vi.fn(),
      sumPostedDebitNotesForBill: vi.fn().mockResolvedValue('0.00'),
      sumPostedAllocationsForBill: vi.fn().mockResolvedValue('0.00'),
    };

    taxCodesRepository = {
      findById: vi.fn().mockResolvedValue({ id: 1, rate_percent: '18.00', is_active: true }),
    };

    purchaseBillsRepository = {
      findById: vi.fn(),
      findWithLines: vi.fn(),
      listLines: vi.fn().mockResolvedValue([]),
    };

    accountingPostingService = {
      postJournal: vi.fn().mockResolvedValue({
        id: 888,
        journal_number: 'JRN00000888',
        lines: [],
      }),
    };

    accountsRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === AP_ACCOUNT.id) return AP_ACCOUNT;
        if (id === INPUT_TAX_ACCOUNT.id) return INPUT_TAX_ACCOUNT;
        if (id === EXPENSE_ACCOUNT_1.id) return EXPENSE_ACCOUNT_1;
        if (id === EXPENSE_ACCOUNT_2.id) return EXPENSE_ACCOUNT_2;
        return null;
      }),
      findByControlRole: vi.fn().mockImplementation(async (role: string) => {
        if (role === 'ap') return AP_ACCOUNT;
        if (role === 'input_tax') return INPUT_TAX_ACCOUNT;
        return null;
      }),
    };

    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };

    service = new DebitNotesService(
      repository as unknown as DebitNotesRepository,
      purchaseBillsRepository as unknown as PurchaseBillsRepository,
      accountingPostingService as unknown as AccountingPostingService,
      accountsRepository as unknown as AccountsRepository,
      taxCodesRepository as unknown as TaxCodesRepository,
      db,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('create (Task ACC-043)', () => {
    it('creates a draft debit note against a posted purchase bill within available balance', async () => {
      const postedBill: PurchaseBillWithLines = {
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: 10,
        bill_date: '2026-04-10',
        due_date: '2026-05-10',
        status: 'posted',
        subtotal: '1000.00',
        tax_amount: '180.00',
        total_amount: '1180.00',
        journal_entry_id: 100,
        row_version: 2,
        created_at: new Date('2026-04-10T10:00:00.000Z'),
        updated_at: null,
        lines: [],
      };

      purchaseBillsRepository.findById.mockResolvedValue(postedBill);
      repository.sumPostedDebitNotesForBill.mockResolvedValue('0.00');

      const createdNote: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Damaged item return',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      repository.insertDebitNote.mockResolvedValue(createdNote);

      const result = await service.create(
        {
          purchase_bill_id: 5,
          debit_note_date: '2026-04-16',
          reason: 'Damaged item return',
          amount: '200.00',
          tax_code_id: 1,
        },
        CURRENT_USER,
      );

      expect(repository.allocateDebitNoteNumber).toHaveBeenCalled();
      expect(repository.insertDebitNote).toHaveBeenCalledWith(
        expect.objectContaining({
          debit_note_number: 'DN00000001',
          purchase_bill_id: 5,
          subtotal: '200.00',
          tax_amount: '36.00',
          total_amount: '236.00',
          status: 'draft',
        }),
      );
      expect(result.id).toBe(1);
      expect(result.status).toBe('draft');
      expect(result.total_amount).toBe('236.00');
    });

    it('rejects creation if purchase bill does not exist', async () => {
      purchaseBillsRepository.findById.mockResolvedValue(null);

      await expect(
        service.create(
          {
            purchase_bill_id: 999,
            debit_note_date: '2026-04-16',
            amount: '100.00',
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(NotFoundError);
    });

    it('rejects creation if purchase bill is not posted', async () => {
      const draftBill = {
        id: 5,
        status: 'draft',
        total_amount: '1000.00',
      };
      purchaseBillsRepository.findById.mockResolvedValue(draftBill);

      await expect(
        service.create(
          {
            purchase_bill_id: 5,
            debit_note_date: '2026-04-16',
            amount: '100.00',
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('rejects creation against a bill with tracked lines (debit_note_tracked_deferred)', async () => {
      purchaseBillsRepository.findById.mockResolvedValue({
        id: 5,
        status: 'posted',
        total_amount: '1180.00',
      });
      purchaseBillsRepository.listLines.mockResolvedValue([
        { id: 1, item_id: 3, inventory_tracked: true },
        { id: 2, item_id: null, inventory_tracked: false },
      ]);

      await expect(
        service.create({ purchase_bill_id: 5, debit_note_date: '2026-04-12', amount: '100.00' } as any),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        details: [{ rule: 'debit_note_tracked_deferred' }],
      });
      expect(repository.insertDebitNote).not.toHaveBeenCalled();
    });

    it('rejects creation if debit note amount exceeds open bill balance', async () => {
      const postedBill = {
        id: 5,
        status: 'posted',
        total_amount: '500.00',
      };
      purchaseBillsRepository.findById.mockResolvedValue(postedBill);
      repository.sumPostedDebitNotesForBill.mockResolvedValue('300.00'); // open balance is 200.00

      await expect(
        service.create(
          {
            purchase_bill_id: 5,
            debit_note_date: '2026-04-16',
            amount: '250.00', // exceeds 200.00
          },
          CURRENT_USER,
        ),
      ).rejects.toThrow('exceeds open bill balance');
    });
  });

  describe('create tax handling (R3)', () => {
    const bill = { id: 5, status: 'posted', total_amount: '1180.00' };

    it('ignores client tax: computes tax from the tax code', async () => {
      purchaseBillsRepository.findById.mockResolvedValue(bill);
      repository.insertDebitNote.mockImplementation(async (row: unknown) => ({
        id: 1,
        ...(row as object),
      }));

      const result = await service.create(
        { purchase_bill_id: 5, debit_note_date: '2026-04-16', amount: '100.00', tax_code_id: 1 },
        CURRENT_USER,
      );

      expect(result.subtotal).toBe('100.00');
      expect(result.tax_amount).toBe('18.00');
      expect(result.total_amount).toBe('118.00');
    });

    it('rejects a client-sent tax_amount at the DTO boundary', () => {
      expect(() =>
        debitNoteCreateSchema.parse({
          purchase_bill_id: 5,
          debit_note_date: '2026-04-16',
          amount: '100.00',
          tax_amount: '0.00',
        }),
      ).toThrow();
    });

    it('treats payment allocations as reducing the open balance (matches the AP report)', async () => {
      purchaseBillsRepository.findById.mockResolvedValue(bill);
      repository.sumPostedAllocationsForBill.mockResolvedValue('1100.00'); // open = 80.00

      await expect(
        service.create(
          { purchase_bill_id: 5, debit_note_date: '2026-04-16', amount: '100.00' },
          CURRENT_USER,
        ),
      ).rejects.toThrow('exceeds open bill balance');
    });

    it('rejects an inactive tax code', async () => {
      purchaseBillsRepository.findById.mockResolvedValue(bill);
      taxCodesRepository.findById.mockResolvedValue({ id: 1, rate_percent: '18.00', is_active: false });

      await expect(
        service.create(
          { purchase_bill_id: 5, debit_note_date: '2026-04-16', amount: '100.00', tax_code_id: 1 },
          CURRENT_USER,
        ),
      ).rejects.toThrow('Tax code is inactive');
    });
  });

  describe('post (Task ACC-043)', () => {
    it('posts debit note against single-line bill: DR AP, CR tax, CR line account', async () => {
      const debitNote: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Refund',
        subtotal: '100.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      const billWithLines: PurchaseBillWithLines = {
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: 10,
        bill_date: '2026-04-10',
        due_date: '2026-05-10',
        status: 'posted',
        subtotal: '500.00',
        tax_amount: '90.00',
        total_amount: '590.00',
        journal_entry_id: 100,
        row_version: 2,
        created_at: new Date('2026-04-10T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 51,
            purchase_bill_id: 5,
            item_id: null,
            account_id: EXPENSE_ACCOUNT_1.id,
            description: 'Single equipment line',
            quantity: '5.00',
            rate: '100.00',
            tax_code_id: 1,
            net_amount: '500.00',
            tax_amount: '90.00',
          },
        ],
      };

      repository.findById.mockResolvedValue(debitNote);
      purchaseBillsRepository.findWithLines.mockResolvedValue(billWithLines);
      repository.sumPostedDebitNotesForBill.mockResolvedValue('0.00');

      repository.updateDebitNote.mockResolvedValue({
        ...debitNote,
        status: 'posted',
        journal_entry_id: 888,
        row_version: 2,
      });

      const result = await service.post(1, CURRENT_USER);

      expect(accountingPostingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-16',
        sourceType: 'debit_note',
        sourceId: 1,
        memo: 'Debit note DN00000001 for bill BIL00000005',
        postedByUserId: CURRENT_USER.id,
        lines: [
          {
            accountId: AP_ACCOUNT.id,
            debit: '118.00',
            credit: '0.00',
            memo: 'Debit note DN00000001 for bill BIL00000005',
            vendorId: 10,
          },
          {
            accountId: INPUT_TAX_ACCOUNT.id,
            debit: '0.00',
            credit: '18.00',
            memo: 'Input tax reversal for debit note DN00000001',
            vendorId: 10,
          },
          {
            accountId: EXPENSE_ACCOUNT_1.id,
            debit: '0.00',
            credit: '100.00',
            memo: 'Single equipment line',
            vendorId: 10,
          },
        ],
      });

      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(888);
    });

    it('prorates debit note credit proportional to line net amounts on multi-line bill, with remainder on last line', async () => {
      const debitNote: DebitNote = {
        id: 2,
        debit_note_number: 'DN00000002',
        purchase_bill_id: 6,
        debit_note_date: '2026-04-18',
        reason: 'Partial discount',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-18T10:00:00.000Z'),
        updated_at: null,
      };

      // Multi-line bill with 60% / 40% split
      const billWithLines: PurchaseBillWithLines = {
        id: 6,
        bill_number: 'BIL00000006',
        vendor_id: 10,
        bill_date: '2026-04-10',
        due_date: '2026-05-10',
        status: 'posted',
        subtotal: '1000.00',
        tax_amount: '0.00',
        total_amount: '1000.00',
        journal_entry_id: 101,
        row_version: 2,
        created_at: new Date('2026-04-10T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 61,
            purchase_bill_id: 6,
            item_id: null,
            account_id: EXPENSE_ACCOUNT_1.id,
            description: 'Line 1 maintenance',
            quantity: '6.00',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '600.00',
            tax_amount: '0.00',
          },
          {
            id: 62,
            purchase_bill_id: 6,
            item_id: null,
            account_id: EXPENSE_ACCOUNT_2.id,
            description: 'Line 2 cleaning',
            quantity: '4.00',
            rate: '100.00',
            tax_code_id: null,
            net_amount: '400.00',
            tax_amount: '0.00',
          },
        ],
      };

      repository.findById.mockResolvedValue(debitNote);
      purchaseBillsRepository.findWithLines.mockResolvedValue(billWithLines);
      repository.sumPostedDebitNotesForBill.mockResolvedValue('0.00');

      repository.updateDebitNote.mockResolvedValue({
        ...debitNote,
        status: 'posted',
        journal_entry_id: 888,
        row_version: 2,
      });

      await service.post(2, CURRENT_USER);

      expect(accountingPostingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-18',
        sourceType: 'debit_note',
        sourceId: 2,
        memo: 'Debit note DN00000002 for bill BIL00000006',
        postedByUserId: CURRENT_USER.id,
        lines: [
          {
            accountId: AP_ACCOUNT.id,
            debit: '100.00',
            credit: '0.00',
            memo: 'Debit note DN00000002 for bill BIL00000006',
            vendorId: 10,
          },
          {
            accountId: EXPENSE_ACCOUNT_1.id,
            debit: '0.00',
            credit: '60.00', // 60% of 100.00
            memo: 'Line 1 maintenance',
            vendorId: 10,
          },
          {
            accountId: EXPENSE_ACCOUNT_2.id,
            debit: '0.00',
            credit: '40.00', // remaining 40.00
            memo: 'Line 2 cleaning',
            vendorId: 10,
          },
        ],
      });
    });

    it('returns idempotently if debit note is already posted', async () => {
      const postedNote: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Refund',
        subtotal: '100.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        status: 'posted',
        journal_entry_id: 888,
        row_version: 2,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      repository.findById.mockResolvedValue(postedNote);

      const result = await service.post(1, CURRENT_USER);

      expect(accountingPostingService.postJournal).not.toHaveBeenCalled();
      expect(result.status).toBe('posted');
    });

    it('rejects posting if debit note is void', async () => {
      const voidNote: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Cancelled',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        status: 'void',
        journal_entry_id: null,
        row_version: 2,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      repository.findById.mockResolvedValue(voidNote);

      await expect(service.post(1, CURRENT_USER)).rejects.toThrow(
        'Void debit notes cannot be posted',
      );
    });

    it('rejects posting if open bill balance is exceeded at post time', async () => {
      const debitNote: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Refund',
        subtotal: '500.00',
        tax_amount: '0.00',
        total_amount: '500.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      const billWithLines: PurchaseBillWithLines = {
        id: 5,
        bill_number: 'BIL00000005',
        vendor_id: 10,
        bill_date: '2026-04-10',
        due_date: '2026-05-10',
        status: 'posted',
        subtotal: '500.00',
        tax_amount: '0.00',
        total_amount: '500.00',
        journal_entry_id: 100,
        row_version: 2,
        created_at: new Date('2026-04-10T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 51,
            purchase_bill_id: 5,
            item_id: null,
            account_id: EXPENSE_ACCOUNT_1.id,
            description: 'Item',
            quantity: '1.00',
            rate: '500.00',
            tax_code_id: null,
            net_amount: '500.00',
            tax_amount: '0.00',
          },
        ],
      };

      repository.findById.mockResolvedValue(debitNote);
      purchaseBillsRepository.findWithLines.mockResolvedValue(billWithLines);
      // Already 200.00 posted, so open balance is 300.00. 500.00 exceeds 300.00.
      repository.sumPostedDebitNotesForBill.mockResolvedValue('200.00');

      await expect(service.post(1, CURRENT_USER)).rejects.toThrow(
        'exceeds open bill balance',
      );
    });
  });

  describe('getById and list', () => {
    it('getById returns debit note', async () => {
      const note: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Refund',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      repository.findById.mockResolvedValue(note);

      const result = await service.getById(1, CURRENT_USER);
      expect(result.id).toBe(1);
      expect(result.debit_note_number).toBe('DN00000001');
    });

    it('getById throws NotFoundError when not found', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.getById(999, CURRENT_USER)).rejects.toThrow(NotFoundError);
    });

    it('list returns paginated response', async () => {
      const note: DebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 5,
        debit_note_date: '2026-04-16',
        reason: 'Refund',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
      };

      repository.findMany.mockResolvedValue({ rows: [note], total: 1 });

      const result = await service.list({}, CURRENT_USER);
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });
  });
});
