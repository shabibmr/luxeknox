# V3-01 — Dual-seed PEOPLE/HEALTH/MEDIA slugs + defer medical-histories

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2 exit |
| **Files** | ≤7 |

## Why

OpenAPI uses granular slugs (`members.create|update`, `trainers.*`, `employees.*`,
`media.create`, `health.update`, `health.approve`, `roles.update`) while seed still has
`members.write` / `trainers.write` / `employees.write` / `media.write` / `health.write` and
`rbac.roles_write`. Controllers must enforce OpenAPI slugs. Dual-seed like `exercises.*` /
`diet.*`. Also flip out-of-scope HEALTH catalog paths to `deferred` so V3-16 parity ignores them.

## Files

- `apps/api/src/platform/db/seed/permissions.ts`
- `apps/api/src/platform/db/seed/roles.ts`
- `docs/openapi/v1.yaml` (x-status only on medical-histories + health-conditions)

## Work

### Additive permissions (keep legacy `*.write`)

| OpenAPI slug | Legacy kept |
| :--- | :--- |
| `members.create`, `members.update` | `members.write` |
| `trainers.create`, `trainers.update` | `trainers.write` |
| `employees.create`, `employees.update` | `employees.write` |
| `media.create` | `media.write` |
| `health.update`, `health.approve` | `health.write` |
| `roles.update` (for `PUT /employees/{id}/role`) | `rbac.roles_write` |

Do **not** remove `diet.*` / `diets.*` or `exercises.*`. Do **not** map `diets.write` → food mutate.

### Role × slug matrix (review lock)

| Role | Grant OpenAPI mutate | Notes |
| :--- | :--- | :--- |
| `super_admin` | `'all'` | unchanged |
| `admin` | all `members|trainers|employees.create|update`, `health.update`, `health.approve`, `media.create`, `roles.update` (+ legacy writes) | front-office full PEOPLE |
| `trainer` | **none** of the new mutate slugs | keep `members.read`, `trainers.read`, `health.read`, `media.read`; **strip** `media.write` if it would imply unrestricted upload — do not grant `media.create` |
| `employee` | `members.create`, `members.update` (+ legacy `members.write`) | front desk onboarding; no trainers/employees mutate; no `health.approve` |
| `member` | `health.update` only among new mutates (own EC / health later) | **strip** blanket `media.write` → no `media.create` until purpose-scoped self-upload is designed in V3-11; keep `media.read` / `health.read` |

Strip inappropriate trainer/member mutate grants that currently over-reach (trainer/member
`media.write`; member `health.write` maps to `health.update` for self-service — keep
`health.update` for member, drop granting `health.approve`).

### YAML status flips

Set `x-status: deferred` on:

- `/members/{id}/medical-histories` (all ops)
- `/members/{id}/medical-histories/{historyId}` (all ops)
- `/health-conditions` (all ops)
- `/health-conditions/{id}` (all ops)

Leave documents/photos `deferred` until V3-13b/c. Leave `/media/*` `deferred` until V3-11.

## Done when

- Seed inserts new slugs idempotently; legacy `*.write` rows remain.
- Admin has OpenAPI create/update (+ approve/roles.update) grants; trainer has no PEOPLE/MEDIA
  mutate OpenAPI slugs; member has `health.update` but not `health.approve` / `media.create`.
- medical-histories + health-conditions paths are `x-status: deferred`.
- `pnpm --filter api lint typecheck test` green.
