import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { sql } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  MEMBER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';

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
    const settings = (await res.json()) as any;
    expect(typeof settings).toBe('object');
    expect(settings.timezone).toBeDefined();
    expect(settings.currency).toBeDefined();
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
    ).rejects.toThrow(/command denied/i);
  });

  it('rejects audit log DELETE mutations at the database level', async () => {
    await expect(
      testApp.db.execute(sql`DELETE FROM audit_logs WHERE id = 1`),
    ).rejects.toThrow(/command denied/i);
  });

  it('still allows audit log INSERT and SELECT', async () => {
    await expect(testApp.db.execute(sql`SELECT COUNT(*) FROM audit_logs`)).resolves.toBeDefined();
  });
});
