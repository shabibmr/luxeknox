import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, eq, gt, gte, inArray, lt, ne, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  scheduleHistories,
  scheduleParticipants,
  schedules,
  type NewSchedule,
  type NewScheduleHistory,
  type NewScheduleParticipant,
  type Schedule,
  type ScheduleHistory,
  type ScheduleParticipant,
} from '../platform/db/schema/scheduling';
import { ACTIVE_SCHEDULE_STATUSES } from './schedule-conflict';

export const ACTIVE_BOOKING_STATUSES = ['booked', 'waitlisted'] as const;

export interface ScheduleListFilters {
  from?: Date;
  to?: Date;
  trainerId?: number;
  memberId?: number;
  trainerScopeId?: number;
  memberScopeId?: number;
  limit: number;
  offset: number;
}

@Injectable()
export class ScheduleRepository extends BaseRepository<typeof schedules, Schedule, NewSchedule> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, schedules);
  }

  private buildListWhere(filters: ScheduleListFilters): SQL | undefined {
    const conditions: SQL[] = [];

    // Overlap semantics: a schedule matches [from, to] if any part of its
    // [start_time, end_time) interval intersects the requested window, not
    // only if it starts inside the window. This lets the calendar surface
    // long-running sessions that started before `from` but are still active.
    if (filters.from) {
      conditions.push(gt(schedules.end_time, filters.from));
    }
    if (filters.to) {
      conditions.push(lt(schedules.start_time, filters.to));
    }
    if (filters.trainerId) {
      conditions.push(eq(schedules.trainer_id, filters.trainerId));
    }
    if (filters.trainerScopeId) {
      conditions.push(eq(schedules.trainer_id, filters.trainerScopeId));
    }
    if (filters.memberScopeId) {
      conditions.push(
        sql`${schedules.id} IN (
          SELECT ${scheduleParticipants.schedule_id}
          FROM ${scheduleParticipants}
          WHERE ${scheduleParticipants.member_id} = ${filters.memberScopeId}
            AND ${scheduleParticipants.booking_status} != 'cancelled'
        )`,
      );
    }
    if (filters.memberId) {
      conditions.push(
        sql`${schedules.id} IN (
          SELECT ${scheduleParticipants.schedule_id}
          FROM ${scheduleParticipants}
          WHERE ${scheduleParticipants.member_id} = ${filters.memberId}
            AND ${scheduleParticipants.booking_status} != 'cancelled'
        )`,
      );
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findManyFiltered(filters: ScheduleListFilters): Promise<{ rows: Schedule[]; total: number }> {
    const db = this.getDb() as any;
    const where = this.buildListWhere(filters);

    let rowsQuery = db.select().from(schedules);
    let countQuery = db.select({ value: count() }).from(schedules);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.orderBy(schedules.start_time).limit(filters.limit).offset(filters.offset),
      countQuery,
    ]);

    return {
      rows: rows as Schedule[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async insertSchedule(values: NewSchedule): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateSchedule(id: number, values: Partial<NewSchedule>): Promise<void> {
    await this.update(eq(schedules.id, id), values);
  }

  async findOverlappingForTrainer(
    trainerId: number,
    startTime: Date,
    endTime: Date,
    excludeId?: number,
  ): Promise<Schedule[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(schedules.trainer_id, trainerId),
      inArray(schedules.status, [...ACTIVE_SCHEDULE_STATUSES]),
      sql`${schedules.start_time} < ${endTime}`,
      sql`${schedules.end_time} > ${startTime}`,
    ];
    if (excludeId) {
      conditions.push(ne(schedules.id, excludeId));
    }

    const rows = await db
      .select()
      .from(schedules)
      .where(and(...conditions));
    return rows as Schedule[];
  }

  async findOverlappingForFacility(
    facilityId: number,
    startTime: Date,
    endTime: Date,
    excludeId?: number,
  ): Promise<Schedule[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(schedules.facility_id, facilityId),
      inArray(schedules.status, [...ACTIVE_SCHEDULE_STATUSES]),
      sql`${schedules.start_time} < ${endTime}`,
      sql`${schedules.end_time} > ${startTime}`,
    ];
    if (excludeId) {
      conditions.push(ne(schedules.id, excludeId));
    }

    const rows = await db
      .select()
      .from(schedules)
      .where(and(...conditions));
    return rows as Schedule[];
  }

  async findFutureBySeriesId(seriesId: number, fromTime: Date): Promise<Schedule[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(schedules)
      .where(
        and(
          eq(schedules.series_id, seriesId),
          gte(schedules.start_time, fromTime),
          ne(schedules.status, 'cancelled'),
        ),
      )
      .orderBy(schedules.start_time);
    return rows as Schedule[];
  }

  async findBusyForTrainer(trainerId: number, from: Date, to: Date): Promise<Schedule[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(schedules)
      .where(
        and(
          eq(schedules.trainer_id, trainerId),
          inArray(schedules.status, [...ACTIVE_SCHEDULE_STATUSES]),
          sql`${schedules.start_time} < ${to}`,
          sql`${schedules.end_time} > ${from}`,
        ),
      );
    return rows as Schedule[];
  }

  /**
   * Locks the schedule row for the duration of the ambient transaction via `SELECT ... FOR UPDATE`,
   * serializing concurrent booking attempts against the same schedule so capacity checks
   * (count booked participants vs. max_capacity) cannot race across two DB connections.
   * Must be called from inside `runInTransaction`.
   */
  async lockScheduleForUpdate(scheduleId: number): Promise<{ id: number; max_capacity: number } | null> {
    const db = this.getDb() as any;
    const result = await db.execute(
      sql`SELECT \`id\`, \`max_capacity\` FROM \`schedules\` WHERE \`id\` = ${scheduleId} FOR UPDATE`,
    );
    const rows = Array.isArray(result) ? (Array.isArray(result[0]) ? result[0] : result) : [];
    const row = rows[0] as { id?: unknown; max_capacity?: unknown } | undefined;
    if (!row || row.id == null) {
      return null;
    }
    return { id: Number(row.id), max_capacity: Number(row.max_capacity) };
  }

  async listParticipants(scheduleId: number): Promise<ScheduleParticipant[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(scheduleParticipants)
      .where(eq(scheduleParticipants.schedule_id, scheduleId));
    return rows as ScheduleParticipant[];
  }

  async cancelParticipants(scheduleId: number): Promise<void> {
    await (this.getDb() as any)
      .update(scheduleParticipants)
      .set({ booking_status: 'cancelled' })
      .where(eq(scheduleParticipants.schedule_id, scheduleId));
  }

  async insertHistory(values: NewScheduleHistory): Promise<void> {
    await (this.getDb() as any).insert(scheduleHistories).values(values);
  }

  async findParticipant(scheduleId: number, memberId: number): Promise<ScheduleParticipant | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(scheduleParticipants)
      .where(
        and(
          eq(scheduleParticipants.schedule_id, scheduleId),
          eq(scheduleParticipants.member_id, memberId),
        ),
      )
      .limit(1);
    return (rows[0] as ScheduleParticipant | undefined) ?? null;
  }

  async findParticipantById(
    scheduleId: number,
    participantId: number,
  ): Promise<ScheduleParticipant | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(scheduleParticipants)
      .where(
        and(
          eq(scheduleParticipants.id, participantId),
          eq(scheduleParticipants.schedule_id, scheduleId),
        ),
      )
      .limit(1);
    return (rows[0] as ScheduleParticipant | undefined) ?? null;
  }

  async insertParticipant(values: NewScheduleParticipant): Promise<number> {
    const result = await (this.getDb() as any).insert(scheduleParticipants).values(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateParticipant(id: number, values: Partial<NewScheduleParticipant>): Promise<void> {
    await (this.getDb() as any)
      .update(scheduleParticipants)
      .set(values)
      .where(eq(scheduleParticipants.id, id));
  }

  async countBookedParticipants(scheduleId: number, excludeParticipantId?: number): Promise<number> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(scheduleParticipants.schedule_id, scheduleId),
      eq(scheduleParticipants.booking_status, 'booked'),
    ];
    if (excludeParticipantId) {
      conditions.push(ne(scheduleParticipants.id, excludeParticipantId));
    }
    const rows = await db
      .select({ value: count() })
      .from(scheduleParticipants)
      .where(and(...conditions));
    return Number(rows[0]?.value ?? 0);
  }

  async countActiveBookingsForMember(memberId: number, from: Date, excludeScheduleId?: number): Promise<number> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(scheduleParticipants.member_id, memberId),
      inArray(scheduleParticipants.booking_status, [...ACTIVE_BOOKING_STATUSES]),
      gt(schedules.start_time, from),
      inArray(schedules.status, [...ACTIVE_SCHEDULE_STATUSES]),
    ];
    if (excludeScheduleId) {
      conditions.push(ne(scheduleParticipants.schedule_id, excludeScheduleId));
    }
    const rows = await db
      .select({ value: count() })
      .from(scheduleParticipants)
      .innerJoin(schedules, eq(scheduleParticipants.schedule_id, schedules.id))
      .where(and(...conditions));
    return Number(rows[0]?.value ?? 0);
  }

  async findOverlappingBookedForMember(
    memberId: number,
    startTime: Date,
    endTime: Date,
    excludeScheduleId?: number,
  ): Promise<Schedule[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(scheduleParticipants.member_id, memberId),
      eq(scheduleParticipants.booking_status, 'booked'),
      inArray(schedules.status, [...ACTIVE_SCHEDULE_STATUSES]),
      sql`${schedules.start_time} < ${endTime}`,
      sql`${schedules.end_time} > ${startTime}`,
    ];
    if (excludeScheduleId) {
      conditions.push(ne(scheduleParticipants.schedule_id, excludeScheduleId));
    }
    const rows = await db
      .select({
        id: schedules.id,
        series_id: schedules.series_id,
        schedule_type_id: schedules.schedule_type_id,
        facility_id: schedules.facility_id,
        trainer_id: schedules.trainer_id,
        title: schedules.title,
        start_time: schedules.start_time,
        end_time: schedules.end_time,
        max_capacity: schedules.max_capacity,
        status: schedules.status,
        notes: schedules.notes,
        row_version: schedules.row_version,
        created_at: schedules.created_at,
        updated_at: schedules.updated_at,
      })
      .from(scheduleParticipants)
      .innerJoin(schedules, eq(scheduleParticipants.schedule_id, schedules.id))
      .where(and(...conditions));
    return rows as Schedule[];
  }

  async listHistory(scheduleId: number, limit: number): Promise<ScheduleHistory[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(scheduleHistories)
      .where(eq(scheduleHistories.schedule_id, scheduleId))
      .orderBy(scheduleHistories.timestamp, scheduleHistories.id)
      .limit(limit);
    return rows as ScheduleHistory[];
  }

  async findEarliestWaitlisted(scheduleId: number): Promise<ScheduleParticipant | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(scheduleParticipants)
      .where(
        and(
          eq(scheduleParticipants.schedule_id, scheduleId),
          eq(scheduleParticipants.booking_status, 'waitlisted'),
        ),
      )
      .orderBy(asc(scheduleParticipants.booked_at))
      .limit(1);
    return (rows[0] as ScheduleParticipant | undefined) ?? null;
  }
}
