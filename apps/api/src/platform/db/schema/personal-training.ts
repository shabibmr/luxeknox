import {
  bigint,
  boolean,
  date,
  decimal,
  index,
  int,
  json,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
  type AnyMySqlColumn,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { memberships } from './memberships';
import { trainers } from './trainers';
import { users } from './users';

export const PT_SUBSCRIPTION_STATUSES = ['scheduled', 'active', 'completed', 'cancelled'] as const;
export type PtSubscriptionStatus = (typeof PT_SUBSCRIPTION_STATUSES)[number];

export const ptProducts = mysqlTable(
  'pt_products',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    code: varchar('code', { length: 32 }).notNull(),
    description: text('description'),
    duration_days: int('duration_days').notNull(),
    base_price: decimal('base_price', { precision: 10, scale: 2 }).notNull(),
    tax_percentage: decimal('tax_percentage', { precision: 5, scale: 2 }).notNull().default('0.00'),
    package_type: varchar('package_type', { length: 16 }).notNull().$type<'single' | 'couple'>(),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('pt_products_code_unique').on(table.code),
    index('pt_products_is_active_idx').on(table.is_active),
  ],
);

export type PtProduct = typeof ptProducts.$inferSelect;
export type NewPtProduct = typeof ptProducts.$inferInsert;

export const ptSubscriptions = mysqlTable(
  'pt_subscriptions',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    pt_product_id: bigint('pt_product_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => ptProducts.id),
    trainer_id: bigint('trainer_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => trainers.id),
    membership_id: bigint('membership_id', { mode: 'number', unsigned: true }).references(
      () => memberships.id,
    ),
    renewed_from_id: bigint('renewed_from_id', { mode: 'number', unsigned: true }).references(
      (): AnyMySqlColumn => ptSubscriptions.id,
    ),
    partner_subscription_id: bigint('partner_subscription_id', {
      mode: 'number',
      unsigned: true,
    }).references((): AnyMySqlColumn => ptSubscriptions.id),
    is_primary: boolean('is_primary').notNull().default(true),
    start_date: date('start_date', { mode: 'string' }).notNull(),
    end_date: date('end_date', { mode: 'string' }).notNull(),
    /** Days of week (0=Sunday … 6=Saturday, `getUTCDay` convention). */
    weekdays: json('weekdays').$type<number[]>().notNull(),
    /** Gym wall-clock "HH:MM:SS" on the hour; slot length is always 60 minutes. */
    slot_start: varchar('slot_start', { length: 8 }).notNull(),
    status: varchar('status', { length: 16 }).notNull().default('scheduled'),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('pt_subscriptions_member_id_idx').on(table.member_id),
    index('pt_subscriptions_trainer_id_idx').on(table.trainer_id),
    index('pt_subscriptions_status_idx').on(table.status),
    index('pt_subscriptions_end_date_idx').on(table.end_date),
    index('pt_subscriptions_partner_subscription_id_idx').on(table.partner_subscription_id),
  ],
);

export type PtSubscription = typeof ptSubscriptions.$inferSelect;
export type NewPtSubscription = typeof ptSubscriptions.$inferInsert;

export const ptSubscriptionChanges = mysqlTable(
  'pt_subscription_changes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    pt_subscription_id: bigint('pt_subscription_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => ptSubscriptions.id),
    change_type: varchar('change_type', { length: 16 }).notNull(),
    effective_date: date('effective_date', { mode: 'string' }).notNull(),
    old_trainer_id: bigint('old_trainer_id', { mode: 'number', unsigned: true }),
    new_trainer_id: bigint('new_trainer_id', { mode: 'number', unsigned: true }),
    old_weekdays: json('old_weekdays').$type<number[]>(),
    new_weekdays: json('new_weekdays').$type<number[]>(),
    old_slot_start: varchar('old_slot_start', { length: 8 }),
    new_slot_start: varchar('new_slot_start', { length: 8 }),
    reason: text('reason'),
    handover_continuity_notes: text('handover_continuity_notes'),
    changed_by_user_id: bigint('changed_by_user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [index('pt_subscription_changes_subscription_idx').on(table.pt_subscription_id)],
);

export type PtSubscriptionChange = typeof ptSubscriptionChanges.$inferSelect;
export type NewPtSubscriptionChange = typeof ptSubscriptionChanges.$inferInsert;

export const PT_PROGRESS_REVIEW_STATUSES = [
  'draft',
  'pending_client_sign',
  'pending_manager_approval',
  'approved',
  'archived',
] as const;
export type PtProgressReviewStatus = (typeof PT_PROGRESS_REVIEW_STATUSES)[number];

export interface BodyMetricSnapshot {
  metric: string;
  start_val: number | null;
  current_val: number | null;
  change_val: number | null;
  target_val: number | null;
}

export interface PerformanceMarkerSnapshot {
  marker: string;
  start_val: string | null;
  current_val: string | null;
  change_val: string | null;
  target_val: string | null;
}

export interface ReviewChecklist {
  goals_reviewed?: boolean;
  measurements_reviewed?: boolean;
  performance_reviewed?: boolean;
  attendance_reviewed?: boolean;
  program_updated?: boolean;
  next_goals_agreed?: boolean;
}

export const ptProgressReviews = mysqlTable(
  'pt_progress_reviews',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    trainer_id: bigint('trainer_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => trainers.id),
    review_period_start: date('review_period_start', { mode: 'string' }).notNull(),
    review_period_end: date('review_period_end', { mode: 'string' }).notNull(),
    body_metrics_snapshot: json('body_metrics_snapshot').$type<BodyMetricSnapshot[]>(),
    performance_markers_snapshot:
      json('performance_markers_snapshot').$type<PerformanceMarkerSnapshot[]>(),
    progress_highlights: json('progress_highlights').$type<string[]>(),
    highlights_other_text: text('highlights_other_text'),
    trainer_summary: text('trainer_summary'),
    client_feedback: text('client_feedback'),
    next_phase_goal: text('next_phase_goal'),
    next_phase_training_focus: text('next_phase_training_focus'),
    next_review_date: date('next_review_date', { mode: 'string' }),
    review_checklist: json('review_checklist').$type<ReviewChecklist>(),
    final_review_notes: text('final_review_notes'),
    client_signed_at: utcDatetime('client_signed_at'),
    trainer_signed_at: utcDatetime('trainer_signed_at'),
    manager_user_id: bigint('manager_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    manager_signed_at: utcDatetime('manager_signed_at'),
    status: varchar('status', { length: 32 })
      .notNull()
      .default('draft')
      .$type<PtProgressReviewStatus>(),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('pt_progress_reviews_member_id_idx').on(table.member_id),
    index('pt_progress_reviews_trainer_id_idx').on(table.trainer_id),
    index('pt_progress_reviews_status_idx').on(table.status),
  ],
);

export type PtProgressReview = typeof ptProgressReviews.$inferSelect;
export type NewPtProgressReview = typeof ptProgressReviews.$inferInsert;

