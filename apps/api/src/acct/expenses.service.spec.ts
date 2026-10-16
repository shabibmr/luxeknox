import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Account, ExpenseVoucher, TaxCode, Vendor } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import type { ExpenseVoucherWithLines, ExpensesRepository } from './expenses.repository';
import { ExpensesService } from './expenses.service';
import type { TaxCodesRepository } from './tax-codes.repository';
import type { VendorsRepository } from './vendors.repository';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const CURRENT_USER: AuthenticatedUser = {
  id: 42,
  email: 'accountant@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const BANK_ACCOUNT: Account = {
  id: 1,
  name: 'Operating Bank Account',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: true,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const NON_BANK_ACCOUNT: Account = {
  id: 2,
  name: 'Prepaid Expenses',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INACTIVE_BANK_ACCOUNT: Account = {
  id: 3,
  name: 'Closed Bank Account',
  account_type: 'asset',
  parent_id: null,
  is_active: false,
  is_bank: true,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const EXPENSE_ACCOUNT: Account = {
  id: 10,
  name: 'Office Supplies',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const ASSET_ACCOUNT: Account = {
  id: 11,
  name: 'Office Equipment',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INCOME_ACCOUNT: Account = {
  id: 12,
  name: 'Sales Revenue',
  account_type: 'income',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const CONTROL_ACCOUNT: Account = {
  id: 13,
  name: 'Accounts Receivable',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'ar',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INPUT_TAX_ACCOUNT: Account = {
  id: 20,
  name: 'Input Tax GST',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'input_tax',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const AP_ACCOUNT: Account = {
  id: 30,
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

const SAMPLE_VENDOR: Vendor = {
  id: 5,
  name: 'Staples Inc',
  phone: '1234567890',
  email: 'orders@staples.test',
  gstin: '29ABCDE1234F1Z5',
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const SAMPLE_TAX_CODE: TaxCode = {
  id: 7,
  code: 'GST18',
  name: 'GST 18%',
  rate_percent: '18.00',
  is_active: true,
};

describe('ExpensesService', () => {
  let service: ExpensesService;
  let expensesRepo: Record<string, ReturnType<typeof vi.fn>>;
  let postingService: Record<string, ReturnType<typeof vi.fn>>;
  let accountsRepo: Record<string, ReturnType<typeof vi.fn>>;
  let vendorsRepo: Record<string, ReturnType<typeof vi.fn>>;
  let taxCodesRepo: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  const db = {} as any;

  beforeEach(() => {
    expensesRepo = {
      allocateExpenseNumber: vi.fn().mockResolvedValue('EXP00000001'),
      findById: vi.fn(),
      findWithLines: vi.fn(),
      listLines: vi.fn(),
      insertExpense: vi.fn(),
      updateExpense: vi.fn(),
      replaceLines: vi.fn(),
      findMany: vi.fn(),
    };

    postingService = {
      postJournal: vi.fn().mockResolvedValue({
        id: 100,
        journal_number: 'JRN00000001',
        lines: [],
      }),
    };

    accountsRepo = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === BANK_ACCOUNT.id) return BANK_ACCOUNT;
        if (id === NON_BANK_ACCOUNT.id) return NON_BANK_ACCOUNT;
        if (id === INACTIVE_BANK_ACCOUNT.id) return INACTIVE_BANK_ACCOUNT;
        if (id === EXPENSE_ACCOUNT.id) return EXPENSE_ACCOUNT;
        if (id === ASSET_ACCOUNT.id) return ASSET_ACCOUNT;
        if (id === INCOME_ACCOUNT.id) return INCOME_ACCOUNT;
        if (id === CONTROL_ACCOUNT.id) return CONTROL_ACCOUNT;
        if (id === INPUT_TAX_ACCOUNT.id) return INPUT_TAX_ACCOUNT;
        if (id === AP_ACCOUNT.id) return AP_ACCOUNT;
        return null;
      }),
      findByControlRole: vi.fn().mockImplementation(async (role: string) => {
        if (role === 'input_tax') return INPUT_TAX_ACCOUNT;
        if (role === 'ap') return AP_ACCOUNT;
        return null;
      }),
    };

    vendorsRepo = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === SAMPLE_VENDOR.id) return SAMPLE_VENDOR;
        return null;
      }),
      assertActiveVendor: vi.fn().mockImplementation(async (id: number) => {
        if (id === SAMPLE_VENDOR.id) return SAMPLE_VENDOR;
        throw new NotFoundError(`Vendor ${id} was not found`);
      }),
    };

    taxCodesRepo = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === SAMPLE_TAX_CODE.id) return SAMPLE_TAX_CODE;
        return null;
      }),
    };

    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };

    service = new ExpensesService(
      expensesRepo as unknown as ExpensesRepository,
      postingService as unknown as AccountingPostingService,
      accountsRepo as unknown as AccountsRepository,
      vendorsRepo as unknown as VendorsRepository,
      taxCodesRepo as unknown as TaxCodesRepository,
      db,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('create - cash expense', () => {
    it('creates draft cash expense, computes tax and totals without requiring vendor', async () => {
      const insertedVoucher: ExpenseVoucherWithLines = {
        id: 1,
        expense_number: 'EXP00000001',
        vendor_id: null,
        payee_name: 'Office Depot Walk-in',
        expense_date: '2026-04-15',
        paid_from_account_id: BANK_ACCOUNT.id,
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
            id: 1,
            expense_voucher_id: 1,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Stationery & printing paper',
            amount: '100.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '18.00',
          },
        ],
      };

      expensesRepo.insertExpense.mockResolvedValue(insertedVoucher);

      const result = await service.create(
        {
          expense_date: '2026-04-15',
          paid_from_account_id: BANK_ACCOUNT.id,
          payee_name: 'Office Depot Walk-in',
          lines: [
            {
              account_id: EXPENSE_ACCOUNT.id,
              amount: '100.00',
              tax_code_id: SAMPLE_TAX_CODE.id,
              description: 'Stationery & printing paper',
            },
          ],
        },
        CURRENT_USER,
      );

      expect(expensesRepo.allocateExpenseNumber).toHaveBeenCalled();
      expect(expensesRepo.insertExpense).toHaveBeenCalledWith(
        expect.objectContaining({
          expense_number: 'EXP00000001',
          paid_from_account_id: BANK_ACCOUNT.id,
          vendor_id: null,
          payee_name: 'Office Depot Walk-in',
          subtotal: '100.00',
          tax_amount: '18.00',
          total_amount: '118.00',
          status: 'draft',
        }),
        [
          {
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Stationery & printing paper',
            amount: '100.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '18.00',
          },
        ],
      );

      expect(result.status).toBe('draft');
      expect(result.subtotal).toBe('100.00');
      expect(result.tax_amount).toBe('18.00');
      expect(result.total_amount).toBe('118.00');
      expect(result.lines).toHaveLength(1);
    });

    it('rejects cash expense if paid_from_account is not a bank account', async () => {
      await expect(
        service.create(
          {
            expense_date: '2026-04-15',
            paid_from_account_id: NON_BANK_ACCOUNT.id,
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                amount: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: expect.stringContaining('must be a bank or cash account'),
      });
    });

    it('rejects cash expense if paid_from_account is inactive', async () => {
      await expect(
        service.create(
          {
            expense_date: '2026-04-15',
            paid_from_account_id: INACTIVE_BANK_ACCOUNT.id,
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                amount: '50.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: expect.stringContaining('is inactive'),
      });
    });
  });

  describe('create - credit expense', () => {
    it('creates draft credit expense requiring vendor, computes totals', async () => {
      const insertedVoucher: ExpenseVoucherWithLines = {
        id: 2,
        expense_number: 'EXP00000002',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-16',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 2,
            expense_voucher_id: 2,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Printer ink cartridges',
            amount: '200.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '36.00',
          },
        ],
      };

      expensesRepo.insertExpense.mockResolvedValue(insertedVoucher);

      const result = await service.create(
        {
          expense_date: '2026-04-16',
          vendor_id: SAMPLE_VENDOR.id,
          lines: [
            {
              account_id: EXPENSE_ACCOUNT.id,
              amount: '200.00',
              tax_code_id: SAMPLE_TAX_CODE.id,
              description: 'Printer ink cartridges',
            },
          ],
        },
        CURRENT_USER,
      );

      expect(vendorsRepo.assertActiveVendor).toHaveBeenCalledWith(SAMPLE_VENDOR.id);
      expect(result.status).toBe('draft');
      expect(result.subtotal).toBe('200.00');
      expect(result.tax_amount).toBe('36.00');
      expect(result.total_amount).toBe('236.00');
    });

    it('rejects credit expense when vendor_id is omitted', async () => {
      await expect(
        service.create(
          {
            expense_date: '2026-04-16',
            lines: [
              {
                account_id: EXPENSE_ACCOUNT.id,
                amount: '200.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: expect.stringContaining('vendor_id is required'),
      });
    });
  });

  describe('line validations', () => {
    it('allows asset accounts for capitalized expense voucher lines', async () => {
      expensesRepo.insertExpense.mockResolvedValue({
        id: 3,
        expense_number: 'EXP00000003',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-17',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '500.00',
        tax_amount: '0.00',
        total_amount: '500.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        lines: [],
      });

      const result = await service.create(
        {
          expense_date: '2026-04-17',
          vendor_id: SAMPLE_VENDOR.id,
          lines: [
            {
              account_id: ASSET_ACCOUNT.id,
              amount: '500.00',
              description: 'Office Chair',
            },
          ],
        },
        CURRENT_USER,
      );

      expect(result.subtotal).toBe('500.00');
    });

    it('rejects income accounts for expense lines', async () => {
      await expect(
        service.create(
          {
            expense_date: '2026-04-17',
            vendor_id: SAMPLE_VENDOR.id,
            lines: [
              {
                account_id: INCOME_ACCOUNT.id,
                amount: '100.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: expect.stringContaining('must be an expense or asset account'),
      });
    });

    it('rejects control accounts for expense lines', async () => {
      await expect(
        service.create(
          {
            expense_date: '2026-04-17',
            vendor_id: SAMPLE_VENDOR.id,
            lines: [
              {
                account_id: CONTROL_ACCOUNT.id,
                amount: '100.00',
              },
            ],
          },
          CURRENT_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: expect.stringContaining('Control account'),
      });
    });
  });

  describe('post - cash expense', () => {
    it('posts journal with DR expense lines, DR input tax, and CR bank account directly (NO payable line)', async () => {
      const draftCashExpense: ExpenseVoucherWithLines = {
        id: 10,
        expense_number: 'EXP00000010',
        vendor_id: null,
        payee_name: 'Coffee Store',
        expense_date: '2026-04-18',
        paid_from_account_id: BANK_ACCOUNT.id,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-18T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 11,
            expense_voucher_id: 10,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Coffee beans & milk',
            amount: '100.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '18.00',
          },
        ],
      };

      const postedVoucher: ExpenseVoucherWithLines = {
        ...draftCashExpense,
        status: 'posted',
        journal_entry_id: 100,
        row_version: 2,
      };

      expensesRepo.findWithLines
        .mockResolvedValueOnce(draftCashExpense)
        .mockResolvedValueOnce(postedVoucher);

      const result = await service.post(10, CURRENT_USER);

      expect(postingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-18',
        sourceType: 'expense_voucher',
        sourceId: 10,
        memo: 'Expense voucher EXP00000010',
        postedByUserId: CURRENT_USER.id,
        lines: [
          {
            accountId: EXPENSE_ACCOUNT.id,
            debit: '100.00',
            memo: 'Coffee beans & milk',
          },
          {
            accountId: INPUT_TAX_ACCOUNT.id,
            debit: '18.00',
            memo: 'Input tax on EXP00000010',
          },
          {
            accountId: BANK_ACCOUNT.id,
            credit: '118.00',
            memo: 'Payment for EXP00000010',
          },
        ],
      });

      // Verify NO payable line was created
      const callArgs = postingService.postJournal.mock.calls[0][0];
      const hasPayableLine = callArgs.lines.some(
        (l: { accountId: number }) => l.accountId === AP_ACCOUNT.id,
      );
      expect(hasPayableLine).toBe(false);

      expect(expensesRepo.updateExpense).toHaveBeenCalledWith(10, {
        status: 'posted',
        journal_entry_id: 100,
        row_version: 2,
        updated_at: expect.any(Date),
      });

      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(100);
    });
  });

  describe('post - credit expense', () => {
    it('posts journal with DR expense lines, DR input tax, and CR accounts payable with vendorId', async () => {
      const draftCreditExpense: ExpenseVoucherWithLines = {
        id: 20,
        expense_number: 'EXP00000020',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-19',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date('2026-04-19T10:00:00.000Z'),
        updated_at: null,
        lines: [
          {
            id: 21,
            expense_voucher_id: 20,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Consulting fees',
            amount: '200.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '36.00',
          },
        ],
      };

      const postedVoucher: ExpenseVoucherWithLines = {
        ...draftCreditExpense,
        status: 'posted',
        journal_entry_id: 100,
        row_version: 2,
      };

      expensesRepo.findWithLines
        .mockResolvedValueOnce(draftCreditExpense)
        .mockResolvedValueOnce(postedVoucher);

      const result = await service.post(20, CURRENT_USER);

      expect(postingService.postJournal).toHaveBeenCalledWith({
        entryDate: '2026-04-19',
        sourceType: 'expense_voucher',
        sourceId: 20,
        memo: 'Expense voucher EXP00000020',
        postedByUserId: CURRENT_USER.id,
        lines: [
          {
            accountId: EXPENSE_ACCOUNT.id,
            debit: '200.00',
            memo: 'Consulting fees',
          },
          {
            accountId: INPUT_TAX_ACCOUNT.id,
            debit: '36.00',
            memo: 'Input tax on EXP00000020',
          },
          {
            accountId: AP_ACCOUNT.id,
            credit: '236.00',
            memo: 'Payable for EXP00000020',
            vendorId: SAMPLE_VENDOR.id,
          },
        ],
      });

      expect(result.status).toBe('posted');
    });
  });

  describe('post - idempotency', () => {
    it('returns already posted expense idempotently without re-posting journal', async () => {
      const alreadyPosted: ExpenseVoucherWithLines = {
        id: 30,
        expense_number: 'EXP00000030',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-20',
        paid_from_account_id: null,
        status: 'posted',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: 99,
        row_version: 2,
        created_at: new Date('2026-04-20T10:00:00.000Z'),
        updated_at: new Date('2026-04-20T11:00:00.000Z'),
        lines: [],
      };

      expensesRepo.findWithLines.mockResolvedValue(alreadyPosted);

      const result = await service.post(30, CURRENT_USER);

      expect(postingService.postJournal).not.toHaveBeenCalled();
      expect(expensesRepo.updateExpense).not.toHaveBeenCalled();
      expect(result.status).toBe('posted');
      expect(result.journal_entry_id).toBe(99);
    });
  });

  describe('update', () => {
    it('updates draft expense voucher and recalculates lines and totals', async () => {
      const existingDraft: ExpenseVoucherWithLines = {
        id: 40,
        expense_number: 'EXP00000040',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-21',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        lines: [
          {
            id: 41,
            expense_voucher_id: 40,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Original line',
            amount: '100.00',
            tax_code_id: null,
            tax_amount: '0.00',
          },
        ],
      };

      const updatedWithLines: ExpenseVoucherWithLines = {
        ...existingDraft,
        subtotal: '150.00',
        tax_amount: '27.00',
        total_amount: '177.00',
        row_version: 2,
        lines: [
          {
            id: 42,
            expense_voucher_id: 40,
            account_id: EXPENSE_ACCOUNT.id,
            description: 'Updated line',
            amount: '150.00',
            tax_code_id: SAMPLE_TAX_CODE.id,
            tax_amount: '27.00',
          },
        ],
      };

      expensesRepo.findWithLines
        .mockResolvedValueOnce(existingDraft)
        .mockResolvedValueOnce(updatedWithLines);

      const result = await service.update(
        40,
        {
          lines: [
            {
              account_id: EXPENSE_ACCOUNT.id,
              amount: '150.00',
              tax_code_id: SAMPLE_TAX_CODE.id,
              description: 'Updated line',
            },
          ],
        },
        CURRENT_USER,
      );

      expect(expensesRepo.replaceLines).toHaveBeenCalledWith(40, [
        {
          account_id: EXPENSE_ACCOUNT.id,
          description: 'Updated line',
          amount: '150.00',
          tax_code_id: SAMPLE_TAX_CODE.id,
          tax_amount: '27.00',
        },
      ]);
      expect(expensesRepo.updateExpense).toHaveBeenCalledWith(
        40,
        expect.objectContaining({
          subtotal: '150.00',
          tax_amount: '27.00',
          total_amount: '177.00',
          row_version: 2,
        }),
      );
      expect(result.subtotal).toBe('150.00');
      expect(result.tax_amount).toBe('27.00');
      expect(result.total_amount).toBe('177.00');
    });

    it('rejects editing a posted expense voucher', async () => {
      const postedVoucher: ExpenseVoucherWithLines = {
        id: 45,
        expense_number: 'EXP00000045',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-21',
        paid_from_account_id: null,
        status: 'posted',
        subtotal: '100.00',
        tax_amount: '0.00',
        total_amount: '100.00',
        journal_entry_id: 99,
        row_version: 2,
        created_at: new Date(),
        updated_at: new Date(),
        lines: [],
      };

      expensesRepo.findWithLines.mockResolvedValue(postedVoucher);

      await expect(
        service.update(45, { payee_name: 'Cannot edit' }, CURRENT_USER),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Only draft expense vouchers can be edited',
      });
      expect(expensesRepo.updateExpense).not.toHaveBeenCalled();
    });
  });

  describe('getById', () => {
    it('returns expense voucher with lines when found', async () => {
      const voucher: ExpenseVoucherWithLines = {
        id: 50,
        expense_number: 'EXP00000050',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-22',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '75.00',
        tax_amount: '0.00',
        total_amount: '75.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
        lines: [],
      };

      expensesRepo.findWithLines.mockResolvedValue(voucher);

      const result = await service.getById(50, CURRENT_USER);
      expect(result.id).toBe(50);
      expect(result.expense_number).toBe('EXP00000050');
    });

    it('throws NotFoundError when expense voucher does not exist', async () => {
      expensesRepo.findWithLines.mockResolvedValue(null);

      await expect(service.getById(999, CURRENT_USER)).rejects.toBeInstanceOf(
        NotFoundError,
      );
    });
  });

  describe('list', () => {
    it('returns paginated expense vouchers', async () => {
      const sampleRow: ExpenseVoucher = {
        id: 60,
        expense_number: 'EXP00000060',
        vendor_id: SAMPLE_VENDOR.id,
        payee_name: null,
        expense_date: '2026-04-23',
        paid_from_account_id: null,
        status: 'draft',
        subtotal: '50.00',
        tax_amount: '0.00',
        total_amount: '50.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      };

      expensesRepo.findMany.mockResolvedValue({
        rows: [sampleRow],
        total: 1,
      });

      const result = await service.list(
        { status: 'draft', vendor_id: '5' },
        CURRENT_USER,
      );

      expect(expensesRepo.findMany).toHaveBeenCalledWith({
        status: 'draft',
        vendorId: 5,
        from: undefined,
        to: undefined,
        search: undefined,
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0].expense_number).toBe('EXP00000060');
      expect(result.meta.total).toBe(1);
    });
  });
});
