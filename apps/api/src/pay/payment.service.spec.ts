import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  BadRequestError,
  BusinessRuleError,
  NotFoundError,
} from '../platform/errors/app-error';
import { PaymentService } from './payment.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

describe('PaymentService', () => {
  let service: PaymentService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let methodRepository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let membershipRepository: Record<string, ReturnType<typeof vi.fn>>;
  let productRepository: Record<string, ReturnType<typeof vi.fn>>;
  let settingsService: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let domainEventBus: { emit: ReturnType<typeof vi.fn> };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };

  const actor = {
    id: 9,
    email: 'cashier@x.com',
    phoneNumber: null,
    userType: 'employee' as const,
    roleId: 1,
    profileId: 1,
    sessionId: 1,
  };

  const adminActor = { ...actor, userType: 'admin' as const, profileId: null };
  const memberActor = { ...actor, userType: 'member' as const, profileId: 5 };
  const trainerActor = { ...actor, userType: 'trainer' as const, profileId: 7 };

  beforeEach(() => {
    repository = {
      allocateInvoiceNumber: vi.fn().mockResolvedValue('INV00000001'),
      allocateReceiptNumber: vi.fn().mockResolvedValue('RCP00000001'),
      insertPayment: vi.fn().mockImplementation(async (row) => ({ id: 42, ...row })),
      updatePayment: vi.fn().mockImplementation(async (id, values) => ({
        id,
        invoice_number: 'INV00000001',
        member_id: 5,
        membership_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        tax_amount: '18.00',
        discount_amount: '0.00',
        total_amount: '118.00',
        amount_paid: '118.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-01-01T00:00:00.000Z'),
        created_at: new Date('2026-01-01T00:00:00.000Z'),
        updated_at: new Date(),
        ...values,
      })),
      insertHistory: vi.fn().mockImplementation(async (row) => ({ id: 1, ...row })),
      listHistories: vi.fn().mockResolvedValue([]),
      findById: vi.fn(),
      findManyFiltered: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
      findReceiptByPaymentId: vi.fn().mockResolvedValue(null),
      insertReceipt: vi.fn().mockImplementation(async (row) => ({ id: 1, ...row })),
      getRevenueToday: vi.fn().mockResolvedValue({ total_amount: '4500.00', invoice_count: 3 }),
    };
    methodRepository = {
      findById: vi.fn().mockResolvedValue({ id: 1, method_name: 'Cash', is_active: true }),
    };
    memberRepository = {
      findById: vi.fn().mockResolvedValue({ id: 5, user_id: 10, assigned_trainer_id: 7 }),
    };
    membershipRepository = {
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue(null),
      insertMembership: vi.fn().mockResolvedValue(99),
      updateMembership: vi.fn().mockResolvedValue(undefined),
      insertHistory: vi.fn().mockResolvedValue(undefined),
    };
    productRepository = {
      findById: vi.fn().mockResolvedValue({
        id: 3,
        is_active: true,
        duration_days: 30,
        pt_sessions_included: 4,
      }),
    };
    settingsService = {
      getTaxRatePercent: vi.fn().mockResolvedValue('18.00'),
      getPaymentsActivateMembershipOnPartial: vi.fn().mockResolvedValue(false),
    };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    domainEventBus = { emit: vi.fn().mockResolvedValue([]) };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };

    service = new PaymentService(
      repository as any,
      methodRepository as any,
      memberRepository as any,
      membershipRepository as any,
      productRepository as any,
      settingsService as any,
      auditService as any,
      domainEventBus as any,
      paginationHelper as any,
      {} as any,
    );
  });

  it('computes tax on (subtotal - discount)', async () => {
    const totals = await service.computeTotals('100.00', '10.00');
    expect(totals.subtotal).toBe('100.00');
    expect(totals.discount).toBe('10.00');
    expect(totals.tax).toBe('16.20');
    expect(totals.total).toBe('106.20');
  });

  it('rejects discount greater than subtotal', async () => {
    await expect(service.computeTotals('10.00', '11.00')).rejects.toBeInstanceOf(BadRequestError);
  });

  it('creates a paid invoice with single payment_method_id shorthand', async () => {
    const result = await service.create(
      { member_id: 5, subtotal: '100.00', payment_method_id: 1 },
      actor,
    );
    expect(result.invoice_number).toBe('INV00000001');
    expect(result.status).toBe('paid');
    expect(result.amount_paid).toBe('118.00');
    expect(result.tax_amount).toBe('18.00');
    expect(repository.insertHistory).toHaveBeenCalledTimes(1);
    expect(repository.allocateReceiptNumber).toHaveBeenCalled();
    expect(domainEventBus.emit).toHaveBeenCalledWith(
      expect.objectContaining({ eventName: 'payment.settled' }),
    );
  });

  it('supports split tender settlement (PAY-005)', async () => {
    methodRepository.findById
      .mockResolvedValueOnce({ id: 1, is_active: true })
      .mockResolvedValueOnce({ id: 2, is_active: true });
    const result = await service.create(
      {
        member_id: 5,
        subtotal: '100.00',
        tenders: [
          { payment_method_id: 1, amount: '50.00' },
          { payment_method_id: 2, amount: '68.00' },
        ],
      },
      actor,
    );
    expect(result.status).toBe('paid');
    expect(result.amount_paid).toBe('118.00');
    expect(result.payment_method_id).toBeNull();
    expect(repository.insertHistory).toHaveBeenCalledTimes(2);
  });

  it('marks partial when tenders underpay', async () => {
    const result = await service.create(
      {
        member_id: 5,
        subtotal: '100.00',
        tenders: [{ payment_method_id: 1, amount: '20.00' }],
      },
      actor,
    );
    expect(result.status).toBe('partial');
    expect(result.amount_paid).toBe('20.00');
    expect(repository.allocateReceiptNumber).not.toHaveBeenCalled();
  });

  it('creates pending invoice with no tender', async () => {
    const result = await service.create({ member_id: 5, subtotal: '50.00' }, actor);
    expect(result.status).toBe('pending');
    expect(result.amount_paid).toBe('0.00');
    expect(repository.insertHistory).not.toHaveBeenCalled();
  });

  it('rejects tender overpayment', async () => {
    await expect(
      service.create(
        {
          member_id: 5,
          subtotal: '10.00',
          tenders: [{ payment_method_id: 1, amount: '999.00' }],
        },
        actor,
      ),
    ).rejects.toBeInstanceOf(BusinessRuleError);
  });

  it('404s unknown member', async () => {
    memberRepository.findById.mockResolvedValue(null);
    await expect(
      service.create({ member_id: 404, subtotal: '10.00' }, actor),
    ).rejects.toBeInstanceOf(NotFoundError);
  });

  describe('PAY-006 outstanding', () => {
    it('queries pending/partial with remaining balance', async () => {
      repository.findManyFiltered.mockResolvedValue({
        rows: [
          {
            id: 1,
            invoice_number: 'INV00000001',
            member_id: 5,
            membership_id: null,
            payment_method_id: null,
            subtotal: '100.00',
            tax_amount: '18.00',
            discount_amount: '0.00',
            total_amount: '118.00',
            amount_paid: '20.00',
            status: 'partial',
            transaction_reference: null,
            cashier_user_id: 9,
            payment_date: new Date('2026-01-01T00:00:00.000Z'),
            row_version: 1,
            created_at: new Date(),
            updated_at: null,
          },
        ],
        total: 1,
      });
      const page = await service.listOutstanding({}, adminActor);
      expect(page.data).toHaveLength(1);
      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          statuses: ['pending', 'partial'],
          outstandingOnly: true,
          scope: { type: 'all' },
        }),
      );
    });
  });

  describe('PAY-007 scoped views', () => {
    const paymentRow = {
      id: 42,
      invoice_number: 'INV00000001',
      member_id: 5,
      membership_id: null,
      payment_method_id: 1,
      subtotal: '100.00',
      tax_amount: '18.00',
      discount_amount: '0.00',
      total_amount: '118.00',
      amount_paid: '118.00',
      status: 'paid',
      transaction_reference: null,
      cashier_user_id: 9,
      payment_date: new Date('2026-01-01T00:00:00.000Z'),
      row_version: 1,
      created_at: new Date(),
      updated_at: null,
    };

    it('member list uses self scope', async () => {
      await service.list({}, memberActor);
      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({ scope: { type: 'self', memberProfileId: 5 } }),
      );
    });

    it('trainer list uses trainer scope', async () => {
      await service.list({}, trainerActor);
      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({ scope: { type: 'trainer', trainerProfileId: 7 } }),
      );
    });

    it('trainer getById omits histories', async () => {
      repository.findById.mockResolvedValue(paymentRow);
      repository.listHistories.mockResolvedValue([
        {
          id: 1,
          payment_id: 42,
          payment_method_id: 1,
          action: 'payment_received',
          amount: '118.00',
          notes: null,
          timestamp: new Date(),
        },
      ]);
      const dto = await service.getById(42, trainerActor);
      expect(dto.histories).toBeUndefined();
      expect(repository.listHistories).not.toHaveBeenCalled();
    });

    it('member cannot read another member payment', async () => {
      repository.findById.mockResolvedValue({ ...paymentRow, member_id: 99 });
      await expect(service.getById(42, memberActor)).rejects.toBeInstanceOf(NotFoundError);
    });
  });

  describe('PAY-008 membership coordination', () => {
    it('assigns membership when product_id and paid', async () => {
      const result = await service.create(
        { member_id: 5, subtotal: '100.00', payment_method_id: 1, product_id: 3 },
        actor,
      );
      expect(membershipRepository.insertMembership).toHaveBeenCalled();
      expect(result.membership_id).toBe(99);
      expect(repository.insertPayment).toHaveBeenCalledWith(
        expect.objectContaining({ membership_id: 99 }),
      );
    });

    it('renews when member already has active membership', async () => {
      membershipRepository.findActiveOrFrozenForMember.mockResolvedValue({
        id: 50,
        member_id: 5,
        product_id: 3,
        start_date: '2026-01-01',
        end_date: '2026-01-31',
        remaining_pt_sessions: 2,
        status: 'active',
        row_version: 1,
      });
      await service.create(
        { member_id: 5, subtotal: '100.00', payment_method_id: 1, product_id: 3 },
        actor,
      );
      expect(membershipRepository.updateMembership).toHaveBeenCalledWith(
        50,
        expect.objectContaining({
          remaining_pt_sessions: 6,
          status: 'active',
        }),
      );
      expect(membershipRepository.insertMembership).not.toHaveBeenCalled();
    });

    it('does not activate on partial by default', async () => {
      await service.create(
        {
          member_id: 5,
          subtotal: '100.00',
          product_id: 3,
          tenders: [{ payment_method_id: 1, amount: '10.00' }],
        },
        actor,
      );
      expect(membershipRepository.insertMembership).not.toHaveBeenCalled();
      expect(repository.insertPayment).toHaveBeenCalledWith(
        expect.objectContaining({ membership_id: null, status: 'partial' }),
      );
    });
  });

  describe('PAY-009 refund', () => {
    const paidRow = {
      id: 42,
      invoice_number: 'INV00000001',
      member_id: 5,
      membership_id: null,
      payment_method_id: 1,
      subtotal: '100.00',
      tax_amount: '18.00',
      discount_amount: '0.00',
      total_amount: '118.00',
      amount_paid: '118.00',
      status: 'paid',
      transaction_reference: null,
      cashier_user_id: 9,
      payment_date: new Date('2026-01-01T00:00:00.000Z'),
      row_version: 1,
      created_at: new Date(),
      updated_at: null,
    };

    it('refunds up to net paid and marks refunded', async () => {
      repository.findById.mockResolvedValue(paidRow);
      repository.listHistories.mockResolvedValue([
        {
          id: 1,
          payment_id: 42,
          payment_method_id: 1,
          action: 'payment_received',
          amount: '118.00',
          notes: null,
          timestamp: new Date(),
        },
      ]);
      const result = await service.refund(42, { amount: '118.00' }, adminActor);
      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'refunded', amount: '118.00' }),
      );
      expect(result.status).toBe('refunded');
      expect(result.amount_paid).toBe('0.00');
    });

    it('rejects refund above net paid', async () => {
      repository.findById.mockResolvedValue(paidRow);
      repository.listHistories.mockResolvedValue([
        {
          id: 1,
          payment_id: 42,
          payment_method_id: 1,
          action: 'payment_received',
          amount: '50.00',
          notes: null,
          timestamp: new Date(),
        },
      ]);
      await expect(
        service.refund(42, { amount: '60.00' }, adminActor),
      ).rejects.toBeInstanceOf(BusinessRuleError);
    });
  });

  describe('PAY-010 adjust', () => {
    it('appends adjusted history and updates total', async () => {
      repository.findById.mockResolvedValue({
        id: 42,
        invoice_number: 'INV00000001',
        member_id: 5,
        membership_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        tax_amount: '18.00',
        discount_amount: '0.00',
        total_amount: '118.00',
        amount_paid: '118.00',
        status: 'paid',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-01-01T00:00:00.000Z'),
        row_version: 2,
        created_at: new Date(),
        updated_at: null,
      });
      repository.listHistories.mockResolvedValue([
        {
          id: 2,
          payment_id: 42,
          payment_method_id: null,
          action: 'adjusted',
          amount: '10.00',
          notes: 'fee',
          timestamp: new Date(),
        },
      ]);
      const result = await service.adjust(
        42,
        { amount: '10.00', notes: 'fee', row_version: 2 },
        adminActor,
      );
      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'adjusted', amount: '10.00' }),
      );
      expect(repository.updatePayment).toHaveBeenCalledWith(
        42,
        expect.objectContaining({ total_amount: '128.00', row_version: 3 }),
      );
      expect(result.histories).toBeDefined();
    });

    it('rejects adjustment that would make total negative', async () => {
      repository.findById.mockResolvedValue({
        id: 42,
        total_amount: '10.00',
        amount_paid: '0.00',
        status: 'pending',
        row_version: 1,
        member_id: 5,
        invoice_number: 'INV1',
        membership_id: null,
        payment_method_id: null,
        subtotal: '10.00',
        tax_amount: '0.00',
        discount_amount: '0.00',
        transaction_reference: null,
        cashier_user_id: null,
        payment_date: new Date(),
        created_at: new Date(),
        updated_at: null,
      });
      await expect(
        service.adjust(42, { amount: '-20.00' }, adminActor),
      ).rejects.toBeInstanceOf(BusinessRuleError);
    });
  });

  describe('DSH-007 / PAY-017 revenue today', () => {
    it('delegates UTC day window to repository', async () => {
      const now = new Date('2026-09-21T15:30:00.000Z');
      const result = await service.getRevenueToday(now);
      expect(result).toEqual({ total_amount: '4500.00', invoice_count: 3 });
      expect(repository.getRevenueToday).toHaveBeenCalledWith(
        new Date('2026-09-21T00:00:00.000Z'),
        new Date('2026-09-22T00:00:00.000Z'),
      );
    });
  });

  describe('PAY-011 receipt', () => {
    it('returns existing receipt', async () => {
      repository.findById.mockResolvedValue({
        id: 42,
        member_id: 5,
        status: 'paid',
        amount_paid: '118.00',
        invoice_number: 'INV00000001',
        membership_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        tax_amount: '18.00',
        discount_amount: '0.00',
        total_amount: '118.00',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-01-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      });
      repository.findReceiptByPaymentId.mockResolvedValue({
        id: 1,
        payment_id: 42,
        receipt_number: 'RCP00000001',
        receipt_pdf_url: null,
        generated_at: new Date('2026-01-01T00:00:00.000Z'),
      });
      const receipt = await service.getReceipt(42, adminActor);
      expect(receipt.receipt_number).toBe('RCP00000001');
      expect(repository.allocateReceiptNumber).not.toHaveBeenCalled();
    });

    it('allocates receipt on read when paid and missing', async () => {
      repository.findById.mockResolvedValue({
        id: 42,
        member_id: 5,
        status: 'paid',
        amount_paid: '118.00',
        invoice_number: 'INV00000001',
        membership_id: null,
        payment_method_id: 1,
        subtotal: '100.00',
        tax_amount: '18.00',
        discount_amount: '0.00',
        total_amount: '118.00',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date('2026-01-01T00:00:00.000Z'),
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      });
      repository.findReceiptByPaymentId.mockResolvedValue(null);
      const receipt = await service.getReceipt(42, adminActor);
      expect(receipt.receipt_number).toBe('RCP00000001');
      expect(repository.allocateReceiptNumber).toHaveBeenCalled();
    });

    it('404s receipt for unpaid pending invoice', async () => {
      repository.findById.mockResolvedValue({
        id: 42,
        member_id: 5,
        status: 'pending',
        amount_paid: '0.00',
        invoice_number: 'INV00000001',
        membership_id: null,
        payment_method_id: null,
        subtotal: '100.00',
        tax_amount: '18.00',
        discount_amount: '0.00',
        total_amount: '118.00',
        transaction_reference: null,
        cashier_user_id: 9,
        payment_date: new Date(),
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      });
      await expect(service.getReceipt(42, adminActor)).rejects.toBeInstanceOf(NotFoundError);
    });
  });
});
