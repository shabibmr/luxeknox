import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import type { MemberLifestyleIntake } from '../platform/db/schema/lifestyle-intake';
import { lifestyleIntakePutSchema } from './lifestyle-intake.dto';
import { LifestyleIntakeService } from './lifestyle-intake.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => {
    insideTransaction = true;
    try {
      const result = await fn();
      intakeCommitted = true;
      return result;
    } finally {
      insideTransaction = false;
    }
  },
}));

let insideTransaction = false;
let intakeCommitted = false;

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const TRAINER_USER: AuthenticatedUser = {
  id: 20,
  email: 'trainer@luxeknox.test',
  phoneNumber: null,
  userType: 'trainer',
  roleId: 3,
  profileId: 9,
  sessionId: 3,
};

const OTHER_MEMBER: AuthenticatedUser = {
  id: 77,
  email: 'other@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 4,
  profileId: 404,
  sessionId: 8,
};

const PRIORITIES = [
  { priority: 'recovery' as const, current_status: 'Stiff', first_action: 'Mobility' },
  { priority: 'sleep' as const, current_status: '6h', first_action: 'Earlier bed' },
  { priority: 'activity' as const, current_status: '5k steps', first_action: 'Walk lunch' },
  { priority: 'nutrition' as const, current_status: 'Low protein', first_action: 'Add shake' },
];

const ORDERED_PRIORITIES = [
  { priority: 'sleep' as const, current_status: '6h', first_action: 'Earlier bed' },
  { priority: 'nutrition' as const, current_status: 'Low protein', first_action: 'Add shake' },
  { priority: 'activity' as const, current_status: '5k steps', first_action: 'Walk lunch' },
  { priority: 'recovery' as const, current_status: 'Stiff', first_action: 'Mobility' },
];

function existingRow(overrides: Partial<MemberLifestyleIntake> = {}): MemberLifestyleIntake {
  return {
    id: 1,
    member_id: 100,
    activity_level: 'light',
    training_history: 'Some history',
    current_pain_discomfort: null,
    sleep_hours_typical: '7.0',
    stress_level: 3,
    work_activity_demands: null,
    typical_daily_steps: null,
    nutrition_approach: null,
    hydration_habits: null,
    recovery_habits: null,
    other_notes: null,
    lifestyle_priorities: ORDERED_PRIORITIES,
    conducted_by_trainer_id: null,
    created_at: new Date('2026-01-01T00:00:00.000Z'),
    updated_at: new Date('2026-01-01T00:00:00.000Z'),
    ...overrides,
  };
}

