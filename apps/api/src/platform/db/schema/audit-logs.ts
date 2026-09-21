import { bigint, jsonb, pgTable, varchar } from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';

export const auditLogs = pgTable('audit_logs', {
  id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
  actor_user_id: bigint('actor_user_id', { mode: 'number' }),
  action: varchar('action', { length: 100 }).notNull(),
  entity_name: varchar('entity_name', { length: 100 }).notNull(),
  entity_id: bigint('entity_id', { mode: 'number' }),
  before_state: jsonb('before_state'),
  after_state: jsonb('after_state'),
  ip_address: varchar('ip_address', { length: 45 }),
  created_at: utcDatetime('created_at').notNull(),
});

export type AuditLog = typeof auditLogs.$inferSelect;
export type NewAuditLog = typeof auditLogs.$inferInsert;
