import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  exercises,
  type Exercise,
} from '../platform/db/schema/exercises';
import {
  workoutPlans,
  workoutPlanVersions,
  workoutPlanExercises,
  type WorkoutPlan,
  type NewWorkoutPlan,
  type WorkoutPlanVersion,
  type NewWorkoutPlanVersion,
  type WorkoutPlanExercise,
  type NewWorkoutPlanExercise,
} from '../platform/db/schema/workout';
import { ConflictError } from '../platform/errors/app-error';

export interface WorkoutPlanFilterParams {
  memberId?: number;
  isTemplate?: boolean;
  trainerId?: number;
  status?: string;
  q?: string;
  limit: number;
  offset: number;
}

export interface WorkoutPlanWithDetails extends WorkoutPlan {
  current_version?: WorkoutPlanVersion & {
    exercises: (WorkoutPlanExercise & { exercise?: Exercise })[];
  };
}

@Injectable()
export class WorkoutPlanRepository extends BaseRepository<
  typeof workoutPlans,
  WorkoutPlan,
  NewWorkoutPlan
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, workoutPlans);
  }

  private buildFilterConditions(
    params: Omit<WorkoutPlanFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.isTemplate !== undefined) {
      conditions.push(eq(workoutPlans.is_template, params.isTemplate));
    }
    if (params.memberId !== undefined) {
      conditions.push(eq(workoutPlans.member_id, params.memberId));
    }
    if (params.trainerId !== undefined) {
      conditions.push(eq(workoutPlans.trainer_id, params.trainerId));
    }
    if (params.status !== undefined) {
      conditions.push(eq(workoutPlans.status, params.status));
    }
    if (params.q) {
      conditions.push(like(workoutPlans.title, `%${params.q}%`));
    }

    if (conditions.length === 0) return undefined;
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findPlans(
    params: WorkoutPlanFilterParams,
  ): Promise<{ rows: WorkoutPlanWithDetails[]; total: number }> {
    const db = this.getDb() as any;
    const whereClause = this.buildFilterConditions(params);

    let plansQuery = db
      .select()
      .from(workoutPlans)
      .orderBy(desc(workoutPlans.created_at))
      .limit(params.limit)
      .offset(params.offset);

    let countQuery = db
      .select({ count: workoutPlans.id })
      .from(workoutPlans);

    if (whereClause) {
      plansQuery = plansQuery.where(whereClause);
      countQuery = countQuery.where(whereClause);
    }

    const [rows, countResult] = await Promise.all([plansQuery, countQuery]);

    const enrichedRows: WorkoutPlanWithDetails[] = await Promise.all(
      (rows as WorkoutPlan[]).map(async (plan) => {
        const latestVersion = await this.findLatestVersionByPlanId(plan.id);
        if (!latestVersion) return plan;
        const lineItems = await this.findExercisesByVersionId(latestVersion.id);
        return {
          ...plan,
          current_version: {
            ...latestVersion,
            exercises: lineItems,
          },
        };
      }),
    );

    return { rows: enrichedRows, total: countResult.length };
  }

  async findPlanById(id: number): Promise<WorkoutPlanWithDetails | null> {
    const db = this.getDb() as any;
    const [plan] = await db
      .select()
      .from(workoutPlans)
      .where(eq(workoutPlans.id, id))
      .limit(1);

    if (!plan) return null;

    const latestVersion = await this.findLatestVersionByPlanId(plan.id);
    if (!latestVersion) return plan;

    const lineItems = await this.findExercisesByVersionId(latestVersion.id);

    return {
      ...plan,
      current_version: {
        ...latestVersion,
        exercises: lineItems,
      },
    };
  }

  async findActivePlanForMember(memberId: number): Promise<WorkoutPlan | null> {
    const db = this.getDb() as any;
    const [activePlan] = await db
      .select()
      .from(workoutPlans)
      .where(
        and(
          eq(workoutPlans.member_id, memberId),
          eq(workoutPlans.status, 'active'),
          eq(workoutPlans.is_template, false),
        ),
      )
      .limit(1);

    return activePlan || null;
  }

  async insertPlan(data: NewWorkoutPlan): Promise<WorkoutPlan> {
    const db = this.getDb() as any;
    const [result] = await db.insert(workoutPlans).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(workoutPlans)
      .where(eq(workoutPlans.id, insertId))
      .limit(1);
    return inserted;
  }

  async updatePlan(
    id: number,
    changes: Partial<NewWorkoutPlan>,
    expectedRowVersion?: number,
  ): Promise<WorkoutPlan> {
    const db = this.getDb() as any;
    const whereConditions: SQL[] = [eq(workoutPlans.id, id)];
    if (expectedRowVersion !== undefined) {
      whereConditions.push(eq(workoutPlans.row_version, expectedRowVersion));
    }

    const nextRowVersion = expectedRowVersion !== undefined ? expectedRowVersion + 1 : undefined;

    const updatePayload: Record<string, any> = {
      ...changes,
      updated_at: new Date(),
    };
    if (nextRowVersion !== undefined) {
      updatePayload.row_version = nextRowVersion;
    }

    const [updateResult] = await db
      .update(workoutPlans)
      .set(updatePayload)
      .where(and(...whereConditions));

    const affected = Number((updateResult as any).affectedRows ?? 0);
    if (expectedRowVersion !== undefined && affected === 0) {
      throw new ConflictError(
        'Workout plan has been modified by another process. Please refresh and try again.',
      );
    }

    const [updated] = await db
      .select()
      .from(workoutPlans)
      .where(eq(workoutPlans.id, id))
      .limit(1);
    return updated;
  }

  async insertVersion(data: NewWorkoutPlanVersion): Promise<WorkoutPlanVersion> {
    const db = this.getDb() as any;
    const [result] = await db.insert(workoutPlanVersions).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(workoutPlanVersions)
      .where(eq(workoutPlanVersions.id, insertId))
      .limit(1);
    return inserted;
  }

  async findLatestVersionByPlanId(planId: number): Promise<WorkoutPlanVersion | null> {
    const db = this.getDb() as any;
    const [latest] = await db
      .select()
      .from(workoutPlanVersions)
      .where(eq(workoutPlanVersions.workout_plan_id, planId))
      .orderBy(desc(workoutPlanVersions.version_number))
      .limit(1);
    return latest || null;
  }

  async findVersionsByPlanId(
    planId: number,
    limit = 20,
    offset = 0,
  ): Promise<{ rows: (WorkoutPlanVersion & { exercises: (WorkoutPlanExercise & { exercise?: Exercise })[] })[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(workoutPlanVersions.workout_plan_id, planId);

    const [rows, countResult] = await Promise.all([
      db
        .select()
        .from(workoutPlanVersions)
        .where(where)
        .orderBy(desc(workoutPlanVersions.version_number))
        .limit(limit)
        .offset(offset),
      db.select({ count: workoutPlanVersions.id }).from(workoutPlanVersions).where(where),
    ]);

    const enriched = await Promise.all(
      (rows as WorkoutPlanVersion[]).map(async (v) => {
        const lineItems = await this.findExercisesByVersionId(v.id);
        return {
          ...v,
          exercises: lineItems,
        };
      }),
    );

    return { rows: enriched, total: countResult.length };
  }

  async insertPlanExercises(items: NewWorkoutPlanExercise[]): Promise<void> {
    if (items.length === 0) return;
    const db = this.getDb() as any;
    await db.insert(workoutPlanExercises).values(items);
  }

  async findExercisesByVersionId(
    versionId: number,
  ): Promise<(WorkoutPlanExercise & { exercise?: Exercise })[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        planExercise: workoutPlanExercises,
        exercise: exercises,
      })
      .from(workoutPlanExercises)
      .leftJoin(exercises, eq(workoutPlanExercises.exercise_id, exercises.id))
      .where(eq(workoutPlanExercises.workout_plan_version_id, versionId))
      .orderBy(workoutPlanExercises.day_number, workoutPlanExercises.order_index);

    return (rows as any[]).map((r) => ({
      ...r.planExercise,
      exercise: r.exercise || undefined,
    }));
  }
}
