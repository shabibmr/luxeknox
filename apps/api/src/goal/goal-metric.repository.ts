import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  goalMetrics,
  type GoalMetric,
  type NewGoalMetric,
} from '../platform/db/schema/goals';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface GoalMetricFilterParams {
  category?: string;
  isActive?: boolean;
  q?: string;
  limit: number;
  offset: number;
}

export interface GoalMetricFilterResult {
  rows: GoalMetric[];
  total: number;
}

@Injectable()
export class GoalMetricRepository extends BaseRepository<
  typeof goalMetrics,
  GoalMetric,
  NewGoalMetric
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, goalMetrics);
  }

  private buildFilterConditions(
    params: Omit<GoalMetricFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.isActive !== undefined) {
      conditions.push(eq(goalMetrics.is_active, params.isActive));
    }
    if (params.category) {
      conditions.push(eq(goalMetrics.category, params.category));
    }
    if (params.q) {
      conditions.push(like(goalMetrics.name, `%${params.q}%`));
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findManyFiltered(params: GoalMetricFilterParams): Promise<GoalMetricFilterResult> {
    const where = this.buildFilterConditions(params);

    const [countResult] = await this.db
      .select({ count: count() })
      .from(goalMetrics)
      .where(where);

    const rows = await this.db
      .select()
      .from(goalMetrics)
      .where(where)
      .limit(params.limit)
      .offset(params.offset);

    return {
      rows,
      total: countResult?.count ?? 0,
    };
  }

  async updateById(id: number, values: Partial<NewGoalMetric>): Promise<GoalMetric | null> {
    await this.update(eq(goalMetrics.id, id), values);
    return this.findById(id);
  }
}
