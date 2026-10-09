import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  memberHealth,
  type MemberHealth,
  type NewMemberHealth,
} from '../platform/db/schema/member-health';

@Injectable()
export class MemberHealthRepository extends BaseRepository<
  typeof memberHealth,
  MemberHealth,
  NewMemberHealth
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, memberHealth);
  }

  async findManyByMemberId(
    memberId: number,
    options: { limit: number; offset: number },
  ): Promise<{ rows: MemberHealth[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(memberHealth.member_id, memberId);

    const [rows, totalResult] = await Promise.all([
      db
        .select()
        .from(memberHealth)
        .where(where)
        .orderBy(desc(memberHealth.recorded_at), desc(memberHealth.id))
        .limit(options.limit)
        .offset(options.offset),
      db.select({ total: count() }).from(memberHealth).where(where),
    ]);

    const total = Number(totalResult?.[0]?.total ?? 0);
    return { rows, total };
  }

  async findByIdAndMemberId(id: number, memberId: number): Promise<MemberHealth | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(memberHealth)
      .where(and(eq(memberHealth.id, id), eq(memberHealth.member_id, memberId)))
      .limit(1);
    return rows[0] ?? null;
  }

  async insertRecord(values: NewMemberHealth): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }
}
