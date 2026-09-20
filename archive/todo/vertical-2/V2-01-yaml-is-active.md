# V2-01 — YAML `is_active` + list filters

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 1 |

## Why

FR-DIET-001 and soft-deactivate convention require `foods.is_active`. Non-updaters browse
verified+active; admins need optional list filters. Prefer amending YAML only — touch
`docs/database-entities.md` only if the foods key-attrs still omit `is_active` after V2-03.

## Files

- `docs/openapi/v1.yaml` (prefer YAML only)

## Work

- On `Food`: add `is_active` boolean, **required**, same pattern as `Exercise.is_active`.
- On `FoodWrite`: add optional `is_active` boolean.
- On `GET /foods` (`listFoods`): add optional query params `is_verified` and `is_active`
  (boolean), alongside existing `limit` / `offset` / `q`.
- Do not invent new operations, tags, or permission slugs. Do not flip any `x-status`.

## Done when

- `Food.required` includes `is_active`; `FoodWrite` exposes optional `is_active`.
- `listFoods` parameters include optional `is_verified` and `is_active`.
- YAML matches the V2 locked decisions in `archive/todo/vertical-2-3-backend-plan.md`.
