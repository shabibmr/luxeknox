import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, gte, lte, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  goalMetrics,
  measurements,
  measurementValues,
  type Measurement,
  type MeasurementValue,
  type NewMeasurement,
} from '../platform/db/schema/goals';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface MeasurementValueDetail extends MeasurementValue {
  metric_name?: string;
  unit_of_measure?: string;
}

export interface MeasurementWithValues extends Measurement {
  values: MeasurementValueDetail[];
}

export interface LongitudinalDataPoint {
  measurement_id: number;
  recorded_at: Date;
  metric_id: number;
  metric_name: string;
  unit_of_measure: string;
  value: number;
}

@Injectable()
export class MeasurementRepository extends BaseRepository<
  typeof measurements,
  Measurement,
  NewMeasurement
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, measurements);
  }

  async createWithValues(
    data: {
      member_id: number;
      recorded_by_user_id: number;
      recorded_at: Date;
      notes?: string | null;
      values: Array<{ metric_id: number; value: number }>;
    },
  ): Promise<MeasurementWithValues> {
    return this.db.transaction(async (tx) => {
      const [insertResult] = await tx.insert(measurements).values({
        member_id: data.member_id,
        recorded_by_user_id: data.recorded_by_user_id,
        recorded_at: data.recorded_at,
        notes: data.notes ?? null,
        created_at: new Date(),
      });

      const measurementId = insertResult.insertId;

      if (data.values.length > 0) {
        await tx.insert(measurementValues).values(
          data.values.map((v) => ({
            measurement_id: measurementId,
            metric_id: v.metric_id,
            value: v.value,
          })),
        );
      }

      const [session] = await tx
        .select()
        .from(measurements)
        .where(eq(measurements.id, measurementId));

      const capturedValues = await tx
        .select({
          id: measurementValues.id,
          measurement_id: measurementValues.measurement_id,
          metric_id: measurementValues.metric_id,
          value: measurementValues.value,
          metric_name: goalMetrics.name,
          unit_of_measure: goalMetrics.unit_of_measure,
        })
        .from(measurementValues)
        .innerJoin(goalMetrics, eq(measurementValues.metric_id, goalMetrics.id))
        .where(eq(measurementValues.measurement_id, measurementId));

      return {
        ...session,
        values: capturedValues,
      };
    });
  }

  async findByIdWithValues(id: number): Promise<MeasurementWithValues | null> {
    const [session] = await this.db
      .select()
      .from(measurements)
      .where(eq(measurements.id, id));

    if (!session) return null;

    const values = await this.db
      .select({
        id: measurementValues.id,
        measurement_id: measurementValues.measurement_id,
        metric_id: measurementValues.metric_id,
        value: measurementValues.value,
        metric_name: goalMetrics.name,
        unit_of_measure: goalMetrics.unit_of_measure,
      })
      .from(measurementValues)
      .innerJoin(goalMetrics, eq(measurementValues.metric_id, goalMetrics.id))
      .where(eq(measurementValues.measurement_id, id));

    return {
      ...session,
      values,
    };
  }

  async findManyByMemberId(
    memberId: number,
    options?: { limit?: number; offset?: number; from?: Date; to?: Date },
  ): Promise<{ rows: MeasurementWithValues[]; total: number }> {
    const conditions: SQL[] = [eq(measurements.member_id, memberId)];

    if (options?.from) {
      conditions.push(gte(measurements.recorded_at, options.from));
    }
    if (options?.to) {
      conditions.push(lte(measurements.recorded_at, options.to));
    }

    const where = and(...conditions);

    const query = this.db
      .select()
      .from(measurements)
      .where(where)
      .orderBy(desc(measurements.recorded_at));

    if (options?.limit) {
      query.limit(options.limit);
    }
    if (options?.offset) {
      query.offset(options.offset);
    }

    const sessions = await query;
    if (sessions.length === 0) {
      return { rows: [], total: 0 };
    }

    const sessionIds = sessions.map((s) => s.id);

    const allValues = await this.db
      .select({
        id: measurementValues.id,
        measurement_id: measurementValues.measurement_id,
        metric_id: measurementValues.metric_id,
        value: measurementValues.value,
        metric_name: goalMetrics.name,
        unit_of_measure: goalMetrics.unit_of_measure,
      })
      .from(measurementValues)
      .innerJoin(goalMetrics, eq(measurementValues.metric_id, goalMetrics.id))
      .where(eq(measurements.member_id, memberId));

    const valuesBySession = new Map<number, MeasurementValueDetail[]>();
    for (const val of allValues) {
      const list = valuesBySession.get(val.measurement_id) ?? [];
      list.push(val);
      valuesBySession.set(val.measurement_id, list);
    }

    const rows: MeasurementWithValues[] = sessions.map((s) => ({
      ...s,
      values: valuesBySession.get(s.id) ?? [],
    }));

    return {
      rows,
      total: rows.length,
    };
  }

  async findLongitudinalSeries(
    memberId: number,
    metricId: number,
    from?: Date,
    to?: Date,
  ): Promise<LongitudinalDataPoint[]> {
    const conditions: SQL[] = [
      eq(measurements.member_id, memberId),
      eq(measurementValues.metric_id, metricId),
    ];

    if (from) {
      conditions.push(gte(measurements.recorded_at, from));
    }
    if (to) {
      conditions.push(lte(measurements.recorded_at, to));
    }

    const rows = await this.db
      .select({
        measurement_id: measurements.id,
        recorded_at: measurements.recorded_at,
        metric_id: measurementValues.metric_id,
        metric_name: goalMetrics.name,
        unit_of_measure: goalMetrics.unit_of_measure,
        value: measurementValues.value,
      })
      .from(measurementValues)
      .innerJoin(measurements, eq(measurementValues.measurement_id, measurements.id))
      .innerJoin(goalMetrics, eq(measurementValues.metric_id, goalMetrics.id))
      .where(and(...conditions))
      .orderBy(asc(measurements.recorded_at));

    return rows;
  }
}
