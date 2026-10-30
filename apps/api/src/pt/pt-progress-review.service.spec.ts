import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import {
  PAGE8_PROGRESS_HIGHLIGHTS,
  ptProgressReviewDraftEditSchema,
  ptProgressReviewDraftSchema,
  PtProgressReviewService,
} from './pt-progress-review.service';

const ADMIN: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const workedSessions = [
  {
    recorded_at: new Date('2026-01-20T12:00:00.000Z'),
    values: [
      {
        metric_id: 1,
        metric_name: 'Weight',
        category: 'body_composition',
        unit_of_measure: 'kg',
        value: 78,
      },
      {
        metric_id: 2,
        metric_name: 'Waist',
        category: 'circumference',
        unit_of_measure: 'cm',
        value: 88,
      },
      {
        metric_id: 3,
        metric_name: 'Bench Press',
        category: 'strength',
        unit_of_measure: 'kg',
        value: 50,
      },
    ],
  },
  {
    recorded_at: new Date('2025-12-01T12:00:00.000Z'),
    values: [
      {
        metric_id: 1,
        metric_name: 'Weight',
        category: 'body_composition',
        unit_of_measure: 'kg',
        value: 99,
      },
    ],
  },
  {
    recorded_at: new Date('2026-01-01T12:00:00.000Z'),
    values: [
      {
        metric_id: 1,
        metric_name: 'Weight',
        category: 'body_composition',
        unit_of_measure: 'kg',
        value: 80,
      },
      {
        metric_id: 3,
        metric_name: 'Bench Press',
        category: 'strength',
        unit_of_measure: 'kg',
        value: 40,
      },
      {
        metric_id: 2,
        metric_name: 'Waist',
        category: 'circumference',
        unit_of_measure: 'cm',
        value: 90,
      },
    ],
  },
];

const workedPeriod = { review_period_start: '2026-01-01', review_period_end: '2026-01-31' };

const workedTargets = [
  { metric_id: 1, status: 'in_progress', target_value: 75, baseline_value: 999, current_value: 1 },
  { metric_id: 3, status: 'achieved', target_value: 60, baseline_value: 999, current_value: 1 },
];

describe('ptProgressReviewDraftSchema progress highlights', () => {
  const period = { review_period_start: '2026-01-01', review_period_end: '2026-01-31' };

  it('accepts only the seven Page 8 highlight keys, without duplicates', () => {
    expect([...PAGE8_PROGRESS_HIGHLIGHTS]).toEqual([
      'improved_technique',
      'increased_strength',
      'improved_conditioning',
      'better_consistency',
      'improved_mobility',
      'goal_milestone',
      'other',
    ]);
    expect(
      ptProgressReviewDraftSchema.parse({
        ...period,
        progress_highlights: ['goal_milestone', 'improved_technique', 'other'],
        highlights_other_text: 'Noted in session',
      }),
    ).toMatchObject({
      progress_highlights: ['goal_milestone', 'improved_technique', 'other'],
      highlights_other_text: 'Noted in session',
    });
    for (const progress_highlights of [
      ['improved_technique', 'improved_technique'],
      ['Improved technique'],
      ['lost_4_kg'],
    ]) {
      expect(ptProgressReviewDraftSchema.safeParse({ ...period, progress_highlights }).success).toBe(false);
    }
  });
});