describe('LifestyleIntakeService', () => {
  let service: LifestyleIntakeService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };

  const putBody = {
    stress_level: 4,
    activity_level: 'moderate' as const,
    sleep_hours_typical: 7.5,
    lifestyle_priorities: PRIORITIES,
  };

  beforeEach(() => {
    insideTransaction = false;
    intakeCommitted = false;

    repository = {
      findByMemberId: vi.fn().mockResolvedValue(null),
      insert: vi.fn().mockImplementation(async () => {
        expect(insideTransaction).toBe(true);
        return 1;
      }),
      updateByMemberId: vi.fn().mockImplementation(async () => {
        expect(insideTransaction).toBe(true);
      }),
    };

    memberRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        expect(insideTransaction).toBe(false);
        return {
          id,
          user_id: 10,
          assigned_trainer_id: null,
        };
      }),
    };

    auditService = {
      recordAudit: vi.fn().mockImplementation(async () => {
        expect(insideTransaction).toBe(true);
      }),
    };

    service = new LifestyleIntakeService(
      repository as any,
      memberRepository as any,
      auditService as any,
      {} as any,
    );
  });

  it('put_inserts_when_no_row', async () => {
    repository.findByMemberId
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(
        existingRow({
          stress_level: 4,
          activity_level: 'moderate',
          sleep_hours_typical: '7.5',
          lifestyle_priorities: ORDERED_PRIORITIES,
        }),
      );

    const result = await service.put(
      100,
      {
        stress_level: 4,
        activity_level: 'moderate',
        sleep_hours_typical: 7.5,
        lifestyle_priorities: PRIORITIES,
      },
      ADMIN_USER,
    );

    expect(repository.insert).toHaveBeenCalledWith(
      expect.objectContaining({
        member_id: 100,
        stress_level: 4,
        sleep_hours_typical: '7.5',
        activity_level: 'moderate',
        lifestyle_priorities: ORDERED_PRIORITIES,
      }),
    );
    expect(repository.updateByMemberId).not.toHaveBeenCalled();
    const saved = existingRow({
      stress_level: 4,
      activity_level: 'moderate',
      sleep_hours_typical: '7.5',
      lifestyle_priorities: ORDERED_PRIORITIES,
    });
    expect(auditService.recordAudit).toHaveBeenCalledWith({
      actorUserId: ADMIN_USER.id,
      action: 'lifestyle_intake.created',
      entityName: 'member_lifestyle_intakes',
      entityId: 1,
      beforeState: undefined,
      afterState: saved,
    });
    expect(intakeCommitted).toBe(true);
    expect(insideTransaction).toBe(false);
    expect(result.stress_level).toBe(4);
    expect(result.sleep_hours_typical).toBe('7.5');
  });

  it('put_updates_when_row_exists', async () => {
    const before = existingRow();
    const saved = existingRow({ stress_level: 5 });
    repository.findByMemberId.mockResolvedValueOnce(before).mockResolvedValueOnce(saved);

    await service.put(
      100,
      {
        stress_level: 5,
        lifestyle_priorities: PRIORITIES,
      },
      ADMIN_USER,
    );

    expect(repository.insert).not.toHaveBeenCalled();
    expect(repository.updateByMemberId).toHaveBeenCalledWith(
      100,
      expect.objectContaining({ stress_level: 5 }),
    );
    expect(auditService.recordAudit).toHaveBeenCalledWith({
      actorUserId: ADMIN_USER.id,
      action: 'lifestyle_intake.updated',
      entityName: 'member_lifestyle_intakes',
      entityId: before.id,
      beforeState: before,
      afterState: saved,
    });
    expect(intakeCommitted).toBe(true);
    expect(insideTransaction).toBe(false);
  });

  it('put_omitted_text_stores_null', async () => {
    repository.findByMemberId
      .mockResolvedValueOnce(existingRow({ training_history: 'Some history' }))
      .mockResolvedValueOnce(existingRow({ training_history: null }));

    await service.put(
      100,
      {
        stress_level: 4,
        lifestyle_priorities: PRIORITIES,
      },
      ADMIN_USER,
    );

    expect(repository.updateByMemberId).toHaveBeenCalledWith(
      100,
      expect.objectContaining({ training_history: null }),
    );
  });

  it('put_trainer_overwrites_conducted_by', async () => {
    memberRepository.findById.mockResolvedValue({
      id: 100,
      user_id: 10,
      assigned_trainer_id: 9,
    });
    repository.findByMemberId
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(existingRow({ conducted_by_trainer_id: 9 }));

    await service.put(
      100,
      {
        stress_level: 4,
        lifestyle_priorities: PRIORITIES,
        conducted_by_trainer_id: 4,
      },
      TRAINER_USER,
    );

    expect(repository.insert).toHaveBeenCalledWith(
      expect.objectContaining({ conducted_by_trainer_id: 9 }),
    );
  });

  it('put_non_trainer_stores_body_trainer_or_null', async () => {
    repository.findByMemberId
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(existingRow({ conducted_by_trainer_id: null }));

    await service.put(
      100,
      {
        stress_level: 4,
        lifestyle_priorities: PRIORITIES,
      },
      ADMIN_USER,
    );

    expect(repository.insert).toHaveBeenCalledWith(
      expect.objectContaining({ conducted_by_trainer_id: null }),
    );
  });

  it('put_audit_failure_leaves_a_first_save_uncommitted', async () => {
    auditService.recordAudit.mockRejectedValue(new Error('audit write failed'));
    repository.findByMemberId
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(existingRow({ stress_level: 4 }));

    await expect(service.put(100, putBody, ADMIN_USER)).rejects.toThrow('audit write failed');

    expect(repository.insert).toHaveBeenCalledOnce();
    expect(intakeCommitted).toBe(false);
    expect(insideTransaction).toBe(false);
  });

  it('put_audit_failure_leaves_a_replacement_uncommitted', async () => {
    const before = existingRow();
    memberRepository.findById.mockResolvedValue({
      id: 100,
      user_id: 10,
      assigned_trainer_id: 9,
    });
    auditService.recordAudit.mockRejectedValue(new Error('audit write failed'));
    repository.findByMemberId
      .mockResolvedValueOnce(before)
      .mockResolvedValueOnce(existingRow({ stress_level: 4 }));

    await expect(service.put(100, putBody, TRAINER_USER)).rejects.toThrow('audit write failed');

    expect(repository.updateByMemberId).toHaveBeenCalledOnce();
    expect(repository.insert).not.toHaveBeenCalled();
    expect(intakeCommitted).toBe(false);
  });

  it('put_hidden_member_writes_nothing', async () => {
    memberRepository.findById.mockResolvedValue({
      id: 100,
      user_id: 55,
      assigned_trainer_id: 4,
    });

    await expect(service.put(100, putBody, TRAINER_USER)).rejects.toBeInstanceOf(NotFoundError);
    await expect(service.put(100, putBody, OTHER_MEMBER)).rejects.toBeInstanceOf(NotFoundError);

    expect(repository.findByMemberId).not.toHaveBeenCalled();
    expect(repository.insert).not.toHaveBeenCalled();
    expect(repository.updateByMemberId).not.toHaveBeenCalled();
    expect(auditService.recordAudit).not.toHaveBeenCalled();
    expect(intakeCommitted).toBe(false);
  });

  it('put_reload_miss_fails_with_not_found', async () => {
    repository.findByMemberId.mockResolvedValueOnce(null).mockResolvedValueOnce(null);

    await expect(service.put(100, putBody, ADMIN_USER)).rejects.toThrow('Lifestyle intake not found');

    expect(repository.insert).toHaveBeenCalledOnce();
    expect(auditService.recordAudit).not.toHaveBeenCalled();
    expect(intakeCommitted).toBe(false);
  });

  it('get_writes_no_audit', async () => {
    repository.findByMemberId.mockImplementation(async () => {
      expect(insideTransaction).toBe(false);
      return existingRow();
    });

    const result = await service.get(100, ADMIN_USER);

    expect(result.id).toBe(1);
    expect(auditService.recordAudit).not.toHaveBeenCalled();
    expect(repository.insert).not.toHaveBeenCalled();
    expect(repository.updateByMemberId).not.toHaveBeenCalled();
    expect(intakeCommitted).toBe(false);
  });

  it('get_missing_throws', async () => {
    repository.findByMemberId.mockResolvedValue(null);
    await expect(service.get(100, ADMIN_USER)).rejects.toThrow(NotFoundError);
    await expect(service.get(100, ADMIN_USER)).rejects.toThrow('Lifestyle intake not found');
  });

  it('schema_rejects_stress_outside_1_to_10', () => {
    const base = { lifestyle_priorities: ORDERED_PRIORITIES };
    expect(lifestyleIntakePutSchema.safeParse({ ...base, stress_level: 0 }).success).toBe(false);
    expect(lifestyleIntakePutSchema.safeParse({ ...base, stress_level: 11 }).success).toBe(false);
    expect(lifestyleIntakePutSchema.safeParse({ ...base, stress_level: 1 }).success).toBe(true);
    expect(lifestyleIntakePutSchema.safeParse({ ...base, stress_level: 10 }).success).toBe(true);
  });

  it('schema_rejects_priority_gaps_and_duplicates', () => {
    const three = ORDERED_PRIORITIES.slice(0, 3);
    expect(
      lifestyleIntakePutSchema.safeParse({ stress_level: 4, lifestyle_priorities: three }).success,
    ).toBe(false);

    const dupSleep = [
      ORDERED_PRIORITIES[0],
      ORDERED_PRIORITIES[0],
      ORDERED_PRIORITIES[1],
      ORDERED_PRIORITIES[2],
    ];
    expect(
      lifestyleIntakePutSchema.safeParse({ stress_level: 4, lifestyle_priorities: dupSleep }).success,
    ).toBe(false);

    const blankAction = ORDERED_PRIORITIES.map((p, i) =>
      i === 0 ? { ...p, first_action: '   ' } : p,
    );
    expect(
      lifestyleIntakePutSchema.safeParse({ stress_level: 4, lifestyle_priorities: blankAction })
        .success,
    ).toBe(false);
  });

  it('schema_rejects_bad_activity_and_sleep', () => {
    const base = { stress_level: 4, lifestyle_priorities: ORDERED_PRIORITIES };
    expect(
      lifestyleIntakePutSchema.safeParse({ ...base, activity_level: 'athlete' }).success,
    ).toBe(false);
    expect(
      lifestyleIntakePutSchema.safeParse({ ...base, sleep_hours_typical: 24.1 }).success,
    ).toBe(false);
    expect(
      lifestyleIntakePutSchema.safeParse({ ...base, sleep_hours_typical: 7.25 }).success,
    ).toBe(false);
    expect(lifestyleIntakePutSchema.safeParse({ ...base, sleep_hours_typical: 0 }).success).toBe(
      true,
    );
    expect(lifestyleIntakePutSchema.safeParse({ ...base, sleep_hours_typical: 24 }).success).toBe(
      true,
    );
  });
});
