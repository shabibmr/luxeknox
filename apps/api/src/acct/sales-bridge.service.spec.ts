import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Account, TaxCode, TaxCodeComponent } from '../platform/db/schema/accounting';
import type { Payment, PaymentHistory } from '../platform/db/schema/payments';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { SalesBridgeService } from './sales-bridge.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const ACCOUNTS: Record<string, Account> = {
  '1000': { id: 1000, name: 'Cash', account_type: 'asset', parent_id: null, is_active: true, is_bank: true, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
  '1010': { id: 1010, name: 'Bank', account_type: 'asset', parent_id: null, is_active: true, is_bank: true, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
  '1100': { id: 1100, name: 'Accounts receivable', account_type: 'asset', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'ar', created_at: new Date(), updated_at: null },
  '2100': { id: 2100, name: 'Output CGST', account_type: 'liability', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'output_cgst', created_at: new Date(), updated_at: null },
  '2110': { id: 2110, name: 'Output SGST', account_type: 'liability', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'output_sgst', created_at: new Date(), updated_at: null },
  '2200': { id: 2200, name: 'Unearned membership revenue', account_type: 'liability', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'unearned_membership', created_at: new Date(), updated_at: null },
  '2210': { id: 2210, name: 'Unearned PT revenue', account_type: 'liability', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'unearned_pt', created_at: new Date(), updated_at: null },
  '4000': { id: 4000, name: 'Membership revenue', account_type: 'income', parent_id: null, is_active: true, is_bank: false, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
  '4100': { id: 4100, name: 'Personal training revenue', account_type: 'income', parent_id: null, is_active: true, is_bank: false, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
  '4200': { id: 4200, name: 'Other sales', account_type: 'income', parent_id: null, is_active: true, is_bank: false, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
  '4900': { id: 4900, name: 'Sales discounts', account_type: 'income', parent_id: null, is_active: true, is_bank: false, is_control: true, control_role: 'discounts', created_at: new Date(), updated_at: null },
  '5950': { id: 5950, name: 'Rounding off', account_type: 'expense', parent_id: null, is_active: true, is_bank: false, is_control: false, control_role: null, created_at: new Date(), updated_at: null },
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

describe('SalesBridgeService', () => {
  let service: SalesBridgeService;
  let postingService: { postJournal: ReturnType<typeof vi.fn> };
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let taxCodesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let creditNotesRepository: Record<string, ReturnType<typeof vi.fn>>;
  let revenueRecognitionRepository: Record<string, ReturnType<typeof vi.fn>>;
  let settingsService: Record<string, ReturnType<typeof vi.fn>>;
  let dbMock: any;

  beforeEach(() => {
    postingService = {
      postJournal: vi.fn().mockImplementation(async (input) => ({
        id: 777,
        journal_number: 'JRN00000001',
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

    service = new SalesBridgeService(
      postingService as any,
      {} as any,
      accountsRepository as any,
      taxCodesRepository as any,
      creditNotesRepository as any,
      revenueRecognitionRepository as any,
      settingsService as any,
      dbMock,
    );
  });

  describe('ACC-050: Disabled posting', () => {
    it('is a no-op when accounting.posting_enabled is false', async () => {
      settingsService.getSetting = vi.fn().mockResolvedValue('false');

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '118.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      const result = await service.onInvoiceCreated(payment);
      expect(result).toBeNull();
      expect(postingService.postJournal).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.insertSchedule).not.toHaveBeenCalled();

      const history: PaymentHistory = {
        id: 1,
        payment_id: 1,
        payment_method_id: 1,
        action: 'payment_received',
        amount: '118.00',
        notes: null,
        timestamp: new Date('2026-05-01T00:00:00.000Z'),
      };

      const collResult = await service.onPaymentReceived(history, payment);
      expect(collResult).toBeNull();

      const refResult = await service.onRefund(payment, { ...history, action: 'refunded' });
      expect(refResult).toBeNull();
      expect(creditNotesRepository.insertCreditNote).not.toHaveBeenCalled();

      const adjResult = await service.onAdjustment(payment, { ...history, action: 'adjusted' }, {
        adjustmentAmount: '10.00',
        newTotal: '128.00',
      });
      expect(adjResult).toBeNull();
    });
  });

  describe('ACC-051 & ACC-055: On invoice insert', () => {
    it('posts journal for membership sale with discount and creates recognition schedule', async () => {
      // Mock membership lookup in DB
      dbMock.select = vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockImplementation(async () => [
              { startDate: '2026-06-01', endDate: '2026-06-30', productId: 1 },
            ]),
          }),
        }),
      });

      const payment: Payment = {
        id: 42,
        invoice_number: 'INV00000042',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '10.00',
        tax_amount: '16.20', // (100 - 10) * 18% = 16.20 (CGST 8.10, SGST 8.10)
        total_amount: '106.20',
        amount_paid: '106.20',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-06-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-06-01T00:00:00.000Z'),
        updated_at: new Date('2026-06-01T00:00:00.000Z'),
      };

      const journal = await service.onInvoiceCreated(payment);
      expect(journal).toBeDefined();

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('sales_invoice');
      expect(postArgs.sourceId).toBe(42);
      expect(postArgs.entryDate).toBe('2026-06-01');

      // Lines verification:
      // Debit: AR 1100 = 106.20
      // Debit: Discount 4900 = 10.00
      // Credit: Unearned Membership 2200 = 100.00
      // Credit: CGST 2100 = 8.10
      // Credit: SGST 2110 = 8.10
      const arLine = postArgs.lines.find((l: any) => l.accountId === 1100);
      expect(arLine).toEqual(expect.objectContaining({ debit: '106.20', memberId: 10 }));

      const discountLine = postArgs.lines.find((l: any) => l.accountId === 4900);
      expect(discountLine).toEqual(expect.objectContaining({ debit: '10.00', memberId: 10 }));

      const unearnedLine = postArgs.lines.find((l: any) => l.accountId === 2200);
      expect(unearnedLine).toEqual(expect.objectContaining({ credit: '100.00', memberId: 10 }));

      const cgstLine = postArgs.lines.find((l: any) => l.accountId === 2100);
      expect(cgstLine).toEqual(expect.objectContaining({ credit: '8.10' }));

      const sgstLine = postArgs.lines.find((l: any) => l.accountId === 2110);
      expect(sgstLine).toEqual(expect.objectContaining({ credit: '8.10' }));

      // ACC-055: recognition schedule
      expect(revenueRecognitionRepository.insertSchedule).toHaveBeenCalledWith(
        expect.objectContaining({
          payment_id: 42,
          unearned_account_id: 2200,
          income_account_id: 4000,
          total_amount: '100.00',
          recognized_amount: '0.00',
          starts_on: '2026-06-01',
          ends_on: '2026-06-30',
          recognized_through: '2026-05-31',
          status: 'open',
        }),
      );
    });

    it('credits 2210 Unearned PT when pt_subscription_id is set and membership_id is null', async () => {
      dbMock.select = vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockImplementation(async () => [
              { startDate: '2026-07-01', endDate: '2026-07-31', ptProductId: 2 },
            ]),
          }),
        }),
      });

      const payment: Payment = {
        id: 50,
        invoice_number: 'INV00000050',
        member_id: 11,
        membership_id: null,
        pt_subscription_id: 7,
        payment_method_id: 1,
        subtotal: '200.00',
        discount_amount: '0.00',
        tax_amount: '36.00',
        total_amount: '236.00',
        amount_paid: '236.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-07-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-07-01T00:00:00.000Z'),
        updated_at: new Date('2026-07-01T00:00:00.000Z'),
      };

      await service.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const unearnedPtLine = postArgs.lines.find((l: any) => l.accountId === 2210);
      expect(unearnedPtLine).toEqual(expect.objectContaining({ credit: '200.00' }));

      expect(revenueRecognitionRepository.insertSchedule).toHaveBeenCalledWith(
        expect.objectContaining({
          payment_id: 50,
          unearned_account_id: 2210,
          income_account_id: 4100,
          total_amount: '200.00',
          starts_on: '2026-07-01',
          ends_on: '2026-07-31',
          recognized_through: '2026-06-30',
        }),
      );
    });

    it('credits 4200 Other sales when neither membership nor PT is set and does not insert schedule', async () => {
      const payment: Payment = {
        id: 60,
        invoice_number: 'INV00000060',
        member_id: 12,
        membership_id: null,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '50.00',
        discount_amount: '0.00',
        tax_amount: '9.00',
        total_amount: '59.00',
        amount_paid: '59.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-08-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-08-01T00:00:00.000Z'),
        updated_at: new Date('2026-08-01T00:00:00.000Z'),
      };

      await service.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const otherSalesLine = postArgs.lines.find((l: any) => l.accountId === 4200);
      expect(otherSalesLine).toEqual(expect.objectContaining({ credit: '50.00' }));
      expect(revenueRecognitionRepository.insertSchedule).not.toHaveBeenCalled();
    });
  });

  describe('ACC-056: Tax rounding gap', () => {
    it('posts rounding gap difference to 5950 Rounding off and spec verifies amount', async () => {
      // Subtotal 100.05, 18% = 18.009 -> 18.01.
      // CGST 9% on 100.05 = 9.0045 -> 9.00.
      // SGST 9% on 100.05 = 9.0045 -> 9.00.
      // Sum components = 18.00, but payment.tax_amount = 18.01. Gap = +0.01!
      const payment: Payment = {
        id: 70,
        invoice_number: 'INV00000070',
        member_id: 15,
        membership_id: 8,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.05',
        discount_amount: '0.00',
        tax_amount: '18.01',
        total_amount: '118.06',
        amount_paid: '118.06',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-09-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-09-01T00:00:00.000Z'),
        updated_at: new Date('2026-09-01T00:00:00.000Z'),
      };

      await service.onInvoiceCreated(payment);

      const postArgs = postingService.postJournal.mock.calls[0][0];
      const roundingLine = postArgs.lines.find((l: any) => l.accountId === 5950);
      expect(roundingLine).toBeDefined();
      expect(roundingLine).toEqual(expect.objectContaining({ credit: '0.01' }));

      // Verify total debits equal total credits
      const debits = postArgs.lines.reduce((sum: number, l: any) => sum + (l.debit ? Number(l.debit) : 0), 0);
      const credits = postArgs.lines.reduce((sum: number, l: any) => sum + (l.credit ? Number(l.credit) : 0), 0);
      expect(debits.toFixed(2)).toBe(credits.toFixed(2));
      expect(debits.toFixed(2)).toBe('118.06');
    });
  });

  describe('ACC-052: On collection (payment_received)', () => {
    it('throws BusinessRuleError when payment method has no linked account_id', async () => {
      // Mock payment method with null account_id
      dbMock.select = vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([{ id: 1, accountId: null, methodName: 'Cash' }]),
          }),
        }),
      });

      const history: PaymentHistory = {
        id: 10,
        payment_id: 1,
        payment_method_id: 1,
        action: 'payment_received',
        amount: '100.00',
        notes: null,
        timestamp: new Date('2026-05-01T00:00:00.000Z'),
      };

      const payment = { id: 1, invoice_number: 'INV00000001', member_id: 10 } as Payment;

      await expect(service.onPaymentReceived(history, payment)).rejects.toThrow(
        new BusinessRuleError('Payment method has no linked account_id'),
      );
    });

    it('debits method bank/cash account and credits 1100 AR', async () => {
      dbMock.select = vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([{ id: 1, accountId: 1000, methodName: 'Cash' }]),
          }),
        }),
      });

      const history: PaymentHistory = {
        id: 12,
        payment_id: 1,
        payment_method_id: 1,
        action: 'payment_received',
        amount: '118.00',
        notes: null,
        timestamp: new Date('2026-05-01T00:00:00.000Z'),
      };

      const payment = { id: 1, invoice_number: 'INV00000001', member_id: 10 } as Payment;

      const journal = await service.onPaymentReceived(history, payment);
      expect(journal).toBeDefined();

      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('sales_receipt');
      expect(postArgs.sourceId).toBe(12);

      const cashLine = postArgs.lines.find((l: any) => l.accountId === 1000);
      expect(cashLine).toEqual(expect.objectContaining({ debit: '118.00' }));

      const arLine = postArgs.lines.find((l: any) => l.accountId === 1100);
      expect(arLine).toEqual(expect.objectContaining({ credit: '118.00' }));
    });
  });

  describe('ACC-053: On refund (refunded)', () => {
    it('writes and posts credit note, splits net/tax, credits refund payment method, and shrinks schedule', async () => {
      // Mock payment method
      dbMock.select = vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([{ id: 2, accountId: 1010 }]),
          }),
        }),
      });

      // Mock existing recognition schedule
      revenueRecognitionRepository.findByPaymentId = vi.fn().mockResolvedValue({
        id: 99,
        payment_id: 1,
        total_amount: '100.00',
        recognized_amount: '0.00',
        status: 'open',
      });

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '118.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      // Half refund: 59.00
      const history: PaymentHistory = {
        id: 15,
        payment_id: 1,
        payment_method_id: 2,
        action: 'refunded',
        amount: '59.00',
        notes: 'Member requested half refund',
        timestamp: new Date('2026-05-15T00:00:00.000Z'),
      };

      const result = await service.onRefund(payment, history, { paymentMethodId: 2 });
      expect(result).toBeDefined();

      expect(creditNotesRepository.allocateCreditNoteNumber).toHaveBeenCalled();
      expect(creditNotesRepository.insertCreditNote).toHaveBeenCalledWith(
        expect.objectContaining({
          credit_note_number: 'CN00000001',
          payment_id: 1,
          total_amount: '59.00',
          subtotal: '50.00',
          tax_amount: '9.00',
          status: 'posted',
        }),
      );

      // Schedule shrunk from 100.00 to 50.00
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(99, {
        total_amount: '50.00',
        status: 'open',
      });

      // Journal checks:
      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('credit_note');
      expect(postArgs.sourceId).toBe(55);

      // Debit unearned 2200 = 50.00
      const unearnedLine = postArgs.lines.find((l: any) => l.accountId === 2200);
      expect(unearnedLine).toEqual(expect.objectContaining({ debit: '50.00' }));

      // Debit CGST 2100 = 4.50, SGST 2110 = 4.50
      const cgstLine = postArgs.lines.find((l: any) => l.accountId === 2100);
      expect(cgstLine).toEqual(expect.objectContaining({ debit: '4.50' }));

      // Credit Bank 1010 = 59.00
      const bankLine = postArgs.lines.find((l: any) => l.accountId === 1010);
      expect(bankLine).toEqual(expect.objectContaining({ credit: '59.00' }));
    });

    it('rejects refund when net share exceeds unrecognized balance on schedule', async () => {
      // Schedule has only 20.00 unrecognized (100 total - 80 recognized)
      revenueRecognitionRepository.findByPaymentId = vi.fn().mockResolvedValue({
        id: 99,
        payment_id: 1,
        total_amount: '100.00',
        recognized_amount: '80.00',
        status: 'open',
      });

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '118.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      // Trying to refund 59.00 (net share 50.00 > unrecognized 20.00)
      const history: PaymentHistory = {
        id: 16,
        payment_id: 1,
        payment_method_id: null,
        action: 'refunded',
        amount: '59.00',
        notes: null,
        timestamp: new Date('2026-05-15T00:00:00.000Z'),
      };

      await expect(service.onRefund(payment, history)).rejects.toThrow(
        new BusinessRuleError('Refund exceeds unrecognized balance on schedule'),
      );
    });
  });

  describe('ACC-057: On adjustment (adjusted)', () => {
    it('decrease writes and posts credit note, shrinks schedule, credits AR', async () => {
      revenueRecognitionRepository.findByPaymentId = vi.fn().mockResolvedValue({
        id: 105,
        payment_id: 1,
        total_amount: '100.00',
        recognized_amount: '0.00',
        status: 'open',
      });

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '0.00',
        status: 'pending',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      const history: PaymentHistory = {
        id: 20,
        payment_id: 1,
        payment_method_id: null,
        action: 'adjusted',
        amount: '-23.60',
        notes: 'Price adjustment down by 20 + tax',
        timestamp: new Date('2026-05-05T00:00:00.000Z'),
      };

      const result = await service.onAdjustment(payment, history, {
        adjustmentAmount: '-23.60',
        newTotal: '94.40',
      });
      expect(result?.creditNote).toBeDefined();

      expect(creditNotesRepository.insertCreditNote).toHaveBeenCalledWith(
        expect.objectContaining({
          total_amount: '23.60',
          subtotal: '20.00',
          tax_amount: '3.60',
          status: 'posted',
        }),
      );

      // Schedule shrunk by net share 20.00 (100.00 -> 80.00)
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(105, {
        total_amount: '80.00',
        status: 'open',
      });

      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('credit_note');

      // Credit AR 1100 = 23.60
      const arLine = postArgs.lines.find((l: any) => l.accountId === 1100);
      expect(arLine).toEqual(expect.objectContaining({ credit: '23.60' }));

      // Debit unearned 2200 = 20.00
      const unearnedLine = postArgs.lines.find((l: any) => l.accountId === 2200);
      expect(unearnedLine).toEqual(expect.objectContaining({ debit: '20.00' }));
    });

    it('rejects decrease when net share exceeds unrecognized balance on schedule', async () => {
      revenueRecognitionRepository.findByPaymentId = vi.fn().mockResolvedValue({
        id: 105,
        payment_id: 1,
        total_amount: '100.00',
        recognized_amount: '90.00', // only 10.00 unrecognized
        status: 'open',
      });

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '0.00',
        status: 'pending',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      const history: PaymentHistory = {
        id: 21,
        payment_id: 1,
        payment_method_id: null,
        action: 'adjusted',
        amount: '-23.60', // net share 20.00 > 10.00 unrecognized
        notes: null,
        timestamp: new Date('2026-05-05T00:00:00.000Z'),
      };

      await expect(
        service.onAdjustment(payment, history, {
          adjustmentAmount: '-23.60',
          newTotal: '94.40',
        }),
      ).rejects.toThrow(
        new BusinessRuleError('Adjustment decrease exceeds unrecognized balance on schedule'),
      );
    });

    it('increase posts sales_adjustment journal, grows schedule, debits AR', async () => {
      revenueRecognitionRepository.findByPaymentId = vi.fn().mockResolvedValue({
        id: 105,
        payment_id: 1,
        total_amount: '100.00',
        recognized_amount: '0.00',
        status: 'open',
      });

      const payment: Payment = {
        id: 1,
        invoice_number: 'INV00000001',
        member_id: 10,
        membership_id: 5,
        pt_subscription_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        discount_amount: '0.00',
        tax_amount: '18.00',
        total_amount: '118.00',
        amount_paid: '0.00',
        status: 'pending',
        transaction_reference: null,
        cashier_user_id: 1,
        payment_date: new Date('2026-05-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date('2026-05-01T00:00:00.000Z'),
        updated_at: new Date('2026-05-01T00:00:00.000Z'),
      };

      const history: PaymentHistory = {
        id: 22,
        payment_id: 1,
        payment_method_id: null,
        action: 'adjusted',
        amount: '11.80',
        notes: 'Price adjustment up',
        timestamp: new Date('2026-05-05T00:00:00.000Z'),
      };

      const result = await service.onAdjustment(payment, history, {
        adjustmentAmount: '11.80',
        newTotal: '129.80',
      });
      expect(result?.journal).toBeDefined();

      // Schedule grew by net share 10.00 (100.00 -> 110.00)
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(105, {
        total_amount: '110.00',
        status: 'open',
      });

      const postArgs = postingService.postJournal.mock.calls[0][0];
      expect(postArgs.sourceType).toBe('sales_adjustment');
      expect(postArgs.sourceId).toBe(22);

      // Debit AR 1100 = 11.80
      const arLine = postArgs.lines.find((l: any) => l.accountId === 1100);
      expect(arLine).toEqual(expect.objectContaining({ debit: '11.80' }));

      // Credit unearned 2200 = 10.00
      const unearnedLine = postArgs.lines.find((l: any) => l.accountId === 2200);
      expect(unearnedLine).toEqual(expect.objectContaining({ credit: '10.00' }));
    });
  });
});
