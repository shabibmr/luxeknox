import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { sql } from 'drizzle-orm';
import {
  createTestApp,
  E2E_ADMIN_CREDENTIALS,
  seedTestAdmin,
  type TestAppInstance,
} from './helpers/mysql';
import { DeviceCredentialService } from '../src/attn/device-credential.service';

// Each step logs in or hashes passwords on a shared dev DB; allow for a loaded machine.
vi.setConfig({ testTimeout: 90_000 });

const RUN_ID = Date.now();
const PASSWORD = 'CoupleSecurePassword123!';

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
 * CM-25 — couple memberships against real MySQL: sale with replacement and
 * discount, preview credit, linked renew, paired freeze, linked cancel, and the
 * partner passing the gate's membership check.
 */
describe('Couple memberships E2E (CM-25)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let deviceKey: string;
  let paymentMethodId: number;
  let singleProductId: number;
  let coupleProductId: number;
  let couplePlusProductId: number;

  const members: Record<'a' | 'b' | 'c' | 'd', { id: number; userId: number }> = {} as any;
  let singleBId: number;
  let coupleAId: number;
  let coupleBId: number;

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
      email: `e2e_couple_${tag}_${RUN_ID}@luxeknox.test`,
      password: PASSWORD,
      first_name: `Couple${tag.toUpperCase()}`,
      last_name: 'Tester',
      gender: 'female',
    });
    expect(res.status).toBe(201);
    return { id: res.body.id as number, userId: res.body.user_id as number };
  }

  async function loginAs(tag: string): Promise<string> {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: `e2e_couple_${tag}_${RUN_ID}@luxeknox.test`,
        password: PASSWORD,
      }),
    });
    expect(res.status).toBe(200);
    const body = (await res.json()) as any;
    return body.accessToken ?? body.access_token;
  }

  async function createProduct(code: string, packageType: 'single' | 'couple', price: string) {
    const res = await api('POST', '/membership-products', {
      name: `E2E ${code}`,
      code: `${code}_${RUN_ID}`,
      duration_days: 30,
      base_price: price,
      max_freeze_days: 10,
      package_type: packageType,
    });
    expect(res.status).toBe(201);
    return res.body.id as number;
  }

  async function getMembership(id: number) {
    const res = await api('GET', `/memberships/${id}`);
    expect(res.status).toBe(200);
    return res.body;
  }

  async function checkIn(userId: number) {
    return fetch(`${testApp.baseUrl}/attendances/check-in`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-Device-Key': deviceKey },
      body: JSON.stringify({ user_id: userId, method: 'rfid', gate_identifier: `gate-couple-${RUN_ID}` }),
    });
  }

  /** Invoice total before tax; tax is a global setting, so assert on the base the discount produces. */
  const preTax = (p: { total_amount: string; tax_amount: string }) =>
    (Number(p.total_amount) - Number(p.tax_amount)).toFixed(2);

  async function paymentsFor(membershipIds: number[]) {
    const ids = sql.join(
      membershipIds.map((i) => sql`${i}`),
      sql`, `,
    );
    return rowsOf<{ membership_id: number; member_id: number; subtotal: string; discount_amount: string; tax_amount: string; total_amount: string }>(
      await testApp.db.execute(
        sql`SELECT membership_id, member_id, subtotal, discount_amount, tax_amount, total_amount FROM payments WHERE membership_id IN (${ids})`,
      ),
    );
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestAdmin(testApp.db);

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

    const devices = testApp.app.get(DeviceCredentialService);
    deviceKey = (await devices.create(`e2e-couple-gate-${RUN_ID}`, 'couple gate')).key;

    const methods = await api('GET', '/payment-methods');
    expect(methods.status).toBe(200);
    const active = (methods.body.data as any[]).find((m) => m.is_active);
    if (active) {
      paymentMethodId = active.id;
    } else {
      const created = await api('POST', '/payment-methods', { method_name: `E2E Cash ${RUN_ID}` });
      expect(created.status).toBe(201);
      paymentMethodId = created.body.id;
    }

    singleProductId = await createProduct('E2E_SINGLE', 'single', '1000.00');
    coupleProductId = await createProduct('E2E_COUPLE', 'couple', '1800.00');
    couplePlusProductId = await createProduct('E2E_COUPLE_PLUS', 'couple', '2400.00');
    for (const tag of ['a', 'b', 'c', 'd'] as const) {
      members[tag] = await createMember(tag);
    }
  }, 120_000);

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('seeds the partner with an ordinary single membership', async () => {
    const res = await api('POST', '/memberships', {
      member_id: members.b.id,
      product_id: singleProductId,
      start_date: isoToday(),
      payment_method_id: paymentMethodId,
    });
    expect(res.status).toBe(201);
    expect(res.body.package_type ?? res.body.product?.package_type).toBe('single');
    expect(res.body.partner_membership_id ?? null).toBeNull();
    singleBId = res.body.id;
  });

  it('preview returns the pro-rated credit for the partner, 404 when nothing to replace', async () => {
    const res = await api('GET', `/memberships/replacement-preview?member_id=${members.b.id}`);
    expect(res.status).toBe(200);
    expect(res.body.membership_id).toBe(singleBId);
    expect(res.body.is_couple).toBe(false);
    expect(res.body.status).toBe('active');
    expect(res.body.remaining_days).toBe(30);
    expect(res.body.suggested_credit).toBe('1000.00');

    const none = await api('GET', `/memberships/replacement-preview?member_id=${members.c.id}`);
    expect(none.status).toBe(404);
  });

  it('rejects invalid couple sales', async () => {
    const base = { start_date: isoToday(), payment_method_id: paymentMethodId };

    // couple package without a partner
    const noPartner = await api('POST', '/memberships', {
      ...base,
      member_id: members.a.id,
      product_id: coupleProductId,
    });
    expect(noPartner.status).toBe(400);

    // single package with a partner
    const singleWithPartner = await api('POST', '/memberships', {
      ...base,
      member_id: members.a.id,
      product_id: singleProductId,
      partner_member_id: members.c.id,
    });
    expect(singleWithPartner.status).toBe(400);

    // partner is the member
    const self = await api('POST', '/memberships', {
      ...base,
      member_id: members.a.id,
      product_id: coupleProductId,
      partner_member_id: members.a.id,
    });
    expect(self.status).toBe(400);

    // partner has a membership and replacement is not confirmed
    const unconfirmed = await api('POST', '/memberships', {
      ...base,
      member_id: members.a.id,
      product_id: coupleProductId,
      partner_member_id: members.b.id,
    });
    expect(unconfirmed.status).toBe(422);

    // discount above the package price
    const overDiscount = await api('POST', '/memberships', {
      ...base,
      member_id: members.a.id,
      product_id: coupleProductId,
      partner_member_id: members.b.id,
      replace_partner_membership: true,
      discount_amount: '1800.01',
    });
    expect(overDiscount.status).toBe(400);

    // nothing above may have changed B's single membership
    expect((await getMembership(singleBId)).status).toBe('active');
  });

  it('sells a couple membership: replaces the partner, links both rows, one discounted invoice on the primary', async () => {
    const res = await api('POST', '/memberships', {
      member_id: members.a.id,
      product_id: coupleProductId,
      start_date: isoToday(),
      payment_method_id: paymentMethodId,
      partner_member_id: members.b.id,
      replace_partner_membership: true,
      discount_amount: '500.00',
    });
    expect(res.status).toBe(201);
    coupleAId = res.body.id;
    expect(res.body.partner_member_id).toBe(members.b.id);
    coupleBId = res.body.partner_membership_id;
    expect(coupleBId).toBeGreaterThan(0);

    const a = await getMembership(coupleAId);
    const b = await getMembership(coupleBId);
    expect(b.member_id).toBe(members.b.id);
    expect(b.partner_membership_id).toBe(coupleAId);
    expect(b.partner_member_id).toBe(members.a.id);
    expect(a.status).toBe('active');
    expect(b.status).toBe('active');
    expect(b.start_date).toBe(a.start_date);
    expect(b.end_date).toBe(a.end_date);

    // B's old single membership was cancelled by the replacement
    const old = await getMembership(singleBId);
    expect(old.status).toBe('cancelled');
    const history = await api('GET', `/memberships/${singleBId}/history`);
    expect(history.status).toBe(200);

    // exactly one invoice for the couple pair, billed to A, discount applied
    const invoices = await paymentsFor([coupleAId, coupleBId]);
    expect(invoices).toHaveLength(1);
    expect(invoices[0].membership_id).toBe(coupleAId);
    expect(invoices[0].member_id).toBe(members.a.id);
    expect(invoices[0].subtotal).toBe('1800.00');
    expect(invoices[0].discount_amount).toBe('500.00');
    expect(preTax(invoices[0])).toBe('1300.00');
  });

  it('blocks replacing a partner who is already in a couple membership', async () => {
    const res = await api('POST', '/memberships', {
      member_id: members.c.id,
      product_id: coupleProductId,
      start_date: isoToday(),
      payment_method_id: paymentMethodId,
      partner_member_id: members.b.id,
      replace_partner_membership: true,
    });
    expect(res.status).toBe(422);
    expect((await getMembership(coupleBId)).status).toBe('active');
  });

  it('lets both partners through the gate membership check', async () => {
    const a = await checkIn(members.a.userId);
    expect(a.status).toBe(201);
    const b = await checkIn(members.b.userId);
    expect(b.status).toBe(201);
  });

  it('renews both rows from the partner side and rejects a package-type change', async () => {
    const beforeA = await getMembership(coupleAId);
    const beforeB = await getMembership(coupleBId);

    const wrongType = await api('POST', `/memberships/${coupleBId}/renew`, {
      product_id: singleProductId,
      row_version: beforeB.row_version,
    });
    expect(wrongType.status).toBe(422);

    const renewed = await api('POST', `/memberships/${coupleBId}/renew`, {
      row_version: beforeB.row_version,
    });
    expect(renewed.status).toBe(201);

    const a = await getMembership(coupleAId);
    const b = await getMembership(coupleBId);
    expect(a.end_date > beforeA.end_date).toBe(true);
    expect(b.end_date).toBe(a.end_date);
    expect(a.row_version).toBeGreaterThan(beforeA.row_version);
    expect(b.row_version).toBeGreaterThan(beforeB.row_version);
  });

  it('extends and upgrades both rows from the partner side', async () => {
    const beforeA = await getMembership(coupleAId);
    const beforeB = await getMembership(coupleBId);

    const extend = await api('POST', `/memberships/${coupleBId}/extensions`, {
      days_extended: 3,
      reason: 'e2e goodwill',
    });
    expect(extend.status).toBe(201);
    const afterExtendA = await getMembership(coupleAId);
    const afterExtendB = await getMembership(coupleBId);
    expect(afterExtendA.end_date > beforeA.end_date).toBe(true);
    expect(afterExtendB.end_date).toBe(afterExtendA.end_date);

    const upgrade = await api('POST', `/memberships/${coupleBId}/upgrade`, {
      product_id: couplePlusProductId,
      row_version: afterExtendB.row_version,
    });
    expect(upgrade.status).toBe(201);
    const a = await getMembership(coupleAId);
    const b = await getMembership(coupleBId);
    expect(a.product_id).toBe(couplePlusProductId);
    expect(b.product_id).toBe(couplePlusProductId);
    expect(b.partner_membership_id).toBe(coupleAId);
    expect(a.partner_membership_id).toBe(coupleBId);
    expect(a.row_version).toBeGreaterThan(beforeA.row_version);
    expect(b.row_version).toBeGreaterThan(beforeB.row_version);
  });

  it('member freeze request creates a pending pair; admin approval freezes both rows', async () => {
    const bToken = await loginAs('b');
    const req = await api(
      'POST',
      `/memberships/${coupleBId}/freezes`,
      { start_date: isoToday(), end_date: isoToday(4), reason: 'e2e couple freeze' },
      bToken,
    );
    expect(req.status).toBe(201);
    expect(req.body.status).toBe('pending');
    const freezeId = req.body.id as number;

    const aFreezes = await api('GET', `/memberships/${coupleAId}/freezes`);
    expect(aFreezes.status).toBe(200);
    const aList = (aFreezes.body.data ?? aFreezes.body) as any[];
    expect(aList).toHaveLength(1);
    expect(aList[0].status).toBe('pending');
    expect(aList[0].paired_freeze_id).toBe(freezeId);
    expect(req.body.paired_freeze_id).toBe(aList[0].id);

    // nothing moves until approval
    expect((await getMembership(coupleAId)).status).toBe('active');
    expect((await getMembership(coupleBId)).status).toBe('active');

    const beforeA = await getMembership(coupleAId);
    const beforeB = await getMembership(coupleBId);

    const approve = await api('POST', `/freezes/${freezeId}/approve`);
    expect(approve.status).toBe(201);

    const a = await getMembership(coupleAId);
    const b = await getMembership(coupleBId);
    expect(a.status).toBe('frozen');
    expect(b.status).toBe('frozen');
    expect(a.end_date > beforeA.end_date).toBe(true);
    expect(b.end_date > beforeB.end_date).toBe(true);
    expect(b.end_date).toBe(a.end_date);

    const aAfter = await api('GET', `/memberships/${coupleAId}/freezes`);
    expect(((aAfter.body.data ?? aAfter.body) as any[])[0].status).toBe('approved');
  });

  it('keeps a frozen couple out of the gate; rejecting a request leaves both active', async () => {
    const sale = await api('POST', '/memberships', {
      member_id: members.c.id,
      product_id: coupleProductId,
      start_date: isoToday(),
      payment_method_id: paymentMethodId,
      partner_member_id: members.d.id,
    });
    expect(sale.status).toBe(201);
    const cId = sale.body.id as number;
    const dId = sale.body.partner_membership_id as number;
    expect(sale.body.partner_member_id).toBe(members.d.id);

    // single invoice, no discount: price is the total for both members
    const invoices = await paymentsFor([cId, dId]);
    expect(invoices).toHaveLength(1);
    expect(invoices[0].member_id).toBe(members.c.id);
    expect(preTax(invoices[0])).toBe('1800.00');

    // member D asks to freeze; admin rejects; both stay active and both requests are rejected
    const dToken = await loginAs('d');
    const req = await api(
      'POST',
      `/memberships/${dId}/freezes`,
      { start_date: isoToday(), end_date: isoToday(2) },
      dToken,
    );
    expect(req.status).toBe(201);
    const rejected = await api('POST', `/freezes/${req.body.id}/reject`, { reason: 'not now' });
    expect(rejected.status).toBe(201);
    const cFreezes = await api('GET', `/memberships/${cId}/freezes`);
    const cList = (cFreezes.body.data ?? cFreezes.body) as any[];
    expect(cList).toHaveLength(1);
    expect(cList[0].status).toBe('rejected');
    expect((await getMembership(cId)).status).toBe('active');
    expect((await getMembership(dId)).status).toBe('active');

    // a staff-created freeze takes effect immediately on both rows
    const direct = await api('POST', `/memberships/${dId}/freezes`, {
      start_date: isoToday(),
      end_date: isoToday(2),
    });
    expect(direct.status).toBe(201);
    expect(direct.body.status).toBe('approved');
    expect((await getMembership(cId)).status).toBe('frozen');
    expect((await getMembership(dId)).status).toBe('frozen');

    // neither frozen partner may enter
    expect((await checkIn(members.c.userId)).status).toBe(422);
    expect((await checkIn(members.d.userId)).status).toBe(422);

    // cancelling from the partner side cancels both
    const d = await getMembership(dId);
    const cancel = await api('POST', `/memberships/${dId}/cancel`, {
      row_version: d.row_version,
      reason: 'e2e',
    });
    expect(cancel.status).toBe(201);
    expect((await getMembership(cId)).status).toBe('cancelled');
    expect((await getMembership(dId)).status).toBe('cancelled');
  });

  it('cancels both rows of the first pair from the primary side', async () => {
    const a = await getMembership(coupleAId);
    const cancel = await api('POST', `/memberships/${coupleAId}/cancel`, {
      row_version: a.row_version,
      reason: 'e2e couple cancel',
    });
    expect(cancel.status).toBe(201);
    expect((await getMembership(coupleAId)).status).toBe('cancelled');
    expect((await getMembership(coupleBId)).status).toBe('cancelled');

    // a cancelled pair must not be resurrected by a staff freeze (direct approval)
    const freeze = await api('POST', `/memberships/${coupleAId}/freezes`, {
      start_date: isoToday(),
      end_date: isoToday(1),
    });
    expect(freeze.status).toBe(422);
    expect((await getMembership(coupleAId)).status).toBe('cancelled');
  });
});
