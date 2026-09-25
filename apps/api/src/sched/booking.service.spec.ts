import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BadRequestError, ConflictError, ForbiddenError } from '../platform/errors/app-error';
import { BookingService } from './booking.service';

const memberActor: AuthenticatedUser = {
  id: 10,
  email: 'member@example.com',
  phoneNumber: null,
  roleId: 2,
  userType: 'member',
  profileId: 50,
  sessionId: 1,
};

const adminActor: AuthenticatedUser = {
  id: 1,
  email: 'admin@example.com',
  phoneNumber: null,
  roleId: 1,
  userType: 'admin',
  profileId: null,
  sessionId: 1,
};

const NOW = Date.now();
function inMinutes(minutes: number): Date {
  return new Date(NOW + minutes * 60_000);
}

function baseSchedule(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    id: 5,
    series_id: null,
    schedule_type_id: 1,
    facility_id: null,
    trainer_id: null,
    title: 'Yoga',
    start_time: inMinutes(180),
    end_time: inMinutes(240),
    max_capacity: 2,
    status: 'scheduled',
    notes: null,
    row_version: 1,
    created_at: new Date(NOW - 60_000),
    updated_at: null,
    ...overrides,
  };
}

function buildService(overrides: Partial<Record<string, unknown>> = {}) {
  const repository = {
    findById: vi.fn().mockResolvedValue(baseSchedule()),
    lockScheduleForUpdate: vi.fn().mockResolvedValue({ id: 5, max_capacity: baseSchedule().max_capacity }),
    findParticipant: vi.fn().mockResolvedValue(null),
    insertParticipant: vi.fn().mockResolvedValue(101),
    updateParticipant: vi.fn(),
    countBookedParticipants: vi.fn().mockResolvedValue(0),
    countActiveBookingsForMember: vi.fn().mockResolvedValue(0),
    findOverlappingBookedForMember: vi.fn().mockResolvedValue([]),
    findEarliestWaitlisted: vi.fn().mockResolvedValue(null),
    insertHistory: vi.fn(),
    ...overrides,
  };

  const memberRepository = {
    findById: vi.fn().mockResolvedValue({ id: 50, first_name: 'Jane', last_name: 'Doe' }),
  };

  const settingsService = {
    getScheduleBookingLeadTimeMinutes: vi.fn().mockResolvedValue(0),
    getScheduleCancellationCutoffMinutes: vi.fn().mockResolvedValue(0),
    getScheduleMemberBookingCap: vi.fn().mockResolvedValue(5),
  };

  const auditService = { recordAudit: vi.fn() };
  const domainEventBus = { emit: vi.fn(), emitSync: vi.fn(), on: vi.fn() };

  const db = {
    transaction: async (fn: (tx: unknown) => Promise<unknown>) => fn(db),
  };

  const service = new BookingService(
    repository as any,
    memberRepository as any,
    settingsService as any,
    auditService as any,
    domainEventBus as any,
    db as any,
  );

  return { service, repository, memberRepository, settingsService, auditService, domainEventBus };
}

