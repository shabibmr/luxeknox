import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
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

  async findByMemberId(memberId: number): Promise<MemberHealth | null> {
    return this.findOne(eq(memberHealth.member_id, memberId));
  }

  async upsertForMember(memberId: number, values: Omit<NewMemberHealth, 'member_id' | 'id'>): Promise<number> {
    const existing = await this.findByMemberId(memberId);
    if (existing) {
      await this.update(eq(memberHealth.id, existing.id), {
        ...values,
        updated_at: values.updated_at ?? new Date(),
      });
      return existing.id;
    }
    const result = await this.create({ ...values, member_id: memberId });
    return Number(result?.[0]?.insertId ?? 0);
  }
}
