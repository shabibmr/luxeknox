import { beforeEach, describe, expect, it, vi } from 'vitest';
import { BusinessRuleError, ConflictError, NotFoundError } from '../platform/errors/app-error';
import { AttendanceService } from './attendance.service';
import { HardwareIngestAdapter } from './hardware-ingest.adapter';
import { signAttendancePass } from './qr-token';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

describe('AttendanceService', () => {
  let service: AttendanceService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let membershipRepository: Record<string, ReturnType<typeof vi.fn>>;
  let userRepository: Record<string, ReturnType<typeof vi.fn>>;
  let settingsService: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let domainEventBus: { emit: ReturnType<typeof vi.fn> };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let db: { select: ReturnType<typeof vi.fn> };

  const staffActor = {
    id: 2,
    email: 'a@b.c',
    phoneNumber: null,
    userType: 'employee' as const,
    roleId: 1,
    profileId: 1,
    sessionId: 1,
  };

  beforeEach(() => {
    process.env.ATTENDANCE_SIGNING_SECRET = 'test-secret';

    repository = {
      findOpenByUserIdForUpdate: vi.fn().mockResolvedValue(null),
      countCheckInsForUserBetween: vi.fn().mockResolvedValue(0),
      insertCheckIn: vi.fn().mockImplementation(async (row) => ({ id: 99, ...row })),
      findById: vi.fn(),
      setCheckOut: vi.fn(),
      findManyFiltered: vi.fn().mockResolvedValue([]),
      listCheckInDatesDesc: vi.fn().mockResolvedValue([]),
      findLatestCheckIn: vi.fn().mockResolvedValue(null),
      findOpenOlderThan: vi.fn().mockResolvedValue([]),
      aggregateDay: vi.fn().mockResolvedValue({
        total_member_checkins: 3,
        total_trainer_checkins: 1,
        peak_hour: 9,
        peak_count: 2,
      }),
      upsertHistory: vi.fn().mockImplementation(async (row) => ({ id: 1, ...row })),
      listHistories: vi.fn().mockResolvedValue([]),
      getOccupancySnapshot: vi.fn().mockResolvedValue({
        checked_in_now: 2,
        by_gate: [{ gate_identifier: 'north', count: 2 }],
      }),
    };
    membershipRepository = {
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue({ id: 1, member_id: 5, status: 'active' }),
    };
    userRepository = {
      findById: vi.fn().mockResolvedValue({ id: 10, status: 'active', user_type: 'member' }),
    };
    settingsService = {
      getAttendanceDebounceSeconds: vi.fn().mockResolvedValue(60),
      getAttendanceDailyCheckInCap: vi.fn().mockResolvedValue(2),
      getAttendanceAutoCheckoutHours: vi.fn().mockResolvedValue(12),
    };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    domainEventBus = { emit: vi.fn().mockResolvedValue([]) };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };

    const memberSelectChain = {
      from: vi.fn().mockReturnThis(),
      where: vi.fn().mockReturnThis(),
      limit: vi.fn().mockResolvedValue([{ id: 5, user_id: 10, assigned_trainer_id: 1 }]),
    };
    db = { select: vi.fn().mockReturnValue(memberSelectChain) };

    service = new AttendanceService(
      repository as any,
      new HardwareIngestAdapter(),
      userRepository as any,
      membershipRepository as any,
      settingsService as any,
      auditService as any,
      domainEventBus as any,
      paginationHelper as any,
      db as any,
    );
  });

  it('checks in via valid QR payload', async () => {
    const { payload } = signAttendancePass(10, 300);
    const result = await service.checkIn(
      { payload, method: 'qr_code' },
      { device: { id: 1, device_name: 'gate-1' } },
    );
    expect(result.id).toBe(99);
    expect(result.user_id).toBe(10);
    expect(repository.insertCheckIn).toHaveBeenCalled();
  });

  it('rejects invalid QR payload', async () => {
    await expect(
      service.checkIn({ payload: 'not-valid', method: 'qr_code' }, { device: { id: 1, device_name: 'g' } }),
    ).rejects.toThrow(/Invalid or expired/);
  });

  it('rejects frozen membership', async () => {
    membershipRepository.findActiveOrFrozenForMember.mockResolvedValue({ id: 1, status: 'frozen' });
    const { payload } = signAttendancePass(10, 300);
    await expect(
      service.checkIn({ payload }, { device: { id: 1, device_name: 'g' } }),
    ).rejects.toBeInstanceOf(BusinessRuleError);
  });

  it('rejects when daily cap is reached', async () => {
    repository.countCheckInsForUserBetween.mockResolvedValue(2);
    const { payload } = signAttendancePass(10, 300);
    await expect(
      service.checkIn({ payload }, { device: { id: 1, device_name: 'g' } }),
    ).rejects.toBeInstanceOf(BusinessRuleError);
  });

  it('manual override bypasses eligibility and daily cap', async () => {
    membershipRepository.findActiveOrFrozenForMember.mockResolvedValue({ id: 1, status: 'frozen' });
    repository.countCheckInsForUserBetween.mockResolvedValue(99);
    const result = await service.manualOverride(
      { user_id: 10, reason: 'Front desk exception for VIP' },
      staffActor,
    );
    expect(result.method).toBe('manual_override');
    expect(auditService.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: 'attendance.manual_override',
        afterState: expect.objectContaining({ reason: 'Front desk exception for VIP' }),
      }),
    );
  });

  it('returns existing open attendance within debounce window', async () => {
    const open = {
      id: 50,
      user_id: 10,
      check_in_time: new Date(),
      check_out_time: null,
      method: 'qr_code',
      gate_identifier: 'A',
      verified_by_user_id: null,
      created_at: new Date(),
      updated_at: new Date(),
    };
    repository.findOpenByUserIdForUpdate.mockResolvedValue(open);
    const { payload } = signAttendancePass(10, 300);
    const result = await service.checkIn({ payload }, { device: { id: 1, device_name: 'g' } });
    expect(result.id).toBe(50);
    expect(repository.insertCheckIn).not.toHaveBeenCalled();
  });

  it('409s when open attendance is outside debounce window', async () => {
    repository.findOpenByUserIdForUpdate.mockResolvedValue({
      id: 50,
      user_id: 10,
      check_in_time: new Date(Date.now() - 120_000),
      check_out_time: null,
      method: 'qr_code',
      gate_identifier: 'A',
      verified_by_user_id: null,
      created_at: new Date(),
      updated_at: new Date(),
    });
    const { payload } = signAttendancePass(10, 300);
    await expect(
      service.checkIn({ payload }, { device: { id: 1, device_name: 'g' } }),
    ).rejects.toBeInstanceOf(ConflictError);
  });

  it('checks out an open attendance', async () => {
    const open = {
      id: 50,
      user_id: 10,
      check_in_time: new Date(),
      check_out_time: null,
      method: 'manual_override',
      gate_identifier: null,
      verified_by_user_id: 2,
      created_at: new Date(),
      updated_at: new Date(),
    };
    repository.findById.mockResolvedValue(open);
    repository.setCheckOut.mockResolvedValue({ ...open, check_out_time: new Date() });
    const result = await service.checkOut(50, staffActor);
    expect(result.check_out_time).not.toBeNull();
  });

  it('404s check-out for missing attendance', async () => {
    repository.findById.mockResolvedValue(null);
    await expect(service.checkOut(404, staffActor)).rejects.toBeInstanceOf(NotFoundError);
  });

  it('computes streak across consecutive UTC days', () => {
    const now = new Date('2026-09-21T15:00:00.000Z');
    expect(service.computeStreak(['2026-09-21', '2026-09-20', '2026-09-19'], now)).toBe(3);
    expect(service.computeStreak(['2026-09-20', '2026-09-19'], now)).toBe(2);
    expect(service.computeStreak(['2026-09-18'], now)).toBe(0);
  });

  it('returns summary for a member', async () => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date('2026-09-21T12:00:00.000Z'));
    try {
      const today = new Date().toISOString().slice(0, 10);
      const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
      repository.listCheckInDatesDesc.mockResolvedValue([today, yesterday]);
      repository.findLatestCheckIn.mockResolvedValue({
        id: 1,
        user_id: 10,
        check_in_time: new Date('2026-09-21T10:00:00.000Z'),
        check_out_time: null,
        method: 'qr_code',
        gate_identifier: null,
        verified_by_user_id: null,
        created_at: new Date(),
        updated_at: new Date(),
      });
      repository.countCheckInsForUserBetween.mockResolvedValue(4);
      const result = await service.summary({ member_id: 5 }, staffActor);
      expect(result.visits_this_month).toBe(4);
      expect(result.last_check_in).toBe('2026-09-21T10:00:00.000Z');
      expect(result.streak_days).toBeGreaterThanOrEqual(1);
    } finally {
      vi.useRealTimers();
    }
  });

  it('rolls up a day into attendance_histories', async () => {
    const history = await service.rollupDay(new Date('2026-09-20T12:00:00.000Z'));
    expect(history.date).toBe('2026-09-20');
    expect(history.total_member_checkins).toBe(3);
    expect(repository.upsertHistory).toHaveBeenCalled();
  });

  it('auto-checks out stale open visits', async () => {
    repository.findOpenOlderThan.mockResolvedValue([
      {
        id: 7,
        user_id: 10,
        check_in_time: new Date(Date.now() - 20 * 60 * 60 * 1000),
        check_out_time: null,
        method: 'qr_code',
        gate_identifier: null,
        verified_by_user_id: null,
        created_at: new Date(),
        updated_at: new Date(),
      },
    ]);
    repository.setCheckOut.mockResolvedValue({});
    const closed = await service.autoCheckoutStale();
    expect(closed).toBe(1);
    expect(auditService.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({ action: 'attendance.auto_checked_out' }),
    );
  });

  it('returns occupancy snapshot', async () => {
    const occ = await service.getOccupancy();
    expect(occ.checked_in_now).toBe(2);
    expect(occ.by_gate[0].gate_identifier).toBe('north');
  });

  it('lists attendances for admin scope', async () => {
    repository.findManyFiltered.mockResolvedValue([
      {
        id: 1,
        user_id: 10,
        check_in_time: new Date('2026-09-21T10:00:00.000Z'),
        check_out_time: null,
        method: 'qr_code',
        gate_identifier: null,
        verified_by_user_id: null,
        created_at: new Date(),
        updated_at: new Date(),
      },
    ]);
    const page = await service.list({}, { ...staffActor, userType: 'admin' });
    expect(page.data).toHaveLength(1);
    expect(page.meta.limit).toBe(20);
  });
});
