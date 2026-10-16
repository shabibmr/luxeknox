import { describe, expect, it, vi } from 'vitest';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { InventoryCatalogController } from './catalog.controller';
import type { InventoryCatalogService } from './catalog.service';

describe('InventoryCatalogController', () => {
  const page = { data: [], meta: {} };
  const service = {
    listUoms: vi.fn().mockResolvedValue(page),
    listCategories: vi.fn().mockResolvedValue(page),
  };
  const controller = new InventoryCatalogController(service as unknown as InventoryCatalogService);

  it('requires inventory.read on both lists', () => {
    for (const handler of [
      InventoryCatalogController.prototype.listUoms,
      InventoryCatalogController.prototype.listCategories,
    ]) {
      expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, handler)).toEqual(['inventory.read']);
    }
  });

  it('delegates to the service with the raw query', async () => {
    const query = { is_active: 'true' };
    await controller.listUoms(query);
    await controller.listCategories(query);
    expect(service.listUoms).toHaveBeenCalledWith(query);
    expect(service.listCategories).toHaveBeenCalledWith(query);
  });
});
