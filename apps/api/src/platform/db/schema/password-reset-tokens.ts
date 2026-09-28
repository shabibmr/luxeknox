import { bigint, index, pgTable, varchar } from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const passwordResetTokens = pgTable(
  'password_reset_tokens',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    user_id: bigint('user_id', { mode: 'number' })
      .notNull()
      .references(() => users.id),
    token_hash: varchar('token_hash', { length: 64 }).notNull().unique(),
    expires_at: utcDatetime('expires_at').notNull(),
    used_at: utcDatetime('used_at'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [index('password_reset_tokens_user_id_idx').on(table.user_id)],
);

export type PasswordResetToken = typeof passwordResetTokens.$inferSelect;
export type NewPasswordResetToken = typeof passwordResetTokens.$inferInsert;
