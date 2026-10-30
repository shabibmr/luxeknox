import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import { PaginationHelper, createPaginatedResponse } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { MemberRepository } from '../people/member.repository';
import { MedicalHistoryRepository } from '../people/medical-history.repository';
import { TrainerRepository } from '../people/trainer.repository';
import { assertMemberAccess } from '../people/row-scope';
import { PtAccessService } from '../pt/pt-access.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import { AuditService } from '../platform/audit/audit.service';
import { WorkoutPlanRepository } from './workout-plan.repository';
import {
  WorkoutSessionRepository,
  type WorkoutSessionWithSets,
  type PersonalRecordResult,
} from './workout-session.repository';
import { HIGH_PAIN_THRESHOLD } from './workout-pain';
import type {
  WorkoutSessionCompleteDto,
  WorkoutSessionCreateDto,
  WorkoutSessionFilterQueryDto,
  WorkoutSetUpdateDto,
  WorkoutSetWriteDto,
} from './workout-session.dto';
import type { WorkoutSession, WorkoutSessionExercise } from '../platform/db/schema/workout';

@Injectable()
export class WorkoutSessionService {
  constructor(
    private readonly sessionRepo: WorkoutSessionRepository,
    private readonly planRepo: WorkoutPlanRepository,
    private readonly memberRepo: MemberRepository,
    private readonly eventBus: DomainEventBus,
    private readonly paginationHelper: PaginationHelper,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    @Optional() private readonly ptAccess?: PtAccessService,
    @Optional() private readonly medicalHistoryRepo?: MedicalHistoryRepository,
    @Optional() private readonly trainerRepo?: TrainerRepository,
    @Optional() private readonly auditService?: AuditService,
  ) {}

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
      await assertMemberAccess(this.memberRepo, actor, effectiveMemberId);
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

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
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

    await assertMemberAccess(this.memberRepo, actor, memberId);
    await this.ptAccess?.assertTrainerCanWrite(actor, memberId);

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

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
    await this.ptAccess?.assertTrainerCanWrite(actor, session.member_id);

    if (session.completed_at !== null) {
      throw new BusinessRuleError('Cannot log sets for a completed workout session');
    }

