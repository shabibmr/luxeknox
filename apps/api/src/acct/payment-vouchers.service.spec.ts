import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import type { PaymentVouchersRepository } from './payment-vouchers.repository';
import { PaymentVouchersService } from './payment-vouchers.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
  getAmbientTransaction: () => null,
}));

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const BANK_ACCOUNT = {
  id: 101,
  code: '1010',
  name: 'HDFC Bank Operating',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: true,
  is_control: false,
  control_role: null,
  created_at: new Date(),
  updated_at: null,
};

const NON_BANK_ACCOUNT = {
  id: 102,
  code: '1020',
  name: 'Petty Cash',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date(),
  updated_at: null,
};

const AP_ACCOUNT = {
  id: 2000,
  code: '2000',
  name: 'Accounts Payable',
  account_type: 'liability',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'ap',
  created_at: new Date(),
  updated_at: null,
};

const POSTED_BILL = {
  id: 1,
  bill_number: 'PB00000001',
  vendor_id: 10,
  bill_date: '2026-04-10',
  due_date: '2026-04-20',
  status: 'posted',
  subtotal: '400.00',
  tax_amount: '100.00',
  total_amount: '500.00',
  journal_entry_id: 10,
  row_version: 1,
  created_at: new Date(),
  updated_at: null,
};

const POSTED_CREDIT_EXPENSE = {
  id: 2,
  expense_number: 'EV00000002',
  vendor_id: 20,
  payee_name: 'Office Supplies Vendor',
  expense_date: '2026-04-12',
  paid_from_account_id: null,
  status: 'posted',
  subtotal: '200.00',
  tax_amount: '0.00',
  total_amount: '200.00',
  journal_entry_id: 12,
  row_version: 1,
  created_at: new Date(),
  updated_at: null,
};

