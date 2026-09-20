# V2-08 — E2E tests

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-06 |
| **Files** | 2 |

## Files

- `apps/api/test/foods.e2e.spec.ts` (new — same shape as `test/exercises.e2e.spec.ts`)
- `apps/api/test/helpers/mysql.ts` (extend seed helpers if needed — stay within 7-file budget)

## Work

Real HTTP (`createTestApp()`), real DB, real app user:

- **Admin:** `POST /foods` 201; `GET /foods` includes it; `GET /foods/{id}` returns it;
  `PATCH .../{id}` with `is_active: false` and/or unverified succeeds; deactivated/unverified rows
  drop out of member/trainer browse.
- **Trainer:** `GET` 200; **`POST` 403** (and `PATCH` 403). Same for member.
- **Unauthenticated:** 401 on every route.
- **Browse:** member/trainer lists only `is_active AND is_verified` foods (seed fixtures that prove
  inactive and unverified are hidden).
- **Filters / pagination:** `q`, optional admin `is_verified` / `is_active`; `limit`/`offset` and
  `meta.has_more` / `meta.total` across a page boundary.
- Confirm dual-seed / role matrix: trainer `diets.write` (if present) does **not** allow food
  create/update.

## Done when

`pnpm --filter api test:e2e` passes locally against compose/verification DB for the foods suite
(twice preferred once reset isolation exists; otherwise unique fixture names).