describe('PtProgressReviewService.createDraft', () => {
  let service: PtProgressReviewService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let measurementRepository: { findManyByMemberId: ReturnType<typeof vi.fn> };
  let goalRepository: { findManyByMemberId: ReturnType<typeof vi.fn> };
  let ptAccess: Record<string, ReturnType<typeof vi.fn>>;
  let audit: { recordAudit: ReturnType<typeof vi.fn> };
  let db: { transaction: ReturnType<typeof vi.fn> };
  let events: string[];

  const dto = { review_period_start: '2026-01-01', review_period_end: '2026-01-31' };

  beforeEach(() => {
    events = [];
    repository = {
      insertReview: vi.fn().mockImplementation(async () => {
        events.push('insert');
        return 7;
      }),
      findReviewById: vi.fn().mockImplementation(async (id: number) => {
        events.push('reload');
        return { id, status: 'draft' };
      }),
    };
    memberRepository = {
      findById: vi.fn().mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 9 }),
    };
    measurementRepository = {
      findManyByMemberId: vi.fn().mockResolvedValue({
        rows: workedSessions,
        total: workedSessions.length,
      }),
    };
    goalRepository = {
      findManyByMemberId: vi.fn().mockResolvedValue({
        rows: workedTargets,
        total: workedTargets.length,
      }),
    };
    ptAccess = { assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) };
    audit = {
      recordAudit: vi.fn().mockImplementation(async () => {
        events.push('audit');
      }),
    };
    db = {
      transaction: vi.fn(async (fn: (tx: unknown) => Promise<unknown>) => {
        events.push('tx-start');
        try {
          return await fn({});
        } finally {
          events.push('tx-end');
        }
      }),
    };
    service = new PtProgressReviewService(
      repository as any,
      memberRepository as any,
      goalRepository as any,
      ptAccess as any,
      audit as any,
      measurementRepository as any,
      db as any,
    );
  });

  it('persists the draft and audits inside the draft transaction', async () => {
    await service.createDraft(100, dto, ADMIN);
    expect(measurementRepository.findManyByMemberId).toHaveBeenCalledWith(100);
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({
        member_id: 100,
        trainer_id: 9,
        status: 'draft',
        review_period_start: '2026-01-01',
        review_period_end: '2026-01-31',
        body_metrics_snapshot: expect.any(Array),
        performance_markers_snapshot: null,
        progress_highlights: null,
        highlights_other_text: null,
      }),
    );
    expect(events).toEqual(['tx-start', 'insert', 'reload', 'audit', 'tx-end']);
    expect(audit.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        actorUserId: ADMIN.id,
        action: 'pt_progress_review.drafted',
        entityName: 'pt_progress_reviews',
        entityId: 7,
        afterState: { id: 7, status: 'draft' },
      }),
    );
  });

  it('stores provided progress highlights and other text as given', async () => {
    await service.createDraft(
      100,
      {
        ...dto,
        progress_highlights: ['goal_milestone', 'improved_technique', 'other'],
        highlights_other_text: 'Noted in session',
      },
      ADMIN,
    );
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({
        progress_highlights: ['goal_milestone', 'improved_technique', 'other'],
        highlights_other_text: 'Noted in session',
      }),
    );
  });

  it('rejects other text when the other highlight is not selected', async () => {
    await expect(
      service.createDraft(
        100,
        { ...dto, progress_highlights: ['improved_mobility'], highlights_other_text: 'Slept better' },
        ADMIN,
      ),
    ).rejects.toBeInstanceOf(BadRequestError);
    await expect(
      service.createDraft(100, { ...dto, highlights_other_text: 'Slept better' }, ADMIN),
    ).rejects.toBeInstanceOf(BadRequestError);
    expect(repository.insertReview).not.toHaveBeenCalled();
  });

  it('stores an empty highlight list instead of null', async () => {
    await service.createDraft(100, { ...dto, progress_highlights: [] }, ADMIN);
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({ progress_highlights: [] }),
    );
  });

  it('rejects a period that ends before it starts', async () => {
    await expect(
      service.createDraft(100, { ...dto, review_period_end: '2025-12-31' }, ADMIN),
    ).rejects.toBeInstanceOf(BusinessRuleError);
    expect(repository.insertReview).not.toHaveBeenCalled();
  });

  it('rejects when no trainer is assigned', async () => {
    memberRepository.findById.mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: null });
    await expect(service.createDraft(100, dto, ADMIN)).rejects.toBeInstanceOf(BusinessRuleError);
  });
});

