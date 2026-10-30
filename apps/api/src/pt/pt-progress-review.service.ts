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
import type {
  BodyMetricSnapshot,
  NewPtProgressReview,
  PerformanceMarkerSnapshot,
  PtProgressReview,
} from '../platform/db/schema/personal-training';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { PtAccessService } from './pt-access.service';
import { PtProgressReviewRepository } from './pt-progress-review.repository';

const isoDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Expected YYYY-MM-DD');

export const PAGE8_PROGRESS_HIGHLIGHTS = [
  'Improved technique',
  'Increased strength',
  'Improved conditioning',
  'Better consistency',
  'Improved mobility',
  'Goal milestone achieved',
] as const;

const progressHighlightsSchema = z
  .array(z.enum(PAGE8_PROGRESS_HIGHLIGHTS))
  .refine((items) => new Set(items).size === items.length, {
    message: 'progress_highlights must not contain duplicates',
  });

export const ptProgressReviewDraftSchema = z.object({
  review_period_start: isoDate,
  review_period_end: isoDate,
  trainer_summary: z.string().optional().nullable(),
  client_feedback: z.string().optional().nullable(),
  next_phase_goal: z.string().optional().nullable(),
  next_phase_training_focus: z.string().optional().nullable(),
  next_review_date: isoDate.optional().nullable(),
  progress_highlights: progressHighlightsSchema.optional(),
  highlights_other_text: z.string().optional().nullable(),
});
export type PtProgressReviewDraftDto = z.infer<typeof ptProgressReviewDraftSchema>;

/** Goal statuses that may supply a review target. Abandoned goals do not. */
const REPORTED_GOAL_STATUSES = new Set(['in_progress', 'achieved']);
/** Mirrors `GOAL_METRIC_CATEGORIES` minus strength (body card columns). */
const BODY_METRIC_CATEGORIES = new Set(['body_composition', 'circumference']);
const PERFORMANCE_METRIC_CATEGORIES = new Set(['strength']);

type SnapshotMeasurementValue = {
  metric_id: number;
  metric_name: string;
  category: string;
  unit_of_measure: string;
  value: number;
};

type SnapshotMeasurementSession = {
  recorded_at: Date;
  values: SnapshotMeasurementValue[];
};

type SnapshotMetricTarget = {
  metric_id: number;
  status: string;
  target_value: number;
};

type SnapshotPeriod = {
  review_period_start: string;
  review_period_end: string;
};

function round2(n: number): number {
  return Math.round(n * 100) / 100;
}

function withUnit(value: number, unit: string): string {
  return `${round2(value)} ${unit}`;
}

function signedWithUnit(value: number, unit: string): string {
  const rounded = round2(value);
  const sign = rounded > 0 ? '+' : '';
  return `${sign}${rounded} ${unit}`;
}

function inReviewPeriod(recordedAt: Date, period: SnapshotPeriod): boolean {
  const day = recordedAt.toISOString().slice(0, 10);
  return day >= period.review_period_start && day <= period.review_period_end;
}

type MetricSeries = {
  metric_id: number;
  name: string;
  unit: string;
  earliestAt: number;
  earliest: number;
  latestAt: number;
  latest: number;
};

function seriesFor(
  sessions: SnapshotMeasurementSession[],
  period: SnapshotPeriod,
  categories: Set<string>,
): MetricSeries[] {
  const byMetric = new Map<number, MetricSeries>();
  for (const session of sessions) {
    if (!inReviewPeriod(session.recorded_at, period)) continue;
    const at = session.recorded_at.getTime();
    for (const point of session.values) {
      if (!categories.has(point.category)) continue;
      const existing = byMetric.get(point.metric_id);
      if (!existing) {
        byMetric.set(point.metric_id, {
          metric_id: point.metric_id,
          name: point.metric_name,
          unit: point.unit_of_measure,
          earliestAt: at,
          earliest: point.value,
          latestAt: at,
          latest: point.value,
        });
        continue;
      }
      if (at < existing.earliestAt) {
        existing.earliestAt = at;
        existing.earliest = point.value;
      }
      if (at >= existing.latestAt) {
        existing.latestAt = at;
        existing.latest = point.value;
      }
    }
  }
  return [...byMetric.values()].sort((a, b) => a.name.localeCompare(b.name));
}

function targetFor(metricId: number, goals: SnapshotMetricTarget[]): number | null {
  const match = goals.find(
    (goal) => goal.metric_id === metricId && REPORTED_GOAL_STATUSES.has(goal.status),
  );
  return match ? match.target_value : null;
}

/** Numeric Page 8 body measures from in-window measurement sessions. */
export function buildBodyMetricSnapshot(
  sessions: SnapshotMeasurementSession[],
  period: SnapshotPeriod,
  goals: SnapshotMetricTarget[],
): BodyMetricSnapshot[] {
  return seriesFor(sessions, period, BODY_METRIC_CATEGORIES).map((series) => ({
    metric: series.name,
    start_val: series.earliest,
    current_val: series.latest,
    change_val: round2(series.latest - series.earliest),
    target_val: targetFor(series.metric_id, goals),
  }));
}

/** Strength markers as unit-bearing strings for `performance_markers_snapshot`. */
export function buildPerformanceMarkerSnapshot(
  sessions: SnapshotMeasurementSession[],
  period: SnapshotPeriod,
  goals: SnapshotMetricTarget[],
): PerformanceMarkerSnapshot[] {
  return seriesFor(sessions, period, PERFORMANCE_METRIC_CATEGORIES).map((series) => {
    const target = targetFor(series.metric_id, goals);
    return {
      marker: series.name,
      start_val: withUnit(series.earliest, series.unit),
      current_val: withUnit(series.latest, series.unit),
      change_val: signedWithUnit(series.latest - series.earliest, series.unit),
      target_val: target == null ? null : withUnit(target, series.unit),
    };
  });
}

function toSnapshotSessions(
  rows: Array<{
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
        body_metrics_snapshot: buildBodyMetricSnapshot(measured, period, goals),
        performance_markers_snapshot: buildPerformanceMarkerSnapshot(measured, period, goals),
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
