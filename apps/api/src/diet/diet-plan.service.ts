import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { PaginationHelper, createPaginatedResponse } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { MemberRepository } from '../people/member.repository';
import {
  DietPlanRepository,
  type DietPlanWithDetails,
  type EnrichedDietPlanVersion,
} from './diet-plan.repository';
import type {
  AssignDietPlanDto,
  DietPlanCreateDto,
  DietPlanFilterQueryDto,
  DietPlanMealsWriteDto,
  DietPlanUpdateDto,
} from './diet-plan.dto';
import type { DietPlan } from '../platform/db/schema/diet';

@Injectable()
export class DietPlanService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    private readonly planRepo: DietPlanRepository,
    private readonly memberRepo: MemberRepository,
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

  private async assertCanManagePlan(plan: DietPlan, actor: AuthenticatedUser): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'trainer') {
      if (plan.trainer_id === actor.profileId) {
        return;
      }
      if (plan.member_id) {
        await this.assertCanAccessMember(actor, plan.member_id);
        return;
      }
      if (plan.is_template) {
        return;
      }
    }
    throw new ForbiddenError('Only trainers or staff may manage diet plans');
  }

  async list(
    rawQuery: Record<string, unknown>,
    filter: DietPlanFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<DietPlanWithDetails>> {
    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);

    let effectiveMemberId = filter.member_id;
    let effectiveTrainerId = filter.trainer_id;
    let effectiveIsTemplate = filter.is_template;

    if (actor.userType === 'member') {
      if (effectiveIsTemplate === true) {
        effectiveMemberId = undefined;
      } else {
        effectiveMemberId = actor.profileId ?? undefined;
        effectiveIsTemplate = false;
      }
    } else if (actor.userType === 'trainer') {
      if (effectiveMemberId) {
        await this.assertCanAccessMember(actor, effectiveMemberId);
      }
      if (!effectiveMemberId && effectiveIsTemplate === undefined) {
        effectiveTrainerId = actor.profileId ?? undefined;
      }
    }

    const { rows, total } = await this.planRepo.findPlans({
      memberId: effectiveMemberId,
      isTemplate: effectiveIsTemplate,
      trainerId: effectiveTrainerId,
      status: filter.status,
      q: filter.q,
      limit,
      offset: offset ?? 0,
    });

    return createPaginatedResponse({ items: rows, total, limit, offset: offset ?? 0 });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<DietPlanWithDetails> {
    const plan = await this.planRepo.findPlanById(id);
    if (!plan) {
      throw new NotFoundError('Diet plan not found');
    }

    if (!plan.is_template) {
      if (actor.userType === 'member') {
        if (plan.member_id !== actor.profileId) {
          throw new NotFoundError('Diet plan not found');
        }
      } else if (actor.userType === 'trainer') {
        if (plan.trainer_id !== actor.profileId && plan.member_id) {
          await this.assertCanAccessMember(actor, plan.member_id);
        }
      }
    }

    return plan;
  }

  async create(dto: DietPlanCreateDto, actor: AuthenticatedUser): Promise<DietPlanWithDetails> {
    const isTemplate = dto.is_template ?? false;

    if (isTemplate) {
      if (dto.member_id) {
        throw new BadRequestError('Templates cannot have an assigned member');
      }
      if (actor.userType === 'member') {
        throw new ForbiddenError('Members cannot create diet templates');
      }
    } else if (dto.member_id) {
      await this.assertCanAccessMember(actor, dto.member_id);
    }

    const trainerId =
      actor.userType === 'trainer' ? actor.profileId : dto.trainer_id;

    return runInTransaction(this.db, async () => {
      const plan = await this.planRepo.insertPlan({
        title: dto.title,
        description: dto.description ?? null,
        member_id: isTemplate ? null : dto.member_id ?? null,
        trainer_id: trainerId ?? null,
        daily_calorie_target: dto.daily_calorie_target ?? null,
        protein_target_g: dto.protein_target_g ?? null,
        carbs_target_g: dto.carbs_target_g ?? null,
        fat_target_g: dto.fat_target_g ?? null,
        is_template: isTemplate,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });

      const version = await this.planRepo.insertVersion({
        diet_plan_id: plan.id,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      this.eventBus.emitSync({
        eventName: 'diet_plan.created',
        occurredAt: new Date(),
        payload: {
          plan_id: plan.id,
          member_id: plan.member_id,
          is_template: isTemplate,
          actor_id: actor.id,
        },
      });

      return {
        ...plan,
        current_version: {
          ...version,
          meals: [],
          total_computed_calories: 0,
          total_computed_protein_g: 0,
          total_computed_carbs_g: 0,
          total_computed_fat_g: 0,
        },
      };
    });
  }

  async update(
    id: number,
    dto: DietPlanUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<DietPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Diet plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot update an archived diet plan');
    }

    if (dto.member_id && !existing.is_template) {
      await this.assertCanAccessMember(actor, dto.member_id);
    }

    await this.planRepo.updatePlan(
      id,
      {
        title: dto.title,
        description: dto.description,
        member_id: dto.member_id,
        trainer_id: dto.trainer_id,
        daily_calorie_target: dto.daily_calorie_target,
        protein_target_g: dto.protein_target_g,
        carbs_target_g: dto.carbs_target_g,
        fat_target_g: dto.fat_target_g,
        is_template: dto.is_template,
      },
      dto.row_version,
    );

    const updated = await this.planRepo.findPlanById(id);
    return updated!;
  }

  async publish(id: number, actor: AuthenticatedUser): Promise<DietPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Diet plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'active') {
      return existing;
    }

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot publish an archived diet plan');
    }

    if (!existing.is_template && existing.member_id) {
      const activePlan = await this.planRepo.findActivePlanForMember(existing.member_id);
      if (activePlan && activePlan.id !== existing.id) {
        throw new ConflictError(
          'Member already has an active diet plan. Archive the current active plan before publishing a new one.',
        );
      }
    }

    await this.planRepo.updatePlan(id, { status: 'active' });

    this.eventBus.emitSync({
      eventName: 'diet_plan.published',
      occurredAt: new Date(),
      payload: {
        plan_id: existing.id,
        member_id: existing.member_id,
        actor_id: actor.id,
      },
    });

    const updated = await this.planRepo.findPlanById(id);
    return updated!;
  }

  async archive(id: number, actor: AuthenticatedUser): Promise<DietPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Diet plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    await this.planRepo.updatePlan(id, { status: 'archived' });

    this.eventBus.emitSync({
      eventName: 'diet_plan.archived',
      occurredAt: new Date(),
      payload: {
        plan_id: existing.id,
        member_id: existing.member_id,
        actor_id: actor.id,
      },
    });

    const updated = await this.planRepo.findPlanById(id);
    return updated!;
  }

  async assign(
    templateId: number,
    dto: AssignDietPlanDto,
    actor: AuthenticatedUser,
  ): Promise<DietPlanWithDetails> {
    const template = await this.planRepo.findPlanById(templateId);
    if (!template) {
      throw new NotFoundError('Template not found');
    }

    if (!template.is_template) {
      throw new BadRequestError('Specified diet plan is not a template');
    }

    await this.assertCanAccessMember(actor, dto.member_id);

    const activePlan = await this.planRepo.findActivePlanForMember(dto.member_id);
    if (activePlan) {
      throw new ConflictError(
        'Member already has an active diet plan. Archive or complete it before assigning a new one.',
      );
    }

    return runInTransaction(this.db, async () => {
      const trainerId =
        actor.userType === 'trainer' ? actor.profileId : template.trainer_id;

      const newPlan = await this.planRepo.insertPlan({
        title: template.title,
        description: template.description,
        member_id: dto.member_id,
        trainer_id: trainerId ?? null,
        daily_calorie_target: template.daily_calorie_target,
        protein_target_g: template.protein_target_g,
        carbs_target_g: template.carbs_target_g,
        fat_target_g: template.fat_target_g,
        is_template: false,
        status: 'active',
        row_version: 1,
        created_at: new Date(),
      });

      const newVersion = await this.planRepo.insertVersion({
        diet_plan_id: newPlan.id,
        version_number: 1,
        changelog: `Assigned from template "${template.title}"`,
        created_at: new Date(),
      });

      const templateMeals = template.current_version?.meals ?? [];
      for (let mIdx = 0; mIdx < templateMeals.length; mIdx++) {
        const tMeal = templateMeals[mIdx];
        const newMeal = await this.planRepo.insertMeal({
          diet_plan_version_id: newVersion.id,
          meal_name: tMeal.meal_name,
          scheduled_time: tMeal.scheduled_time ?? null,
          target_calories: tMeal.target_calories ?? null,
          notes: tMeal.notes ?? null,
          order_index: mIdx,
          created_at: new Date(),
        });

        if (tMeal.foods && tMeal.foods.length > 0) {
          await this.planRepo.insertFoods(
            tMeal.foods.map((f, fIdx) => ({
              diet_plan_meal_id: newMeal.id,
              food_id: f.food_id,
              quantity: f.quantity,
              serving_unit: f.serving_unit ?? null,
              order_index: fIdx,
              created_at: new Date(),
            })),
          );
        }
      }

      this.eventBus.emitSync({
        eventName: 'diet_plan.assigned',
        occurredAt: new Date(),
        payload: {
          plan_id: newPlan.id,
          template_id: template.id,
          member_id: dto.member_id,
          actor_id: actor.id,
        },
      });

      const created = await this.planRepo.findPlanById(newPlan.id);
      return created!;
    });
  }

  async replaceMeals(
    planId: number,
    dto: DietPlanMealsWriteDto,
    actor: AuthenticatedUser,
  ): Promise<DietPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(planId);
    if (!existing) {
      throw new NotFoundError('Diet plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot modify meals on an archived diet plan');
    }

    return runInTransaction(this.db, async () => {
      // Optimistic concurrency check
      await this.planRepo.updatePlan(planId, {}, dto.row_version);

      const latestVersion = await this.planRepo.findLatestVersionByPlanId(planId);
      const nextVersionNumber = (latestVersion?.version_number ?? 0) + 1;

      const newVersion = await this.planRepo.insertVersion({
        diet_plan_id: planId,
        version_number: nextVersionNumber,
        changelog: dto.changelog ?? `Version ${nextVersionNumber} update`,
        created_at: new Date(),
      });

      if (dto.meals && dto.meals.length > 0) {
        for (let mIdx = 0; mIdx < dto.meals.length; mIdx++) {
          const mealDto = dto.meals[mIdx];
          const newMeal = await this.planRepo.insertMeal({
            diet_plan_version_id: newVersion.id,
            meal_name: mealDto.meal_name,
            scheduled_time: mealDto.scheduled_time ?? null,
            target_calories: mealDto.target_calories ?? null,
            notes: mealDto.notes ?? null,
            order_index: mIdx,
            created_at: new Date(),
          });

          if (mealDto.foods && mealDto.foods.length > 0) {
            await this.planRepo.insertFoods(
              mealDto.foods.map((f, fIdx) => ({
                diet_plan_meal_id: newMeal.id,
                food_id: f.food_id,
                quantity: f.quantity,
                serving_unit: f.serving_unit ?? null,
                order_index: fIdx,
                created_at: new Date(),
              })),
            );
          }
        }
      }

      this.eventBus.emitSync({
        eventName: 'diet_plan.version_created',
        occurredAt: new Date(),
        payload: {
          plan_id: planId,
          version_number: nextVersionNumber,
          actor_id: actor.id,
        },
      });

      const updated = await this.planRepo.findPlanById(planId);
      return updated!;
    });
  }

  async listVersions(
    planId: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<EnrichedDietPlanVersion>> {
    const plan = await this.planRepo.findPlanById(planId);
    if (!plan) {
      throw new NotFoundError('Diet plan not found');
    }

    if (!plan.is_template) {
      if (actor.userType === 'member') {
        if (plan.member_id !== actor.profileId) {
          throw new NotFoundError('Diet plan not found');
        }
      } else if (actor.userType === 'trainer') {
        if (plan.trainer_id !== actor.profileId && plan.member_id) {
          await this.assertCanAccessMember(actor, plan.member_id);
        }
      }
    }

    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);
    const { rows, total } = await this.planRepo.findVersionsByPlanId(planId, limit, offset ?? 0);
    return createPaginatedResponse({ items: rows, total, limit, offset: offset ?? 0 });
  }
}