describe('PtProgressReviewService sign-off state machine', () => {
  const TRAINER: AuthenticatedUser = { ...ADMIN, id: 20, userType: 'trainer', profileId: 9 };
  const MEMBER: AuthenticatedUser = { ...ADMIN, id: 10, userType: 'member', profileId: 100 };
  let service: PtProgressReviewService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let ptAccess: { assertTrainerCanWrite: ReturnType<typeof vi.fn> };
  let audit: { recordAudit: ReturnType<typeof vi.fn> };
  let review: Record<string, unknown>;
  let events: string[];

  beforeEach(() => {
    events = [];
    review = { id: 7, member_id: 100, trainer_id: 9, status: 'draft' };
    repository = {
      findReviewById: vi.fn().mockImplementation(async () => {
        events.push('reload');
        return { ...review };
      }),
      updateReview: vi.fn().mockImplementation(async () => {
        events.push('update');
      }),
    };
    memberRepository = {
      findById: vi.fn().mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 9 }),
    };
    ptAccess = { assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) };
    audit = {
      recordAudit: vi.fn().mockImplementation(async () => {
        events.push('audit');
      }),
    };
    const db = {
      transaction: vi.fn(async (fn: (tx: unknown) => Promise<unknown>) => {
        events.push('tx-start');
        try {
          return await fn({});
        } finally {
          events.push('tx-end');
        }
      }),
    };
    service = new PtProgressReviewService(
      repository as any,
      memberRepository as any,
      {} as any,
      ptAccess as any,
      audit as any,
      {} as any,
      db as any,
    );
  });

  it('audits a trainer sign inside the same transaction as the status update', async () => {
    await service.trainerSign(7, TRAINER);
    expect(events).toEqual(['reload', 'tx-start', 'update', 'reload', 'audit', 'tx-end']);
  });

  it('rejects the sign-off when the audit write fails', async () => {
    audit.recordAudit.mockImplementation(async () => {
      throw new Error('audit failed');
    });
    await expect(service.trainerSign(7, TRAINER)).rejects.toThrow('audit failed');
  });

  it('lets the review trainer read a review they are not assigned to, and hides it from other trainers', async () => {
    memberRepository.findById.mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 8 });
    await expect(service.get(7, TRAINER)).resolves.toMatchObject({ id: 7, trainer_id: 9 });
    await expect(service.get(7, { ...TRAINER, profileId: 99 })).rejects.toBeInstanceOf(NotFoundError);
    await expect(service.get(7, { ...TRAINER, profileId: 8 })).resolves.toMatchObject({ id: 7 });
  });

  it('lets the review trainer sign a draft when they are not the assigned trainer', async () => {
    memberRepository.findById.mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 8 });
    await service.trainerSign(7, TRAINER);
    expect(ptAccess.assertTrainerCanWrite).toHaveBeenCalledWith(TRAINER, 100);
    expect(repository.updateReview).toHaveBeenCalledWith(
      7,
      expect.objectContaining({ status: 'pending_client_sign', trainer_signed_at: expect.any(Date) }),
    );
  });

  it('runs draft -> trainer -> client -> manager', async () => {
    await service.trainerSign(7, TRAINER);
    expect(repository.updateReview).toHaveBeenLastCalledWith(
      7,
      expect.objectContaining({ status: 'pending_client_sign', trainer_signed_at: expect.any(Date) }),
    );
    review.status = 'pending_client_sign';
    await service.clientSign(7, MEMBER);
    expect(repository.updateReview).toHaveBeenLastCalledWith(
      7,
      expect.objectContaining({ status: 'pending_manager_approval', client_signed_at: expect.any(Date) }),
    );
    review.status = 'pending_manager_approval';
    await service.managerApprove(7, ADMIN);
    expect(repository.updateReview).toHaveBeenLastCalledWith(
      7,
      expect.objectContaining({ status: 'approved', manager_user_id: 1, manager_signed_at: expect.any(Date) }),
    );
  });

  it('blocks out-of-order transitions', async () => {
    await expect(service.clientSign(7, MEMBER)).rejects.toBeInstanceOf(BusinessRuleError);
    await expect(service.managerApprove(7, ADMIN)).rejects.toBeInstanceOf(BusinessRuleError);
    review.status = 'approved';
    await expect(service.trainerSign(7, TRAINER)).rejects.toBeInstanceOf(BusinessRuleError);
  });

  it('refuses an assigned trainer who is not the review trainer', async () => {
    memberRepository.findById.mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 8 });
    await expect(service.trainerSign(7, { ...TRAINER, profileId: 8 })).rejects.toBeInstanceOf(
      ForbiddenError,
    );
    expect(repository.updateReview).not.toHaveBeenCalled();
  });

  it('refuses trainer sign from an admin or employee', async () => {
    await expect(service.trainerSign(7, ADMIN)).rejects.toBeInstanceOf(ForbiddenError);
    await expect(
      service.trainerSign(7, { ...ADMIN, id: 3, userType: 'employee' }),
    ).rejects.toBeInstanceOf(ForbiddenError);
    expect(repository.updateReview).not.toHaveBeenCalled();
  });

  it('enforces who may sign at each stage', async () => {
    // A trainer who is not assigned to the member must not learn that the review exists.
    await expect(service.trainerSign(7, { ...TRAINER, profileId: 99 })).rejects.toBeInstanceOf(
      NotFoundError,
    );
    review.status = 'pending_client_sign';
    await expect(service.clientSign(7, { ...MEMBER, id: 11 })).rejects.toBeInstanceOf(ForbiddenError);
    await expect(service.clientSign(7, TRAINER)).rejects.toBeInstanceOf(ForbiddenError);
    review.status = 'pending_manager_approval';
    await expect(service.managerApprove(7, TRAINER)).rejects.toBeInstanceOf(ForbiddenError);
    expect(repository.updateReview).not.toHaveBeenCalled();
  });

  describe('updateDraft', () => {
    beforeEach(() => {
      review.review_period_end = '2026-01-31';
    });

    it('saves the card fields and audits inside the same transaction', async () => {
      await service.updateDraft(
        7,
        {
          progress_highlights: ['increased_strength', 'other'],
          highlights_other_text: ' Slept better ',
          trainer_summary: 'Strong quarter',
          client_feedback: 'Felt stronger',
          next_phase_goal: 'Squat 80 kg',
          next_phase_training_focus: 'Lower body',
          next_review_date: '2026-04-30',
          review_checklist: { goals_reviewed: true, next_goals_agreed: true },
        },
        TRAINER,
      );
      expect(events).toEqual(['reload', 'tx-start', 'update', 'reload', 'audit', 'tx-end']);
      expect(repository.updateReview).toHaveBeenCalledWith(7, {
        progress_highlights: ['increased_strength', 'other'],
        highlights_other_text: 'Slept better',
        trainer_summary: 'Strong quarter',
        client_feedback: 'Felt stronger',
        next_phase_goal: 'Squat 80 kg',
        next_phase_training_focus: 'Lower body',
        next_review_date: '2026-04-30',
        review_checklist: { goals_reviewed: true, next_goals_agreed: true },
        updated_at: expect.any(Date),
      });
      expect(audit.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'pt_progress_review.draft_edited', entityId: 7 }),
      );
    });

    it('leaves omitted fields alone', async () => {
      await service.updateDraft(7, { trainer_summary: 'Only this' }, TRAINER);
      expect(repository.updateReview).toHaveBeenCalledWith(7, {
        trainer_summary: 'Only this',
        updated_at: expect.any(Date),
      });
    });

    it('refuses every edit once the review is no longer a draft', async () => {
      for (const status of ['pending_client_sign', 'pending_manager_approval', 'approved']) {
        review.status = status;
        await expect(service.updateDraft(7, { trainer_summary: 'x' }, TRAINER)).rejects.toBeInstanceOf(
          ConflictError,
        );
      }
      expect(repository.updateReview).not.toHaveBeenCalled();
    });

    it('allows other text only while other is selected, and clears it when other is deselected', async () => {
      await expect(
        service.updateDraft(7, { highlights_other_text: 'Slept better' }, TRAINER),
      ).rejects.toBeInstanceOf(BadRequestError);
      await expect(
        service.updateDraft(
          7,
          { progress_highlights: ['improved_mobility'], highlights_other_text: 'Slept better' },
          TRAINER,
        ),
      ).rejects.toBeInstanceOf(BadRequestError);
      expect(repository.updateReview).not.toHaveBeenCalled();

      review.progress_highlights = ['other'];
      review.highlights_other_text = 'Slept better';
      await service.updateDraft(7, { progress_highlights: ['improved_mobility'] }, TRAINER);
      expect(repository.updateReview).toHaveBeenCalledWith(7, {
        progress_highlights: ['improved_mobility'],
        highlights_other_text: null,
        updated_at: expect.any(Date),
      });
    });

    it('requires the next review date to fall after the review period end', async () => {
      await expect(
        service.updateDraft(7, { next_review_date: '2026-01-31' }, TRAINER),
      ).rejects.toBeInstanceOf(BadRequestError);
      expect(repository.updateReview).not.toHaveBeenCalled();
    });

    it('merges the discussed checks into the stored ones', async () => {
      review.review_checklist = { goals_reviewed: true, attendance_reviewed: true };
      await service.updateDraft(7, { review_checklist: { attendance_reviewed: false, program_updated: true } }, TRAINER);
      expect(repository.updateReview).toHaveBeenCalledWith(7, {
        review_checklist: { goals_reviewed: true, attendance_reviewed: false, program_updated: true },
        updated_at: expect.any(Date),
      });
    });

    it('does not re-check a stored next review date the edit did not touch', async () => {
      review.next_review_date = '2026-01-15';
      await service.updateDraft(7, { trainer_summary: 'Unrelated edit' }, TRAINER);
      expect(repository.updateReview).toHaveBeenCalledWith(7, {
        trainer_summary: 'Unrelated edit',
        updated_at: expect.any(Date),
      });
    });

    it('lets only the review trainer edit', async () => {
      await expect(service.updateDraft(7, { trainer_summary: 'x' }, ADMIN)).rejects.toBeInstanceOf(
        ForbiddenError,
      );
      await expect(service.updateDraft(7, { trainer_summary: 'x' }, MEMBER)).rejects.toBeInstanceOf(
        ForbiddenError,
      );
      memberRepository.findById.mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 8 });
      await expect(
        service.updateDraft(7, { trainer_summary: 'x' }, { ...TRAINER, profileId: 8 }),
      ).rejects.toBeInstanceOf(ForbiddenError);
      await expect(
        service.updateDraft(7, { trainer_summary: 'x' }, { ...TRAINER, profileId: 99 }),
      ).rejects.toBeInstanceOf(NotFoundError);
      expect(repository.updateReview).not.toHaveBeenCalled();
    });
  });
});

