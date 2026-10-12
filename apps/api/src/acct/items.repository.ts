import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accounts,
  items,
  taxCodes,
  type Account,
  type Item,
  type NewItem,
  type TaxCode,
} from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';
import type { ItemKind } from './items.dto';

export interface ItemFilterParams {
  itemKind?: ItemKind;
  search?: string;
  isActive?: boolean;
  limit: number;
  offset: number;
}

@Injectable()
export class ItemsRepository extends BaseRepository<
  typeof items,
  Item,
  NewItem
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, items);
  }

  async findMany(params: ItemFilterParams): Promise<{ rows: Item[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.itemKind) {
      conditions.push(eq(items.item_kind, params.itemKind));
    }
    if (params.isActive !== undefined) {
      conditions.push(eq(items.is_active, params.isActive));
    }
    if (params.search && params.search.trim().length > 0) {
      const term = `%${params.search.trim()}%`;
      conditions.push(like(items.name, term));
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    let listQ = db.select().from(items);
    let countQ = db.select({ value: count() }).from(items);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(items.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }

  async insertItem(data: NewItem): Promise<Item> {
    const db = this.getDb() as any;
    const result = await db.insert(items).values(data);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) throw new Error(`Failed to load item ${id}`);
    return created;
  }

  async updateItem(id: number, data: Partial<NewItem>): Promise<Item> {
    const db = this.getDb() as any;
    await db.update(items).set(data).where(eq(items.id, id));
    const updated = await this.findById(id);
    if (!updated) throw new NotFoundError(`Item ${id} was not found`);
    return updated;
  }

  async findAccountById(id: number): Promise<Account | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(accounts)
      .where(eq(accounts.id, id))
      .limit(1);
    return rows[0] ?? null;
  }

  async findTaxCodeById(id: number): Promise<TaxCode | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(taxCodes)
      .where(eq(taxCodes.id, id))
      .limit(1);
    return rows[0] ?? null;
  }
}
