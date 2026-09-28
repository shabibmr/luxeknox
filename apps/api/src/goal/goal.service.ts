import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { AuditService } from '../platform/audit/audit.service';
import type {
  Goal,
  GoalHistory,
  NewGoal,
  NewGoalHistory,
} from '../platform/db/schema/goals';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type {
  GoalCheckInWriteDto,
  GoalFilterQueryDto,
  GoalUpdateDto,
  GoalWriteDto,
} from './goal.dto';
import { GoalMetricRepository } from './goal-metric.repository';
import { GoalRepository, type GoalWithDetail, type GoalWithMetric } from './goal.repository';

@Injectable()
export class GoalService {
  constructor(
    private readonly goalRepo: GoalRepository,
    private readonly metricRepo: GoalMetricRepository,
    private readonly memberRepo: MemberRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async assertCanManageMemberGoal(actor: AuthenticatedUser, memberId: number): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepo.findById(memberId);
      if (!member || member.assigned_trainer_id !== actor.profileId) {
        throw new ForbiddenError('Trainer may only manage goals for assigned members');
      }
      return;
    }
    // Per FR-GOAL-003: Member reads own goals; may not create in MVP
    throw new ForbiddenError('Only trainers and staff may create or modify goals');
  }

  evaluateAchievement(baseline: number, target: number, current: number): boolean {
    if (baseline < target) {
      return current >= target;
    }
    if (baseline > target) {
      return current <= target;
    }
    return current === target;
  }

  async listMemberGoals(
    memberId: number,
    rawQuery: Record<string, unknown>,
    filter: GoalFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<GoalWithMetric>> {
    await assertMemberAccess(this.memberRepo, actor, memberId);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.goalRepo.findManyByMemberId(memberId, {
      status: filter.status,
      metricId: filter.metric_id,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async getGoalById(goalId: number, actor: AuthenticatedUser): Promise<GoalWithDetail> {
    const goal = await this.goalRepo.findByIdWithDetail(goalId);
    if (!goal) {
      throw new NotFoundError(`Goal with id ${goalId} not found`);
    }

    await assertMemberAccess(this.memberRepo, actor, goal.member_id);
    return goal;
  }

  async createGoal(
    memberId: number,
    dto: GoalWriteDto,
    actor: AuthenticatedUser,
  ): Promise<GoalWithMetric> {
    await this.assertCanManageMemberGoal(actor, memberId);

    const metric = await this.metricRepo.findById(dto.metric_id);
    if (!metric || !metric.is_active) {
      throw new BusinessRuleError('Active goal metric required');
    }

    const now = new Date();
    const isAlreadyAchieved = this.evaluateAchievement(
      dto.baseline_value,
      dto.target_value,
      dto.baseline_value,
    );

    const newGoal: NewGoal = {
      member_id: memberId,
      metric_id: dto.metric_id,
      baseline_value: dto.baseline_value,
      target_value: dto.target_value,
      current_value: dto.baseline_value,
      start_date: dto.start_date,
      target_date: dto.target_date ?? null,
      status: isAlreadyAchieved ? 'achieved' : dto.status ?? 'in_progress',
      row_version: 1,
      created_at: now,
      updated_at: now,
    };

    const created = await this.goalRepo.create(newGoal);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'goals',
      entityId: created.id,
      afterState: created,
    });

    const populated = await this.goalRepo.findByIdWithMetric(created.id);
    return populated!;
  }

  async updateGoal(
    goalId: number,
    dto: GoalUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<GoalWithMetric> {
    const existing = await this.goalRepo.findById(goalId);
    if (!existing) {
      throw new NotFoundError(`Goal with id ${goalId} not found`);
    }

    await this.assertCanManageMemberGoal(actor, existing.member_id);

    const targetValue = dto.target_value ?? existing.target_value;
    let status = dto.status ?? existing.status;

    if (
      status === 'in_progress' &&
      this.evaluateAchievement(existing.baseline_value, targetValue, existing.current_value)
    ) {
      status = 'achieved';
    }

    const updated = await this.goalRepo.updateById(goalId, {
      target_value: targetValue,
      target_date: dto.target_date !== undefined ? dto.target_date : existing.target_date,
      status,
      row_version: existing.row_version + 1,
      updated_at: new Date(),
    });

    if (!updated) {
      throw new NotFoundError(`Goal with id ${goalId} not found`);
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'update',
      entityName: 'goals',
      entityId: goalId,
      beforeState: existing,
      afterState: updated,
    });

    const populated = await this.goalRepo.findByIdWithMetric(goalId);
    return populated!;
  }

  async checkIn(
    goalId: number,
    dto: GoalCheckInWriteDto,
    actor: AuthenticatedUser,
  ): Promise<GoalHistory> {
    const goal = await this.goalRepo.findById(goalId);
    if (!goal) {
      throw new NotFoundError(`Goal with id ${goalId} not found`);
    }

    await assertMemberAccess(this.memberRepo, actor, goal.member_id);

    const now = new Date();
    const recordedDate = dto.recorded_date ?? now.toISOString().slice(0, 10);

    const newHistory: NewGoalHistory = {
      goal_id: goalId,
      recorded_value: dto.recorded_value,
      recorded_date: recordedDate,
      notes: dto.notes ?? null,
      created_at: now,
    };

    const history = await this.goalRepo.addHistory(newHistory);

    // Evaluate achievement
    const isAchieved = this.evaluateAchievement(
      goal.baseline_value,
      goal.target_value,
      dto.recorded_value,
    );

    const newStatus = isAchieved && goal.status === 'in_progress' ? 'achieved' : goal.status;

    await this.goalRepo.updateById(goalId, {
      current_value: dto.recorded_value,
      status: newStatus,
      row_version: goal.row_version + 1,
      updated_at: now,
    });

    return history;
  }
}