describe('PaymentVouchersService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let postingService: Record<string, ReturnType<typeof vi.fn>>;
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let db: Record<string, unknown>;
  let service: PaymentVouchersService;

  beforeEach(() => {
    repository = {
      allocatePaymentVoucherNumber: vi.fn().mockResolvedValue('PV00000001'),
      findWithAllocations: vi.fn(),
      listAllocations: vi.fn(),
      listAllocationsForVoucherIds: vi.fn(),
      insertVoucher: vi.fn(),
      updateVoucher: vi.fn(),
      replaceAllocations: vi.fn(),
      findMany: vi.fn(),
      sumPostedAllocationsForBill: vi.fn().mockResolvedValue('0.00'),
      sumPostedAllocationsForExpense: vi.fn().mockResolvedValue('0.00'),
      sumPostedDebitNotesForBill: vi.fn().mockResolvedValue('0.00'),
      findPurchaseBillById: vi.fn().mockImplementation(async (id: number) => {
        if (id === POSTED_BILL.id) return POSTED_BILL;
        return null;
      }),
      findExpenseVoucherById: vi.fn().mockImplementation(async (id: number) => {
        if (id === POSTED_CREDIT_EXPENSE.id) return POSTED_CREDIT_EXPENSE;
        return null;
      }),
    };

    postingService = {
      postJournal: vi.fn().mockResolvedValue({
        id: 99,
        journal_number: 'JRN00000099',
        lines: [],
      }),
    };

    accountsRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === BANK_ACCOUNT.id) return BANK_ACCOUNT;
        if (id === NON_BANK_ACCOUNT.id) return NON_BANK_ACCOUNT;
        return null;
      }),
      findByControlRole: vi.fn().mockImplementation(async (role: string) => {
        if (role === 'ap') return AP_ACCOUNT;
        return null;
      }),
      findByCode: vi.fn().mockImplementation(async (code: string) => {
        if (code === '2000') return AP_ACCOUNT;
        return null;
      }),
    };

    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };

    db = {};

    service = new PaymentVouchersService(
      repository as unknown as PaymentVouchersRepository,
      postingService as unknown as AccountingPostingService,
      accountsRepository as unknown as AccountsRepository,
      db as any,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('create', () => {
    it('creates a valid payment voucher with allocations matching total_amount', async () => {
      const now = new Date();
      repository.insertVoucher.mockResolvedValue({
        id: 1,
        voucher_number: 'PV00000001',
        payment_date: '2026-04-15',
        bank_account_id: 101,
        total_amount: '200.00',
        memo: 'Payment for supplies',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: now,
        updated_at: null,
        allocations: [
          {
            id: 1,
            payment_voucher_id: 1,
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '200.00',
          },
        ],
      });

      const result = await service.create(
        {
          payment_date: '2026-04-15',
          bank_account_id: 101,
          total_amount: '200.00',
          memo: 'Payment for supplies',
          allocations: [
            {
              purchase_bill_id: 1,
              amount: '200.00',
            },
          ],
        },
        ADMIN_USER,
      );

      expect(repository.allocatePaymentVoucherNumber).toHaveBeenCalled();
      expect(repository.insertVoucher).toHaveBeenCalledWith(
        expect.objectContaining({
          voucher_number: 'PV00000001',
          payment_date: '2026-04-15',
          bank_account_id: 101,
          total_amount: '200.00',
          status: 'draft',
        }),
        [
          {
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '200.00',
          },
        ],
      );
      expect(result.id).toBe(1);
      expect(result.status).toBe('draft');
      expect(result.allocations).toHaveLength(1);
      expect(result.allocations[0]?.amount).toBe('200.00');
    });

    it('rejects non-bank account for bank_account_id', async () => {
      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 102, // NON_BANK_ACCOUNT
            total_amount: '200.00',
            allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);

      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 102,
            total_amount: '200.00',
            allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('Account 102 is not a bank account');
    });

    it('rejects allocation amount exceeding open balance of a purchase bill', async () => {
      // Bill total = 500.00, already allocated = 350.00, debit notes = 50.00 -> open balance = 100.00
      repository.sumPostedAllocationsForBill.mockResolvedValue('350.00');
      repository.sumPostedDebitNotesForBill.mockResolvedValue('50.00');

      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '150.00',
            allocations: [{ purchase_bill_id: 1, amount: '150.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('Allocation amount exceeds open balance');
    });

    it('rejects voucher where sum of allocations !== total_amount', async () => {
      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '250.00',
            allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('Total amount must equal the sum of allocation amounts');
    });

    it('rejects allocation to unposted purchase bill', async () => {
      repository.findPurchaseBillById.mockResolvedValue({
        ...POSTED_BILL,
        status: 'draft',
      });

      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '100.00',
            allocations: [{ purchase_bill_id: 1, amount: '100.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('Purchase bill PB00000001 is not posted');
    });

    it('rejects allocation to direct cash expense voucher (paid_from_account_id not null)', async () => {
      repository.findExpenseVoucherById.mockResolvedValue({
        ...POSTED_CREDIT_EXPENSE,
        paid_from_account_id: 101,
      });

      await expect(
        service.create(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '100.00',
            allocations: [{ expense_voucher_id: 2, amount: '100.00' }],
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('already paid directly');
    });
  });

  describe('post', () => {
    it('posting voucher creates balanced journal (DR accounts payable, CR bank account)', async () => {
      const draftVoucher = {
        id: 10,
        voucher_number: 'PV00000010',
        payment_date: '2026-04-18',
        bank_account_id: 101,
        total_amount: '300.00',
        memo: 'Payment for bill and expense',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        allocations: [
          {
            id: 1,
            payment_voucher_id: 10,
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '200.00',
          },
          {
            id: 2,
            payment_voucher_id: 10,
            purchase_bill_id: null,
            expense_voucher_id: 2,
            amount: '100.00',
          },
        ],
      };

      repository.findWithAllocations.mockResolvedValue(draftVoucher);
      repository.updateVoucher.mockImplementation(async (id: number, patch: any) => ({
        ...draftVoucher,
        ...patch,
      }));

      const result = await service.post(10, ADMIN_USER);

      expect(postingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-18',
        sourceType: 'payment_voucher',
        sourceId: 10,
        memo: 'Payment for bill and expense',
        postedByUserId: 1,
        lines: [
          {
            accountId: 2000, // AP
            debit: '200.00',
            memo: 'Payment for bill PB00000001',
            vendorId: 10,
          },
          {
            accountId: 2000, // AP
            debit: '100.00',
            memo: 'Payment for expense EV00000002',
            vendorId: 20,
          },
          {
            accountId: 101, // Bank
            credit: '300.00',
            memo: 'Payment for bill and expense',
          },
        ],
      });

      expect(repository.updateVoucher).toHaveBeenCalledWith(10, {
        status: 'posted',
        journal_entry_id: 99,
        row_version: 2,
        updated_at: expect.any(Date),
      });

      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(99);
      expect(result.row_version).toBe(2);
    });

    it('re-posting is idempotent', async () => {
      const postedVoucher = {
        id: 10,
        voucher_number: 'PV00000010',
        payment_date: '2026-04-18',
        bank_account_id: 101,
        total_amount: '300.00',
        memo: null,
        status: 'posted',
        journal_entry_id: 99,
        row_version: 2,
        created_at: new Date(),
        updated_at: new Date(),
        allocations: [],
      };

      repository.findWithAllocations.mockResolvedValue(postedVoucher);

      const result = await service.post(10, ADMIN_USER);

      expect(postingService.postJournal).not.toHaveBeenCalled();
      expect(repository.updateVoucher).not.toHaveBeenCalled();
      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(99);
    });

    it('rejects posting if open balance was consumed after creation', async () => {
      const draftVoucher = {
        id: 10,
        voucher_number: 'PV00000010',
        payment_date: '2026-04-18',
        bank_account_id: 101,
        total_amount: '200.00',
        memo: null,
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        allocations: [
          {
            id: 1,
            payment_voucher_id: 10,
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '200.00',
          },
        ],
      };

      repository.findWithAllocations.mockResolvedValue(draftVoucher);
      // Another transaction posted 400.00 against the 500.00 bill
      repository.sumPostedAllocationsForBill.mockResolvedValue('400.00');

      await expect(service.post(10, ADMIN_USER)).rejects.toThrow(
        'Allocation amount exceeds open balance',
      );
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });
  });

  describe('update', () => {
    it('edits a draft voucher successfully', async () => {
      const draftVoucher = {
        id: 5,
        voucher_number: 'PV00000005',
        payment_date: '2026-04-15',
        bank_account_id: 101,
        total_amount: '200.00',
        memo: 'Old memo',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        allocations: [
          {
            id: 1,
            payment_voucher_id: 5,
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '200.00',
          },
        ],
      };

      repository.findWithAllocations.mockResolvedValue(draftVoucher);
      repository.updateVoucher.mockImplementation(async (id: number, patch: any) => ({
        ...draftVoucher,
        ...patch,
      }));

      const result = await service.update(
        5,
        {
          memo: 'Updated memo',
        },
        ADMIN_USER,
      );

      expect(repository.updateVoucher).toHaveBeenCalledWith(5, {
        memo: 'Updated memo',
        row_version: 2,
        updated_at: expect.any(Date),
      });
      expect(result.memo).toBe('Updated memo');
    });

    it('rejects edits on posted voucher', async () => {
      const postedVoucher = {
        id: 5,
        voucher_number: 'PV00000005',
        payment_date: '2026-04-15',
        bank_account_id: 101,
        total_amount: '200.00',
        memo: 'Old memo',
        status: 'posted',
        journal_entry_id: 99,
        row_version: 2,
        created_at: new Date(),
        updated_at: new Date(),
        allocations: [],
      };

      repository.findWithAllocations.mockResolvedValue(postedVoucher);

      await expect(
        service.update(5, { memo: 'Updated memo' }, ADMIN_USER),
      ).rejects.toThrow('Only draft payment vouchers can be edited');
    });
  });

  describe('getById and list', () => {
    it('getById returns voucher with allocations', async () => {
      const voucher = {
        id: 1,
        voucher_number: 'PV00000001',
        payment_date: '2026-04-15',
        bank_account_id: 101,
        total_amount: '100.00',
        memo: null,
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        allocations: [
          {
            id: 1,
            payment_voucher_id: 1,
            purchase_bill_id: 1,
            expense_voucher_id: null,
            amount: '100.00',
          },
        ],
      };
      repository.findWithAllocations.mockResolvedValue(voucher);

      const result = await service.getById(1, ADMIN_USER);
      expect(result.id).toBe(1);
      expect(result.allocations).toHaveLength(1);
      expect(result.allocations[0]?.amount).toBe('100.00');
    });

    it('getById throws NotFoundError if voucher does not exist', async () => {
      repository.findWithAllocations.mockResolvedValue(null);
      await expect(service.getById(999, ADMIN_USER)).rejects.toThrow(NotFoundError);
    });

    it('list returns paginated response', async () => {
      repository.findMany.mockResolvedValue({
        rows: [
          {
            id: 1,
            voucher_number: 'PV00000001',
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '100.00',
            memo: null,
            status: 'draft',
            journal_entry_id: null,
            row_version: 1,
            created_at: new Date(),
            updated_at: null,
            allocations: [],
          },
        ],
        total: 1,
      });

      const result = await service.list({ status: 'draft' }, ADMIN_USER);
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });
  });
});
