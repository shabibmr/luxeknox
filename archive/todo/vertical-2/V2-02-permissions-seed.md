# V2-02 — Seed `diet.*` permissions

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 2 |

## Why

`docs/openapi/v1.yaml` sets `x-permission: diet.read` / `diet.create` / `diet.update` on `/foods`
ops. Controllers must enforce those OpenAPI slugs. Existing `diets.*` stay reserved for plans/logs —
do **not** map `diets.write` → food mutate (FR-DIET-001 is Admin CRUD + browse).

## Files

- `apps/api/src/platform/db/seed/permissions.ts`
- `apps/api/src/platform/db/seed/roles.ts`

## Work

- Add additive `SEED_PERMISSIONS` (DIET section): `diet.read`, `diet.create`, `diet.update`
  (actions/descriptions for the food library). Leave `diets.read` / `diets.write` /
  `diets.templates_write` in place.
- Role assignment:
  - `super_admin`: already `'all'`, no change.
  - `admin`: all three (`diet.read`, `.create`, `.update`).
  - `trainer`: `diet.read` only — **do not** grant `diet.create` / `diet.update`.
  - `member`: `diet.read` only — **do not** grant `diet.create` / `diet.update`.
  - `employee`: none for `diet.*`.
- Seeding is idempotent (`ON DUPLICATE KEY UPDATE` on `slug`); safe against an already-seeded DB.
- If rows already exist, verify the matrix above and fix any over-grants — do not remove `diets.*`.

## Done when

- `pnpm --filter api seed` succeeds; `SELECT slug FROM permissions WHERE slug LIKE 'diet.%'`
  returns exactly three food-library rows (`diet.read|create|update`).
- Admin has all three role_permissions; trainer and member have `diet.read` only; employee has none
  for `diet.*`.
- `diets.*` rows remain; trainer/member `diets.write` (if present) does not grant food mutate.
