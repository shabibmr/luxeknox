import { bigint, index, mysqlEnum, mysqlTable, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { USER_TYPES, users } from './users';

export const sessions = mysqlTable(
  'sessions',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    user_type: mysqlEnum('user_type', USER_TYPES).notNull(),
    profile_id: bigint('profile_id', { mode: 'number', unsigned: true }),
    family_id: varchar('family_id', { length: 64 }).notNull(),
    access_token_hash: varchar('access_token_hash', { length: 64 }).notNull(),
    refresh_token_hash: varchar('refresh_token_hash', { length: 64 }).notNull(),
    revoked_at: utcDatetime('revoked_at'),
    expires_at: utcDatetime('expires_at').notNull(),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('sessions_access_token_hash_idx').on(table.access_token_hash),
    index('sessions_refresh_token_hash_idx').on(table.refresh_token_hash),
    index('sessions_family_id_idx').on(table.family_id),
    index('sessions_user_id_revoked_at_idx').on(table.user_id, table.revoked_at),
  ],
);

export type Session = typeof sessions.$inferSelect;
export type NewSession = typeof sessions.$inferInsert;
