import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { sql } from 'drizzle-orm';
import {
  createTestApp,
  E2E_ADMIN_CREDENTIALS,
  seedTestAdmin,
  type TestAppInstance,
} from './helpers/mysql';
import { PtAccessService } from '../src/pt/pt-access.service';
import { PtScheduleService } from '../src/pt/pt-schedule.service';
import { PtSubscriptionService } from '../src/pt/pt-subscription.service';

// Shared MySQL + password hashing; allow a loaded machine.
vi.setConfig({ testTimeout: 90_000 });

const RUN_ID = Date.now();
const PASSWORD = 'CouplePtSecurePassword123!';
const WEEKDAYS = [1, 3, 5];
const SLOT = '17:00';
const BUSY_SLOT = '18:00:00';

function isoToday(offsetDays = 0): string {
  const d = new Date();
  d.setUTCDate(d.getUTCDate() + offsetDays);
  return d.toISOString().slice(0, 10);
}

function rowsOf<T>(result: unknown): T[] {
  if (!Array.isArray(result)) return [];
  return (Array.isArray(result[0]) ? result[0] : result) as T[];
}

/**
 * CP-21 — couple PT against real MySQL: discounted sale, one invoice on the
 * primary, shared capacity-2 sessions, partner-busy conflict, linked renew /
 * change-slot / reassign, status job, and trainer write access for both members.
 */
