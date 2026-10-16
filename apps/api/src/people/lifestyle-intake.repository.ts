import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  memberLifestyleIntakes,
  type MemberLifestyleIntake,
  type NewMemberLifestyleIntake,
} from '../platform/db/schema/lifestyle-intake';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class LifestyleIntakeRepository extends BaseRepository<
  typeof memberLifestyleIntakes,
  MemberLifestyleIntake,
  NewMemberLifestyleIntake
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, memberLifestyleIntakes);
  }

  async findByMemberId(memberId: number): Promise<MemberLifestyleIntake | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(memberLifestyleIntakes)
      .where(eq(memberLifestyleIntakes.member_id, memberId))
      .limit(1);
    return rows[0] ?? null;
  }

  async insert(values: NewMemberLifestyleIntake): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateByMemberId(
    memberId: number,
    values: Partial<NewMemberLifestyleIntake>,
  ): Promise<void> {
    const db = this.getDb() as any;
    await db
      .update(memberLifestyleIntakes)
      .set(values)
      .where(eq(memberLifestyleIntakes.member_id, memberId));
  }
}
