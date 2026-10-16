import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Account, RevenueRecognitionSchedule, TaxCode, TaxCodeComponent } from '../platform/db/schema/accounting';
import type { Payment, PaymentHistory } from '../platform/db/schema/payments';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { roundMoney, subMoney } from '../platform/money/money';
import { RevenueRecognitionPortService } from './revenue-recognition-port.service';
import { SalesBridgeService } from './sales-bridge.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const ACCOUNTS: Record<string, Account> = {
  '1000': {
    id: 1000,
    name: 'Cash',
    account_type: 'asset',
    parent_id: null,
    is_active: true,
    is_bank: true,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '1010': {
    id: 1010,
    name: 'Bank',
    account_type: 'asset',
    parent_id: null,
    is_active: true,
    is_bank: true,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '1020': {
    id: 1020,
    name: 'Card/UPI clearing',
    account_type: 'asset',
    parent_id: null,
    is_active: true,
    is_bank: true,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '1100': {
    id: 1100,
    name: 'Accounts receivable',
    account_type: 'asset',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'ar',
    created_at: new Date(),
    updated_at: null,
  },
  '2100': {
    id: 2100,
    name: 'Output CGST',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'output_cgst',
    created_at: new Date(),
    updated_at: null,
  },
  '2110': {
    id: 2110,
    name: 'Output SGST',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'output_sgst',
    created_at: new Date(),
    updated_at: null,
  },
  '2200': {
    id: 2200,
    name: 'Unearned membership revenue',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'unearned_membership',
    created_at: new Date(),
    updated_at: null,
  },
  '2210': {
    id: 2210,
    name: 'Unearned PT revenue',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'unearned_pt',
    created_at: new Date(),
    updated_at: null,
  },
  '4000': {
    id: 4000,
    name: 'Membership revenue',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '4100': {
    id: 4100,
    name: 'Personal training revenue',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '4200': {
    id: 4200,
    name: 'Other sales',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '4300': {
    id: 4300,
    name: 'Forfeited membership income',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '4900': {
    id: 4900,
    name: 'Sales discounts',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'discounts',
    created_at: new Date(),
    updated_at: null,
  },
  '5950': {
    id: 5950,
    name: 'Rounding off',
    account_type: 'expense',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
};

const GST_18: TaxCode = {
  id: 1,
  name: 'GST 18%',
  code: 'gst_18',
  rate_percent: '18.00',
  is_active: true,
};

const GST_COMPONENTS: TaxCodeComponent[] = [
  { id: 1, tax_code_id: 1, name: 'CGST', rate_percent: '9.00', output_account_id: 2100, input_account_id: 1300 },
  { id: 2, tax_code_id: 1, name: 'SGST', rate_percent: '9.00', output_account_id: 2110, input_account_id: 1300 },
];

function makePayment(overrides?: Partial<Payment>): Payment {
  return {
    id: 10,
    invoice_number: 'INV-2026-00010',
    member_id: 1,
    membership_id: 100,
    pt_subscription_id: null,
    payment_method_id: 1,
    subtotal: '1000.00',
    discount_amount: '100.00',
    tax_amount: '162.00', // taxable is 900.00; 18% = 162.00 (CGST 81.00, SGST 81.00)
    total_amount: '1062.00',
    amount_paid: '0.00',
    status: 'pending',
    transaction_reference: null,
    cashier_user_id: 2,
    payment_date: new Date('2026-04-15T10:00:00Z'),
    row_version: 1,
    created_at: new Date(),
    updated_at: null,
    ...overrides,
  };
}

describe('Member Sales Bridge & Revenue Recognition (ACC-056)', () => {
  let salesBridge: SalesBridgeService;
  let recognitionPort: RevenueRecognitionPortService;
  let postingService: { postJournal: ReturnType<typeof vi.fn> };
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let taxCodesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let creditNotesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let revenueRecognitionRepository: {
    insertSchedule: ReturnType<typeof vi.fn>;
    findByPaymentId: ReturnType<typeof vi.fn>;
    updateSchedule: ReturnType<typeof vi.fn>;
    findByMembershipId: ReturnType<typeof vi.fn>;
    findByPtSubscriptionId: ReturnType<typeof vi.fn>;
  };
  let settingsService: Record<string, ReturnType<typeof vi.fn>>;
  let dbMock: any;

  beforeEach(() => {
    postingService = {
      postJournal: vi.fn().mockImplementation(async (input) => ({
        id: 501,
        journal_number: 'JRN00000501',
        ...input,
      })),
    };

    accountsRepository = {
      findByControlRole: vi.fn().mockImplementation(async (role: string) =>
        Object.values(ACCOUNTS).find((a) => a.control_role === role) ?? null),
      findByName: vi.fn().mockImplementation(async (name: string) =>
        Object.values(ACCOUNTS).find((a) => a.name === name) ?? null),
    };

    taxCodesRepository = {
      findByCode: vi.fn().mockImplementation(async (code: string) => (code === 'gst_18' ? GST_18 : null)),
      listComponents: vi.fn().mockResolvedValue(GST_COMPONENTS),
    };

    creditNotesRepository = {
      allocateCreditNoteNumber: vi.fn().mockResolvedValue('CN00000001'),
      insertCreditNote: vi.fn().mockImplementation(async (row) => ({ id: 55, ...row })),
      updateCreditNote: vi.fn().mockImplementation(async (id, row) => ({ id, ...row })),
      findByPaymentId: vi.fn().mockResolvedValue([]),
    };

    revenueRecognitionRepository = {
      insertSchedule: vi.fn().mockImplementation(async (row) => ({ id: 88, ...row })),
      findByPaymentId: vi.fn().mockResolvedValue(null),
      updateSchedule: vi.fn().mockImplementation(async (id, row) => ({ id, ...row })),
      findByMembershipId: vi.fn().mockResolvedValue([]),
      findByPtSubscriptionId: vi.fn().mockResolvedValue([]),
    };

    settingsService = {
      getSetting: vi.fn().mockImplementation(async (key: string) => {
        if (key === 'accounting.posting_enabled') return 'true';
        if (key === 'accounting.default_tax_code') return 'gst_18';
        return null;
      }),
    };

    dbMock = {
      select: vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([]),
          }),
        }),
      }),
    };

    salesBridge = new SalesBridgeService(
      postingService as any,
      {} as any,
      accountsRepository as any,
      taxCodesRepository as any,
      creditNotesRepository as any,
      revenueRecognitionRepository as any,
      settingsService as any,
      dbMock as any,
    );

    recognitionPort = new RevenueRecognitionPortService(
      revenueRecognitionRepository as any,
      postingService as any,
      accountsRepository as any,
      dbMock as any,
      settingsService as any,
    );
  });

  describe('1. Balanced Membership Invoice Insert (ACC-051 & ACC-055)', () => {
    it('posts balanced sales_invoice journal and inserts revenue recognition schedule', async () => {
      const payment = makePayment({
        membership_id: 100,
        subtotal: '1000.00',
        discount_amount: '100.00',
        tax_amount: '162.00',
        total_amount: '1062.00',
      });

      // Mock membership lookup for term dates
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([
              { startDate: '2026-05-01', endDate: '2026-07-31', productId: 10 },
            ]),
          }),
        }),
      });
      // Mock membershipProducts lookup for income account (none -> defaults to 4000)
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([{ incomeAccountId: null }]),
          }),
        }),
      });

      await salesBridge.onInvoiceCreated(payment);

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postArgs = postingService.postJournal.mock.calls[0][0];

      expect(postArgs.sourceType).toBe('sales_invoice');
      expect(postArgs.sourceId).toBe(payment.id);
      expect(postArgs.entryDate).toBe('2026-04-15');

      // Verify lines: Debit 1100 AR (1062.00), Debit 4900 Discounts (100.00),
      // Credit 2200 Unearned (1000.00), Credit 2100 CGST (81.00), Credit 2110 SGST (81.00)
      const lines = postArgs.lines;
      const totalDebit = lines.reduce((sum: number, l: any) => sum + (l.debit ? parseFloat(l.debit) : 0), 0);
      const totalCredit = lines.reduce((sum: number, l: any) => sum + (l.credit ? parseFloat(l.credit) : 0), 0);
      expect(totalDebit).toBeCloseTo(1162.00, 2);
      expect(totalCredit).toBeCloseTo(1162.00, 2);
      expect(totalDebit).toEqual(totalCredit);

      // Verify schedule creation
      expect(revenueRecognitionRepository.insertSchedule).toHaveBeenCalledTimes(1);
      const scheduleInput = revenueRecognitionRepository.insertSchedule.mock.calls[0][0];
      expect(scheduleInput).toEqual(
        expect.objectContaining({
          payment_id: payment.id,
          unearned_account_id: 2200,
          income_account_id: 4000,
          total_amount: '1000.00',
          starts_on: '2026-05-01',
          ends_on: '2026-07-31',
          recognized_through: '2026-04-30', // day before term start
          status: 'open',
        }),
      );
    });
  });

  describe('2. PT Invoice Insert (ACC-051 & ACC-055)', () => {
    it('credits 2210 unearned PT and inserts schedule with 2210 and 4100', async () => {
      const payment = makePayment({
        membership_id: null,
        pt_subscription_id: 40,
        subtotal: '5000.00',
        discount_amount: '0.00',
        tax_amount: '900.00',
        total_amount: '5900.00',
      });

      // PT lookup
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([
              { startDate: '2026-06-01', endDate: '2026-08-31', ptProductId: 5 },
            ]),
          }),
        }),
      });
      // ptProducts lookup
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([{ incomeAccountId: null }]),
          }),
        }),
      });

      await salesBridge.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const unearnedLine = postArgs.lines.find((l: any) => l.accountId === 2210);
      expect(unearnedLine).toBeDefined();
      expect(unearnedLine.credit).toBe('5000.00');

      const scheduleInput = revenueRecognitionRepository.insertSchedule.mock.calls[0][0];
      expect(scheduleInput.unearned_account_id).toBe(2210);
      expect(scheduleInput.income_account_id).toBe(4100);
      expect(scheduleInput.total_amount).toBe('5000.00');
      expect(scheduleInput.recognized_through).toBe('2026-05-31');
    });
  });

  describe('3. Standard Direct Sale Invoice (ACC-051)', () => {
    it('credits 4200 other sales and does not create recognition schedule', async () => {
      const payment = makePayment({
        membership_id: null,
        pt_subscription_id: null,
        subtotal: '200.00',
        discount_amount: '0.00',
        tax_amount: '36.00',
        total_amount: '236.00',
      });

      await salesBridge.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const salesLine = postArgs.lines.find((l: any) => l.accountId === 4200);
      expect(salesLine).toBeDefined();
      expect(salesLine.credit).toBe('200.00');
      expect(revenueRecognitionRepository.insertSchedule).not.toHaveBeenCalled();
    });
  });

  describe('4. Tax Rounding Gap to 5950 (ACC-056)', () => {
    it('posts tax rounding gap between stored tax and split components to 5950 Rounding off', async () => {
      // Payment has stored tax_amount of 163.00, while recomputed CGST (81.00) + SGST (81.00) = 162.00
      // Rounding gap = 163.00 - 162.00 = +1.00 rupee
      const payment = makePayment({
        membership_id: null,
        pt_subscription_id: null,
        subtotal: '1000.00',
        discount_amount: '100.00',
        tax_amount: '163.00', // 1 rupee gap
        total_amount: '1063.00',
      });

      await salesBridge.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const roundingLine = postArgs.lines.find((l: any) => l.accountId === 5950);
      expect(roundingLine).toBeDefined();
      expect(roundingLine.credit).toBe('1.00');

      // Verify entire entry balances:
      // Debits: AR 1063.00 + Discount 100.00 = 1163.00
      // Credits: 4200 (1000.00) + CGST (81.00) + SGST (81.00) + Rounding (1.00) = 1163.00
      const totalDebit = postArgs.lines.reduce((sum: number, l: any) => sum + (l.debit ? parseFloat(l.debit) : 0), 0);
      const totalCredit = postArgs.lines.reduce((sum: number, l: any) => sum + (l.credit ? parseFloat(l.credit) : 0), 0);
      expect(totalDebit).toBeCloseTo(1163.00, 2);
      expect(totalCredit).toBeCloseTo(1163.00, 2);
    });
  });

  describe('5. Collection on payment_received (ACC-052)', () => {
    it('debits payment method account and credits 1100 accounts receivable', async () => {
      const payment = makePayment({ total_amount: '1000.00' });
      const history: PaymentHistory = {
        id: 701,
        payment_id: payment.id,
        payment_method_id: 2,
        action: 'payment_received',
        amount: '1000.00',
        timestamp: new Date('2026-04-16T12:00:00Z'),
        notes: null,
      };

      // Mock payment method 2 mapped to 1010 Bank
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([
              { id: 2, methodName: 'Bank Transfer', accountId: 1010 },
            ]),
          }),
        }),
      });

      await salesBridge.onPaymentReceived(history, payment);

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('sales_receipt');
      expect(postArgs.sourceId).toBe(history.id);
      expect(postArgs.entryDate).toBe('2026-04-16');

      expect(postArgs.lines).toEqual([
        {
          accountId: 1010,
          debit: '1000.00',
          memberId: payment.member_id,
          memo: 'Receipt tender via Bank Transfer for INV-2026-00010',
        },
        {
          accountId: 1100,
          credit: '1000.00',
          memberId: payment.member_id,
          memo: 'Collection for INV-2026-00010',
        },
      ]);
    });
  });

  describe('6. Collection Failure on Unmapped Payment Method (ACC-052)', () => {
    it('throws BusinessRuleError when payment method has no account_id and posting is enabled', async () => {
      const payment = makePayment();
      const history: PaymentHistory = {
        id: 702,
        payment_id: payment.id,
        payment_method_id: 3,
        action: 'payment_received',
        amount: '500.00',
        timestamp: new Date(),
        notes: null,
      };

      // Method with no accountId
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([
              { id: 3, methodName: 'Crypto', accountId: null },
            ]),
          }),
        }),
      });

      await expect(salesBridge.onPaymentReceived(history, payment)).rejects.toThrow(
        BusinessRuleError,
      );
      await expect(salesBridge.onPaymentReceived(history, payment)).rejects.toThrow(
        /Payment method has no linked account_id/i,
      );
    });
  });

  describe('7. Full Refund Credit Note (ACC-053)', () => {
    it('posts credit note, debits unearned and tax, credits bank, and shrinks schedule', async () => {
      const payment = makePayment({
        membership_id: 100,
        subtotal: '1000.00',
        tax_amount: '180.00',
        total_amount: '1180.00',
        amount_paid: '1180.00', // fully collected
      });

      const history: PaymentHistory = {
        id: 801,
        payment_id: payment.id,
        payment_method_id: 1,
        action: 'refunded',
        amount: '1180.00', // full refund
        timestamp: new Date('2026-05-10T14:00:00Z'),
        notes: null,
      };

      // Existing open schedule of 1000.00
      const schedule: RevenueRecognitionSchedule = {
        id: 99,
        payment_id: payment.id,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '1000.00',
        recognized_amount: '0.00',
        starts_on: '2026-05-01',
        ends_on: '2026-07-31',
        recognized_through: '2026-04-30',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByPaymentId.mockResolvedValue(schedule);

      // Method 1 mapped to 1000 Cash
      dbMock.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValueOnce({
          where: vi.fn().mockReturnValueOnce({
            limit: vi.fn().mockResolvedValueOnce([
              { id: 1, methodName: 'Cash', accountId: 1000 },
            ]),
          }),
        }),
      });

      const result = await salesBridge.onRefund(payment, history, { paymentMethodId: 1 });
      expect(result).not.toBeNull();
      expect(result!.creditNote.credit_note_number).toBe('CN00000001');

      // Schedule should be shrunk to 0.00 and closed
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(99, {
        total_amount: '0.00',
        status: 'closed',
      });

      // Journal debits unearned (1000) + CGST (90) + SGST (90), credits Cash (1180)
      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('credit_note');
      expect(postArgs.sourceId).toBe(result!.creditNote.id);
      const creditLine = postArgs.lines.find((l: any) => l.accountId === 1000);
      expect(creditLine).toBeDefined();
      expect(creditLine.credit).toBe('1180.00');
    });
  });

  describe('8. Adjustments Up and Down (ACC-057)', () => {
    it('adjustment increase posts sales_adjustment journal and grows schedule', async () => {
      const payment = makePayment({
        membership_id: 100,
        subtotal: '1000.00',
        tax_amount: '180.00',
        total_amount: '1180.00',
      });
      const history: PaymentHistory = {
        id: 901,
        payment_id: payment.id,
        payment_method_id: null,
        action: 'adjusted',
        amount: '236.00', // +236.00 adjustment
        timestamp: new Date('2026-05-01T10:00:00Z'),
        notes: null,
      };

      const schedule: RevenueRecognitionSchedule = {
        id: 99,
        payment_id: payment.id,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '1000.00',
        recognized_amount: '0.00',
        starts_on: '2026-05-01',
        ends_on: '2026-07-31',
        recognized_through: '2026-04-30',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByPaymentId.mockResolvedValue(schedule);

      await salesBridge.onAdjustment(payment, history, {
        adjustmentAmount: '236.00',
        newTotal: '1416.00',
      });

      // Grows schedule by net share (200.00 net -> new total 1200.00)
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(
        99,
        expect.objectContaining({
          total_amount: '1200.00',
        }),
      );

      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('sales_adjustment');
      expect(postArgs.sourceId).toBe(history.id);
      // Debits AR 236.00, credits Unearned 200.00, credits CGST 18.00, SGST 18.00
      const arLine = postArgs.lines.find((l: any) => l.accountId === 1100);
      expect(arLine.debit).toBe('236.00');
    });

    it('adjustment decrease rejects when decrease exceeds unrecognized balance', async () => {
      const payment = makePayment({
        membership_id: 100,
        subtotal: '1000.00',
        tax_amount: '180.00',
        total_amount: '1180.00',
      });
      const history: PaymentHistory = {
        id: 902,
        payment_id: payment.id,
        payment_method_id: null,
        action: 'adjusted',
        amount: '-800.00',
        timestamp: new Date(),
        notes: null,
      };

      // Only 50.00 unrecognized remaining on schedule
      const schedule: RevenueRecognitionSchedule = {
        id: 99,
        payment_id: payment.id,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '1000.00',
        recognized_amount: '950.00', // unrecognized = 50.00
        starts_on: '2026-05-01',
        ends_on: '2026-07-31',
        recognized_through: '2026-07-15',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByPaymentId.mockResolvedValue(schedule);

      await expect(
        salesBridge.onAdjustment(payment, history, {
          adjustmentAmount: '-800.00',
          newTotal: '380.00',
        }),
      ).rejects.toThrow(BusinessRuleError);
      await expect(
        salesBridge.onAdjustment(payment, history, {
          adjustmentAmount: '-800.00',
          newTotal: '380.00',
        }),
      ).rejects.toThrow(/Adjustment decrease exceeds unrecognized balance/);
    });
  });

  describe('9. Freeze & Extend Lifecycle Port (ACC-058)', () => {
    it('freeze approved pauses schedule and freeze ended reopens and extends ends_on', async () => {
      const schedule: RevenueRecognitionSchedule = {
        id: 77,
        payment_id: 10,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '6000.00',
        recognized_amount: '2000.00',
        starts_on: '2026-01-01',
        ends_on: '2026-06-30',
        recognized_through: '2026-02-28',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      // Freeze approved
      await recognitionPort.onFreezeApproved({
        membershipId: 100,
        freezeStartDate: '2026-03-01',
      });
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(77, {
        status: 'paused',
        paused_from: '2026-03-01',
      });

      // Freeze ended
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([
        { ...schedule, status: 'paused', paused_from: '2026-03-01' },
      ]);
      await recognitionPort.onFreezeEnded({
        membershipId: 100,
        newEndDate: '2026-07-31',
      });
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(77, {
        status: 'open',
        ends_on: '2026-07-31',
        paused_from: null,
      });
    });

    it('extension moves ends_on to new end date', async () => {
      const schedule: RevenueRecognitionSchedule = {
        id: 77,
        payment_id: 10,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '6000.00',
        recognized_amount: '2000.00',
        starts_on: '2026-01-01',
        ends_on: '2026-06-30',
        recognized_through: '2026-02-28',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await recognitionPort.onMembershipExtended({
        membershipId: 100,
        newEndDate: '2026-08-31',
      });
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(77, {
        ends_on: '2026-08-31',
      });
    });
  });

  describe('10. Cancellation Forfeiture (ACC-059)', () => {
    it('forfeits remaining unearned amount to 4300 and zeroes unearned balance on schedule', async () => {
      // Total 6000, recognized 2000, unearned remaining = 4000
      const schedule: RevenueRecognitionSchedule = {
        id: 77,
        payment_id: 10,
        unearned_account_id: 2200,
        income_account_id: 4000,
        total_amount: '6000.00',
        recognized_amount: '2000.00',
        starts_on: '2026-01-01',
        ends_on: '2026-06-30',
        recognized_through: '2026-02-28',
        status: 'open',
        paused_from: null,
      };
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await recognitionPort.onMembershipCancelled({
        membershipId: 100,
        cancelledByUserId: 1,
        cancelDate: '2026-03-15',
      });

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('recognition_forfeit');
      expect(postArgs.sourceId).toBe(77);
      expect(postArgs.entryDate).toBe('2026-03-15');
      expect(postArgs.lines).toEqual([
        {
          accountId: 2200,
          debit: '4000.00',
          memo: 'Forfeit unearned balance schedule #77',
        },
        {
          accountId: 4300,
          credit: '4000.00',
          memo: 'Forfeited income from cancelled membership #100',
        },
      ]);

      // Schedule closed with unearned at zero (total_amount = recognized_amount = 2000.00)
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(77, {
        status: 'closed',
        total_amount: '2000.00',
      });
    });
  });

  describe('11. Disabled Posting No-Op Guarantee', () => {
    beforeEach(() => {
      settingsService.getSetting.mockResolvedValue('false');
    });

    it('strictly no-ops on invoice insert, payment received, refund, freeze, extend, cancel', async () => {
      const payment = makePayment();
      const history: PaymentHistory = {
        id: 999,
        payment_id: payment.id,
        payment_method_id: 1,
        action: 'payment_received',
        amount: '1000.00',
        timestamp: new Date(),
        notes: null,
      };

      const resInvoice = await salesBridge.onInvoiceCreated(payment);
      expect(resInvoice).toBeNull();

      const resPayment = await salesBridge.onPaymentReceived(history, payment);
      expect(resPayment).toBeNull();

      const resRefund = await salesBridge.onRefund(payment, history);
      expect(resRefund).toBeNull();

      await recognitionPort.onFreezeApproved({ membershipId: 1, freezeStartDate: '2026-05-01' });
      await recognitionPort.onFreezeEnded({ membershipId: 1, newEndDate: '2026-08-31' });
      await recognitionPort.onMembershipExtended({ membershipId: 1, newEndDate: '2026-09-30' });
      await recognitionPort.onMembershipCancelled({ membershipId: 1 });

      expect(postingService.postJournal).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.insertSchedule).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).not.toHaveBeenCalled();
    });
  });
});
