import { describe, it, expect, beforeEach, vi } from 'vitest';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Response } from 'express';

describe('ReportsController', () => {
  let controller: ReportsController;
  let service: any;

  const adminUser: AuthenticatedUser = {
    id: 1,
    roleId: 2,
    userType: 'admin',
    profileId: 10,
    sessionId: 100,
    email: 'admin@example.com',
    phoneNumber: '+1234567890',
  };

  beforeEach(() => {
    service = {
      generateReport: vi.fn().mockResolvedValue({
        type: 'members',
        from: '2026-09-01',
        to: '2026-09-21',
        rows: [
          { category: 'summary', metric: 'acquisition_new_members', count: 12 },
          { category: 'summary', metric: 'active_members', count: 50 },
        ],
      }),
    };

    controller = new ReportsController(service as ReportsService);
  });

  it('returns json report response by default', async () => {
    const mockRes = {
      setHeader: vi.fn(),
    } as unknown as Response;

    const res = await controller.getReport(
      { type: 'members' },
      { from: '2026-09-01', to: '2026-09-21', format: 'json' },
      adminUser,
      mockRes,
    );

    expect(res).toEqual({
      type: 'members',
      from: '2026-09-01',
      to: '2026-09-21',
      rows: [
        { category: 'summary', metric: 'acquisition_new_members', count: 12 },
        { category: 'summary', metric: 'active_members', count: 50 },
      ],
    });
    expect(mockRes.setHeader).not.toHaveBeenCalled();
  });

  it('returns pipe-separated csv with Content-Type header when format=csv', async () => {
    const mockRes = {
      setHeader: vi.fn(),
    } as unknown as Response;

    const res = await controller.getReport(
      { type: 'members' },
      { from: '2026-09-01', to: '2026-09-21', format: 'csv' },
      adminUser,
      mockRes,
    );

    expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Type', 'text/csv; charset=utf-8');
    expect(mockRes.setHeader).toHaveBeenCalledWith(
      'Content-Disposition',
      'attachment; filename="report-members-2026-09-01-2026-09-21.csv"',
    );
    expect(typeof res).toBe('string');
    expect(res).toContain('category|metric|count\n');
    expect(res).toContain('summary|acquisition_new_members|12\n');
    expect(res).toContain('summary|active_members|50\n');
  });
});
