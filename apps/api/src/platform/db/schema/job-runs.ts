import { bigint, index, int, mysqlEnum, mysqlTable, text, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const jobRunStatuses = ['success', 'failure', 'running'] as const;
export type JobRunStatus = (typeof jobRunStatuses)[number];

export const jobRuns = mysqlTable(
  'job_runs',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    job_name: varchar('job_name', { length: 150 }).notNull(),
    status: mysqlEnum('status', jobRunStatuses).notNull(),
    started_at: utcDatetime('started_at').notNull(),
    finished_at: utcDatetime('finished_at'),
    error_message: text('error_message'),
    retry_count: int('retry_count').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('job_runs_job_name_idx').on(table.job_name),
    index('job_runs_status_finished_at_idx').on(table.status, table.finished_at),
  ],
);

export type JobRun = typeof jobRuns.$inferSelect;
export type NewJobRun = typeof jobRuns.$inferInsert;
