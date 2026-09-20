import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { eq } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  INACTIVE_USER_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';
import { sessions } from '../src/platform/db/schema/sessions';
import { hashToken } from '../src/auth/token';
import { SessionCache } from '../src/auth/session.cache';

describe('Auth E2E', () => {
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

  it('performs full auth lifecycle: login -> /me -> refresh -> logout -> me rejected', async () => {
    // 1. Login with Super Admin credentials
    const loginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });

    expect(loginRes.status).toBe(200);
    const loginData = (await loginRes.json()) as any;
    expect(loginData.accessToken).toMatch(/^gk_at_/);
    expect(loginData.refreshToken).toMatch(/^gk_rt_/);
    expect(loginData.tokenType).toBe('Bearer');
    expect(loginData.expiresIn).toBe(1800);

    // 2. GET /v1/me with Bearer token
    const meRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${loginData.accessToken}` },
    });

    expect(meRes.status).toBe(200);
    const meData = (await meRes.json()) as any;
    expect(meData.user.email).toBe(ADMIN_CREDENTIALS.email);
    expect(meData.role.slug).toBe('super_admin');
    expect(meData.slugs).toContain('settings.read');
    expect(meData.slugs).not.toContain('*');
    expect(meData.profile).toBeNull();

    // 3. Refresh token rotation
    const refreshRes = await fetch(`${testApp.baseUrl}/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        refreshToken: loginData.refreshToken,
      }),
    });

    expect(refreshRes.status).toBe(200);
    const refreshData = (await refreshRes.json()) as any;
    expect(refreshData.accessToken).toMatch(/^gk_at_/);
    expect(refreshData.refreshToken).toMatch(/^gk_rt_/);
    expect(refreshData.refreshToken).not.toBe(loginData.refreshToken);

    // 4. Logout with new access token
    const logoutRes = await fetch(`${testApp.baseUrl}/auth/logout`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${refreshData.accessToken}` },
    });

    expect(logoutRes.status).toBe(204);

    // 5. Subsequent GET /v1/me with logged-out token returns 401
    const postLogoutMeRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${refreshData.accessToken}` },
    });

    expect(postLogoutMeRes.status).toBe(401);
  });

  it('detects refresh token reuse and revokes entire family', async () => {
    // 1. Login
    const loginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    const loginData = (await loginRes.json()) as any;
    const oldRefreshToken = loginData.refreshToken;

    // 2. Rotate refresh token once
    const firstRefreshRes = await fetch(`${testApp.baseUrl}/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: oldRefreshToken }),
    });
    expect(firstRefreshRes.status).toBe(200);
    const newTokens = (await firstRefreshRes.json()) as any;

    // 3. Replay old refresh token (Reuse attack)
    const reuseRes = await fetch(`${testApp.baseUrl}/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: oldRefreshToken }),
    });
    expect(reuseRes.status).toBe(401);

    // 4. Verify family revocation: new token pair is now also invalid
    const meRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${newTokens.accessToken}` },
    });
    expect(meRes.status).toBe(401);
  });

  it('rejects login for inactive user account', async () => {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: INACTIVE_USER_CREDENTIALS.email,
        password: INACTIVE_USER_CREDENTIALS.password,
      }),
    });

    expect(res.status).toBe(401);
    const body = (await res.json()) as any;
    expect(body.message).toBe('Invalid credentials');
  });

  it('verifies UTC timestamp round-trip on created session in database', async () => {
    const loginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    const { accessToken } = (await loginRes.json()) as any;
    const tokenHash = hashToken(accessToken);

    const sessionRows = await (testApp.db as any)
      .select()
      .from(sessions)
      .where(eq(sessions.access_token_hash, tokenHash))
      .limit(1);

    expect(sessionRows).toHaveLength(1);
    const session = sessionRows[0];

    expect(session.created_at).toBeInstanceOf(Date);
    expect(session.expires_at).toBeInstanceOf(Date);
    // created_at should be within the last minute in UTC
    const diffMs = Math.abs(Date.now() - session.created_at.getTime());
    expect(diffMs).toBeLessThan(60000);
  });

  it('rejects login with invalid payload returning 400 validation_error', async () => {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    });

    expect(res.status).toBe(400);
    const body = (await res.json()) as any;
    expect(body.code).toBe('validation_error');
    expect(body.message).toBe('Validation failed');
    expect(Array.isArray(body.details)).toBe(true);
    expect(body.details.length).toBeGreaterThan(0);
  });

  it('rejects refresh with malformed token as 400 validation_error not 401', async () => {
    const res = await fetch(`${testApp.baseUrl}/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: 'nope' }),
    });

    expect(res.status).toBe(400);
    const body = (await res.json()) as any;
    expect(body.code).toBe('validation_error');
    expect(Array.isArray(body.details)).toBe(true);
    expect(body.details.length).toBeGreaterThan(0);
  });

  it('rejects access token when 30-minute access TTL has expired', async () => {
    const loginRes = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    const { accessToken } = (await loginRes.json()) as any;
    const tokenHash = hashToken(accessToken);

    // Evict from in-memory cache to force DB lookup and mutate created_at to 31 minutes ago
    const thirtyOneMinutesAgo = new Date(Date.now() - 31 * 60 * 1000);
    await (testApp.db as any)
      .update(sessions)
      .set({ created_at: thirtyOneMinutesAgo })
      .where(eq(sessions.access_token_hash, tokenHash));

    // Clear session cache in app
    const sessionCache = (testApp.app as any).get(SessionCache);
    sessionCache.dropSession(tokenHash);

    // Verify /me rejects the 31-minute-old access token with 401
    const meRes = await fetch(`${testApp.baseUrl}/me`, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });
    expect(meRes.status).toBe(401);
  });
});
