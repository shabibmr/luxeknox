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

// Unique per test run so repeated local runs (no resetTestData yet — todo/fixes/F-14-e2e-ci-gaps.md)
// don't collide on `name`.
const RUN_ID = Date.now();
const uniqueName = (label: string) => `e2e_${label}_${RUN_ID}`;

describe('Exercises E2E', () => {
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
    it('GET /exercises returns 401 without a token', async () => {
      const res = await fetch(`${testApp.baseUrl}/exercises`);
      expect(res.status).toBe(401);
    });

    it('GET /exercises succeeds for admin, trainer, and member', async () => {
      for (const token of [adminToken, trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/exercises`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        expect(res.status).toBe(200);
      }
    });

    it('POST /exercises returns 403 for trainer and member', async () => {
      for (const token of [trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/exercises`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ name: uniqueName('forbidden') }),
        });
        expect(res.status).toBe(403);
      }
    });

    it('PATCH /exercises/:id returns 403 for trainer and member', async () => {
      const createRes = await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ name: uniqueName('patch_target') }),
      });
      const created = (await createRes.json()) as any;

      for (const token of [trainerToken, memberToken]) {
        const res = await fetch(`${testApp.baseUrl}/exercises/${created.id}`, {
          method: 'PATCH',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ is_active: false }),
        });
        expect(res.status).toBe(403);
      }
    });
  });

  describe('admin CRUD (FR-WORK-001)', () => {
    it('creates an exercise and writes an audit row', async () => {
      const name = uniqueName('bench_press');
      const res = await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name,
          primary_muscle_group: 'chest',
          equipment_needed: 'barbell',
          difficulty_level: 'intermediate',
          secondary_muscles: ['triceps', 'shoulders'],
        }),
      });

      expect(res.status).toBe(201);
      const body = (await res.json()) as any;
      expect(body.name).toBe(name);
      expect(body.is_active).toBe(true);
      // On real MySQL 8.4 (the target engine, ADR-0002) mysql2 auto-parses the native JSON
      // column. This suite may also run against a MariaDB dev server that stores it as TEXT and
      // returns a raw JSON string instead — tolerate both without weakening the assertion.
      const secondaryMuscles =
        typeof body.secondary_muscles === 'string'
          ? JSON.parse(body.secondary_muscles)
          : body.secondary_muscles;
      expect(secondaryMuscles).toEqual(['triceps', 'shoulders']);

      const [auditRows] = (await testApp.db.execute(
        sql`SELECT action FROM audit_logs WHERE entity_name = 'exercises' AND entity_id = ${body.id} AND action = 'exercise.created'`,
      )) as any;
      expect(auditRows.length).toBeGreaterThan(0);
    });

    it('rejects creation missing the required name field', async () => {
      const res = await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ primary_muscle_group: 'chest' }),
      });
      expect(res.status).toBe(400);
    });

    it('GET /exercises/:id returns 404 for a missing id', async () => {
      const res = await fetch(`${testApp.baseUrl}/exercises/999999999`, {
        headers: { Authorization: `Bearer ${adminToken}` },
      });
      expect(res.status).toBe(404);
    });

    it('PATCH with only is_active leaves other fields untouched (partial update)', async () => {
      const createRes = await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name: uniqueName('deadlift'),
          instructions: 'Keep your back straight.',
        }),
      });
      const created = (await createRes.json()) as any;

      const patchRes = await fetch(`${testApp.baseUrl}/exercises/${created.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ is_active: false }),
      });

      expect(patchRes.status).toBe(200);
      const patched = (await patchRes.json()) as any;
      expect(patched.is_active).toBe(false);
      expect(patched.instructions).toBe('Keep your back straight.');
    });

    it('deactivated exercises drop out of the default (active-only) list for members', async () => {
      const name = uniqueName('deactivated_exercise');
      const createRes = await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ name }),
      });
      const created = (await createRes.json()) as any;

      await fetch(`${testApp.baseUrl}/exercises/${created.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ is_active: false }),
      });

      const memberListRes = await fetch(`${testApp.baseUrl}/exercises?q=${encodeURIComponent(name)}`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      const memberList = (await memberListRes.json()) as any;
      expect(memberList.data.find((e: any) => e.id === created.id)).toBeUndefined();

      // Admin (holds exercises.update) still sees it via getById.
      const adminGetRes = await fetch(`${testApp.baseUrl}/exercises/${created.id}`, {
        headers: { Authorization: `Bearer ${adminToken}` },
      });
      expect(adminGetRes.status).toBe(200);

      // Member cannot: deactivated exercises are treated as not found for non-privileged callers.
      const memberGetRes = await fetch(`${testApp.baseUrl}/exercises/${created.id}`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      expect(memberGetRes.status).toBe(404);
    });
  });

  describe('browse & search (FR-WORK-002)', () => {
    it('filters by primary_muscle_group, equipment_needed, and difficulty_level', async () => {
      const name = uniqueName('filter_target');
      await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({
          name,
          primary_muscle_group: 'back',
          equipment_needed: 'pull-up bar',
          difficulty_level: 'advanced',
        }),
      });

      const res = await fetch(
        `${testApp.baseUrl}/exercises?primary_muscle_group=back&equipment_needed=${encodeURIComponent('pull-up bar')}&difficulty_level=advanced`,
        { headers: { Authorization: `Bearer ${trainerToken}` } },
      );
      const body = (await res.json()) as any;
      expect(body.data.some((e: any) => e.name === name)).toBe(true);
    });

    it('q is a case-insensitive substring match on name', async () => {
      const name = uniqueName('CaseSensitiveSearch');
      await fetch(`${testApp.baseUrl}/exercises`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
        body: JSON.stringify({ name }),
      });

      const res = await fetch(`${testApp.baseUrl}/exercises?q=${encodeURIComponent(name.toLowerCase())}`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      const body = (await res.json()) as any;
      expect(body.data.some((e: any) => e.name === name)).toBe(true);
    });
  });

  describe('pagination (PageMeta contract)', () => {
    it('returns limit/offset/has_more/total in the response envelope', async () => {
      const res = await fetch(`${testApp.baseUrl}/exercises?limit=2&offset=0`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      const body = (await res.json()) as any;

      expect(body.meta).toHaveProperty('limit', 2);
      expect(body.meta).toHaveProperty('offset', 0);
      expect(body.meta).toHaveProperty('has_more');
      expect(body.meta).toHaveProperty('total');
      expect(body.data.length).toBeLessThanOrEqual(2);
    });

    it('offset advances past the first page without repeating rows', async () => {
      const nameA = uniqueName('page_a');
      const nameB = uniqueName('page_b');
      for (const name of [nameA, nameB]) {
        await fetch(`${testApp.baseUrl}/exercises`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${adminToken}` },
          body: JSON.stringify({ name }),
        });
      }

      const page1Res = await fetch(`${testApp.baseUrl}/exercises?limit=1&offset=0`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      const page1 = (await page1Res.json()) as any;

      const page2Res = await fetch(`${testApp.baseUrl}/exercises?limit=1&offset=1`, {
        headers: { Authorization: `Bearer ${memberToken}` },
      });
      const page2 = (await page2Res.json()) as any;

      expect(page1.data[0]?.id).not.toBe(page2.data[0]?.id);
    });
  });
});
