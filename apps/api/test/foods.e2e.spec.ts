import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { sql } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  MEMBER_CREDENTIALS,
  TRAINER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';

const RUN_ID = Date.now();
const uniqueName = (label: string) => `e2e_food_${label}_${RUN_ID}`;

describe('Foods E2E', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let trainerToken: string;
  let memberToken: string;

  async function login(identifier: string, password: string): Promise<string> {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identifier, password }),
    });
    const data = (await res.json()) as any;
    return data.accessToken;
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);

    adminToken = await login(ADMIN_CREDENTIALS.email, ADMIN_CREDENTIALS.password);
    trainerToken = await login(TRAINER_CREDENTIALS.email, TRAINER_CREDENTIALS.password);
    memberToken = await login(MEMBER_CREDENTIALS.email, MEMBER_CREDENTIALS.password);
  });

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  describe('authorization', () => {
    it('GET /foods returns 401 without a token', async () => {
      const res = await fetch(`${testApp.baseUrl}/foods`);
      expect(res.status).toBe(401);
    });

    it('GET /foods succeeds for admin, trainer, and member', async () => {
      for (const token of [adminToken, trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/foods`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        expect(res.status).toBe(200);
      }
    });

    it('POST /foods returns 403 for trainer and member', async () => {
      for (const token of [trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/foods`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ name: uniqueName('forbidden'), serving_unit: 'g' }),
        });
        expect(res.status).toBe(403);
      }
    });

    it('PATCH /foods/:id returns 403 for trainer and member', async () => {
      const createRes = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('patch_target'),
          serving_unit: 'g',
          is_verified: true,
        }),
      });
      const created = (await createRes.json()) as any;

      for (const token of [trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/foods/${created.id}`, {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ is_active: false }),
        });
        expect(res.status).toBe(403);
      }
    });
  });

  describe('admin CRUD (FR-DIET-001)', () => {
    it('creates a food and writes an audit row', async () => {
      const name = uniqueName('chicken');
      const res = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name,
          serving_unit: 'g',
          serving_size: 100,
          calories: 165,
          protein_grams: 31,
          is_verified: true,
        }),
      });

      expect(res.status).toBe(201);
      const body = (await res.json()) as any;
      expect(body.name).toBe(name);
      expect(body.serving_unit).toBe('g');
      expect(body.is_active).toBe(true);
      expect(body.is_verified).toBe(true);

      const [auditRows] = (await testApp.db.execute(
        sql`SELECT action FROM audit_logs WHERE entity_name = 'foods' AND entity_id = ${body.id} AND action = 'food.created'`,
      )) as any;
      expect(auditRows.length).toBeGreaterThan(0);
    });

    it('rejects creation missing required fields', async () => {
      const res = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ name: uniqueName('missing_unit') }),
      });
      expect(res.status).toBe(400);
    });

    it('GET /foods/:id returns 404 for a missing id', async () => {
      const res = await fetch(`${testApp.baseUrl}/foods/999999999`, {
        headers: { Authorization: `Bearer ${adminToken}` },
      });
      expect(res.status).toBe(404);
    });

    it('PATCH with only is_active leaves other fields untouched', async () => {
      const createRes = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('oats'),
          serving_unit: 'g',
          calories: 389,
          is_verified: true,
        }),
      });
      const created = (await createRes.json()) as any;

      const patchRes = await fetch(`${testApp.baseUrl}/foods/${created.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ is_active: false }),
      });
      expect(patchRes.status).toBe(200);
      const patched = (await patchRes.json()) as any;
      expect(patched.is_active).toBe(false);
      expect(patched.name).toBe(created.name);
      expect(patched.calories).toBe(created.calories);
    });
  });

  describe('browse visibility (verified+active)', () => {
    it('hides unverified and inactive foods from trainer/member list and get', async () => {
      const unverifiedRes = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('unverified'),
          serving_unit: 'g',
          is_verified: false,
          is_active: true,
        }),
      });
      const unverified = (await unverifiedRes.json()) as any;

      const inactiveRes = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('inactive'),
          serving_unit: 'g',
          is_verified: true,
          is_active: false,
        }),
      });
      const inactive = (await inactiveRes.json()) as any;

      const visibleRes = await fetch(`${testApp.baseUrl}/foods`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('visible'),
          serving_unit: 'g',
          is_verified: true,
          is_active: true,
        }),
      });
      const visible = (await visibleRes.json()) as any;

      for (const token of [trainerToken, memberToken]) {
        const listRes = await fetch(`${testApp.baseUrl}/foods?q=e2e_food_`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        expect(listRes.status).toBe(200);
        const list = (await listRes.json()) as any;
        const ids = list.data.map((row: any) => row.id);
        expect(ids).toContain(visible.id);
        expect(ids).not.toContain(unverified.id);
        expect(ids).not.toContain(inactive.id);

        const getUnverified = await fetch(`${testApp.baseUrl}/foods/${unverified.id}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        expect(getUnverified.status).toBe(404);

        const getInactive = await fetch(`${testApp.baseUrl}/foods/${inactive.id}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        expect(getInactive.status).toBe(404);
      }

      const adminGet = await fetch(`${testApp.baseUrl}/foods/${unverified.id}`, {
        headers: { Authorization: `Bearer ${adminToken}` },
      });
      expect(adminGet.status).toBe(200);
    });
  });
});
