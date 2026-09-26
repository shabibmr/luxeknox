import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { verifyRowVersion } from '../platform/concurrency/row-version';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { Schedule, ScheduleHistory, ScheduleParticipant } from '../platform/db/schema/scheduling';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { TrainerRepository } from '../people/trainer.repository';
import type { CancelRequestDto, ScheduleCreateDto, ScheduleTransitionDto, ScheduleUpdateDto } from './schedule.dto';
import { scheduleFilterQuerySchema } from './schedule.dto';
import { FacilityRepository } from './facility.repository';
import { buildWeeklyOccurrences } from './recurring-schedule';
import {
  findTrainerConflicts,
  isFacilityOverCapacity,
  type ScheduleBlock,
} from './schedule-conflict';
import { ScheduleRepository } from './schedule.repository';
import { ScheduleTypeRepository } from './schedule-type.repository';

export type ScheduleWithParticipants = Schedule & {
  participants: ScheduleParticipant[];
};

@Injectable()
export class ScheduleService {
  constructor(
    private readonly repository: ScheduleRepository,
    private readonly scheduleTypeRepository: ScheduleTypeRepository,
    private readonly facilityRepository: FacilityRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private async toScheduleBlock(rows: Schedule[]): Promise<ScheduleBlock[]> {
    return rows.map((row) => ({
      id: row.id,
      trainer_id: row.trainer_id,
      facility_id: row.facility_id,
      start_time: row.start_time,
      end_time: row.end_time,
      status: row.status,
    }));
  }

  private listScope(actor: AuthenticatedUser): {
    trainerScopeId?: number;
    memberScopeId?: number;
  } {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return {};
    }
    if (actor.userType === 'trainer') {
      return { trainerScopeId: actor.profileId ?? -1 };
    }
    if (actor.userType === 'member') {
      return { memberScopeId: actor.profileId ?? -1 };
    }
    throw new ForbiddenError();
  }

