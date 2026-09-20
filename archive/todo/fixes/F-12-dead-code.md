# F-12 — Remove dead and duplicated helpers

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | low |
| **Depends** | F-07 |
| **Files** | 6 |

## Why

Four small pieces of code with no callers or no purpose. Individually trivial; together they are the reason a reader cannot tell which parts of the platform layer are load-bearing.

1. **Middle Man** — `pagination.ts:171-186`: `PaginationHelper.encodeCursor`, `.decodeCursor` and `.createResponse` are one-line pass-throughs to standalone functions of the same name defined directly above them in the same file.
2. **Speculative Generality** — `permission-cache.ts:47-67`: `hasPermission` and `hasAllPermissions` have no callers. `PermissionGuard` does its own wildcard check inline (`permission.guard.ts:59`) rather than using them, so the two implementations can drift.
3. **Dead export** — `money.ts:53-67`: `formatMoney` has no callers anywhere, and Module 0 has no currency-rendering requirement. Presentation formatting belongs with a client, not in a rounding helper.
4. **Divergent Change** — `money.ts:1-2`: `IDEMPOTENCY_KEY_HEADER` and `IdempotencyKey` live in the money module and have nothing to do with money. The file has two unrelated reasons to change.

## Files

- `apps/api/src/platform/http/pagination.ts`
- `apps/api/src/platform/http/pagination.spec.ts`
- `apps/api/src/platform/money/money.ts`
- `apps/api/src/platform/http/idempotency.ts` (new)
- `apps/api/src/rbac/permission-cache.ts`
- `apps/api/src/rbac/permission.guard.ts`

## Steps

1. **Pagination.** Delete `encodeCursor`, `decodeCursor` and `createResponse` from the `PaginationHelper` class (lines 171-186). Find callers first and point them at the module-level functions, which are already exported:
   ```
   rg "paginationHelper\.(encodeCursor|decodeCursor|createResponse)|helper\.(encodeCursor|decodeCursor|createResponse)" apps/api
   ```
   Keep `resolveLimit` and `normalizeParams` — those do real work and need the injected `SettingsService`. Update `pagination.spec.ts` to call the standalone functions directly.
2. **Permission cache.** Delete `hasPermission` and `hasAllPermissions` (lines 47-67). Confirm nothing calls them first (`rg "hasPermission|hasAllPermissions" apps/api`). Do **not** rewrite `PermissionGuard` to use them instead — the guard needs to know *which* slug failed to build its 403 details (`permission.guard.ts:66-69`), and a boolean cannot carry that. If F-08 introduced `WILDCARD_SLUG`, make sure the guard's check uses that constant rather than a bare `'*'`.
3. **Money.** Delete `formatMoney` (lines 48-67). `roundMoney` stays — it implements the locked `DECIMAL(12,2)` decision and has tests.
4. **Idempotency.** Create `apps/api/src/platform/http/idempotency.ts`:
   ```ts
   export const IDEMPOTENCY_KEY_HEADER = 'idempotency-key' as const;
   export type IdempotencyKey = string;
   ```
   Delete lines 1-2 of `money.ts` and repoint importers:
   ```
   rg "IDEMPOTENCY_KEY_HEADER|IdempotencyKey" apps/api
   ```
   If there are no importers at all, delete the two declarations outright instead of creating the new file — Module 0 explicitly excludes the idempotency store, so an unused constant waiting for it is the same smell in a tidier location. Prefer deletion; create the file only if something already imports these.
5. Run `pnpm --filter api typecheck` after each deletion rather than all four at once, so an unexpected caller is easy to attribute.

## Done when

- `PaginationHelper` exposes only `resolveLimit` and `normalizeParams`.
- `rg "formatMoney|hasAllPermissions" apps/api` returns nothing.
- `money.ts` exports `roundMoney` and nothing else.
- `pnpm --filter api lint typecheck test` passes with no unused-export warnings.
