import { createHmac, timingSafeEqual } from 'node:crypto';

/**
 * Minimal claim set embedded in a signed attendance pass payload.
 */
export interface AttendancePassClaims {
  user_id: number;
  expires_at: number; // unix seconds
}

function sign(secret: string, userId: number, expiresUnix: number): string {
  return createHmac('sha256', secret).update(`${userId}\n${expiresUnix}`).digest('hex');
}

/**
 * Resolve HMAC secret used to sign attendance QR pass payloads.
 * Mirrors `resolveMediaSigningSecret()` in `src/media/storage.service.ts`:
 * never reuse another module's signing secret, and require an explicit
 * secret outside development/test.
 */
export function resolveAttendanceSigningSecret(): string {
  const configured = process.env.ATTENDANCE_SIGNING_SECRET?.trim();
  if (configured) return configured;

  const nodeEnv = (process.env.NODE_ENV || 'development').toLowerCase();
  const isLocal = nodeEnv === 'development' || nodeEnv === 'test' || nodeEnv === '';
  if (!isLocal) {
    throw new Error('ATTENDANCE_SIGNING_SECRET is required when NODE_ENV is not development/test');
  }
  return 'dev-attendance-signing-secret';
}

/**
 * Signs an opaque QR/barcode payload for a member's digital attendance pass.
 * Payload format: `base64url(userId.expiresUnix.hmacHex)` — opaque to clients,
 * verified only by `verifyAttendancePass`.
 */
export function signAttendancePass(
  userId: number,
  ttlSeconds: number,
): { payload: string; expires_at: string } {
  const secret = resolveAttendanceSigningSecret();
  const expiresUnix = Math.floor(Date.now() / 1000) + Math.max(1, Math.floor(ttlSeconds));
  const signature = sign(secret, userId, expiresUnix);
  const raw = `${userId}.${expiresUnix}.${signature}`;
  const payload = Buffer.from(raw, 'utf8').toString('base64url');
  return { payload, expires_at: new Date(expiresUnix * 1000).toISOString() };
}

/**
 * Verifies a signed attendance pass payload, returning its claims when the
 * signature is valid and the pass has not expired, or `null` otherwise.
 * Never throws — malformed/tampered/expired payloads all resolve to `null`.
 */
export function verifyAttendancePass(payload: string): AttendancePassClaims | null {
  let raw: string;
  try {
    raw = Buffer.from(payload, 'base64url').toString('utf8');
  } catch {
    return null;
  }

  const parts = raw.split('.');
  if (parts.length !== 3) {
    return null;
  }
  const [userIdStr, expiresStr, signature] = parts;
  const userId = Number(userIdStr);
  const expiresUnix = Number(expiresStr);
  if (!Number.isFinite(userId) || !Number.isFinite(expiresUnix)) {
    return null;
  }

  const secret = resolveAttendanceSigningSecret();
  const expected = sign(secret, userId, expiresUnix);

  try {
    const a = Buffer.from(expected, 'hex');
    const b = Buffer.from(signature, 'hex');
    if (a.length !== b.length || !timingSafeEqual(a, b)) {
      return null;
    }
  } catch {
    return null;
  }

  if (expiresUnix * 1000 < Date.now()) {
    return null;
  }

  return { user_id: userId, expires_at: expiresUnix };
}
