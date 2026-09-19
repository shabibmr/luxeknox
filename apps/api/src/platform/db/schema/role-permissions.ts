import { bigint, mysqlTable, uniqueIndex } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { roles } from './roles';
import { permissions } from './permissions';

export const rolePermissions = mysqlTable(
  'role_permissions',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    role_id: bigint('role_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => roles.id),
    permission_id: bigint('permission_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => permissions.id),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    uniqueIndex('role_permissions_role_id_permission_id_unique').on(table.role_id, table.permission_id),
  ],
);

export type RolePermission = typeof rolePermissions.$inferSelect;
export type NewRolePermission = typeof rolePermissions.$inferInsert;
