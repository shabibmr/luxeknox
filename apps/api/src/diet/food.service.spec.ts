import { describe, it, expect, vi, beforeEach } from 'vitest';
import { FoodService } from './food.service';
import { FoodRepository } from './food.repository';
import { PaginationHelper } from '../platform/http/pagination';
import { AuditService } from '../platform/audit/audit.service';
import { PermissionCache } from '../rbac/permission-cache';
import { NotFoundError } from '../platform/errors/app-error';
import type { Food } from '../platform/db/schema/foods';
import type { AuthenticatedUser } from '../auth/auth.guard';

const MEMBER_USER: AuthenticatedUser = {
  id: 10,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 5,
  profileId: null,
  sessionId: 1,
};

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 2,
};

function makeFood(overrides: Partial<Food> = {}): Food {
  return {
    id: 1,
    name: 'Chicken Breast',
    serving_unit: 'g',
    serving_size: 100,
    calories: 165,
    protein_grams: 31,
    carbs_grams: 0,
    fat_grams: 3.6,
    fiber_grams: 0,
    is_verified: true,
    is_active: true,
    created_at: new Date('2026-09-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

describe('FoodService', () => {
  let repository: Partial<FoodRepository>;
  let paginationHelper: PaginationHelper;
  let auditService: Partial<AuditService>;
  let permissionCache: Partial<PermissionCache>;
  let service: FoodService;

  beforeEach(() => {
    repository = {
      findManyFiltered: vi.fn(),
      findById: vi.fn(),
      insertFood: vi.fn(),
      updateFood: vi.fn(),
    };
    paginationHelper = new PaginationHelper({
      getDefaultPageSize: vi.fn().mockResolvedValue(20),
    } as any);
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    permissionCache = { hasPermission: vi.fn().mockResolvedValue(false) };

    service = new FoodService(
      repository as FoodRepository,
      paginationHelper,
      auditService as AuditService,
      permissionCache as PermissionCache,
    );
  });

  describe('list', () => {
    it('forces is_active and is_verified for callers without diet.update', async () => {
      vi.mocked(repository.findManyFiltered!).mockResolvedValue({
        rows: [makeFood()],
        total: 1,
      });

      const result = await service.list(
        { q: 'chicken', is_active: 'false', is_verified: 'false', limit: '10', offset: '0' },
        MEMBER_USER,
      );

      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          q: 'chicken',
          isActive: true,
          isVerified: true,
          limit: 10,
          offset: 0,
        }),
      );
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });

    it('passes optional filters when the caller holds diet.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(repository.findManyFiltered!).mockResolvedValue({ rows: [], total: 0 });

      await service.list({ is_active: 'false', is_verified: 'true' }, ADMIN_USER);

      expect(permissionCache.hasPermission).toHaveBeenCalledWith(ADMIN_USER.roleId, 'diet.update');
      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          isActive: false,
          isVerified: true,
        }),
      );
    });
  });

  describe('getById', () => {
    it('throws NotFoundError when the repository returns null', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(null);

      await expect(service.getById(999, MEMBER_USER)).rejects.toThrow(NotFoundError);
    });

    it('404s inactive or unverified foods for non-updaters', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(
        makeFood({ is_active: true, is_verified: false }),
      );

      await expect(service.getById(1, MEMBER_USER)).rejects.toThrow(NotFoundError);
    });

    it('returns inactive foods for callers with diet.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(repository.findById!).mockResolvedValue(makeFood({ is_active: false }));

      const result = await service.getById(1, ADMIN_USER);

      expect(result.is_active).toBe(false);
    });
  });

  describe('create', () => {
    it('inserts, then records exactly one audit row', async () => {
      vi.mocked(repository.insertFood!).mockResolvedValue(42);
      vi.mocked(repository.findById!).mockResolvedValue(makeFood({ id: 42 }));

      const result = await service.create(
        { name: 'Oats', serving_unit: 'g' },
        ADMIN_USER,
      );

      expect(result.id).toBe(42);
      expect(auditService.recordAudit).toHaveBeenCalledTimes(1);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          actorUserId: ADMIN_USER.id,
          action: 'food.created',
          entityName: 'foods',
          entityId: 42,
        }),
      );
    });
  });

  describe('update', () => {
    it('throws NotFoundError when the food does not exist', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(null);

      await expect(service.update(1, { name: 'X' }, ADMIN_USER)).rejects.toThrow(NotFoundError);
      expect(repository.updateFood).not.toHaveBeenCalled();
    });

    it('only writes fields present in the DTO', async () => {
      vi.mocked(repository.findById!)
        .mockResolvedValueOnce(makeFood())
        .mockResolvedValueOnce(makeFood({ is_active: false }));

      await service.update(1, { is_active: false }, ADMIN_USER);

      expect(repository.updateFood).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ is_active: false, updated_at: expect.any(Date) }),
      );
      const values = vi.mocked(repository.updateFood!).mock.calls[0][1];
      expect(values).not.toHaveProperty('name');
      expect(values).not.toHaveProperty('calories');
    });

    it('writes exactly one audit row with before/after state', async () => {
      const before = makeFood();
      const after = makeFood({ is_active: false });
      vi.mocked(repository.findById!).mockResolvedValueOnce(before).mockResolvedValueOnce(after);

      await service.update(1, { is_active: false }, ADMIN_USER);

      expect(auditService.recordAudit).toHaveBeenCalledTimes(1);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'food.updated',
          entityName: 'foods',
          entityId: 1,
          beforeState: before,
          afterState: after,
        }),
      );
    });
  });
});
