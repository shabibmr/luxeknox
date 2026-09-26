import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { AuditService } from '../platform/audit/audit.service';
import type { NewGoalHistory } from '../platform/db/schema/goals';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { SettingsService } from '../sys/settings.service';
import type {
  MeasurementFilterQueryDto,
  MeasurementWriteDto,
} from './goal.dto';
import { GoalRepository } from './goal.repository';
import { GoalService } from './goal.service';
import {
  MeasurementRepository,
  type LongitudinalDataPoint,
  type MeasurementWithValues,
} from './measurement.repository';

@Injectable()
export class MeasurementService {
  constructor(
    private readonly measurementRepo: MeasurementRepository,
    private readonly goalRepo: GoalRepository,
    private readonly goalService: GoalService,
    private readonly memberRepo: MemberRepository,
    private readonly settingsService: SettingsService,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async assertCanRecordMeasurement(actor: AuthenticatedUser, memberId: number): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'member') {
      if (actor.profileId !== memberId) {
        throw new ForbiddenError('Cannot record measurements for another member');
      }
      return;
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepo.findById(memberId);
      if (!member || member.assigned_trainer_id !== actor.profileId) {
        throw new ForbiddenError('Trainer may only record measurements for assigned members');
      }
      return;
    }
    throw new ForbiddenError('Access denied');
  }

  async validateMandatoryMetrics(providedMetricIds: number[]): Promise<void> {
    const mandatory = await this.settingsService.getMandatoryMeasurementMetricIds();
    if (mandatory.length === 0) {
      return;
    }

    const providedSet = new Set(providedMetricIds);
    const missing = mandatory.filter((id) => !providedSet.has(id));

    if (missing.length > 0) {
      throw new BusinessRuleError(
        `Missing mandatory measurement metrics: ${missing.join(', ')}`,
      );
    }
  }

  async createMeasurement(
    memberId: number,
    dto: MeasurementWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MeasurementWithValues> {
    await this.assertCanRecordMeasurement(actor, memberId);

    const providedMetricIds = dto.values.map((v) => v.metric_id);
    await this.validateMandatoryMetrics(providedMetricIds);

    const recordedAt = dto.recorded_at ? new Date(dto.recorded_at) : new Date();

    // 1. Create measurement session with batch values
    const created = await this.measurementRepo.createWithValues({
      member_id: memberId,
      recorded_by_user_id: actor.id,
      recorded_at: recordedAt,
      notes: dto.notes ?? null,
      values: dto.values,
    });

    // 2. GOA-008 & GOA-009: Synchronize matching active goals & evaluate achievement
    const recordedDateStr = recordedAt.toISOString().slice(0, 10);

    for (const val of dto.values) {
      const activeGoals = await this.goalRepo.findActiveByMemberIdAndMetricId(
        memberId,
        val.metric_id,
      );

      for (const goal of activeGoals) {
        const newHistory: NewGoalHistory = {
          goal_id: goal.id,
          recorded_value: val.value,
          recorded_date: recordedDateStr,
          notes: dto.notes ?? 'Updated via measurement session',
          created_at: new Date(),
        };

        await this.goalRepo.addHistory(newHistory);

        const isAchieved = this.goalService.evaluateAchievement(
          goal.baseline_value,
          goal.target_value,
          val.value,
        );

        await this.goalRepo.updateById(goal.id, {
          current_value: val.value,
          status: isAchieved ? 'achieved' : goal.status,
          row_version: goal.row_version + 1,
          updated_at: new Date(),
        });
      }
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'measurements',
      entityId: created.id,
      afterState: created,
    });

    return created;
  }

  async listMeasurements(
    memberId: number,
    rawQuery: Record<string, unknown>,
    filter: MeasurementFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MeasurementWithValues>> {
    await assertMemberAccess(this.memberRepo, actor, memberId);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const fromDate = filter.from ? new Date(filter.from) : undefined;
    const toDate = filter.to ? new Date(filter.to) : undefined;

    const { rows, total } = await this.measurementRepo.findManyByMemberId(memberId, {
      limit: pagination.limit,
      offset,
      from: fromDate,
      to: toDate,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async getMeasurementById(
    id: number,
    actor: AuthenticatedUser,
  ): Promise<MeasurementWithValues> {
    const session = await this.measurementRepo.findByIdWithValues(id);
    if (!session) {
      throw new NotFoundError(`Measurement session with id ${id} not found`);
    }

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
    return session;
  }

  async getLongitudinalChart(
    memberId: number,
    metricId: number,
    fromStr: string | undefined,
    toStr: string | undefined,
    actor: AuthenticatedUser,
  ): Promise<LongitudinalDataPoint[]> {
    await assertMemberAccess(this.memberRepo, actor, memberId);

    const fromDate = fromStr ? new Date(fromStr) : undefined;
    const toDate = toStr ? new Date(toStr) : undefined;

    return this.measurementRepo.findLongitudinalSeries(memberId, metricId, fromDate, toDate);
  }
}
