import { beforeEach, describe, expect, it, vi } from 'vitest';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { SessionAttendanceService } from './session-attendance.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

describe('SessionAttendanceService', () => {
  let service: SessionAttendanceService;
  let scheduleRepository: Record<string, ReturnType<typeof vi.fn>>;
  let membershipRepository: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let domainEventBus: { emit: ReturnType<typeof vi.fn> };
  let db: { select: ReturnType<typeof vi.fn> };

  const staff = {
    id: 2,
    email: 'e@x.com',
    phoneNumber: null,
    userType: 'employee' as const,
    roleId: 1,
    profileId: 1,
    sessionId: 1,
  };

  const ptSchedule = {
    id: 10,
    schedule_type_id: 3,
    trainer_id: 7,
    max_capacity: 1,
    title: 'PT',
  };

  const participant = {
    id: 55,
    schedule_id: 10,
    member_id: 5,
    booking_status: 'booked',
    attended: null as boolean | null,
    booked_at: new Date(),
    marked_at: null as Date | null,
  };

  beforeEach(() => {
    scheduleRepository = {
      findById: vi.fn().mockResolvedValue(ptSchedule),
      findParticipantById: vi.fn().mockResolvedValue(participant),
      updateParticipant: vi.fn().mockResolvedValue(undefined),
    };
    membershipRepository = {
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue({
        id: 1,
        member_id: 5,
        remaining_pt_sessions: 3,
        status: 'active',
      }),
      adjustRemainingPtSessions: vi.fn().mockResolvedValue({ remaining_pt_sessions: 2 }),
    };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    domainEventBus = { emit: vi.fn().mockResolvedValue([]) };

    const typeChain = {
      from: vi.fn().mockReturnThis(),
      where: vi.fn().mockReturnThis(),
      limit: vi.fn().mockResolvedValue([{ requires_trainer: true }]),
    };
    db = { select: vi.fn().mockReturnValue(typeChain) };

    service = new SessionAttendanceService(
      scheduleRepository as any,
      membershipRepository as any,
      auditService as any,
      domainEventBus as any,
      db as any,
    );
  });

  it('marks attended and consumes one PT session for 1:1 trainer schedules', async () => {
    scheduleRepository.findParticipantById
      .mockResolvedValueOnce(participant)
      .mockResolvedValueOnce({ ...participant, attended: true, marked_at: new Date() });

    const result = await service.mark(10, 55, { attended: true }, staff);
    expect(result.attended).toBe(true);
    expect(membershipRepository.adjustRemainingPtSessions).toHaveBeenCalledWith(5, -1);
    expect(auditService.recordAudit).toHaveBeenCalled();
  });

  it('rejects PT mark when no remaining sessions', async () => {
    membershipRepository.findActiveOrFrozenForMember.mockResolvedValue({
      id: 1,
      remaining_pt_sessions: 0,
      status: 'active',
    });
    await expect(service.mark(10, 55, { attended: true }, staff)).rejects.toBeInstanceOf(
      BusinessRuleError,
    );
  });

  it('restores a PT session when un-marking attended', async () => {
    scheduleRepository.findParticipantById
      .mockResolvedValueOnce({ ...participant, attended: true })
      .mockResolvedValueOnce({ ...participant, attended: false });
    await service.mark(10, 55, { attended: false }, staff);
    expect(membershipRepository.adjustRemainingPtSessions).toHaveBeenCalledWith(5, 1);
  });

  it('does not consume PT for group classes (capacity > 1)', async () => {
    scheduleRepository.findById.mockResolvedValue({ ...ptSchedule, max_capacity: 12 });
    scheduleRepository.findParticipantById
      .mockResolvedValueOnce(participant)
      .mockResolvedValueOnce({ ...participant, attended: true });
    await service.mark(10, 55, { attended: true }, staff);
    expect(membershipRepository.adjustRemainingPtSessions).not.toHaveBeenCalled();
  });

  it('forbids members from marking', async () => {
    await expect(
      service.mark(10, 55, { attended: true }, { ...staff, userType: 'member' }),
    ).rejects.toBeInstanceOf(ForbiddenError);
  });

  it('404s unknown participant', async () => {
    scheduleRepository.findParticipantById.mockResolvedValue(null);
    await expect(service.mark(10, 55, { attended: true }, staff)).rejects.toBeInstanceOf(
      NotFoundError,
    );
  });
});
