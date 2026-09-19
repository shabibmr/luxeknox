import { bigint, boolean, index, json, mysqlTable, text, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const exercises = mysqlTable(
  'exercises',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    primary_muscle_group: varchar('primary_muscle_group', { length: 100 }),
    secondary_muscles: json('secondary_muscles').$type<string[]>(),
    equipment_needed: varchar('equipment_needed', { length: 150 }),
    instructions: text('instructions'),
    video_url: varchar('video_url', { length: 500 }),
    gif_url: varchar('gif_url', { length: 500 }),
    difficulty_level: varchar('difficulty_level', { length: 50 }),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('exercises_is_active_primary_muscle_group_idx').on(
      table.is_active,
      table.primary_muscle_group,
    ),
    index('exercises_name_idx').on(table.name),
  ],
);

export type Exercise = typeof exercises.$inferSelect;
export type NewExercise = typeof exercises.$inferInsert;
