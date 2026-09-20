# Vertical 2 — Food Library — Todo

Backend implementation of the second feature vertical (`docs/adr/0007-first-delivery-vertical.md`).
Builds on Module 0 + Vertical 1 (`archive/todo/vertical-1/`). Source plan:
`archive/todo/vertical-2-3-backend-plan.md` (V2 section only).

**Location:** tickets live under `archive/todo/vertical-2/` (live `todo/` is archived).

**Scope:** `foods` only — Admin CRUD (FR-DIET-001), Member/Trainer browse verified+active.
Contract: `docs/openapi/v1.yaml` (`GET/POST /foods`, `GET/PATCH /foods/{id}`, schemas `Food` /
`FoodWrite` / `FoodPage`, permissions `diet.read` / `diet.create` / `diet.update`).

**Out of scope:** diet plans, plan versions, meals, diet_plan_foods, diet_histories / food logs
(FR-DIET-002+). Do not add columns, endpoints, or mutate grants for those here. Keep existing
`diets.*` seed slugs reserved for later plan/log work — do not map `diets.write` → food mutate.

**Rule:** each task touches at most 7 files (same rule as Module 0 / V1).
**Rule:** each task lands green — `pnpm --filter api lint typecheck test` passes before the next
task starts.

**Status:** completed (verified live against local MariaDB — `db:migrate` collation gate blocked; `foods` applied with `utf8mb4_unicode_ci`).

## Locked decisions

| Topic | Decision | Source |
| :--- | :--- | :--- |
| Contract | Implement against `docs/openapi/v1.yaml`; dump drift is a bug | `docs/openapi/README.md`, V1 practice |
| Permission slugs | `diet.read` / `diet.create` / `diet.update`. Additive alongside `diets.*` | YAML `x-permission`, plan |
| Role matrix | Admin: all three. Trainer + member: `diet.read` only. Employee: none for `diet.*` | FR-DIET-001, plan |
| Visibility | Non-updaters browse `is_active AND is_verified` | FR-DIET-001, BR-DIET-002, plan |
| Delete | No hard delete, no `DELETE` endpoint. Soft-deactivate via `is_active` | YAML (`PATCH` only), entities |
| `is_active` | Column + YAML `Food` (required) / `FoodWrite` (optional) + optional list filters | plan locked decisions |
| Nutrition nums | Drizzle `double` (OpenAPI `number`; MySQL `decimal` lacks number mode) | schema / typecheck |
| Audit | `POST`/`PATCH` write an `audit_logs` row (FR-API-007), M0-19 helper | FRD |
| openapi parity | V2-09 dump/compare for `/foods` mvp ops — not module-0-only `openapi:check` | plan, V1-11 |

## Graph

```
V2-01 YAML is_active ─┐
V2-02 permissions seed ┤
                       ├─ V2-05 service ─ V2-06 controller ─┬─ V2-07 unit tests
V2-03 schema + migration ─ V2-04 repository ┘               ├─ V2-08 e2e tests
                                                             └─ V2-09 openapi parity
```

V2-01, V2-02, and V2-03 have no prerequisites and may run in parallel.
Plan shorthand: `V2-01 ∥ V2-02 ∥ V2-03 → V2-04 → V2-05 → V2-06 → V2-07 ∥ V2-08 → V2-09`.

## Checklist

- [x] [V2-01](./V2-01-yaml-is-active.md) YAML `is_active` + list filters
- [x] [V2-02](./V2-02-permissions-seed.md) Seed `diet.read/create/update`
- [x] [V2-03](./V2-03-schema-migration.md) `foods` schema + `0003_foods.sql`
- [x] [V2-04](./V2-04-repository.md) `FoodRepository`
- [x] [V2-05](./V2-05-service-dto.md) `FoodService` + Zod + audit
- [x] [V2-06](./V2-06-controller-module.md) `FoodController` + `DietModule`
- [x] [V2-07](./V2-07-unit-tests.md) Unit tests (13/13)
- [x] [V2-08](./V2-08-e2e-tests.md) E2E tests (9/9)
- [x] [V2-09](./V2-09-openapi-parity.md) OpenAPI parity (`/foods`)

## Exit

Live admin CRUD; trainer `POST` 403; browse hides inactive/unverified for non-updaters; faster than
V1 or stop and fix patterns (ADR-0007).

## Out of Vertical 2

`diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, `diet_histories`.
`PEOPLE` / Members (vertical 3). `MEDIA` (ADR-0005 / V3). Workout plans/sessions (vertical 6+).
