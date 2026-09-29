import { describe, it, expect, vi } from 'vitest';
import { HttpStatus } from '@nestjs/common';
import type { Response } from 'express';
import { HealthController, HealthResponseDto, ReadyResponseDto } from './health.controller';
import type { DrizzleDb } from '../db/client';
import type { JobRunRepository } from '../../job/job-run.repository';

describe('HealthController', () => {
  const createMockResponse = () => {
    const res = {
      statusCode: 200,
      status: vi.fn().mockImplementation((code: number) => {
        res.statusCode = code;
        return res;
      }),
    } as unknown as Response;
    return res;
  };

  const createMockJobRunRepository = () =>
    ({
      getMetrics: vi.fn().mockResolvedValue({
        failureCount: 0,
        retryCount: 0,
        lastSuccessAt: null,
      }),
    }) as unknown as JobRunRepository;

  describe('GET /v1/health', () => {
    it('returns status ok and UTC timestamp without database interaction', () => {
      // Create controller with no DB or mock DB that should never be called
      const mockDb = {
        execute: vi.fn(),
      } as unknown as DrizzleDb;

      const controller = new HealthController(mockDb, createMockJobRunRepository());
      const result: HealthResponseDto = controller.getHealth();

      expect(result.status).toBe('ok');
      expect(result.timestamp).toBeDefined();
      expect(new Date(result.timestamp).toISOString()).toBe(result.timestamp);
      // Ensure DB was not queried
      expect(mockDb.execute).not.toHaveBeenCalled();
    });
  });

  describe('GET /v1/ready', () => {
    it('returns 200 ok and connected when database ping succeeds', async () => {
      const mockDb = {
        execute: vi.fn().mockResolvedValue([{ '1': 1 }]),
      } as unknown as DrizzleDb;

      const res = createMockResponse();
      const jobRunRepository = createMockJobRunRepository();
      const controller = new HealthController(mockDb, jobRunRepository);

      const result: ReadyResponseDto = await controller.getReady(res);

      expect(mockDb.execute).toHaveBeenCalledTimes(1);
      expect(jobRunRepository.getMetrics).toHaveBeenCalledTimes(1);
      expect(res.status).toHaveBeenCalledWith(HttpStatus.OK);
      expect(result.status).toBe('ok');
      expect(result.database).toBe('connected');
      expect(result.timestamp).toBeDefined();
      expect(new Date(result.timestamp).toISOString()).toBe(result.timestamp);
      expect(result.jobs).toEqual({
        failure_count: 0,
        retry_count: 0,
        last_success_at: null,
      });
    });

    it('returns 503 error and disconnected when database ping fails', async () => {
      const mockDb = {
        execute: vi.fn().mockRejectedValue(new Error('ECONNREFUSED 127.0.0.1:3306')),
      } as unknown as DrizzleDb;

      const res = createMockResponse();
      const controller = new HealthController(mockDb, createMockJobRunRepository());

      const result: ReadyResponseDto = await controller.getReady(res);

      expect(mockDb.execute).toHaveBeenCalledTimes(1);
      expect(res.status).toHaveBeenCalledWith(HttpStatus.SERVICE_UNAVAILABLE);
      expect(result.status).toBe('error');
      expect(result.database).toBe('disconnected');
      expect(result.timestamp).toBeDefined();
      expect(new Date(result.timestamp).toISOString()).toBe(result.timestamp);
    });

    it('returns role in response when current_user is returned by ping', async () => {
      const mockDb = {
        execute: vi.fn().mockResolvedValue({
          rows: [{ current_user: 'luxeknox_app', is_superuser: 'off' }],
        }),
      } as unknown as DrizzleDb;

      const res = createMockResponse();
      const controller = new HealthController(mockDb, createMockJobRunRepository());

      const result: ReadyResponseDto = await controller.getReady(res);
      expect(result.status).toBe('ok');
      expect(result.database).toBe('connected');
      expect(result.role).toBe('luxeknox_app');
    });

    it('successfully verifies role when verifyRole=true and role matches DB_USER', async () => {
      const originalDbUser = process.env.DB_USER;
      process.env.DB_USER = 'luxeknox_app';
      try {
        const mockDb = {
          execute: vi.fn().mockResolvedValue({
            rows: [{ current_user: 'luxeknox_app', is_superuser: 'off' }],
          }),
        } as unknown as DrizzleDb;

        const res = createMockResponse();
        const controller = new HealthController(mockDb, createMockJobRunRepository());

        const result: ReadyResponseDto = await controller.getReady(res, 'true');
        expect(res.status).toHaveBeenCalledWith(HttpStatus.OK);
        expect(result.status).toBe('ok');
        expect(result.role).toBe('luxeknox_app');
      } finally {
        process.env.DB_USER = originalDbUser;
      }
    });

    it('returns 503 when verifyRole=true and connected role is a superuser', async () => {
      const originalDbUser = process.env.DB_USER;
      process.env.DB_USER = 'luxeknox_admin';
      try {
        const mockDb = {
          execute: vi.fn().mockResolvedValue({
            rows: [{ current_user: 'luxeknox_admin', is_superuser: 'on' }],
          }),
        } as unknown as DrizzleDb;

        const res = createMockResponse();
        const controller = new HealthController(mockDb, createMockJobRunRepository());

        const result: ReadyResponseDto = await controller.getReady(res, 'true');
        expect(res.status).toHaveBeenCalledWith(HttpStatus.SERVICE_UNAVAILABLE);
        expect(result.status).toBe('error');
        expect(result.database).toBe('disconnected');
      } finally {
        process.env.DB_USER = originalDbUser;
      }
    });

    it('returns 503 when verifyRole=true and connected role does not match expected DB_USER', async () => {
      const originalDbUser = process.env.DB_USER;
      process.env.DB_USER = 'luxeknox_app';
      try {
        const mockDb = {
          execute: vi.fn().mockResolvedValue({
            rows: [{ current_user: 'unexpected_role', is_superuser: 'off' }],
          }),
        } as unknown as DrizzleDb;

        const res = createMockResponse();
        const controller = new HealthController(mockDb, createMockJobRunRepository());

        const result: ReadyResponseDto = await controller.getReady(res, 'true');
        expect(res.status).toHaveBeenCalledWith(HttpStatus.SERVICE_UNAVAILABLE);
        expect(result.status).toBe('error');
        expect(result.database).toBe('disconnected');
      } finally {
        process.env.DB_USER = originalDbUser;
      }
    });
  });
});
