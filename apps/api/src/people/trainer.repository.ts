import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { trainers, type NewTrainer, type Trainer } from '../platform/db/schema/trainers';
import { members } from '../platform/db/schema/members';

export interface TrainerFilterParams {
  q?: string;
  status?: 'all' | 'active' | 'inactive';
  is_active?: boolean;
  limit: number;
  offset: number;
}

export interface TrainerFilterResult {
  rows: Trainer[];
  total: number;
}

@Injectable()
export class TrainerRepository extends BaseRepository<typeof trainers, Trainer, NewTrainer> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, trainers);
  }

  async findManyFiltered(params: TrainerFilterParams): Promise<TrainerFilterResult> {
    const { limit, offset, q } = params;
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (q) {
      const pattern = `%${q}%`;
      conditions.push(
        or(like(trainers.first_name, pattern), like(trainers.last_name, pattern))!,
      );
    }

    const isActive =
      params.is_active ??
      (params.status === 'active' ? true : params.status === 'inactive' ? false : undefined);
    if (isActive !== undefined) {
      conditions.push(eq(trainers.is_active, isActive));
    }

    const where =
      conditions.length === 0
        ? undefined
        : conditions.length === 1
        ? conditions[0]
        : and(...conditions);

    let rowsQuery = db.select().from(trainers);
    let countQuery = db.select({ value: count() }).from(trainers);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as Trainer[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async updateTrainer(id: number, values: Partial<NewTrainer>): Promise<void> {
    await this.update(eq(trainers.id, id), values);
  }

  async countTotal(): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db.select({ value: count() }).from(trainers);
    return Number(rows[0]?.value ?? 0);
  }

  async countActive(): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ value: count() })
      .from(trainers)
      .where(eq(trainers.is_active, true));
    return Number(rows[0]?.value ?? 0);
  }

  async countAssignedMembers(trainerId: number): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ value: count() })
      .from(members)
      .where(eq(members.assigned_trainer_id, trainerId));
    return Number(rows[0]?.value ?? 0);
  }

  async countAssignedMembersForIds(trainerIds: number[]): Promise<Map<number, number>> {
    const result = new Map<number, number>();
    if (trainerIds.length === 0) return result;
    // Simple per-id counts keep MariaDB SQL portable without GROUP BY edge cases.
    await Promise.all(
      trainerIds.map(async (id) => {
        result.set(id, await this.countAssignedMembers(id));
      }),
    );
    return result;
  }
}
