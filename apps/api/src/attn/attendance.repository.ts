import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, isNull, lt, lte, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  attendanceHistories,
  attendances,
  type Attendance,
  type AttendanceHistory,
  type NewAttendance,
  type NewAttendanceHistory,
} from '../platform/db/schema/attendance';
import { members } from '../platform/db/schema/members';
import { users } from '../platform/db/schema/users';

export type AttendanceListScope =
  | { type: 'all' }
  | { type: 'self'; userId: number }
  | { type: 'trainer'; trainerProfileId: number };

export interface AttendanceListParams {
  scope: AttendanceListScope;
  userId?: number;
  from?: Date;
  to?: Date;
  limit: number;
  /** Cursor: rows strictly older than this check_in_time/id pair (desc). */
  cursor?: { checkInTime: Date; id: number };
}

@Injectable()
export class AttendanceRepository extends BaseRepository<
  typeof attendances,
  Attendance,
  NewAttendance
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, attendances);
  }

  async findOpenByUserIdForUpdate(userId: number): Promise<Attendance | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(attendances)
      .where(and(eq(attendances.user_id, userId), isNull(attendances.check_out_time)))
      .orderBy(sql`${attendances.check_in_time} desc`)
      .limit(1)
      .for('update');
    return rows[0] ?? null;
  }

  async findOpenByUserId(userId: number): Promise<Attendance | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(attendances)
      .where(and(eq(attendances.user_id, userId), isNull(attendances.check_out_time)))
      .orderBy(sql`${attendances.check_in_time} desc`)
      .limit(1);
    return rows[0] ?? null;
  }

  async countCheckInsForUserBetween(
    userId: number,
    dayStart: Date,
    dayEnd: Date,
  ): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ value: count() })
      .from(attendances)
      .where(
        and(
          eq(attendances.user_id, userId),
          gte(attendances.check_in_time, dayStart),
          lt(attendances.check_in_time, dayEnd),
        ),
      );
    return Number(rows[0]?.value ?? 0);
  }

  async insertCheckIn(row: NewAttendance): Promise<Attendance> {
    const db = this.getDb() as any;
    const result = await db.insert(attendances).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load attendance ${id} after insert`);
    }
    return created;
  }

  async setCheckOut(id: number, checkOutTime: Date): Promise<Attendance | null> {
    const db = this.getDb() as any;
    await db
      .update(attendances)
      .set({ check_out_time: checkOutTime, updated_at: checkOutTime })
      .where(eq(attendances.id, id));
    return this.findById(id);
  }

  private buildListConditions(params: AttendanceListParams): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.userId != null) {
      conditions.push(eq(attendances.user_id, params.userId));
    }
    if (params.from) {
      conditions.push(gte(attendances.check_in_time, params.from));
    }
    if (params.to) {
      conditions.push(lte(attendances.check_in_time, params.to));
    }
    if (params.scope.type === 'self') {
      conditions.push(eq(attendances.user_id, params.scope.userId));
    }
    if (params.cursor) {
      conditions.push(
        sql`(${attendances.check_in_time} < ${params.cursor.checkInTime} OR (${attendances.check_in_time} = ${params.cursor.checkInTime} AND ${attendances.id} < ${params.cursor.id}))`,
      );
    }

    if (conditions.length === 0) return undefined;
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findManyFiltered(params: AttendanceListParams): Promise<Attendance[]> {
    const db = this.getDb() as any;
    const where = this.buildListConditions(params);

    if (params.scope.type === 'trainer') {
      const conditions: SQL[] = [
        eq(members.assigned_trainer_id, params.scope.trainerProfileId),
      ];
      if (where) conditions.push(where);
      return db
        .select({
          id: attendances.id,
          user_id: attendances.user_id,
          check_in_time: attendances.check_in_time,
          check_out_time: attendances.check_out_time,
          method: attendances.method,
          gate_identifier: attendances.gate_identifier,
          verified_by_user_id: attendances.verified_by_user_id,
          created_at: attendances.created_at,
          updated_at: attendances.updated_at,
        })
        .from(attendances)
        .innerJoin(members, eq(members.user_id, attendances.user_id))
        .where(and(...conditions))
        .orderBy(desc(attendances.check_in_time), desc(attendances.id))
        .limit(params.limit + 1);
    }

    let q = db.select().from(attendances);
    if (where) q = q.where(where);
    return q.orderBy(desc(attendances.check_in_time), desc(attendances.id)).limit(params.limit + 1);
  }

  /** Distinct UTC dates (YYYY-MM-DD) with check-ins for a user, newest first. */
  async listCheckInDatesDesc(userId: number, limit = 400): Promise<string[]> {
    const db = this.getDb() as any;
    const rows = await db
      .selectDistinct({
        day: sql<string>`DATE(${attendances.check_in_time})`.as('day'),
      })
      .from(attendances)
      .where(eq(attendances.user_id, userId))
      .orderBy(sql`DATE(${attendances.check_in_time}) desc`)
      .limit(limit);
    return rows.map((r: { day: string }) => String(r.day).slice(0, 10));
  }

  async findLatestCheckIn(userId: number): Promise<Attendance | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(attendances)
      .where(eq(attendances.user_id, userId))
      .orderBy(desc(attendances.check_in_time))
      .limit(1);
    return rows[0] ?? null;
  }

  async findOpenOlderThan(cutoff: Date): Promise<Attendance[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(attendances)
      .where(and(isNull(attendances.check_out_time), lt(attendances.check_in_time, cutoff)));
  }

  /** ATT-017: currently checked-in (open) gate visits, optionally grouped by gate. */
  async getOccupancySnapshot(): Promise<{
    checked_in_now: number;
    by_gate: Array<{ gate_identifier: string | null; count: number }>;
  }> {
    const db = this.getDb() as any;
    const totalRows = await db
      .select({ value: count() })
      .from(attendances)
      .where(isNull(attendances.check_out_time));
    const byGateRows: Array<{ gate_identifier: string | null; value: number }> = await db
      .select({
        gate_identifier: attendances.gate_identifier,
        value: count(),
      })
      .from(attendances)
      .where(isNull(attendances.check_out_time))
      .groupBy(attendances.gate_identifier);

    return {
      checked_in_now: Number(totalRows[0]?.value ?? 0),
      by_gate: byGateRows.map((r) => ({
        gate_identifier: r.gate_identifier,
        count: Number(r.value),
      })),
    };
  }

  /**
   * Aggregate gate check-ins for a UTC calendar day into member vs trainer counts
   * and peak hour.
   */
  async aggregateDay(dayStart: Date, dayEnd: Date): Promise<{
    total_member_checkins: number;
    total_trainer_checkins: number;
    peak_hour: number | null;
    peak_count: number | null;
  }> {
    const db = this.getDb() as any;
    const byType: Array<{ user_type: string; value: number }> = await db
      .select({
        user_type: users.user_type,
        value: count(),
      })
      .from(attendances)
      .innerJoin(users, eq(users.id, attendances.user_id))
      .where(
        and(gte(attendances.check_in_time, dayStart), lt(attendances.check_in_time, dayEnd)),
      )
      .groupBy(users.user_type);

    let total_member_checkins = 0;
    let total_trainer_checkins = 0;
    for (const row of byType) {
      const n = Number(row.value);
      if (row.user_type === 'member') total_member_checkins += n;
      if (row.user_type === 'trainer') total_trainer_checkins += n;
    }

    const byHour: Array<{ hour: number; value: number }> = await db
      .select({
        hour: sql<number>`HOUR(${attendances.check_in_time})`.as('hour'),
        value: count(),
      })
      .from(attendances)
      .where(
        and(gte(attendances.check_in_time, dayStart), lt(attendances.check_in_time, dayEnd)),
      )
      .groupBy(sql`HOUR(${attendances.check_in_time})`)
      .orderBy(desc(count()))
      .limit(1);

    const peak = byHour[0];
    return {
      total_member_checkins,
      total_trainer_checkins,
      peak_hour: peak ? Number(peak.hour) : null,
      peak_count: peak ? Number(peak.value) : null,
    };
  }

  async upsertHistory(row: NewAttendanceHistory): Promise<AttendanceHistory> {
    const db = this.getDb() as any;
    await db
      .insert(attendanceHistories)
      .values(row)
      .onDuplicateKeyUpdate({
        set: {
          total_member_checkins: row.total_member_checkins,
          total_trainer_checkins: row.total_trainer_checkins,
          peak_hour: row.peak_hour,
          peak_count: row.peak_count,
          updated_at: row.updated_at ?? row.created_at,
        },
      });

    const rows = await db
      .select()
      .from(attendanceHistories)
      .where(eq(attendanceHistories.date, row.date))
      .limit(1);
    return rows[0];
  }

  async listHistories(params: {
    from?: string;
    to?: string;
    limit: number;
    cursorId?: number;
  }): Promise<AttendanceHistory[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];
    if (params.from) conditions.push(gte(attendanceHistories.date, params.from));
    if (params.to) conditions.push(lte(attendanceHistories.date, params.to));
    if (params.cursorId != null) {
      conditions.push(lt(attendanceHistories.id, params.cursorId));
    }
    let q = db.select().from(attendanceHistories);
    if (conditions.length) {
      q = q.where(conditions.length === 1 ? conditions[0] : and(...conditions));
    }
    return q.orderBy(desc(attendanceHistories.date), desc(attendanceHistories.id)).limit(params.limit + 1);
  }
}
