# V2-09 — OpenAPI parity (`/foods`)

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-08 |
| **Files** | 1 |

## Why

Module-0-only `openapi:check` is insufficient for this vertical. Mirror V1-11: dump and compare the
mvp `/foods` operations against `docs/openapi/v1.yaml`.

## Files

- `docs/openapi/v1.json` (regenerated, not hand-edited)

## Work

1. `pnpm --filter api openapi:dump`.
2. Compare `/foods` and `/foods/{id}` ops in the fresh `v1.json` against `v1.yaml`: same
   `operationId`s (`listFoods` / `createFood` / `getFood` / `updateFood`), snake_case fields,
   status codes, query/path params (`q`, `is_verified`, `is_active`, `id`).
3. Fix drift on the Nest side (controller/DTOs), not by weakening `v1.yaml`, unless V2-01 already
   amended the contract intentionally — then dump must match the amended YAML.
4. Guards must enforce `diet.read` / `diet.create` / `diet.update` even though dumps omit
   `x-permission`.
5. Do not regenerate `packages/api_client` unless YAML changed in V2-01 and Flutter needs it; note
   the decision in the ticket when closing.

## Done when

- No field/status/operationId/param drift between dumped `v1.json` and YAML `/foods` section.
- Parity scope is explicitly beyond module-0-only check.

## Live verification

- `pnpm --filter api openapi:dump` → 12 endpoints including `/v1/foods` and `/v1/foods/{id}`.
- Compared dump vs YAML: `listFoods` / `createFood` / `getFood` / `updateFood`; query params
  `limit`/`offset`/`q`/`is_verified`/`is_active`; `FoodResponseDto` fields match amended YAML
  (including `is_active`).
- `openapi:check` still green for module-0 (8 ops).
- **Did not** regenerate `packages/api_client` — backend-only vertical; Flutter regen is a follow-up
  after YAML `is_active` (V2-01).
