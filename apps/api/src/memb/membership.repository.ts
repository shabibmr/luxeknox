import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, lte, ne, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  membershipExtensions,
  membershipFreezes,
  membershipHistories,
  memberships,
  membershipProducts,
  type Membership,
  type MembershipExtension,
  type MembershipFreeze,
  type MembershipHistory,
  type MembershipProduct,
  type NewMembership,
  type NewMembershipExtension,
  type NewMembershipFreeze,
  type NewMembershipHistory,
} from '../platform/db/schema/memberships';
import { members } from '../platform/db/schema/members';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export type MembershipListScope =
  | { type: 'all' }
  | { type: 'self'; memberProfileId: number }
  | { type: 'trainer'; trainerProfileId: number };

export interface MembershipFilterParams {
  memberId?: number;
  status?: string;
  scope: MembershipListScope;
  limit: number;
  offset: number;
}

export interface MembershipWithProduct extends Membership {
  product: MembershipProduct | null;
}

@Injectable()
export class MembershipRepository extends BaseRepository<
  typeof memberships,
  Membership,
  NewMembership
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, memberships);
  }

  private buildFilterConditions(
    params: Omit<MembershipFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.memberId !== undefined) {
      conditions.push(eq(memberships.member_id, params.memberId));
    }
    if (params.status) {
      conditions.push(eq(memberships.status, params.status));
    }
    if (params.scope.type === 'self') {
      conditions.push(eq(memberships.member_id, params.scope.memberProfileId));
    }
    if (params.scope.type === 'trainer') {
      conditions.push(eq(members.assigned_trainer_id, params.scope.trainerProfileId));
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  /** Joins `members` only when the trainer scope needs it, to keep the admin/self path a plain scan. */
  async findManyFiltered(
    params: MembershipFilterParams,
  ): Promise<{ rows: MembershipWithProduct[]; total: number }> {
    const { limit, offset, ...filterParams } = params;
    const where = this.buildFilterConditions(filterParams);
    const db = this.getDb() as any;
    const needsMemberJoin = params.scope.type === 'trainer';

    let rowsQuery = db
      .select({ membership: memberships, product: membershipProducts })
      .from(memberships)
      .leftJoin(membershipProducts, eq(memberships.product_id, membershipProducts.id));
    let countQuery = db.select({ value: sql<number>`count(*)` }).from(memberships);

    if (needsMemberJoin) {
      rowsQuery = rowsQuery.innerJoin(members, eq(memberships.member_id, members.id));
      countQuery = countQuery.innerJoin(members, eq(memberships.member_id, members.id));
    }
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.orderBy(desc(memberships.id)).limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows.map((row: any) => ({ ...row.membership, product: row.product ?? null })),
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByIdWithProduct(id: number): Promise<MembershipWithProduct | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ membership: memberships, product: membershipProducts })
      .from(memberships)
      .leftJoin(membershipProducts, eq(memberships.product_id, membershipProducts.id))
      .where(eq(memberships.id, id))
      .limit(1);
    const row = rows[0];
    if (!row) return null;
    return { ...row.membership, product: row.product ?? null };
  }

  /** FR-MEMB-006: at most one active/frozen membership per member. */
  async findActiveOrFrozenForMember(memberId: number): Promise<Membership | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(memberships)
      .where(
        and(
          eq(memberships.member_id, memberId),
          sql`${memberships.status} in ('active', 'frozen')`,
        ),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  /** BR-MEMB-004: locker uniqueness among active/frozen memberships (excludes `excludeId` on renew/upgrade). */
  async findByLockerNumberActiveOrFrozen(
    lockerNumber: string,
    excludeId?: number,
  ): Promise<Membership | null> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(memberships.locker_number, lockerNumber),
      sql`${memberships.status} in ('active', 'frozen')`,
    ];
    if (excludeId !== undefined) {
      conditions.push(ne(memberships.id, excludeId));
    }
    const rows = await db
      .select()
      .from(memberships)
      .where(and(...conditions))
      .limit(1);
    return rows[0] ?? null;
  }

  async insertMembership(values: NewMembership): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateMembership(id: number, values: Partial<NewMembership>): Promise<void> {
    await this.update(eq(memberships.id, id), values);
  }

  async insertHistory(values: NewMembershipHistory): Promise<void> {
    const db = this.getDb() as any;
    await db.insert(membershipHistories).values(values);
  }

  async listHistory(
    membershipId: number,
    limit: number,
  ): Promise<MembershipHistory[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(membershipHistories)
      .where(eq(membershipHistories.membership_id, membershipId))
      .orderBy(membershipHistories.timestamp, membershipHistories.id)
      .limit(limit);
  }

  async insertFreeze(values: NewMembershipFreeze): Promise<number> {
    const db = this.getDb() as any;
    const result = await db.insert(membershipFreezes).values(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateFreeze(id: number, values: Partial<NewMembershipFreeze>): Promise<void> {
    const db = this.getDb() as any;
    await db.update(membershipFreezes).set(values).where(eq(membershipFreezes.id, id));
  }

  async findFreezeById(id: number): Promise<MembershipFreeze | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(membershipFreezes)
      .where(eq(membershipFreezes.id, id))
      .limit(1);
    return rows[0] ?? null;
  }

  async listFreezesForMembership(membershipId: number): Promise<MembershipFreeze[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(membershipFreezes)
      .where(eq(membershipFreezes.membership_id, membershipId))
      .orderBy(desc(membershipFreezes.id));
  }

  /** FR-MEMB-017: sum of *approved* freeze days already granted on this membership. */
  async sumApprovedFreezeDays(membershipId: number): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ total: sql<number>`coalesce(sum(${membershipFreezes.total_freeze_days}), 0)` })
      .from(membershipFreezes)
      .where(
        and(eq(membershipFreezes.membership_id, membershipId), eq(membershipFreezes.status, 'approved')),
      );
    return Number(rows[0]?.total ?? 0);
  }

  /** FR-MEMB-018: overlap against pending/approved freezes on the same membership. */
  async findOverlappingFreeze(
    membershipId: number,
    startDate: string,
    endDate: string,
  ): Promise<MembershipFreeze | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(membershipFreezes)
      .where(
        and(
          eq(membershipFreezes.membership_id, membershipId),
          sql`${membershipFreezes.status} in ('pending', 'approved')`,
          lte(membershipFreezes.start_date, endDate),
          gte(membershipFreezes.end_date, startDate),
        ),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  async insertExtension(values: NewMembershipExtension): Promise<number> {
    const db = this.getDb() as any;
    const result = await db.insert(membershipExtensions).values(values);
    return Number(result?.[0]?.insertId ?? 0);
  }
}
