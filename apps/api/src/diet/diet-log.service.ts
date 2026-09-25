import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { PaginationHelper, createPaginatedResponse } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { MemberRepository } from '../people/member.repository';
import { SettingsService } from '../sys/settings.service';
import { DietPlanRepository } from './diet-plan.repository';
import {
  DietLogRepository,
  type DietLogRollupSummary,
} from './diet-log.repository';
import type {
  DietLogFilterQueryDto,
  DietLogWriteDto,
} from './diet-log.dto';
import type { DietHistory } from '../platform/db/schema/diet';

@Injectable()
export class DietLogService {
  constructor(
    private readonly logRepo: DietLogRepository,
    private readonly planRepo: DietPlanRepository,
    private readonly memberRepo: MemberRepository,
    private readonly settingsService: SettingsService,
    private readonly eventBus: DomainEventBus,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  private async assertCanAccessMember(actor: AuthenticatedUser, memberId: number): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'member') {
      if (actor.profileId !== memberId) {
        throw new NotFoundError('Member not found');
      }
      return;
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepo.findById(memberId);
      if (!member || member.assigned_trainer_id !== actor.profileId) {
        throw new NotFoundError('Member not found or not assigned to trainer');
      }
      return;
    }
    throw new ForbiddenError('Access denied');
  }

  async putLog(
    memberId: number,
    dateStr: string,
    dto: DietLogWriteDto,
    actor: AuthenticatedUser,
  ): Promise<DietHistory> {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
      throw new BadRequestError('Invalid date format. Expected YYYY-MM-DD.');
    }

    await this.assertCanAccessMember(actor, memberId);

    let planId = dto.diet_plan_id;
    let targetCalories: number | null = null;

    if (planId) {
      const plan = await this.planRepo.findPlanById(planId);
      if (!plan) {
        throw new NotFoundError('Diet plan not found');
      }
      targetCalories = plan.daily_calorie_target ?? null;
    } else {
      const activePlan = await this.planRepo.findActivePlanForMember(memberId);
      if (activePlan) {
        planId = activePlan.id;
        targetCalories = activePlan.daily_calorie_target ?? null;
      }
    }

    let calculatedAdherence = dto.adherence_score ?? null;
    if (calculatedAdherence === null && targetCalories && targetCalories > 0) {
      const formula = await this.settingsService.getDietAdherenceFormula();
      if (formula === 'calorie_ratio') {
        const deviation = Math.abs(dto.total_calories_consumed - targetCalories) / targetCalories;
        calculatedAdherence = Math.max(0, Math.min(100, Math.round((1 - deviation) * 100)));
      }
    }

    const saved = await this.logRepo.upsertLog({
      member_id: memberId,
      diet_plan_id: planId ?? null,
      logged_date: dateStr,
      total_calories_consumed: dto.total_calories_consumed,
      adherence_score: calculatedAdherence,
      water_intake_ml: dto.water_intake_ml ?? null,
      member_notes: dto.member_notes ?? null,
    });

    this.eventBus.emitSync({
      eventName: 'diet_log.recorded',
      occurredAt: new Date(),
      payload: {
        member_id: memberId,
        logged_date: dateStr,
        total_calories_consumed: saved.total_calories_consumed,
        adherence_score: saved.adherence_score,
        actor_id: actor.id,
      },
    });

    return saved;
  }

  async listLogs(
    memberId: number,
    rawQuery: Record<string, unknown>,
    filter: DietLogFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<DietHistory>> {
    await this.assertCanAccessMember(actor, memberId);

    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);

    const { rows, total } = await this.logRepo.findLogs({
      memberId,
      from: filter.from,
      to: filter.to,
      limit,
      offset: offset ?? 0,
    });

    return createPaginatedResponse({ items: rows, total, limit, offset: offset ?? 0 });
  }

  async getSummary(
    memberId: number,
    from?: string,
    to?: string,
    actor?: AuthenticatedUser,
  ): Promise<DietLogRollupSummary> {
    if (actor) {
      await this.assertCanAccessMember(actor, memberId);
    }
    return this.logRepo.getRollupSummary(memberId, from, to);
  }
}
