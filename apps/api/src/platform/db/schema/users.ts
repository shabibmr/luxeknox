import { bigint, mysqlEnum, mysqlTable, uniqueIndex, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { roles } from './roles';

export const USER_TYPES = ['member', 'trainer', 'employee', 'admin'] as const;
export type UserType = (typeof USER_TYPES)[number];

export const USER_STATUSES = ['active', 'inactive', 'suspended'] as const;
export type UserStatus = (typeof USER_STATUSES)[number];

export const users = mysqlTable(
  'users',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    email: varchar('email', { length: 255 }),
    phone_number: varchar('phone_number', { length: 32 }),
    password_hash: varchar('password_hash', { length: 255 }).notNull(),
    user_type: mysqlEnum('user_type', USER_TYPES).notNull(),
    role_id: bigint('role_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => roles.id),
    avatar_url: varchar('avatar_url', { length: 1024 }),
    status: mysqlEnum('status', USER_STATUSES).notNull().default('active'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('users_email_unique').on(table.email),
    uniqueIndex('users_phone_number_unique').on(table.phone_number),
  ],
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
