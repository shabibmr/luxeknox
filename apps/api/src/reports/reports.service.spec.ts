import { describe, it, expect, beforeEach, vi } from 'vitest';
import { ReportsService } from './reports.service';
import { ReportsRepository } from './reports.repository';
import { SettingsService } from '../sys/settings.service';
import { PermissionCache } from '../rbac/permission-cache';
import { PersonFactory } from '../people/person.factory';
import { JobRunnerService } from '../job/job-runner.service';
import { ForbiddenError } from '../platform/errors/app-error';
import { CSV_SEPARATOR, formatToCsv, escapeCsvCell } from './reports.csv';
import { resolveReportDateRange, wallClockToUtcDate } from './reports.timezone';
import type { AuthenticatedUser } from '../auth/auth.guard';

describe('ReportsService', () => {
  let service: ReportsService;
  let reportsRepository: any;
  let settingsService: any;
  let permissionCache: any;
  let personFactory: any;
  let jobRunner: any;

  const adminUser: AuthenticatedUser = {
    id: 1,
    roleId: 2,
    userType: 'admin',
    profileId: 10,
    sessionId: 100,
    email: 'admin@example.com',
    phoneNumber: '+1234567890',
  };

  const trainerUser: AuthenticatedUser = {
    id: 2,
    roleId: 3,
    userType: 'trainer',
    profileId: 20,
    sessionId: 200,
    email: 'trainer@example.com',
    phoneNumber: '+1234567891',
  };

  const memberUser: AuthenticatedUser = {
    id: 3,
    roleId: 5,
    userType: 'member',
    profileId: 30,
    sessionId: 300,
    email: 'member@example.com',
    phoneNumber: '+1234567892',
  };

  beforeEach(() => {
    reportsRepository = {
      getMembersReport: vi.fn().mockResolvedValue([
        { category: 'summary', metric: 'acquisition_new_members', count: 12 },
        { category: 'summary', metric: 'active_members', count: 50 },
        { category: 'demographics_gender', metric: 'male', count: 30 },
      ]),
      getMembershipsReport: vi.fn().mockResolvedValue([
        { category: 'package_mix', product_name: 'Gold Annual', total_purchased: 25 },
        { category: 'summary', metric: 'total_renewals', count: 5 },
      ]),
      getAttendanceReport: vi.fn().mockResolvedValue([
        { category: 'summary', metric: 'total_footfall', value: 120 },
        { category: 'peak_hour_heatmap', hour: 18, checkin_count: 35 },
      ]),
      getPaymentsReport: vi.fn().mockResolvedValue([
        { category: 'collections', metric: 'gross_collections', amount: '5000.00' },
      ]),
      getTrainersReport: vi.fn().mockResolvedValue([
        {
          trainer_id: 20,
          trainer_name: 'John Trainer',
          sessions_delivered: 15,
          sessions_scheduled: 18,
          assigned_members: 8,
          active_members: 7,
          client_retention_rate: '87.50%',
          revenue: '1200.00',
        },
      ]),
      getWorkoutsReport: vi.fn().mockResolvedValue([
        { category: 'summary', metric: 'total_sessions_completed', value: 45 },
        { category: 'top_exercises', exercise_name: 'Bench Press', logged_sets: 90 },
      ]),
      getDietsReport: vi.fn().mockResolvedValue([
        { category: 'summary', metric: 'active_foods_in_library', count: 150 },
      ]),
      getProgressReport: vi.fn().mockResolvedValue([
        { category: 'summary', metric: 'goals_achieved', count: 8 },
      ]),
    };

    settingsService = {
      getTimezone: vi.fn().mockResolvedValue('Asia/Kolkata'),
    };

    permissionCache = {
      hasPermission: vi.fn().mockImplementation(async (_roleId: number, slug: string) => {
        if (_roleId === adminUser.roleId) {
          return true; // Admin has reports.read, reports.export, reports.read_own
        }
        if (_roleId === trainerUser.roleId) {
          return slug === 'reports.read_own'; // Trainer only has reports.read_own
        }
        return false; // Member has no report permissions
      }),
    };

    personFactory = {
      resolveProfileId: vi.fn().mockResolvedValue(20),
    };

    jobRunner = {
      run: vi.fn().mockImplementation(async (_name: string, fn: () => Promise<void>) => {
        await fn();
      }),
    };

    service = new ReportsService(
      reportsRepository,
      settingsService,
      permissionCache,
      personFactory,
      jobRunner,
    );
  });

  describe('RPT-001 / RPT-002: Member report', () => {
    it('returns member acquisition, status counts, and demographics for admin', async () => {
      const res = await service.generateReport(adminUser, 'members', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });

      expect(res.type).toBe('members');
      expect(res.from).toBe('2026-09-01');
      expect(res.to).toBe('2026-09-21');
      expect(res.rows).toHaveLength(3);
      expect(reportsRepository.getMembersReport).toHaveBeenCalledTimes(1);
    });
  });

  describe('RPT-003: Membership report', () => {
    it('queries memberships report with optional product_id filter', async () => {
      const res = await service.generateReport(adminUser, 'memberships', {
        from: '2026-09-01',
        to: '2026-09-21',
        product_id: 101,
        format: 'json',
      });

      expect(res.type).toBe('memberships');
      expect(reportsRepository.getMembershipsReport).toHaveBeenCalledWith(
        expect.any(Date),
        expect.any(Date),
        101,
      );
    });
  });

  describe('RPT-004: Attendance report', () => {
    it('queries attendance footfall, peak heatmap, and duration', async () => {
      const res = await service.generateReport(adminUser, 'attendance', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });

      expect(res.type).toBe('attendance');
      expect(reportsRepository.getAttendanceReport).toHaveBeenCalled();
      expect(res.rows[0].metric).toBe('total_footfall');
    });
  });

  describe('RPT-005: Payments report', () => {
    it('queries collections, tax, discounts, and aging', async () => {
      const res = await service.generateReport(adminUser, 'payments', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });

      expect(res.type).toBe('payments');
      expect(reportsRepository.getPaymentsReport).toHaveBeenCalled();
    });
  });

  describe('RPT-006: Trainer report (Admin)', () => {
    it('allows admin to query all trainers or specific trainer with revenue included', async () => {
      const res = await service.generateReport(adminUser, 'trainers', {
        from: '2026-09-01',
        to: '2026-09-21',
        trainer_id: 20,
        format: 'json',
      });

      expect(res.type).toBe('trainers');
      expect(reportsRepository.getTrainersReport).toHaveBeenCalledWith(
        expect.any(Date),
        expect.any(Date),
        20,
      );
      expect(res.rows[0].revenue).toBe('1200.00');
    });
  });

  describe('RPT-007: Workouts report', () => {
    it('queries workout plans, session completion rate, and volume', async () => {
      const res = await service.generateReport(adminUser, 'workouts', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });

      expect(res.type).toBe('workouts');
      expect(reportsRepository.getWorkoutsReport).toHaveBeenCalled();
    });
  });

  describe('RPT-008 & RPT-009: Diets and Progress reports', () => {
    it('queries diets and progress summaries', async () => {
      const dietRes = await service.generateReport(adminUser, 'diets', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });
      expect(dietRes.type).toBe('diets');
      expect(reportsRepository.getDietsReport).toHaveBeenCalled();

      const progressRes = await service.generateReport(adminUser, 'progress', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });
      expect(progressRes.type).toBe('progress');
      expect(reportsRepository.getProgressReport).toHaveBeenCalled();
    });
  });

  describe('RPT-010: Trainer own-slice restrictions', () => {
    it('allows a trainer to view trainer_own report with revenue stripped', async () => {
      const res = await service.generateReport(trainerUser, 'trainer_own', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'json',
      });

      expect(res.type).toBe('trainer_own');
      expect(reportsRepository.getTrainersReport).toHaveBeenCalledWith(
        expect.any(Date),
        expect.any(Date),
        20,
      );
      expect(res.rows[0].revenue).toBeUndefined();
      expect(res.rows[0].sessions_delivered).toBe(15);
    });

    it('rejects a trainer attempting to access gym-wide reports without reports.read', async () => {
      await expect(
        service.generateReport(trainerUser, 'members', {
          from: '2026-09-01',
          to: '2026-09-21',
          format: 'json',
        }),
      ).rejects.toThrow(ForbiddenError);
    });

    it('rejects a member attempting to access any report', async () => {
      await expect(
        service.generateReport(memberUser, 'members', {
          from: '2026-09-01',
          to: '2026-09-21',
          format: 'json',
        }),
      ).rejects.toThrow(ForbiddenError);

      await expect(
        service.generateReport(memberUser, 'trainer_own', {
          from: '2026-09-01',
          to: '2026-09-21',
          format: 'json',
        }),
      ).rejects.toThrow(ForbiddenError);
    });
  });

  describe('RPT-011: Gym timezone date boundaries', () => {
    it('converts date strings into gym timezone day boundaries', () => {
      const res = resolveReportDateRange('2026-09-01', '2026-09-10', 'Asia/Kolkata');
      expect(res.from).toBe('2026-09-01');
      expect(res.to).toBe('2026-09-10');
      // Asia/Kolkata is UTC+5:30.
      // 2026-09-01 00:00:00 IST = 2026-08-31 18:30:00 UTC
      expect(res.startUtc.toISOString()).toBe('2026-08-31T18:30:00.000Z');
      // 2026-09-10 23:59:59.999 IST = 2026-09-10 18:29:59.999 UTC
      expect(res.endUtc.toISOString()).toBe('2026-09-10T18:29:59.999Z');
    });

    it('defaults from and to when not specified', () => {
      const res = resolveReportDateRange(undefined, undefined, 'UTC');
      expect(res.from).toMatch(/^\d{4}-\d{2}-\d{2}$/);
      expect(res.to).toMatch(/^\d{4}-\d{2}-\d{2}$/);
      expect(res.startUtc.getTime()).toBeLessThan(res.endUtc.getTime());
    });
  });

  describe('RPT-012: CSV export with pipe separator', () => {
    it('formats CSV using "|" as separator per global rule', () => {
      const rows = [
        { id: 1, name: 'Standard Package', price: '100.00' },
        { id: 2, name: 'Deluxe | Premium', price: '200.00' },
      ];

      const csv = formatToCsv(rows);
      const lines = csv.trim().split('\n');

      expect(lines[0]).toBe('id|name|price');
      expect(lines[1]).toBe('1|Standard Package|100.00');
      // Value containing pipe '|' must be quoted
      expect(lines[2]).toBe('2|"Deluxe | Premium"|200.00');
      expect(CSV_SEPARATOR).toBe('|');
    });

    it('escapes cells containing double quotes and newlines', () => {
      expect(escapeCsvCell('Simple')).toBe('Simple');
      expect(escapeCsvCell('With|Pipe')).toBe('"With|Pipe"');
      expect(escapeCsvCell('With"Quote')).toBe('"With""Quote"');
      expect(escapeCsvCell('With\nNewline')).toBe('"With\nNewline"');
      expect(escapeCsvCell(null)).toBe('');
      expect(escapeCsvCell(undefined)).toBe('');
    });

    it('exports CSV report through service when caller has reports.export', async () => {
      const csv = await service.exportReportCsv(adminUser, 'members', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'csv',
      });

      expect(typeof csv).toBe('string');
      expect(csv).toContain('category|metric|count');
      expect(csv).toContain('summary|acquisition_new_members|12');
    });

    it('rejects CSV export if caller lacks reports.export permission', async () => {
      permissionCache.hasPermission.mockImplementation(async (_roleId: number, slug: string) => {
        return slug === 'reports.read'; // Has read but lacks export
      });

      await expect(
        service.exportReportCsv(adminUser, 'members', {
          from: '2026-09-01',
          to: '2026-09-21',
          format: 'csv',
        }),
      ).rejects.toThrow(ForbiddenError);
    });
  });

  describe('RPT-013: Async background export job', () => {
    it('queues a background job using JobRunnerService', async () => {
      const res = await service.queueAsyncReportExport(adminUser, 'memberships', {
        from: '2026-09-01',
        to: '2026-09-21',
        format: 'csv',
      });

      expect(res.status).toBe('completed');
      expect(res.jobName).toContain('report_export_memberships_');
      expect(jobRunner.run).toHaveBeenCalledWith(
        expect.stringContaining('report_export_memberships_'),
        expect.any(Function),
      );
    });
  });
});
