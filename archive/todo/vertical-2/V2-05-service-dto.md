# V2-05 — `FoodService` + DTOs

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-04, V2-01 |
| **Files** | 3 |

## Files

- `apps/api/src/diet/food.service.ts` (new)
- `apps/api/src/diet/food.dto.ts` (new — Zod schemas mirroring `FoodWrite`)
- `apps/api/src/diet/food.dto.spec.ts` (new, or fold into V2-07 — implementer's call)

## Work

- `food.dto.ts`: `foodWriteSchema` (Zod) — `name` and `serving_unit` required non-empty strings;
  `serving_size`, `calories`, `protein_grams`, `carbs_grams`, `fat_grams`, `fiber_grams` optional
  numbers; `is_verified` / `is_active` optional booleans. Field names **snake_case** (raw body via
  `ZodValidationPipe`).
- `food.service.ts`:
  - `list(query, caller)`: pagination via `PaginationHelper` (V1 shape). For callers **without**
    `diet.update`, force browse filters `is_active = true` **and** `is_verified = true`
    (FR-DIET-001 / BR-DIET-002), ignoring weaker client filters. Updaters (admin) may pass optional
    `is_active` / `is_verified` / `q` through to the repository.
  - `getById(id)`: `NotFoundError` if missing. Non-updaters must not see inactive or unverified rows
    (404), matching list visibility.
  - `create(dto)`: insert, then audit via M0-19 helper — action `food.created`.
  - `update(id, dto)`: audit `food.updated`. Deactivation is `is_active: false` on PATCH — **no
    DELETE** method or route.
- No raw SQL in the service (delegate to repository).

## Done when

- Zod rejects a body missing `name` or `serving_unit`; accepts minimal `{ name, serving_unit }`.
- Non-updater list/get only surfaces active+verified foods.
- Every mutation writes exactly one audit row.