describe('Couple PT E2E (CP-21)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let paymentMethodId: number;
  let gymProductId: number;
  let singlePtProductId: number;
  let couplePtProductId: number;
  let trainer1Id: number;
  let trainer2Id: number;

  const members: Record<'a' | 'b' | 'c' | 'd' | 'e', { id: number; userId: number }> = {} as any;

  let couplePrimaryId: number;
  let couplePartnerId: number;
  let renewedPrimaryId: number;
  let renewedPartnerId: number;

  let accessService: PtAccessService;
  let scheduleService: PtScheduleService;
  let subscriptionService: PtSubscriptionService;

  async function api(method: string, path: string, body?: unknown, token = adminToken) {
    const res = await fetch(`${testApp.baseUrl}${path}`, {
      method,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const text = await res.text();
    return { status: res.status, body: text ? (JSON.parse(text) as any) : null };
  }

  async function createMember(tag: string) {
    const res = await api('POST', '/members', {
      email: `e2e_pt_couple_${tag}_${RUN_ID}@luxeknox.test`,
      password: PASSWORD,
      first_name: `PtCouple${tag.toUpperCase()}`,
      last_name: 'Tester',
      gender: 'female',
    });
    expect(res.status).toBe(201);
    return { id: res.body.id as number, userId: res.body.user_id as number };
  }

  async function createTrainer(tag: string) {
    const res = await api('POST', '/trainers', {
      email: `e2e_pt_couple_trainer_${tag}_${RUN_ID}@luxeknox.test`,
      password: PASSWORD,
      first_name: `PtTrainer${tag.toUpperCase()}`,
      last_name: 'Coach',
      gender: 'male',
      max_clients_capacity: 20,
    });
    expect(res.status, JSON.stringify(res.body)).toBe(201);
    return res.body.id as number;
  }

  async function sellGymMembership(memberId: number) {
    const res = await api('POST', '/memberships', {
      member_id: memberId,
      product_id: gymProductId,
      start_date: isoToday(),
      payment_method_id: paymentMethodId,
    });
    expect(res.status).toBe(201);
    return res.body.id as number;
  }

  async function getPt(id: number) {
    const res = await api('GET', `/pt-subscriptions/${id}`);
    expect(res.status).toBe(200);
    return res.body;
  }

  const preTax = (p: { total_amount: string; tax_amount: string }) =>
    (Number(p.total_amount) - Number(p.tax_amount)).toFixed(2);

  async function paymentsFor(ptSubscriptionIds: number[]) {
    const ids = sql.join(
      ptSubscriptionIds.map((i) => sql`${i}`),
      sql`, `,
    );
    return rowsOf<{
      pt_subscription_id: number;
      member_id: number;
      subtotal: string;
      discount_amount: string;
      tax_amount: string;
      total_amount: string;
    }>(
      await testApp.db.execute(
        sql`SELECT pt_subscription_id, member_id, subtotal, discount_amount, tax_amount, total_amount
            FROM payments WHERE pt_subscription_id IN (${ids})`,
      ),
    );
  }

  async function sessionsFor(ptSubscriptionId: number) {
    return rowsOf<{
      id: number;
      max_capacity: number;
      title: string;
      trainer_id: number;
      participant_count: number;
    }>(
      await testApp.db.execute(sql`
        SELECT s.id, s.max_capacity, s.title, s.trainer_id,
               (SELECT COUNT(*) FROM schedule_participants sp
                WHERE sp.schedule_id = s.id AND sp.booking_status = 'booked') AS participant_count
        FROM schedules s
        WHERE s.pt_subscription_id = ${ptSubscriptionId} AND s.status = 'scheduled'
        ORDER BY s.start_time
      `),
    );
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestAdmin(testApp.db);
    accessService = testApp.app.get(PtAccessService);
    scheduleService = testApp.app.get(PtScheduleService);
    subscriptionService = testApp.app.get(PtSubscriptionService);

    const login = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: E2E_ADMIN_CREDENTIALS.email,
        password: E2E_ADMIN_CREDENTIALS.password,
      }),
    });
    expect(login.status).toBe(200);
    const loginBody = (await login.json()) as any;
    adminToken = loginBody.accessToken ?? loginBody.access_token;

    const methods = await api('GET', '/payment-methods');
    expect(methods.status).toBe(200);
    const active = (methods.body.data as any[]).find((m) => m.is_active);
    if (active) {
      paymentMethodId = active.id;
    } else {
      const created = await api('POST', '/payment-methods', { method_name: `E2E PT Cash ${RUN_ID}` });
      expect(created.status).toBe(201);
      paymentMethodId = created.body.id;
    }

    const gym = await api('POST', '/membership-products', {
      name: `E2E PT Gym ${RUN_ID}`,
      code: `E2E_PT_GYM_${RUN_ID}`,
      duration_days: 365,
      base_price: '1000.00',
      max_freeze_days: 30,
      package_type: 'single',
    });
    expect(gym.status).toBe(201);
    gymProductId = gym.body.id;

    const singlePt = await api('POST', '/pt-products', {
      name: `E2E Single PT ${RUN_ID}`,
      code: `E2E_PT_S_${RUN_ID}`.slice(0, 32),
      duration_days: 30,
      base_price: '3999.00',
      package_type: 'single',
    });
    expect(singlePt.status).toBe(201);
    singlePtProductId = singlePt.body.id;

    const couplePt = await api('POST', '/pt-products', {
      name: `E2E Couple PT ${RUN_ID}`,
      code: `E2E_PT_C_${RUN_ID}`.slice(0, 32),
      duration_days: 30,
      base_price: '6999.00',
      package_type: 'couple',
    });
    expect(couplePt.status).toBe(201);
    couplePtProductId = couplePt.body.id;

    trainer1Id = await createTrainer('1');
    trainer2Id = await createTrainer('2');

    for (const tag of ['a', 'b', 'c', 'd', 'e'] as const) {
      members[tag] = await createMember(tag);
      await sellGymMembership(members[tag].id);
    }
  }, 180_000);

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('rejects invalid couple sales', async () => {
    const base = {
      trainer_id: trainer1Id,
      start_date: isoToday(),
      weekdays: WEEKDAYS,
      slot_start: SLOT,
      payment_method_id: paymentMethodId,
    };

    const missingPartner = await api('POST', '/pt-subscriptions', {
      ...base,
      member_id: members.a.id,
      pt_product_id: couplePtProductId,
    });
    expect(missingPartner.status).toBe(400);

    const singleWithPartner = await api('POST', '/pt-subscriptions', {
      ...base,
      member_id: members.a.id,
      pt_product_id: singlePtProductId,
      partner_member_id: members.b.id,
    });
    expect(singleWithPartner.status).toBe(400);

    const selfPartner = await api('POST', '/pt-subscriptions', {
      ...base,
      member_id: members.a.id,
      pt_product_id: couplePtProductId,
      partner_member_id: members.a.id,
    });
    expect(selfPartner.status).toBe(400);
  });

  it('blocks the slot when only the partner is busy elsewhere', async () => {
    const startDate = isoToday();
    const endDate = isoToday(30);
    const windows = await scheduleService.occurrenceWindows(startDate, endDate, WEEKDAYS, BUSY_SLOT);
    expect(windows.length).toBeGreaterThan(0);
    const first = windows[0]!;
    expect(Number.isNaN(first.start.getTime())).toBe(false);

    const typeRows = rowsOf<{ id: number }>(
      await testApp.db.execute(sql`SELECT id FROM schedule_types WHERE name = 'Personal Training' LIMIT 1`),
    );
    const scheduleTypeId = typeRows[0]!.id;
    const startIso = first.start.toISOString().slice(0, 19).replace('T', ' ');
    const endIso = first.end.toISOString().slice(0, 19).replace('T', ' ');
    const busyInsert = rowsOf<{ id: number }>(
      await testApp.db.execute(sql`
        INSERT INTO schedules (schedule_type_id, title, start_time, end_time, max_capacity, status, row_version, created_at)
        VALUES (${scheduleTypeId}, ${`E2E Partner Busy ${RUN_ID}`}, ${startIso}, ${endIso}, 10, 'scheduled', 1, NOW(3))
      `),
    );
    // mysql2 returns OkPacket; fetch last insert id explicitly
    const idRows = rowsOf<{ id: number }>(
      await testApp.db.execute(sql`SELECT LAST_INSERT_ID() AS id`),
    );
    const scheduleId = Number(idRows[0]!.id);
    expect(scheduleId).toBeGreaterThan(0);
    void busyInsert;
    await testApp.db.execute(sql`
      INSERT INTO schedule_participants (schedule_id, member_id, booking_status, booked_at)
      VALUES (${scheduleId}, ${members.c.id}, 'booked', NOW(3))
    `);

    const res = await api('POST', '/pt-subscriptions', {
      member_id: members.a.id,
      partner_member_id: members.c.id,
      pt_product_id: couplePtProductId,
      trainer_id: trainer1Id,
      start_date: startDate,
      weekdays: WEEKDAYS,
      slot_start: BUSY_SLOT,
      payment_method_id: paymentMethodId,
    });
    expect(res.status).toBe(409);
  });

  it('sells a couple PT with a discount: linked rows, one invoice on primary, shared sessions', async () => {
    const res = await api('POST', '/pt-subscriptions', {
      member_id: members.a.id,
      partner_member_id: members.b.id,
      pt_product_id: couplePtProductId,
      trainer_id: trainer1Id,
      start_date: isoToday(),
      weekdays: WEEKDAYS,
      slot_start: SLOT,
      discount_amount: '500.00',
      payment_method_id: paymentMethodId,
    });
    expect(res.status).toBe(201);
    expect(res.body.subscription).toBeTruthy();
    expect(res.body.payment).toBeTruthy();

    couplePrimaryId = res.body.subscription.id;
    couplePartnerId = res.body.subscription.partner_subscription_id;
    expect(couplePartnerId).toBeGreaterThan(0);
    expect(res.body.subscription.is_primary).toBe(true);
    expect(res.body.subscription.package_type).toBe('couple');
    expect(res.body.subscription.partner_member_id).toBe(members.b.id);

    const a = await getPt(couplePrimaryId);
    const b = await getPt(couplePartnerId);
    expect(a.partner_subscription_id).toBe(couplePartnerId);
    expect(b.partner_subscription_id).toBe(couplePrimaryId);
    expect(b.is_primary).toBe(false);
    expect(a.start_date).toBe(b.start_date);
    expect(a.end_date).toBe(b.end_date);
    expect(a.trainer_id).toBe(trainer1Id);
    expect(b.trainer_id).toBe(trainer1Id);
    expect(a.slot_start).toMatch(/^17:00/);
    expect(b.slot_start).toMatch(/^17:00/);
    expect(a.status).toBe('active');
    expect(b.status).toBe('active');

    const invoices = await paymentsFor([couplePrimaryId, couplePartnerId]);
    expect(invoices).toHaveLength(1);
    expect(invoices[0]!.pt_subscription_id).toBe(couplePrimaryId);
    expect(invoices[0]!.member_id).toBe(members.a.id);
    expect(invoices[0]!.subtotal).toBe('6999.00');
    expect(invoices[0]!.discount_amount).toBe('500.00');
    expect(preTax(invoices[0]!)).toBe('6499.00');

    const sessions = await sessionsFor(couplePrimaryId);
    expect(sessions.length).toBeGreaterThan(0);
    for (const s of sessions) {
      expect(s.max_capacity).toBe(2);
      expect(Number(s.participant_count)).toBe(2);
      expect(s.trainer_id).toBe(trainer1Id);
      expect(s.title).toMatch(/PT ·/);
    }
    const partnerOwned = await sessionsFor(couplePartnerId);
    expect(partnerOwned).toHaveLength(0);

    expect(await accessService.trainerAccess(trainer1Id, members.a.id)).toBe('full');
    expect(await accessService.trainerAccess(trainer1Id, members.b.id)).toBe('full');
  });

  it('renews from the partner side into two new linked rows billed on the new primary', async () => {
    const beforeA = await getPt(couplePrimaryId);
    const beforeB = await getPt(couplePartnerId);

    const renewed = await api('POST', `/pt-subscriptions/${couplePartnerId}/renew`, {
      payment_method_id: paymentMethodId,
    });
    expect(renewed.status).toBe(201);
    renewedPrimaryId = renewed.body.subscription.id;
    renewedPartnerId = renewed.body.subscription.partner_subscription_id;
    expect(renewedPartnerId).toBeGreaterThan(0);

    const a = await getPt(renewedPrimaryId);
    const b = await getPt(renewedPartnerId);
    expect(a.is_primary).toBe(true);
    expect(b.is_primary).toBe(false);
    expect(a.partner_subscription_id).toBe(renewedPartnerId);
    expect(b.partner_subscription_id).toBe(renewedPrimaryId);
    expect(a.start_date).toBe(b.start_date);
    expect(a.end_date).toBe(b.end_date);
    expect(a.start_date > beforeA.end_date || a.start_date === isoToday()).toBe(true);
    expect(beforeA.status).toBe((await getPt(couplePrimaryId)).status);
    expect(beforeB.id).toBe(couplePartnerId);

    const invoices = await paymentsFor([renewedPrimaryId, renewedPartnerId]);
    expect(invoices).toHaveLength(1);
    expect(invoices[0]!.pt_subscription_id).toBe(renewedPrimaryId);
    expect(invoices[0]!.member_id).toBe(members.a.id);
  });

  it('changes the slot from the partner side on both renewed rows', async () => {
    const effective = (await getPt(renewedPartnerId)).start_date;
    const res = await api('POST', `/pt-subscriptions/${renewedPartnerId}/change-slot`, {
      weekdays: WEEKDAYS,
      slot_start: '16:00',
      effective_date: effective,
      reason: 'e2e couple change slot',
    });
    // Nest POST defaults to 201 when @HttpCode is omitted.
    expect([200, 201]).toContain(res.status);

    const a = await getPt(renewedPrimaryId);
    const b = await getPt(renewedPartnerId);
    expect(a.slot_start).toMatch(/^16:00/);
    expect(b.slot_start).toMatch(/^16:00/);
    expect(a.weekdays).toEqual(expect.arrayContaining(WEEKDAYS));
    expect(b.weekdays).toEqual(expect.arrayContaining(WEEKDAYS));

    const sessions = await sessionsFor(renewedPrimaryId);
    expect(sessions.length).toBeGreaterThan(0);
    for (const s of sessions) {
      expect(s.max_capacity).toBe(2);
      expect(Number(s.participant_count)).toBe(2);
    }
  });

  it('reassigns the trainer from either side onto both rows', async () => {
    // Original pair is still active (start=today). Reassign with effective today so
    // trainer_id updates immediately; sessions regenerate under the new trainer.
    const effective = isoToday();
    const res = await api('POST', `/pt-subscriptions/${couplePartnerId}/reassign-trainer`, {
      trainer_id: trainer2Id,
      effective_date: effective,
      reason: 'e2e couple reassign',
    });
    expect([200, 201]).toContain(res.status);

    const a = await getPt(couplePrimaryId);
    const b = await getPt(couplePartnerId);
    expect(a.trainer_id).toBe(trainer2Id);
    expect(b.trainer_id).toBe(trainer2Id);

    const sessions = await sessionsFor(couplePrimaryId);
    expect(sessions.length).toBeGreaterThan(0);
    for (const s of sessions) {
      expect(s.trainer_id).toBe(trainer2Id);
      expect(s.max_capacity).toBe(2);
    }

    expect(await accessService.trainerAccess(trainer2Id, members.a.id)).toBe('full');
    expect(await accessService.trainerAccess(trainer2Id, members.b.id)).toBe('full');
    expect(await accessService.trainerAccess(trainer1Id, members.a.id)).toBe('read_only');
  });

  it('status job activates and completes both rows of a linked pair together', async () => {
    const startDate = isoToday(2);
    const purchase = await api('POST', '/pt-subscriptions', {
      member_id: members.d.id,
      partner_member_id: members.e.id,
      pt_product_id: couplePtProductId,
      trainer_id: trainer1Id,
      start_date: startDate,
      weekdays: WEEKDAYS,
      slot_start: '19:00',
      payment_method_id: paymentMethodId,
    });
    expect(purchase.status).toBe(201);
    const primaryId = purchase.body.subscription.id as number;
    const partnerId = purchase.body.subscription.partner_subscription_id as number;
    expect((await getPt(primaryId)).status).toBe('scheduled');
    expect((await getPt(partnerId)).status).toBe('scheduled');

    const today = isoToday();
    await testApp.db.execute(
      sql`UPDATE pt_subscriptions SET start_date = ${today} WHERE id IN (${primaryId}, ${partnerId})`,
    );

    const activated = await subscriptionService.runStatusTransitions();
    expect(activated.activated).toBeGreaterThanOrEqual(2);
    expect((await getPt(primaryId)).status).toBe('active');
    expect((await getPt(partnerId)).status).toBe('active');
    expect(await accessService.trainerAccess(trainer1Id, members.d.id)).toBe('full');
    expect(await accessService.trainerAccess(trainer1Id, members.e.id)).toBe('full');

    const yesterday = isoToday(-1);
    await testApp.db.execute(
      sql`UPDATE pt_subscriptions SET end_date = ${yesterday} WHERE id IN (${primaryId}, ${partnerId})`,
    );

    const completed = await subscriptionService.runStatusTransitions();
    expect(completed.completed).toBeGreaterThanOrEqual(2);
    expect((await getPt(primaryId)).status).toBe('completed');
    expect((await getPt(partnerId)).status).toBe('completed');
    expect(await accessService.trainerAccess(trainer1Id, members.d.id)).toBe('read_only');
    expect(await accessService.trainerAccess(trainer1Id, members.e.id)).toBe('read_only');
  });
});
