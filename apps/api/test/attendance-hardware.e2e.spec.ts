import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { eq, sql } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  TRAINER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';
import { DeviceCredentialService } from '../src/attn/device-credential.service';
import { users } from '../src/platform/db/schema/users';
import { attendances } from '../src/platform/db/schema/attendance';

const RUN_ID = Date.now();

/**
 * ATT-018 — hardware duplicate-event safety under real MySQL.
 *
 * Proves that:
 * 1. Idempotency-Key replay returns the same attendance without a second insert.
 * 2. Debounce without an idempotency key also returns the existing open visit.
 */
describe('Attendance hardware duplicate-event E2E (ATT-018)', () => {
  let testApp: TestAppInstance;
  let deviceKey: string;
  let trainerUserId: number;

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);

    const db = testApp.db as any;
    const trainerRows = await db
      .select()
      .from(users)
      .where(eq(users.email, TRAINER_CREDENTIALS.email))
      .limit(1);
    trainerUserId = trainerRows[0].id;

    const devices = testApp.app.get(DeviceCredentialService);
    const created = await devices.create(`e2e-gate-${RUN_ID}`, 'e2e north gate');
    deviceKey = created.key;

    await db.execute(sql`
      DELETE FROM attendances
      WHERE user_id = ${trainerUserId}
    `);
  }, 120_000);

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  async function checkIn(headers: Record<string, string>, body: Record<string, unknown>) {
    return fetch(`${testApp.baseUrl}/attendances/check-in`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Device-Key': deviceKey,
        ...headers,
      },
      body: JSON.stringify(body),
    });
  }

  it('replays Idempotency-Key without creating a duplicate attendance', async () => {
    const idemKey = `attn-e2e-${RUN_ID}-idem`;
    const body = {
      user_id: trainerUserId,
      method: 'rfid',
      gate_identifier: `gate-${RUN_ID}`,
    };

    const first = await checkIn({ 'Idempotency-Key': idemKey }, body);
    expect(first.status).toBe(201);
    const firstData = (await first.json()) as { id: number; user_id: number };
    expect(firstData.user_id).toBe(trainerUserId);

    const second = await checkIn({ 'Idempotency-Key': idemKey }, body);
    expect(second.status).toBe(201);
    const secondData = (await second.json()) as { id: number };
    expect(secondData.id).toBe(firstData.id);

    const db = testApp.db as any;
    const rows = await db
      .select()
      .from(attendances)
      .where(eq(attendances.user_id, trainerUserId));
    const open = rows.filter((r: { check_out_time: Date | null }) => r.check_out_time == null);
    expect(open.length).toBe(1);
  });

  it('debounce returns the same open attendance without Idempotency-Key', async () => {
    const body = {
      user_id: trainerUserId,
      method: 'rfid',
      gate_identifier: `gate-${RUN_ID}`,
    };

    const again = await checkIn({}, body);
    expect(again.status).toBe(201);
    const data = (await again.json()) as { id: number; check_out_time: string | null };
    expect(data.check_out_time).toBeNull();

    const db = testApp.db as any;
    const rows = await db
      .select()
      .from(attendances)
      .where(eq(attendances.user_id, trainerUserId));
    const open = rows.filter((r: { check_out_time: Date | null }) => r.check_out_time == null);
    expect(open.length).toBe(1);
  });
});
