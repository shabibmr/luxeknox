import { Injectable, Optional } from '@nestjs/common';
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
import { EmployeeRepository } from '../people/employee.repository';
import { NotificationService } from '../notif/notification.service';
import { assertMemberAccess } from '../people/row-scope';
import { PtAccessService } from '../pt/pt-access.service';
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
    @Optional() private readonly ptAccess?: PtAccessService,
    @Optional() private readonly medicalHistoryRepo?: MedicalHistoryRepository,
    @Optional() private readonly trainerRepo?: TrainerRepository,
    @Optional() private readonly employeeRepo?: EmployeeRepository,
    @Optional() private readonly notificationService?: NotificationService,
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

    const actualRir = dto.actual_rir ?? dto.target_rir;
    const actualDurationSeconds = dto.actual_duration_seconds ?? dto.target_duration_seconds;

    return this.sessionRepo.insertSessionExercise({
      workout_session_id: sessionId,
      exercise_id: dto.exercise_id,
      set_number: dto.set_number,
      reps_completed: dto.reps_completed ?? 0,
      weight_lifted_kg: String(dto.weight_lifted_kg ?? 0),
      rpe_score: dto.rpe_score !== undefined && dto.rpe_score !== null ? String(dto.rpe_score) : null,
      actual_rir: actualRir !== undefined && actualRir !== null ? String(actualRir) : null,
      actual_duration_seconds: actualDurationSeconds ?? null,
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

    if (dto.client_signed_at !== undefined) {
      clientSignedAt = dto.client_signed_at ? new Date(dto.client_signed_at) : null;
    } else if (dto.client_signed === true || (actor.userType === 'member' && dto.client_signed !== false)) {
      clientSignedAt = completedAt;
    } else if (dto.client_signed === false) {
      clientSignedAt = null;
    }

    if (dto.trainer_signed_at !== undefined) {
      trainerSignedAt = dto.trainer_signed_at ? new Date(dto.trainer_signed_at) : null;
    } else if (dto.trainer_signed === true || (actor.userType === 'trainer' && dto.trainer_signed !== false)) {
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

    await this.sessionRepo.completeSession(
      sessionId,
      completedAt,
      totalVolume.toFixed(2),
      durationMinutes,
      dto.client_feedback_rating,
      dto.notes,
      extra,
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
        effort_rating: dto.effort_rating ?? null,
        satisfaction_rating: dto.satisfaction_rating ?? null,
        pain_discomfort_score: dto.pain_discomfort_score ?? null,
      },
    });

    if (
      dto.pain_discomfort_score !== undefined &&
      dto.pain_discomfort_score !== null &&
      dto.pain_discomfort_score >= 4
    ) {
      await this.handleHighPainSafetyTrigger(
        session,
        dto.pain_discomfort_score,
        dto.pain_notes,
        completedAt,
        actor,
      );
    }

    return (await this.sessionRepo.findSessionById(sessionId))!;
  }

  private async handleHighPainSafetyTrigger(
    session: WorkoutSession,
    painScore: number,
    painNotes: string | null | undefined,
    completedAt: Date,
    actor: AuthenticatedUser,
  ): Promise<void> {
    const notesSuffix = painNotes ? `: ${painNotes}` : '';
    await this.medicalHistoryRepo?.insertHistory({
      member_id: session.member_id,
      title: `Active Discomfort Alert (Score: ${painScore}/10)`,
      description: `High pain or discomfort reported during workout session #${session.id}${notesSuffix}`,
      diagnosed_date: completedAt.toISOString().slice(0, 10),
      clearance_status: 'active',
      created_at: completedAt,
    });

    const recipientUserIds: number[] = [];

    // 1. Assigned trainer
    let trainerId = session.trainer_id;
    if (!trainerId) {
      const member = await this.memberRepo.findById(session.member_id);
      trainerId = member?.assigned_trainer_id ?? null;
    }
    if (trainerId && this.trainerRepo) {
      const trainer = await this.trainerRepo.findById(trainerId);
      if (trainer?.user_id) {
        recipientUserIds.push(trainer.user_id);
      }
    }

    // 2. Head coach / management
    if (this.employeeRepo) {
      const headCoaches = await this.employeeRepo.findManyFiltered({
        q: 'Head Coach',
        status: 'active',
        limit: 5,
        offset: 0,
      });
      for (const hc of headCoaches.rows) {
        if (hc.user_id) recipientUserIds.push(hc.user_id);
      }
      if (headCoaches.rows.length === 0) {
        const coaches = await this.employeeRepo.findManyFiltered({
          q: 'Coach',
          status: 'active',
          limit: 5,
          offset: 0,
        });
        for (const c of coaches.rows) {
          if (c.user_id) recipientUserIds.push(c.user_id);
        }
      }
    }

    const uniqueRecipients = Array.from(new Set(recipientUserIds)).filter((id) => id > 0);
    if (this.notificationService && uniqueRecipients.length > 0) {
      await this.notificationService.dispatch({
        recipientUserIds: uniqueRecipients,
        title: 'High Pain/Discomfort Safety Alert',
        message: `Member #${session.member_id} reported a high pain/discomfort score of ${painScore}/10 in workout session #${session.id}.${painNotes ? ` Notes: ${painNotes}` : ''}`,
        typeCode: 'announcement',
        dataPayload: {
          session_id: session.id,
          member_id: session.member_id,
          pain_discomfort_score: painScore,
          pain_notes: painNotes ?? null,
          priority: 'high',
        },
      });
    }

    this.eventBus.emitSync({
      eventName: 'workout_session.safety_alert',
      occurredAt: completedAt,
      payload: {
        session_id: session.id,
        member_id: session.member_id,
        pain_discomfort_score: painScore,
        pain_notes: painNotes ?? null,
        recipient_user_ids: uniqueRecipients,
        actor_id: actor.id,
      },
    });
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
    const rir = dto.actual_rir !== undefined ? dto.actual_rir : dto.target_rir;
    if (rir !== undefined) {
      patch.actual_rir = rir !== null ? String(rir) : null;
    }
    const duration =
      dto.actual_duration_seconds !== undefined
        ? dto.actual_duration_seconds
        : dto.target_duration_seconds;
    if (duration !== undefined) {
      patch.actual_duration_seconds = duration;
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
