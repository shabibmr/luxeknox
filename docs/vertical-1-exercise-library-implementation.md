# Vertical 1 — Exercise Library: implementation picture

> **Baseline** for `/compare-vertical` (stack + UI + gap plan). Section order and delta axes: `.grok/skills/compare-vertical/references/section-checklist.md`.

Analysis only (no code changes). Scope is **catalogue exercises** (FR-WORK-001 / FR-WORK-002), per ADR-0007. Workout plans/sessions live in the same Nest `WorkModule` but are **out of Vertical 1**.

**Status:** Backend tickets V1-01…V1-11 all checked in `archive/todo/vertical-1/`. Flutter feature under `app/lib/features/exercises/` is implemented and wired.

---

## 1. What “CRUD” means here

| Operation | HTTP | Permission | Notes |
| :--- | :--- | :--- | :--- |
| **Read list** | `GET /v1/exercises` | `exercises.read` | Filters: `q`, `primary_muscle_group`, `equipment_needed`, `difficulty_level`; offset pagination |
| **Read one** | `GET /v1/exercises/{id}` | `exercises.read` | Inactive rows 404 for callers without `exercises.update` |
| **Create** | `POST /v1/exercises` | `exercises.create` | 201; audit `exercise.created` |
| **Update** | `PATCH /v1/exercises/{id}` | `exercises.update` | Partial; audit `exercise.updated` |
| **Delete** | **None** | — | Soft-deactivate via `PATCH { "is_active": false }` |

There is **no** `DELETE /exercises/{id}` and no `exercises.delete` slug.

---

## 2. End-to-end stack

```
Flutter UI
  ExerciseLibraryScreen / ExerciseDetailScreen / ExerciseFormScreen
    ↓ Bloc / Cubit
  Use cases (get/create/update/deactivate)
    ↓
  ExerciseRepositoryImpl → ExerciseRemoteDataSource → WORKApi (generated)
    ↓ HTTP /v1/exercises*
Nest ExerciseController → ExerciseService → ExerciseRepository → MariaDB `exercises`
```

**Contract source of truth:** `docs/openapi/v1.yaml` (`listExercises`, `createExercise`, `getExercise`, `updateExercise`). Client: `packages/api_client`.

---

## 3. Backend (Nest)

### Layout

| Piece | Path |
| :--- | :--- |
| Controller | `apps/api/src/work/exercise.controller.ts` |
| Service | `apps/api/src/work/exercise.service.ts` |
| Repository | `apps/api/src/work/exercise.repository.ts` |
| Zod DTOs | `apps/api/src/work/exercise.dto.ts` |
| Schema | `apps/api/src/platform/db/schema/exercises.ts` |
| Module | `apps/api/src/work/work.module.ts` (also hosts later workout plan/session) |
| Outbound shape fix | `normalize-secondary-muscles.ts` (MariaDB JSON → `string[] \| null`) |

### Table (`exercises`)

`id`, `name`, `primary_muscle_group`, `secondary_muscles` (JSON array), `equipment_needed` (**single string**), `instructions`, `video_url`, `gif_url`, `difficulty_level`, `is_active` (default true), `created_at`, `updated_at`. Indexes on `(is_active, primary_muscle_group)` and `name`.

### Service behavior

- **List:** `PaginationHelper` + filter schema. Callers **without** `exercises.update` get `activeOnly: true`. Holders of `exercises.update` see inactive too (`SEE_INACTIVE_PERMISSION`).
- **Get:** Load by id → `requireVisibleCatalogueRow` (inactive → 404 unless unrestricted).
- **Create:** Insert (defaults `is_active: true`) → reload → `present()` → audit.
- **Update:** Partial field patch only; omitted fields untouched. Deactivation is just `is_active: false`. Always audits before/after.

### Validation (Zod)

- Write: `name` required; optional muscle/equipment/instructions/urls/difficulty/`is_active`; URLs must be valid URL strings when present.
- Update: same schema `.partial()`.
- Filter query: optional `q` + three facet strings (not strict — pagination keys stripped safely).

---

## 4. Permissions (seeded)

| Slug | Admin | Trainer | Member |
| :--- | :---: | :---: | :---: |
| `exercises.read` | ✓ | ✓ | ✓ |
| `exercises.create` | ✓ | ✓ | — |
| `exercises.update` | ✓ | — | — |

Implications:

- Members: browse/detail only.
- Trainers: can **create** (seed grants create) but **cannot** edit/deactivate (no update).
- Admins: full catalogue mutate + see inactive.

