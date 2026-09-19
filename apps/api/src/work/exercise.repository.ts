import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { exercises, type Exercise, type NewExercise } from '../platform/db/schema/exercises';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface ExerciseFilterParams {
  q?: string;
  primaryMuscleGroup?: string;
  equipmentNeeded?: string;
  difficultyLevel?: string;
  activeOnly: boolean;
  limit: number;
  offset: number;
}

export interface ExerciseFilterResult {
  rows: Exercise[];
  total: number;
}

@Injectable()
export class ExerciseRepository extends BaseRepository<typeof exercises, Exercise, NewExercise> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, exercises);
  }

  private buildFilterConditions(
    params: Omit<ExerciseFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.activeOnly) {
      conditions.push(eq(exercises.is_active, true));
    }
    if (params.q) {
      conditions.push(like(exercises.name, `%${params.q}%`));
    }
    if (params.primaryMuscleGroup) {
      conditions.push(eq(exercises.primary_muscle_group, params.primaryMuscleGroup));
    }
    if (params.equipmentNeeded) {
      conditions.push(eq(exercises.equipment_needed, params.equipmentNeeded));
    }
    if (params.difficultyLevel) {
      conditions.push(eq(exercises.difficulty_level, params.difficultyLevel));
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  /**
   * Finds exercises matching the given filters, paginated. Returns the page of rows
   * alongside the total matching count (for offset-mode `has_more`/`total` in PageMeta).
   */
  async findManyFiltered(params: ExerciseFilterParams): Promise<ExerciseFilterResult> {
    const { limit, offset, ...filterParams } = params;
    const where = this.buildFilterConditions(filterParams);
    const db = this.getDb() as any;

    let rowsQuery = db.select().from(exercises);
    let countQuery = db.select({ value: count() }).from(exercises);
    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as Exercise[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  /**
   * Inserts a new exercise and returns its generated ID.
   */
  async insertExercise(values: NewExercise): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  /**
   * Updates an exercise by ID.
   */
  async updateExercise(id: number, values: Partial<NewExercise>): Promise<void> {
    await this.update(eq(exercises.id, id), values);
  }
}
