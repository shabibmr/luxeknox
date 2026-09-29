import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  ptProducts,
  type NewPtProduct,
  type PtProduct,
} from '../platform/db/schema/personal-training';

export interface PtProductFilterParams {
  q?: string;
  activeOnly: boolean;
  limit: number;
  offset: number;
}

@Injectable()
export class PtProductRepository extends BaseRepository<typeof ptProducts, PtProduct, NewPtProduct> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, ptProducts);
  }

  async findManyFiltered(params: PtProductFilterParams): Promise<{ rows: PtProduct[]; total: number }> {
    const conditions: SQL[] = [];
    if (params.activeOnly) conditions.push(eq(ptProducts.is_active, true));
    if (params.q) {
      const like_ = `%${params.q}%`;
      conditions.push(or(like(ptProducts.name, like_), like(ptProducts.code, like_)) as SQL);
    }
    const where = conditions.length === 0 ? undefined : and(...conditions);
    const db = this.getDb() as any;

    let rowsQuery = db.select().from(ptProducts);
    let countQuery = db.select({ value: count() }).from(ptProducts);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.orderBy(ptProducts.name).limit(params.limit).offset(params.offset),
      countQuery,
    ]);
    return { rows: rows as PtProduct[], total: Number(countRows[0]?.value ?? 0) };
  }

  async findByCode(code: string): Promise<PtProduct | null> {
    return this.findOne(eq(ptProducts.code, code));
  }

  async insertProduct(values: NewPtProduct): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateProduct(id: number, values: Partial<NewPtProduct>): Promise<void> {
    await this.update(eq(ptProducts.id, id), values);
  }
}
