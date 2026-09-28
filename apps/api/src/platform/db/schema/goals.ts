import {
  bigint,
  boolean,
  date,
  double,
  index,
  int,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { users } from './users';

export const GOAL_STATUSES = ['in_progress', 'achieved', 'abandoned'] as const;
export type GoalStatus = (typeof GOAL_STATUSES)[number];

export const GOAL_METRIC_CATEGORIES = ['body_composition', 'circumference', 'strength'] as const;
export type GoalMetricCategory = (typeof GOAL_METRIC_CATEGORIES)[number];

export const PROGRESS_PHOTO_POSES = ['front', 'side', 'back'] as const;
export type ProgressPhotoPose = (typeof PROGRESS_PHOTO_POSES)[number];

export const PROGRESS_NOTE_TYPES = ['member_note', 'trainer_assessment'] as const;
export type ProgressNoteType = (typeof PROGRESS_NOTE_TYPES)[number];

// 1. Goal Metrics Catalog
export const goalMetrics = mysqlTable(
  'goal_metrics',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 100 }).notNull(),
    unit_of_measure: varchar('unit_of_measure', { length: 32 }).notNull(),
    category: varchar('category', { length: 64 }).notNull(),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('goal_metrics_category_idx').on(table.category),
    index('goal_metrics_is_active_idx').on(table.is_active),
    index('goal_metrics_name_idx').on(table.name),
  ],
);

export type GoalMetric = typeof goalMetrics.$inferSelect;
export type NewGoalMetric = typeof goalMetrics.$inferInsert;

// 2. Member Goals
export const goals = mysqlTable(
  'goals',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    metric_id: bigint('metric_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => goalMetrics.id),
    baseline_value: double('baseline_value').notNull(),
    target_value: double('target_value').notNull(),
    current_value: double('current_value').notNull(),
    start_date: date('start_date', { mode: 'string' }).notNull(),
    target_date: date('target_date', { mode: 'string' }),
    status: varchar('status', { length: 32 }).notNull().default('in_progress'),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('goals_member_id_idx').on(table.member_id),
    index('goals_metric_id_idx').on(table.metric_id),
    index('goals_status_idx').on(table.status),
    index('goals_member_status_idx').on(table.member_id, table.status),
  ],
);

export type Goal = typeof goals.$inferSelect;
export type NewGoal = typeof goals.$inferInsert;

// 3. Goal Histories (Check-ins and Progress Milestones)
export const goalHistories = mysqlTable(
  'goal_histories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    goal_id: bigint('goal_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => goals.id),
    recorded_value: double('recorded_value').notNull(),
    recorded_date: date('recorded_date', { mode: 'string' }).notNull(),
    notes: text('notes'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('goal_histories_goal_id_idx').on(table.goal_id),
    index('goal_histories_recorded_date_idx').on(table.recorded_date),
  ],
);

export type GoalHistory = typeof goalHistories.$inferSelect;
export type NewGoalHistory = typeof goalHistories.$inferInsert;

// 4. Measurements (Periodic Body Measurement Sessions)
export const measurements = mysqlTable(
  'measurements',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    recorded_by_user_id: bigint('recorded_by_user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    recorded_at: utcDatetime('recorded_at').notNull(),
    notes: text('notes'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('measurements_member_id_idx').on(table.member_id),
    index('measurements_recorded_at_idx').on(table.recorded_at),
    index('measurements_member_recorded_at_idx').on(table.member_id, table.recorded_at),
  ],
);

export type Measurement = typeof measurements.$inferSelect;
export type NewMeasurement = typeof measurements.$inferInsert;

// 5. Measurement Values (Captured Values per Metric in Session)
export const measurementValues = mysqlTable(
  'measurement_values',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    measurement_id: bigint('measurement_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => measurements.id),
    metric_id: bigint('metric_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => goalMetrics.id),
    value: double('value').notNull(),
  },
  (table) => [
    uniqueIndex('measurement_values_measurement_metric_unique').on(
      table.measurement_id,
      table.metric_id,
    ),
    index('measurement_values_metric_id_idx').on(table.metric_id),
  ],
);

export type MeasurementValue = typeof measurementValues.$inferSelect;
export type NewMeasurementValue = typeof measurementValues.$inferInsert;

// 6. Progress Photos
export const progressPhotos = mysqlTable(
  'progress_photos',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    photo_url: varchar('photo_url', { length: 512 }).notNull(),
    pose: varchar('pose', { length: 32 }).notNull(),
    taken_date: date('taken_date', { mode: 'string' }).notNull(),
    is_private: boolean('is_private').notNull().default(false),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('progress_photos_member_id_idx').on(table.member_id),
    index('progress_photos_taken_date_idx').on(table.taken_date),
    index('progress_photos_member_taken_date_idx').on(table.member_id, table.taken_date),
  ],
);

export type ProgressPhoto = typeof progressPhotos.$inferSelect;
export type NewProgressPhoto = typeof progressPhotos.$inferInsert;

// 7. Progress Notes
export const progressNotes = mysqlTable(
  'progress_notes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    author_user_id: bigint('author_user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    note_text: text('note_text').notNull(),
    note_type: varchar('note_type', { length: 32 }).notNull(),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('progress_notes_member_id_idx').on(table.member_id),
    index('progress_notes_author_id_idx').on(table.author_user_id),
    index('progress_notes_created_at_idx').on(table.created_at),
    index('progress_notes_member_created_at_idx').on(table.member_id, table.created_at),
  ],
);

export type ProgressNote = typeof progressNotes.$inferSelect;
export type NewProgressNote = typeof progressNotes.$inferInsert;
