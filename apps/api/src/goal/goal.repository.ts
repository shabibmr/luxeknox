import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  goalHistories,
  goalMetrics,
  goals,
  type Goal,
  type GoalHistory,
  type GoalMetric,
  type NewGoal,
  type NewGoalHistory,
} from '../platform/db/schema/goals';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface GoalWithMetric extends Goal {
  metric: GoalMetric;
}

export interface GoalWithDetail extends GoalWithMetric {
  histories: GoalHistory[];
}

@Injectable()
export class GoalRepository extends BaseRepository<typeof goals, Goal, NewGoal> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, goals);
  }

  async findManyByMemberId(
    memberId: number,
    options?: { status?: string; metricId?: number; limit?: number; offset?: number },
  ): Promise<{ rows: GoalWithMetric[]; total: number }> {
    const conditions: SQL[] = [eq(goals.member_id, memberId)];

    if (options?.status) {
      conditions.push(eq(goals.status, options.status));
    }
    if (options?.metricId) {
      conditions.push(eq(goals.metric_id, options.metricId));
    }

    const where = and(...conditions);

    const query = this.db
      .select({
        goal: goals,
        metric: goalMetrics,
      })
      .from(goals)
      .innerJoin(goalMetrics, eq(goals.metric_id, goalMetrics.id))
      .where(where)
      .orderBy(desc(goals.created_at));

    if (options?.limit) {
      query.limit(options.limit);
    }
    if (options?.offset) {
      query.offset(options.offset);
    }

    const results = await query;
    const rows: GoalWithMetric[] = results.map((r) => ({
      ...r.goal,
      metric: r.metric,
    }));

    return {
      rows,
      total: rows.length,
    };
  }

  async findByIdWithMetric(goalId: number): Promise<GoalWithMetric | null> {
    const [result] = await this.db
      .select({
        goal: goals,
        metric: goalMetrics,
      })
      .from(goals)
      .innerJoin(goalMetrics, eq(goals.metric_id, goalMetrics.id))
      .where(eq(goals.id, goalId));

    if (!result) return null;

    return {
      ...result.goal,
      metric: result.metric,
    };
  }

  async findByIdWithDetail(goalId: number): Promise<GoalWithDetail | null> {
    const goalWithMetric = await this.findByIdWithMetric(goalId);
    if (!goalWithMetric) return null;

    const histories = await this.db
      .select()
      .from(goalHistories)
      .where(eq(goalHistories.goal_id, goalId))
      .orderBy(desc(goalHistories.recorded_date), desc(goalHistories.created_at));

    return {
      ...goalWithMetric,
      histories,
    };
  }

  async findActiveByMemberIdAndMetricId(
    memberId: number,
    metricId: number,
  ): Promise<Goal[]> {
    return this.db
      .select()
      .from(goals)
      .where(
        and(
          eq(goals.member_id, memberId),
          eq(goals.metric_id, metricId),
          eq(goals.status, 'in_progress'),
        ),
      );
  }

  async addHistory(newHistory: NewGoalHistory): Promise<GoalHistory> {
    const [idResult] = await this.db.insert(goalHistories).values(newHistory);
    const [row] = await this.db
      .select()
      .from(goalHistories)
      .where(eq(goalHistories.id, idResult.insertId));
    return row;
  }

  async listHistories(goalId: number): Promise<GoalHistory[]> {
    return this.db
      .select()
      .from(goalHistories)
      .where(eq(goalHistories.goal_id, goalId))
      .orderBy(desc(goalHistories.recorded_date), desc(goalHistories.created_at));
  }

  async updateById(id: number, values: Partial<NewGoal>): Promise<Goal | null> {
    await this.update(eq(goals.id, id), values);
    return this.findById(id);
  }
}
