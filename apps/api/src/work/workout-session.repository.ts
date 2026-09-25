import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNotNull, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { exercises, type Exercise } from '../platform/db/schema/exercises';
import {
  workoutSessions,
  workoutSessionExercises,
  type WorkoutSession,
  type NewWorkoutSession,
  type WorkoutSessionExercise,
  type NewWorkoutSessionExercise,
} from '../platform/db/schema/workout';

export interface WorkoutSessionWithSets extends WorkoutSession {
  sets: (WorkoutSessionExercise & { exercise?: Exercise })[];
}

export interface PersonalRecordResult {
  exercise_id: number;
  exercise_name: string;
  max_weight_kg: number;
  max_reps: number;
  best_set_volume_kg: number;
  achieved_at: Date;
}

@Injectable()
export class WorkoutSessionRepository extends BaseRepository<
  typeof workoutSessions,
  WorkoutSession,
  NewWorkoutSession
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, workoutSessions);
  }

  async findSessions(
    memberId?: number,
    limit = 20,
    offset = 0,
  ): Promise<{ rows: WorkoutSessionWithSets[]; total: number }> {
    const db = this.getDb() as any;
    const whereClause = memberId ? eq(workoutSessions.member_id, memberId) : undefined;

    let sessionsQuery = db
      .select()
      .from(workoutSessions)
      .orderBy(desc(workoutSessions.started_at))
      .limit(limit)
      .offset(offset);

    let countQuery = db
      .select({ count: workoutSessions.id })
      .from(workoutSessions);

    if (whereClause) {
      sessionsQuery = sessionsQuery.where(whereClause);
      countQuery = countQuery.where(whereClause);
    }

    const [rows, countResult] = await Promise.all([sessionsQuery, countQuery]);

    const enriched = await Promise.all(
      (rows as WorkoutSession[]).map(async (s) => {
        const sets = await this.findSetsBySessionId(s.id);
        return {
          ...s,
          sets,
        };
      }),
    );

    return { rows: enriched, total: countResult.length };
  }

  async findSessionById(id: number): Promise<WorkoutSessionWithSets | null> {
    const db = this.getDb() as any;
    const [session] = await db
      .select()
      .from(workoutSessions)
      .where(eq(workoutSessions.id, id))
      .limit(1);

    if (!session) return null;

    const sets = await this.findSetsBySessionId(session.id);
    return {
      ...session,
      sets,
    };
  }

  async findActiveSessionForMember(memberId: number): Promise<WorkoutSession | null> {
    const db = this.getDb() as any;
    const [active] = await db
      .select()
      .from(workoutSessions)
      .where(
        and(
          eq(workoutSessions.member_id, memberId),
          eq(workoutSessions.completed_at, null as any),
        ),
      )
      .limit(1);

    return active || null;
  }

  async insertSession(data: NewWorkoutSession): Promise<WorkoutSession> {
    const db = this.getDb() as any;
    const [result] = await db.insert(workoutSessions).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(workoutSessions)
      .where(eq(workoutSessions.id, insertId))
      .limit(1);
    return inserted;
  }

  async insertSessionExercise(
    data: NewWorkoutSessionExercise,
  ): Promise<WorkoutSessionExercise> {
    const db = this.getDb() as any;
    const [result] = await db.insert(workoutSessionExercises).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(workoutSessionExercises)
      .where(eq(workoutSessionExercises.id, insertId))
      .limit(1);
    return inserted;
  }

  async findSetsBySessionId(
    sessionId: number,
  ): Promise<(WorkoutSessionExercise & { exercise?: Exercise })[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        set: workoutSessionExercises,
        exercise: exercises,
      })
      .from(workoutSessionExercises)
      .leftJoin(exercises, eq(workoutSessionExercises.exercise_id, exercises.id))
      .where(eq(workoutSessionExercises.workout_session_id, sessionId))
      .orderBy(workoutSessionExercises.set_number);

    return (rows as any[]).map((r) => ({
      ...r.set,
      exercise: r.exercise || undefined,
    }));
  }

  async completeSession(
    id: number,
    completedAt: Date,
    totalVolumeKg: string,
    durationMinutes: number,
    rating?: number,
    notes?: string,
  ): Promise<WorkoutSession> {
    const db = this.getDb() as any;
    await db
      .update(workoutSessions)
      .set({
        completed_at: completedAt,
        total_volume_kg: totalVolumeKg,
        duration_minutes: durationMinutes,
        client_feedback_rating: rating,
        notes: notes,
        updated_at: new Date(),
      })
      .where(eq(workoutSessions.id, id));

    const [updated] = await db
      .select()
      .from(workoutSessions)
      .where(eq(workoutSessions.id, id))
      .limit(1);
    return updated;
  }

  async findPersonalRecords(
    memberId: number,
    exerciseId?: number,
  ): Promise<PersonalRecordResult[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [
      eq(workoutSessions.member_id, memberId),
      isNotNull(workoutSessions.completed_at),
      eq(workoutSessionExercises.is_completed, true),
    ];
    if (exerciseId !== undefined) {
      conditions.push(eq(workoutSessionExercises.exercise_id, exerciseId));
    }

    const rows = await db
      .select({
        exercise_id: workoutSessionExercises.exercise_id,
        exercise_name: exercises.name,
        weight_lifted_kg: workoutSessionExercises.weight_lifted_kg,
        reps_completed: workoutSessionExercises.reps_completed,
        started_at: workoutSessions.started_at,
      })
      .from(workoutSessionExercises)
      .innerJoin(workoutSessions, eq(workoutSessionExercises.workout_session_id, workoutSessions.id))
      .innerJoin(exercises, eq(workoutSessionExercises.exercise_id, exercises.id))
      .where(and(...conditions));

    const prMap = new Map<number, PersonalRecordResult>();

    for (const row of rows as any[]) {
      const weight = Number(row.weight_lifted_kg || 0);
      const reps = Number(row.reps_completed || 0);
      const volume = weight * reps;
      const current = prMap.get(row.exercise_id);

      if (!current) {
        prMap.set(row.exercise_id, {
          exercise_id: row.exercise_id,
          exercise_name: row.exercise_name,
          max_weight_kg: weight,
          max_reps: reps,
          best_set_volume_kg: volume,
          achieved_at: row.started_at,
        });
      } else {
        if (weight > current.max_weight_kg) {
          current.max_weight_kg = weight;
          current.achieved_at = row.started_at;
        }
        if (reps > current.max_reps) {
          current.max_reps = reps;
        }
        if (volume > current.best_set_volume_kg) {
          current.best_set_volume_kg = volume;
        }
      }
    }

    return Array.from(prMap.values());
  }
}
