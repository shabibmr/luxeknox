import { bigint, mysqlTable, text, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const permissions = mysqlTable('permissions', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
  module: varchar('module', { length: 50 }).notNull(),
  action: varchar('action', { length: 50 }).notNull(),
  slug: varchar('slug', { length: 100 }).notNull().unique(),
  description: text('description'),
  created_at: utcDatetime('created_at').notNull(),
});

export type Permission = typeof permissions.$inferSelect;
export type NewPermission = typeof permissions.$inferInsert;
