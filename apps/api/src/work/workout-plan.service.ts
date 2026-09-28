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
import { assertMemberAccess } from '../people/row-scope';
import {
  WorkoutPlanRepository,
  type WorkoutPlanWithDetails,
} from './workout-plan.repository';
import type {
  AssignPlanDto,
  WorkoutPlanCreateDto,
  WorkoutPlanExercisesWriteDto,
  WorkoutPlanFilterQueryDto,
  WorkoutPlanUpdateDto,
} from './workout-plan.dto';
import type { WorkoutPlan, WorkoutPlanVersion, WorkoutPlanExercise } from '../platform/db/schema/workout';
import type { Exercise } from '../platform/db/schema/exercises';

@Injectable()
export class WorkoutPlanService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    private readonly planRepo: WorkoutPlanRepository,
    private readonly memberRepo: MemberRepository,
    private readonly eventBus: DomainEventBus,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  private async assertCanManagePlan(plan: WorkoutPlan, actor: AuthenticatedUser): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'trainer') {
      if (plan.trainer_id === actor.profileId) {
        return;
      }
      if (plan.member_id) {
        await assertMemberAccess(this.memberRepo, actor, plan.member_id);
        return;
      }
      if (plan.is_template) {
        return;
      }
    }
    throw new ForbiddenError('Only trainers or staff may manage workout plans');
  }

  async list(
    rawQuery: Record<string, unknown>,
    filter: WorkoutPlanFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<WorkoutPlanWithDetails>> {
    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);

    let effectiveMemberId = filter.member_id;
    let effectiveTrainerId = filter.trainer_id;
    let effectiveIsTemplate = filter.is_template;

    if (actor.userType === 'member') {
      if (effectiveIsTemplate === true) {
        // Member explicitly requesting templates
        effectiveMemberId = undefined;
      } else {
        // Force member scope
        effectiveMemberId = actor.profileId ?? undefined;
        effectiveIsTemplate = false;
      }
    } else if (actor.userType === 'trainer') {
      if (effectiveMemberId) {
        await assertMemberAccess(this.memberRepo, actor, effectiveMemberId);
      }
      if (!effectiveMemberId && effectiveIsTemplate === undefined) {
        // Can see templates or own plans
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

  async getById(id: number, actor: AuthenticatedUser): Promise<WorkoutPlanWithDetails> {
    const plan = await this.planRepo.findPlanById(id);
    if (!plan) {
      throw new NotFoundError('Workout plan not found');
    }

    if (!plan.is_template) {
      if (actor.userType === 'member') {
        if (plan.member_id !== actor.profileId) {
          throw new NotFoundError('Workout plan not found');
        }
      } else if (actor.userType === 'trainer') {
        if (plan.trainer_id !== actor.profileId && plan.member_id) {
          await assertMemberAccess(this.memberRepo, actor, plan.member_id);
        }
      }
    }

    return plan;
  }

  async create(dto: WorkoutPlanCreateDto, actor: AuthenticatedUser): Promise<WorkoutPlanWithDetails> {
    const isTemplate = dto.is_template ?? false;

    if (isTemplate) {
      if (dto.member_id) {
        throw new BadRequestError('Templates cannot have an assigned member');
      }
      if (actor.userType === 'member') {
        throw new ForbiddenError('Members cannot create workout templates');
      }
    } else if (dto.member_id) {
      await assertMemberAccess(this.memberRepo, actor, dto.member_id);
    }

    const trainerId =
      actor.userType === 'trainer' ? actor.profileId : dto.trainer_id;

    return runInTransaction(this.db, async () => {
      const plan = await this.planRepo.insertPlan({
        title: dto.title,
        description: dto.description ?? null,
        member_id: isTemplate ? null : dto.member_id ?? null,
        trainer_id: trainerId ?? null,
        target_goal: dto.target_goal ?? null,
        difficulty: dto.difficulty ?? null,
        duration_weeks: dto.duration_weeks ?? null,
        is_template: isTemplate,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });

      const version = await this.planRepo.insertVersion({
        workout_plan_id: plan.id,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      this.eventBus.emitSync({
        eventName: 'workout_plan.created',
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
          exercises: [],
        },
      };
    });
  }

  async update(
    id: number,
    dto: WorkoutPlanUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Workout plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot update an archived workout plan');
    }

    if (dto.member_id && !existing.is_template) {
      await assertMemberAccess(this.memberRepo, actor, dto.member_id);
    }

    await this.planRepo.updatePlan(
      id,
      {
        title: dto.title,
        description: dto.description,
        member_id: dto.member_id,
        trainer_id: dto.trainer_id,
        target_goal: dto.target_goal,
        difficulty: dto.difficulty,
        duration_weeks: dto.duration_weeks,
        is_template: dto.is_template,
      },
      dto.row_version,
    );

    const updated = await this.planRepo.findPlanById(id);
    return updated!;
  }

  async publish(id: number, actor: AuthenticatedUser): Promise<WorkoutPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Workout plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'active') {
      return existing;
    }

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot publish an archived workout plan');
    }

    if (!existing.is_template && existing.member_id) {
      const activePlan = await this.planRepo.findActivePlanForMember(existing.member_id);
      if (activePlan && activePlan.id !== existing.id) {
        throw new ConflictError(
          'Member already has an active workout plan. Archive the current active plan before publishing a new one.',
        );
      }
    }

    await this.planRepo.updatePlan(id, { status: 'active' });

    this.eventBus.emitSync({
      eventName: 'workout_plan.published',
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

  async archive(id: number, actor: AuthenticatedUser): Promise<WorkoutPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(id);
    if (!existing) {
      throw new NotFoundError('Workout plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    await this.planRepo.updatePlan(id, { status: 'archived' });

    this.eventBus.emitSync({
      eventName: 'workout_plan.archived',
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
    dto: AssignPlanDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutPlanWithDetails> {
    const template = await this.planRepo.findPlanById(templateId);
    if (!template) {
      throw new NotFoundError('Template not found');
    }

    if (!template.is_template) {
      throw new BadRequestError('Specified workout plan is not a template');
    }

    await assertMemberAccess(this.memberRepo, actor, dto.member_id);

    const activePlan = await this.planRepo.findActivePlanForMember(dto.member_id);
    if (activePlan) {
      throw new ConflictError(
        'Member already has an active workout plan. Archive or complete it before assigning a new one.',
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
        target_goal: template.target_goal,
        difficulty: template.difficulty,
        duration_weeks: template.duration_weeks,
        is_template: false,
        status: 'active',
        row_version: 1,
        created_at: new Date(),
      });

      const newVersion = await this.planRepo.insertVersion({
        workout_plan_id: newPlan.id,
        version_number: 1,
        changelog: `Assigned from template "${template.title}"`,
        created_at: new Date(),
      });

      const templateExercises = template.current_version?.exercises ?? [];
      if (templateExercises.length > 0) {
        await this.planRepo.insertPlanExercises(
          templateExercises.map((e) => ({
            workout_plan_version_id: newVersion.id,
            exercise_id: e.exercise_id,
            day_number: e.day_number,
            order_index: e.order_index,
            target_sets: e.target_sets,
            target_reps: e.target_reps,
            target_weight_kg: e.target_weight_kg,
            rest_seconds: e.rest_seconds,
            notes: e.notes,
          })),
        );
      }

      this.eventBus.emitSync({
        eventName: 'workout_plan.assigned',
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

  async replaceExercises(
    planId: number,
    dto: WorkoutPlanExercisesWriteDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutPlanWithDetails> {
    const existing = await this.planRepo.findPlanById(planId);
    if (!existing) {
      throw new NotFoundError('Workout plan not found');
    }

    await this.assertCanManagePlan(existing, actor);

    if (existing.status === 'archived') {
      throw new BusinessRuleError('Cannot modify exercises on an archived workout plan');
    }

    return runInTransaction(this.db, async () => {
      // Optimistic concurrency check
      await this.planRepo.updatePlan(planId, {}, dto.row_version);

      const latestVersion = await this.planRepo.findLatestVersionByPlanId(planId);
      const nextVersionNumber = (latestVersion?.version_number ?? 0) + 1;

      const newVersion = await this.planRepo.insertVersion({
        workout_plan_id: planId,
        version_number: nextVersionNumber,
        changelog: dto.changelog ?? `Version ${nextVersionNumber} update`,
        created_at: new Date(),
      });

      if (dto.exercises && dto.exercises.length > 0) {
        await this.planRepo.insertPlanExercises(
          dto.exercises.map((e) => ({
            workout_plan_version_id: newVersion.id,
            exercise_id: e.exercise_id,
            day_number: e.day_number,
            order_index: e.order_index,
            target_sets: e.target_sets ?? 3,
            target_reps: e.target_reps ?? '10',
            target_weight_kg: e.target_weight_kg ? String(e.target_weight_kg) : null,
            rest_seconds: e.rest_seconds ?? 60,
            notes: e.notes ?? null,
          })),
        );
      }

      this.eventBus.emitSync({
        eventName: 'workout_plan.version_created',
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
  ): Promise<PaginatedResponse<WorkoutPlanVersion & { exercises: (WorkoutPlanExercise & { exercise?: Exercise })[] }>> {
    const plan = await this.planRepo.findPlanById(planId);
    if (!plan) {
      throw new NotFoundError('Workout plan not found');
    }

    if (!plan.is_template) {
      if (actor.userType === 'member') {
        if (plan.member_id !== actor.profileId) {
          throw new NotFoundError('Workout plan not found');
        }
      } else if (actor.userType === 'trainer') {
        if (plan.trainer_id !== actor.profileId && plan.member_id) {
          await assertMemberAccess(this.memberRepo, actor, plan.member_id);
        }
      }
    }

    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);
    const { rows, total } = await this.planRepo.findVersionsByPlanId(planId, limit, offset ?? 0);
    return createPaginatedResponse({ items: rows, total, limit, offset: offset ?? 0 });
  }
}
