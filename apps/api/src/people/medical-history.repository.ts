import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  medicalHistories,
  type MedicalHistory,
  type NewMedicalHistory,
} from '../platform/db/schema/medical-histories';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class MedicalHistoryRepository extends BaseRepository<
  typeof medicalHistories,
  MedicalHistory,
  NewMedicalHistory
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, medicalHistories);
  }

  async findManyByMemberId(
    memberId: number,
    options: { limit: number; offset: number },
  ): Promise<{ rows: MedicalHistory[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(medicalHistories.member_id, memberId);

    const [rows, totalResult] = await Promise.all([
      db
        .select()
        .from(medicalHistories)
        .where(where)
        .orderBy(desc(medicalHistories.id))
        .limit(options.limit)
        .offset(options.offset),
      db.select({ total: count() }).from(medicalHistories).where(where),
    ]);

    const total = Number(totalResult?.[0]?.total ?? 0);
    return { rows, total };
  }

  async findByIdAndMemberId(id: number, memberId: number): Promise<MedicalHistory | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(medicalHistories)
      .where(and(eq(medicalHistories.id, id), eq(medicalHistories.member_id, memberId)))
      .limit(1);
    return rows[0] ?? null;
  }

  async insertHistory(values: NewMedicalHistory): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateHistory(id: number, memberId: number, values: Partial<NewMedicalHistory>): Promise<void> {
    const db = this.getDb() as any;
    await db
      .update(medicalHistories)
      .set(values)
      .where(and(eq(medicalHistories.id, id), eq(medicalHistories.member_id, memberId)));
  }

  async deleteHistory(id: number, memberId: number): Promise<void> {
    const db = this.getDb() as any;
    await db
      .delete(medicalHistories)
      .where(and(eq(medicalHistories.id, id), eq(medicalHistories.member_id, memberId)));
  }
}
