import { Inject, Injectable } from '@nestjs/common';
import { desc, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  parQScreenings,
  type NewParQScreening,
  type ParQScreening,
} from '../platform/db/schema/par-q';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class ParQRepository extends BaseRepository<
  typeof parQScreenings,
  ParQScreening,
  NewParQScreening
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, parQScreenings);
  }

  /** Newest screening wins: a resubmission supersedes earlier ones. */
  async findLatestByMemberId(memberId: number): Promise<ParQScreening | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(parQScreenings)
      .where(eq(parQScreenings.member_id, memberId))
      .orderBy(desc(parQScreenings.id))
      .limit(1);
    return rows[0] ?? null;
  }

  async insert(values: NewParQScreening): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateById(id: number, values: Partial<NewParQScreening>): Promise<void> {
    const db = this.getDb() as any;
    await db.update(parQScreenings).set(values).where(eq(parQScreenings.id, id));
  }
}
