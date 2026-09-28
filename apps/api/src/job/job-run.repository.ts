import { Inject, Injectable } from '@nestjs/common';
import { count, eq, sql } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { jobRuns, type JobRun, type NewJobRun } from '../platform/db/schema/job-runs';

export interface JobMetrics {
  failureCount: number;
  retryCount: number;
  lastSuccessAt: Date | null;
}

@Injectable()
export class JobRunRepository extends BaseRepository<typeof jobRuns, JobRun, NewJobRun> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, jobRuns);
  }

  async insertRun(values: NewJobRun): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async getMetrics(): Promise<JobMetrics> {
    const db = this.getDb() as any;

    const [failureRows, retryRows, lastSuccessRows] = await Promise.all([
      db.select({ value: count() }).from(jobRuns).where(eq(jobRuns.status, 'failure')),
      db.select({ value: sql<string>`coalesce(sum(${jobRuns.retry_count}), 0)` }).from(jobRuns),
      db
        .select({ value: sql<Date | null>`max(${jobRuns.finished_at})` })
        .from(jobRuns)
        .where(eq(jobRuns.status, 'success')),
    ]);

    return {
      failureCount: Number(failureRows[0]?.value ?? 0),
      retryCount: Number(retryRows[0]?.value ?? 0),
      lastSuccessAt: lastSuccessRows[0]?.value ? new Date(lastSuccessRows[0].value) : null,
    };
  }
}
