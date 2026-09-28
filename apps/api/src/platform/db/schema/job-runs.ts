import {
  bigint,
  index,
  integer,
  pgEnum,
  pgTable,
  text,
  varchar,
} from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';

export const jobRunStatuses = ['success', 'failure', 'running'] as const;
export type JobRunStatus = (typeof jobRunStatuses)[number];

export const jobRunStatusEnum = pgEnum('job_run_status', jobRunStatuses);

export const jobRuns = pgTable(
  'job_runs',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    job_name: varchar('job_name', { length: 150 }).notNull(),
    status: jobRunStatusEnum('status').notNull(),
    started_at: utcDatetime('started_at').notNull(),
    finished_at: utcDatetime('finished_at'),
    error_message: text('error_message'),
    retry_count: integer('retry_count').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('job_runs_job_name_idx').on(table.job_name),
    index('job_runs_status_finished_at_idx').on(table.status, table.finished_at),
  ],
);

export type JobRun = typeof jobRuns.$inferSelect;
export type NewJobRun = typeof jobRuns.$inferInsert;
