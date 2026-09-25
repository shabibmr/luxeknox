import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { ScheduleParticipant } from '../platform/db/schema/scheduling';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { MemberRepository } from '../people/member.repository';
import { SettingsService } from '../sys/settings.service';
import type { BookRequestDto, CancelBookingRequestDto } from './booking.dto';
import { findMemberConflicts, isActiveScheduleStatus, type ScheduleBlock } from './schedule-conflict';
import { ScheduleRepository } from './schedule.repository';

const STAFF_TYPES = new Set(['admin', 'employee']);

@Injectable()
export class BookingService {
  constructor(
    private readonly repository: ScheduleRepository,
    private readonly memberRepository: MemberRepository,
    private readonly settingsService: SettingsService,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private resolveMemberId(dto: { member_id?: number }, actor: AuthenticatedUser): number {
    if (actor.userType === 'member') {
      if (dto.member_id != null && dto.member_id !== actor.profileId) {
        throw new ForbiddenError('Members may only book for themselves');
      }
      return actor.profileId!;
    }
    if (STAFF_TYPES.has(actor.userType) || actor.userType === 'trainer') {
      if (dto.member_id == null) {
        throw new BadRequestError('member_id is required');
      }
      return dto.member_id;
    }
    throw new ForbiddenError();
  }

  private assertOwnBookingAccess(memberId: number, actor: AuthenticatedUser): void {
    if (STAFF_TYPES.has(actor.userType) || actor.userType === 'trainer') {
      return;
    }
    if (actor.userType === 'member' && actor.profileId === memberId) {
      return;
    }
    throw new ForbiddenError();
  }

  async book(
    scheduleId: number,
    dto: BookRequestDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleParticipant> {
    const memberId = this.resolveMemberId(dto, actor);

    const schedule = await this.repository.findById(scheduleId);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    if (!isActiveScheduleStatus(schedule.status)) {
      throw new BadRequestError('Cannot book a schedule that is not active');
    }

    const member = await this.memberRepository.findById(memberId);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    const now = new Date();
    if (schedule.start_time <= now) {
      throw new BadRequestError('Cannot book a schedule that has already started');
    }

    const leadTimeMinutes = await this.settingsService.getScheduleBookingLeadTimeMinutes();
    const leadTimeDeadline = new Date(schedule.start_time.getTime() - leadTimeMinutes * 60_000);
    if (now > leadTimeDeadline) {
      throw new BadRequestError(
        `Bookings must be made at least ${leadTimeMinutes} minutes before the schedule starts`,
      );
    }

    const cap = await this.settingsService.getScheduleMemberBookingCap();
    const activeCount = await this.repository.countActiveBookingsForMember(memberId, now, scheduleId);
    if (activeCount >= cap) {
      throw new ConflictError(`Member has reached the maximum of ${cap} active bookings`);
    }

    const overlappingCandidates = await this.repository.findOverlappingBookedForMember(
      memberId,
      schedule.start_time,
      schedule.end_time,
      scheduleId,
    );
    const overlapBlocks: ScheduleBlock[] = overlappingCandidates.map((row) => ({
      id: row.id,
      trainer_id: row.trainer_id,
      facility_id: row.facility_id,
      start_time: row.start_time,
      end_time: row.end_time,
      status: row.status,
    }));
    if (
      findMemberConflicts(
        overlapBlocks,
        { start_time: schedule.start_time, end_time: schedule.end_time },
        scheduleId,
      ).length > 0
    ) {
      throw new ConflictError('Member already has another booking during this time');
    }

    const participant = await runInTransaction(this.db, async () => {
      // Lock the schedule row first so two concurrent bookings for the same schedule
      // are serialized: the second transaction blocks here until the first commits,
      // and then re-reads a capacity count that reflects the first booking. Without
      // this lock, two connections can both read "1 seat left" under REPEATABLE READ
      // and both insert a 'booked' participant, overbooking the schedule.
      const locked = await this.repository.lockScheduleForUpdate(scheduleId);
      if (!locked) {
        throw new NotFoundError('Schedule not found');
      }

      const existing = await this.repository.findParticipant(scheduleId, memberId);
      if (existing && existing.booking_status !== 'cancelled') {
        throw new ConflictError('Member already has a booking for this schedule');
      }

      const bookedCount = await this.repository.countBookedParticipants(
        scheduleId,
        existing?.id,
      );
      const status = bookedCount < locked.max_capacity ? 'booked' : 'waitlisted';

      let participantId: number;
      if (existing) {
        participantId = existing.id;
        await this.repository.updateParticipant(existing.id, {
          booking_status: status,
          attended: null,
          booked_at: now,
          marked_at: null,
        });
      } else {
        participantId = await this.repository.insertParticipant({
          schedule_id: scheduleId,
          member_id: memberId,
          booking_status: status,
          booked_at: now,
        });
      }

      await this.repository.insertHistory({
        schedule_id: scheduleId,
        action: status === 'booked' ? 'booked' : 'waitlisted',
        changed_by_user_id: actor.id,
        notes: null,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: status === 'booked' ? 'schedule.booked' : 'schedule.waitlisted',
        entityName: 'schedule_participants',
        entityId: participantId,
        afterState: { schedule_id: scheduleId, member_id: memberId, booking_status: status },
      });

      const created = await this.repository.findParticipant(scheduleId, memberId);
      if (!created) {
        throw new NotFoundError('Booking not found after creation');
      }
      return created;
    });

    await this.domainEventBus.emit({
      eventName: participant.booking_status === 'booked' ? 'schedule.booked' : 'schedule.waitlisted',
      occurredAt: now,
      payload: { scheduleId, memberId, participantId: participant.id },
    });

    return participant;
  }

  async cancelBooking(
    scheduleId: number,
    memberId: number,
    dto: CancelBookingRequestDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleParticipant> {
    this.assertOwnBookingAccess(memberId, actor);

    const schedule = await this.repository.findById(scheduleId);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }

    const participant = await this.repository.findParticipant(scheduleId, memberId);
    if (!participant || participant.booking_status === 'cancelled') {
      throw new NotFoundError('Booking not found');
    }

    const now = new Date();
    const staffOverride = STAFF_TYPES.has(actor.userType);
    if (!staffOverride) {
      const cutoffMinutes = await this.settingsService.getScheduleCancellationCutoffMinutes();
      const cutoffDeadline = new Date(schedule.start_time.getTime() - cutoffMinutes * 60_000);
      if (now > cutoffDeadline) {
        throw new BadRequestError(
          `Bookings can only be cancelled up to ${cutoffMinutes} minutes before the schedule starts`,
        );
      }
    }

    let promotedParticipantId: number | null = null;

    const refreshed = await runInTransaction(this.db, async () => {
      const wasBooked = participant.booking_status === 'booked';

      await this.repository.updateParticipant(participant.id, {
        booking_status: 'cancelled',
        marked_at: now,
      });

      await this.repository.insertHistory({
        schedule_id: scheduleId,
        action: 'booking_cancelled',
        changed_by_user_id: actor.id,
        notes: dto.reason ?? null,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'schedule.booking_cancelled',
        entityName: 'schedule_participants',
        entityId: participant.id,
        beforeState: participant,
        afterState: { ...participant, booking_status: 'cancelled' },
      });

      if (wasBooked) {
        const next = await this.repository.findEarliestWaitlisted(scheduleId);
        if (next) {
          await this.repository.updateParticipant(next.id, {
            booking_status: 'booked',
            booked_at: next.booked_at,
          });
          await this.repository.insertHistory({
            schedule_id: scheduleId,
            action: 'waitlist_promoted',
            changed_by_user_id: actor.id,
            notes: null,
            timestamp: now,
          });
          await this.auditService.recordAudit({
            actorUserId: actor.id,
            action: 'schedule.waitlist_promoted',
            entityName: 'schedule_participants',
            entityId: next.id,
            beforeState: next,
            afterState: { ...next, booking_status: 'booked' },
          });
          promotedParticipantId = next.id;
        }
      }

      const result = await this.repository.findParticipant(scheduleId, memberId);
      if (!result) {
        throw new NotFoundError('Booking not found after cancellation');
      }
      return result;
    });

    await this.domainEventBus.emit({
      eventName: 'schedule.booking_cancelled',
      occurredAt: now,
      payload: { scheduleId, memberId, participantId: participant.id },
    });

    if (promotedParticipantId != null) {
      await this.domainEventBus.emit({
        eventName: 'schedule.waitlist_promoted',
        occurredAt: now,
        payload: { scheduleId, participantId: promotedParticipantId },
      });
    }

    return refreshed;
  }
}
