import {
  bigint,
  decimal,
  int,
  json,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { trainers } from './trainers';

export const ACTIVITY_LEVELS = ['sedentary', 'light', 'moderate', 'high'] as const;
export type ActivityLevel = (typeof ACTIVITY_LEVELS)[number];

export interface LifestylePriorityItem {
  priority: 'sleep' | 'nutrition' | 'activity' | 'recovery';
  current_status: string;
  first_action: string;
}

export const memberLifestyleIntakes = mysqlTable(
  'member_lifestyle_intakes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    activity_level: varchar('activity_level', { length: 32 }).$type<ActivityLevel>(),
    training_history: text('training_history'),
    current_pain_discomfort: text('current_pain_discomfort'),
    sleep_hours_typical: decimal('sleep_hours_typical', { precision: 3, scale: 1 }),
    stress_level: int('stress_level'),
    work_activity_demands: text('work_activity_demands'),
    typical_daily_steps: int('typical_daily_steps'),
    nutrition_approach: text('nutrition_approach'),
    hydration_habits: text('hydration_habits'),
    recovery_habits: text('recovery_habits'),
    other_notes: text('other_notes'),
    lifestyle_priorities: json('lifestyle_priorities').$type<LifestylePriorityItem[]>(),
    conducted_by_trainer_id: bigint('conducted_by_trainer_id', {
      mode: 'number',
      unsigned: true,
    }).references(() => trainers.id),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('member_lifestyle_intakes_member_id_unique').on(table.member_id),
  ],
);

export type MemberLifestyleIntake = typeof memberLifestyleIntakes.$inferSelect;
export type NewMemberLifestyleIntake = typeof memberLifestyleIntakes.$inferInsert;
