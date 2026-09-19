# V1-04 — Seed `exercises.*` permissions

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 2 |

## Why

`docs/openapi/v1.yaml` sets `x-permission: exercises.read` (`GET /exercises`, `GET /exercises/{id}`),
`exercises.create` (`POST /exercises`), `exercises.update` (`PATCH /exercises/{id}`). None of these
slugs exist in `SEED_PERMISSIONS` (`apps/api/src/platform/db/seed/permissions.ts`) — the WORK module
there only has the coarser `workouts.read` / `workouts.write` / `workouts.templates_write`, reserved
for plans/sessions (out of scope here — see register-level locked decisions). These are new,
additive slugs, not a rename.

## Files

- `apps/api/src/platform/db/seed/permissions.ts`
- `apps/api/src/platform/db/seed/roles.ts`

## Work

- Add to `SEED_PERMISSIONS` (WORK section): `{ module: 'WORK', action: 'exercises_read', slug:
  'exercises.read', description: 'View the exercise library' }`, and the `exercises_create` /
  `exercises_update` equivalents for `exercises.create` / `exercises.update`.
- Role assignment, matching screen 29's `R` (member) / `R` (trainer) / `F` (admin) access:
  - `super_admin`: already `'all'`, no change needed.
  - `admin`: add all three (`exercises.read`, `.create`, `.update`).
  - `trainer`: add `exercises.read` only.
  - `member`: add `exercises.read` only.
  - `employee`: none — not in the R/R/F table for this screen.
- Seeding is idempotent (`ON DUPLICATE KEY UPDATE` on `slug` — see existing `seedPermissions`), so
  this is safe to run against an already-seeded database.

## Done when

- `pnpm --filter api seed` succeeds and `SELECT slug FROM permissions WHERE slug LIKE 'exercises.%'`
  returns exactly three rows.
- Admin has all three role_permissions rows; trainer and member have `exercises.read` only; employee
  has none.
