import { bigint, json, mysqlTable, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const auditLogs = mysqlTable('audit_logs', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
  actor_user_id: bigint('actor_user_id', { mode: 'number', unsigned: true }),
  action: varchar('action', { length: 100 }).notNull(),
  entity_name: varchar('entity_name', { length: 100 }).notNull(),
  entity_id: bigint('entity_id', { mode: 'number', unsigned: true }),
  before_state: json('before_state'),
  after_state: json('after_state'),
  ip_address: varchar('ip_address', { length: 45 }),
  created_at: utcDatetime('created_at').notNull(),
});

export type AuditLog = typeof auditLogs.$inferSelect;
export type NewAuditLog = typeof auditLogs.$inferInsert;
