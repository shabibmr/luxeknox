import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError } from '../platform/errors/app-error';
import { DebitNotesService } from './debit-notes.service';
import { ExpensesService } from './expenses.service';
import { PaymentVouchersService } from './payment-vouchers.service';
import { PurchaseBillsService } from './purchase-bills.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
  getAmbientTransaction: () => null,
}));

const ACTOR: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

describe('Phase 4 — Purchases, expenses, money out (ACC-044)', () => {
  describe('1. Purchase Bill (Draft, lines, posting)', () => {
    it('creates draft bill with lines and posts balanced journal to AP', async () => {
      const mockPostJournal = vi.fn().mockResolvedValue({
        id: 101,
        journal_number: 'JRN00000101',
      });
      const postingService = { postJournal: mockPostJournal } as any;

      const mockBill = {
        id: 10,
        bill_number: 'BIL00000010',
        vendor_id: 2,
        bill_date: '2026-05-01',
        due_date: '2026-05-15',
        status: 'draft',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      };

      const mockLines = [
        {
          id: 1,
          purchase_bill_id: 10,
          item_id: null,
          account_id: 5000,
          description: 'Office supplies',
          quantity: '2.00',
          rate: '100.00',
          tax_code_id: 1,
          net_amount: '200.00',
          tax_amount: '36.00',
        },
      ];

      const billsRepo = {
        allocateBillNumber: vi.fn().mockResolvedValue('BIL00000010'),
        insertBill: vi.fn().mockResolvedValue({ ...mockBill, lines: mockLines }),
        findWithLines: vi.fn().mockImplementation(() => ({ ...mockBill, lines: mockLines })),
        updateBill: vi.fn().mockImplementation((id, values) => {
          Object.assign(mockBill, values);
          return { ...mockBill, lines: mockLines };
        }),
      } as any;

      const accountsRepo = {
        findById: vi.fn().mockImplementation((id) => {
          if (id === 5000) return { id: 5000, name: 'Supplies', is_active: true, is_control: false };
          return null;
        }),
        findByControlRole: vi.fn().mockImplementation((role) => {
          if (role === 'ap') return { id: 2000, name: 'Accounts payable', code: '2000' };
          if (role === 'input_tax') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
        findByCode: vi.fn().mockImplementation((code) => {
          if (code === '2000') return { id: 2000, name: 'Accounts payable', code: '2000' };
          if (code === '1300') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
      } as any;

      const vendorsRepo = {
        findById: vi.fn().mockResolvedValue({ id: 2, name: 'Stationery Hub', is_active: true }),
      } as any;

      const taxCodesRepo = {
        findById: vi.fn().mockResolvedValue({ id: 1, name: 'GST 18%', rate_percent: '18.00', is_active: true }),
      } as any;

      const itemsRepo = { findById: vi.fn().mockResolvedValue(null) } as any;
      const db = {} as any;
      const paginationHelper = {} as any;

      const service = new PurchaseBillsService(
        billsRepo,
        postingService,
        accountsRepo,
        vendorsRepo,
        itemsRepo,
        taxCodesRepo,
        db,
        paginationHelper,
      );

      // Create draft bill
      const created = await service.create(
        {
          vendor_id: 2,
          bill_date: '2026-05-01',
          due_date: '2026-05-15',
          lines: [
            {
              account_id: 5000,
              description: 'Office supplies',
              quantity: '2.00',
              rate: '100.00',
              tax_code_id: 1,
            },
          ],
        },
        ACTOR,
      );

      expect(created.status).toBe('draft');
      expect(created.subtotal).toBe('200.00');
      expect(created.tax_amount).toBe('36.00');
      expect(created.total_amount).toBe('236.00');

      // Post bill
      const posted = await service.post(10, ACTOR);
      expect(posted.status).toBe('posted');
      expect(posted.journal_entry_id).toBe(101);

      // Journal entry checks
      expect(mockPostJournal).toHaveBeenCalledTimes(1);
      const call = mockPostJournal.mock.calls[0][0];
      expect(call.sourceType).toBe('purchase_bill');
      expect(call.sourceId).toBe(10);
      expect(call.entryDate).toBe('2026-05-01');

      // Debits = 200 (Supplies) + 36 (Input Tax) = 236. Credit = 236 (AP).
      const debits = call.lines.filter((l: any) => l.debit && Number(l.debit) > 0);
      const credits = call.lines.filter((l: any) => l.credit && Number(l.credit) > 0);
      expect(debits).toHaveLength(2);
      expect(credits).toHaveLength(1);

      expect(debits.find((l: any) => l.accountId === 5000)?.debit).toBe('200.00');
      expect(debits.find((l: any) => l.accountId === 1300)?.debit).toBe('36.00');
      expect(credits[0].accountId).toBe(2000);
      expect(credits[0].credit).toBe('236.00');
    });
  });

  describe('2. Cash Expense Voucher (Direct bank/cash credit, no AP)', () => {
    it('creates cash expense and credits bank account directly with no payable line', async () => {
      const mockPostJournal = vi.fn().mockResolvedValue({
        id: 102,
        journal_number: 'JRN00000102',
      });
      const postingService = { postJournal: mockPostJournal } as any;

      const mockVoucher = {
        id: 20,
        expense_number: 'EXP00000020',
        vendor_id: null,
        payee_name: 'Metro Water',
        expense_date: '2026-05-02',
        paid_from_account_id: 1000,
        status: 'draft',
        subtotal: '50.00',
        tax_amount: '0.00',
        total_amount: '50.00',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      };

      const mockLines = [
        {
          id: 1,
          expense_voucher_id: 20,
          account_id: 5100,
          description: 'Drinking water cans',
          amount: '50.00',
          tax_code_id: null,
          tax_amount: '0.00',
        },
      ];

      const expensesRepo = {
        allocateExpenseNumber: vi.fn().mockResolvedValue('EXP00000020'),
        insertExpense: vi.fn().mockResolvedValue({ ...mockVoucher, lines: mockLines }),
        findWithLines: vi.fn().mockImplementation(() => ({ ...mockVoucher, lines: mockLines })),
        updateExpense: vi.fn().mockImplementation((id, values) => {
          Object.assign(mockVoucher, values);
          return { ...mockVoucher, lines: mockLines };
        }),
      } as any;

      const accountsRepo = {
        findById: vi.fn().mockImplementation((id) => {
          if (id === 1000) return { id: 1000, name: 'Cash', account_type: 'asset', is_active: true, is_bank: true };
          if (id === 5100) return { id: 5100, name: 'Utilities', account_type: 'expense', is_active: true, is_control: false };
          return null;
        }),
        findByControlRole: vi.fn().mockImplementation((role) => {
          if (role === 'input_tax') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
        findByCode: vi.fn().mockImplementation((code) => {
          if (code === '1300') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
      } as any;

      const vendorsRepo = {} as any;
      const taxCodesRepo = {} as any;
      const db = {} as any;
      const paginationHelper = {} as any;

      const service = new ExpensesService(
        expensesRepo,
        postingService,
        accountsRepo,
        vendorsRepo,
        taxCodesRepo,
        db,
        paginationHelper,
      );

      // Create draft cash expense
      const created = await service.create(
        {
          expense_date: '2026-05-02',
          paid_from_account_id: 1000,
          payee_name: 'Metro Water',
          lines: [
            {
              account_id: 5100,
              description: 'Drinking water cans',
              amount: '50.00',
            },
          ],
        },
        ACTOR,
      );

      expect(created.status).toBe('draft');
      expect(created.total_amount).toBe('50.00');

      // Post cash expense
      const posted = await service.post(20, ACTOR);
      expect(posted.status).toBe('posted');

      // Journal verification
      const call = mockPostJournal.mock.calls[0][0];
      expect(call.sourceType).toBe('expense_voucher');
      expect(call.sourceId).toBe(20);

      // Lines must NOT contain accounts payable (2000)
      const accountsInJournal = call.lines.map((l: any) => l.accountId);
      expect(accountsInJournal).not.toContain(2000);

      // Must debit expense and credit cash account directly
      expect(call.lines).toEqual([
        {
          accountId: 5100,
          debit: '50.00',
          memo: 'Drinking water cans',
        },
        {
          accountId: 1000,
          credit: '50.00',
          memo: 'Payment for EXP00000020',
        },
      ]);
    });
  });

  describe('3. Payment Voucher Over-allocation', () => {
    it('rejects allocation exceeding the open balance of a purchase bill', async () => {
      const postingService = { postJournal: vi.fn() } as any;

      const vouchersRepo = {
        allocatePaymentVoucherNumber: vi.fn().mockResolvedValue('PV00000001'),
        findPurchaseBillById: vi.fn().mockResolvedValue({
          id: 10,
          bill_number: 'BIL00000010',
          status: 'posted',
          total_amount: '200.00',
        }),
        sumPostedAllocationsForBill: vi.fn().mockResolvedValue('150.00'),
        sumPostedDebitNotesForBill: vi.fn().mockResolvedValue('0.00'),
      } as any;

      const accountsRepo = {
        findById: vi.fn().mockResolvedValue({ id: 1010, name: 'Bank', is_active: true, is_bank: true }),
      } as any;

      const db = {} as any;
      const paginationHelper = {} as any;

      const service = new PaymentVouchersService(
        vouchersRepo,
        postingService,
        accountsRepo,
        db,
        paginationHelper,
      );

      // Remaining open balance is 200.00 - 150.00 = 50.00.
      // Allocating 60.00 must throw BusinessRuleError
      await expect(
        service.create(
          {
            payment_date: '2026-05-03',
            bank_account_id: 1010,
            total_amount: '60.00',
            allocations: [
              {
                purchase_bill_id: 10,
                amount: '60.00',
              },
            ],
          },
          ACTOR,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('4. Debit Note against a posted bill', () => {
    it('creates and posts debit note against posted bill, debits payable, and prorates credits', async () => {
      const mockPostJournal = vi.fn().mockResolvedValue({
        id: 104,
        journal_number: 'JRN00000104',
      });
      const postingService = { postJournal: mockPostJournal } as any;

      const mockBill = {
        id: 10,
        bill_number: 'BIL00000010',
        vendor_id: 2,
        status: 'posted',
        subtotal: '200.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        lines: [
          {
            id: 1,
            purchase_bill_id: 10,
            account_id: 5000,
            net_amount: '200.00',
            tax_amount: '36.00',
          },
        ],
      };

      const mockDebitNote = {
        id: 1,
        debit_note_number: 'DN00000001',
        purchase_bill_id: 10,
        debit_note_date: '2026-05-04',
        subtotal: '50.00',
        tax_amount: '9.00',
        total_amount: '59.00',
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      };

      const debitNotesRepo = {
        allocateDebitNoteNumber: vi.fn().mockResolvedValue('DN00000001'),
        sumPostedDebitNotesForBill: vi.fn().mockResolvedValue('0.00'),
        sumPostedAllocationsForBill: vi.fn().mockResolvedValue('0.00'),
        insertDebitNote: vi.fn().mockImplementation((row) => ({
          ...mockDebitNote,
          ...row,
        })),
        findById: vi.fn().mockImplementation(() => ({ ...mockDebitNote })),
        updateDebitNote: vi.fn().mockImplementation((id, values) => {
          Object.assign(mockDebitNote, values);
          return { ...mockDebitNote };
        }),
      } as any;

      const billsRepo = {
        findById: vi.fn().mockResolvedValue(mockBill),
        findWithLines: vi.fn().mockResolvedValue(mockBill),
      } as any;

      const accountsRepo = {
        findByControlRole: vi.fn().mockImplementation((role) => {
          if (role === 'ap') return { id: 2000, name: 'Accounts payable', code: '2000' };
          if (role === 'input_tax') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
        findByCode: vi.fn().mockImplementation((code) => {
          if (code === '2000') return { id: 2000, name: 'Accounts payable', code: '2000' };
          if (code === '1300') return { id: 1300, name: 'Input tax', code: '1300' };
          return null;
        }),
      } as any;

      const db = {} as any;
      const paginationHelper = {} as any;

      const service = new DebitNotesService(
        debitNotesRepo,
        billsRepo,
        postingService,
        accountsRepo,
        { findById: vi.fn().mockResolvedValue({ id: 1, rate_percent: '18.00', is_active: true }) } as any,
        db,
        paginationHelper,
      );

      // Create draft debit note
      const created = await service.create(
        {
          purchase_bill_id: 10,
          debit_note_date: '2026-05-04',
          amount: '50.00',
          tax_code_id: 1,
          reason: 'Defective goods returned',
        },
        ACTOR,
      );

      expect(created.status).toBe('draft');
      expect(created.total_amount).toBe('59.00');

      // Post debit note
      const posted = await service.post(1, ACTOR);
      expect(posted.status).toBe('posted');

      // Journal verification
      const call = mockPostJournal.mock.calls[0][0];
      expect(call.sourceType).toBe('debit_note');
      expect(call.sourceId).toBe(1);

      // Debits = 59.00 to AP (2000)
      // Credits = 50.00 to Supplies (5000) + 9.00 to Input Tax (1300)
      const debitLines = call.lines.filter((l: any) => l.debit && Number(l.debit) > 0);
      const creditLines = call.lines.filter((l: any) => l.credit && Number(l.credit) > 0);

      expect(debitLines).toHaveLength(1);
      expect(debitLines[0].accountId).toBe(2000);
      expect(debitLines[0].debit).toBe('59.00');

      expect(creditLines).toHaveLength(2);
      expect(creditLines.find((l: any) => l.accountId === 5000)?.credit).toBe('50.00');
      expect(creditLines.find((l: any) => l.accountId === 1300)?.credit).toBe('9.00');
    });

    it('rejects debit note if amount exceeds open bill balance', async () => {
      const debitNotesRepo = {
        sumPostedDebitNotesForBill: vi.fn().mockResolvedValue('200.00'),
        sumPostedAllocationsForBill: vi.fn().mockResolvedValue('0.00'),
      } as any;

      const billsRepo = {
        findById: vi.fn().mockResolvedValue({
          id: 10,
          bill_number: 'BIL00000010',
          status: 'posted',
          total_amount: '236.00',
        }),
      } as any;

      const service = new DebitNotesService(
        debitNotesRepo,
        billsRepo,
        {} as any,
        {} as any,
        {} as any,
        {} as any,
        {} as any,
      );

      // Remaining balance = 236.00 - 200.00 = 36.00
      // Requesting 40.00 subtotal + 0 tax = 40.00 exceeds 36.00 open balance!
      await expect(
        service.create(
          {
            purchase_bill_id: 10,
            debit_note_date: '2026-05-04',
            amount: '40.00',
          },
          ACTOR,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });
});
