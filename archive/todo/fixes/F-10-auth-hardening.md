# F-10 — Auth hardening: uniform 401, verify errors, proxy trust, throttle scope

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | medium |
| **Depends** | F-02 |
| **Files** | 7 |

## Why

Four small defects in the login path, none of which is a ship blocker alone:

1. **Account-state oracle.** `auth.service.ts:59-62` answers `"Account is not active"` for a suspended account but `"Invalid credentials"` for a bad password. The difference confirms which accounts exist and are merely disabled.
2. **Malformed hash → 500.** `password.ts:21` calls `argon2.verify(hash, password)` bare. `argon2.verify` *throws* on a hash it cannot parse (a truncated or hand-edited `password_hash` row), so a data problem surfaces as a 500 instead of a 401.
3. **Unconditional `x-forwarded-for` trust.** `auth.controller.ts:42-46` takes the first hop of a client-supplied header as the throttle key with no proxy-trust configuration. Any caller can rotate that header and defeat per-IP rate limiting entirely.
4. **Shared-IP lockout reset.** `login-throttle.ts:64-71` clears the IP bucket on success. On a shared egress IP, one successful login wipes the counter an attacker is filling.

## Files

- `apps/api/src/auth/auth.service.ts`
- `apps/api/src/auth/password.ts`
- `apps/api/src/auth/auth.controller.ts`
- `apps/api/src/main.ts`
- `apps/api/src/auth/login-throttle.ts`
- `apps/api/src/auth/auth.service.spec.ts`
- `apps/api/test/auth.e2e.spec.ts`

## Steps

1. **Uniform rejection.** In `auth.service.ts`, make the inactive branch (lines 59-62) indistinguishable from a bad password, and count it against the throttle like the other failure paths:
   ```ts
   if (userResult.status !== 'active') {
     this.loginThrottle.recordFailure(identifier, ipAddress);
     throw new UnauthorizedError('Invalid credentials');
   }
   ```
   This does mean a suspended member who keeps retrying will eventually be rate-limited. That is the intended trade — the alternative is publishing account state.
2. **Contain verify failures.** In `password.ts`:
   ```ts
   export async function verifyPassword(hash: string, password: string): Promise<boolean> {
     try {
       return await argon2.verify(hash, password);
     } catch {
       return false;
     }
   }
   ```
   A hash that cannot be parsed is a failed verification, not a server error. Do not log the hash.
3. **Make proxy trust explicit.** In `main.ts`, after `app.enableCors()`:
   ```ts
   if (process.env.TRUST_PROXY) {
     app.set('trust proxy', process.env.TRUST_PROXY);
   }
   ```
   Then in `auth.controller.ts` delete the manual header parse (lines 42-46) and use Express's own resolution, which honours that setting:
   ```ts
   const ipAddress = req.ip ?? req.socket.remoteAddress ?? 'unknown';
   ```
   With `TRUST_PROXY` unset, `req.ip` is the socket peer and a spoofed header is ignored. Add `TRUST_PROXY=` (commented, with a note that it takes an Express trust-proxy value such as `1` or a CIDR) to `.env.example` if you are also touching that file in F-03.
4. **Scope the success reset.** In `login-throttle.ts`, `recordSuccess` clears the identifier bucket only:
   ```ts
   recordSuccess(identifier: string): void {
     this.attempts.delete(`id:${identifier.toLowerCase().trim()}`);
   }
   ```
   Drop the `ipAddress` parameter and update the caller at `auth.service.ts:65` to `this.loginThrottle.recordSuccess(identifier);`.
5. **Tests.**
   - `auth.service.spec.ts`: an inactive user's login rejects with the message `Invalid credentials` and calls `recordFailure`; a stored hash of `'not-a-hash'` yields 401, not a thrown parse error.
   - `auth.e2e.spec.ts:125` — the existing inactive-login case asserts the old message; update it to assert status 401 and `Invalid credentials`.
   - Add: repeated failed logins from the same identifier still lock out after a successful login from a *different* identifier on the same IP.

## Done when

- Login with a correct password on a suspended account returns exactly the same status, code and message as login with a wrong password.
- A user row with a corrupt `password_hash` produces 401, not 500.
- With `TRUST_PROXY` unset, sending `X-Forwarded-For: 1.2.3.4` does not change which bucket the throttle uses.
- `rg "x-forwarded-for" apps/api/src` returns nothing.
- `pnpm --filter api test` and `test:e2e` pass.
