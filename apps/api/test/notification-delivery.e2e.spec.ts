import { afterAll, beforeAll, describe, expect, it } from 'vitest';
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

describe('Notification & Device Delivery E2E (NOT-016)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let memberToken: string;
  let trainerToken: string;

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);

    adminToken = await login(testApp.baseUrl, ADMIN_CREDENTIALS.email, ADMIN_CREDENTIALS.password);
    memberToken = await login(testApp.baseUrl, MEMBER_CREDENTIALS.email, MEMBER_CREDENTIALS.password);
    trainerToken = await login(testApp.baseUrl, TRAINER_CREDENTIALS.email, TRAINER_CREDENTIALS.password);
  }, 120_000);

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('allows a member to register and list their push device', async () => {
    const regRes = await fetch(`${testApp.baseUrl}/devices`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${memberToken}`,
      },
      body: JSON.stringify({
        device_token: `fcm_token_e2e_${Date.now()}`,
        device_platform: 'android',
      }),
    });

    expect(regRes.status).toBe(201);
    const device = (await regRes.json()) as any;
    expect(device.id).toBeDefined();
    expect(device.device_platform).toBe('android');

    const listRes = await fetch(`${testApp.baseUrl}/devices`, {
      headers: { Authorization: `Bearer ${memberToken}` },
    });
    expect(listRes.status).toBe(200);
    const body = (await listRes.json()) as any;
    expect(body.data.some((d: any) => d.id === device.id)).toBe(true);

    // Delete device
    const delRes = await fetch(`${testApp.baseUrl}/devices/${device.id}`, {
      method: 'DELETE',
      headers: { Authorization: `Bearer ${memberToken}` },
    });
    expect(delRes.status).toBe(204);
  });

  it('allows an admin to broadcast to all members, and member receives it in inbox', async () => {
    const broadcastTitle = `E2E Broadcast ${Date.now()}`;

    const broadcastRes = await fetch(`${testApp.baseUrl}/notifications/broadcast`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        title: broadcastTitle,
        message: 'Important gym notice for all members.',
        audience: 'all_members',
      }),
    });

    expect(broadcastRes.status).toBe(201);
    const broadcast = (await broadcastRes.json()) as any;
    expect(broadcast.title).toBe(broadcastTitle);

    // Member checks their inbox
    const inboxRes = await fetch(`${testApp.baseUrl}/notifications`, {
      headers: { Authorization: `Bearer ${memberToken}` },
    });
    expect(inboxRes.status).toBe(200);
    const inbox = (await inboxRes.json()) as any;
    const item = inbox.data.find((n: any) => n.title === broadcastTitle);
    expect(item).toBeDefined();
    expect(item.is_read).toBe(false);

    // Member marks notification read
    const readRes = await fetch(`${testApp.baseUrl}/notifications/${item.id}/read`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${memberToken}` },
    });
    expect(readRes.status).toBe(200);
    const readItem = (await readRes.json()) as any;
    expect(readItem.is_read).toBe(true);
  });

  it('allows member to mark-all-read', async () => {
    const markAllRes = await fetch(`${testApp.baseUrl}/notifications/read-all`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${memberToken}` },
    });
    expect(markAllRes.status).toBe(204);
  });
});
