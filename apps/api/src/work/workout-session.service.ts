import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
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
import { WorkoutPlanRepository } from './workout-plan.repository';
import {
  WorkoutSessionRepository,
  type WorkoutSessionWithSets,
  type PersonalRecordResult,
} from './workout-session.repository';
import type {
  WorkoutSessionCompleteDto,
  WorkoutSessionCreateDto,
  WorkoutSessionFilterQueryDto,
  WorkoutSetWriteDto,
} from './workout-plan.dto';
import type { WorkoutSessionExercise } from '../platform/db/schema/workout';

@Injectable()
export class WorkoutSessionService {
  constructor(
    private readonly sessionRepo: WorkoutSessionRepository,
    private readonly planRepo: WorkoutPlanRepository,
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

  async listSessions(
    rawQuery: Record<string, unknown>,
    filter: WorkoutSessionFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<WorkoutSessionWithSets>> {
    const { limit, offset } = await this.paginationHelper.normalizeParams(rawQuery);

    let effectiveMemberId = filter.member_id;

    if (actor.userType === 'member') {
      effectiveMemberId = actor.profileId ?? undefined;
    } else if (actor.userType === 'trainer' && effectiveMemberId) {
      await this.assertCanAccessMember(actor, effectiveMemberId);
    }

    const { rows, total } = await this.sessionRepo.findSessions(
      effectiveMemberId,
      limit,
      offset ?? 0,
    );

    return createPaginatedResponse({ items: rows, total, limit, offset: offset ?? 0 });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<WorkoutSessionWithSets> {
    const session = await this.sessionRepo.findSessionById(id);
    if (!session) {
      throw new NotFoundError('Workout session not found');
    }

    await this.assertCanAccessMember(actor, session.member_id);
    return session;
  }

  async start(
    dto: WorkoutSessionCreateDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutSessionWithSets> {
    let memberId = dto.member_id;
    if (actor.userType === 'member') {
      memberId = actor.profileId ?? undefined;
    }

    if (!memberId) {
      throw new BadRequestError('member_id is required');
    }

    await this.assertCanAccessMember(actor, memberId);

    const activeSession = await this.sessionRepo.findActiveSessionForMember(memberId);
    if (activeSession) {
      throw new ConflictError(
        'Member already has an active workout session in progress. Complete or cancel it first.',
      );
    }

    let versionId = dto.workout_plan_version_id;
    let trainerId: number | null = null;

    if (dto.workout_plan_id) {
      const plan = await this.planRepo.findPlanById(dto.workout_plan_id);
      if (!plan) {
        throw new NotFoundError('Workout plan not found');
      }
      trainerId = plan.trainer_id;
      if (!versionId) {
        const latestVersion = await this.planRepo.findLatestVersionByPlanId(dto.workout_plan_id);
        versionId = latestVersion?.id;
      }
    }

    if (actor.userType === 'trainer') {
      trainerId = actor.profileId ?? null;
    }

    const session = await this.sessionRepo.insertSession({
      member_id: memberId,
      workout_plan_id: dto.workout_plan_id ?? null,
      workout_plan_version_id: versionId ?? null,
      trainer_id: trainerId,
      started_at: new Date(),
      total_volume_kg: '0.00',
      created_at: new Date(),
    });

    this.eventBus.emitSync({
      eventName: 'workout_session.started',
      occurredAt: new Date(),
      payload: {
        session_id: session.id,
        member_id: session.member_id,
        workout_plan_id: session.workout_plan_id,
        actor_id: actor.id,
      },
    });

    return {
      ...session,
      sets: [],
    };
  }

  async logSet(
    sessionId: number,
    dto: WorkoutSetWriteDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutSessionExercise> {
    const session = await this.sessionRepo.findSessionById(sessionId);
    if (!session) {
      throw new NotFoundError('Workout session not found');
    }

    await this.assertCanAccessMember(actor, session.member_id);

    if (session.completed_at !== null) {
      throw new BusinessRuleError('Cannot log sets for a completed workout session');
    }

    return this.sessionRepo.insertSessionExercise({
      workout_session_id: sessionId,
      exercise_id: dto.exercise_id,
      set_number: dto.set_number,
      reps_completed: dto.reps_completed ?? 0,
      weight_lifted_kg: String(dto.weight_lifted_kg ?? 0),
      rpe_score: dto.rpe_score ? String(dto.rpe_score) : null,
      is_completed: dto.is_completed ?? true,
      created_at: new Date(),
    });
  }

  async complete(
    sessionId: number,
    dto: WorkoutSessionCompleteDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutSessionWithSets> {
    const session = await this.sessionRepo.findSessionById(sessionId);
    if (!session) {
      throw new NotFoundError('Workout session not found');
    }

    await this.assertCanAccessMember(actor, session.member_id);

    if (session.completed_at !== null) {
      return session;
    }

    const sets = await this.sessionRepo.findSetsBySessionId(sessionId);
    const totalVolume = sets
      .filter((s) => s.is_completed)
      .reduce((sum, s) => {
        const reps = Number(s.reps_completed || 0);
        const weight = Number(s.weight_lifted_kg || 0);
        return sum + reps * weight;
      }, 0);

    const completedAt = new Date();
    const durationMinutes = Math.max(
      1,
      Math.round((completedAt.getTime() - new Date(session.started_at).getTime()) / 60000),
    );

    await this.sessionRepo.completeSession(
      sessionId,
      completedAt,
      totalVolume.toFixed(2),
      durationMinutes,
      dto.client_feedback_rating,
      dto.notes,
    );

    this.eventBus.emitSync({
      eventName: 'workout_session.completed',
      occurredAt: new Date(),
      payload: {
        session_id: session.id,
        member_id: session.member_id,
        total_volume_kg: totalVolume,
        duration_minutes: durationMinutes,
        actor_id: actor.id,
      },
    });

    return (await this.sessionRepo.findSessionById(sessionId))!;
  }

  async getPersonalRecords(
    memberId: number | undefined,
    exerciseId: number | undefined,
    actor: AuthenticatedUser,
  ): Promise<PersonalRecordResult[]> {
    if (actor.userType === 'member') {
      if (memberId && memberId !== actor.profileId) {
        throw new NotFoundError('Member not found');
      }
      memberId = actor.profileId ?? undefined;
    }

    if (!memberId) {
      throw new BadRequestError('member_id is required');
    }

    await this.assertCanAccessMember(actor, memberId);

    return this.sessionRepo.findPersonalRecords(memberId, exerciseId);
  }
}
