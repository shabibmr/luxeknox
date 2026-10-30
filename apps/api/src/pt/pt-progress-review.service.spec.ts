import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import {
  buildBodyMetricSnapshot,
  buildPerformanceMarkerSnapshot,
  PAGE8_PROGRESS_HIGHLIGHTS,
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

describe('measurement snapshot builders', () => {
  it('snapshots earliest and latest in-window measurements, with goal targets only', () => {
    expect(buildBodyMetricSnapshot(workedSessions, workedPeriod, workedTargets)).toEqual([
      { metric: 'Waist', start_val: 90, current_val: 88, change_val: -2, target_val: null },
      { metric: 'Weight', start_val: 80, current_val: 78, change_val: -2, target_val: 75 },
    ]);
    expect(buildPerformanceMarkerSnapshot(workedSessions, workedPeriod, workedTargets)).toEqual([
      {
        marker: 'Bench Press',
        start_val: '40 kg',
        current_val: '50 kg',
        change_val: '+10 kg',
        target_val: '60 kg',
      },
    ]);
  });

  it('ignores abandoned targets and categories other than body or strength', () => {
    const sessions = [
      {
        recorded_at: new Date('2026-01-10T12:00:00.000Z'),
        values: [
          {
            metric_id: 2,
            metric_name: 'Waist',
            category: 'circumference',
            unit_of_measure: 'cm',
            value: 90,
          },
          {
            metric_id: 3,
            metric_name: 'Bench Press',
            category: 'strength',
            unit_of_measure: 'kg',
            value: 40,
          },
          {
            metric_id: 9,
            metric_name: 'Resting HR',
            category: 'cardio',
            unit_of_measure: 'bpm',
            value: 70,
          },
        ],
      },
    ];
    const goals = [
      { metric_id: 2, status: 'abandoned', target_value: 70 },
      { metric_id: 2, status: 'in_progress', target_value: 80 },
      { metric_id: 3, status: 'abandoned', target_value: 100 },
    ];

    expect(buildBodyMetricSnapshot(sessions, workedPeriod, goals)).toEqual([
      { metric: 'Waist', start_val: 90, current_val: 90, change_val: 0, target_val: 80 },
    ]);
    expect(buildPerformanceMarkerSnapshot(sessions, workedPeriod, goals)).toEqual([
      {
        marker: 'Bench Press',
        start_val: '40 kg',
        current_val: '40 kg',
        change_val: '0 kg',
        target_val: null,
      },
    ]);
  });

  it('uses the UTC calendar date, including the period end and excluding the next UTC day', () => {
    const sessions = [
      {
        recorded_at: new Date('2026-01-01T00:00:00.000Z'),
        values: [
          {
            metric_id: 1,
            metric_name: 'Weight',
            category: 'body_composition',
            unit_of_measure: 'kg',
            value: 80,
          },
        ],
      },
      {
        recorded_at: new Date('2026-01-31T20:00:00.000Z'),
        values: [
          {
            metric_id: 1,
            metric_name: 'Weight',
            category: 'body_composition',
            unit_of_measure: 'kg',
            value: 77,
          },
        ],
      },
      {
        recorded_at: new Date('2026-02-01T00:30:00.000Z'),
        values: [
          {
            metric_id: 1,
            metric_name: 'Weight',
            category: 'body_composition',
            unit_of_measure: 'kg',
            value: 70,
          },
        ],
      },
    ];

    expect(buildBodyMetricSnapshot(sessions, workedPeriod, [])).toEqual([
      { metric: 'Weight', start_val: 80, current_val: 77, change_val: -3, target_val: null },
    ]);
  });

  it('rounds change to two decimal places', () => {
    const sessions = [
      {
        recorded_at: new Date('2026-01-01T00:00:00.000Z'),
        values: [
          {
            metric_id: 1,
            metric_name: 'Weight',
            category: 'body_composition',
            unit_of_measure: 'kg',
            value: 82.55,
          },
        ],
      },
      {
        recorded_at: new Date('2026-01-20T00:00:00.000Z'),
        values: [
          {
            metric_id: 1,
            metric_name: 'Weight',
            category: 'body_composition',
            unit_of_measure: 'kg',
            value: 78.141,
          },
        ],
      },
    ];

    expect(buildBodyMetricSnapshot(sessions, workedPeriod, [])).toEqual([
      { metric: 'Weight', start_val: 82.55, current_val: 78.141, change_val: -4.41, target_val: null },
    ]);
  });
});

describe('ptProgressReviewDraftSchema progress highlights', () => {
  const period = { review_period_start: '2026-01-01', review_period_end: '2026-01-31' };

  it('accepts only the Page 8 labels, without duplicates', () => {
    expect([...PAGE8_PROGRESS_HIGHLIGHTS]).toEqual([
      'Improved technique',
      'Increased strength',
      'Improved conditioning',
      'Better consistency',
      'Improved mobility',
      'Goal milestone achieved',
    ]);
    expect(
      ptProgressReviewDraftSchema.parse({
        ...period,
        progress_highlights: ['Goal milestone achieved', 'Improved technique'],
        highlights_other_text: 'Noted in session',
      }),
    ).toMatchObject({
      progress_highlights: ['Goal milestone achieved', 'Improved technique'],
      highlights_other_text: 'Noted in session',
    });
    expect(
      ptProgressReviewDraftSchema.safeParse({
        ...period,
        progress_highlights: ['Improved technique', 'Improved technique'],
      }).success,
    ).toBe(false);
    expect(
      ptProgressReviewDraftSchema.safeParse({
        ...period,
        progress_highlights: ['Lost 4.4 kg'],
      }).success,
    ).toBe(false);
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

  it('persists in-window measurement deltas and audits inside the draft transaction', async () => {
    await service.createDraft(100, dto, ADMIN);
    expect(measurementRepository.findManyByMemberId).toHaveBeenCalledWith(100);
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({
        member_id: 100,
        trainer_id: 9,
        status: 'draft',
        review_period_start: '2026-01-01',
        review_period_end: '2026-01-31',
        body_metrics_snapshot: [
          { metric: 'Waist', start_val: 90, current_val: 88, change_val: -2, target_val: null },
          { metric: 'Weight', start_val: 80, current_val: 78, change_val: -2, target_val: 75 },
        ],
        performance_markers_snapshot: [
          {
            marker: 'Bench Press',
            start_val: '40 kg',
            current_val: '50 kg',
            change_val: '+10 kg',
            target_val: '60 kg',
          },
        ],
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
        progress_highlights: ['Goal milestone achieved', 'Improved technique'],
        highlights_other_text: 'Noted in session',
      },
      ADMIN,
    );
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({
        progress_highlights: ['Goal milestone achieved', 'Improved technique'],
        highlights_other_text: 'Noted in session',
      }),
    );
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
});
