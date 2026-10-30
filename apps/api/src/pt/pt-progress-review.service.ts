import { Inject, Injectable } from '@nestjs/common';
import { z } from 'zod';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { GoalRepository } from '../goal/goal.repository';
import { MeasurementRepository } from '../goal/measurement.repository';
import { MemberRepository } from '../people/member.repository';
import { requireScopedMember } from '../people/require-scoped-member';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { GoalMetricCategory } from '../platform/db/schema/goals';
import type {
  BodyMetricSnapshot,
  NewPtProgressReview,
  PresentationCardRow,
  PtProgressReview,
} from '../platform/db/schema/personal-training';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { PtAccessService } from './pt-access.service';
import { PtProgressReviewRepository } from './pt-progress-review.repository';

const isoDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Expected YYYY-MM-DD');

export const PAGE8_PROGRESS_HIGHLIGHTS = [
  'improved_technique',
  'increased_strength',
  'improved_conditioning',
  'better_consistency',
  'improved_mobility',
  'goal_milestone',
  'other',
] as const;
export type Page8ProgressHighlight = (typeof PAGE8_PROGRESS_HIGHLIGHTS)[number];

/** Printed labels for the highlight checkboxes on the presentation card. */
export const PAGE8_PROGRESS_HIGHLIGHT_LABELS: Record<Page8ProgressHighlight, string> = {
  improved_technique: 'Improved technique',
  increased_strength: 'Increased strength',
  improved_conditioning: 'Improved conditioning',
  better_consistency: 'Better consistency',
  improved_mobility: 'Improved mobility',
  goal_milestone: 'Goal milestone achieved',
  other: 'Other',
};

const progressHighlightsSchema = z
  .array(z.enum(PAGE8_PROGRESS_HIGHLIGHTS))
  .refine((items) => new Set(items).size === items.length, {
    message: 'progress_highlights must not contain duplicates',
  });

const MAX_CARD_TEXT_LENGTH = 2000;
const cardText = z.string().trim().max(MAX_CARD_TEXT_LENGTH);

export const ptProgressReviewDraftSchema = z.object({
  review_period_start: isoDate,
  review_period_end: isoDate,
  trainer_summary: cardText.optional().nullable(),
  client_feedback: cardText.optional().nullable(),
  next_phase_goal: z.string().optional().nullable(),
  next_phase_training_focus: z.string().optional().nullable(),
  next_review_date: isoDate.optional().nullable(),
  progress_highlights: progressHighlightsSchema.optional(),
  highlights_other_text: z.string().optional().nullable(),
});
export type PtProgressReviewDraftDto = z.infer<typeof ptProgressReviewDraftSchema>;

/** Partial update of a draft's presentation card. The period and measure rows are not editable. */
export const ptProgressReviewDraftEditSchema = z
  .object({
    progress_highlights: progressHighlightsSchema.nullable(),
    highlights_other_text: z.string().nullable(),
    trainer_summary: cardText.nullable(),
    client_feedback: cardText.nullable(),
    next_phase_goal: z.string().nullable(),
    next_phase_training_focus: z.string().nullable(),
    next_review_date: isoDate.nullable(),
    review_checklist: z
      .object({
        goals_reviewed: z.boolean(),
        measurements_reviewed: z.boolean(),
        performance_reviewed: z.boolean(),
        attendance_reviewed: z.boolean(),
        program_updated: z.boolean(),
        next_goals_agreed: z.boolean(),
      })
      .partial()
      .strict(),
  })
  .partial()
  .strict();
export type PtProgressReviewDraftEditDto = z.infer<typeof ptProgressReviewDraftEditSchema>;

/** Goal statuses that may supply a review target. Abandoned goals do not. */
const REPORTED_GOAL_STATUSES = new Set(['in_progress', 'achieved']);

type SnapshotMeasurementValue = {
  metric_id: number;
  metric_name: string;
  category: string;
  unit_of_measure: string;
  value: number;
};

type SnapshotMeasurementSession = {
  id?: number;
  recorded_at: Date;
  values: SnapshotMeasurementValue[];
};

type SnapshotMetric = { id: number; name: string; category: string };

type SnapshotGoal = {
  id: number;
  metric_id: number;
  status: string;
  target_value: number;
  metric: { name: string; category: string };
};

type SnapshotPeriod = {
  review_period_start: string;
  review_period_end: string;
};

const BODY_COMPOSITION: GoalMetricCategory = 'body_composition';
const CIRCUMFERENCE: GoalMetricCategory = 'circumference';
const STRENGTH: GoalMetricCategory = 'strength';

/** Decimal places kept while subtracting, so doubles never reach the rounding step. */
const SCALE = 10;

/** `a - b` rounded half away from zero to two decimals, computed on decimal strings. */
function roundedChange(current: number, start: number): number {
  const scaled = (n: number) => BigInt(n.toFixed(SCALE).replace('.', ''));
  const diff = scaled(current) - scaled(start);
  const negative = diff < 0n;
  const magnitude = negative ? -diff : diff;
  const unit = 10n ** BigInt(SCALE - 2);
  const hundredths = (magnitude + unit / 2n) / unit;
  const value = Number(hundredths) / 100;
  return negative && hundredths !== 0n ? -value : value;
}

