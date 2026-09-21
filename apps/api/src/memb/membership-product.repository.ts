import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  membershipProducts,
  type MembershipProduct,
  type NewMembershipProduct,
} from '../platform/db/schema/memberships';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface MembershipProductFilterParams {
  q?: string;
  activeOnly: boolean;
  limit: number;
  offset: number;
}

export interface MembershipProductFilterResult {
  rows: MembershipProduct[];
  total: number;
}

@Injectable()
export class MembershipProductRepository extends BaseRepository<
  typeof membershipProducts,
  MembershipProduct,
  NewMembershipProduct
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, membershipProducts);
  }

  private buildFilterConditions(
    params: Omit<MembershipProductFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.activeOnly) {
      conditions.push(eq(membershipProducts.is_active, true));
    }
    if (params.q) {
      const like_ = `%${params.q}%`;
      conditions.push(
        or(like(membershipProducts.name, like_), like(membershipProducts.code, like_)) as SQL,
      );
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findManyFiltered(
    params: MembershipProductFilterParams,
  ): Promise<MembershipProductFilterResult> {
    const { limit, offset, ...filterParams } = params;
    const where = this.buildFilterConditions(filterParams);
    const db = this.getDb() as any;

    let rowsQuery = db.select().from(membershipProducts);
    let countQuery = db.select({ value: count() }).from(membershipProducts);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as MembershipProduct[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByCode(code: string): Promise<MembershipProduct | null> {
    return this.findOne(eq(membershipProducts.code, code));
  }

  async insertProduct(values: NewMembershipProduct): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateProduct(id: number, values: Partial<NewMembershipProduct>): Promise<void> {
    await this.update(eq(membershipProducts.id, id), values);
  }
}
