# Vertical 2 — Food Library: implementation picture

> Stack picture from `/compare-vertical`. Baseline: `docs/vertical-1-exercise-library-implementation.md`. Section order and delta axes: `.grok/skills/compare-vertical/references/section-checklist.md`. UI design: `docs/vertical-2-food-library-ui-design.md`. Gap plan: `docs/vertical-2-food-library-gap-plan.md`.

Analysis only (no code changes). Scope is **catalogue foods** (FR-DIET-001), per ADR-0007. Diet plans/logs live in the same Nest `DietModule` but are **out of Vertical 2**.

**Status:** Backend tickets V2-01…V2-09 all checked in `archive/todo/vertical-2/`. Flutter Food Library under `app/lib/features/foods/` matches Nest/OpenAPI on `diet.*` gates, `isActive` mapping, list filter forward, and soft-deactivate (`PATCH is_active: false`). Gap plan V2-G1…G5 applied; see `docs/vertical-2-food-library-gap-plan.md`.

---

## 1. What “CRUD” means here

| Operation | HTTP | Permission | Notes |
| :--- | :--- | :--- | :--- |
| **Read list** | `GET /v1/foods` | `diet.read` | Filters: `q`, `is_verified`, `is_active`; offset pagination. Non-updaters forced to verified+active |
| **Read one** | `GET /v1/foods/{id}` | `diet.read` | Non-public rows 404 unless actor has `diet.update` |
| **Create** | `POST /v1/foods` | `diet.create` | 201; audit `food.created`; defaults `is_active: true`, `is_verified: false` if omitted |
| **Update** | `PATCH /v1/foods/{id}` | `diet.update` | Partial; audit `food.updated` |
| **Delete** | **None** | — | Soft-deactivate via `PATCH { "is_active": false }` |

There is **no** `DELETE /foods/{id}` and no `diet.delete` / `foods.delete` slug. Nest `@RequirePermission` and OpenAPI `x-permission` agree on `diet.*`.

---

## 2. End-to-end stack

```
Flutter UI
  FoodLibraryScreen / FoodDetailScreen / FoodFormScreen
    ↓ Bloc / Cubit
  Use cases (get/create/update/deactivate)
    ↓
  FoodRepositoryImpl → FoodRemoteDataSource → DIETApi (generated)
    ↓ HTTP /v1/foods*
Nest FoodController → FoodService → FoodRepository → MariaDB `foods`
```

**Contract source of truth:** `docs/openapi/v1.yaml` (`listFoods`, `createFood`, `getFood`, `updateFood`). Client: `packages/api_client` (`DIETApi`).

---

## 3. Backend (Nest)

### Layout

| Piece | Path |
| :--- | :--- |
| Controller | `apps/api/src/diet/food.controller.ts` |
| Service | `apps/api/src/diet/food.service.ts` |
| Repository | `apps/api/src/diet/food.repository.ts` |
| Zod DTOs | `apps/api/src/diet/food.dto.ts` |
| Schema | `apps/api/src/platform/db/schema/foods.ts` |
| Module | `apps/api/src/diet/diet.module.ts` (also hosts diet plan/log) |

### Table (`foods`)

`id`, `name`, `serving_unit`, `serving_size`, `calories`, `protein_grams`, `carbs_grams`, `fat_grams`, `fiber_grams`, `is_verified` (default false), `is_active` (default true), `created_at`, `updated_at`. Indexes on `(is_active, is_verified)` and `name`.

### Service behavior

- **List:** `PaginationHelper` + `foodFilterQuerySchema`. Callers **without** `diet.update` get `isActive: true` and `isVerified: true` forced. Holders of `diet.update` may pass optional `is_active` / `is_verified` (`SEE_UNRESTRICTED_PERMISSION`).
- **Get:** Load by id → `requireVisibleCatalogueRow` with `isPublicCatalogueRow` = `is_active && is_verified` (else 404 unless unrestricted).
- **Create:** Insert → reload → audit `food.created`.
- **Update:** Partial field patch only; omitted fields untouched. Deactivation is `is_active: false`. Always audits before/after as `food.updated`.

### Validation (Zod)

- Write: `name` + `serving_unit` required; optional serving/macros/`is_verified`/`is_active`.
- Update: same schema `.partial()`.
- Filter query: optional `q`, `is_verified`, `is_active` (boolean query coercion for `true`/`false`/`1`/`0`).

---

## 4. Permissions (seeded)

Slugs in `apps/api/src/platform/db/seed/permissions.ts` / `roles.ts`:

| Slug | Admin | Trainer | Member |
| :--- | :---: | :---: | :---: |
| `diet.read` | ✓ | ✓ | ✓ |
| `diet.create` | ✓ | — | — |
| `diet.update` | ✓ | — | — |

Implications:

- Members and trainers: browse verified+active only.
- Trainers **cannot** create or edit foods (unlike V1 exercises, where trainers have `exercises.create`).
- Admins: full catalogue mutate + see unrestricted rows.

**Flutter:** screens and foods tests gate on `diet.read` / `diet.create` / `diet.update` (aligned with seed).

---

## 5. Flutter (Clean Architecture)

### Domain

- Entity: `Food` — nutrition fields + `isVerified` + `isActive`
- Filter: `FoodFilter` (`query`, `isVerified`, `isActive`) — forwarded on list
- Repo contract: `getFoods`, `getFood`, `create`, `update`, `deactivate`
- Use cases: one file each for those five operations

### Data

