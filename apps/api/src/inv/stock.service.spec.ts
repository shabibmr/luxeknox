import { beforeEach, describe, expect, it, vi } from 'vitest';
import { BusinessRuleError } from '../platform/errors/app-error';
import type { ItemStock } from '../platform/db/schema/inventory';
import { StockService, type StockSource } from './stock.service';
import type { StockRepository } from './stock.repository';

const ITEM_ID = 42;
const SOURCE: StockSource = {
  sourceType: 'purchase_bill',
  sourceId: 100,
  sourceLineId: 1,
  movementDate: '2026-10-16',
};

function stockRow(partial: Partial<ItemStock> = {}): ItemStock {
  return {
    id: 1,
    item_id: ITEM_ID,
    qty_on_hand: '0.000',
    stock_value: '0.00',
    avg_cost: '0.0000',
    row_version: 1,
    ...partial,
  };
}

describe('StockService', () => {
  let repository: {
    findTrackedItem: ReturnType<typeof vi.fn>;
    lockStockForUpdate: ReturnType<typeof vi.fn>;
    insertStock: ReturnType<typeof vi.fn>;
    updateStock: ReturnType<typeof vi.fn>;
    insertMovement: ReturnType<typeof vi.fn>;
  };
  let service: StockService;
  let current: ItemStock | null;

  beforeEach(() => {
    current = null;
    repository = {
      findTrackedItem: vi.fn(async (itemId: number) => {
        if (itemId !== ITEM_ID) return null;
        return { id: ITEM_ID, inventory_tracked: true };
      }),
      lockStockForUpdate: vi.fn(async () => current),
      insertStock: vi.fn(async (row: Omit<ItemStock, 'id'>) => {
        current = { id: 1, ...row };
        return current;
      }),
      updateStock: vi.fn(async (itemId: number, patch: Partial<ItemStock>) => {
        current = { ...current!, item_id: itemId, ...patch, row_version: (current?.row_version ?? 0) + 1 };
        return current;
      }),
      insertMovement: vi.fn(async () => undefined),
    };
    service = new StockService(repository as unknown as StockRepository);
  });

  it('receives 10@100 then 5@130 → qty 15, value 1650, avg 110', async () => {
    const first = await service.receive(ITEM_ID, '10.000', '1000.00', SOURCE);
    expect(first).toMatchObject({
      qtyOnHand: '10.000',
      stockValue: '1000.00',
      avgCost: '100.0000',
      unitCost: '100.0000',
      value: '1000.00',
    });

    const second = await service.receive(ITEM_ID, '5.000', '650.00', {
      ...SOURCE,
      sourceLineId: 2,
    });
    expect(second).toMatchObject({
      qtyOnHand: '15.000',
      stockValue: '1650.00',
      avgCost: '110.0000',
      value: '650.00',
    });
    expect(repository.insertMovement).toHaveBeenCalledTimes(2);
  });

  it('issues 2 at average cost 110 → value 220', async () => {
    current = stockRow({
      qty_on_hand: '15.000',
      stock_value: '1650.00',
      avg_cost: '110.0000',
    });

    const issued = await service.issue(ITEM_ID, '2.000', {
      sourceType: 'counter_sale',
      sourceId: 50,
      sourceLineId: 7,
      movementDate: '2026-10-16',
    });

    expect(issued).toMatchObject({
      qtyOnHand: '13.000',
      stockValue: '1430.00',
      avgCost: '110.0000',
      unitCost: '110.0000',
      value: '220.00',
    });
    expect(repository.insertMovement).toHaveBeenCalledWith(
      expect.objectContaining({
        item_id: ITEM_ID,
        qty_in: '0.000',
        qty_out: '2.000',
        unit_cost: '110.0000',
        value: '220.00',
        balance_qty: '13.000',
        balance_value: '1430.00',
      }),
    );
  });

  it('refuses an issue above on-hand with insufficient_stock', async () => {
    current = stockRow({
      qty_on_hand: '13.000',
      stock_value: '1430.00',
      avg_cost: '110.0000',
    });

    await expect(service.issue(ITEM_ID, '14.000', SOURCE)).rejects.toBeInstanceOf(BusinessRuleError);

    try {
      await service.issue(ITEM_ID, '14.000', SOURCE);
    } catch (err) {
      expect(err).toBeInstanceOf(BusinessRuleError);
      expect((err as BusinessRuleError).details).toEqual([
        {
          rule: 'insufficient_stock',
          item_id: ITEM_ID,
          requested: '14.000',
          available: '13.000',
        },
      ]);
    }
    expect(repository.updateStock).not.toHaveBeenCalled();
    expect(repository.insertMovement).not.toHaveBeenCalled();
  });

  it('emptying stock takes the remaining value so value is 0', async () => {
    // Residue after rounding: qty 3, value 10.00, avg 3.3333 → issue 1 then 2
    current = stockRow({
      qty_on_hand: '3.000',
      stock_value: '10.00',
      avg_cost: '3.3333',
    });

    const first = await service.issue(ITEM_ID, '1.000', SOURCE);
    expect(first.value).toBe('3.33');
    expect(first.qtyOnHand).toBe('2.000');
    expect(first.stockValue).toBe('6.67');

    const last = await service.issue(ITEM_ID, '2.000', { ...SOURCE, sourceLineId: 9 });
    expect(last.qtyOnHand).toBe('0.000');
    expect(last.stockValue).toBe('0.00');
    expect(last.avgCost).toBe('0.0000');
    expect(last.value).toBe('6.67');
  });

  it('refuses receive/issue on an untracked item', async () => {
    repository.findTrackedItem.mockResolvedValueOnce({ id: ITEM_ID, inventory_tracked: false });
    await expect(service.receive(ITEM_ID, '1.000', '10.00', SOURCE)).rejects.toMatchObject({
      details: [expect.objectContaining({ rule: 'item_not_tracked' })],
    });
  });
});
