import { beforeEach, describe, expect, it, vi } from 'vitest';
import { ForbiddenException } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { MemberRepository } from '../people/member.repository';
import type { AuditService } from '../platform/audit/audit.service';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { PaginationHelper } from '../platform/http/pagination';
import type { SettingsService } from '../sys/settings.service';
import type { GoalRepository } from './goal.repository';
import type { GoalService } from './goal.service';
import type { MeasurementRepository } from './measurement.repository';
import { MeasurementService } from './measurement.service';

describe('MeasurementService (GOA-006, GOA-007, GOA-008, GOA-013)', () => {
  let measurementService: MeasurementService;
  let measurementRepo: any;
  let goalRepo: any;
  let goalService: any;
  let memberRepo: any;
  let settingsService: any;
  let paginationHelper: PaginationHelper;
  let auditService: any;

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

  beforeEach(() => {
    const mockSettings = { getDefaultPageSize: vi.fn().mockResolvedValue(20) } as any;
    paginationHelper = new PaginationHelper(mockSettings);

    measurementRepo = {
      createWithValues: vi.fn().mockImplementation(async (data) => ({
        id: 1,
        member_id: data.member_id,
        recorded_by_user_id: data.recorded_by_user_id,
        recorded_at: data.recorded_at,
        notes: data.notes,
        created_at: new Date(),
        values: data.values.map((v: any, idx: number) => ({
          id: idx + 1,
          measurement_id: 1,
          metric_id: v.metric_id,
          value: v.value,
          metric_name: 'Weight',
          unit_of_measure: 'kg',
        })),
      })),
      findByIdWithValues: vi.fn().mockResolvedValue({
        id: 1,
        member_id: 100,
        recorded_by_user_id: 20,
        recorded_at: new Date(),
        notes: 'Monthly check',
        created_at: new Date(),
        values: [
          {
            id: 1,
            measurement_id: 1,
            metric_id: 1,
            value: 75.5,
            metric_name: 'Weight',
            unit_of_measure: 'kg',
          },
        ],
      }),
      findManyByMemberId: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
      findLongitudinalSeries: vi.fn().mockResolvedValue([
        {
          measurement_id: 1,
          recorded_at: new Date('2026-01-01T10:00:00Z'),
          metric_id: 1,
          metric_name: 'Weight',
          unit_of_measure: 'kg',
          value: 80.0,
        },
        {
          measurement_id: 2,
          recorded_at: new Date('2026-02-01T10:00:00Z'),
          metric_id: 1,
          metric_name: 'Weight',
          unit_of_measure: 'kg',
          value: 77.5,
        },
      ]),
    };

    goalRepo = {
      findActiveByMemberIdAndMetricId: vi.fn().mockResolvedValue([
        {
          id: 10,
          member_id: 100,
          metric_id: 1,
          baseline_value: 85,
          target_value: 75,
          current_value: 80,
          status: 'in_progress',
          row_version: 1,
        },
      ]),
      addHistory: vi.fn().mockResolvedValue({ id: 101 }),
      update: vi.fn().mockResolvedValue({}),
      updateById: vi.fn().mockResolvedValue({}),
    };

    goalService = {
      evaluateAchievement: vi.fn().mockImplementation((b, t, c) => {
        if (b > t) return c <= t;
        if (b < t) return c >= t;
        return c === t;
      }),
    };

    memberRepo = {
      findById: vi.fn().mockImplementation(async (id) => {
        if (id === 100) {
          return { id: 100, assigned_trainer_id: 5, user_id: 20 };
        }
        return null;
      }),
    };

    settingsService = {
      getMandatoryMeasurementMetricIds: vi.fn().mockResolvedValue([]),
    };

    auditService = {
      recordAudit: vi.fn().mockResolvedValue(undefined),
    };

    measurementService = new MeasurementService(
      measurementRepo,
      goalRepo,
      goalService,
      memberRepo,
      settingsService,
      paginationHelper,
      auditService,
    );
  });

  describe('Measurement Recording & Batch Values (GOA-006)', () => {
    it('records a measurement session with multiple metric values', async () => {
      const res = await measurementService.createMeasurement(
        100,
        {
          notes: 'Session notes',
          values: [
            { metric_id: 1, value: 75.5 },
            { metric_id: 2, value: 18.0 },
          ],
        },
        mockMemberUser,
      );

      expect(res.id).toBe(1);
      expect(measurementRepo.createWithValues).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          notes: 'Session notes',
          values: [
            { metric_id: 1, value: 75.5 },
            { metric_id: 2, value: 18.0 },
          ],
        }),
      );
    });

    it('allows assigned trainer to record measurements for client', async () => {
      await measurementService.createMeasurement(
        100,
        {
          values: [{ metric_id: 1, value: 75.5 }],
        },
        mockTrainerUser,
      );

      expect(measurementRepo.createWithValues).toHaveBeenCalled();
    });

    it('rejects unassigned trainer attempting to record measurements', async () => {
      const unassignedTrainer: AuthenticatedUser = {
        ...mockTrainerUser,
        profileId: 99,
      };

      await expect(
        measurementService.createMeasurement(
          100,
          {
            values: [{ metric_id: 1, value: 75.5 }],
          },
          unassignedTrainer,
        ),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('Mandatory Metrics by Settings (GOA-007)', () => {
    it('rejects measurement session missing mandatory metrics configured in settings', async () => {
      // Configure mandatory metrics [1, 2] (e.g. Weight and Body Fat)
      settingsService.getMandatoryMeasurementMetricIds.mockResolvedValue([1, 2]);

      await expect(
        measurementService.createMeasurement(
          100,
          {
            values: [{ metric_id: 1, value: 75.5 }], // missing metric_id: 2
          },
          mockMemberUser,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('accepts measurement session when all mandatory metrics are provided', async () => {
      settingsService.getMandatoryMeasurementMetricIds.mockResolvedValue([1, 2]);

      const res = await measurementService.createMeasurement(
        100,
        {
          values: [
            { metric_id: 1, value: 75.5 },
            { metric_id: 2, value: 18.2 },
          ],
        },
        mockMemberUser,
      );

      expect(res).toBeDefined();
    });
  });

  describe('Goal Synchronization from Measurement Writes (GOA-008 & GOA-009)', () => {
    it('automatically updates current_value and appends history for matching active goals', async () => {
      await measurementService.createMeasurement(
        100,
        {
          values: [{ metric_id: 1, value: 78.0 }],
        },
        mockMemberUser,
      );

      // Should query active goals for member 100 with metric 1
      expect(goalRepo.findActiveByMemberIdAndMetricId).toHaveBeenCalledWith(100, 1);

      // Should add milestone history
      expect(goalRepo.addHistory).toHaveBeenCalledWith(
        expect.objectContaining({
          goal_id: 10,
          recorded_value: 78.0,
        }),
      );

      // Should update goal current_value
      expect(goalRepo.updateById).toHaveBeenCalledWith(
        10,
        expect.objectContaining({
          current_value: 78.0,
          status: 'in_progress',
        }),
      );
    });

    it('marks matching goal as achieved when target is reached via measurement write', async () => {
      // Target was 75kg from 85kg baseline. Value 74kg exceeds/reaches target
      await measurementService.createMeasurement(
        100,
        {
          values: [{ metric_id: 1, value: 74.0 }],
        },
        mockMemberUser,
      );

      expect(goalRepo.updateById).toHaveBeenCalledWith(
        10,
        expect.objectContaining({
          current_value: 74.0,
          status: 'achieved',
        }),
      );
    });
  });

  describe('Longitudinal Chart Queries (GOA-013)', () => {
    it('retrieves time series data points ordered chronologically', async () => {
      const chart = await measurementService.getLongitudinalChart(
        100,
        1,
        '2026-01-01',
        '2026-03-01',
        mockMemberUser,
      );

      expect(chart).toHaveLength(2);
      expect(chart[0].value).toBe(80.0);
      expect(chart[1].value).toBe(77.5);
      expect(measurementRepo.findLongitudinalSeries).toHaveBeenCalledWith(
        100,
        1,
        expect.any(Date),
        expect.any(Date),
      );
    });
  });
});
