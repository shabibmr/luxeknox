# Vertical 2 — Food Library: gap-fix plan

> Vertical: V2 Food Library (catalogue foods, FR-DIET-001).
> Mode: default. This file is the `/implement` handoff.
> **Status: V2-G1…G5 Done** (Flutter foods feature + consolidated #36 + hub label; optional DS query-arg test + admin web/API verify).
> Stack: `docs/vertical-2-food-library-implementation.md`
> UI: `docs/vertical-2-food-library-ui-design.md`
> Baseline: Vertical 1 Exercise Library soft-CRUD catalogue.

Scores pulled from implementation §9 (including the delta-axis table) and UI §3 plus §9. Match rows (HTTP surface, Nest layout, audit, Flutter layers, pagination, OpenAPI contract, three-screen catalogue, 840dp split, list chrome, inline empty/error, unsaved scope, shell 600/1240) are not work items.

## 1. In scope

Fixes that close a **partial / different** score or a takeaway that breaks live catalogue behavior:

| ID | Problem | Closes |
| :--- | :--- | :--- |
| V2-G1 | Flutter UI and foods tests gate on `foods.*`; Nest, OpenAPI, and seed agree on `diet.*` | Stack Permissions **different**; UI create / detail / form **partial** |
| V2-G2 | Domain omits `isActive`; mapper drops wire `is_active`; deactivate PATCH sets `is_verified: false`. Confirm copy says the food disappears as verified | Stack Soft-deactivate **partial**, Deactivate client **different**, Mapper shims **partial**; UI §9.4 |
| V2-G3 | List remote data source does not forward `is_verified` / `is_active`; comments still claim the contract lacks those query params | Stack §9.5; UI filter sheet **partial** (query mirror only) |
| V2-G4 | Admin More / trainer hub label “Diet Library” vs in-screen “Food Library” | UI §9.5 label alignment |
| V2-G5 | Consolidated #36 still says member **R (Browse)** though there is no member library route | UI Member no library tab **partial**; UI §9.6 |

## 2. Out of scope (intentional)

| Delta | Why it stays |
| :--- | :--- |
| Admin-only `diet.create` / `diet.update` (trainers `diet.read` only) | Product rule vs V1 trainer create. Do not widen the seed. Evidence: implementation §9.3 and Permissions row (`roles.ts`) |
| Public row = `is_active && is_verified` | Stricter than V1 inactive-only. Evidence: implementation Visibility row (`food.service.ts` `isPublicCatalogueRow`) |
| Nutrition / macro body, no exercise media URLs | Domain content, not missing catalogue chrome. Evidence: implementation Media row; UI §9.2 and detail row |
| Verified toggle, numeric macros, no Active switch, no media URL fields | Food form shape. Deactivate stays a confirm on edit, not a new switch. Evidence: UI §9.3 |
| Verified-only filter facet (not muscle / equipment / difficulty) | Food facets. Only the missing query forward is in scope (V2-G3). Evidence: UI §9.7 |
| No member Food Library route | Same structural absence as V1’s member library tab. V2-G5 fixes spec text only. Evidence: UI §3 Member row |
| Diet plans/logs and `app/lib/features/diet/` (including meal `FoodPickerSheet` and master diet plans) | Out of this vertical. Evidence: `.grok/skills/compare-vertical/references/vertical-index.md` V2 column |

## 3. Work items

| ID | Fix | Primary paths | Acceptance | Depends on | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| V2-G1 | Replace `context.can('foods.*')` and test capability fixtures with `diet.read` / `diet.create` / `diet.update` | `app/lib/features/foods/presentation/screens/food_library_screen.dart`; `food_detail_screen.dart`; `food_form_screen.dart`; `app/test/features/foods/presentation/food_role_variants_test.dart`; `food_goldens_test.dart` (and any other `foods.create` / `foods.update` / `foods.read` under `app/lib/features/foods` or `app/test/features/foods`) | Admin holding only `diet.*` sees create `+` and edit; trainer without `diet.create` / `diet.update` does not. Role and golden tests pass on `diet.*` fixtures. No `foods.create` / `foods.update` / `foods.read` left in the foods feature or its tests | — | **Done** |
| V2-G2 | Add `isActive` on `Food` (`copyWith` / props). Map `api.Food.isActive` in `FoodModel`. Deactivate = GET then PATCH with `isActive: false` and leave `isVerified` unchanged. Point confirm copy at deactivated / not active, not “no longer appear as verified” | `app/lib/features/foods/domain/entities/food.dart`; `data/models/food_model.dart`; `data/repositories/food_repository_impl.dart`; `domain/repositories/food_repository.dart`; `presentation/foods_strings.dart`; `presentation/screens/food_form_screen.dart` | Wire body includes `is_active: false` and does not clear verified. Read round-trips `isActive`. Confirm copy matches that behavior. Repository and model tests cover the field | — | **Done** |
| V2-G3 | Forward list filters `q`, `is_verified`, `is_active`, `limit`, `offset`. Drop stale “contract has no is_active / is_verified” comments. Keep the sheet verified-only; do not add exercise facets | `domain/entities/food_filter.dart`; `data/datasources/food_remote_datasource.dart`; `presentation/widgets/food_filter_sheet.dart`; `presentation/bloc/food_list_bloc.dart` | Changing the verified filter changes `GET /v1/foods` query params. Comments match the OpenAPI list operation. Filter tests still pass | V2-G2 only for shared `isActive` naming | **Done** |
| V2-G4 | Make the hub/rail label match `FoodStrings.libraryTitle` (“Food Library”). Prefer renaming `ShellStrings.dietLibrary` (route path `/admin/diet-library` may stay) | `app/lib/core/l10n/shell_strings.dart`; `app/lib/core/widgets/more_hub_screen.dart`; `app/lib/core/router/trainer_routes.dart` | More hub and trainer entry read “Food Library”, same as the library AppBar | — | **Done** |
| V2-G5 | Change consolidated #36 so member food browse is not a dedicated library route (diet-context / no member library surface), matching the V1 member-library note | `docs/screens/consolidated-screens.md` (#36); role screen docs only where they repeat member **R (Browse)** for this catalogue | Spec no longer implies a member food-library route. No new route is added | — | **Done** |

## 4. Verification

- `cd app && flutter test test/features/foods` (model, repository, filter, list bloc, filter sheet, role variants, goldens).
- Do not regen the API client: `is_active` / list filters are already on the diet contract. Do not change Nest seed or `food.service` visibility.
- Optional: seeded admin on web, `/admin/diet-library`, AppBar `+` visible, edit → deactivate, row hidden from a non-updater list because `is_active` is false (verified flag unchanged).

## 5. Implement handoff

Fix Vertical 2 Food Library client/spec gaps in `docs/vertical-2-food-library-gap-plan.md`: (V2-G1) gate foods screens and tests with `diet.read` / `diet.create` / `diet.update` instead of `foods.*`; (V2-G2) add domain `isActive`, map it, deactivate with PATCH `is_active: false` without clearing verified, and fix the confirm copy; (V2-G3) forward `q`, `is_verified`, `is_active`, `limit`, and `offset` on the list call and remove stale contract-mismatch comments; (V2-G4) rename the shell hub label to “Food Library”; (V2-G5) correct consolidated #36 so it does not claim a member library route. Do not change admin-only mutate seed, verified+active visibility, diet plans/logs, or `app/lib/features/diet/`, and do not add a member foods route. Run `flutter test test/features/foods`.
