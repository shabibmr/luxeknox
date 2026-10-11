import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MembershipProductService } from './membership-product.service';
import type { MembershipProductRepository } from './membership-product.repository';
import { PaginationHelper } from '../platform/http/pagination';
import type { AuditService } from '../platform/audit/audit.service';
import type { PermissionCache } from '../rbac/permission-cache';
import { BadRequestError, ConflictError, NotFoundError } from '../platform/errors/app-error';
import type { MembershipProduct } from '../platform/db/schema/memberships';
import type { AuthenticatedUser } from '../auth/auth.guard';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const MEMBER_USER: AuthenticatedUser = {
  id: 10,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 5,
  profileId: 1,
  sessionId: 2,
};

function makeProduct(overrides: Partial<MembershipProduct> = {}): MembershipProduct {
  return {
    id: 1,
    name: 'Gold Plan',
    code: 'GOLD',
    description: null,
    duration_days: 30,
    base_price: '1299.00',
    tax_percentage: '5.00',
    max_freeze_days: 15,
    pt_sessions_included: 4,
    access_facilities: ['pool', 'sauna'],
    is_active: true,
    package_type: 'single',
    created_at: new Date('2026-09-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

describe('MembershipProductService', () => {
  let repository: Partial<MembershipProductRepository>;
  let paginationHelper: PaginationHelper;
  let auditService: Partial<AuditService>;
  let permissionCache: Partial<PermissionCache>;
  let service: MembershipProductService;

  beforeEach(() => {
    repository = {
      findManyFiltered: vi.fn(),
      findById: vi.fn(),
      findByCode: vi.fn(),
      insertProduct: vi.fn(),
      updateProduct: vi.fn(),
    };
    paginationHelper = new PaginationHelper({
      getDefaultPageSize: vi.fn().mockResolvedValue(20),
    } as any);
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    permissionCache = { hasPermission: vi.fn().mockResolvedValue(false) };

    service = new MembershipProductService(
      repository as MembershipProductRepository,
      paginationHelper,
      auditService as AuditService,
      permissionCache as PermissionCache,
    );
  });

  describe('create', () => {
    it('rejects a duplicate code with 409', async () => {
      vi.mocked(repository.findByCode!).mockResolvedValue(makeProduct());

      await expect(
        service.create(
          {
            name: 'Gold Plan',
            code: 'GOLD',
            duration_days: 30,
            base_price: '1299.00',
            package_type: 'single',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow(ConflictError);
      expect(repository.insertProduct).not.toHaveBeenCalled();
    });

    it('normalizes money via roundMoney and defaults optional fields', async () => {
      vi.mocked(repository.findByCode!).mockResolvedValue(null);
      vi.mocked(repository.insertProduct!).mockResolvedValue(1);
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct());

      await service.create(
        {
          name: 'Gold Plan',
          code: 'GOLD',
          duration_days: 30,
          base_price: '1299.00',
          package_type: 'single',
        },
        ADMIN_USER,
      );

      expect(repository.insertProduct).toHaveBeenCalledWith(
        expect.objectContaining({
          base_price: '1299.00',
          tax_percentage: '0.00',
          max_freeze_days: 0,
          is_active: true,
          package_type: 'single',
        }),
      );
    });

    it('creates a single package with package_type "single"', async () => {
      vi.mocked(repository.findByCode!).mockResolvedValue(null);
      vi.mocked(repository.insertProduct!).mockResolvedValue(1);
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct({ package_type: 'single' }));

      const result = await service.create(
        {
          name: 'Gold Plan',
          code: 'GOLD',
          duration_days: 30,
          base_price: '1299.00',
          package_type: 'single',
        },
        ADMIN_USER,
      );

      expect(repository.insertProduct).toHaveBeenCalledWith(
        expect.objectContaining({ package_type: 'single' }),
      );
      expect(result.package_type).toBe('single');
    });

    it('creates a couple package with package_type "couple"', async () => {
      vi.mocked(repository.findByCode!).mockResolvedValue(null);
      vi.mocked(repository.insertProduct!).mockResolvedValue(2);
      vi.mocked(repository.findById!).mockResolvedValue(
        makeProduct({ id: 2, code: 'CPL-M', package_type: 'couple' }),
      );

      const result = await service.create(
        {
          name: 'Couple Monthly',
          code: 'CPL-M',
          duration_days: 30,
          base_price: '1999.00',
          package_type: 'couple',
        },
        ADMIN_USER,
      );

      expect(repository.insertProduct).toHaveBeenCalledWith(
        expect.objectContaining({ package_type: 'couple' }),
      );
      expect(result.package_type).toBe('couple');
    });
  });

  describe('getById', () => {
    it('404s an inactive product for a caller without memberships.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(false);
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct({ is_active: false }));

      await expect(service.getById(1, MEMBER_USER)).rejects.toThrow(NotFoundError);
    });

    it('returns an inactive product for a caller with memberships.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct({ is_active: false }));

      const result = await service.getById(1, ADMIN_USER);
      expect(result.is_active).toBe(false);
    });
  });

  describe('update', () => {
    it('rejects renaming to a code already used by another product', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct());
      vi.mocked(repository.findByCode!).mockResolvedValue(makeProduct({ id: 2, code: 'SILVER' }));

      await expect(service.update(1, { code: 'SILVER' }, ADMIN_USER)).rejects.toThrow(ConflictError);
    });

    it('rejects changing package_type', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct({ package_type: 'single' }));

      await expect(
        service.update(1, { package_type: 'couple' }, ADMIN_USER),
      ).rejects.toThrow(BadRequestError);
      expect(repository.updateProduct).not.toHaveBeenCalled();
    });
  });

  describe('list', () => {
    it('passes the package_type filter through to the repository', async () => {
      vi.mocked(repository.findManyFiltered!).mockResolvedValue({ rows: [], total: 0 });

      await service.list({ package_type: 'couple' }, ADMIN_USER);

      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({ packageType: 'couple' }),
      );
    });
  });
});
