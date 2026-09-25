import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { DietLogService } from './diet-log.service';

const trainerActor: AuthenticatedUser = {
  id: 2,
  email: 'trainer@example.com',
  phoneNumber: null,
  roleId: 2,
  userType: 'trainer',
  profileId: 20,
  sessionId: 2,
};

const memberActor: AuthenticatedUser = {
  id: 3,
  email: 'member@example.com',
  phoneNumber: null,
  roleId: 3,
  userType: 'member',
  profileId: 30,
  sessionId: 3,
};

function buildService(overrides: {
  logRepo?: Partial<Record<string, unknown>>;
  planRepo?: Partial<Record<string, unknown>>;
  memberRepo?: Partial<Record<string, unknown>>;
  settingsService?: Partial<Record<string, unknown>>;
  eventBus?: Partial<Record<string, unknown>>;
} = {}) {
  const logRepo = {
    upsertLog: vi.fn(),
    findByMemberAndDate: vi.fn().mockResolvedValue(null),
    findLogs: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    getRollupSummary: vi.fn().mockResolvedValue({
      logged_days: 5,
      avg_calories_consumed: 2100,
      avg_adherence_score: 95,
      avg_water_intake_ml: 2500,
    }),
    ...overrides.logRepo,
  };

  const planRepo = {
    findPlanById: vi.fn().mockResolvedValue(null),
    findActivePlanForMember: vi.fn().mockResolvedValue({
      id: 10,
      title: 'Active Cut',
      member_id: 30,
      daily_calorie_target: 2000,
    }),
    ...overrides.planRepo,
  };

  const memberRepo = {
    findById: vi.fn().mockImplementation(async (id: number) => {
      if (id === 30) {
        return { id: 30, user_id: 3, assigned_trainer_id: 20 };
      }
      if (id === 40) {
        return { id: 40, user_id: 4, assigned_trainer_id: 99 };
      }
      return null;
    }),
    ...overrides.memberRepo,
  };

  const settingsService = {
    getDietAdherenceFormula: vi.fn().mockResolvedValue('calorie_ratio'),
    ...overrides.settingsService,
  };

  const eventBus = {
    emitSync: vi.fn(),
    emit: vi.fn().mockResolvedValue([]),
    ...overrides.eventBus,
  };

  const paginationHelper = {
    normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
  };

  const service = new DietLogService(
    logRepo as any,
    planRepo as any,
    memberRepo as any,
    settingsService as any,
    eventBus as any,
    paginationHelper as any,
  );

  return { service, logRepo, planRepo, memberRepo, settingsService, eventBus };
}

describe('DietLogService', () => {
  describe('putLog (DIT-010, DIT-011)', () => {
    it('rejects invalid date format', async () => {
      const { service } = buildService();
      await expect(
        service.putLog(30, 'invalid-date', { total_calories_consumed: 2000 }, memberActor),
      ).rejects.toThrow(BadRequestError);
    });

    it('member can upsert own daily diet log and adherence is computed (DIT-010, DIT-011)', async () => {
      const { service, logRepo, eventBus } = buildService();
      logRepo.upsertLog.mockResolvedValue({
        id: 1,
        member_id: 30,
        diet_plan_id: 10,
        logged_date: '2026-09-21',
        total_calories_consumed: 1900,
        adherence_score: 95,
        water_intake_ml: 3000,
        member_notes: 'Felt great',
      });

      const result = await service.putLog(
        30,
        '2026-09-21',
        {
          total_calories_consumed: 1900,
          water_intake_ml: 3000,
          member_notes: 'Felt great',
        },
        memberActor,
      );

      // Target was 2000, consumed 1900 -> deviation = 100/2000 = 5% -> adherence = 95%
      expect(logRepo.upsertLog).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 30,
          diet_plan_id: 10,
          logged_date: '2026-09-21',
          total_calories_consumed: 1900,
          adherence_score: 95,
          water_intake_ml: 3000,
        }),
      );
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_log.recorded',
          payload: expect.objectContaining({
            member_id: 30,
            logged_date: '2026-09-21',
            adherence_score: 95,
          }),
        }),
      );
      expect(result.id).toBe(1);
    });

    it('respects client-supplied adherence score if provided', async () => {
      const { service, logRepo } = buildService();
      logRepo.upsertLog.mockResolvedValue({
        id: 2,
        member_id: 30,
        logged_date: '2026-09-21',
        total_calories_consumed: 2500,
        adherence_score: 80,
      });

      await service.putLog(
        30,
        '2026-09-21',
        {
          total_calories_consumed: 2500,
          adherence_score: 80,
        },
        memberActor,
      );

      expect(logRepo.upsertLog).toHaveBeenCalledWith(
        expect.objectContaining({
          adherence_score: 80,
        }),
      );
    });

    it('trainer can log for assigned member', async () => {
      const { service, logRepo } = buildService();
      logRepo.upsertLog.mockResolvedValue({
        id: 3,
        member_id: 30,
        logged_date: '2026-09-21',
        total_calories_consumed: 2000,
      });

      const res = await service.putLog(
        30,
        '2026-09-21',
        { total_calories_consumed: 2000 },
        trainerActor,
      );
      expect(res.id).toBe(3);
    });

    it('trainer rejected when logging for unassigned member', async () => {
      const { service } = buildService();
      await expect(
        service.putLog(
          40,
          '2026-09-21',
          { total_calories_consumed: 2000 },
          trainerActor,
        ),
      ).rejects.toThrow(NotFoundError);
    });
  });

  describe('listLogs', () => {
    it('returns paginated logs for member', async () => {
      const { service, logRepo } = buildService();
      logRepo.findLogs.mockResolvedValue({
        rows: [
          {
            id: 1,
            member_id: 30,
            logged_date: '2026-09-21',
            total_calories_consumed: 2000,
          },
        ],
        total: 1,
      });

      const result = await service.listLogs(
        30,
        {},
        { from: '2026-09-01', to: '2026-09-30' },
        memberActor,
      );

      expect(result.data).toHaveLength(1);
      expect(logRepo.findLogs).toHaveBeenCalledWith(
        expect.objectContaining({
          memberId: 30,
          from: '2026-09-01',
          to: '2026-09-30',
        }),
      );
    });
  });

  describe('getSummary (DIT-012 rollups)', () => {
    it('returns rollup summary for member intake', async () => {
      const { service, logRepo } = buildService();
      const summary = await service.getSummary(30, '2026-09-01', '2026-09-30', memberActor);

      expect(summary.logged_days).toBe(5);
      expect(summary.avg_calories_consumed).toBe(2100);
      expect(summary.avg_adherence_score).toBe(95);
    });
  });
});