function calendarDay(recordedAt: Date): string {
  return recordedAt.toISOString().slice(0, 10);
}

/** Value of the latest session on or before `boundary` (a calendar date) that measured the metric. */
function valueOnOrBefore(
  sessions: SnapshotMeasurementSession[],
  metricId: number,
  boundary: string,
): number | null {
  let best: { at: number; id: number; value: number } | null = null;
  for (const session of sessions) {
    if (calendarDay(session.recorded_at) > boundary) continue;
    const point = session.values.find((v) => v.metric_id === metricId);
    if (!point) continue;
    const at = session.recorded_at.getTime();
    const id = session.id ?? 0;
    if (!best || at > best.at || (at === best.at && id >= best.id)) {
      best = { at, id, value: point.value };
    }
  }
  return best ? best.value : null;
}

function cardRow(
  row: PresentationCardRow,
  metric: SnapshotMetric | null,
  sessions: SnapshotMeasurementSession[],
  period: SnapshotPeriod,
  goals: SnapshotGoal[],
): BodyMetricSnapshot {
  if (!metric) {
    return { row, metric: null, start_val: null, current_val: null, change_val: null, target_val: null };
  }
  const start = valueOnOrBefore(sessions, metric.id, period.review_period_start);
  const current = valueOnOrBefore(sessions, metric.id, period.review_period_end);
  const target = goals
    .filter((g) => g.metric_id === metric.id && REPORTED_GOAL_STATUSES.has(g.status))
    .sort((a, b) => a.id - b.id)[0];
  return {
    row,
    metric: metric.name,
    start_val: start,
    current_val: current,
    change_val: start != null && current != null ? roundedChange(current, start) : null,
    target_val: target ? target.target_value : null,
  };
}

function knownMetrics(sessions: SnapshotMeasurementSession[], goals: SnapshotGoal[]): SnapshotMetric[] {
  const byId = new Map<number, SnapshotMetric>();
  for (const session of sessions) {
    for (const v of session.values) {
      byId.set(v.metric_id, { id: v.metric_id, name: v.metric_name, category: v.category });
    }
  }
  for (const goal of goals) {
    if (!byId.has(goal.metric_id)) {
      byId.set(goal.metric_id, { id: goal.metric_id, ...goal.metric });
    }
  }
  return [...byId.values()].sort((a, b) => a.id - b.id);
}

function isCardio(metric: SnapshotMetric): boolean {
  return metric.name.toLowerCase().includes('cardio');
}

function measuredInPeriod(
  sessions: SnapshotMeasurementSession[],
  metricId: number,
  period: SnapshotPeriod,
): boolean {
  return sessions.some((session) => {
    const day = calendarDay(session.recorded_at);
    return (
      day >= period.review_period_start &&
      day <= period.review_period_end &&
      session.values.some((v) => v.metric_id === metricId)
    );
  });
}

/** The five Page 8 measure rows, from measurement sessions on or before the period boundaries. */
export function buildPresentationCardRows(
  sessions: SnapshotMeasurementSession[],
  period: SnapshotPeriod,
  goals: SnapshotGoal[],
): BodyMetricSnapshot[] {
  const metrics = knownMetrics(sessions, goals);
  const named = (category: string, name: string) =>
    metrics.find((m) => m.category === category && m.name.toLowerCase() === name) ?? null;

  const weight = named(BODY_COMPOSITION, 'weight');
  const waist = named(CIRCUMFERENCE, 'waist');
  const strength =
    named(STRENGTH, 'strength') ??
    metrics.find(
      (m) =>
        m.category === STRENGTH &&
        !isCardio(m) &&
        measuredInPeriod(sessions, m.id, period),
    ) ??
    null;
  const cardio = metrics.find(isCardio) ?? null;
  const used = new Set([weight, waist, strength, cardio].flatMap((m) => (m ? [m.id] : [])));
  const otherGoal = goals
    .filter((g) => REPORTED_GOAL_STATUSES.has(g.status) && !used.has(g.metric_id))
    .sort((a, b) => a.id - b.id)[0];
  const other = otherGoal ? { id: otherGoal.metric_id, ...otherGoal.metric } : null;
  return [
    cardRow('weight', weight, sessions, period, goals),
    cardRow('waist', waist, sessions, period, goals),
    cardRow('strength', strength, sessions, period, goals),
    cardRow('cardio', cardio, sessions, period, goals),
    cardRow('other', other, sessions, period, goals),
  ];
}

function toSnapshotSessions(
  rows: Array<{
    id?: number;
    recorded_at: Date;
    values: Array<{
      metric_id: number;
      value: number;
      metric_name?: string;
      category?: string;
      unit_of_measure?: string;
    }>;
  }>,
): SnapshotMeasurementSession[] {
  return rows.map((row) => ({
    id: row.id,
    recorded_at: row.recorded_at,
    values: row.values.flatMap((value) =>
      value.metric_name && value.category && value.unit_of_measure
        ? [
            {
              metric_id: value.metric_id,
              metric_name: value.metric_name,
              category: value.category,
              unit_of_measure: value.unit_of_measure,
              value: value.value,
            },
          ]
        : [],
    ),
  }));
}

