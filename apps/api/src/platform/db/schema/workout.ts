import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  index,
  integer,
  numeric,
  pgTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { exercises } from './exercises';
import { members } from './members';
import { trainers } from './trainers';

export const WORKOUT_PLAN_STATUSES = ['draft', 'active', 'archived'] as const;
export type WorkoutPlanStatus = (typeof WORKOUT_PLAN_STATUSES)[number];

export const workoutPlans = pgTable(
  'workout_plans',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    title: varchar('title', { length: 150 }).notNull(),
    description: text('description'),
    member_id: bigint('member_id', { mode: 'number' }).references(() => members.id),
    trainer_id: bigint('trainer_id', { mode: 'number' }).references(() => trainers.id),
    target_goal: varchar('target_goal', { length: 64 }),
    difficulty: varchar('difficulty', { length: 32 }),
    duration_weeks: integer('duration_weeks'),
    is_template: boolean('is_template').notNull().default(false),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    row_version: integer('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('workout_plans_member_id_idx').on(table.member_id),
    index('workout_plans_trainer_id_idx').on(table.trainer_id),
    index('workout_plans_status_idx').on(table.status),
    index('workout_plans_is_template_idx').on(table.is_template),
    // PostgreSQL partial unique index replaces MySQL's stored generated column + UNIQUE KEY (ADR-0009).
    uniqueIndex('workout_plans_active_assigned_member_id_unique')
      .on(table.member_id)
      .where(sql`status = 'active' AND is_template = false`),
  ],
);

export type WorkoutPlan = typeof workoutPlans.$inferSelect;
export type NewWorkoutPlan = typeof workoutPlans.$inferInsert;

export const workoutPlanVersions = pgTable(
  'workout_plan_versions',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    workout_plan_id: bigint('workout_plan_id', { mode: 'number' })
      .notNull()
      .references(() => workoutPlans.id),
    version_number: integer('version_number').notNull(),
    changelog: text('changelog'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    uniqueIndex('workout_plan_versions_plan_id_version_unique').on(
      table.workout_plan_id,
      table.version_number,
    ),
    index('workout_plan_versions_workout_plan_id_idx').on(table.workout_plan_id),
  ],
);

export type WorkoutPlanVersion = typeof workoutPlanVersions.$inferSelect;
export type NewWorkoutPlanVersion = typeof workoutPlanVersions.$inferInsert;

export const workoutPlanExercises = pgTable(
  'workout_plan_exercises',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    workout_plan_version_id: bigint('workout_plan_version_id', { mode: 'number' })
      .notNull()
      .references(() => workoutPlanVersions.id),
    exercise_id: bigint('exercise_id', { mode: 'number' })
      .notNull()
      .references(() => exercises.id),
    day_number: integer('day_number').notNull(),
    order_index: integer('order_index').notNull(),
    target_sets: integer('target_sets').notNull().default(3),
    target_reps: varchar('target_reps', { length: 32 }).notNull().default('10'),
    target_weight_kg: numeric('target_weight_kg', { precision: 6, scale: 2 }),
    rest_seconds: integer('rest_seconds').notNull().default(60),
    notes: text('notes'),
  },
  (table) => [
    index('workout_plan_exercises_version_day_order_idx').on(
      table.workout_plan_version_id,
      table.day_number,
      table.order_index,
    ),
    index('workout_plan_exercises_exercise_id_idx').on(table.exercise_id),
  ],
);

export type WorkoutPlanExercise = typeof workoutPlanExercises.$inferSelect;
export type NewWorkoutPlanExercise = typeof workoutPlanExercises.$inferInsert;

export const workoutSessions = pgTable(
  'workout_sessions',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    workout_plan_id: bigint('workout_plan_id', { mode: 'number' }).references(
      () => workoutPlans.id,
    ),
    workout_plan_version_id: bigint('workout_plan_version_id', {
      mode: 'number',
    }).references(() => workoutPlanVersions.id),
    trainer_id: bigint('trainer_id', { mode: 'number' }).references(() => trainers.id),
    started_at: utcDatetime('started_at').notNull(),
    completed_at: utcDatetime('completed_at'),
    total_volume_kg: numeric('total_volume_kg', { precision: 10, scale: 2 }).notNull().default('0.00'),
    duration_minutes: integer('duration_minutes'),
    client_feedback_rating: integer('client_feedback_rating'),
    notes: text('notes'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('workout_sessions_member_id_idx').on(table.member_id),
    index('workout_sessions_started_at_idx').on(table.started_at),
    // PostgreSQL partial unique index replaces MySQL's stored generated column + UNIQUE KEY (ADR-0009).
    uniqueIndex('workout_sessions_active_session_member_id_unique')
      .on(table.member_id)
      .where(sql`completed_at IS NULL`),
  ],
);

export type WorkoutSession = typeof workoutSessions.$inferSelect;
export type NewWorkoutSession = typeof workoutSessions.$inferInsert;

export const workoutSessionExercises = pgTable(
  'workout_session_exercises',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    workout_session_id: bigint('workout_session_id', { mode: 'number' })
      .notNull()
      .references(() => workoutSessions.id),
    exercise_id: bigint('exercise_id', { mode: 'number' })
      .notNull()
      .references(() => exercises.id),
    set_number: integer('set_number').notNull(),
    reps_completed: integer('reps_completed').notNull().default(0),
    weight_lifted_kg: numeric('weight_lifted_kg', { precision: 6, scale: 2 }).notNull().default('0.00'),
    rpe_score: numeric('rpe_score', { precision: 3, scale: 1 }),
    is_completed: boolean('is_completed').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('workout_session_exercises_session_idx').on(table.workout_session_id),
    index('workout_session_exercises_exercise_idx').on(table.exercise_id),
    index('workout_session_exercises_session_exercise_set_idx').on(
      table.workout_session_id,
      table.exercise_id,
      table.set_number,
    ),
  ],
);

export type WorkoutSessionExercise = typeof workoutSessionExercises.$inferSelect;
export type NewWorkoutSessionExercise = typeof workoutSessionExercises.$inferInsert;
