import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { VendorsRepository } from './vendors.repository';
import { VendorsService } from './vendors.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const VENDOR_ROW = {
  id: 10,
  name: 'Acme Fitness Equipments',
  phone: '9876543210',
  email: 'vendor@acme.test',
  gstin: '29ABCDE1234F1Z5',
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: new Date('2026-04-01T00:00:00.000Z'),
};

describe('VendorsService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: VendorsService;

  beforeEach(() => {
    repository = {
      findMany: vi.fn().mockResolvedValue({ rows: [VENDOR_ROW], total: 1 }),
      findById: vi.fn().mockResolvedValue(VENDOR_ROW),
      insertVendor: vi.fn().mockResolvedValue(VENDOR_ROW),
      updateVendor: vi.fn().mockResolvedValue(VENDOR_ROW),
      assertActiveVendor: vi.fn().mockResolvedValue(VENDOR_ROW),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };
    service = new VendorsService(
      repository as unknown as VendorsRepository,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('list', () => {
    it('returns paginated vendor records with search and is_active filters', async () => {
      const result = await service.list(
        { search: 'Acme', is_active: 'true', limit: 20, offset: 0 },
        ADMIN_USER,
      );

      expect(paginationHelper.normalizeParams).toHaveBeenCalledWith({
        search: 'Acme',
        is_active: 'true',
        limit: 20,
        offset: 0,
      });
      expect(repository.findMany).toHaveBeenCalledWith({
        search: 'Acme',
        isActive: true,
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0]).toMatchObject({
        id: 10,
        name: 'Acme Fitness Equipments',
        phone: '9876543210',
        email: 'vendor@acme.test',
        gstin: '29ABCDE1234F1Z5',
        is_active: true,
      });
      expect(result.meta.total).toBe(1);
    });

    it('works without filter parameters', async () => {
      const result = await service.list({}, ADMIN_USER);

      expect(repository.findMany).toHaveBeenCalledWith({
        search: undefined,
        isActive: undefined,
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
    });
  });

  describe('getById', () => {
    it('returns vendor when found', async () => {
      const result = await service.getById(10, ADMIN_USER);

      expect(repository.findById).toHaveBeenCalledWith(10);
      expect(result.id).toBe(10);
      expect(result.name).toBe('Acme Fitness Equipments');
    });

    it('throws NotFoundError when vendor does not exist', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.getById(999, ADMIN_USER)).rejects.toThrow(NotFoundError);
      await expect(service.getById(999, ADMIN_USER)).rejects.toThrow('Vendor 999 was not found');
    });
  });

  describe('create', () => {
    it('creates vendor with provided details', async () => {
      const dto = {
        name: 'Acme Fitness Equipments',
        phone: '9876543210',
        email: 'vendor@acme.test',
        gstin: '29ABCDE1234F1Z5',
        is_active: true,
      };

      const result = await service.create(dto, ADMIN_USER);

      expect(repository.insertVendor).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'Acme Fitness Equipments',
          phone: '9876543210',
          email: 'vendor@acme.test',
          gstin: '29ABCDE1234F1Z5',
          is_active: true,
        }),
      );
      expect(result.id).toBe(10);
    });

    it('handles nullable optional fields gracefully', async () => {
      const dto = {
        name: 'Minimal Vendor',
        is_active: true,
      };
      repository.insertVendor.mockResolvedValue({
        ...VENDOR_ROW,
        name: 'Minimal Vendor',
        phone: null,
        email: null,
        gstin: null,
      });

      const result = await service.create(dto, ADMIN_USER);

      expect(repository.insertVendor).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'Minimal Vendor',
          phone: null,
          email: null,
          gstin: null,
          is_active: true,
        }),
      );
      expect(result.phone).toBeNull();
      expect(result.email).toBeNull();
      expect(result.gstin).toBeNull();
    });
  });

  describe('update', () => {
    it('updates vendor when vendor exists', async () => {
      const dto = {
        name: 'Updated Acme',
        phone: '1234567890',
      };
      repository.updateVendor.mockResolvedValue({
        ...VENDOR_ROW,
        name: 'Updated Acme',
        phone: '1234567890',
      });

      const result = await service.update(10, dto, ADMIN_USER);

      expect(repository.findById).toHaveBeenCalledWith(10);
      expect(repository.updateVendor).toHaveBeenCalledWith(
        10,
        expect.objectContaining({
          name: 'Updated Acme',
          phone: '1234567890',
        }),
      );
      expect(result.name).toBe('Updated Acme');
    });

    it('throws NotFoundError if vendor does not exist on update', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.update(999, { name: 'New Name' }, ADMIN_USER)).rejects.toThrow(
        NotFoundError,
      );
    });
  });

  describe('assertActiveVendor', () => {
    it('returns vendor when vendor is active', async () => {
      repository.assertActiveVendor.mockResolvedValue(VENDOR_ROW);

      const result = await service.assertActiveVendor(10);

      expect(repository.assertActiveVendor).toHaveBeenCalledWith(10);
      expect(result.id).toBe(10);
      expect(result.is_active).toBe(true);
    });

    it('throws NotFoundError when vendor does not exist', async () => {
      repository.assertActiveVendor.mockRejectedValue(
        new NotFoundError('Vendor 999 was not found'),
      );

      await expect(service.assertActiveVendor(999)).rejects.toThrow(NotFoundError);
    });

    it('throws BusinessRuleError when vendor is inactive', async () => {
      repository.assertActiveVendor.mockRejectedValue(
        new BusinessRuleError('Vendor is inactive'),
      );

      await expect(service.assertActiveVendor(10)).rejects.toThrow(BusinessRuleError);
      await expect(service.assertActiveVendor(10)).rejects.toThrow('Vendor is inactive');
    });
  });
});
