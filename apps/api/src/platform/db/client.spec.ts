import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { Pool } from 'pg';
import {
  createConnectionPool,
  createAdminConnectionPool,
  createDrizzleClient,
  checkLeastPrivilege,
  verifyLeastPrivilege,
  resolveSsl,
  DEFAULT_CONNECTION_TIMEOUT_MS,
  DEFAULT_IDLE_TIMEOUT_MS,
  DEFAULT_POOL_MAX,
  DEFAULT_STATEMENT_TIMEOUT_MS,
  SESSION_OPTIONS,
} from './client';

describe('Database Client & Connection Pool Configuration (HARDEN-06)', () => {
  const originalEnv = process.env;

  beforeEach(() => {
    process.env = { ...originalEnv };
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  describe('Constants & Secure Defaults', () => {
    it('declares expected default timeouts and session options', () => {
      expect(DEFAULT_CONNECTION_TIMEOUT_MS).toBe(5000);
      expect(DEFAULT_IDLE_TIMEOUT_MS).toBe(30000);
      expect(DEFAULT_POOL_MAX).toBe(20);
      expect(DEFAULT_STATEMENT_TIMEOUT_MS).toBe(15000);
      expect(SESSION_OPTIONS).toBe('-c timezone=UTC');
    });
  });

  describe('resolveSsl', () => {
    it('returns undefined when SSL is not configured or disabled', () => {
      delete process.env.DB_SSL;
      delete process.env.DB_SSL_REJECT_UNAUTHORIZED;
      expect(resolveSsl()).toBeUndefined();

      process.env.DB_SSL = 'false';
      expect(resolveSsl()).toBeUndefined();

      process.env.DB_SSL = '0';
      expect(resolveSsl()).toBeUndefined();
    });

    it('enables SSL with rejectUnauthorized true when DB_SSL is true or 1', () => {
      process.env.DB_SSL = 'true';
      delete process.env.DB_SSL_REJECT_UNAUTHORIZED;
      expect(resolveSsl()).toEqual({ rejectUnauthorized: true });

      process.env.DB_SSL = '1';
      expect(resolveSsl()).toEqual({ rejectUnauthorized: true });
    });

    it('supports configuring rejectUnauthorized false via DB_SSL_REJECT_UNAUTHORIZED', () => {
      process.env.DB_SSL = 'true';
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'false';
      expect(resolveSsl()).toEqual({ rejectUnauthorized: false });

      process.env.DB_SSL = '1';
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'false';
      expect(resolveSsl()).toEqual({ rejectUnauthorized: false });
    });

    it('preserves rejectUnauthorized true when DB_SSL_REJECT_UNAUTHORIZED is true', () => {
      process.env.DB_SSL = 'true';
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'true';
      expect(resolveSsl()).toEqual({ rejectUnauthorized: true });
    });

    it('allows caller ssl config to override env variables', () => {
      process.env.DB_SSL = 'true';

      // Explicitly disabled by caller
      expect(resolveSsl(false)).toBe(false);

      // Explicitly enabled by caller as boolean
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'false';
      expect(resolveSsl(true)).toEqual({ rejectUnauthorized: false });

      // Custom SSL object
      const customSsl = { rejectUnauthorized: false, ca: 'dummy-cert' };
      expect(resolveSsl(customSsl)).toEqual(customSsl);
    });
  });

  describe('createConnectionPool', () => {
    beforeEach(() => {
      delete process.env.DATABASE_URL;
      delete process.env.DB_SSL;
      delete process.env.DB_SSL_REJECT_UNAUTHORIZED;
      delete process.env.DB_CONNECTION_TIMEOUT_MS;
      delete process.env.DB_POOL_MAX;
      delete process.env.DB_STATEMENT_TIMEOUT_MS;

      process.env.DB_HOST = '127.0.0.1';
      process.env.DB_PORT = '5432';
      process.env.DB_USER = 'test_user';
      process.env.DB_PASSWORD = 'test_password';
      process.env.DB_NAME = 'test_db';
    });

    it('creates pool with secure default timeouts and pool size', () => {
      const pool = createConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.max).toBe(20);
      expect(options.connectionTimeoutMillis).toBe(5000);
      expect(options.idleTimeoutMillis).toBe(30000);
      expect(options.statement_timeout).toBe(15000);
      expect(options.options).toBe('-c timezone=UTC');
      expect(options.ssl).toBeUndefined();
    });

    it('configures pool max and timeouts from environment variables', () => {
      process.env.DB_POOL_MAX = '35';
      process.env.DB_CONNECTION_TIMEOUT_MS = '8000';
      process.env.DB_STATEMENT_TIMEOUT_MS = '20000';

      const pool = createConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.max).toBe(35);
      expect(options.connectionTimeoutMillis).toBe(8000);
      expect(options.idleTimeoutMillis).toBe(30000);
      expect(options.statement_timeout).toBe(20000);
    });

    it('enables SSL with rejectUnauthorized true when DB_SSL=true', () => {
      process.env.DB_SSL = 'true';

      const pool = createConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.ssl).toEqual({ rejectUnauthorized: true });
    });

    it('enables SSL with rejectUnauthorized false when DB_SSL_REJECT_UNAUTHORIZED=false', () => {
      process.env.DB_SSL = '1';
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'false';

      const pool = createConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.ssl).toEqual({ rejectUnauthorized: false });
    });

    it('accepts explicit options overriding env and defaults', () => {
      process.env.DB_POOL_MAX = '35';
      process.env.DB_CONNECTION_TIMEOUT_MS = '8000';

      const pool = createConnectionPool({
        max: 50,
        connectionTimeoutMillis: 2000,
        idleTimeoutMillis: 10000,
        statement_timeout: 7000,
        ssl: { rejectUnauthorized: false },
      });
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.max).toBe(50);
      expect(options.connectionTimeoutMillis).toBe(2000);
      expect(options.idleTimeoutMillis).toBe(10000);
      expect(options.statement_timeout).toBe(7000);
      expect(options.ssl).toEqual({ rejectUnauthorized: false });
    });

    it('supports legacy connectionLimit option for max pool size', () => {
      const pool = createConnectionPool({ connectionLimit: 15 });
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.max).toBe(15);
    });

    it('extracts statement_timeout from connection options string if not explicitly given', () => {
      const pool = createConnectionPool({
        options: '-c timezone=UTC -c statement_timeout=12000',
      });
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.statement_timeout).toBe(12000);
    });

    it('supports disabling statement_timeout with false', () => {
      const pool = createConnectionPool({ statement_timeout: false });
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.statement_timeout).toBe(false);
    });

    it('supports string connection URL input', () => {
      const connStr = 'postgres://test_user:test_pass@127.0.0.1:5432/custom_db';
      const pool = createConnectionPool(connStr);
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.connectionString).toBe(connStr);
      expect(options.max).toBe(20);
      expect(options.connectionTimeoutMillis).toBe(5000);
      expect(options.idleTimeoutMillis).toBe(30000);
      expect(options.statement_timeout).toBe(15000);
      expect(options.options).toBe('-c timezone=UTC');
    });

    it('supports string connection URL with DB_SSL enabled', () => {
      process.env.DB_SSL = 'true';
      process.env.DB_SSL_REJECT_UNAUTHORIZED = 'false';

      const connStr = 'postgres://test_user:test_pass@127.0.0.1:5432/custom_db';
      const pool = createConnectionPool(connStr);
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.connectionString).toBe(connStr);
      expect(options.ssl).toEqual({ rejectUnauthorized: false });
    });

    it('uses DATABASE_URL environment variable when host and user are omitted', () => {
      process.env.DATABASE_URL = 'postgres://env_user:env_pass@127.0.0.1:5432/env_db';

      const pool = createConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.connectionString).toBe(process.env.DATABASE_URL);
      expect(options.max).toBe(20);
      expect(options.connectionTimeoutMillis).toBe(5000);
      expect(options.statement_timeout).toBe(15000);
    });

    it('throws error when required env vars are missing and DATABASE_URL is not set', () => {
      delete process.env.DB_USER;
      delete process.env.DB_PASSWORD;

      expect(() => createConnectionPool()).toThrow(/Missing required environment variable: DB_USER/);
    });
  });

  describe('createAdminConnectionPool', () => {
    beforeEach(() => {
      delete process.env.DB_SSL;
      process.env.DB_HOST = '127.0.0.1';
      process.env.DB_PORT = '5432';
      process.env.DB_NAME = 'luxeknox';
      process.env.DB_ADMIN_USER = 'admin_user';
      process.env.DB_ADMIN_PASSWORD = 'admin_password';
      process.env.DATABASE_URL = 'postgres://app_user:app_pass@127.0.0.1:5432/app_db';
    });

    it('bypasses DATABASE_URL and connects explicitly as admin user with secure defaults', () => {
      const pool = createAdminConnectionPool();
      const options = (pool as unknown as { options: Record<string, unknown> }).options;

      expect(options.user).toBe('admin_user');
      expect(options.host).toBe('127.0.0.1');
      expect(options.port).toBe(5432);
      expect(options.database).toBe('luxeknox');
      expect(options.max).toBe(20);
      expect(options.connectionTimeoutMillis).toBe(5000);
      expect(options.idleTimeoutMillis).toBe(30000);
      expect(options.statement_timeout).toBe(15000);
    });

    it('throws if DB_ADMIN_USER is missing', () => {
      delete process.env.DB_ADMIN_USER;
      expect(() => createAdminConnectionPool()).toThrow(
        /Missing required environment variable: DB_ADMIN_USER/,
      );
    });

    it('throws if DB_ADMIN_PASSWORD is missing', () => {
      delete process.env.DB_ADMIN_PASSWORD;
      expect(() => createAdminConnectionPool()).toThrow(
        /Missing required environment variable: DB_ADMIN_PASSWORD/,
      );
    });
  });

  describe('createDrizzleClient', () => {
    it('creates drizzle client with and without schema', () => {
      const pool = new Pool();
      const dbWithoutSchema = createDrizzleClient(pool);
      expect(dbWithoutSchema).toBeDefined();

      const fakeSchema = { dummyTable: {} };
      const dbWithSchema = createDrizzleClient(pool, fakeSchema);
      expect(dbWithSchema).toBeDefined();
    });
  });

  describe('Least Privilege Verification (HARDEN-07)', () => {
    it('returns compliant report when user is non-superuser with no DDL privileges', async () => {
      const mockPool = {
        query: vi.fn().mockResolvedValue({
          rows: [
            {
              currentUser: 'luxeknox_app',
              isSuperuser: 'off',
              hasSchemaCreate: false,
              ownedTablesCount: 0,
              auditHasUpdate: false,
              auditHasDelete: false,
              auditHasTruncate: false,
            },
          ],
        }),
      } as unknown as Pool;

      const report = await checkLeastPrivilege(mockPool);
      expect(report.currentUser).toBe('luxeknox_app');
      expect(report.isSuperuser).toBe(false);
      expect(report.hasSchemaCreate).toBe(false);
      expect(report.ownedTablesCount).toBe(0);
      expect(report.auditHasUpdate).toBe(false);
      expect(report.auditHasDelete).toBe(false);
      expect(report.auditHasTruncate).toBe(false);
      expect(report.violations).toHaveLength(0);

      await expect(verifyLeastPrivilege(mockPool)).resolves.toBeUndefined();
    });

    it('identifies superuser violation', async () => {
      const mockPool = {
        query: vi.fn().mockResolvedValue({
          rows: [
            {
              currentUser: 'luxeknox_admin',
              isSuperuser: 'on',
              hasSchemaCreate: false,
              ownedTablesCount: 0,
              auditHasUpdate: false,
              auditHasDelete: false,
              auditHasTruncate: false,
            },
          ],
        }),
      } as unknown as Pool;

      const report = await checkLeastPrivilege(mockPool);
      expect(report.isSuperuser).toBe(true);
      expect(report.violations).toContain("connected user 'luxeknox_admin' is a superuser");

      await expect(verifyLeastPrivilege(mockPool)).rejects.toThrow(
        /connected user 'luxeknox_admin' is a superuser/,
      );
    });

    it('identifies schema CREATE privilege violation (DDL boundary)', async () => {
      const mockPool = {
        query: vi.fn().mockResolvedValue({
          rows: [
            {
              currentUser: 'luxeknox_app',
              isSuperuser: 'off',
              hasSchemaCreate: true,
              ownedTablesCount: 0,
              auditHasUpdate: false,
              auditHasDelete: false,
              auditHasTruncate: false,
            },
          ],
        }),
      } as unknown as Pool;

      const report = await checkLeastPrivilege(mockPool);
      expect(report.hasSchemaCreate).toBe(true);
      expect(report.violations).toContain(
        "user 'luxeknox_app' has CREATE privilege on schema public (DDL boundary violation)",
      );

      await expect(verifyLeastPrivilege(mockPool)).rejects.toThrow(/DDL boundary violation/);
    });

    it('identifies owned tables violation (ALTER/DROP DDL risk)', async () => {
      const mockPool = {
        query: vi.fn().mockResolvedValue({
          rows: [
            {
              currentUser: 'luxeknox_app',
              isSuperuser: 'off',
              hasSchemaCreate: false,
              ownedTablesCount: 3,
              auditHasUpdate: false,
              auditHasDelete: false,
              auditHasTruncate: false,
            },
          ],
        }),
      } as unknown as Pool;

      const report = await checkLeastPrivilege(mockPool);
      expect(report.ownedTablesCount).toBe(3);
      expect(report.violations).toContain(
        "user 'luxeknox_app' owns 3 table(s) in schema public (DDL boundary violation)",
      );

      await expect(verifyLeastPrivilege(mockPool)).rejects.toThrow(/owns 3 table\(s\)/);
    });

    it('identifies audit_logs mutation privilege violation (append-only immutability)', async () => {
      const mockPool = {
        query: vi.fn().mockResolvedValue({
          rows: [
            {
              currentUser: 'luxeknox_app',
              isSuperuser: 'off',
              hasSchemaCreate: false,
              ownedTablesCount: 0,
              auditHasUpdate: true,
              auditHasDelete: true,
              auditHasTruncate: true,
            },
          ],
        }),
      } as unknown as Pool;

      const report = await checkLeastPrivilege(mockPool);
      expect(report.auditHasUpdate).toBe(true);
      expect(report.auditHasDelete).toBe(true);
      expect(report.auditHasTruncate).toBe(true);
      expect(report.violations[0]).toMatch(/violates append-only immutability/);

      await expect(verifyLeastPrivilege(mockPool)).rejects.toThrow(
        /violates append-only immutability/,
      );
    });
  });
});