- `FoodRemoteDataSource` → `DIETApi.listFoods` / `getFood` / `createFood` / `updateFood`
- List cursor is **offset-as-string** (`int.tryParse(cursor)`)
- Remote list forwards `q`, `is_verified`, `is_active`, `limit`, `offset`
- **Deactivate** = GET → `copyWith(isActive: false)` → PATCH write (`is_verified` unchanged)

### Presentation

| Screen | Role | Behavior |
| :--- | :--- | :--- |
| `FoodLibraryScreen` | Intended: read | Search, filter sheet, infinite scroll via `FoodListBloc`; master–detail ≥840dp |
| App-bar `+` | `diet.create` | Pushes `FoodFormScreen` (create) |
| `FoodDetailScreen` | Intended: read | `FoodDetailCubit`; edit if `diet.update` |
| `FoodFormScreen` | create/update | Create vs edit by optional `food`; deactivate confirm in edit |

**Routes**

- Admin: `/admin/diet-library` (`Routes.adminDietLibrary`)
- Trainer: `/trainer/plans/foods` (+ `/:id`)
- Member: no food-library route (diet log is separate under `features/diet/`)

### Mapper quirks (`food_model.dart`)

| Field | OpenAPI / Nest | Flutter domain | Mapping |
| :--- | :--- | :--- | :--- |
| `id` | `int` | `String` | `toString` / `int.parse` |
| nutrition nums | `number?` | `double?` | `toDouble()` |
| `is_verified` | `boolean?` | `bool` | null → `false` on read |
| `is_active` | required on `Food`; optional on `FoodWrite` | `bool` (`isActive`) | mapped end-to-end; deactivate PATCHes `is_active: false` |

---

## 6. Read / Create / Update / Delete flows (UI → API)

### Read

1. Library start → `GetFoodsUseCase` → `GET /foods?...` (server enforces verified+active for non-updaters)
2. Detail → `GetFoodUseCase` → `GET /foods/{id}`
3. Inactive or unverified: members/trainers get 404; admins with `diet.update` can list/get them

### Create

1. `+` → form → `CreateFoodUseCase` → `POST /foods` (`FoodWrite`)
2. Pop `true` → parent refreshes list
3. UI gate uses `diet.create`

### Update

1. Detail edit → form prefilled → `UpdateFoodUseCase` → `PATCH /foods/{id}`
2. UI gate uses `diet.update`

### Delete (deactivate)

1. Edit form → confirm → `DeactivateFoodUseCase`
2. Client: GET + PATCH with **`is_active: false`** (`is_verified` unchanged)
3. Confirm copy: food leaves the active library (matches V1 exercise wording)

---

## 7. Tests / verification already in tree

**API:** `food.controller.spec.ts`, `food.service.spec.ts`; e2e `apps/api/test/foods.e2e.spec.ts` (V2-08).

**Flutter:** repository/model/usecase/entity/filter tests; `food_list_bloc_test`, `food_detail_cubit_test`, `food_role_variants_test`, filter/list-item/goldens; plus `app/test/features/diet/verified_food_visibility_test.dart`.

---

## 8. Boundaries (do not confuse with V2)

- **In V2:** catalogue foods only (FR-DIET-001).
- **Same Nest module, later work:** `DietPlan*` / `DietLog*` (`diets.*` slugs); Flutter `app/lib/features/diet/`.
- **Media:** no media URLs on foods — nutrition numbers only.
- **Exercises (V1):** parallel soft-CRUD catalogue under `WorkModule` / `exercises.*`.

---

## 9. Takeaways

1. Vertical 2 backend is a **complete soft-CRUD catalogue** aligned with V1: C/R/U + `PATCH is_active: false`; hard delete absent.
2. Visibility is **stricter than V1**: public row = `is_active && is_verified`; gate permission `diet.update`.
3. Mutate grants are **admin-only** (`diet.create` / `diet.update`); trainers only `diet.read` — deliberate vs V1 trainer create.
4. Nest + OpenAPI + seed + Flutter UI/tests agree on **`diet.*`**.
5. Flutter maps `isActive`; deactivate PATCHes `is_active: false` and leaves verified unchanged; list DS forwards verified/active filters.
6. Clean Architecture shape (five use cases, DIETApi, offset-as-string cursor, 840dp master–detail) mirrors Exercise Library.

### vs Vertical 1 (delta axes)

| Axis | Score | Evidence |
| :--- | :--- | :--- |
| HTTP surface | **match** | `GET/POST /v1/foods`, `GET/PATCH /v1/foods/{id}`; no DELETE — `food.controller.ts`, OpenAPI |
| Soft-deactivate | **match** | Server and Flutter `PATCH { is_active: false }` — `food_repository_impl.dart` |
| Visibility | **different** | V1 inactive-only; V2 verified+active — `food.service.ts` `isPublicCatalogueRow` |
| Permissions | **different** | Slugs `diet.*` (admin mutate only) vs V1 `exercises.*` (trainer create) — seed `roles.ts` |
| Nest layout | **match** | controller / service / repository / dto / schema / `diet.module.ts` |
| Audit | **match** | `food.created` / `food.updated` |
| Flutter layers | **match** | domain → data → presentation; five use cases including deactivate |
| Deactivate client | **match** | GET+PATCH `is_active: false`; verified unchanged |
| Pagination | **match** | offset; Flutter cursor is offset-as-string |
| Mapper shims | **match** | `id` int↔String + num→double; `is_active` mapped — `food_model.dart` |
| Media | **different** | No media URLs; nutrition macros instead |
| Contract | **match** | `docs/openapi/v1.yaml` + `packages/api_client` `DIETApi` |

Post-implement: gap plan V2-G1…G5 closed. Remaining deltas above are intentional product differences.
