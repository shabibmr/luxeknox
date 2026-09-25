import { bigint, index, int, mysqlTable, text, uniqueIndex, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

/**
 * Generic idempotency store (FND-010). Keys are client-supplied (`Idempotency-Key`
 * header) and scoped by HTTP method + path. A stored response is replayed on
 * retry; a key reused with a different request body hash yields 409.
 */
export const idempotencyKeys = mysqlTable(
  'idempotency_keys',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    idempotency_key: varchar('idempotency_key', { length: 128 }).notNull(),
    method: varchar('method', { length: 16 }).notNull(),
    path: varchar('path', { length: 255 }).notNull(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true }).references(() => users.id),
    request_hash: varchar('request_hash', { length: 64 }).notNull(),
    response_status: int('response_status').notNull(),
    response_body: text('response_body').notNull(),
    created_at: utcDatetime('created_at').notNull(),
    expires_at: utcDatetime('expires_at').notNull(),
  },
  (table) => [
    uniqueIndex('idempotency_keys_key_method_path_unique').on(
      table.idempotency_key,
      table.method,
      table.path,
    ),
    index('idempotency_keys_expires_at_idx').on(table.expires_at),
  ],
);

export type IdempotencyKeyRow = typeof idempotencyKeys.$inferSelect;
export type NewIdempotencyKeyRow = typeof idempotencyKeys.$inferInsert;
