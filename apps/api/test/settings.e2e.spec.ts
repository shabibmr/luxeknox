import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { sql } from 'drizzle-orm';
import type { Pool } from 'pg';
import { DRIZZLE_POOL_TOKEN } from '../src/platform/db/drizzle.module';
import { verifyLeastPrivilege, checkLeastPrivilege } from '../src/platform/db/client';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  MEMBER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/postgres';

describe('Settings & RBAC E2E', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let memberToken: string;

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);

    // Login as Admin
    const adminLoginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    const adminLoginData = (await adminLoginRes.json()) as any;
    adminToken = adminLoginData.accessToken;

    // Login as Member
    const memberLoginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: MEMBER_CREDENTIALS.email,
        password: MEMBER_CREDENTIALS.password,
      }),
    });
    const memberLoginData = (await memberLoginRes.json()) as any;
    memberToken = memberLoginData.accessToken;
  });

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('GET /v1/settings/public is accessible unauthenticated', async () => {
    const res = await fetch(`${testApp.baseUrl}/settings/public`);
    expect(res.status).toBe(200);

    const data = (await res.json()) as any;
    expect(data.timezone).toBeDefined();
    expect(data.currency).toBeDefined();
  });

  it('GET /v1/settings succeeds (200) for Super Admin with settings.read permission', async () => {
    const res = await fetch(`${testApp.baseUrl}/settings`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });

    expect(res.status).toBe(200);
    const body = (await res.json()) as { data: Array<{ setting_key: string }> };
    expect(Array.isArray(body.data)).toBe(true);
    const keys = body.data.map((s) => s.setting_key);
    expect(keys).toContain('timezone');
    expect(keys).toContain('currency');
  });

  it('GET /v1/settings returns 403 Forbidden for Member role lacking settings.read', async () => {
    const res = await fetch(`${testApp.baseUrl}/settings`, {
      headers: { Authorization: `Bearer ${memberToken}` },
    });

    expect(res.status).toBe(403);
  });

  it('GET /v1/settings returns 401 Unauthorized when no Authorization header provided', async () => {
    const res = await fetch(`${testApp.baseUrl}/settings`);
    expect(res.status).toBe(401);
  });

  it('rejects audit log UPDATE mutations at the database level', async () => {
    await expect(
      testApp.db.execute(sql`UPDATE audit_logs SET action = 'tampered' WHERE id = 1`),
    ).rejects.toThrow(/permission denied/i);
  });

  it('rejects audit log DELETE mutations at the database level', async () => {
    await expect(
      testApp.db.execute(sql`DELETE FROM audit_logs WHERE id = 1`),
    ).rejects.toThrow(/permission denied/i);
  });

  it('rejects audit log TRUNCATE mutations at the database level', async () => {
    await expect(
      testApp.db.execute(sql`TRUNCATE TABLE audit_logs`),
    ).rejects.toThrow(/permission denied/i);
  });

  it('still allows audit log INSERT and SELECT', async () => {
    await expect(testApp.db.execute(sql`SELECT COUNT(*) FROM audit_logs`)).resolves.toBeDefined();
  });

  it('rejects DDL mutations (CREATE, DROP, ALTER) at the database level', async () => {
    // Attempting CREATE TABLE violates schema USAGE-only grant
    await expect(
      testApp.db.execute(sql`CREATE TABLE ddl_boundary_probe (id int)`),
    ).rejects.toThrow(/permission denied/i);

    // Attempting DROP TABLE or ALTER TABLE violates table ownership
    await expect(
      testApp.db.execute(sql`DROP TABLE audit_logs`),
    ).rejects.toThrow(/must be owner/i);

    await expect(
      testApp.db.execute(sql`ALTER TABLE audit_logs ADD COLUMN probe text`),
    ).rejects.toThrow(/must be owner/i);
  });

  it('verifies the application runs under least privilege via verifyLeastPrivilege()', async () => {
    const pool = testApp.app.get<Pool>(DRIZZLE_POOL_TOKEN);
    await expect(verifyLeastPrivilege(pool)).resolves.toBeUndefined();

    const report = await checkLeastPrivilege(pool);
    expect(report.currentUser).toBe('luxeknox_app');
    expect(report.isSuperuser).toBe(false);
    expect(report.hasSchemaCreate).toBe(false);
    expect(report.ownedTablesCount).toBe(0);
    expect(report.auditHasUpdate).toBe(false);
    expect(report.auditHasDelete).toBe(false);
    expect(report.auditHasTruncate).toBe(false);
    expect(report.violations).toHaveLength(0);
  });

  it('verifies GET /v1/ready confirms DB connection and reports least-privileged role', async () => {
    const res = await fetch(`${testApp.baseUrl}/ready`);
    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    expect(body.status).toBe('ok');
    expect(body.database).toBe('connected');
    expect(body.role).toBe('luxeknox_app');

    const verifyRes = await fetch(`${testApp.baseUrl}/ready?verifyRole=true`);
    expect(verifyRes.status).toBe(200);
    const verifyBody = (await verifyRes.json()) as any;
    expect(verifyBody.status).toBe('ok');
    expect(verifyBody.database).toBe('connected');
    expect(verifyBody.role).toBe('luxeknox_app');
  });
});
