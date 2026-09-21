import { bigint, check, pgEnum, pgTable, uniqueIndex, varchar } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { utcDatetime } from '../utc-datetime';
import { roles } from './roles';

export const USER_TYPES = ['member', 'trainer', 'employee', 'admin'] as const;
export type UserType = (typeof USER_TYPES)[number];

export const USER_STATUSES = ['active', 'inactive', 'suspended'] as const;
export type UserStatus = (typeof USER_STATUSES)[number];

// Decision 3 (ADR-0009): pgEnum for the four stable, tuple-defined enum sets. user_type is
// shared by users and sessions, so it is declared here and imported by sessions.ts.
export const userTypeEnum = pgEnum('user_type', USER_TYPES);
export const userStatusEnum = pgEnum('user_status', USER_STATUSES);

export const users = pgTable(
  'users',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    email: varchar('email', { length: 255 }),
    phone_number: varchar('phone_number', { length: 32 }),
    password_hash: varchar('password_hash', { length: 255 }).notNull(),
    user_type: userTypeEnum('user_type').notNull(),
    role_id: bigint('role_id', { mode: 'number' })
      .notNull()
      .references(() => roles.id),
    avatar_url: varchar('avatar_url', { length: 1024 }),
    status: userStatusEnum('status').notNull().default('active'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('users_email_unique').on(table.email),
    uniqueIndex('users_phone_number_unique').on(table.phone_number),
    // Decision 2 (ADR-0009): the app already normalizes to lowercase via normalizeEmail()
    // (src/people/credentials.ts) before every write, so a plain unique index is equivalent
    // for case. This CHECK makes that invariant engine-enforced rather than assumed —
    // deliberately not `citext`, which is deprecated in favour of nondeterministic collations.
    check('users_email_lowercase_check', sql`${table.email} = lower(${table.email})`),
  ],
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
