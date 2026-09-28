import {
  bigint,
  boolean,
  date,
  index,
  integer,
  jsonb,
  numeric,
  pgTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { users } from './users';

export const membershipProducts = pgTable(
  'membership_products',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    name: varchar('name', { length: 150 }).notNull(),
    code: varchar('code', { length: 32 }).notNull(),
    description: text('description'),
    duration_days: integer('duration_days').notNull(),
    base_price: numeric('base_price', { precision: 10, scale: 2 }).notNull(),
    tax_percentage: numeric('tax_percentage', { precision: 5, scale: 2 }).notNull().default('0.00'),
    max_freeze_days: integer('max_freeze_days').notNull().default(0),
    pt_sessions_included: integer('pt_sessions_included').notNull().default(0),
    access_facilities: jsonb('access_facilities').$type<string[]>(),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('membership_products_code_unique').on(table.code),
    index('membership_products_is_active_idx').on(table.is_active),
  ],
);

export type MembershipProduct = typeof membershipProducts.$inferSelect;
export type NewMembershipProduct = typeof membershipProducts.$inferInsert;

export const memberships = pgTable(
  'memberships',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    product_id: bigint('product_id', { mode: 'number' })
      .notNull()
      .references(() => membershipProducts.id),
    start_date: date('start_date', { mode: 'string' }).notNull(),
    end_date: date('end_date', { mode: 'string' }).notNull(),
    remaining_pt_sessions: integer('remaining_pt_sessions').notNull().default(0),
    status: varchar('status', { length: 16 }).notNull().default('active'),
    locker_number: varchar('locker_number', { length: 16 }),
    auto_renew: boolean('auto_renew').notNull().default(false),
    row_version: integer('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('memberships_member_id_idx').on(table.member_id),
    index('memberships_status_idx').on(table.status),
    index('memberships_end_date_idx').on(table.end_date),
    index('memberships_locker_number_idx').on(table.locker_number),
  ],
);

export type Membership = typeof memberships.$inferSelect;
export type NewMembership = typeof memberships.$inferInsert;

export const membershipFreezes = pgTable(
  'membership_freezes',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    membership_id: bigint('membership_id', { mode: 'number' })
      .notNull()
      .references(() => memberships.id),
    start_date: date('start_date', { mode: 'string' }).notNull(),
    end_date: date('end_date', { mode: 'string' }).notNull(),
    total_freeze_days: integer('total_freeze_days').notNull(),
    reason: text('reason'),
    status: varchar('status', { length: 16 }).notNull().default('pending'),
    reviewed_by_user_id: bigint('reviewed_by_user_id', { mode: 'number' }).references(
      () => users.id,
    ),
    reviewed_at: utcDatetime('reviewed_at'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('membership_freezes_membership_id_idx').on(table.membership_id),
    index('membership_freezes_status_idx').on(table.status),
  ],
);

export type MembershipFreeze = typeof membershipFreezes.$inferSelect;
export type NewMembershipFreeze = typeof membershipFreezes.$inferInsert;

export const membershipExtensions = pgTable(
  'membership_extensions',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    membership_id: bigint('membership_id', { mode: 'number' })
      .notNull()
      .references(() => memberships.id),
    days_extended: integer('days_extended').notNull(),
    reason: text('reason'),
    granted_by_user_id: bigint('granted_by_user_id', { mode: 'number' })
      .notNull()
      .references(() => users.id),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [index('membership_extensions_membership_id_idx').on(table.membership_id)],
);

export type MembershipExtension = typeof membershipExtensions.$inferSelect;
export type NewMembershipExtension = typeof membershipExtensions.$inferInsert;

export const membershipHistories = pgTable(
  'membership_histories',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    membership_id: bigint('membership_id', { mode: 'number' })
      .notNull()
      .references(() => memberships.id),
    action: varchar('action', { length: 16 }).notNull(),
    old_end_date: date('old_end_date', { mode: 'string' }),
    new_end_date: date('new_end_date', { mode: 'string' }),
    performed_by_user_id: bigint('performed_by_user_id', { mode: 'number' })
      .notNull()
      .references(() => users.id),
    timestamp: utcDatetime('timestamp').notNull(),
  },
  (table) => [index('membership_histories_membership_id_idx').on(table.membership_id)],
);

export type MembershipHistory = typeof membershipHistories.$inferSelect;
export type NewMembershipHistory = typeof membershipHistories.$inferInsert;
