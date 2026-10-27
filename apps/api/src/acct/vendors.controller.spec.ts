import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { VendorsController } from './vendors.controller';
import {
  vendorUpdateSchema,
  vendorWriteSchema,
  type VendorDto,
} from './vendors.dto';
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

const VENDOR_DTO: VendorDto = {
  id: 10,
  name: 'Acme Fitness Equipments',
  phone: '9876543210',
  email: 'vendor@acme.test',
  gstin: '29ABCDE1234F1Z5',
  is_active: true,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: new Date('2026-04-01T00:00:00.000Z'),
};

describe('VendorsController', () => {
  let service: Partial<VendorsService>;
  let controller: VendorsController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [VENDOR_DTO],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(VENDOR_DTO),
      create: vi.fn().mockResolvedValue(VENDOR_DTO),
      update: vi.fn().mockResolvedValue({ ...VENDOR_DTO, name: 'Updated Acme' }),
      assertActiveVendor: vi.fn().mockResolvedValue(VENDOR_DTO),
    };
    controller = new VendorsController(service as VendorsService);
  });

  describe('permissions and route mapping', () => {
    it('requires accounting.read on GET /accounting/vendors', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, VendorsController.prototype.list),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.vendors_write on POST /accounting/vendors', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, VendorsController.prototype.create),
      ).toEqual(['accounting.vendors_write']);
    });

    it('requires accounting.read on GET /accounting/vendors/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, VendorsController.prototype.getById),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.vendors_write on PATCH /accounting/vendors/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, VendorsController.prototype.update),
      ).toEqual(['accounting.vendors_write']);
    });
  });

  describe('controller execution', () => {
    it('delegates list call to service', async () => {
      const query = { search: 'Acme', is_active: 'true' };
      const result = await controller.list(query, ADMIN_USER);

      expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
      expect(result.data).toEqual([VENDOR_DTO]);
    });

    it('delegates create call to service', async () => {
      const dto = {
        name: 'Acme Fitness Equipments',
        phone: '9876543210',
        email: 'vendor@acme.test',
        gstin: '29ABCDE1234F1Z5',
        is_active: true,
      };
      const result = await controller.create(dto, ADMIN_USER);

      expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
      expect(result).toEqual(VENDOR_DTO);
    });

    it('delegates getById call to service', async () => {
      const result = await controller.getById(10, ADMIN_USER);

      expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result).toEqual(VENDOR_DTO);
    });

    it('delegates update call to service', async () => {
      const dto = { name: 'Updated Acme' };
      const result = await controller.update(10, dto, ADMIN_USER);

      expect(service.update).toHaveBeenCalledWith(10, dto, ADMIN_USER);
      expect(result.name).toBe('Updated Acme');
    });
  });

  describe('Zod validation pipe', () => {
    const writePipe = new ZodValidationPipe(vendorWriteSchema);
    const updatePipe = new ZodValidationPipe(vendorUpdateSchema);

    it('validates valid vendor write payload', () => {
      const payload = {
        name: 'Acme Fitness',
        phone: '9876543210',
        email: 'acme@test.com',
        gstin: '29ABCDE1234F1Z5',
      };
      const result = writePipe.transform(payload, {} as any);
      expect(result.name).toBe('Acme Fitness');
      expect(result.is_active).toBe(true);
    });

    it('rejects vendor write without name', () => {
      const payload = {
        phone: '9876543210',
      };
      expect(() => writePipe.transform(payload, {} as any)).toThrow();
    });

    it('rejects vendor write with invalid email', () => {
      const payload = {
        name: 'Acme Fitness',
        email: 'not-an-email',
      };
      expect(() => writePipe.transform(payload, {} as any)).toThrow();
    });

    it('validates partial vendor update payload', () => {
      const payload = {
        name: 'New Name',
        is_active: false,
      };
      const result = updatePipe.transform(payload, {} as any);
      expect(result.name).toBe('New Name');
      expect(result.is_active).toBe(false);
    });
  });
});
