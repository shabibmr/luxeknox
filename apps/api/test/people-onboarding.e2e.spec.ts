import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { sql } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  TRAINER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';

const RUN_ID = Date.now();
const onboardEmail = `e2e_onboard_${RUN_ID}@luxeknox.test`;
const onboardPassword = 'OnboardSecurePassword123!';
const otherMemberEmail = `e2e_other_${RUN_ID}@luxeknox.test`;
const trainerEmail = `e2e_trainer_profile_${RUN_ID}@luxeknox.test`;
const trainerPassword = 'TrainerSecurePassword123!';

/** Retarget signed MEDIA URLs to the ephemeral e2e listen port. */
function retargetToApp(url: string, baseUrl: string): string {
  const media = new URL(url);
  const app = new URL(baseUrl);
  media.protocol = app.protocol;
  media.host = app.host;
  return media.toString();
}

describe('People onboarding E2E (V3-14)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;

  async function login(identifier: string, password: string): Promise<{
    status: number;
    accessToken: string | null;
    body: any;
  }> {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identifier, password }),
    });
    const body = (await res.json()) as any;
    return {
      status: res.status,
      accessToken: body.accessToken ?? body.access_token ?? null,
      body,
    };
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);

    const adminLogin = await login(ADMIN_CREDENTIALS.email, ADMIN_CREDENTIALS.password);
    expect(adminLogin.status).toBe(200);
    adminToken = adminLogin.accessToken!;
  });

  afterAll(async () => {
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('onboards a member: create → login profile_id → EC → waiver signed PUT → attach', async () => {
    const createRes = await fetch(`${testApp.baseUrl}/members`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: onboardEmail,
        password: onboardPassword,
        first_name: 'Onboard',
        last_name: 'Member',
      }),
    });
    expect(createRes.status).toBe(201);
    const member = (await createRes.json()) as any;
    expect(member.id).toBeGreaterThan(0);
    expect(member.user_id).toBeGreaterThan(0);
    expect(member.membership_number).toMatch(/^M\d{8}$/);
    expect(member.first_name).toBe('Onboard');

    const memberLogin = await login(onboardEmail, onboardPassword);
    expect(memberLogin.status).toBe(200);
    expect(memberLogin.accessToken).toBeTruthy();

    const meRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${memberLogin.accessToken}` },
    });
    expect(meRes.status).toBe(200);
    const me = (await meRes.json()) as any;
    expect(me.principal?.profile_id).toBe(member.id);
    expect(me.profile).toBeTruthy();
    expect(me.profile.id).toBe(member.id);

    const ecRes = await fetch(`${testApp.baseUrl}/users/${member.user_id}/emergency-contacts`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${memberLogin.accessToken}`,
      },
      body: JSON.stringify({
        contact_name: 'Primary Contact',
        relationship: 'spouse',
        phone_primary: '+15551234567',
        is_primary: true,
      }),
    });
    expect(ecRes.status).toBe(201);
    const ec = (await ecRes.json()) as any;
    expect(ec.is_primary).toBe(true);
    expect(ec.contact_name).toBe('Primary Contact');

    const uploadRes = await fetch(`${testApp.baseUrl}/media/uploads`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        purpose: 'waiver',
        content_type: 'application/pdf',
        size_bytes: 12,
      }),
    });
    expect(uploadRes.status).toBe(201);
    const slot = (await uploadRes.json()) as any;
    expect(slot.object_key).toMatch(/^waiver\//);
    expect(slot.url).toContain('/v1/media/objects?');

    const putUrl = retargetToApp(slot.url, testApp.baseUrl);
    const putRes = await fetch(putUrl, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/pdf' },
      body: Buffer.from('%PDF-1.4 e2e'),
    });
    expect(putRes.status).toBe(204);

    const docRes = await fetch(`${testApp.baseUrl}/members/${member.id}/documents`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${memberLogin.accessToken}`,
      },
      body: JSON.stringify({
        document_type: 'waiver',
        title: 'Liability waiver',
        file_url: slot.object_key,
        file_size: 12,
      }),
    });
    expect(docRes.status).toBe(201);
    const doc = (await docRes.json()) as any;
    expect(doc.document_type).toBe('waiver');
    expect(doc.file_url).toBe(slot.object_key);
  });

  it('returns 404 when trainer reads an unassigned member', async () => {
    const trainerCreate = await fetch(`${testApp.baseUrl}/trainers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: trainerEmail,
        password: trainerPassword,
        first_name: 'Scope',
        last_name: 'Trainer',
        max_clients_capacity: 5,
      }),
    });
    expect(trainerCreate.status).toBe(201);

    const otherCreate = await fetch(`${testApp.baseUrl}/members`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: otherMemberEmail,
        password: onboardPassword,
        first_name: 'Other',
        last_name: 'Member',
      }),
    });
    expect(otherCreate.status).toBe(201);
    const other = (await otherCreate.json()) as any;

    const trainerLogin = await login(trainerEmail, trainerPassword);
    expect(trainerLogin.status).toBe(200);

    const getRes = await fetch(`${testApp.baseUrl}/members/${other.id}`, {
      headers: { Authorization: `Bearer ${trainerLogin.accessToken}` },
    });
    expect(getRes.status).toBe(404);
  });

  it('returns 404 when trainer requests signed GET for id_proof', async () => {
    const uploadRes = await fetch(`${testApp.baseUrl}/media/uploads`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        purpose: 'id_proof',
        content_type: 'image/jpeg',
        size_bytes: 1024,
      }),
    });
    expect(uploadRes.status).toBe(201);
    const slot = (await uploadRes.json()) as any;

    // Prefer freshly created trainer with profile; fall back to seeded e2e trainer user.
    let trainerToken: string | null = null;
    const fresh = await login(trainerEmail, trainerPassword);
    if (fresh.status === 200 && fresh.accessToken) {
      trainerToken = fresh.accessToken;
    } else {
      const seeded = await login(TRAINER_CREDENTIALS.email, TRAINER_CREDENTIALS.password);
      expect(seeded.status).toBe(200);
      trainerToken = seeded.accessToken;
    }

    const getRes = await fetch(`${testApp.baseUrl}/media/${encodeURIComponent(slot.object_key)}`, {
      headers: { Authorization: `Bearer ${trainerToken}` },
    });
    expect(getRes.status).toBe(404);
  });

  it('employee terminate blocks subsequent login', async () => {
    const rolesRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });
    expect(rolesRes.status).toBe(200);

    const [roleRows] = (await testApp.db.execute(
      sql`SELECT id FROM roles WHERE slug = 'employee' LIMIT 1`,
    )) as any;
    const employeeRoleId = Number(roleRows?.[0]?.id ?? roleRows?.[0]?.ID);
    expect(employeeRoleId).toBeGreaterThan(0);

    const empEmail = `e2e_emp_${RUN_ID}@luxeknox.test`;
    const empPassword = 'EmployeeSecurePassword123!';
    const createRes = await fetch(`${testApp.baseUrl}/employees`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: empEmail,
        password: empPassword,
        first_name: 'Temp',
        last_name: 'Employee',
        job_title: 'Front desk',
        role_id: employeeRoleId,
      }),
    });
    expect(createRes.status).toBe(201);
    const employee = (await createRes.json()) as any;

    const before = await login(empEmail, empPassword);
    expect(before.status).toBe(200);

    const statusRes = await fetch(`${testApp.baseUrl}/employees/${employee.id}/status`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({ status: 'terminated' }),
    });
    expect(statusRes.status).toBe(200);

    const after = await login(empEmail, empPassword);
    expect(after.status).toBe(401);
  });

  it('assign-trainer returns 422 at capacity and allows admin override', async () => {
    const capTrainerEmail = `e2e_cap_trainer_${RUN_ID}@luxeknox.test`;
    const trainerRes = await fetch(`${testApp.baseUrl}/trainers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: capTrainerEmail,
        password: trainerPassword,
        first_name: 'Cap',
        last_name: 'Trainer',
        max_clients_capacity: 1,
      }),
    });
    expect(trainerRes.status).toBe(201);
    const trainer = (await trainerRes.json()) as any;

    const m1Res = await fetch(`${testApp.baseUrl}/members`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: `e2e_cap_m1_${RUN_ID}@luxeknox.test`,
        password: onboardPassword,
        first_name: 'Cap',
        last_name: 'One',
      }),
    });
    expect(m1Res.status).toBe(201);
    const m1 = (await m1Res.json()) as any;

    const assign1 = await fetch(`${testApp.baseUrl}/members/${m1.id}/assign-trainer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({ trainer_id: trainer.id, override_capacity: false }),
    });
    expect(assign1.status).toBe(200);

    const m2Res = await fetch(`${testApp.baseUrl}/members`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: `e2e_cap_m2_${RUN_ID}@luxeknox.test`,
        password: onboardPassword,
        first_name: 'Cap',
        last_name: 'Two',
      }),
    });
    expect(m2Res.status).toBe(201);
    const m2 = (await m2Res.json()) as any;

    const blocked = await fetch(`${testApp.baseUrl}/members/${m2.id}/assign-trainer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({ trainer_id: trainer.id, override_capacity: false }),
    });
    expect(blocked.status).toBe(422);

    const overridden = await fetch(`${testApp.baseUrl}/members/${m2.id}/assign-trainer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        trainer_id: trainer.id,
        override_capacity: true,
        reason: 'VIP capacity override',
      }),
    });
    expect(overridden.status).toBe(200);
    const body = (await overridden.json()) as any;
    expect(body.assigned_trainer_id).toBe(trainer.id);
  });
});