Flutter mirrors this: library `+` → `exercises.create`; detail edit / form deactivate → `exercises.update`.

---

## 5. Flutter (Clean Architecture)

### Domain

- Entity: `Exercise` (`app/lib/features/exercises/domain/entities/exercise.dart`)
- Filter: `ExerciseFilter` (search + facets)
- Repo contract: `getExercises`, `getExercise`, `create`, `update`, `deactivate`
- Use cases: one file each for those five operations

### Data

- `ExerciseRemoteDataSource` → `WORKApi.listExercises` / `getExercise` / `createExercise` / `updateExercise`
- List cursor is **offset-as-string** (`int.tryParse(cursor)`)
- **Deactivate** = get exercise → `copyWith(isActive: false)` → `updateExercise` (no dedicated API)

### Presentation

| Screen | Role | Behavior |
| :--- | :--- | :--- |
| `ExerciseLibraryScreen` | All with read | Search, filter sheet, infinite scroll via `ExerciseListBloc`; master–detail ≥840dp |
| App-bar `+` | `exercises.create` | Pushes `ExerciseFormScreen` (create); on `true` → `ExerciseListRefreshed` |
| `ExerciseDetailScreen` | All with read | `ExerciseDetailCubit.loadExercise`; edit if `exercises.update` |
| `ExerciseFormScreen` | create/update | Create vs edit by optional `exercise`; gate slug create vs update; deactivate confirm in edit |

**Routes**

- Admin: `/admin/workout-library` (More → Workout Library)
- Trainer: `/trainer/plans/exercises` (+ `/:id`)
- Member: exercise detail from workout context (`/home/workout/exercises/:id`); no library tab

### Mapper quirks (documented in `exercise_model.dart`)

| Field | OpenAPI / Nest | Flutter domain | Mapping |
| :--- | :--- | :--- | :--- |
| `id` | `int` | `String` | `toString` / `int.parse` |
| Nullable strings / lists | nullable | non-null (`''` / `[]`) | null → empty on read |
| `equipment_needed` | single `string?` | `List<String>` | API string → one-element list; write-back first element |

These are intentional compatibility shims, not silent inventions.

---

## 6. Read / Create / Update / Delete flows (UI → API)

### Read

1. Library start → `GetExercisesUseCase` → `GET /exercises?...`
2. Detail → `GetExerciseUseCase` → `GET /exercises/{id}`
3. Inactive: members/trainers get 404; admins with update can list/get them

### Create

1. `+` → form → `CreateExerciseUseCase` → `POST /exercises` (`ExerciseWrite`)
2. Pop `true` → parent refreshes list

### Update

1. Detail edit → form prefilled → `UpdateExerciseUseCase` → `PATCH /exercises/{id}`
2. Detail + list refresh when under library shell

### Delete (deactivate)

1. Edit form → confirm → `DeactivateExerciseUseCase`
2. Client: GET + PATCH full write with `is_active: false`
3. Server: accepts partial `{ is_active: false }` as well

---

## 7. Tests / verification already in tree

**API:** `exercise.controller.spec.ts`, `exercise.service.spec.ts`, `normalize-secondary-muscles.spec.ts`; e2e covered under V1-10.

**Flutter:** repository/model/usecase/entity tests; `exercise_list_bloc_test`, `exercise_detail_cubit_test`, `exercise_role_variants_test`, filter/list-item/media widget tests.

---

## 8. Boundaries (do not confuse with V1)

- **In V1:** catalogue exercises only.
- **Same Nest module, later work:** `WorkoutPlan*` / `WorkoutSession*` (not ADR-0007 Vertical 1).
- **Media:** external HTTPS `video_url` / `gif_url` strings only — no MEDIA signed upload in V1.
- **Foods (V2):** parallel catalogue pattern (`diet.*`, soft-deactivate, no DELETE).

---

## 9. Takeaways

1. Vertical 1 is a **complete soft-CRUD catalogue**: C/R/U + deactivate; hard delete deliberately absent.
2. Pattern to copy: Controller → Service (audit + visibility) → Repository → Zod DTOs → OpenAPI-aligned wire; Flutter Clean Architecture with capability-gated UI.
3. Visibility policy is shared catalogue helper: inactive hidden unless actor has update.
4. Flutter ↔ API shape drift on `equipment_needed` and nullability is contained in one mapper file.
5. Trainer seed can **create** but not **update** — UI correctly hides edit/deactivate without `exercises.update`.

No implementation work proposed from this analysis. Next optional deep-dives: compare V1 vs Foods V2 side-by-side, or audit live API responses against the Flutter mapper.
