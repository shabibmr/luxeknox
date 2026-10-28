import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { InventoryItemsController } from './items.controller';
import type { InventoryItemDto } from './items.dto';
import type { InventoryItemsService } from './items.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const ITEM: InventoryItemDto = {
  id: 10,
  name: 'Whey Protein',
  sku: 'WHEY-1',
  hsn_sac: null,
  item_kind: 'goods',
  category_id: 4,
  category_name: 'Supplements',
  uom_id: 1,
  uom_code: 'PCS',
  uom_decimal_places: 0,
  sale_rate: '1499.00',
  purchase_rate: null,
  tax_code_id: null,
  tax_rate_percent: null,
  income_account_id: 4250,
  expense_account_id: 5000,
  inventory_account_id: null,
  cogs_account_id: null,
  inventory_tracked: false,
  qty_on_hand: null,
  reorder_level: null,
  has_movements: false,
  is_active: true,
  row_version: 1,
  created_at: '2026-10-16T00:00:00.000Z',
  updated_at: null,
};

describe('InventoryItemsController', () => {
  let service: { list: ReturnType<typeof vi.fn>; getById: ReturnType<typeof vi.fn> };
  let controller: InventoryItemsController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [ITEM],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(ITEM),
    };
    controller = new InventoryItemsController(service as unknown as InventoryItemsService);
  });

  it('requires inventory.read on list and get', () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, InventoryItemsController.prototype.list),
    ).toEqual(['inventory.read']);
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, InventoryItemsController.prototype.getById),
    ).toEqual(['inventory.read']);
  });

  it('delegates list and get to the service', async () => {
    const query = { search: 'WHEY' };
    await controller.list(query, ADMIN_USER);
    await controller.getById(10, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
  });
});
