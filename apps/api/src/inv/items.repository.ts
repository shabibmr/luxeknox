import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, like, or, sql, type SQL } from 'drizzle-orm';
import type { ItemKind } from '../acct/items.dto';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  itemCategories,
  items,
  uoms,
  type Item,
  type NewItem,
} from '../platform/db/schema/accounting';

export interface ItemListFilter {
  itemKind?: ItemKind;
  search?: string;
  categoryId?: number;
  isActive?: boolean;
  inventoryTracked?: boolean;
}

export interface InventoryItemRow {
  id: number;
  name: string;
  sku: string | null;
  hsn_sac: string | null;
  item_kind: string;
  category_id: number | null;
  category_name: string | null;
  uom_id: number;
  uom_code: string;
  uom_decimal_places: number;
  sale_rate: string | null;
  purchase_rate: string | null;
  tax_code_id: number | null;
  income_account_id: number;
  expense_account_id: number;
  inventory_account_id: number | null;
  cogs_account_id: number | null;
  inventory_tracked: boolean;
  reorder_level: string | null;
  is_active: boolean;
  row_version: number;
  created_at: Date;
  updated_at: Date | null;
}

const itemReadColumns = {
  id: items.id,
  name: items.name,
  sku: items.sku,
  hsn_sac: items.hsn_sac,
  item_kind: items.item_kind,
  category_id: items.category_id,
  category_name: itemCategories.name,
  uom_id: items.uom_id,
  uom_code: uoms.code,
  uom_decimal_places: uoms.decimal_places,
  sale_rate: items.sale_rate,
  purchase_rate: items.purchase_rate,
  tax_code_id: items.tax_code_id,
  income_account_id: items.income_account_id,
  expense_account_id: items.expense_account_id,
  inventory_account_id: items.inventory_account_id,
  cogs_account_id: items.cogs_account_id,
  inventory_tracked: items.inventory_tracked,
  reorder_level: items.reorder_level,
  is_active: items.is_active,
  row_version: items.row_version,
  created_at: items.created_at,
  updated_at: items.updated_at,
};

export function itemListWhere(filters: ItemListFilter): SQL | undefined {
  const conditions: SQL[] = [];

  if (filters.itemKind) {
    conditions.push(eq(items.item_kind, filters.itemKind));
  }
  if (filters.categoryId != null) {
    conditions.push(eq(items.category_id, filters.categoryId));
  }
  if (filters.isActive !== undefined) {
    conditions.push(eq(items.is_active, filters.isActive));
  }
  if (filters.inventoryTracked !== undefined) {
    conditions.push(eq(items.inventory_tracked, filters.inventoryTracked));
  }
  const search = filters.search?.trim();
  if (search) {
    const term = `%${search}%`;
    conditions.push(or(like(items.name, term), like(items.sku, term)) as SQL);
  }

  return conditions.length > 0 ? and(...conditions) : undefined;
}

@Injectable()
export class InventoryItemsRepository extends BaseRepository<typeof items, Item, NewItem> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, items);
  }

  async findMany(
    params: ItemListFilter & {
      limit: number;
      offset?: number;
      cursor?: { createdAt: string; id: number };
    },
  ): Promise<{ rows: InventoryItemRow[]; total: number }> {
    const db = this.getDb() as any;
    const filterWhere = itemListWhere(params);
    const listConditions: SQL[] = [];
    if (filterWhere) listConditions.push(filterWhere);
    if (params.cursor) {
      const cursorDate = new Date(params.cursor.createdAt);
      listConditions.push(
        sql`(${items.created_at} < ${cursorDate} OR (${items.created_at} = ${cursorDate} AND ${items.id} < ${params.cursor.id}))`,
      );
    }
    const listWhere = listConditions.length > 0 ? and(...listConditions) : undefined;

    let listQ = db
      .select(itemReadColumns)
      .from(items)
      .innerJoin(uoms, eq(items.uom_id, uoms.id))
      .leftJoin(itemCategories, eq(items.category_id, itemCategories.id));
    let countQ = db.select({ value: count() }).from(items);
    if (listWhere) {
      listQ = listQ.where(listWhere);
    }
    if (filterWhere) {
      countQ = countQ.where(filterWhere);
    }

    const offset = params.cursor ? 0 : (params.offset ?? 0);
    const rows = await listQ
      .orderBy(desc(items.created_at), desc(items.id))
      .limit(params.limit)
      .offset(offset);
    const totalRows = await countQ;
    return { rows: rows as InventoryItemRow[], total: Number(totalRows[0]?.value ?? 0) };
  }

  async findReadById(id: number): Promise<InventoryItemRow | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select(itemReadColumns)
      .from(items)
      .innerJoin(uoms, eq(items.uom_id, uoms.id))
      .leftJoin(itemCategories, eq(items.category_id, itemCategories.id))
      .where(eq(items.id, id))
      .limit(1);
    return (rows[0] as InventoryItemRow | undefined) ?? null;
  }
}