  private async assertReadScope(actor: AuthenticatedUser, schedule: Schedule): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'trainer') {
      if (schedule.trainer_id === actor.profileId) {
        return;
      }
      throw new NotFoundError('Schedule not found');
    }
    if (actor.userType === 'member') {
      const participants = await this.repository.listParticipants(schedule.id);
      if (participants.some((row) => row.member_id === actor.profileId && row.booking_status !== 'cancelled')) {
        return;
      }
      throw new NotFoundError('Schedule not found');
    }
    throw new ForbiddenError();
  }

  private async present(schedule: Schedule): Promise<ScheduleWithParticipants> {
    const participants = await this.repository.listParticipants(schedule.id);
    return { ...schedule, participants };
  }

  private async assertNoConflicts(
    params: {
      trainerId: number | null;
      facilityId: number | null;
      startTime: Date;
      endTime: Date;
      excludeId?: number;
    },
  ): Promise<void> {
    if (params.trainerId) {
      const trainerRows = await this.repository.findOverlappingForTrainer(
        params.trainerId,
        params.startTime,
        params.endTime,
        params.excludeId,
      );
      const conflicts = findTrainerConflicts(await this.toScheduleBlock(trainerRows), {
        trainer_id: params.trainerId,
        start_time: params.startTime,
        end_time: params.endTime,
      }, params.excludeId);
      if (conflicts.length > 0) {
        throw new ConflictError('Trainer has an overlapping schedule');
      }
    }

    if (params.facilityId) {
      const facility = await this.facilityRepository.findById(params.facilityId);
      if (!facility) {
        throw new NotFoundError('Facility not found');
      }
      const facilityRows = await this.repository.findOverlappingForFacility(
        params.facilityId,
        params.startTime,
        params.endTime,
        params.excludeId,
      );
      if (
        isFacilityOverCapacity(
          await this.toScheduleBlock(facilityRows),
          {
            facility_id: params.facilityId,
            start_time: params.startTime,
            end_time: params.endTime,
          },
          facility.capacity,
          params.excludeId,
        )
      ) {
        throw new ConflictError('Facility is fully booked for the requested time');
      }
    }
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<ScheduleWithParticipants>> {
    const filters = scheduleFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const scope = this.listScope(actor);

    const { rows, total } = await this.repository.findManyFiltered({
      from: filters.from ? new Date(filters.from) : undefined,
      to: filters.to ? new Date(filters.to) : undefined,
      trainerId: filters.trainer_id,
      memberId: filters.member_id,
      trainerScopeId: scope.trainerScopeId,
      memberScopeId: scope.memberScopeId,
      limit: pagination.limit,
      offset,
    });

    const items = await Promise.all(rows.map((row) => this.present(row)));
    return createPaginatedResponse({ items, limit: pagination.limit, offset, total });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<ScheduleWithParticipants> {
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    await this.assertReadScope(actor, schedule);
    return this.present(schedule);
  }

  async create(dto: ScheduleCreateDto, actor: AuthenticatedUser): Promise<ScheduleWithParticipants> {
    const scheduleType = await this.scheduleTypeRepository.findById(dto.schedule_type_id);
    if (!scheduleType) {
      throw new NotFoundError('Schedule type not found');
    }

    if (scheduleType.requires_trainer && !dto.trainer_id) {
      throw new BadRequestError('trainer_id is required for this schedule type');
    }

    if (dto.facility_id) {
      const facility = await this.facilityRepository.findById(dto.facility_id);
      if (!facility) {
        throw new NotFoundError('Facility not found');
      }
      if (!facility.is_active) {
        throw new BadRequestError('Inactive facilities cannot accept new schedules');
      }
    }

    if (dto.trainer_id) {
      const trainer = await this.trainerRepository.findById(dto.trainer_id);
      if (!trainer) {
        throw new NotFoundError('Trainer not found');
      }
      if (!trainer.is_active) {
        throw new BadRequestError('Inactive trainers cannot be assigned to new schedules');
      }
    }

    const startTime = new Date(dto.start_time);
    const endTime = new Date(dto.end_time);
    if (endTime <= startTime) {
      throw new BadRequestError('end_time must be after start_time');
    }

    let maxCapacity = dto.max_capacity;
    if (maxCapacity == null && dto.facility_id) {
      const facility = await this.facilityRepository.findById(dto.facility_id);
      maxCapacity = facility?.capacity ?? 1;
    }
    maxCapacity ??= 1;

    const occurrences = buildWeeklyOccurrences(startTime, endTime, dto.recur_until);

    const first = await runInTransaction(this.db, async () => {
      const createdIds: number[] = [];
      let seriesId = dto.series_id ?? null;
      const now = new Date();

      for (const occurrence of occurrences) {
        await this.assertNoConflicts({
          trainerId: dto.trainer_id ?? null,
          facilityId: dto.facility_id ?? null,
          startTime: occurrence.start_time,
          endTime: occurrence.end_time,
        });

        const id = await this.repository.insertSchedule({
          series_id: seriesId,
          schedule_type_id: dto.schedule_type_id,
          facility_id: dto.facility_id ?? null,
          trainer_id: dto.trainer_id ?? null,
          title: dto.title,
          start_time: occurrence.start_time,
          end_time: occurrence.end_time,
          max_capacity: maxCapacity,
          status: 'scheduled',
          notes: dto.notes ?? null,
          row_version: 1,
          created_at: now,
          updated_at: null,
        });

        if (!seriesId && occurrences.length > 1) {
          seriesId = id;
          await this.repository.updateSchedule(id, { series_id: seriesId });
        } else if (seriesId) {
          await this.repository.updateSchedule(id, { series_id: seriesId });
        }

        await this.repository.insertHistory({
          schedule_id: id,
          action: 'created',
          changed_by_user_id: actor.id,
          notes: dto.notes ?? null,
          timestamp: now,
        });

        createdIds.push(id);
      }

      const first = await this.repository.findById(createdIds[0]!);
      if (!first) {
        throw new NotFoundError('Schedule not found after create');
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'schedule.created',
        entityName: 'schedules',
        entityId: first.id,
        afterState: first,
      });

      return first;
    });

    await this.domainEventBus.emit({
      eventName: 'schedule.created',
      occurredAt: new Date(),
      payload: { scheduleId: first.id, seriesId: first.series_id, trainerId: first.trainer_id },
    });

    return this.present(first);
  }

  async update(
    id: number,
    dto: ScheduleUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleWithParticipants> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Schedule not found');
    }
    await this.assertReadScope(actor, before);

    if (before.status === 'cancelled') {
      throw new BadRequestError('Cancelled schedules cannot be updated');
    }

    if (dto.row_version != null) {
      verifyRowVersion(dto.row_version, before.row_version);
    }

    const startTime = dto.start_time ? new Date(dto.start_time) : before.start_time;
    const endTime = dto.end_time ? new Date(dto.end_time) : before.end_time;
    if (endTime <= startTime) {
      throw new BadRequestError('end_time must be after start_time');
    }

    const trainerId = dto.trainer_id ?? before.trainer_id;
    const facilityId = dto.facility_id ?? before.facility_id;

    if (facilityId) {
      const facility = await this.facilityRepository.findById(facilityId);
      if (!facility) {
        throw new NotFoundError('Facility not found');
      }
      if (!facility.is_active) {
        throw new BadRequestError('Inactive facilities cannot accept schedules');
      }
    }

    if (trainerId) {
      const trainer = await this.trainerRepository.findById(trainerId);
      if (!trainer) {
        throw new NotFoundError('Trainer not found');
      }
      if (!trainer.is_active) {
        throw new BadRequestError('Inactive trainers cannot be assigned to schedules');
      }
    }

    await this.assertNoConflicts({
      trainerId,
      facilityId,
      startTime,
      endTime,
      excludeId: id,
    });

    const now = new Date();
    await this.repository.updateSchedule(id, {
      schedule_type_id: dto.schedule_type_id ?? before.schedule_type_id,
      facility_id: facilityId,
      trainer_id: trainerId,
      title: dto.title ?? before.title,
      start_time: startTime,
      end_time: endTime,
      max_capacity: dto.max_capacity ?? before.max_capacity,
      notes: dto.notes ?? before.notes,
      row_version: before.row_version + 1,
      updated_at: now,
    });

    const action =
      before.start_time.getTime() !== startTime.getTime() ||
      before.end_time.getTime() !== endTime.getTime()
        ? 'rescheduled'
        : 'updated';

    await this.repository.insertHistory({
      schedule_id: id,
      action,
      changed_by_user_id: actor.id,
      notes: dto.notes ?? null,
      timestamp: now,
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Schedule not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule.updated',
      entityName: 'schedules',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    await this.domainEventBus.emit({
      eventName: action === 'rescheduled' ? 'schedule.rescheduled' : 'schedule.updated',
      occurredAt: now,
      payload: { scheduleId: id, trainerId: after.trainer_id },
    });

    return this.present(after);
  }

  async cancel(
    id: number,
    dto: CancelRequestDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleWithParticipants> {
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    await this.assertReadScope(actor, schedule);

    if (dto.row_version != null) {
      verifyRowVersion(dto.row_version, schedule.row_version);
    }

    if (dto.cancel_series && schedule.series_id) {
      const targets = await this.repository.findFutureBySeriesId(
        schedule.series_id,
        schedule.start_time,
      );
      const allTargets = targets.some((row) => row.id === schedule.id)
        ? targets
        : [schedule, ...targets];

      for (const target of allTargets) {
        if (target.status !== 'cancelled') {
          await this.cancelOne(target, dto.reason ?? null, actor);
        }
      }

      const refreshed = await this.repository.findById(id);
      if (!refreshed) {
        throw new NotFoundError('Schedule not found after cancel');
      }
      return this.present(refreshed);
    }

    await this.cancelOne(schedule, dto.reason ?? null, actor);
    const refreshed = await this.repository.findById(id);
    if (!refreshed) {
      throw new NotFoundError('Schedule not found after cancel');
    }
    return this.present(refreshed);
  }

  private async cancelOne(
    schedule: Schedule,
    reason: string | null,
    actor: AuthenticatedUser,
  ): Promise<void> {
    if (schedule.status === 'cancelled') {
      return;
    }
    if (schedule.status === 'completed') {
      throw new BadRequestError('Completed schedules cannot be cancelled');
    }

    const now = new Date();
    await this.repository.updateSchedule(schedule.id, {
      status: 'cancelled',
      row_version: schedule.row_version + 1,
      updated_at: now,
    });
    await this.repository.cancelParticipants(schedule.id);
    await this.repository.insertHistory({
      schedule_id: schedule.id,
      action: 'cancelled',
      changed_by_user_id: actor.id,
      notes: reason,
      timestamp: now,
    });

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule.cancelled',
      entityName: 'schedules',
      entityId: schedule.id,
      beforeState: schedule,
      afterState: { ...schedule, status: 'cancelled' },
    });

    await this.domainEventBus.emit({
      eventName: 'schedule.cancelled',
      occurredAt: now,
      payload: { scheduleId: schedule.id, trainerId: schedule.trainer_id, reason },
    });
  }

  /** Staff or the assigned trainer may drive a session's lifecycle; members cannot. */
  private assertManageScope(actor: AuthenticatedUser, schedule: Schedule): void {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'trainer' && schedule.trainer_id === actor.profileId) {
      return;
    }
    throw new ForbiddenError();
  }

  async start(
    id: number,
    dto: ScheduleTransitionDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleWithParticipants> {
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    this.assertManageScope(actor, schedule);

    if (dto.row_version != null) {
      verifyRowVersion(dto.row_version, schedule.row_version);
    }
    if (schedule.status !== 'scheduled') {
      throw new BadRequestError(
        `Cannot start a schedule in status '${schedule.status}'; it must be 'scheduled'`,
      );
    }

    const now = new Date();
    await this.repository.updateSchedule(id, {
      status: 'ongoing',
      row_version: schedule.row_version + 1,
      updated_at: now,
    });
    await this.repository.insertHistory({
      schedule_id: id,
      action: 'started',
      changed_by_user_id: actor.id,
      notes: dto.notes ?? null,
      timestamp: now,
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Schedule not found after start');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule.started',
      entityName: 'schedules',
      entityId: id,
      beforeState: schedule,
      afterState: after,
    });

    await this.domainEventBus.emit({
      eventName: 'schedule.started',
      occurredAt: now,
      payload: { scheduleId: id, trainerId: after.trainer_id },
    });

    return this.present(after);
  }

  async complete(
    id: number,
    dto: ScheduleTransitionDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleWithParticipants> {
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    this.assertManageScope(actor, schedule);

    if (dto.row_version != null) {
      verifyRowVersion(dto.row_version, schedule.row_version);
    }
    if (schedule.status !== 'ongoing') {
      throw new BadRequestError(
        `Cannot complete a schedule in status '${schedule.status}'; it must be 'ongoing'`,
      );
    }

    const now = new Date();
    await this.repository.updateSchedule(id, {
      status: 'completed',
      row_version: schedule.row_version + 1,
      updated_at: now,
    });
    await this.repository.insertHistory({
      schedule_id: id,
      action: 'completed',
      changed_by_user_id: actor.id,
      notes: dto.notes ?? null,
      timestamp: now,
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Schedule not found after complete');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule.completed',
      entityName: 'schedules',
      entityId: id,
      beforeState: schedule,
      afterState: after,
    });

    await this.domainEventBus.emit({
      eventName: 'schedule.completed',
      occurredAt: now,
      payload: { scheduleId: id, trainerId: after.trainer_id },
    });

    return this.present(after);
  }

  /** FR-SCHED history: chronological, append-only, read-only to clients. */
  async listHistory(
    id: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<ScheduleHistory>> {
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundError('Schedule not found');
    }
    await this.assertReadScope(actor, schedule);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const rows = await this.repository.listHistory(id, pagination.limit);
    return createPaginatedResponse({ items: rows, limit: pagination.limit, offset: 0 });
  }
}
