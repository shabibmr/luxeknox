import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BadRequestError, NotFoundError } from '../platform/errors/app-error';
import { decodeCursor, encodeCursor, type PaginationHelper } from '../platform/http/pagination';
import type { InventoryItemRow, InventoryItemsRepository } from './items.repository';
import { InventoryItemsService } from './items.service';
import type { StockRepository } from './stock.repository';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const ROW: InventoryItemRow = {
  id: 10,
  name: 'Whey Protein',
  sku: 'WHEY-1',
  hsn_sac: '2106',
  item_kind: 'goods',
  category_id: 4,
  category_name: 'Supplements',
  uom_id: 1,
  uom_code: 'PCS',
  uom_decimal_places: 0,
  sale_rate: '1499.00',
  purchase_rate: '900.00',
  tax_code_id: 1,
  income_account_id: 4250,
  expense_account_id: 5000,
  inventory_account_id: 1400,
  cogs_account_id: 5050,
  inventory_tracked: true,
  reorder_level: '5.000',
  is_active: true,
  row_version: 1,
  created_at: new Date('2026-10-16T00:00:00.000Z'),
  updated_at: null,
};

describe('InventoryItemsService', () => {
  let repository: {
    findMany: ReturnType<typeof vi.fn>;
    findReadById: ReturnType<typeof vi.fn>;
  };
  let stockRepository: {
    findItemIdsWithMovements: ReturnType<typeof vi.fn>;
  };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: InventoryItemsService;

  beforeEach(() => {
    repository = {
      findMany: vi.fn().mockResolvedValue({ rows: [ROW], total: 1 }),
      findReadById: vi.fn().mockResolvedValue(ROW),
    };
    stockRepository = {
      findItemIdsWithMovements: vi.fn().mockResolvedValue(new Set()),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };
    service = new InventoryItemsService(
      repository as unknown as InventoryItemsRepository,
      stockRepository as unknown as StockRepository,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  it('lists items with uom and category names and omits stock', async () => {
    const page = await service.list({ search: 'WHEY-1', category_id: '4' }, ADMIN_USER);

    expect(repository.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        search: 'WHEY-1',
        categoryId: 4,
        limit: 20,
        offset: 0,
      }),
    );
    expect(stockRepository.findItemIdsWithMovements).toHaveBeenCalledWith([10]);
    expect(page.data).toEqual([
      expect.objectContaining({
        id: 10,
        sku: 'WHEY-1',
        uom_code: 'PCS',
        uom_decimal_places: 0,
        category_name: 'Supplements',
        has_movements: false,
      }),
    ]);
    expect(page.data[0]).not.toHaveProperty('stock');
    expect(page.meta.total).toBe(1);
  });

  it('lists the page after a cursor and returns next_cursor when more remain', async () => {
    const cursorPayload = {
      createdAt: '2026-10-16T00:00:00.000Z',
      id: 20,
    };
    const cursor = encodeCursor(cursorPayload);
    paginationHelper.normalizeParams.mockResolvedValue({
      mode: 'cursor',
      limit: 1,
      cursor: cursorPayload,
    });

    const older = {
      ...ROW,
      id: 9,
      name: 'Older Item',
      created_at: new Date('2026-10-15T00:00:00.000Z'),
    };
    const evenOlder = {
      ...ROW,
      id: 8,
      name: 'Even Older',
      created_at: new Date('2026-10-14T00:00:00.000Z'),
    };
    repository.findMany.mockResolvedValue({ rows: [older, evenOlder], total: 3 });

    const page = await service.list({ cursor, limit: '1' }, ADMIN_USER);

    expect(repository.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        limit: 2,
        cursor: cursorPayload,
      }),
    );
    expect(repository.findMany.mock.calls[0][0]).not.toHaveProperty('offset');
    expect(page.data).toHaveLength(1);
    expect(page.data[0]?.id).toBe(9);
    expect(page.meta.cursor).toBe(cursor);
    expect(page.meta.has_more).toBe(true);
    expect(page.meta.next_cursor).toBeTruthy();
    expect(decodeCursor(page.meta.next_cursor!)).toEqual({
      createdAt: '2026-10-15T00:00:00.000Z',
      id: 9,
    });
  });

  it('refuses an unknown cursor', async () => {
    const { PaginationHelper: RealPaginationHelper } = await import('../platform/http/pagination');
    const realHelper = new RealPaginationHelper({
      getDefaultPageSize: vi.fn().mockResolvedValue(20),
    } as never);
    service = new InventoryItemsService(
      repository as unknown as InventoryItemsRepository,
      stockRepository as unknown as StockRepository,
      realHelper,
    );

    await expect(service.list({ cursor: 'not-a-cursor' }, ADMIN_USER)).rejects.toBeInstanceOf(
      BadRequestError,
    );
    expect(repository.findMany).not.toHaveBeenCalled();
  });

  it('sets has_movements true when a stock movement exists', async () => {
    stockRepository.findItemIdsWithMovements.mockResolvedValue(new Set([10]));

    const page = await service.list({}, ADMIN_USER);
    const item = await service.getById(10, ADMIN_USER);

    expect(page.data[0]?.has_movements).toBe(true);
    expect(item.has_movements).toBe(true);
  });

  it('passes inventory_tracked from the query string', async () => {
    await service.list({ inventory_tracked: 'false', is_active: 'true', item_kind: 'goods' }, ADMIN_USER);

    expect(repository.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        inventoryTracked: false,
        isActive: true,
        itemKind: 'goods',
      }),
    );
  });

  it('returns the same item shape from get', async () => {
    const item = await service.getById(10, ADMIN_USER);
    expect(item.uom_code).toBe('PCS');
    expect(item.category_name).toBe('Supplements');
    expect(item.has_movements).toBe(false);
    expect(stockRepository.findItemIdsWithMovements).toHaveBeenCalledWith([10]);
    expect(item).not.toHaveProperty('stock');
  });

  it('throws when the item does not exist', async () => {
    repository.findReadById.mockResolvedValue(null);
    await expect(service.getById(99, ADMIN_USER)).rejects.toBeInstanceOf(NotFoundError);
    expect(stockRepository.findItemIdsWithMovements).not.toHaveBeenCalled();
  });
});
