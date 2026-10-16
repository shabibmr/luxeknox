import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { PaginationHelper } from '../platform/http/pagination';
import type { InventoryCatalogRepository } from './catalog.repository';
import { InventoryCatalogService } from './catalog.service';

describe('InventoryCatalogService', () => {
  let repository: { findUoms: ReturnType<typeof vi.fn>; findCategories: ReturnType<typeof vi.fn> };
  let service: InventoryCatalogService;

  beforeEach(() => {
    repository = {
      findUoms: vi.fn().mockResolvedValue({
        rows: [{ id: 1, code: 'KG', name: 'Kilogram', decimal_places: 3, is_active: 1 }],
        total: 1,
      }),
      findCategories: vi.fn().mockResolvedValue({
        rows: [{ id: 4, name: 'Supplements', parent_id: null, is_active: true }],
        total: 1,
      }),
    };
    const pagination = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };
    service = new InventoryCatalogService(
      repository as unknown as InventoryCatalogRepository,
      pagination as unknown as PaginationHelper,
    );
  });

  it('lists uoms with the is_active filter and maps fields', async () => {
    const result = await service.listUoms({ is_active: 'true' });
    expect(repository.findUoms).toHaveBeenCalledWith({ isActive: true, limit: 20, offset: 0 });
    expect(result.data).toEqual([
      { id: 1, code: 'KG', name: 'Kilogram', decimal_places: 3, is_active: true },
    ]);
    expect(result.meta.total).toBe(1);
  });

  it('lists categories without a filter', async () => {
    const result = await service.listCategories({});
    expect(repository.findCategories).toHaveBeenCalledWith({
      isActive: undefined,
      limit: 20,
      offset: 0,
    });
    expect(result.data).toEqual([
      { id: 4, name: 'Supplements', parent_id: null, is_active: true },
    ]);
  });
});
