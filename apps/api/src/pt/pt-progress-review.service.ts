import { Injectable } from '@nestjs/common';
import { z } from 'zod';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { GoalRepository } from '../goal/goal.repository';
import { MemberRepository } from '../people/member.repository';
import { requireScopedMember } from '../people/require-scoped-member';
import { AuditService } from '../platform/audit/audit.service';
import type {
  BodyMetricSnapshot,
  NewPtProgressReview,
  PtProgressReview,
} from '../platform/db/schema/personal-training';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { PtAccessService } from './pt-access.service';
import { PtProgressReviewRepository } from './pt-progress-review.repository';

const isoDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Expected YYYY-MM-DD');

export const ptProgressReviewDraftSchema = z.object({
  review_period_start: isoDate,
  review_period_end: isoDate,
  trainer_summary: z.string().optional().nullable(),
  client_feedback: z.string().optional().nullable(),
  next_phase_goal: z.string().optional().nullable(),
  next_phase_training_focus: z.string().optional().nullable(),
  next_review_date: isoDate.optional().nullable(),
});
export type PtProgressReviewDraftDto = z.infer<typeof ptProgressReviewDraftSchema>;

/** Goal statuses whose progress is reported on a review card. */
const REPORTED_GOAL_STATUSES = new Set(['in_progress', 'achieved']);

function round2(n: number): number {
  return Math.round(n * 100) / 100;
}

/** `change_val` is always `current - start`, matching the Page 8 measures table. */
export function buildBodyMetricSnapshot(
  goals: Array<{
    status: string;
    baseline_value: number;
    current_value: number;
    target_value: number;
    metric: { name: string };
  }>,
): BodyMetricSnapshot[] {
  return goals
    .filter((g) => REPORTED_GOAL_STATUSES.has(g.status))
    .map((g) => ({
      metric: g.metric.name,
      start_val: g.baseline_value,
      current_val: g.current_value,
      change_val: round2(g.current_value - g.baseline_value),
      target_val: g.target_value,
    }));
}

function nullableTrimmed(value: string | null | undefined): string | null {
  const trimmed = value?.trim();
  return trimmed ? trimmed : null;
}

@Injectable()
export class PtProgressReviewService {
  constructor(
    private readonly repository: PtProgressReviewRepository,
    private readonly memberRepository: MemberRepository,
    private readonly goalRepository: GoalRepository,
    private readonly ptAccess: PtAccessService,
    private readonly auditService: AuditService,
  ) {}

  async createDraft(
    memberId: number,
    dto: PtProgressReviewDraftDto,
    actor: AuthenticatedUser,
  ): Promise<PtProgressReview> {
    const member = await requireScopedMember(this.memberRepository, memberId, actor);
    await this.ptAccess.assertTrainerCanWrite(actor, memberId);

    if (dto.review_period_end < dto.review_period_start) {
      throw new BusinessRuleError('Review period end must not be before its start');
    }

    const trainerId = actor.userType === 'trainer' ? actor.profileId : member.assigned_trainer_id;
    if (trainerId == null) {
      throw new BusinessRuleError('A trainer must be assigned to the member to draft a review');
    }

    const { rows: goals } = await this.goalRepository.findManyByMemberId(memberId);
    const now = new Date();

    const id = await this.repository.insertReview({
      member_id: memberId,
      trainer_id: trainerId,
      review_period_start: dto.review_period_start,
      review_period_end: dto.review_period_end,
      body_metrics_snapshot: buildBodyMetricSnapshot(goals),
      trainer_summary: nullableTrimmed(dto.trainer_summary),
      client_feedback: nullableTrimmed(dto.client_feedback),
      next_phase_goal: nullableTrimmed(dto.next_phase_goal),
      next_phase_training_focus: nullableTrimmed(dto.next_phase_training_focus),
      next_review_date: dto.next_review_date ?? null,
      status: 'draft',
      created_at: now,
    });

    const saved = await this.repository.findReviewById(id);
    if (!saved) throw new NotFoundError('Progress review not found');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'pt_progress_review.drafted',
      entityName: 'pt_progress_reviews',
      entityId: id,
      afterState: saved,
    });
    return saved;
  }

  async get(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    await requireScopedMember(this.memberRepository, review.member_id, actor);
    return review;
  }

  /** draft -> pending_client_sign. Only the review's trainer (or an admin) may sign. */
  async trainerSign(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    await requireScopedMember(this.memberRepository, review.member_id, actor);
    if (actor.userType === 'trainer' && actor.profileId !== review.trainer_id) {
      throw new ForbiddenError('Only the review trainer can sign this review');
    }
    await this.ptAccess.assertTrainerCanWrite(actor, review.member_id);
    this.assertStatus(review, 'draft', 'trainer-sign');
    const now = new Date();
    return this.transition(review, actor, 'pt_progress_review.trainer_signed', {
      status: 'pending_client_sign',
      trainer_signed_at: now,
      updated_at: now,
    });
  }

  /** pending_client_sign -> pending_manager_approval. Only the reviewed member may sign. */
  async clientSign(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    const member = await this.memberRepository.findById(review.member_id);
    if (!member) throw new NotFoundError('Member not found');
    if (actor.userType !== 'member' || member.user_id !== actor.id) {
      throw new ForbiddenError('Only the reviewed client can sign this review');
    }
    this.assertStatus(review, 'pending_client_sign', 'client-sign');
    const now = new Date();
    return this.transition(review, actor, 'pt_progress_review.client_signed', {
      status: 'pending_manager_approval',
      client_signed_at: now,
      updated_at: now,
    });
  }

  /** pending_manager_approval -> approved. Staff other than trainers/members only. */
  async managerApprove(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    if (actor.userType === 'member' || actor.userType === 'trainer') {
      throw new ForbiddenError('Only management can approve a review');
    }
    this.assertStatus(review, 'pending_manager_approval', 'manager-approve');
    const now = new Date();
    return this.transition(review, actor, 'pt_progress_review.manager_approved', {
      status: 'approved',
      manager_user_id: actor.id,
      manager_signed_at: now,
      updated_at: now,
    });
  }

  private async requireReview(id: number): Promise<PtProgressReview> {
    const review = await this.repository.findReviewById(id);
    if (!review) throw new NotFoundError('Progress review not found');
    return review;
  }

  private assertStatus(review: PtProgressReview, expected: PtProgressReview['status'], step: string) {
    if (review.status !== expected) {
      throw new BusinessRuleError(`Cannot ${step}: review is ${review.status}, expected ${expected}`);
    }
  }

  private async transition(
    before: PtProgressReview,
    actor: AuthenticatedUser,
    action: string,
    patch: Partial<NewPtProgressReview>,
  ): Promise<PtProgressReview> {
    await this.repository.updateReview(before.id, patch);
    const after = await this.requireReview(before.id);
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action,
      entityName: 'pt_progress_reviews',
      entityId: before.id,
      beforeState: before,
      afterState: after,
    });
    return after;
  }
}
