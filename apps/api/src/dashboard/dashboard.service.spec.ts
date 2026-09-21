import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DashboardService } from './dashboard.service';
import { PermissionCache } from '../rbac/permission-cache';
import { PersonFactory } from '../people/person.factory';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import { EmployeeRepository } from '../people/employee.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { DashboardCache } from './dashboard-cache';
import type { AuthenticatedUser } from '../auth/auth.guard';

function makeUser(overrides: Partial<AuthenticatedUser> = {}): AuthenticatedUser {
  return {
    id: 1,
    email: 'user@luxeknox.test',
    phoneNumber: null,
    userType: 'member',
    roleId: 5,
    profileId: null,
    sessionId: 1,
    ...overrides,
  };
}

function delay<T>(value: T, ms = 0): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms));
}

describe('DashboardService', () => {
  let permissionCache: Partial<PermissionCache>;
  let personFactory: Partial<PersonFactory>;
  let memberRepository: Partial<MemberRepository>;
  let trainerRepository: Partial<TrainerRepository>;
  let employeeRepository: Partial<EmployeeRepository>;
  let membershipRepository: Partial<MembershipRepository>;
  let cache: DashboardCache;
  let service: DashboardService;

  beforeEach(() => {
    permissionCache = { hasPermission: vi.fn().mockResolvedValue(false) };
    personFactory = { resolveProfileId: vi.fn().mockResolvedValue(null) };
    memberRepository = {
      countAll: vi.fn().mockResolvedValue(0),
      findById: vi.fn().mockResolvedValue(null),
      findManyFiltered: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    };
    trainerRepository = {
      countTotal: vi.fn().mockResolvedValue(0),
      countActive: vi.fn().mockResolvedValue(0),
      countAssignedMembers: vi.fn().mockResolvedValue(0),
      findById: vi.fn().mockResolvedValue(null),
    };
    employeeRepository = {
      countTotal: vi.fn().mockResolvedValue(0),
      countActive: vi.fn().mockResolvedValue(0),
    };
    membershipRepository = {
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue(null),
      countByStatus: vi.fn().mockResolvedValue({}),
      countExpiringSoon: vi.fn().mockResolvedValue(0),
    };
    cache = new DashboardCache();

    service = new DashboardService(
      permissionCache as PermissionCache,
      personFactory as PersonFactory,
      memberRepository as MemberRepository,
      trainerRepository as TrainerRepository,
      employeeRepository as EmployeeRepository,
      membershipRepository as MembershipRepository,
      cache,
    );
  });

  describe('DSH-002 member widget', () => {
    it('includes membership status/days-remaining and assigned trainer when permitted', async () => {
      const user = makeUser({ userType: 'member', profileId: 42, roleId: 9 });
      vi.mocked(permissionCache.hasPermission!).mockImplementation(
        async (_roleId, slug) => slug === 'dashboard.member',
      );
      vi.mocked(membershipRepository.findActiveOrFrozenForMember!).mockResolvedValue({
        id: 1,
        status: 'active',
        end_date: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10),
      } as any);
      vi.mocked(memberRepository.findById!).mockResolvedValue({
        id: 42,
        assigned_trainer_id: 7,
      } as any);
      vi.mocked(trainerRepository.findById!).mockResolvedValue({
        id: 7,
        first_name: 'Jamie',
        last_name: 'Fox',
      } as any);

      const result = await service.getDashboard(user);

      expect(result.role).toBe('member');
      expect(result.member?.membership?.status).toBe('active');
      expect(result.member?.membership?.days_remaining).toBeGreaterThanOrEqual(4);
      expect(result.member?.assigned_trainer).toEqual({ id: 7, name: 'Jamie Fox' });
      expect(result.trainer).toBeUndefined();
      expect(result.admin).toBeUndefined();
    });

    it('omits the member section without the dashboard.member permission', async () => {
      const user = makeUser({ userType: 'member', profileId: 42 });
      const result = await service.getDashboard(user);
      expect(result.member).toBeUndefined();
    });
  });

  describe('DSH-003 trainer widget', () => {
    it('includes assigned member count and a preview list', async () => {
      const user = makeUser({ userType: 'trainer', profileId: 3, roleId: 4 });
      vi.mocked(permissionCache.hasPermission!).mockImplementation(
        async (_roleId, slug) => slug === 'dashboard.trainer',
      );
      vi.mocked(trainerRepository.countAssignedMembers!).mockResolvedValue(12);
      vi.mocked(memberRepository.findManyFiltered!).mockResolvedValue({
        rows: [{ id: 1, first_name: 'Ana', last_name: 'Lee', membership_number: 'M00000001' } as any],
        total: 12,
      });

      const result = await service.getDashboard(user);

      expect(result.trainer?.assigned_members_count).toBe(12);
      expect(result.trainer?.assigned_members).toEqual([
        { id: 1, name: 'Ana Lee', membership_number: 'M00000001' },
      ]);
    });
  });

  describe('DSH-004 admin widget', () => {
    it('composes member/trainer/employee/membership aggregates', async () => {
      const user = makeUser({ userType: 'admin', profileId: null, roleId: 2 });
      vi.mocked(permissionCache.hasPermission!).mockImplementation(
        async (_roleId, slug) => slug === 'dashboard.admin',
      );
      vi.mocked(memberRepository.countAll!).mockResolvedValue(100);
      vi.mocked(trainerRepository.countTotal!).mockResolvedValue(10);
      vi.mocked(trainerRepository.countActive!).mockResolvedValue(8);
      vi.mocked(employeeRepository.countTotal!).mockResolvedValue(5);
      vi.mocked(employeeRepository.countActive!).mockResolvedValue(5);
      vi.mocked(membershipRepository.countByStatus!).mockResolvedValue({ active: 90, frozen: 5 });
      vi.mocked(membershipRepository.countExpiringSoon!).mockResolvedValue(7);

      const result = await service.getDashboard(user);

      expect(result.admin).toEqual({
        members_total: 100,
        trainers_total: 10,
        trainers_active: 8,
        employees_total: 5,
        employees_active: 5,
        memberships_by_status: { active: 90, frozen: 5 },
        memberships_expiring_soon: { days: 7, count: 7 },
      });
    });
  });

  describe('DSH-005 partial-failure isolation', () => {
    it('omits a section that throws instead of failing the whole response', async () => {
      const user = makeUser({ userType: 'admin', roleId: 2 });
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(membershipRepository.countByStatus!).mockRejectedValue(new Error('db down'));

      const result = await service.getDashboard(user);

      expect(result.admin).toBeUndefined();
    });
  });

  describe('DSH-006 caching', () => {
    it('serves the admin summary from cache on a second call within TTL', async () => {
      const user = makeUser({ userType: 'admin', roleId: 2 });
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);

      await service.getDashboard(user);
      await service.getDashboard(user);

      expect(memberRepository.countAll).toHaveBeenCalledTimes(1);
      expect(membershipRepository.countByStatus).toHaveBeenCalledTimes(1);
    });
  });

  describe('DSH-008 composition latency', () => {
    it('runs independent widget queries in parallel rather than serially', async () => {
      const user = makeUser({ userType: 'admin', roleId: 2 });
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      const QUERY_DELAY_MS = 20;
      vi.mocked(memberRepository.countAll!).mockImplementation(() => delay(0, QUERY_DELAY_MS));
      vi.mocked(trainerRepository.countTotal!).mockImplementation(() => delay(0, QUERY_DELAY_MS));
      vi.mocked(trainerRepository.countActive!).mockImplementation(() => delay(0, QUERY_DELAY_MS));
      vi.mocked(employeeRepository.countTotal!).mockImplementation(() => delay(0, QUERY_DELAY_MS));
      vi.mocked(employeeRepository.countActive!).mockImplementation(() => delay(0, QUERY_DELAY_MS));
      vi.mocked(membershipRepository.countByStatus!).mockImplementation(() => delay({}, QUERY_DELAY_MS));
      vi.mocked(membershipRepository.countExpiringSoon!).mockImplementation(() => delay(0, QUERY_DELAY_MS));

      const start = Date.now();
      await service.getDashboard(user);
      const elapsed = Date.now() - start;

      // 7 independent queries serially would take >= 140ms; in parallel it stays near one delay.
      expect(elapsed).toBeLessThan(QUERY_DELAY_MS * 3);
    });
  });
});
