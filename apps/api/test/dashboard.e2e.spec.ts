import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  MEMBER_CREDENTIALS,
  TRAINER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';

async function login(baseUrl: string, identifier: string, password: string): Promise<string> {
  const res = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ identifier, password }),
  });
  expect(res.status).toBe(200);
  const data = (await res.json()) as any;
  return data.accessToken as string;
}

describe('Dashboard E2E', () => {
  let testApp: TestAppInstance;

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);
  });

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('rejects unauthenticated requests', async () => {
    const res = await fetch(`${testApp.baseUrl}/dashboard`);
    expect(res.status).toBe(401);
  });

  it('returns the admin widget with real aggregates for the super admin', async () => {
    const token = await login(testApp.baseUrl, ADMIN_CREDENTIALS.email, ADMIN_CREDENTIALS.password);

    const res = await fetch(`${testApp.baseUrl}/dashboard`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    expect(body.role).toBe('admin');
    expect(body.admin).toBeDefined();
    expect(typeof body.admin.members_total).toBe('number');
    expect(typeof body.admin.trainers_total).toBe('number');
    expect(typeof body.admin.employees_total).toBe('number');
    expect(body.admin.memberships_by_status).toEqual(expect.any(Object));
    expect(body.admin.memberships_expiring_soon).toEqual({
      days: 7,
      count: expect.any(Number),
    });
    // Bootstrap admin has no PEOPLE profile, so member/trainer sections are omitted.
    expect(body.member).toBeUndefined();
    expect(body.trainer).toBeUndefined();
  });

  it('omits the member widget for a member user with no PEOPLE profile row yet', async () => {
    const token = await login(testApp.baseUrl, MEMBER_CREDENTIALS.email, MEMBER_CREDENTIALS.password);

    const res = await fetch(`${testApp.baseUrl}/dashboard`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    expect(body.role).toBe('member');
    expect(body.member).toBeUndefined();
    expect(body.admin).toBeUndefined();
  });

  it('omits the trainer widget for a trainer user with no PEOPLE profile row yet', async () => {
    const token = await login(testApp.baseUrl, TRAINER_CREDENTIALS.email, TRAINER_CREDENTIALS.password);

    const res = await fetch(`${testApp.baseUrl}/dashboard`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    expect(body.role).toBe('trainer');
    expect(body.trainer).toBeUndefined();
    expect(body.admin).toBeUndefined();
  });
});
