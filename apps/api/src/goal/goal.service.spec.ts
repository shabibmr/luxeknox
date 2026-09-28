import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { MemberRepository } from '../people/member.repository';
import type { AuditService } from '../platform/audit/audit.service';
import type { GoalMetric } from '../platform/db/schema/goals';
import { BusinessRuleError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { PaginationHelper } from '../platform/http/pagination';
import type { GoalMetricRepository } from './goal-metric.repository';
import { GoalMetricService } from './goal-metric.service';
import type { GoalRepository } from './goal.repository';
import { GoalService } from './goal.service';

describe('GoalService & GoalMetricService (GOA-003, GOA-004, GOA-005, GOA-009)', () => {
  let goalService: GoalService;
  let metricService: GoalMetricService;
  let goalRepo: any;
  let metricRepo: any;
  let memberRepo: any;
  let auditService: any;
  let paginationHelper: PaginationHelper;

  const mockAdminUser: AuthenticatedUser = {
    id: 1,
    roleId: 1,
    userType: 'admin',
    email: 'admin@luxeknox.com',
    phoneNumber: null,
    profileId: null,
    sessionId: 1,
  };

  const mockTrainerUser: AuthenticatedUser = {
    id: 10,
    roleId: 2,
    userType: 'trainer',
    profileId: 5,
    email: 'trainer@luxeknox.com',
    phoneNumber: null,
    sessionId: 2,
  };

  const mockMemberUser: AuthenticatedUser = {
    id: 20,
    roleId: 4,
    userType: 'member',
    profileId: 100,
    email: 'member@luxeknox.com',
    phoneNumber: null,
    sessionId: 3,
  };

  const sampleMetric: GoalMetric = {
    id: 1,
    name: 'Bench Press',
    unit_of_measure: 'kg',
    category: 'strength',
    is_active: true,
    created_at: new Date('2026-01-01T00:00:00Z'),
    updated_at: new Date('2026-01-01T00:00:00Z'),
  };

  beforeEach(() => {
    const mockSettings = { getDefaultPageSize: vi.fn().mockResolvedValue(20) } as any;
    paginationHelper = new PaginationHelper(mockSettings);

    metricRepo = {
      findManyFiltered: vi.fn().mockResolvedValue({ rows: [sampleMetric], total: 1 }),
      findById: vi.fn().mockResolvedValue(sampleMetric),
      create: vi.fn().mockImplementation(async (data) => ({ id: 1, ...data })),
      update: vi.fn().mockImplementation(async (id, data) => ({ ...sampleMetric, ...data })),
      updateById: vi.fn().mockImplementation(async (id, data) => ({ ...sampleMetric, ...data })),
    };

    goalRepo = {
      findManyByMemberId: vi.fn().mockResolvedValue({
        rows: [
          {
            id: 1,
            member_id: 100,
            metric_id: 1,
            baseline_value: 80,
            target_value: 100,
            current_value: 85,
            start_date: '2026-01-01',
            target_date: '2026-06-01',
            status: 'in_progress',
            row_version: 1,
            created_at: new Date(),
            updated_at: new Date(),
            metric: sampleMetric,
          },
        ],
        total: 1,
      }),
      findById: vi.fn().mockResolvedValue({
        id: 1,
        member_id: 100,
        metric_id: 1,
        baseline_value: 80,
        target_value: 100,
        current_value: 85,
        start_date: '2026-01-01',
        target_date: '2026-06-01',
        status: 'in_progress',
        row_version: 1,
        created_at: new Date(),
        updated_at: new Date(),
      }),
      findByIdWithMetric: vi.fn().mockResolvedValue({
        id: 1,
        member_id: 100,
        metric_id: 1,
        baseline_value: 80,
        target_value: 100,
        current_value: 85,
        start_date: '2026-01-01',
        target_date: '2026-06-01',
        status: 'in_progress',
        row_version: 1,
        created_at: new Date(),
        updated_at: new Date(),
        metric: sampleMetric,
      }),
      findByIdWithDetail: vi.fn().mockResolvedValue({
        id: 1,
        member_id: 100,
        metric_id: 1,
        baseline_value: 80,
        target_value: 100,
        current_value: 85,
        start_date: '2026-01-01',
        target_date: '2026-06-01',
        status: 'in_progress',
        row_version: 1,
        created_at: new Date(),
        updated_at: new Date(),
        metric: sampleMetric,
        histories: [],
      }),
      create: vi.fn().mockImplementation(async (data) => ({ id: 1, ...data })),
      update: vi.fn().mockImplementation(async (id, data) => ({
        id,
        member_id: 100,
        metric_id: 1,
        baseline_value: 80,
        target_value: 100,
        current_value: 85,
        start_date: '2026-01-01',
        target_date: '2026-06-01',
        status: 'in_progress',
        row_version: 2,
        created_at: new Date(),
        updated_at: new Date(),
        ...data,
      })),
      updateById: vi.fn().mockImplementation(async (id, data) => ({
        id,
        member_id: 100,
        metric_id: 1,
        baseline_value: 80,
        target_value: 100,
        current_value: 85,
        start_date: '2026-01-01',
        target_date: '2026-06-01',
        status: 'in_progress',
        row_version: 2,
        created_at: new Date(),
        updated_at: new Date(),
        ...data,
      })),
      addHistory: vi.fn().mockImplementation(async (data) => ({ id: 1, ...data })),
      listHistories: vi.fn().mockResolvedValue([]),
    };

    memberRepo = {
      findById: vi.fn().mockImplementation(async (id) => {
        if (id === 100) {
          return { id: 100, assigned_trainer_id: 5, user_id: 20 };
        }
        return null;
      }),
    };

    auditService = {
      recordAudit: vi.fn().mockResolvedValue(undefined),
    };

    metricService = new GoalMetricService(metricRepo, paginationHelper, auditService);
    goalService = new GoalService(
      goalRepo,
      metricRepo,
      memberRepo,
      paginationHelper,
      auditService,
    );
  });

  describe('GoalMetricService (GOA-003)', () => {
    it('lists goal metrics with pagination and filtering', async () => {
      const res = await metricService.list({}, { category: 'strength', limit: 50 });
      expect(res.data).toHaveLength(1);
      expect(res.data[0].name).toBe('Bench Press');
      expect(metricRepo.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({ category: 'strength' }),
      );
    });

    it('creates a new goal metric and writes audit trail', async () => {
      const created = await metricService.create(
        {
          name: 'Body Weight',
          unit_of_measure: 'kg',
          category: 'body_composition',
          is_active: true,
        },
        mockAdminUser,
      );

      expect(created.name).toBe('Body Weight');
      expect(metricRepo.create).toHaveBeenCalled();
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({ entityName: 'goal_metrics', action: 'create' }),
      );
    });

    it('updates an existing goal metric', async () => {
      const updated = await metricService.update(
        1,
        { name: 'Incline Bench Press' },
        mockAdminUser,
      );
      expect(updated.name).toBe('Incline Bench Press');
      expect(metricRepo.updateById).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ name: 'Incline Bench Press' }),
      );
    });
  });

  describe('GoalService Lifecycle & Access Control (GOA-004)', () => {
    it('allows assigned trainer to create a goal for their client', async () => {
      const goal = await goalService.createGoal(
        100,
        {
          metric_id: 1,
          baseline_value: 80,
          target_value: 100,
          start_date: '2026-02-01',
        },
        mockTrainerUser,
      );

      expect(goal.id).toBe(1);
      expect(goalRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          metric_id: 1,
          baseline_value: 80,
          target_value: 100,
          current_value: 80,
          status: 'in_progress',
        }),
      );
    });

    it('rejects member attempting to create goal directly (FR-GOAL-003)', async () => {
      await expect(
        goalService.createGoal(
          100,
          {
            metric_id: 1,
            baseline_value: 80,
            target_value: 100,
            start_date: '2026-02-01',
          },
          mockMemberUser,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('rejects unassigned trainer attempting to create goal for member', async () => {
      const unassignedTrainer: AuthenticatedUser = {
        ...mockTrainerUser,
        profileId: 99,
      };

      await expect(
        goalService.createGoal(
          100,
          {
            metric_id: 1,
            baseline_value: 80,
            target_value: 100,
            start_date: '2026-02-01',
          },
          unassignedTrainer,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('allows member to list their own goals with joined metrics', async () => {
      const res = await goalService.listMemberGoals(100, {}, {}, mockMemberUser);
      expect(res.data).toHaveLength(1);
      expect(res.data[0].metric.name).toBe('Bench Press');
    });

    it('rejects member attempting to read another member goals', async () => {
      await expect(
        goalService.listMemberGoals(200, {}, {}, mockMemberUser),
      ).rejects.toThrow(NotFoundError);
    });
  });

  describe('Goal Check-ins & Achievement Logic (GOA-005 & GOA-009)', () => {
    it('evaluates target achievement directionally: gain target (baseline < target)', () => {
      // e.g. bench press from 80kg to 100kg
      expect(goalService.evaluateAchievement(80, 100, 95)).toBe(false);
      expect(goalService.evaluateAchievement(80, 100, 100)).toBe(true);
      expect(goalService.evaluateAchievement(80, 100, 105)).toBe(true);
    });

    it('evaluates target achievement directionally: loss target (baseline > target)', () => {
      // e.g. body fat from 25% down to 15%
      expect(goalService.evaluateAchievement(25, 15, 18)).toBe(false);
      expect(goalService.evaluateAchievement(25, 15, 15)).toBe(true);
      expect(goalService.evaluateAchievement(25, 15, 13)).toBe(true);
    });

    it('records check-in, writes goal history and marks achieved when target is reached', async () => {
      const history = await goalService.checkIn(
        1,
        {
          recorded_value: 100,
          notes: 'Reached milestone target',
        },
        mockMemberUser,
      );

      expect(history.recorded_value).toBe(100);
      expect(goalRepo.addHistory).toHaveBeenCalledWith(
        expect.objectContaining({
          goal_id: 1,
          recorded_value: 100,
        }),
      );

      // Status should transition to 'achieved'
      expect(goalRepo.updateById).toHaveBeenCalledWith(
        1,
        expect.objectContaining({
          current_value: 100,
          status: 'achieved',
        }),
      );
    });

    it('keeps in_progress status when milestone is not yet reached', async () => {
      await goalService.checkIn(
        1,
        {
          recorded_value: 90,
          notes: 'Halfway there',
        },
        mockMemberUser,
      );

      expect(goalRepo.updateById).toHaveBeenCalledWith(
        1,
        expect.objectContaining({
          current_value: 90,
          status: 'in_progress',
        }),
      );
    });
  });
});
