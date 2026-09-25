import { randomBytes, createHash } from 'crypto';

export const ACCESS_TOKEN_PREFIX = 'gk_at_';
export const REFRESH_TOKEN_PREFIX = 'gk_rt_';
export const PASSWORD_RESET_TOKEN_PREFIX = 'gk_pr_';

/**
 * Generates an opaque 256-bit (32 bytes) random token with the specified prefix.
 * Encoded as URL-safe Base64 without padding.
 */
function generatePrefixedToken(prefix: string): string {
  const bytes = randomBytes(32);
  const base64url = bytes.toString('base64url');
  return `${prefix}${base64url}`;
}

/**
 * Issues a new opaque 256-bit random access token: `gk_at_<base64url>`.
 * Access tokens have a 30-minute lifespan per ADR-0003.
 *
 * NOTE: Never log raw tokens.
 */
export function issueAccessToken(): string {
  return generatePrefixedToken(ACCESS_TOKEN_PREFIX);
}

/**
 * Issues a new opaque 256-bit random refresh token: `gk_rt_<base64url>`.
 * Refresh tokens have a 30-day sliding lifespan per ADR-0003.
 *
 * NOTE: Never log raw tokens.
 */
export function issueRefreshToken(): string {
  return generatePrefixedToken(REFRESH_TOKEN_PREFIX);
}

/**
 * Issues a new opaque 256-bit random password-reset token: `gk_pr_<base64url>`.
 * Single-use, short-lived (see PASSWORD_RESET_TOKEN_EXPIRY_MINUTES in auth.service).
 *
 * NOTE: Never log raw tokens.
 */
export function issuePasswordResetToken(): string {
  return generatePrefixedToken(PASSWORD_RESET_TOKEN_PREFIX);
}

/**
 * Hashes an opaque token (access or refresh) using SHA-256 (hex-encoded).
 * Used for database storage and lookups in the `sessions` table.
 *
 * @param token The raw opaque token
 * @returns 64-character lowercase hexadecimal SHA-256 hash
 */
export function hashToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}
