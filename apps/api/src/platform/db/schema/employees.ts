import { bigint, date, mysqlEnum, mysqlTable, uniqueIndex, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const EMPLOYEE_STATUSES = [
  'active',
  'on_probation',
  'suspended',
  'terminated',
] as const;
export type EmployeeStatus = (typeof EMPLOYEE_STATUSES)[number];

export const employees = mysqlTable(
  'employees',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    first_name: varchar('first_name', { length: 100 }).notNull(),
    last_name: varchar('last_name', { length: 100 }).notNull(),
    job_title: varchar('job_title', { length: 150 }).notNull(),
    department: varchar('department', { length: 150 }),
    hire_date: date('hire_date', { mode: 'string' }),
    status: mysqlEnum('status', EMPLOYEE_STATUSES).notNull().default('active'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('employees_user_id_unique').on(table.user_id)],
);

export type Employee = typeof employees.$inferSelect;
export type NewEmployee = typeof employees.$inferInsert;
