# F-11 — Seed hygiene: shared hasher, no password reset, required env

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | medium |
| **Depends** | — |
| **Files** | 2 |

## Why

> **Correction first.** The review claimed `seed/admin.ts:32` hashes with the weaker argon2i because `argon2.hash(rawPassword)` passes no options. That is **false** — `argon2@0.41.1` defaults to `type: argon2id` (`node_modules/.pnpm/argon2@0.41.1/node_modules/argon2/argon2.cjs:30-37`). The seeded hash is correct. Do not "fix" the algorithm.

What is real is smaller and still worth closing:

1. **Two hashing call sites.** `auth/password.ts:9-11` owns `hashPassword`, and `seed/admin.ts:32` calls `argon2.hash` directly. They agree today only by coincidence; the moment someone tunes `memoryCost` or `timeCost` in the helper, the bootstrap admin's hash silently diverges from every other user's.
2. **Re-seeding resets the admin password.** `seed/admin.ts:46-54` puts `password_hash` in the `onDuplicateKeyUpdate` set, so every `pnpm seed` overwrites the Super Admin password back to whatever `BOOTSTRAP_ADMIN_PASSWORD` currently is — including back to the in-source default if the env var is absent. M0-12 requires the seed to be idempotent, and overwriting a rotated password is not idempotent in the way that matters.
3. **A real default password in source.** `seed/admin.ts:18` falls back to `'AdminSecurePassword123!'`. Convenient for dev, dangerous anywhere else.

## Files

- `apps/api/src/platform/db/seed/admin.ts`
- `.env.example`

## Steps

1. Use the one hasher. Replace `import * as argon2 from 'argon2';` with:
   ```ts
   import { hashPassword } from '../../../auth/password';
   ```
   and line 32 with `const passwordHash = await hashPassword(rawPassword);`
   (A seed script is a composition root — importing from `auth/` here is fine, and is the point: one definition of how this project hashes passwords.)
2. Require the password outside development:
   ```ts
   const rawPassword = process.env.BOOTSTRAP_ADMIN_PASSWORD;
   if (!rawPassword) {
     if (process.env.NODE_ENV === 'production') {
       throw new Error('BOOTSTRAP_ADMIN_PASSWORD must be set when seeding in production.');
     }
     console.warn('[Seed] BOOTSTRAP_ADMIN_PASSWORD unset — using the development default.');
   }
   const password = rawPassword || 'AdminSecurePassword123!';
   ```
3. Stop overwriting the password on re-seed. In the `onDuplicateKeyUpdate` set (lines 46-54), **delete the `password_hash` line**. Keep `user_type`, `role_id`, `status` and `updated_at` — re-seeding should still repair a downgraded or deactivated admin, just not the credential. Add a one-line comment saying so, because the omission looks like an oversight otherwise:
   ```ts
   // password_hash is intentionally not updated: re-seeding must not reset a rotated admin password.
   ```
4. In `.env.example`, mark the bootstrap password as development-only:
   ```
   # Bootstrap Super Admin. BOOTSTRAP_ADMIN_PASSWORD is required when NODE_ENV=production.
   # Rotating this value after the first seed has no effect — the seed never overwrites an existing password.
   ```
5. Verify idempotency by hand:
   ```
   pnpm --filter api seed
   # change the admin password in the DB, or set a different BOOTSTRAP_ADMIN_PASSWORD
   pnpm --filter api seed
   # the stored password_hash must be unchanged
   ```

## Done when

- `rg "argon2" apps/api/src` matches only `auth/password.ts`.
- Running `seed` twice with different `BOOTSTRAP_ADMIN_PASSWORD` values leaves the first hash in place.
- Running `seed` on a fresh database still creates a Super Admin that can log in (`test/auth.e2e.spec.ts` covers this).
- `NODE_ENV=production pnpm --filter api seed` with no `BOOTSTRAP_ADMIN_PASSWORD` aborts with the explicit error.