type RowSession = {
  id?: number;
  recorded_at: Date;
  values: Array<{
    metric_id: number;
    metric_name: string;
    category: string;
    unit_of_measure: string;
    value: number;
  }>;
};

const metricValue = (
  metric_id: number,
  metric_name: string,
  category: string,
  value: number,
  unit_of_measure = 'kg',
) => ({ metric_id, metric_name, category, unit_of_measure, value });

const goalFor = (
  id: number,
  metric: { id: number; name: string; category: string },
  target_value: number,
  status = 'in_progress',
) => ({ id, metric_id: metric.id, status, target_value, metric });

const WEIGHT = { id: 1, name: 'Weight', category: 'body_composition' };
const WAIST = { id: 2, name: 'Waist', category: 'circumference' };
const STRENGTH = { id: 3, name: 'Strength', category: 'strength' };
const BENCH = { id: 4, name: 'Bench Press', category: 'strength' };
const CARDIO = { id: 5, name: 'Cardio Index', category: 'strength' };
const BODY_FAT = { id: 6, name: 'Body Fat', category: 'body_composition' };

describe('PtProgressReviewService.createDraft presentation card rows', () => {
  const period = { review_period_start: '2026-01-01', review_period_end: '2026-01-31' };

  async function draftRows(sessions: RowSession[], goals: ReturnType<typeof goalFor>[] = []) {
    const insertReview = vi.fn().mockResolvedValue(7);
    const service = new PtProgressReviewService(
      { insertReview, findReviewById: vi.fn().mockResolvedValue({ id: 7 }) } as any,
      {
        findById: vi.fn().mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 9 }),
      } as any,
      { findManyByMemberId: vi.fn().mockResolvedValue({ rows: goals, total: goals.length }) } as any,
      { assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) } as any,
      { recordAudit: vi.fn().mockResolvedValue(undefined) } as any,
      {
        findManyByMemberId: vi.fn().mockResolvedValue({ rows: sessions, total: sessions.length }),
      } as any,
      { transaction: vi.fn(async (fn: (tx: unknown) => Promise<unknown>) => fn({})) } as any,
    );
    await service.createDraft(100, period, ADMIN);
    return insertReview.mock.calls[0][0] as {
      body_metrics_snapshot: Array<Record<string, unknown>>;
      performance_markers_snapshot: unknown;
    };
  }

  it('returns the five rows in order, taking start and current on or before the period boundaries', async () => {
    const saved = await draftRows(
      [
        { recorded_at: new Date('2025-12-20T09:00:00Z'), values: [metricValue(1, 'Weight', 'body_composition', 85)] },
        { recorded_at: new Date('2026-01-10T09:00:00Z'), values: [metricValue(1, 'Weight', 'body_composition', 83)] },
        { recorded_at: new Date('2026-02-05T09:00:00Z'), values: [metricValue(1, 'Weight', 'body_composition', 70)] },
      ],
      [goalFor(11, WEIGHT, 75)],
    );

    expect(saved.body_metrics_snapshot).toEqual([
      { row: 'weight', metric: 'Weight', start_val: 85, current_val: 83, change_val: -2, target_val: 75 },
      { row: 'waist', metric: null, start_val: null, current_val: null, change_val: null, target_val: null },
      { row: 'strength', metric: null, start_val: null, current_val: null, change_val: null, target_val: null },
      { row: 'cardio', metric: null, start_val: null, current_val: null, change_val: null, target_val: null },
      { row: 'other', metric: null, start_val: null, current_val: null, change_val: null, target_val: null },
    ]);
  });

  it('prefers the strength metric named strength, else a strength metric measured in the period', async () => {
    const named = await draftRows(
      [
        {
          recorded_at: new Date('2026-01-05T09:00:00Z'),
          values: [metricValue(4, 'Bench Press', 'strength', 40), metricValue(3, 'Strength', 'strength', 100)],
        },
      ],
      [],
    );
    expect(named.body_metrics_snapshot[2]).toMatchObject({ row: 'strength', metric: 'Strength', current_val: 100 });

    const fallback = await draftRows(
      [
        { recorded_at: new Date('2025-11-05T09:00:00Z'), values: [metricValue(1, 'Squat', 'strength', 60)] },
        {
          recorded_at: new Date('2026-01-05T09:00:00Z'),
          values: [metricValue(5, 'Cardio Index', 'strength', 30), metricValue(4, 'Bench Press', 'strength', 40)],
        },
      ],
      [],
    );
    expect(fallback.body_metrics_snapshot[2]).toMatchObject({
      row: 'strength',
      metric: 'Bench Press',
      start_val: null,
      current_val: 40,
      change_val: null,
    });
  });

  it('fills the cardio row only from a metric whose name contains cardio', async () => {
    const saved = await draftRows(
      [
        {
          recorded_at: new Date('2025-12-30T09:00:00Z'),
          values: [metricValue(5, 'Cardio Index', 'strength', 30, 'pts')],
        },
        {
          recorded_at: new Date('2026-01-20T09:00:00Z'),
          values: [metricValue(5, 'Cardio Index', 'strength', 34, 'pts'), metricValue(4, 'Bench Press', 'strength', 40)],
        },
      ],
      [],
    );
    expect(saved.body_metrics_snapshot[3]).toEqual({
      row: 'cardio',
      metric: 'Cardio Index',
      start_val: 30,
      current_val: 34,
      change_val: 4,
      target_val: null,
    });
    expect(saved.body_metrics_snapshot[2]).toMatchObject({ metric: 'Bench Press' });
  });

  it('fills the other row with the lowest-id reported goal whose metric is not already used', async () => {
    const saved = await draftRows(
      [
        {
          recorded_at: new Date('2025-12-30T09:00:00Z'),
          values: [metricValue(1, 'Weight', 'body_composition', 85), metricValue(6, 'Body Fat', 'body_composition', 24, '%')],
        },
        {
          recorded_at: new Date('2026-01-20T09:00:00Z'),
          values: [metricValue(1, 'Weight', 'body_composition', 83), metricValue(6, 'Body Fat', 'body_composition', 22.5, '%')],
        },
      ],
      [
        goalFor(10, WEIGHT, 75),
        goalFor(11, BODY_FAT, 18, 'abandoned'),
        goalFor(12, BODY_FAT, 20, 'achieved'),
        goalFor(13, BENCH, 60),
      ],
    );
    expect(saved.body_metrics_snapshot[4]).toEqual({
      row: 'other',
      metric: 'Body Fat',
      start_val: 24,
      current_val: 22.5,
      change_val: -1.5,
      target_val: 20,
    });
  });

  it('breaks same-day ties by later time, then higher session id, and picks the lowest goal id target', async () => {
    const weight = (value: number) => [metricValue(1, 'Weight', 'body_composition', value)];
    const saved = await draftRows(
      [
        { id: 2, recorded_at: new Date('2026-01-20T09:00:00Z'), values: weight(81) },
        { id: 3, recorded_at: new Date('2026-01-20T09:00:00Z'), values: weight(82) },
        { id: 1, recorded_at: new Date('2026-01-20T07:00:00Z'), values: weight(90) },
      ],
      [goalFor(20, WEIGHT, 70), goalFor(12, WEIGHT, 75)],
    );
    expect(saved.body_metrics_snapshot[0]).toMatchObject({ current_val: 82, target_val: 75 });
  });

  it('uses the lowest metric id when several metrics contain cardio', async () => {
    const saved = await draftRows([
      {
        recorded_at: new Date('2026-01-20T09:00:00Z'),
        values: [metricValue(9, 'Cardio Test B', 'strength', 5), metricValue(8, 'Cardio Test A', 'strength', 4)],
      },
    ]);
    expect(saved.body_metrics_snapshot[3]).toMatchObject({ metric: 'Cardio Test A' });
  });

  it('leaves start and change empty when the first measurement falls mid-period', async () => {
    const saved = await draftRows(
      [{ recorded_at: new Date('2026-01-15T09:00:00Z'), values: [metricValue(1, 'Weight', 'body_composition', 83)] }],
      [goalFor(10, WEIGHT, 75)],
    );
    expect(saved.body_metrics_snapshot[0]).toEqual({
      row: 'weight',
      metric: 'Weight',
      start_val: null,
      current_val: 83,
      change_val: null,
      target_val: 75,
    });
  });

  it('rounds change half away from zero to two decimals', async () => {
    const at = (day: string, weight: number, waist: number) => ({
      recorded_at: new Date(`${day}T09:00:00Z`),
      values: [
        metricValue(1, 'Weight', 'body_composition', weight),
        metricValue(2, 'Waist', 'circumference', waist, 'cm'),
      ],
    });
    const saved = await draftRows([at('2026-01-01', 82.55, 10.005), at('2026-01-20', 78.141, 10)]);
    expect(saved.body_metrics_snapshot[0]).toMatchObject({ change_val: -4.41 });
    expect(saved.body_metrics_snapshot[1]).toMatchObject({ change_val: -0.01 });
    const up = await draftRows([at('2026-01-01', 80, 10), at('2026-01-20', 80, 10.005)]);
    expect(up.body_metrics_snapshot[1]).toMatchObject({ change_val: 0.01 });
  });

  it('does not write a performance-marker snapshot on a new draft', async () => {
    const saved = await draftRows([]);
    expect(saved.performance_markers_snapshot).toBeNull();
    expect(saved.body_metrics_snapshot).toHaveLength(5);
  });

});

describe('ptProgressReviewDraftEditSchema', () => {
  it('accepts the card fields and the six discussed checks', () => {
    expect(
      ptProgressReviewDraftEditSchema.safeParse({
        progress_highlights: ['other'],
        highlights_other_text: 'x',
        trainer_summary: 'x',
        client_feedback: null,
        next_phase_goal: 'x',
        next_phase_training_focus: 'x',
        next_review_date: '2026-04-30',
        review_checklist: {
          goals_reviewed: true,
          measurements_reviewed: true,
          performance_reviewed: true,
          attendance_reviewed: true,
          program_updated: true,
          next_goals_agreed: true,
        },
      }).success,
    ).toBe(true);
  });

  it('rejects unknown highlights, duplicates, the period and the measure rows', () => {
    for (const bad of [
      { progress_highlights: ['lost_4_kg'] },
      { progress_highlights: ['other', 'other'] },
      { review_period_start: '2026-01-01' },
      { body_metrics_snapshot: [] },
      { review_checklist: { unknown_check: true } },
      { trainer_summary: 'x'.repeat(2001) },
    ]) {
      expect(ptProgressReviewDraftEditSchema.safeParse(bad).success, JSON.stringify(bad)).toBe(false);
    }
  });
});