describe('BookingService', () => {
  describe('book', () => {
    it('books a member when capacity is available', async () => {
      const { service, repository } = buildService({
        findParticipant: vi.fn().mockResolvedValueOnce(null).mockResolvedValueOnce({
          id: 101,
          schedule_id: 5,
          member_id: 50,
          booking_status: 'booked',
          attended: null,
          booked_at: new Date(),
          marked_at: null,
        }),
      });

      const participant = await service.book(5, {}, memberActor);

      expect(participant.booking_status).toBe('booked');
      expect(repository.insertParticipant).toHaveBeenCalledWith(
        expect.objectContaining({ schedule_id: 5, member_id: 50, booking_status: 'booked' }),
      );
    });

    it('waitlists a member when the schedule is at capacity', async () => {
      const { service, repository } = buildService({
        countBookedParticipants: vi.fn().mockResolvedValue(2),
        findParticipant: vi.fn().mockResolvedValueOnce(null).mockResolvedValueOnce({
          id: 101,
          schedule_id: 5,
          member_id: 50,
          booking_status: 'waitlisted',
          attended: null,
          booked_at: new Date(),
          marked_at: null,
        }),
      });

      const participant = await service.book(5, {}, memberActor);

      expect(participant.booking_status).toBe('waitlisted');
      expect(repository.insertParticipant).toHaveBeenCalledWith(
        expect.objectContaining({ booking_status: 'waitlisted' }),
      );
    });

    it('rejects booking when lead time requirement is not met', async () => {
      const { service, settingsService } = buildService({
        findById: vi.fn().mockResolvedValue(baseSchedule({ start_time: inMinutes(30) })),
      });
      settingsService.getScheduleBookingLeadTimeMinutes.mockResolvedValue(120);

      await expect(service.book(5, {}, memberActor)).rejects.toBeInstanceOf(BadRequestError);
    });

    it('rejects booking when member has reached their active booking cap', async () => {
      const { service } = buildService({
        countActiveBookingsForMember: vi.fn().mockResolvedValue(5),
      });

      await expect(service.book(5, {}, memberActor)).rejects.toBeInstanceOf(ConflictError);
    });

    it('rejects booking when member has an overlapping active booking', async () => {
      const { service } = buildService({
        findOverlappingBookedForMember: vi.fn().mockResolvedValue([
          {
            id: 9,
            trainer_id: null,
            facility_id: null,
            start_time: inMinutes(190),
            end_time: inMinutes(230),
            status: 'scheduled',
          },
        ]),
      });

      await expect(service.book(5, {}, memberActor)).rejects.toBeInstanceOf(ConflictError);
    });

    it('rejects a duplicate active booking for the same schedule', async () => {
      const { service } = buildService({
        findParticipant: vi.fn().mockResolvedValue({
          id: 101,
          schedule_id: 5,
          member_id: 50,
          booking_status: 'booked',
          attended: null,
          booked_at: new Date(),
          marked_at: null,
        }),
      });

      await expect(service.book(5, {}, memberActor)).rejects.toBeInstanceOf(ConflictError);
    });

    it('rejects a member booking on behalf of a different member', async () => {
      const { service } = buildService();

      await expect(service.book(5, { member_id: 99 }, memberActor)).rejects.toBeInstanceOf(
        ForbiddenError,
      );
    });
  });

  describe('cancelBooking', () => {
    const bookedParticipant = {
      id: 101,
      schedule_id: 5,
      member_id: 50,
      booking_status: 'booked',
      attended: null,
      booked_at: new Date(),
      marked_at: null,
    };

    it('rejects member cancellation past the cutoff', async () => {
      const { service, settingsService } = buildService({
        findParticipant: vi.fn().mockResolvedValue(bookedParticipant),
      });
      settingsService.getScheduleCancellationCutoffMinutes.mockResolvedValue(240);

      await expect(
        service.cancelBooking(5, 50, {}, memberActor),
      ).rejects.toBeInstanceOf(BadRequestError);
    });

    it('allows staff to cancel past the cutoff', async () => {
      const { service, settingsService, repository } = buildService({
        findParticipant: vi.fn().mockResolvedValue(bookedParticipant),
      });
      settingsService.getScheduleCancellationCutoffMinutes.mockResolvedValue(240);

      await service.cancelBooking(5, 50, {}, adminActor);

      expect(repository.updateParticipant).toHaveBeenCalledWith(
        101,
        expect.objectContaining({ booking_status: 'cancelled' }),
      );
    });

    it('promotes the earliest waitlisted participant after a booked cancellation (FIFO)', async () => {
      const waitlisted = {
        id: 202,
        schedule_id: 5,
        member_id: 51,
        booking_status: 'waitlisted',
        attended: null,
        booked_at: new Date(NOW - 1000),
        marked_at: null,
      };

      const { service, repository } = buildService({
        findParticipant: vi.fn().mockResolvedValue(bookedParticipant),
        findEarliestWaitlisted: vi.fn().mockResolvedValue(waitlisted),
      });

      await service.cancelBooking(5, 50, {}, memberActor);

      expect(repository.updateParticipant).toHaveBeenCalledWith(
        202,
        expect.objectContaining({ booking_status: 'booked' }),
      );
    });

    it('does not promote anyone when the cancelled booking was already waitlisted', async () => {
      const { service, repository } = buildService({
        findParticipant: vi.fn().mockResolvedValue({ ...bookedParticipant, booking_status: 'waitlisted' }),
      });

      await service.cancelBooking(5, 50, {}, memberActor);

      expect(repository.findEarliestWaitlisted).not.toHaveBeenCalled();
    });
  });
});
