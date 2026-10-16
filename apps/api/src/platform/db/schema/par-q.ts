import {
  bigint,
  boolean,
  index,
  mysqlTable,
  text,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { users } from './users';

export const PAR_Q_CLEARANCE_STATUSES = [
  'passed',
  'pending_clearance',
  'cleared',
  'rejected',
] as const;
export type ParQClearanceStatus = (typeof PAR_Q_CLEARANCE_STATUSES)[number];

export const parQScreenings = mysqlTable(
  'par_q_screenings',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    version: varchar('version', { length: 32 }).notNull().default('2024.1'),
    q1_heart_condition: boolean('q1_heart_condition').notNull().default(false),
    q1_details: text('q1_details'),
    q2_chest_pain_activity: boolean('q2_chest_pain_activity').notNull().default(false),
    q2_details: text('q2_details'),
    q3_chest_pain_rest: boolean('q3_chest_pain_rest').notNull().default(false),
    q3_details: text('q3_details'),
    q4_dizziness_consciousness: boolean('q4_dizziness_consciousness').notNull().default(false),
    q4_details: text('q4_details'),
    q5_bone_joint_problem: boolean('q5_bone_joint_problem').notNull().default(false),
    q5_details: text('q5_details'),
    q6_medication_condition: boolean('q6_medication_condition').notNull().default(false),
    q6_details: text('q6_details'),
    q7_other_reason: boolean('q7_other_reason').notNull().default(false),
    q7_details: text('q7_details'),
    has_positive_answer: boolean('has_positive_answer').notNull().default(false),
    trainer_screening_notes: text('trainer_screening_notes'),
    referral_required: boolean('referral_required').notNull().default(false),
    referral_reason: text('referral_reason'),
    declaration_accepted: boolean('declaration_accepted').notNull().default(false),
    client_signed_at: utcDatetime('client_signed_at'),
    trainer_signed_at: utcDatetime('trainer_signed_at'),
    trainer_user_id: bigint('trainer_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    clearance_status: varchar('clearance_status', { length: 32 })
      .notNull()
      .default('passed')
      .$type<ParQClearanceStatus>(),
    cleared_at: utcDatetime('cleared_at'),
    cleared_by_user_id: bigint('cleared_by_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('par_q_screenings_member_id_idx').on(table.member_id),
    index('par_q_screenings_clearance_status_idx').on(table.clearance_status),
  ],
);

export type ParQScreening = typeof parQScreenings.$inferSelect;
export type NewParQScreening = typeof parQScreenings.$inferInsert;
