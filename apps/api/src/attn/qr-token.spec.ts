import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { signAttendancePass, verifyAttendancePass } from './qr-token';

describe('qr-token', () => {
  const originalSecret = process.env.ATTENDANCE_SIGNING_SECRET;

  beforeEach(() => {
    process.env.ATTENDANCE_SIGNING_SECRET = 'test-attendance-secret';
  });

  afterEach(() => {
    process.env.ATTENDANCE_SIGNING_SECRET = originalSecret;
  });

  it('round-trips a freshly signed pass', () => {
    const { payload, expires_at } = signAttendancePass(42, 300);
    expect(typeof payload).toBe('string');
    expect(payload.length).toBeGreaterThan(0);
    expect(new Date(expires_at).getTime()).toBeGreaterThan(Date.now());

    const claims = verifyAttendancePass(payload);
    expect(claims).not.toBeNull();
    expect(claims?.user_id).toBe(42);
  });

  it('rejects an expired pass', () => {
    vi.useFakeTimers();
    try {
      const { payload } = signAttendancePass(7, 60);
      // A correctly-signed pass verifies while still within its TTL.
      expect(verifyAttendancePass(payload)).toEqual({ user_id: 7, expires_at: expect.any(Number) });
      // Advance the clock well past the pass's expiry; the signature is still
      // valid, but the expiry check must now reject it.
      vi.advanceTimersByTime(61_000);
      expect(verifyAttendancePass(payload)).toBeNull();
    } finally {
      vi.useRealTimers();
    }
  });

  it('rejects a tampered payload (user_id changed after signing)', () => {
    const { payload } = signAttendancePass(1, 300);
    const raw = Buffer.from(payload, 'base64url').toString('utf8');
    const [, expiresStr, signature] = raw.split('.');
    const tampered = Buffer.from(`999.${expiresStr}.${signature}`, 'utf8').toString('base64url');

    expect(verifyAttendancePass(tampered)).toBeNull();
  });

  it('rejects a payload with a wrong/forged signature', () => {
    const { payload } = signAttendancePass(1, 300);
    const raw = Buffer.from(payload, 'base64url').toString('utf8');
    const [userId, expiresStr] = raw.split('.');
    const wrongSignature = '0'.repeat(64);
    const forged = Buffer.from(`${userId}.${expiresStr}.${wrongSignature}`, 'utf8').toString('base64url');

    expect(verifyAttendancePass(forged)).toBeNull();
  });

  it('returns null for malformed payloads', () => {
    expect(verifyAttendancePass('not-valid-base64url!!!')).toBeNull();
    expect(verifyAttendancePass(Buffer.from('only-two.parts', 'utf8').toString('base64url'))).toBeNull();
  });
});
