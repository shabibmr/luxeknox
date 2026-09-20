import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { foods, type Food, type NewFood } from '../platform/db/schema/foods';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface FoodFilterParams {
  q?: string;
  isActive?: boolean;
  isVerified?: boolean;
  limit: number;
  offset: number;
}

export interface FoodFilterResult {
  rows: Food[];
  total: number;
}

@Injectable()
export class FoodRepository extends BaseRepository<typeof foods, Food, NewFood> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, foods);
  }

  private buildFilterConditions(
    params: Omit<FoodFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.isActive !== undefined) {
      conditions.push(eq(foods.is_active, params.isActive));
    }
    if (params.isVerified !== undefined) {
      conditions.push(eq(foods.is_verified, params.isVerified));
    }
    if (params.q) {
      conditions.push(like(foods.name, `%${params.q}%`));
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  /**
   * Finds foods matching the given filters, paginated. Returns the page of rows
   * alongside the total matching count (for offset-mode `has_more`/`total` in PageMeta).
   */
  async findManyFiltered(params: FoodFilterParams): Promise<FoodFilterResult> {
    const { limit, offset, ...filterParams } = params;
    const where = this.buildFilterConditions(filterParams);
    const db = this.getDb() as any;

    let rowsQuery = db.select().from(foods);
    let countQuery = db.select({ value: count() }).from(foods);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as Food[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async insertFood(values: NewFood): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateFood(id: number, values: Partial<NewFood>): Promise<void> {
    await this.update(eq(foods.id, id), values);
  }
}
