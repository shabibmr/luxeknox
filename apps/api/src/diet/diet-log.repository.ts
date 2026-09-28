import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, lte, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  dietHistories,
  type DietHistory,
  type NewDietHistory,
} from '../platform/db/schema/diet';

export interface DietLogFilterParams {
  memberId: number;
  from?: string;
  to?: string;
  limit: number;
  offset: number;
}

export interface DietLogRollupSummary {
  logged_days: number;
  avg_calories_consumed: number;
  avg_adherence_score: number | null;
  avg_water_intake_ml: number | null;
}

@Injectable()
export class DietLogRepository extends BaseRepository<
  typeof dietHistories,
  DietHistory,
  NewDietHistory
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, dietHistories);
  }

  private buildFilterConditions(
    params: Omit<DietLogFilterParams, 'limit' | 'offset'>,
  ): SQL {
    const conditions: SQL[] = [eq(dietHistories.member_id, params.memberId)];

    if (params.from) {
      conditions.push(gte(dietHistories.logged_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(dietHistories.logged_date, params.to));
    }

    return conditions.length === 1 ? conditions[0] : and(...conditions)!;
  }

  async upsertLog(data: {
    member_id: number;
    diet_plan_id?: number | null;
    logged_date: string;
    total_calories_consumed: number;
    adherence_score?: number | null;
    water_intake_ml?: number | null;
    member_notes?: string | null;
  }): Promise<DietHistory> {
    const db = this.getDb() as any;
    const now = new Date();

    await db
      .insert(dietHistories)
      .values({
        member_id: data.member_id,
        diet_plan_id: data.diet_plan_id ?? null,
        logged_date: data.logged_date,
        total_calories_consumed: data.total_calories_consumed,
        adherence_score: data.adherence_score ?? null,
        water_intake_ml: data.water_intake_ml ?? null,
        member_notes: data.member_notes ?? null,
        created_at: now,
        updated_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          diet_plan_id: sql`VALUES(\`diet_plan_id\`)`,
          total_calories_consumed: sql`VALUES(\`total_calories_consumed\`)`,
          adherence_score: sql`VALUES(\`adherence_score\`)`,
          water_intake_ml: sql`VALUES(\`water_intake_ml\`)`,
          member_notes: sql`VALUES(\`member_notes\`)`,
          updated_at: now,
        },
      });

    const [row] = await db
      .select()
      .from(dietHistories)
      .where(
        and(
          eq(dietHistories.member_id, data.member_id),
          eq(dietHistories.logged_date, data.logged_date),
        ),
      )
      .limit(1);

    return row;
  }

  async findByMemberAndDate(memberId: number, loggedDate: string): Promise<DietHistory | null> {
    const db = this.getDb() as any;
    const [row] = await db
      .select()
      .from(dietHistories)
      .where(
        and(
          eq(dietHistories.member_id, memberId),
          eq(dietHistories.logged_date, loggedDate),
        ),
      )
      .limit(1);

    return row || null;
  }

  async findLogs(
    params: DietLogFilterParams,
  ): Promise<{ rows: DietHistory[]; total: number }> {
    const db = this.getDb() as any;
    const whereClause = this.buildFilterConditions(params);

    const [rows, countResult] = await Promise.all([
      db
        .select()
        .from(dietHistories)
        .where(whereClause)
        .orderBy(desc(dietHistories.logged_date))
        .limit(params.limit)
        .offset(params.offset),
      db.select({ count: dietHistories.id }).from(dietHistories).where(whereClause),
    ]);

    return { rows: rows as DietHistory[], total: countResult.length };
  }

  async getRollupSummary(
    memberId: number,
    from?: string,
    to?: string,
  ): Promise<DietLogRollupSummary> {
    const db = this.getDb() as any;
    const whereClause = this.buildFilterConditions({ memberId, from, to });

    const [result] = await db
      .select({
        count: sql<number>`count(${dietHistories.id})`,
        avgCalories: sql<number>`avg(${dietHistories.total_calories_consumed})`,
        avgAdherence: sql<number | null>`avg(${dietHistories.adherence_score})`,
        avgWater: sql<number | null>`avg(${dietHistories.water_intake_ml})`,
      })
      .from(dietHistories)
      .where(whereClause);

    const count = Number(result?.count ?? 0);
    const avgCalories = Number(result?.avgCalories ?? 0);
    const avgAdherence = result?.avgAdherence != null ? Number(result.avgAdherence) : null;
    const avgWater = result?.avgWater != null ? Number(result.avgWater) : null;

    return {
      logged_days: count,
      avg_calories_consumed: Math.round(avgCalories * 10) / 10,
      avg_adherence_score: avgAdherence != null ? Math.round(avgAdherence * 10) / 10 : null,
      avg_water_intake_ml: avgWater != null ? Math.round(avgWater) : null,
    };
  }
}
