# F-01 — Health controller: canonical DB token, drop fallback pool

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | low |
| **Depends** | — |
| **Blocks** | F-03 |
| **Files** | 2 |

## Why

`health.controller.ts:26` redeclares `export const DRIZZLE_DB_TOKEN = 'DRIZZLE_DB'` instead of importing the canonical one from `drizzle.module.ts`. It only resolves because the two string literals happen to match — nothing enforces that, and a rename in `drizzle.module.ts` would silently detach the health check from the real pool.

`health.controller.ts:33-39` then hand-builds a second pool when the token is not injected. `DrizzleModule` is `@Global()` and always provides the token, so that branch is unreachable. It also builds a pool nobody ever calls `.end()` on.

Do this first: F-03 makes `createConnectionPool()` throw when `DB_USER`/`DB_PASSWORD` are unset, which would turn this dead branch into a live crash in unit tests.

## Files

- `apps/api/src/platform/health/health.controller.ts`
- `apps/api/src/platform/health/health.controller.spec.ts`

## Steps

1. In `health.controller.ts`, delete line 26: `export const DRIZZLE_DB_TOKEN = 'DRIZZLE_DB';`
2. Add the canonical import at the top: `import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';`
3. Replace the whole constructor and the `private readonly db: DrizzleDb;` field declaration (lines 31-40) with a single injected parameter:
   ```ts
   constructor(@Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb) {}
   ```
4. Drop `Optional` from the `@nestjs/common` import list, and drop `createConnectionPool, createDrizzleClient` from the `../db/client` import — keep only `type DrizzleDb`.
5. Open `health.controller.spec.ts`. Every `new HealthController(...)` must now be passed a stub. If a test constructed it with no argument to exercise the fallback, delete that test — the branch no longer exists. Use a stub shaped like:
   ```ts
   const db = { execute: vi.fn().mockResolvedValue([]) } as unknown as DrizzleDb;
   ```
   and for the failure path `execute: vi.fn().mockRejectedValue(new Error('down'))`.
6. Grep for other importers of the deleted export — there should be none:
   ```
   rg "DRIZZLE_DB_TOKEN.*health|from '.*health.controller'" apps/api/src apps/api/test
   ```

## Done when

- `rg "DRIZZLE_DB_TOKEN = " apps/api/src` returns exactly one hit, in `drizzle.module.ts`.
- `health.controller.ts` contains no call to `createConnectionPool`.
- `pnpm --filter api test` passes.
- `GET /v1/ready` still returns 200 with `database: "connected"` against compose MySQL.
