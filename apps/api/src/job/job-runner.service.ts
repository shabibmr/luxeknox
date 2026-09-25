import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { jobRuns } from '../platform/db/schema/job-runs';
import { runInTransaction } from '../platform/db/transaction-context';
import { JobRunRepository } from './job-run.repository';

export type JobFn = () => Promise<unknown>;

@Injectable()
export class JobRunnerService {
  private readonly registry = new Map<string, JobFn>();

  constructor(
    private readonly jobRunRepository: JobRunRepository,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  register(jobName: string, fn: JobFn): void {
    this.registry.set(jobName, fn);
  }

  async run(jobName: string, fn: JobFn): Promise<void> {
    const startedAt = new Date();
    const runId = await this.jobRunRepository.insertRun({
      job_name: jobName,
      status: 'running',
      started_at: startedAt,
      finished_at: null,
      error_message: null,
      retry_count: 0,
      created_at: startedAt,
    });

    try {
      await fn();
      await this.jobRunRepository.update(eq(jobRuns.id, runId), {
        status: 'success',
        finished_at: new Date(),
      });
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      await this.jobRunRepository.update(eq(jobRuns.id, runId), {
        status: 'failure',
        finished_at: new Date(),
        error_message: message,
      });
      throw err;
    }
  }

  async rerun(jobRunId: number, fn?: JobFn): Promise<void> {
    const original = await this.jobRunRepository.findById(jobRunId);
    if (!original) {
      throw new NotFoundException(`job_runs row ${jobRunId} not found`);
    }

    const runFn = fn ?? this.registry.get(original.job_name);
    if (!runFn) {
      throw new NotFoundException(
        `No registered job function for '${original.job_name}'; pass fn explicitly to rerun a job registered elsewhere`,
      );
    }

    await runInTransaction(this.db, async () => {
      await this.jobRunRepository.update(eq(jobRuns.id, jobRunId), {
        retry_count: original.retry_count + 1,
      });
    });

    await this.run(original.job_name, runFn);
  }
}
