import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { SessionCache } from '../auth/session.cache';
import type { SessionRepository } from '../auth/session.repository';
import type { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import type { PaginationHelper } from '../platform/http/pagination';
import { EmployeeService } from './employee.service';
import type { EmployeeRepository, EmployeeWithRole } from './employee.repository';
import type { PersonFactory } from './person.factory';

function actor(): AuthenticatedUser {
  return {
    id: 1,
    email: 'admin@example.com',
    phoneNumber: null,
    userType: 'admin',
    roleId: 1,
    profileId: null,
    sessionId: 1,
  };
}

describe('EmployeeService.setStatus', () => {
  let service: EmployeeService;
  let repository: {
    findByIdWithRole: ReturnType<typeof vi.fn>;
    updateStatus: ReturnType<typeof vi.fn>;
    getDb: ReturnType<typeof vi.fn>;
  };
  let sessionRepository: { revokeAllForUser: ReturnType<typeof vi.fn> };
  let sessionCache: { dropByUser: ReturnType<typeof vi.fn> };
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let usersUpdate: ReturnType<typeof vi.fn>;

  const before: EmployeeWithRole = {
    id: 7,
    user_id: 70,
    first_name: 'Desk',
    last_name: 'Staff',
    job_title: 'Front desk',
    department: 'ops',
    hire_date: '2026-01-01',
    status: 'active',
    created_at: new Date(),
    updated_at: null,
    role_id: 4,
  };

  beforeEach(() => {
    usersUpdate = vi.fn().mockReturnValue({
      set: vi.fn().mockReturnValue({
        where: vi.fn().mockResolvedValue(undefined),
      }),
    });

    repository = {
      findByIdWithRole: vi
        .fn()
        .mockResolvedValueOnce(before)
        .mockResolvedValueOnce({ ...before, status: 'terminated' }),
      updateStatus: vi.fn().mockResolvedValue(undefined),
      getDb: vi.fn().mockReturnValue({
        update: usersUpdate,
      }),
    };
    sessionRepository = { revokeAllForUser: vi.fn().mockResolvedValue(undefined) };
    sessionCache = { dropByUser: vi.fn() };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };

    service = new EmployeeService(
      repository as unknown as EmployeeRepository,
      {} as PersonFactory,
      {} as PaginationHelper,
      auditService as unknown as AuditService,
      sessionRepository as unknown as SessionRepository,
      sessionCache as unknown as SessionCache,
      {
        transaction: vi.fn(async (fn: (tx: unknown) => Promise<unknown>) => fn({})),
      } as unknown as DrizzleDb<any>,
    );
  });

  it('terminate marks user non-authable and revokes sessions', async () => {
    const result = await service.setStatus(7, { status: 'terminated' }, actor());

    expect(repository.updateStatus).toHaveBeenCalledWith(7, 'terminated');
    expect(usersUpdate).toHaveBeenCalled();
    expect(sessionRepository.revokeAllForUser).toHaveBeenCalledWith(70, expect.any(Date));
    expect(sessionCache.dropByUser).toHaveBeenCalledWith(70);
    expect(result.status).toBe('terminated');
    expect(auditService.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: 'employee.status_changed',
        afterState: expect.objectContaining({ auth_blocked: true }),
      }),
    );
  });

  it('suspend marks user non-authable and revokes sessions', async () => {
    repository.findByIdWithRole
      .mockReset()
      .mockResolvedValueOnce(before)
      .mockResolvedValueOnce({ ...before, status: 'suspended' });

    await service.setStatus(7, { status: 'suspended' }, actor());

    expect(sessionRepository.revokeAllForUser).toHaveBeenCalledWith(70, expect.any(Date));
    expect(sessionCache.dropByUser).toHaveBeenCalledWith(70);
  });

  it('active status does not revoke sessions', async () => {
    repository.findByIdWithRole
      .mockReset()
      .mockResolvedValueOnce({ ...before, status: 'on_probation' })
      .mockResolvedValueOnce({ ...before, status: 'active' });

    await service.setStatus(7, { status: 'active' }, actor());

    expect(sessionRepository.revokeAllForUser).not.toHaveBeenCalled();
    expect(sessionCache.dropByUser).not.toHaveBeenCalled();
  });
});
