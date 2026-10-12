import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { ItemsController } from './items.controller';
import {
  itemCreateSchema,
  itemUpdateSchema,
  type ItemDto,
} from './items.dto';
import { ItemsService } from './items.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const ITEM_DTO: ItemDto = {
  id: 10,
  name: 'Personal Training Session',
  item_kind: 'service',
  inventory_tracked: false,
  income_account_id: 4000,
  expense_account_id: 5000,
  tax_code_id: 1,
  is_active: true,
};

describe('ItemsController', () => {
  let service: Partial<ItemsService>;
  let controller: ItemsController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [ITEM_DTO],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(ITEM_DTO),
      create: vi.fn().mockResolvedValue(ITEM_DTO),
      update: vi.fn().mockResolvedValue({ ...ITEM_DTO, name: 'Updated Session' }),
    };
    controller = new ItemsController(service as ItemsService);
  });

  describe('permissions and route mapping', () => {
    it('requires accounting.read on GET /accounting/items', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ItemsController.prototype.list),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.accounts_write on POST /accounting/items', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ItemsController.prototype.create),
      ).toEqual(['accounting.accounts_write']);
    });

    it('requires accounting.read on GET /accounting/items/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ItemsController.prototype.getById),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.accounts_write on PATCH /accounting/items/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ItemsController.prototype.update),
      ).toEqual(['accounting.accounts_write']);
    });
  });

  describe('controller execution', () => {
    it('delegates list call to service', async () => {
      const query = { item_kind: 'service', is_active: 'true', search: 'Training' };
      const result = await controller.list(query, ADMIN_USER);

      expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
      expect(result.data).toEqual([ITEM_DTO]);
    });

    it('delegates create call to service', async () => {
      const dto = {
        name: 'Personal Training Session',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 1,
        is_active: true,
      };
      const result = await controller.create(dto, ADMIN_USER);

      expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
      expect(result).toEqual(ITEM_DTO);
    });

    it('delegates getById call to service', async () => {
      const result = await controller.getById(10, ADMIN_USER);

      expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result).toEqual(ITEM_DTO);
    });

    it('delegates update call to service', async () => {
      const dto = { name: 'Updated Session' };
      const result = await controller.update(10, dto, ADMIN_USER);

      expect(service.update).toHaveBeenCalledWith(10, dto, ADMIN_USER);
      expect(result.name).toBe('Updated Session');
    });
  });

  describe('Zod validation pipe', () => {
    const createPipe = new ZodValidationPipe(itemCreateSchema);
    const updatePipe = new ZodValidationPipe(itemUpdateSchema);

    it('validates valid item create payload', () => {
      const payload = {
        name: 'Gym Towel',
        item_kind: 'goods',
        income_account_id: 4000,
        expense_account_id: 5000,
      };
      const result = createPipe.transform(payload);
      expect(result.name).toBe('Gym Towel');
      expect(result.item_kind).toBe('goods');
      expect(result.inventory_tracked).toBe(false);
      expect(result.is_active).toBe(true);
    });

    it('rejects create payload missing required fields', () => {
      const payload = {
        name: 'Gym Towel',
        item_kind: 'goods',
      };
      expect(() => createPipe.transform(payload)).toThrow();
    });

    it('rejects create payload with invalid item_kind', () => {
      const payload = {
        name: 'Gym Towel',
        item_kind: 'other',
        income_account_id: 4000,
        expense_account_id: 5000,
      };
      expect(() => createPipe.transform(payload)).toThrow();
    });

    it('rejects create payload with inventory_tracked: true', () => {
      const payload = {
        name: 'Gym Towel',
        item_kind: 'goods',
        income_account_id: 4000,
        expense_account_id: 5000,
        inventory_tracked: true,
      };
      expect(() => createPipe.transform(payload)).toThrow();
    });

    it('validates valid partial update payload', () => {
      const payload = {
        name: 'New Name',
        income_account_id: 4100,
      };
      const result = updatePipe.transform(payload);
      expect(result.name).toBe('New Name');
      expect(result.income_account_id).toBe(4100);
    });

    it('rejects update payload with inventory_tracked: true', () => {
      const payload = {
        inventory_tracked: true,
      };
      expect(() => updatePipe.transform(payload)).toThrow();
    });
  });
});
