import { Inject, Injectable } from '@nestjs/common';
import { eq, inArray, sql } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { items } from '../platform/db/schema/accounting';
import {
  itemStock,
  stockMovements,
  type ItemStock,
  type NewItemStock,
  type NewStockMovement,
} from '../platform/db/schema/inventory';

export interface StockItemFlags {
  id: number;
  inventory_tracked: boolean;
}

@Injectable()
export class StockRepository extends BaseRepository<typeof itemStock, ItemStock, NewItemStock> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb) {
    super(db, itemStock);
  }

  async findTrackedItem(itemId: number): Promise<StockItemFlags | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: items.id,
        inventory_tracked: items.inventory_tracked,
      })
      .from(items)
      .where(eq(items.id, itemId))
      .limit(1);
    const row = rows[0] as StockItemFlags | undefined;
    return row ?? null;
  }

  /**
   * Locks the `item_stock` row for the item (or returns null if none yet).
   * Must run inside the caller's transaction.
   */
  async lockStockForUpdate(itemId: number): Promise<ItemStock | null> {
    const db = this.getDb() as any;
    const rows = await db.execute(
      sql`SELECT \`id\`, \`item_id\`, \`qty_on_hand\`, \`stock_value\`, \`avg_cost\`, \`row_version\`
          FROM \`item_stock\` WHERE \`item_id\` = ${itemId} FOR UPDATE`,
    );
    const list = (rows?.[0] ?? rows) as ItemStock[] | undefined;
    const row = Array.isArray(list) ? list[0] : undefined;
    if (!row) return null;
    return {
      id: Number(row.id),
      item_id: Number(row.item_id),
      qty_on_hand: String(row.qty_on_hand),
      stock_value: String(row.stock_value),
      avg_cost: String(row.avg_cost),
      row_version: Number(row.row_version),
    };
  }

  async insertStock(row: NewItemStock): Promise<ItemStock> {
    const db = this.getDb() as any;
    const result = await db.insert(itemStock).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    if (!id) {
      throw new Error('Failed to insert item_stock');
    }
    return { id, ...row } as ItemStock;
  }

  async updateStock(
    itemId: number,
    patch: Pick<ItemStock, 'qty_on_hand' | 'stock_value' | 'avg_cost' | 'row_version'>,
  ): Promise<void> {
    const db = this.getDb() as any;
    await db.update(itemStock).set(patch).where(eq(itemStock.item_id, itemId));
  }

  async insertMovement(row: NewStockMovement): Promise<void> {
    const db = this.getDb() as any;
    await db.insert(stockMovements).values(row);
  }

  /** Item ids among `itemIds` that have at least one `stock_movements` row. */
  async findItemIdsWithMovements(itemIds: number[]): Promise<Set<number>> {
    if (itemIds.length === 0) return new Set();
    const db = this.getDb() as any;
    const rows = await db
      .selectDistinct({ item_id: stockMovements.item_id })
      .from(stockMovements)
      .where(inArray(stockMovements.item_id, itemIds));
    return new Set((rows as Array<{ item_id: number }>).map((row) => Number(row.item_id)));
  }

  /** Current `qty_on_hand` for the given items. Missing rows are omitted from the map. */
  async findQtyOnHandByItemIds(itemIds: number[]): Promise<Map<number, string>> {
    if (itemIds.length === 0) return new Map();
    const db = this.getDb() as any;
    const rows = await db
      .select({
        item_id: itemStock.item_id,
        qty_on_hand: itemStock.qty_on_hand,
      })
      .from(itemStock)
      .where(inArray(itemStock.item_id, itemIds));
    return new Map(
      (rows as Array<{ item_id: number; qty_on_hand: string | number }>).map((row) => [
        Number(row.item_id),
        String(row.qty_on_hand),
      ]),
    );
  }
}
