# F-05 — UserRepository: remove raw SQL from auth service and guard

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | high |
| **Depends** | — |
| **Blocks** | F-06 |
| **Files** | 6 |

## Why

ADR-0004: "All data access goes through a repository layer. No SQL in controllers or services." The ADR's stated reason is that a future tenant predicate needs exactly one place to land.

`sys/settings.*` obeys this (`SettingsService` → `SettingsRepository` → `BaseRepository`), so the pattern is established. The auth path does not:

- `auth.service.ts:201-235` — `findUserByIdentifier`, `findUserById`, `findSessionByRefreshTokenHash` all run `this.db.select().from(...)` directly.
- `auth.guard.ts:119-123` — loads the user with a raw select on every authenticated request.

That is four query sites a tenant predicate would have to be retrofitted into, in the module that will need it first.

## Files

- `apps/api/src/auth/user.repository.ts` (new)
- `apps/api/src/auth/auth.service.ts`
- `apps/api/src/auth/auth.guard.ts`
- `apps/api/src/auth/session.repository.ts`
- `apps/api/src/auth/auth.module.ts`
- `apps/api/src/auth/auth.service.spec.ts`

## Steps

1. Create `apps/api/src/auth/user.repository.ts`, modelled exactly on `settings.repository.ts`:
   ```ts
   import { Inject, Injectable } from '@nestjs/common';
   import { eq, or } from 'drizzle-orm';
   import { BaseRepository } from '../platform/db/base.repository';
   import { users, type User } from '../platform/db/schema/users';
   import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
   import type { DrizzleDb } from '../platform/db/client';

   @Injectable()
   export class UserRepository extends BaseRepository<typeof users, User, typeof users.$inferInsert> {
     constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
       super(db, users);
     }

     /** Finds a user by email or phone number. */
     async findByIdentifier(identifier: string): Promise<User | null> {
       return this.findOne(or(eq(users.email, identifier), eq(users.phone_number, identifier))!);
     }
   }
   ```
   If `schema/users.ts` exports a `NewUser` type, use it in place of `typeof users.$inferInsert`. Do not add a `findById` — `BaseRepository.findById` (`base.repository.ts:65`) already covers it.
2. Move the session lookup to where it belongs. In `session.repository.ts`, add the any-state lookup used for reuse detection:
   ```ts
   /** Finds a session by refresh token hash regardless of revoked/expired state (reuse detection). */
   async findByRefreshTokenHash(refreshTokenHash: string): Promise<Session | null> {
     return this.findOne(eq(sessions.refresh_token_hash, refreshTokenHash));
   }
   ```
   Note the deliberate contrast with the existing `findActiveByRefreshTokenHash` — this one must **not** filter on `revoked_at`, because finding a revoked row is the whole point.
3. Rewrite the `AuthService` constructor (`auth.service.ts:24-30`): delete the `@Inject(DRIZZLE_DB_TOKEN) private readonly db` parameter and add `private readonly userRepository: UserRepository`.
4. Delete `auth.service.ts:198-235` — all three private query helpers — and update the three call sites:
   - line 45: `const userResult = await this.userRepository.findByIdentifier(normalizedId);`
   - line 95: `const user = await this.userRepository.findById(activeSession.user_id);`
   - line 105: `const existingSession = await this.sessionRepository.findByRefreshTokenHash(refreshTokenHash);`
5. Clean the now-unused imports from `auth.service.ts`: `and, eq, or, type SQL` from `drizzle-orm`, `DRIZZLE_DB_TOKEN`, `DrizzleDb`, `users`, and `sessions`/`Session` if nothing else references them. Add the `UserRepository` import. Run `pnpm --filter api typecheck` — it will name any import you missed.
6. In `auth.guard.ts`: drop the `@Inject(DRIZZLE_DB_TOKEN) private readonly db` constructor parameter, add `private readonly userRepository: UserRepository`, and replace lines 119-125 with:
   ```ts
   const user = await this.userRepository.findById(session.user_id);
   ```
   Remove the `eq` import, the `users` import, the `DRIZZLE_DB_TOKEN` import and the `DrizzleDb` import. Keep the `User`/`UserType` type imports if still referenced.
7. In `auth.module.ts`, add `UserRepository` to both `providers` and `exports` (alongside `SessionRepository`).
8. Update `auth.service.spec.ts`: wherever the test builds an `AuthService` with a fake `db`, swap it for a `UserRepository` double — `{ findByIdentifier: vi.fn(), findById: vi.fn() }` — and move any refresh-reuse fixture onto `sessionRepository.findByRefreshTokenHash`.

## Done when

- `rg "\.select\(\)\.from\(" apps/api/src/auth` returns nothing.
- `rg "DRIZZLE_DB_TOKEN" apps/api/src/auth` matches only `user.repository.ts` and `session.repository.ts`.
- `pnpm --filter api test` and `test:e2e` pass unchanged — this is a pure refactor; no behaviour should move.
