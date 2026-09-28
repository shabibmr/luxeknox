import { describe, it, expect, vi, beforeEach } from 'vitest';
import { JobRunnerService } from './job-runner.service';
import type { JobRunRepository } from './job-run.repository';
import type { DrizzleDb } from '../platform/db/client';

describe('JobRunnerService', () => {
  let mockJobRunRepository: {
    insertRun: ReturnType<typeof vi.fn>;
    update: ReturnType<typeof vi.fn>;
    findById: ReturnType<typeof vi.fn>;
  };
  let mockDb: any;
  let jobRunnerService: JobRunnerService;

  beforeEach(() => {
    mockJobRunRepository = {
      insertRun: vi.fn().mockResolvedValue(1),
      update: vi.fn().mockResolvedValue(undefined),
      findById: vi.fn(),
    };
    mockDb = {
      transaction: vi.fn().mockImplementation(async (callback: (tx: any) => Promise<any>) => {
        return callback(mockDb);
      }),
    };
    jobRunnerService = new JobRunnerService(
      mockJobRunRepository as unknown as JobRunRepository,
      mockDb as DrizzleDb<any>,
    );
  });

  describe('run', () => {
    it('records a running row then success on success', async () => {
      const fn = vi.fn().mockResolvedValue(undefined);

      await jobRunnerService.run('nightly-report', fn);

      expect(mockJobRunRepository.insertRun).toHaveBeenCalledWith(
        expect.objectContaining({
          job_name: 'nightly-report',
          status: 'running',
          started_at: expect.any(Date),
        }),
      );
      expect(fn).toHaveBeenCalledTimes(1);
      expect(mockJobRunRepository.update).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({
          status: 'success',
          finished_at: expect.any(Date),
        }),
      );
    });

    it('records failure with error message and rethrows on failure', async () => {
      const error = new Error('boom');
      const fn = vi.fn().mockRejectedValue(error);

      await expect(jobRunnerService.run('nightly-report', fn)).rejects.toThrow('boom');

      expect(mockJobRunRepository.update).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({
          status: 'failure',
          finished_at: expect.any(Date),
          error_message: 'boom',
        }),
      );
    });
  });

  describe('rerun', () => {
    it('re-invokes the passed fn, bumps retry_count, and records the new run', async () => {
      mockJobRunRepository.findById.mockResolvedValue({
        id: 5,
        job_name: 'nightly-report',
        status: 'failure',
        started_at: new Date(),
        finished_at: new Date(),
        error_message: 'boom',
        retry_count: 0,
        created_at: new Date(),
      });
      const fn = vi.fn().mockResolvedValue(undefined);

      await jobRunnerService.rerun(5, fn);

      expect(mockJobRunRepository.findById).toHaveBeenCalledWith(5);
      expect(mockJobRunRepository.update).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({ retry_count: 1 }),
      );
      expect(fn).toHaveBeenCalledTimes(1);
      expect(mockJobRunRepository.insertRun).toHaveBeenCalledWith(
        expect.objectContaining({ job_name: 'nightly-report', status: 'running' }),
      );
    });

    it('re-invokes a fn registered via register() when none is passed', async () => {
      mockJobRunRepository.findById.mockResolvedValue({
        id: 7,
        job_name: 'membership-sweep',
        status: 'failure',
        started_at: new Date(),
        finished_at: new Date(),
        error_message: 'timeout',
        retry_count: 2,
        created_at: new Date(),
      });
      const fn = vi.fn().mockResolvedValue(undefined);
      jobRunnerService.register('membership-sweep', fn);

      await jobRunnerService.rerun(7);

      expect(fn).toHaveBeenCalledTimes(1);
      expect(mockJobRunRepository.update).toHaveBeenCalledWith(
        expect.anything(),
        expect.objectContaining({ retry_count: 3 }),
      );
    });

    it('throws when the job_runs row does not exist', async () => {
      mockJobRunRepository.findById.mockResolvedValue(null);

      await expect(jobRunnerService.rerun(999)).rejects.toThrow();
    });

    it('throws when no fn is passed and none is registered', async () => {
      mockJobRunRepository.findById.mockResolvedValue({
        id: 8,
        job_name: 'unregistered-job',
        status: 'failure',
        started_at: new Date(),
        finished_at: new Date(),
        error_message: 'boom',
        retry_count: 0,
        created_at: new Date(),
      });

      await expect(jobRunnerService.rerun(8)).rejects.toThrow();
    });
  });
});