function assertOtherTextAllowed(
  otherText: string | null | undefined,
  highlights: readonly string[] | null | undefined,
): void {
  if (nullableTrimmed(otherText) && !highlights?.includes('other')) {
    throw new BadRequestError('highlights_other_text requires the other highlight to be selected');
  }
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
    private readonly measurementRepository: MeasurementRepository,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
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

    assertOtherTextAllowed(dto.highlights_other_text, dto.progress_highlights);

    const trainerId = actor.userType === 'trainer' ? actor.profileId : member.assigned_trainer_id;
    if (trainerId == null) {
      throw new BusinessRuleError('A trainer must be assigned to the member to draft a review');
    }

    const { rows: sessions } = await this.measurementRepository.findManyByMemberId(memberId);
    const { rows: goals } = await this.goalRepository.findManyByMemberId(memberId);
    const period = {
      review_period_start: dto.review_period_start,
      review_period_end: dto.review_period_end,
    };
    const measured = toSnapshotSessions(sessions);
    const now = new Date();

    return runInTransaction(this.db, async () => {
      const id = await this.repository.insertReview({
        member_id: memberId,
        trainer_id: trainerId,
        review_period_start: dto.review_period_start,
        review_period_end: dto.review_period_end,
        body_metrics_snapshot: buildPresentationCardRows(measured, period, goals),
        performance_markers_snapshot: null,
        progress_highlights: dto.progress_highlights ?? null,
        highlights_other_text: nullableTrimmed(dto.highlights_other_text),
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
    });
  }

  async get(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    const isReviewTrainer = actor.userType === 'trainer' && actor.profileId === review.trainer_id;
    if (!isReviewTrainer) {
      await requireScopedMember(this.memberRepository, review.member_id, actor);
    }
    return review;
  }

  /** Saves the presentation card while the review is still a draft. Only the review's trainer may edit. */
  async updateDraft(
    id: number,
    dto: PtProgressReviewDraftEditDto,
    actor: AuthenticatedUser,
  ): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    await this.assertReviewTrainer(review, actor, 'edit');
    if (review.status !== 'draft') {
      throw new ConflictError(`Cannot edit: review is ${review.status}, only a draft can be edited`);
    }

    const highlights =
      dto.progress_highlights !== undefined ? dto.progress_highlights : review.progress_highlights;
    const otherSelected = highlights?.includes('other') ?? false;
    assertOtherTextAllowed(dto.highlights_other_text, highlights);
    const providedOtherText = nullableTrimmed(dto.highlights_other_text);
    if (dto.next_review_date && dto.next_review_date <= review.review_period_end) {
      throw new BadRequestError('next_review_date must be after the review period end');
    }

    const patch: Partial<NewPtProgressReview> = { updated_at: new Date() };
    if (dto.progress_highlights !== undefined) patch.progress_highlights = dto.progress_highlights;
    if (dto.highlights_other_text !== undefined || (!otherSelected && review.highlights_other_text)) {
      patch.highlights_other_text = otherSelected ? providedOtherText : null;
    }
    if (dto.trainer_summary !== undefined) patch.trainer_summary = nullableTrimmed(dto.trainer_summary);
    if (dto.client_feedback !== undefined) patch.client_feedback = nullableTrimmed(dto.client_feedback);
    if (dto.next_phase_goal !== undefined) patch.next_phase_goal = nullableTrimmed(dto.next_phase_goal);
    if (dto.next_phase_training_focus !== undefined) {
      patch.next_phase_training_focus = nullableTrimmed(dto.next_phase_training_focus);
    }
    if (dto.next_review_date !== undefined) patch.next_review_date = dto.next_review_date;
    if (dto.review_checklist !== undefined) {
      patch.review_checklist = { ...review.review_checklist, ...dto.review_checklist };
    }

    return this.transition(review, actor, 'pt_progress_review.draft_edited', patch);
  }

  /** draft -> pending_client_sign. Only the review's trainer may sign. */
  async trainerSign(id: number, actor: AuthenticatedUser): Promise<PtProgressReview> {
    const review = await this.requireReview(id);
    await this.assertReviewTrainer(review, actor, 'sign');
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

  /** The review's own trainer with write access. Other trainers in scope are forbidden; out of scope are not found. */
  private async assertReviewTrainer(
    review: PtProgressReview,
    actor: AuthenticatedUser,
    verb: 'sign' | 'edit',
  ): Promise<void> {
    const isReviewTrainer = actor.userType === 'trainer' && actor.profileId === review.trainer_id;
    if (!isReviewTrainer) {
      await requireScopedMember(this.memberRepository, review.member_id, actor);
      throw new ForbiddenError(`Only the review trainer can ${verb} this review`);
    }
    await this.ptAccess.assertTrainerCanWrite(actor, review.member_id);
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
    return runInTransaction(this.db, async () => {
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
    });
  }
}
