import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { members, type Member, type NewMember } from '../platform/db/schema/members';
import { trainers } from '../platform/db/schema/trainers';
import { users, type UserStatus } from '../platform/db/schema/users';

export type MemberListScope =
  | { type: 'all' }
  | { type: 'trainer'; trainerProfileId: number }
  | { type: 'self'; userId: number };

export interface MemberFilterParams {
  q?: string;
  status?: UserStatus;
  assignedTrainerId?: number;
  scope: MemberListScope;
  limit: number;
  offset: number;
}

export interface MemberFilterResult {
  rows: Member[];
  total: number;
}

@Injectable()
export class MemberRepository extends BaseRepository<typeof members, Member, NewMember> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, members);
  }

  private buildScopeCondition(scope: MemberListScope): SQL | undefined {
    if (scope.type === 'all') return undefined;
    if (scope.type === 'trainer') {
      return eq(members.assigned_trainer_id, scope.trainerProfileId);
    }
    return eq(members.user_id, scope.userId);
  }

  async findManyFiltered(params: MemberFilterParams): Promise<MemberFilterResult> {
    const { limit, offset, scope, q, status, assignedTrainerId } = params;
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    const scopeCond = this.buildScopeCondition(scope);
    if (scopeCond) conditions.push(scopeCond);
    if (assignedTrainerId != null) {
      conditions.push(eq(members.assigned_trainer_id, assignedTrainerId));
    }
    if (status) {
      conditions.push(eq(users.status, status));
    }
    if (q) {
      const pattern = `%${q}%`;
      conditions.push(
        or(
          like(members.first_name, pattern),
          like(members.last_name, pattern),
          like(members.membership_number, pattern),
          like(users.email, pattern),
          like(users.phone_number, pattern),
        )!,
      );
    }

    const where = conditions.length === 0 ? undefined : conditions.length === 1 ? conditions[0] : and(...conditions);

    let rowsQuery = db
      .select({
        id: members.id,
        user_id: members.user_id,
        membership_number: members.membership_number,
        first_name: members.first_name,
        last_name: members.last_name,
        gender: members.gender,
        date_of_birth: members.date_of_birth,
        address: members.address,
        assigned_trainer_id: members.assigned_trainer_id,
        joined_date: members.joined_date,
        notes: members.notes,
        created_at: members.created_at,
        updated_at: members.updated_at,
      })
      .from(members)
      .leftJoin(users, eq(users.id, members.user_id));

    let countQuery = db
      .select({ value: count() })
      .from(members)
      .leftJoin(users, eq(users.id, members.user_id));

    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as Member[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async updateMember(id: number, values: Partial<NewMember>): Promise<void> {
    await this.update(eq(members.id, id), values);
  }

  async countAssignedToTrainer(trainerId: number): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ value: count() })
      .from(members)
      .where(eq(members.assigned_trainer_id, trainerId));
    return Number(rows[0]?.value ?? 0);
  }

  async findTrainerAssignmentMeta(trainerId: number): Promise<{
    id: number;
    is_active: boolean;
    max_clients_capacity: number | null;
  } | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: trainers.id,
        is_active: trainers.is_active,
        max_clients_capacity: trainers.max_clients_capacity,
      })
      .from(trainers)
      .where(eq(trainers.id, trainerId))
      .limit(1);
    return rows[0] ?? null;
  }
}
