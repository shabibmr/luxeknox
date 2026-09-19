import { bigint, boolean, mysqlTable, text, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const roles = mysqlTable('roles', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
  name: varchar('name', { length: 100 }).notNull(),
  slug: varchar('slug', { length: 100 }).notNull().unique(),
  description: text('description'),
  is_system: boolean('is_system').notNull().default(false),
  created_at: utcDatetime('created_at').notNull(),
  updated_at: utcDatetime('updated_at'),
});

export type Role = typeof roles.$inferSelect;
export type NewRole = typeof roles.$inferInsert;