    return this.sessionRepo.insertSessionExercise({
      workout_session_id: sessionId,
      exercise_id: dto.exercise_id,
      set_number: dto.set_number,
      reps_completed: dto.reps_completed ?? 0,
      weight_lifted_kg: String(dto.weight_lifted_kg ?? 0),
      rpe_score: dto.rpe_score !== undefined && dto.rpe_score !== null ? String(dto.rpe_score) : null,
      actual_rir: dto.actual_rir !== undefined && dto.actual_rir !== null ? String(dto.actual_rir) : null,
      actual_duration_seconds: dto.actual_duration_seconds ?? null,
      is_completed: dto.is_completed ?? true,
      notes: dto.notes ?? null,
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

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
    await this.ptAccess?.assertTrainerCanWrite(actor, session.member_id);

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

    let clientSignedAt: Date | null = session.client_signed_at ?? null;
    let trainerSignedAt: Date | null = session.trainer_signed_at ?? null;

    if (dto.client_signed === true || (actor.userType === 'member' && dto.client_signed !== false)) {
      clientSignedAt = completedAt;
    } else if (dto.client_signed === false) {
      clientSignedAt = null;
    }

    if (dto.trainer_signed === true || (actor.userType === 'trainer' && dto.trainer_signed !== false)) {
      trainerSignedAt = completedAt;
    } else if (dto.trainer_signed === false) {
      trainerSignedAt = null;
    }

    const extra: {
      effort_rating?: number | null;
      satisfaction_rating?: number | null;
      pain_discomfort_score?: number | null;
      pain_notes?: string | null;
      trainer_notes?: string | null;
      next_session_plan?: string | null;
      session_focus?: string | null;
      warmup_protocol?: string | null;
      cooldown_protocol?: string | null;
      client_signed_at?: Date | null;
      trainer_signed_at?: Date | null;
    } = {
      client_signed_at: clientSignedAt,
      trainer_signed_at: trainerSignedAt,
    };

    if (dto.effort_rating !== undefined) extra.effort_rating = dto.effort_rating;
    if (dto.satisfaction_rating !== undefined) extra.satisfaction_rating = dto.satisfaction_rating;
    if (dto.pain_discomfort_score !== undefined) extra.pain_discomfort_score = dto.pain_discomfort_score;
    if (dto.pain_notes !== undefined) extra.pain_notes = dto.pain_notes;
    if (dto.trainer_notes !== undefined) extra.trainer_notes = dto.trainer_notes;
    if (dto.next_session_plan !== undefined) extra.next_session_plan = dto.next_session_plan;
    if (dto.session_focus !== undefined) extra.session_focus = dto.session_focus;
    if (dto.warmup_protocol !== undefined) extra.warmup_protocol = dto.warmup_protocol;
    if (dto.cooldown_protocol !== undefined) extra.cooldown_protocol = dto.cooldown_protocol;

    const isHighPain =
      typeof dto.pain_discomfort_score === 'number' &&
      dto.pain_discomfort_score >= HIGH_PAIN_THRESHOLD;

    await runInTransaction(this.db, async () => {
      await this.sessionRepo.completeSession(
        sessionId,
        completedAt,
        totalVolume.toFixed(2),
        durationMinutes,
        dto.client_feedback_rating ?? undefined,
        dto.notes ?? undefined,
        extra,
      );

      if (isHighPain) {
        if (!this.medicalHistoryRepo || !this.auditService) {
          throw new BusinessRuleError(
            'Medical history and audit services are required for high pain safety trigger',
          );
        }

        const notesSuffix = dto.pain_notes ? `: ${dto.pain_notes}` : '';
        const historyId = await this.medicalHistoryRepo.insertHistory({
          member_id: session.member_id,
          title: `Active Discomfort Alert (Score: ${dto.pain_discomfort_score}/10)`,
          description: `High pain or discomfort reported during workout session #${session.id}${notesSuffix}`,
          diagnosed_date: completedAt.toISOString().slice(0, 10),
          clearance_status: 'active',
          created_at: completedAt,
        });

        await this.auditService.recordAudit({
          actorUserId: actor.id,
          action: 'medical_history.created',
          entityName: 'medical_histories',
          entityId: historyId,
          afterState: {
            id: historyId,
            member_id: session.member_id,
            title: `Active Discomfort Alert (Score: ${dto.pain_discomfort_score}/10)`,
            description: `High pain or discomfort reported during workout session #${session.id}${notesSuffix}`,
            diagnosed_date: completedAt.toISOString().slice(0, 10),
            clearance_status: 'active',
            created_at: completedAt,
          },
        });
      }
    });

    this.eventBus.emitSync({
      eventName: 'workout_session.completed',
      occurredAt: new Date(),
      payload: {
        session_id: session.id,
        member_id: session.member_id,
        total_volume_kg: totalVolume,
        duration_minutes: durationMinutes,
        actor_id: actor.id,
        effort_rating: dto.effort_rating ?? null,
        satisfaction_rating: dto.satisfaction_rating ?? null,
        pain_discomfort_score: dto.pain_discomfort_score ?? null,
      },
    });

    if (isHighPain) {
      let assignedTrainerUserId: number | null = null;
      const member = await this.memberRepo.findById(session.member_id);
      if (member?.assigned_trainer_id && this.trainerRepo) {
        const assignedTrainer = await this.trainerRepo.findById(member.assigned_trainer_id);
        assignedTrainerUserId = assignedTrainer?.user_id ?? null;
      }

      let sessionTrainerUserId: number | null = null;
      if (session.trainer_id && this.trainerRepo) {
        const sessionTrainer = await this.trainerRepo.findById(session.trainer_id);
        sessionTrainerUserId = sessionTrainer?.user_id ?? null;
      }

      this.eventBus.emitSync({
        eventName: 'workout_session.safety_alert',
        occurredAt: completedAt,
        payload: {
          sessionId: session.id,
          memberId: session.member_id,
          painDiscomfortScore: dto.pain_discomfort_score!,
          painNotes: dto.pain_notes ?? null,
          assignedTrainerUserId,
          sessionTrainerUserId,
        },
      });
    }

    return (await this.sessionRepo.findSessionById(sessionId))!;
  }

  async getActive(
    memberId: number | undefined,
    actor: AuthenticatedUser,
  ): Promise<WorkoutSessionWithSets> {
    let effectiveMemberId = memberId;
    if (actor.userType === 'member') {
      effectiveMemberId = actor.profileId ?? undefined;
    }

    if (!effectiveMemberId) {
      throw new BadRequestError('member_id is required');
    }

    await assertMemberAccess(this.memberRepo, actor, effectiveMemberId);

    const active = await this.sessionRepo.findActiveSessionForMember(effectiveMemberId);
    if (!active) {
      throw new NotFoundError('No active workout session');
    }

    return (await this.sessionRepo.findSessionById(active.id))!;
  }

  async updateSet(
    sessionId: number,
    setId: number,
    dto: WorkoutSetUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<WorkoutSessionExercise> {
    const session = await this.sessionRepo.findSessionById(sessionId);
    if (!session) {
      throw new NotFoundError('Workout session not found');
    }

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
    await this.ptAccess?.assertTrainerCanWrite(actor, session.member_id);

    if (session.completed_at !== null) {
      throw new BusinessRuleError('Cannot modify sets of a completed workout session');
    }

    const existing = await this.sessionRepo.findSetInSession(sessionId, setId);
    if (!existing) {
      throw new NotFoundError('Workout set not found');
    }

    const patch: Partial<
      Pick<
        WorkoutSessionExercise,
        | 'reps_completed'
        | 'weight_lifted_kg'
        | 'rpe_score'
        | 'actual_rir'
        | 'actual_duration_seconds'
        | 'is_completed'
        | 'notes'
      >
    > = {};
    if (dto.reps_completed !== undefined) {
      patch.reps_completed = dto.reps_completed;
    }
    if (dto.weight_lifted_kg !== undefined) {
      patch.weight_lifted_kg = String(dto.weight_lifted_kg);
    }
    if (dto.rpe_score !== undefined) {
      patch.rpe_score = dto.rpe_score !== null ? String(dto.rpe_score) : null;
    }
    if (dto.actual_rir !== undefined) {
      patch.actual_rir = dto.actual_rir !== null ? String(dto.actual_rir) : null;
    }
    if (dto.actual_duration_seconds !== undefined) {
      patch.actual_duration_seconds = dto.actual_duration_seconds;
    }
    if (dto.is_completed !== undefined) {
      patch.is_completed = dto.is_completed;
    }
    if (dto.notes !== undefined) {
      patch.notes = dto.notes;
    }

    return this.sessionRepo.updateSessionExercise(setId, patch);
  }

  async deleteSet(sessionId: number, setId: number, actor: AuthenticatedUser): Promise<void> {
    const session = await this.sessionRepo.findSessionById(sessionId);
    if (!session) {
      throw new NotFoundError('Workout session not found');
    }

    await assertMemberAccess(this.memberRepo, actor, session.member_id);
    await this.ptAccess?.assertTrainerCanWrite(actor, session.member_id);

    if (session.completed_at !== null) {
      throw new BusinessRuleError('Cannot modify sets of a completed workout session');
    }

    const existing = await this.sessionRepo.findSetInSession(sessionId, setId);
    if (!existing) {
      throw new NotFoundError('Workout set not found');
    }

    await this.sessionRepo.deleteSessionExercise(setId);
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

    await assertMemberAccess(this.memberRepo, actor, memberId);

    return this.sessionRepo.findPersonalRecords(memberId, exerciseId);
  }

  async getExerciseHistory(
    memberId: number | undefined,
    exerciseId: number,
    actor: AuthenticatedUser,
  ) {
    let effectiveMemberId = memberId;
    if (actor.userType === 'member') {
      effectiveMemberId = actor.profileId ?? undefined;
    }

    if (!effectiveMemberId) {
      throw new BadRequestError('member_id is required');
    }

    await assertMemberAccess(this.memberRepo, actor, effectiveMemberId);

    return this.sessionRepo.findExerciseHistory(effectiveMemberId, exerciseId);
  }
}
