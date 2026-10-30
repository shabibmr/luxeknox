import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { ParQScreening } from '../platform/db/schema/par-q';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { parQSubmitSchema, parQTrainerReviewSchema, type ParQSubmitDto } from './dto/par-q.dto';
import { MEDICAL_CLEARANCE_REQUIRED, ParQService } from './par-q.service';

const { txState } = vi.hoisted(() => ({
  txState: { latest: null as ParQScreening | null },
}));

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => {
    const snapshot = txState.latest ? { ...txState.latest } : null;
    try {
      return await fn();
    } catch (error) {
      txState.latest = snapshot;
      throw error;
    }
  },
}));

const ADMIN: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const TRAINER: AuthenticatedUser = {
  id: 20,
  email: 'trainer@luxeknox.test',
  phoneNumber: null,
  userType: 'trainer',
  roleId: 3,
  profileId: 9,
  sessionId: 3,
};

const MEMBER: AuthenticatedUser = {
  id: 30,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 4,
  profileId: 100,
  sessionId: 4,
};

const CLIENT_SIGNATURE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAB';

const ALL_NO: ParQSubmitDto = {
  q1_heart_condition: false,
  q2_chest_pain_activity: false,
  q3_chest_pain_rest: false,
  q4_dizziness_consciousness: false,
  q5_bone_joint_problem: false,
  q6_medication_condition: false,
  q7_other_reason: false,
  declaration_accepted: true,
  client_signature: CLIENT_SIGNATURE,
};

function screening(overrides: Partial<ParQScreening> = {}): ParQScreening {
  return {
    id: 5,
    member_id: 100,
    version: '2024.1',
    q1_heart_condition: false,
    q1_details: null,
    q2_chest_pain_activity: false,
    q2_details: null,
    q3_chest_pain_rest: false,
    q3_details: null,
    q4_dizziness_consciousness: false,
    q4_details: null,
    q5_bone_joint_problem: false,
    q5_details: null,
    q6_medication_condition: false,
    q6_details: null,
    q7_other_reason: false,
    q7_details: null,
    has_positive_answer: false,
    trainer_screening_notes: null,
    referral_required: false,
    referral_reason: null,
    declaration_accepted: true,
    client_signature: CLIENT_SIGNATURE,
    client_signed_at: new Date('2026-01-01T00:00:00Z'),
    trainer_signed_at: null,
    trainer_user_id: null,
    clearance_status: 'passed',
    cleared_at: null,
    cleared_by_user_id: null,
    created_at: new Date('2026-01-01T00:00:00Z'),
    updated_at: null,
    ...overrides,
  };
}

function build(latest: ParQScreening | null = screening()) {
  txState.latest = latest ? { ...latest } : null;
  const repository = {
    findLatestByMemberId: vi.fn(async () => txState.latest),
    insert: vi.fn(async (values: Partial<ParQScreening>) => {
      txState.latest = screening({ id: 5, ...values });
      return 5;
    }),
    updateById: vi.fn(async (_id: number, values: Partial<ParQScreening>) => {
      txState.latest = { ...txState.latest!, ...values };
    }),
  };
  const memberRepository = {
    findById: vi.fn().mockResolvedValue({
      id: 100,
      user_id: 30,
      assigned_trainer_id: 9,
    }),
  };
  const auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
  const service = new ParQService(
    repository as any,
    memberRepository as any,
    auditService as any,
    {} as any,
  );
  return { service, repository, auditService };
}

