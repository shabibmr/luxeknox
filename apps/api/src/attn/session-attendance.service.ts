import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MembershipRepository } from '../memb/membership.repository';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { ScheduleParticipant } from '../platform/db/schema/scheduling';
import { scheduleTypes } from '../platform/db/schema/scheduling';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { DomainEventBus } from '../platform/events/domain-events';
import { ScheduleRepository } from '../sched/schedule.repository';
import { eq } from 'drizzle-orm';

export interface MarkAttendanceDto {
  attended: boolean;
}

/**
 * ATT-015 / ATT-016: class/PT session attendance is distinct from gate attendance.
 * PT consumption: 1:1 trainer sessions (`requires_trainer && max_capacity === 1`)
 * decrement `remaining_pt_sessions` only when marking attended for the first time.
 */
@Injectable()
export class SessionAttendanceService {
  constructor(
    private readonly scheduleRepository: ScheduleRepository,
    private readonly membershipRepository: MembershipRepository,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  async mark(
    scheduleId: number,
    participantId: number,
    dto: MarkAttendanceDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleParticipant> {
    if (actor.userType === 'member') {
      throw new ForbiddenError('Members cannot mark session attendance');
    }

    return runInTransaction(this.db, async () => {
      const schedule = await this.scheduleRepository.findById(scheduleId);
      if (!schedule) {
        throw new NotFoundError('Schedule not found');
      }

      const participant = await this.scheduleRepository.findParticipantById(
        scheduleId,
        participantId,
      );
      if (!participant) {
        throw new NotFoundError('Schedule participant not found');
      }
      if (participant.booking_status === 'cancelled') {
        throw new BadRequestError('Cannot mark attendance on a cancelled booking');
      }
      if (participant.booking_status === 'waitlisted') {
        throw new BadRequestError('Cannot mark attendance on a waitlisted booking');
      }

      if (actor.userType === 'trainer') {
        if (actor.profileId == null || schedule.trainer_id !== actor.profileId) {
          throw new ForbiddenError('Trainers may only mark attendance on their own schedules');
        }
      }

      const wasAttended = participant.attended === true;
      const nowAttended = dto.attended === true;
      const now = new Date();

      await this.scheduleRepository.updateParticipant(participant.id, {
        attended: dto.attended,
        marked_at: now,
      });

      const isPt = await this.isPersonalTrainingSession(schedule);
      let ptDelta = 0;
      if (isPt && !wasAttended && nowAttended) {
        const membership = await this.membershipRepository.findActiveOrFrozenForMember(
          participant.member_id,
        );
        if (!membership || membership.remaining_pt_sessions <= 0) {
          throw new BusinessRuleError('No remaining PT sessions to consume');
        }
        await this.membershipRepository.adjustRemainingPtSessions(participant.member_id, -1);
        ptDelta = -1;
      } else if (isPt && wasAttended && !nowAttended) {
        await this.membershipRepository.adjustRemainingPtSessions(participant.member_id, 1);
        ptDelta = 1;
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'schedule.attendance_marked',
        entityName: 'schedule_participants',
        entityId: participant.id,
        beforeState: { attended: participant.attended, marked_at: participant.marked_at },
        afterState: { attended: dto.attended, marked_at: now.toISOString(), pt_delta: ptDelta },
      });

      await this.domainEventBus.emit({
        eventName: 'schedule.attendance_marked',
        occurredAt: now,
        payload: {
          schedule_id: scheduleId,
          participant_id: participant.id,
          member_id: participant.member_id,
          attended: dto.attended,
          pt_delta: ptDelta,
        },
      });

      const updated = await this.scheduleRepository.findParticipantById(scheduleId, participantId);
      return updated!;
    });
  }

  /**
   * 1:1 PT heuristic: schedule type requires a trainer and capacity is exactly one.
   */
  async isPersonalTrainingSession(schedule: {
    schedule_type_id: number;
    max_capacity: number;
  }): Promise<boolean> {
    if (schedule.max_capacity !== 1) return false;
    const db = this.db as any;
    const rows = await db
      .select({ requires_trainer: scheduleTypes.requires_trainer })
      .from(scheduleTypes)
      .where(eq(scheduleTypes.id, schedule.schedule_type_id))
      .limit(1);
    return Boolean(rows[0]?.requires_trainer);
  }
}
