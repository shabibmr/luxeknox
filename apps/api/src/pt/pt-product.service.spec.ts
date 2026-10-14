import { describe, it, expect, vi, beforeEach } from 'vitest';
import { PtProductService } from './pt-product.service';
import type { PtProductRepository } from './pt-product.repository';
import { PaginationHelper } from '../platform/http/pagination';
import type { AuditService } from '../platform/audit/audit.service';
import type { PermissionCache } from '../rbac/permission-cache';
import { BadRequestError, ConflictError } from '../platform/errors/app-error';
import type { PtProduct } from '../platform/db/schema/personal-training';
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

function makeProduct(overrides: Partial<PtProduct> = {}): PtProduct {
  return {
    id: 1,
    name: 'Personal Training - 1 Month',
    code: 'PT-1M',
    description: null,
    duration_days: 30,
    base_price: '3999.00',
    tax_percentage: '0.00',
    income_account_id: null,
    package_type: 'single',
    is_active: true,
    created_at: new Date('2026-09-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

describe('PtProductService', () => {
  let repository: Partial<PtProductRepository>;
  let paginationHelper: PaginationHelper;
  let auditService: Partial<AuditService>;
  let permissionCache: Partial<PermissionCache>;
  let service: PtProductService;

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

    service = new PtProductService(
      repository as PtProductRepository,
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
            name: 'Personal Training - 1 Month',
            code: 'PT-1M',
            duration_days: 30,
            base_price: '3999.00',
            package_type: 'single',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow(ConflictError);
      expect(repository.insertProduct).not.toHaveBeenCalled();
    });

    it('creates a single package with package_type "single"', async () => {
      vi.mocked(repository.findByCode!).mockResolvedValue(null);
      vi.mocked(repository.insertProduct!).mockResolvedValue(1);
      vi.mocked(repository.findById!).mockResolvedValue(makeProduct({ package_type: 'single' }));

      const result = await service.create(
        {
          name: 'Personal Training - 1 Month',
          code: 'PT-1M',
          duration_days: 30,
          base_price: '3999.00',
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
        makeProduct({ id: 2, code: 'CPT-1M', package_type: 'couple' }),
      );

      const result = await service.create(
        {
          name: 'Couple PT 1 Month',
          code: 'CPT-1M',
          duration_days: 30,
          base_price: '6999.00',
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

  describe('update', () => {
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
