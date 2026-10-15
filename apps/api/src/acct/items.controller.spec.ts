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
  sku: null,
  hsn_sac: null,
  item_kind: 'service',
  category_id: null,
  uom_id: 1,
  inventory_tracked: false,
  sale_rate: null,
  purchase_rate: null,
  reorder_level: null,
  income_account_id: 4000,
  expense_account_id: 5000,
  inventory_account_id: null,
  cogs_account_id: null,
  tax_code_id: 1,
  is_active: true,
  row_version: 1,
  created_at: '2026-10-16T00:00:00.000Z',
  updated_at: null,
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
        uom_id: 1,
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
        uom_id: 1,
        income_account_id: 4000,
        expense_account_id: 5000,
        sale_rate: '10.5',
        reorder_level: 1,
      };
      const result = createPipe.transform(payload);
      expect(result.name).toBe('Gym Towel');
      expect(result.item_kind).toBe('goods');
      expect(result.uom_id).toBe(1);
      expect(result.sale_rate).toBe('10.50');
      expect(result.reorder_level).toBe('1.000');
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

    it('accepts a tracked goods payload', () => {
      const payload = {
        name: 'Gym Towel',
        item_kind: 'goods',
        uom_id: 1,
        income_account_id: 4000,
        expense_account_id: 5000,
        inventory_tracked: true,
      };
      const result = createPipe.transform(payload);
      expect(result.inventory_tracked).toBe(true);
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

    it('accepts an update that turns tracking on', () => {
      const result = updatePipe.transform({ inventory_tracked: true, reorder_level: '0.5' });
      expect(result.inventory_tracked).toBe(true);
      expect(result.reorder_level).toBe('0.500');
    });
  });
});