describe('ParQService', () => {
  describe('submit', () => {
    it('passes an all-negative questionnaire outright', async () => {
      const { service, repository } = build(screening({ clearance_status: 'passed' }));

      const result = await service.submit(100, ALL_NO, ADMIN);

      expect(repository.insert).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          has_positive_answer: false,
          referral_required: false,
          clearance_status: 'passed',
        }),
      );
      expect(result.clearance_status).toBe('passed');
    });

    it('parks a positive questionnaire in pending_clearance and flags a referral', async () => {
      const { service, repository } = build(
        screening({ q3_chest_pain_rest: true, has_positive_answer: true, clearance_status: 'pending_clearance' }),
      );

      await service.submit(
        100,
        { ...ALL_NO, q3_chest_pain_rest: true, q3_details: '  Pain on stairs  ' },
        ADMIN,
      );

      expect(repository.insert).toHaveBeenCalledWith(
        expect.objectContaining({
          q3_chest_pain_rest: true,
          q3_details: 'Pain on stairs',
          has_positive_answer: true,
          referral_required: true,
          clearance_status: 'pending_clearance',
        }),
      );
    });

    it('keeps answers and notes out of the audit record', async () => {
      const { service, auditService } = build();

      await service.submit(100, ALL_NO, ADMIN);

      const call = auditService.recordAudit.mock.calls[0]![0];
      expect(call.action).toBe('par_q.submitted');
      expect(Object.keys(call.afterState)).toEqual([
        'id',
        'member_id',
        'has_positive_answer',
        'referral_required',
        'clearance_status',
      ]);
    });

    it('stores the member signature and returns it', async () => {
      const { service } = build(null);

      const result = await service.submit(100, ALL_NO, ADMIN);

      expect(result.client_signature).toBe(CLIENT_SIGNATURE);
    });

    it('leaves the previous screening unchanged when the audit write throws', async () => {
      const previous = screening({ id: 3, clearance_status: 'passed' });
      const { service, auditService } = build(previous);
      auditService.recordAudit.mockRejectedValue(new Error('audit down'));

      await expect(service.submit(100, ALL_NO, ADMIN)).rejects.toThrow('audit down');

      const latest = await service.getLatest(100, ADMIN);
      expect(latest.id).toBe(3);
      expect(latest.clearance_status).toBe('passed');
    });
  });

  describe('submit validation', () => {
    it('requires details for every YES answer', () => {
      const result = parQSubmitSchema.safeParse({ ...ALL_NO, q5_bone_joint_problem: true });
      expect(result.success).toBe(false);
    });

    it('requires the declaration to be accepted', () => {
      const result = parQSubmitSchema.safeParse({ ...ALL_NO, declaration_accepted: false });
      expect(result.success).toBe(false);
    });

    it('rejects a submission without a signature', () => {
      const { client_signature: _omitted, ...withoutSignature } = ALL_NO;
      const result = parQSubmitSchema.safeParse(withoutSignature);
      expect(result.success).toBe(false);
    });

    it('rejects a blank signature', () => {
      const result = parQSubmitSchema.safeParse({ ...ALL_NO, client_signature: '   ' });
      expect(result.success).toBe(false);
    });

    it('requires a referral reason when a referral is required', () => {
      const result = parQTrainerReviewSchema.safeParse({
        trainer_screening_notes: 'Needs GP letter',
        referral_required: true,
      });
      expect(result.success).toBe(false);
    });
  });

  describe('trainerReview', () => {
    it('records notes, referral and trainer sign-off on the latest screening', async () => {
      const { service, repository } = build(screening({ clearance_status: 'pending_clearance' }));

      await service.trainerReview(
        100,
        {
          trainer_screening_notes: ' Knee history ',
          referral_required: true,
          referral_reason: ' GP sign-off ',
        },
        TRAINER,
      );

      expect(repository.updateById).toHaveBeenCalledWith(
        5,
        expect.objectContaining({
          trainer_screening_notes: 'Knee history',
          referral_required: true,
          referral_reason: 'GP sign-off',
          trainer_user_id: 20,
          trainer_signed_at: expect.any(Date),
        }),
      );
    });

    it('does not let a member review their own questionnaire', async () => {
      const { service } = build();

      await expect(
        service.trainerReview(
          100,
          { trainer_screening_notes: 'ok', referral_required: false },
          MEMBER,
        ),
      ).rejects.toBeInstanceOf(ForbiddenError);
    });

    it('404s when the member has no screening', async () => {
      const { service } = build(null);

      await expect(
        service.trainerReview(
          100,
          { trainer_screening_notes: 'ok', referral_required: false },
          TRAINER,
        ),
      ).rejects.toBeInstanceOf(NotFoundError);
    });

    it('leaves screening notes unchanged when the audit write throws', async () => {
      const previous = screening({
        clearance_status: 'pending_clearance',
        trainer_screening_notes: null,
      });
      const { service, auditService } = build(previous);
      auditService.recordAudit.mockRejectedValue(new Error('audit down'));

      await expect(
        service.trainerReview(
          100,
          { trainer_screening_notes: 'Knee history', referral_required: false },
          TRAINER,
        ),
      ).rejects.toThrow('audit down');

      const latest = await service.getLatest(100, ADMIN);
      expect(latest.trainer_screening_notes).toBeNull();
    });
  });

  describe('clear', () => {
    it('clears a pending screening and stamps who decided', async () => {
      const { service, repository } = build(screening({ clearance_status: 'pending_clearance' }));

      await service.clear(100, { decision: 'cleared' }, ADMIN);

      expect(repository.updateById).toHaveBeenCalledWith(
        5,
        expect.objectContaining({
          clearance_status: 'cleared',
          cleared_by_user_id: 1,
          cleared_at: expect.any(Date),
        }),
      );
    });

    it('rejects a decision on a screening that is not pending', async () => {
      const { service, repository } = build(screening({ clearance_status: 'passed' }));

      await expect(service.clear(100, { decision: 'cleared' }, ADMIN)).rejects.toBeInstanceOf(
        BusinessRuleError,
      );
      expect(repository.updateById).not.toHaveBeenCalled();
    });

    it('leaves clearance unchanged when the audit write throws', async () => {
      const previous = screening({ clearance_status: 'pending_clearance' });
      const { service, auditService } = build(previous);
      auditService.recordAudit.mockRejectedValue(new Error('audit down'));

      await expect(service.clear(100, { decision: 'cleared' }, ADMIN)).rejects.toThrow('audit down');

      const latest = await service.getLatest(100, ADMIN);
      expect(latest.clearance_status).toBe('pending_clearance');
      expect(latest.cleared_by_user_id).toBeNull();
    });
  });

  describe('getLatest', () => {
    it('returns the latest screening for a scoped member', async () => {
      const { service } = build(screening({ clearance_status: 'pending_clearance' }));

      const result = await service.getLatest(100, ADMIN);

      expect(result.id).toBe(5);
      expect(result.clearance_status).toBe('pending_clearance');
      expect(result.client_signature).toBe(CLIENT_SIGNATURE);
    });

    it('404s when the member has no screening', async () => {
      const { service } = build(null);

      await expect(service.getLatest(100, ADMIN)).rejects.toBeInstanceOf(NotFoundError);
    });

    it('does not write an audit record', async () => {
      const { service, auditService } = build();

      await service.getLatest(100, TRAINER);

      expect(auditService.recordAudit).not.toHaveBeenCalled();
    });
  });

  describe('assertMayTrain', () => {
    it.each(['pending_clearance', 'rejected'] as const)('blocks when the latest is %s', async (status) => {
      const { service } = build(screening({ clearance_status: status }));

      await expect(service.assertMayTrain(100)).rejects.toThrow(MEDICAL_CLEARANCE_REQUIRED);
    });

    it.each(['passed', 'cleared'] as const)('allows when the latest is %s', async (status) => {
      const { service } = build(screening({ clearance_status: status }));

      await expect(service.assertMayTrain(100)).resolves.toBeUndefined();
    });

    it('allows a member with no screening on file', async () => {
      const { service } = build(null);

      await expect(service.assertMayTrain(100)).resolves.toBeUndefined();
    });
  });
});
