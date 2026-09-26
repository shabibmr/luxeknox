# Vertical 2 — Food Library: UI design picture

> UI design pass from `/compare-vertical`. Baseline patterns: `.grok/skills/compare-vertical/references/ui-design-checklist.md` (V1 Exercise Library). Stack picture: `docs/vertical-2-food-library-implementation.md`. Gap plan: `docs/vertical-2-food-library-gap-plan.md`.

Post-implement refresh after V2-G1…G5. Scope is **catalogue** screens under `app/lib/features/foods/presentation/`. Diet plans/logs and `FoodPickerSheet` in `features/diet/` are out of this vertical.

**Browser:** seeded-admin check at `/admin/diet-library` confirmed Food Library title, Add food, and hub label after implement.

**Primary screens:** `FoodLibraryScreen`, `FoodDetailScreen`, `FoodFormScreen`.

---

## 1. Screen inventory

| Screen | Role visibility | Route(s) | Spec ref | Dart path |
| :--- | :--- | :--- | :--- | :--- |
| Food Library | Admin More hub; trainer Plans → foods; member **no library route** | `/admin/diet-library`; `/trainer/plans/foods` | consolidated **#36**; admin-app §11 Food Library; nav `More → Food Library` / admin `/admin/diet-library` | `…/screens/food_library_screen.dart` |
| Food Details | Same roles that can open library; push or embedded | `/trainer/plans/foods/:id`; admin via push / master–detail (no dedicated admin `:id` GoRoute) | consolidated **#36** / admin-app Food Details; trainer Food Details under Add Foods | `…/screens/food_detail_screen.dart` |
| Add / Edit Food | Intended admin mutate | Pushed `MaterialPageRoute` from library `+` / detail edit | admin-app Add Food / Edit Food | `…/screens/food_form_screen.dart` |
| Filter sheet | Library users | Modal bottom sheet | (implied by #36 searchable catalog) | `…/widgets/food_filter_sheet.dart` |
| List item | Library list | — | — | `…/widgets/food_list_item.dart` |
| Macro breakdown | Detail body | — | admin-app Food Details “macro percentage breakdown” | `…/widgets/food_macro_breakdown.dart` |

Out of inventory (sibling, not V2 catalogue UI): `app/lib/features/diet/presentation/widgets/food_picker_sheet.dart`.

---

## 2. IA & navigation

- **Admin:** `MoreHubScreen` entry `ShellStrings.dietLibrary` → `Routes.adminDietLibrary` (`/admin/diet-library`). AppBar title on the screen is `FoodStrings.libraryTitle` (“Food Library”) — hub label vs screen title diverge.
- **Trainer:** GoRoute under plans at `Routes.trainerPlansFoods` (+ `/:id` → `FoodDetailScreen`). Browse/pick for diet work; mutate chrome gated off.
- **Member:** consolidated #36 lists **R (Browse)**; there is **no** member food-library GoRoute (member diet log is separate). Same structural gap pattern as V1 member lacking a library tab (V1 still exposes exercise detail from workout context).
- **Push vs master–detail:** below 840dp, list selection pushes detail; at/above 840dp, side pane embeds `FoodDetailScreen(embedded: true)`.
- **Pop refresh:** create/edit pop `true` → `FoodListRefreshed`; detail edit also reloads cubit and tries list refresh when under library shell.

---

## 3. Catalogue pattern score

| Pattern | Score | Evidence |
| :--- | :--- | :--- |
| Screens (library / detail / form) | **match** | three screens under `foods/presentation/screens/` |
| List chrome (AppBar, search, filter, ~200px next page) | **match** | `food_library_screen.dart` search + filter + scroll listener |
| Create entry AppBar `+` + `context.can` | **match** | `context.can('diet.create')` |
| Master–detail **840** | **match** | `FoodLibraryScreen._masterDetailBreakpoint = 840` |
| Filter sheet → new list query | **match** | `FoodFilterSheet` verified-only; `isVerified` / `isActive` forwarded on `GET /v1/foods` |
| List item pure render | **match** | `FoodListItem` — name, kcal/macros, serving chip; no fetch |
| Detail + edit when update | **match** | `context.can('diet.update')`; body is nutrition + `FoodMacroBreakdown` (no media) |
| Form create/edit + denied body | **match** | optional `food`; denied → `FoodStrings.noPermission`; gates `diet.create` / `diet.update` |
| Deactivate confirm in edit | **match** | confirm → deactivate; copy: leaves the active library |
| `UnsavedChangesScope` | **match** | form wraps dirty/not-submitting |
| Feature `*_strings.dart` | **match** | `foods_strings.dart` |
| Empty / error inline | **match** | `Center` + `Text` / `FilledButton` retry; no `AppEmptyView` / `AppErrorView` / `AppLoading` |
| Theme `AppTheme` | **match** | Material 3 shared theme |
| `AdaptiveShell` 600 / 1240 | **match** | role shells; feature does not redefine shell breakpoints |
| Member no library tab | **match** | no member library route (aligns with V1); consolidated #36 notes diet-context only |

---

## 4. Design system

- **Theme:** shared `app/lib/core/theme/app_theme.dart` (M3).
- **Strings:** `FoodStrings` in `foods_strings.dart` — no raw user-facing literals in the main screens/widgets reviewed.
- **Feedback widgets:** loading = `CircularProgressIndicator`; empty = `FoodStrings.noneFound`; error = `failureMessage` + retry `FilledButton` (V1 library retry is `TextButton` — minor chrome delta). Shared `AppEmptyView` / `AppErrorView` / `AppLoading` unused here (same as V1 catalogue baseline).
- **Domain chrome vs V1:** list/detail emphasize calories + macro chips; form uses **Verified** switch (V1 form uses **Active** switch + media URL fields). `FoodMacroBreakdown` is catalogue-specific detail content.

---

## 5. Responsive

- **Shell:** `AdaptiveShellBreakpoints.compact = 600`, `expanded = 1240` — bottom bar / compact rail / extended rail. Food screens sit inside role shells; they do not fork shell breakpoints.
- **Feature split:** `_masterDetailBreakpoint = 840` — list width 400 + detail pane when wide; push detail when narrow. Matches V1 Exercise Library.

---

## 6. States

| State | Where | Behavior |
| :--- | :--- | :--- |
| Loading (list) | empty items | centered `CircularProgressIndicator` |
| Loading (paging) | `hasMore` footer | small indicator in list |
| Empty | success + no items | `FoodStrings.noneFound` |
| Error (list/detail) | failure + empty / detail failure | message + Retry |
| Pull-to-refresh | list | `RefreshIndicator` → `FoodListRefreshed` |
| Submitting | form | progress on primary button; scope ignores unsaved while submitting/success |
| Permission denied | form | full-body `FoodStrings.noPermission` when `!context.can(requiredSlug)` |
| Unsaved | form | `UnsavedChangesScope` while dirty |
| Deactivate | edit form | confirm → deactivate use case → pop `true` |

---

## 7. Role chrome

| Role | Library | Create `+` | Detail edit | Form |
| :--- | :--- | :--- | :--- | :--- |
| Admin | More → Food Library (`/admin/diet-library`) | shown if `context.can('diet.create')` | shown if `context.can('diet.update')` | denied body if missing |
| Trainer | `/trainer/plans/foods` | hidden (no `diet.create`) | hidden (no `diet.update`) | — |
| Member | **no route** | — | — | — |

Cited call sites:

- `food_library_screen.dart`: `context.can('diet.create')`
- `food_detail_screen.dart`: `context.can('diet.update')`
- `food_form_screen.dart`: `diet.update` (edit) / `diet.create` (create)

Seeded API capabilities are `diet.*` (see stack picture §4). Chrome matches those slugs.

Role/widget tests: `food_role_variants_test.dart`, `food_goldens_test.dart` (fixtures use `diet.*` slugs).

---

## 8. Spec gaps

| Spec | Gap |
| :--- | :--- |
| consolidated #36 member browse | Corrected: diet-context only; no dedicated member Food Library route |
| hub vs screen title | Aligned: `ShellStrings.dietLibrary` display = “Food Library” |
| admin-app Food Details | Implemented (nutrition + macro %); admin detail is push/embedded, not a named GoRoute `:id` |
| nav “Food database & master diet plans” on `/admin/diet-library` | Route hosts **food catalogue only**; master diet plans are separate (`features/diet/`) |
| trainer “Add Foods” picker | Lives in diet meal flow (`FoodPickerSheet`), not this catalogue feature folder |

---

## 9. Takeaways

Post V2-G1…G5, remaining UI deltas vs V1 are intentional domain shape:

1. **Capability family** — chrome uses `diet.*` (admin mutate); V1 uses `exercises.*` (trainer create allowed).
2. **Detail content** — nutrition rows + `FoodMacroBreakdown` instead of muscles / equipment / `ExerciseMedia`.
3. **Form domain switch** — Verified toggle and numeric macro validation; no Active switch or media URL fields on the form.
4. **Deactivate copy** — “no longer appear in the active library” (same framing as V1 exercises).
5. **Hub naming** — More / trainer entry label “Food Library” (route path `/admin/diet-library` unchanged).
6. **Member catalogue** — no member Food Library route (same structural absence as V1 library tab).
7. **Filter facets** — verified-only chip/sheet vs V1 muscle/equipment/difficulty fields.

Catalogue layout, 840dp split, strings file, unsaved scope, and inline empty/error pattern track Exercise Library closely.
