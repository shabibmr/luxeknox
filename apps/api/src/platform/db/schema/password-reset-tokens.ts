import { bigint, mysqlTable, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const passwordResetTokens = mysqlTable('password_reset_tokens', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
  user_id: bigint('user_id', { mode: 'number', unsigned: true })
    .notNull()
    .references(() => users.id),
  token_hash: varchar('token_hash', { length: 64 }).notNull().unique(),
  expires_at: utcDatetime('expires_at').notNull(),
  used_at: utcDatetime('used_at'),
  created_at: utcDatetime('created_at').notNull(),
});

export type PasswordResetToken = typeof passwordResetTokens.$inferSelect;
export type NewPasswordResetToken = typeof passwordResetTokens.$inferInsert;
