import { describe, it, expect } from 'vitest';
import { PUBLIC_PATH_PATTERNS } from './public-paths';

describe('PUBLIC_PATH_PATTERNS', () => {
  it.each(['/v1/health', '/v1/ready', '/v1/auth/login', '/v1/auth/refresh', '/v1/settings/public'])(
    'treats %s as public',
    (p) => expect(PUBLIC_PATH_PATTERNS.some((r) => r.test(p))).toBe(true),
  );

  it.each(['/v1/settings', '/v1/me', '/v1/auth/logout', '/v1/settings/public/extra', '/health'])(
    'treats %s as protected',
    (p) => expect(PUBLIC_PATH_PATTERNS.some((r) => r.test(p))).toBe(false),
  );
});
