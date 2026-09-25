import { beforeEach, describe, expect, it, vi } from 'vitest';
import { BadRequestError, BusinessRuleError, ConflictError, NotFoundError } from '../platform/errors/app-error';
import { PaymentService } from '../pay/payment.service';
import { SessionAttendanceService } from '../attn/session-attendance.service';
import { AttendanceService } from '../attn/attendance.service';
import type { AuthenticatedUser } from '../auth/auth.guard';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

describe('MEM-012: Membership Integration with Schedule and Payment Dependencies', () => {
  const adminActor: AuthenticatedUser = {
    id: 1,
    email: 'admin@luxeknox.test',
    phoneNumber: null,
    userType: 'admin',
    roleId: 1,
    profileId: 1,
    sessionId: 1,
  };

  const memberActor: AuthenticatedUser = {
    id: 10,
    email: 'member@luxeknox.test',
    phoneNumber: null,
    userType: 'member',
    roleId: 5,
    profileId: 42,
    sessionId: 2,
  };

  // Payment + Membership Coordination Mocks (PAY-008)
  let paymentRepo: Record<string, ReturnType<typeof vi.fn>>;
  let methodRepo: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepo: Record<string, ReturnType<typeof vi.fn>>;
  let membRepo: Record<string, ReturnType<typeof vi.fn>>;
  let membProductRepo: Record<string, ReturnType<typeof vi.fn>>;
  let membService: Record<string, ReturnType<typeof vi.fn>>;
  let settingsService: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let domainEventBus: { emit: ReturnType<typeof vi.fn> };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };

  let paymentService: PaymentService;

  // Session Attendance (ATT-016) Mocks
  let scheduleRepo: Record<string, ReturnType<typeof vi.fn>>;
  let sessionAttendanceService: SessionAttendanceService;

  // Gate Attendance (ATT-009) Mocks
  let attendanceRepo: Record<string, ReturnType<typeof vi.fn>>;
  let userRepo: Record<string, ReturnType<typeof vi.fn>>;
  let hardwareAdapter: Record<string, ReturnType<typeof vi.fn>>;
  let attendanceService: AttendanceService;

  beforeEach(() => {
    paymentRepo = {
      allocateInvoiceNumber: vi.fn().mockResolvedValue('INV00000100'),
      insertPayment: vi.fn().mockImplementation(async (row) => ({ id: 50, ...row })),
      insertHistory: vi.fn().mockImplementation(async (row) => ({ id: 1, ...row })),
      listHistories: vi.fn().mockResolvedValue([]),
      findById: vi.fn().mockImplementation(async (id) => ({
        id,
        invoice_number: 'INV00000100',
        subtotal: '1000.00',
        tax_amount: '180.00',
        discount_amount: '0.00',
        total_amount: '1180.00',
        amount_paid: '1180.00',
        status: 'paid',
        membership_id: 101,
        member_id: 42,
        payment_date: new Date(),
        row_version: 1,
      })),
      updatePayment: vi.fn().mockImplementation(async (_id, patch) => ({ id: 50, ...patch })),
      findManyFiltered: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
      getRevenueToday: vi.fn().mockResolvedValue({ total_amount: '1180.00', invoice_count: 1 }),
      findReceiptByPaymentId: vi.fn().mockResolvedValue(null),
      allocateReceiptNumber: vi.fn().mockResolvedValue('RCP00000100'),
      insertReceipt: vi.fn().mockImplementation(async (r) => ({ id: 1, ...r })),
    };

    methodRepo = {
      findById: vi.fn().mockResolvedValue({ id: 1, method_name: 'Credit Card', is_active: true }),
    };

    memberRepo = {
      findById: vi.fn().mockResolvedValue({ id: 42, user_id: 10 }),
    };

    membProductRepo = {
      findById: vi.fn().mockResolvedValue({
        id: 3,
        name: 'Gold Annual PT',
        base_price: '1000.00',
        duration_days: 365,
        pt_sessions_included: 10,
        is_active: true,
      }),
    };

    membRepo = {
      findById: vi.fn().mockResolvedValue({
        id: 101,
        member_id: 42,
        product_id: 3,
        start_date: '2026-01-01',
        end_date: '2026-12-31',
        remaining_pt_sessions: 10,
        status: 'active',
        row_version: 1,
      }),
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue(null),
      insertMembership: vi.fn().mockResolvedValue(101),
      insertHistory: vi.fn().mockResolvedValue(undefined),
      updateMembership: vi.fn().mockResolvedValue(undefined),
      adjustRemainingPtSessions: vi.fn().mockResolvedValue(undefined),
    };

    settingsService = {
      getTaxRatePercent: vi.fn().mockResolvedValue('18.00'),
      getAttendanceDailyCheckInCap: vi.fn().mockResolvedValue(2),
      getAttendanceDebounceSeconds: vi.fn().mockResolvedValue(60),
      getPaymentsActivateMembershipOnPartial: vi.fn().mockResolvedValue(false),
    };

    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    domainEventBus = { emit: vi.fn().mockResolvedValue([]) };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };

    paymentService = new PaymentService(
      paymentRepo as any,
      methodRepo as any,
      memberRepo as any,
      membRepo as any,
      membProductRepo as any,
      settingsService as any,
      auditService as any,
      domainEventBus as any,
      paginationHelper as any,
      {} as any,
    );

    let participantAttended: boolean | null = null;
    scheduleRepo = {
      findById: vi.fn().mockResolvedValue({
        id: 201,
        schedule_type_id: 1,
        requires_trainer: true,
        max_capacity: 1,
        trainer_id: 7,
      }),
      findParticipantById: vi.fn().mockImplementation(async () => ({
        id: 301,
        schedule_id: 201,
        member_id: 42,
        booking_status: 'booked',
        attended: participantAttended,
      })),
      updateParticipant: vi.fn().mockImplementation(async (_id, patch) => {
        if ('attended' in patch) participantAttended = patch.attended;
      }),
    };

    const mockScheduleDb = {
      select: vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([{ requires_trainer: true }]),
          }),
        }),
      }),
    };

    sessionAttendanceService = new SessionAttendanceService(
      scheduleRepo as any,
      membRepo as any,
      auditService as any,
      domainEventBus as any,
      mockScheduleDb as any,
    );

    attendanceRepo = {
      findLatestCheckIn: vi.fn().mockResolvedValue(null),
      countCheckInsForUserBetween: vi.fn().mockResolvedValue(0),
      insertCheckIn: vi.fn().mockImplementation(async (r) => ({ id: 401, ...r })),
      findOpenByUserIdForUpdate: vi.fn().mockResolvedValue(null),
    };

    userRepo = {
      findById: vi.fn().mockResolvedValue({ id: 10, status: 'active', user_type: 'member' }),
    };

    hardwareAdapter = {
      resolve: vi.fn().mockReturnValue({ userId: 10, method: 'qr_code', gateIdentifier: 'gate-1' }),
    };

    const mockDb = {
      select: vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockReturnValue({
            limit: vi.fn().mockResolvedValue([{ id: 42, user_id: 10 }]),
          }),
        }),
      }),
    };

    attendanceService = new AttendanceService(
      attendanceRepo as any,
      hardwareAdapter as any,
      userRepo as any,
      membRepo as any,
      settingsService as any,
      auditService as any,
      domainEventBus as any,
      paginationHelper as any,
      mockDb as any,
    );
  });

  describe('1. Membership Purchase Coordination with Payment (PAY-008)', () => {
    it('creates active membership and settled invoice in a coordinated transaction', async () => {
      const result = await paymentService.purchaseMembership(
        {
          member_id: 42,
          product_id: 3,
          start_date: '2026-01-01',
          payment_method_id: 1,
        },
        adminActor,
      );

      // Verify membership creation was called on repository
      expect(membRepo.insertMembership).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 42,
          product_id: 3,
          status: 'active',
          remaining_pt_sessions: 10,
        }),
      );

      // Verify payment was calculated with 18% tax on 1000.00 = 1180.00
      expect(paymentRepo.insertPayment).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 42,
          membership_id: 101,
          subtotal: '1000.00',
          tax_amount: '180.00',
          total_amount: '1180.00',
          amount_paid: '1180.00',
          status: 'paid',
        }),
      );

      // Verify single tender history recorded
      expect(paymentRepo.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'payment_received',
          amount: '1180.00',
          payment_method_id: 1,
        }),
      );

      expect(result.membershipId).toBe(101);
      expect(result.payment.total_amount).toBe('1180.00');
      expect(result.payment.status).toBe('paid');
    });

    it('rejects membership purchase when product is inactive or not found', async () => {
      membProductRepo.findById.mockResolvedValueOnce(null);

      await expect(
        paymentService.purchaseMembership(
          {
            member_id: 42,
            product_id: 999,
            payment_method_id: 1,
          },
          adminActor,
        ),
      ).rejects.toBeInstanceOf(NotFoundError);
    });

    it('rejects membership purchase when member does not exist', async () => {
      memberRepo.findById.mockResolvedValueOnce(null);

      await expect(
        paymentService.purchaseMembership(
          {
            member_id: 999,
            product_id: 3,
            payment_method_id: 1,
          },
          adminActor,
        ),
      ).rejects.toBeInstanceOf(NotFoundError);
    });
  });

  describe('2. Membership Renewal Coordination with Payment (PAY-008)', () => {
    it('renews membership and charges renewal invoice in coordinated transaction', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce({
        id: 101,
        member_id: 42,
        product_id: 3,
        start_date: '2026-01-01',
        end_date: '2026-12-31',
        remaining_pt_sessions: 10,
        status: 'active',
        row_version: 1,
      });

      const result = await paymentService.renewMembership(
        {
          membership_id: 101,
          expected_row_version: 1,
          payment_method_id: 1,
        },
        adminActor,
      );

      expect(membRepo.updateMembership).toHaveBeenCalledWith(
        101,
        expect.objectContaining({
          status: 'active',
          row_version: 2,
        }),
      );

      expect(paymentRepo.insertPayment).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 42,
          membership_id: 101,
          subtotal: '1000.00',
          total_amount: '1180.00',
          status: 'paid',
        }),
      );

      expect(result.membershipId).toBe(101);
      expect(result.payment.status).toBe('paid');
    });

    it('propagates concurrency conflict when row_version is stale during renewal', async () => {
      await expect(
        paymentService.renewMembership(
          {
            membership_id: 101,
            expected_row_version: 99, // Stale version vs actual 1
            payment_method_id: 1,
          },
          adminActor,
        ),
      ).rejects.toBeInstanceOf(ConflictError);
    });
  });

  describe('3. Scheduling PT Session Consumption & Restoral (ATT-016)', () => {
    it('decrements membership remaining_pt_sessions on attended 1:1 PT session', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce({
        id: 101,
        status: 'active',
        remaining_pt_sessions: 10,
      });

      const updated = await sessionAttendanceService.mark(
        201,
        301,
        { attended: true },
        adminActor,
      );

      expect(updated.attended).toBe(true);
      expect(membRepo.adjustRemainingPtSessions).toHaveBeenCalledWith(42, -1);
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'schedule.attendance_marked',
          payload: expect.objectContaining({ pt_delta: -1 }),
        }),
      );
    });

    it('restores remaining_pt_sessions when attended state is unset', async () => {
      // Participant previously attended
      scheduleRepo.findParticipantById.mockResolvedValueOnce({
        id: 301,
        schedule_id: 201,
        member_id: 42,
        booking_status: 'booked',
        attended: true,
      });

      const updated = await sessionAttendanceService.mark(
        201,
        301,
        { attended: false },
        adminActor,
      );

      expect(updated.attended).toBe(false);
      expect(membRepo.adjustRemainingPtSessions).toHaveBeenCalledWith(42, 1);
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'schedule.attendance_marked',
          payload: expect.objectContaining({ pt_delta: 1 }),
        }),
      );
    });

    it('rejects PT attendance marking when membership has no remaining PT sessions', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce({
        id: 101,
        status: 'active',
        remaining_pt_sessions: 0, // No sessions left
      });

      await expect(
        sessionAttendanceService.mark(
          201,
          301,
          { attended: true },
          adminActor,
        ),
      ).rejects.toBeInstanceOf(BusinessRuleError);
    });

    it('rejects PT attendance marking when member has no membership contract', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce(null);

      await expect(
        sessionAttendanceService.mark(
          201,
          301,
          { attended: true },
          adminActor,
        ),
      ).rejects.toBeInstanceOf(BusinessRuleError);
    });
  });

  describe('4. Membership State Gates on Gate Attendance (ATT-009)', () => {
    it('allows check-in for active membership', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce({
        id: 101,
        status: 'active',
      });

      const checkIn = await attendanceService.checkIn(
        { method: 'qr_code', payload: 'valid' },
        { actor: memberActor },
      );

      expect(checkIn.user_id).toBe(10);
      expect(attendanceRepo.insertCheckIn).toHaveBeenCalled();
    });

    it('rejects gate check-in when membership is frozen', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce({
        id: 101,
        status: 'frozen',
      });

      await expect(
        attendanceService.checkIn(
          { method: 'qr_code', payload: 'valid' },
          { actor: memberActor },
        ),
      ).rejects.toThrow('Membership is frozen; check-in is not allowed');
    });

    it('rejects gate check-in when member has no active membership', async () => {
      membRepo.findActiveOrFrozenForMember.mockResolvedValueOnce(null);

      await expect(
        attendanceService.checkIn(
          { method: 'qr_code', payload: 'valid' },
          { actor: memberActor },
        ),
      ).rejects.toThrow('No active membership for check-in');
    });
  });
});
