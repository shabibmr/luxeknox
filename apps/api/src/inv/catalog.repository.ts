import { Inject, Injectable } from '@nestjs/common';
import { asc, count, eq, type SQL } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { itemCategories, uoms, type ItemCategory, type Uom } from '../platform/db/schema/accounting';

export interface CatalogListParams {
  isActive?: boolean;
  limit: number;
  offset: number;
}

@Injectable()
export class InventoryCatalogRepository {
  constructor(@Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>) {}

  async findUoms(params: CatalogListParams): Promise<{ rows: Uom[]; total: number }> {
    const db = this.db as any;
    const where: SQL | undefined =
      params.isActive === undefined ? undefined : eq(uoms.is_active, params.isActive);
    let listQ = db.select().from(uoms);
    let countQ = db.select({ value: count() }).from(uoms);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }
    const rows = await listQ.orderBy(asc(uoms.code)).limit(params.limit).offset(params.offset);
    const totalRows = await countQ;
    return { rows: rows as Uom[], total: Number(totalRows[0]?.value ?? 0) };
  }

  async findCategories(
    params: CatalogListParams,
  ): Promise<{ rows: ItemCategory[]; total: number }> {
    const db = this.db as any;
    const where: SQL | undefined =
      params.isActive === undefined ? undefined : eq(itemCategories.is_active, params.isActive);
    let listQ = db.select().from(itemCategories);
    let countQ = db.select({ value: count() }).from(itemCategories);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }
    const rows = await listQ
      .orderBy(asc(itemCategories.name))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    return { rows: rows as ItemCategory[], total: Number(totalRows[0]?.value ?? 0) };
  }
}
