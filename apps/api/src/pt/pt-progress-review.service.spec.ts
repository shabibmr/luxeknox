import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { buildBodyMetricSnapshot, PtProgressReviewService } from './pt-progress-review.service';

const ADMIN: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const goal = (
  name: string,
  baseline: number,
  current: number,
  target: number,
  status = 'in_progress',
) => ({
  status,
  baseline_value: baseline,
  current_value: current,
  target_value: target,
  metric: { name },
});

describe('buildBodyMetricSnapshot', () => {
  it('computes change as current minus start', () => {
    const snap = buildBodyMetricSnapshot([
      goal('Weight', 82.5, 78.1, 75),
      goal('Squat 1RM', 60, 85, 100),
    ]);
    expect(snap).toEqual([
      { metric: 'Weight', start_val: 82.5, current_val: 78.1, change_val: -4.4, target_val: 75 },
      { metric: 'Squat 1RM', start_val: 60, current_val: 85, change_val: 25, target_val: 100 },
    ]);
  });

  it('skips abandoned goals', () => {
    expect(buildBodyMetricSnapshot([goal('Waist', 90, 88, 80, 'abandoned')])).toEqual([]);
  });
});

describe('PtProgressReviewService.createDraft', () => {
  let service: PtProgressReviewService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let goalRepository: Record<string, ReturnType<typeof vi.fn>>;
  let ptAccess: Record<string, ReturnType<typeof vi.fn>>;
  let audit: { recordAudit: ReturnType<typeof vi.fn> };

  const dto = { review_period_start: '2026-01-01', review_period_end: '2026-03-26' };

  beforeEach(() => {
    repository = {
      insertReview: vi.fn().mockResolvedValue(7),
      findReviewById: vi.fn().mockImplementation(async (id: number) => ({ id, status: 'draft' })),
    };
    memberRepository = {
      findById: vi.fn().mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 9 }),
    };
    goalRepository = {
      findManyByMemberId: vi.fn().mockResolvedValue({
        rows: [goal('Weight', 82.5, 78.1, 75)],
        total: 1,
      }),
    };
    ptAccess = { assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) };
    audit = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    service = new PtProgressReviewService(
      repository as any,
      memberRepository as any,
      goalRepository as any,
      ptAccess as any,
      audit as any,
    );
  });

  it('snapshots deltas, assigns the member trainer and starts in draft', async () => {
    await service.createDraft(100, dto, ADMIN);
    expect(repository.insertReview).toHaveBeenCalledWith(
      expect.objectContaining({
        member_id: 100,
        trainer_id: 9,
        status: 'draft',
        body_metrics_snapshot: [
          { metric: 'Weight', start_val: 82.5, current_val: 78.1, change_val: -4.4, target_val: 75 },
        ],
      }),
    );
    expect(audit.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({ action: 'pt_progress_review.drafted', entityId: 7 }),
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
  let review: Record<string, unknown>;

  beforeEach(() => {
    review = { id: 7, member_id: 100, trainer_id: 9, status: 'draft' };
    repository = {
      findReviewById: vi.fn().mockImplementation(async () => ({ ...review })),
      updateReview: vi.fn().mockResolvedValue(undefined),
    };
    const memberRepository = {
      findById: vi.fn().mockResolvedValue({ id: 100, user_id: 10, assigned_trainer_id: 9 }),
    };
    service = new PtProgressReviewService(
      repository as any,
      memberRepository as any,
      {} as any,
      { assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) } as any,
      { recordAudit: vi.fn().mockResolvedValue(undefined) } as any,
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

  it('enforces who may sign at each stage', async () => {
    // A trainer outside the member's row scope never sees the review (404).
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
