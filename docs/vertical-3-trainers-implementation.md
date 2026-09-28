# Vertical 3 — Trainers: implementation picture

> **Baseline comparison** against Vertical 1 (`docs/vertical-1-exercise-library-implementation.md`). Section order and delta axes follow `.agents/skills/compare-vertical/references/section-checklist.md`.

Analysis only (no code changes). Scope is **Trainers** (FR-PEOPLE-003 / FR-PEOPLE-007 / FR-PEOPLE-010), per ADR-0007 and `archive/todo/vertical-3/README.md`. Sibling features in the same Nest `PeopleModule` (Members, Employees, Emergency Contacts, Media MVP, Health Onboarding) and related modules (Scheduling availability, Workout/Diet plans) are **out of this specific vertical slice**.

**Status:** Backend tickets V3-01…V3-16 all completed in `archive/todo/vertical-3/` (specifically V3-06 for Trainers API). Flutter feature under `app/lib/features/people/` is implemented and wired across admin, trainer, and member roles.
**UI Design Specs:** [Trainer App Screens Specification](file:///Users/admin/code/gym/docs/screens/trainer-app-screens.md) and [People & Profile Status](file:///Users/admin/code/gym/docs/flutter/03-people-profile.md).

---

## 1. What “CRUD” means here

| Operation | HTTP | Permission | Notes |
| :--- | :--- | :--- | :--- |
| **Read list** | `GET /v1/trainers` | `trainers.read` | Directory list; query filter `q` (name search); offset pagination (`limit`, `offset`); computes `assigned_active_count`; strips `hourly_rate` for `member` role |
| **Read one** | `GET /v1/trainers/{id}` | `trainers.read` | Returns `TrainerResponse`; strips `hourly_rate` for `member` actors (FR-PEOPLE-010); row-scoped for `trainer` actor (self only unless staff); computes `assigned_active_count` |
| **Create** | `POST /v1/trainers` | `trainers.create` | 201 Created; atomic 1-TX creation of `users` (`user_type: trainer`) + `trainers` profile via `PersonFactory`; audit `trainer.created` |
| **Update** | `PATCH /v1/trainers/{id}` | `trainers.update` | Partial patch of profile fields (`first_name`, `last_name`, `bio`, `specializations`, `hourly_rate`, `max_clients_capacity`, `is_active`) and optional credentials patch (`phone_number`); row-scoped for `trainer`; audit `trainer.updated` |
| **Delete** | **None** | — | Soft-deactivate via `PATCH /v1/trainers/{id}` with `{ "is_active": false }`. No hard DELETE and no `trainers.delete` slug |
| **Roster** | `GET /v1/trainers/{id}/members` | `members.read` | Members assigned to trainer (`assigned_trainer_id = id`); row-scoped (trainers see own roster only; members receive 404) |

There is **no** `DELETE /trainers/{id}` endpoint and no `trainers.delete` permission slug. Soft-deactivating a trainer (`is_active = false`) gates new client assignments but does **not** revoke login capabilities (`users.status` manages authentication status).

---

## 2. End-to-end stack

```
Flutter UI
  TrainersDirectoryScreen / AddTrainerScreen / EditTrainerProfileScreen / MyTrainerProfileScreen
    ↓ Cubit (TrainersDirectoryCubit, TrainerFormCubit, EditTrainerProfileCubit, MyTrainerProfileCubit)
  Use cases (ListTrainers, GetTrainer, CreateTrainer, UpdateTrainer, GetAssignedTrainer)
    ↓
  PeopleRepositoryImpl → PeopleRemoteDataSourceImpl → PEOPLEApi (generated)
    ↓ HTTP /v1/trainers*
Nest TrainerController → TrainerService → TrainerRepository + PersonFactory → MariaDB `trainers` + `users`
```

**Contract source of truth:** `docs/openapi/v1.yaml` (`listTrainers`, `createTrainer`, `getTrainer`, `updateTrainer`, `listTrainerMembers`). Client: `packages/api_client`.

---

## 3. Backend (Nest)

### Layout

| Piece | Path |
| :--- | :--- |
| Controller | `apps/api/src/people/trainer.controller.ts` |
| Service | `apps/api/src/people/trainer.service.ts` |
| Repository | `apps/api/src/people/trainer.repository.ts` |
| Zod DTOs | `apps/api/src/people/trainer.dto.ts` |
| Schema | `apps/api/src/platform/db/schema/trainers.ts` |
| Module | `apps/api/src/people/people.module.ts` |
| Outbound shape fix | `apps/api/src/people/normalize-specializations.ts` (MariaDB JSON/TEXT → `string[] \| null`) |
| Person Factory | `apps/api/src/people/person.factory.ts` (1-TX user + profile creation & credential updates) |
| Row Scope Guard | `apps/api/src/people/row-scope.ts` (`assertPeopleRowScope`) |

### Table (`trainers`)

- `id`: bigint autoincrement PK
- `user_id`: bigint FK referencing `users.id` (unique index `trainers_user_id_unique`)
- `first_name`: varchar(100) not null
- `last_name`: varchar(100) not null
- `bio`: text nullable
- `specializations`: json array of strings (normalized on outbound read)
- `hourly_rate`: decimal(12,2) nullable Money string
- `rating`: double nullable
- `max_clients_capacity`: bigint nullable
- `is_active`: boolean not null (default true)
- `created_at`: utcDatetime not null
- `updated_at`: utcDatetime nullable

### Service behavior

- **List:** Parses `trainerFilterQuerySchema` and pagination params (`limit`, `offset`). Filters by `q` across `first_name` and `last_name`. Calculates `assigned_active_count` dynamically per trainer via `memberRepository.countAssignedMembersForIds`. If actor is a member, `hourly_rate` is coerced to `null`.
- **Get:** Loads record by id → 404 if missing. Enforces row scoping: `trainer` actor can only fetch their own profile; `member` actor can view directory details but `hourly_rate` is stripped; staff have full visibility. Dynamically attaches `assigned_active_count`.
- **Create:** Uses `PersonFactory.createPerson` to atomically create a `users` record (`user_type: trainer`, email, phone, password) and `trainers` profile (`is_active: true`) inside a single database transaction. Emits `trainer.created` audit log.
- **Update:** Loads existing profile (404 if missing) and validates row-scope. Runs transaction: patches profile columns and updates `users.phone_number` if changed. Emits `trainer.updated` audit log with before/after state diff.
- **ListMembers:** Gated by `members.read`. Scopes queries so trainers can only view members where `assigned_trainer_id = trainer.id`, members get 404, and staff/admins can list any trainer's roster.

### Validation (Zod)

- **Create (`trainerCreateSchema`):** `email` (email format, max 255), `phone_number` (optional nullable string 1..32), `password` (required string 1..255), `first_name` (1..100), `last_name` (1..100), `bio` (optional nullable <=5000), `specializations` (optional nullable array of non-empty strings), `hourly_rate` (optional nullable regex `/^-?\d+\.\d{2}$/`), `max_clients_capacity` (optional nullable positive integer).
- **Update (`trainerUpdateSchema`):** `.strict()` object with optional `phone_number`, `first_name`, `last_name`, `bio`, `specializations`, `hourly_rate`, `max_clients_capacity`, `is_active`.
- **Filter query (`trainerFilterQuerySchema`):** Optional `q` string.

---

## 4. Permissions (seeded)

| Slug | Admin | Trainer | Employee | Member |
| :--- | :---: | :---: | :---: | :---: |
| `trainers.read` | ✓ | ✓ | ✓ | ✓ |
| `trainers.create` | ✓ | — | — | — |
| `trainers.update` | ✓ | — | — | — |
| `trainers.write` *(legacy alias)* | ✓ | — | — | — |
| `members.read` *(for roster)* | ✓ | ✓ | ✓ | ✓ |

### Implications

- **Members:** Can browse trainers directory and view assigned trainer details via `trainers.read`, but `hourly_rate` is hidden. Cannot list rosters or mutate trainers.
- **Trainers:** Can browse directory with `trainers.read` and inspect own assigned member roster via `members.read`. In the seeded permissions, trainers do not hold `trainers.create` or `trainers.update`.
- **Admins:** Full management: create trainers, update profile, toggle `is_active`, and view all rosters.
- **Self-Edit Nuance:** Flutter's `EditTrainerProfileScreen` allows non-admin self-edit mode (hiding `max_clients_capacity` and `is_active`), but backend route `PATCH /trainers/:id` requires `trainers.update`. Self-updates must either be performed via the auth `/me` profile flow or require the `trainers.update` capability.

---

## 5. Flutter (Clean Architecture)

### Domain

- **Entities:**
  - `TrainerProfile` (`app/lib/features/people/domain/entities/trainer_profile.dart`): full profile model including `phoneNumber`.
  - `TrainerSummary` (`app/lib/features/people/domain/entities/trainer_summary.dart`): directory summary model with `assignedActiveCount`.
  - `NewTrainerInput` (`app/lib/features/people/domain/entities/new_trainer_input.dart`): input entity for trainer registration.
- **Repo contract:** `PeopleRepository` (`listTrainers`, `getTrainer`, `createTrainer`, `updateTrainer`, `assignTrainer`).
- **Use cases:** `ListTrainersUseCase`, `GetTrainerUseCase`, `CreateTrainerUseCase`, `UpdateTrainerUseCase`, `GetAssignedTrainerUseCase`.

### Data

- `PeopleRemoteDataSourceImpl` → generated `PEOPLEApi.listTrainers`, `getTrainer`, `createTrainer`, `updateTrainer`.
- List cursor is **offset-as-string** (`int.tryParse(cursor)` / next offset arithmetic).
- `PeopleRepositoryImpl` maps API models to domain entities in `people_mapper.dart`.

### Presentation

| Screen | Role | Behavior |
| :--- | :--- | :--- |
| `TrainersDirectoryScreen` | Admin / Staff (`trainers.read`) | Search filter field, infinite scroll list, FAB gated on `trainers.create` |
| `AddTrainerScreen` | Admin (`trainers.create`) | Multi-field creation form (credentials + bio + specializations + rate + capacity). On success, pops new ID to open edit screen |
| `EditTrainerProfileScreen` | Admin (`trainers.update`) / Trainer | Prefilled profile edit form. Hides `maxClientsCapacity` and `isActive` toggle unless `isAdmin` is true |
| `MyTrainerProfileScreen` | Member (`trainers.read`) | Profile view of assigned trainer (avatar, rating, specializations, rate if visible, "Book Session" CTA) |

**Routes**

- Admin: `/admin/trainers` (`Routes.adminTrainers`), `/admin/trainers/create` (`Routes.adminTrainersCreate`), `/admin/trainers/:id/edit` (`Routes.adminTrainersEdit`)
- Trainer: `/trainer/profile/edit` (`Routes.trainerProfileEdit`)
- Member: `/home/profile/trainer` (`Routes.memberProfileTrainer`)

### Mapper quirks (documented in `people_mapper.dart`)

| Field | OpenAPI / Nest | Flutter domain | Mapping |
| :--- | :--- | :--- | :--- |
| `id` / `user_id` | `int` | `int` | Direct integer mapping (no string conversion) |
| `specializations` | `string[] \| null` | `List<String>` | `?.toList() ?? const []` |
| `hourly_rate` | `string?` (Money) | `String?` | String passed through |
| `rating` | `number?` | `double?` | `?.toDouble()` |
| `phone_number` | Handled via `users` | Merged into `TrainerProfile` | Merged from user credentials during mapper/update |

---

## 6. Read / Create / Update / Delete flows (UI → API)

### Read
1. **Directory:** Admin navigates to `/admin/trainers` → `TrainersDirectoryCubit.load()` → `ListTrainersUseCase` → `GET /v1/trainers?limit=...&offset=...&q=...`.
2. **Member View:** Member opens `/home/profile/trainer` → `MyTrainerProfileCubit.load(memberId)` → `GetAssignedTrainerUseCase` (fetches member dossier then `GET /v1/trainers/{id}`). Backend strips `hourly_rate`.

### Create
1. Admin taps FAB on directory screen → navigates to `AddTrainerScreen`.
2. Admin fills credentials, profile details, and specializations chips → taps Submit → `TrainerFormCubit.submit()` → `CreateTrainerUseCase` → `POST /v1/trainers`.
3. Backend `PersonFactory` creates `users` entry and `trainers` entry in a single transaction, then records audit `trainer.created`.
4. Screen pops returning created `id` → Directory reloads and navigates to `EditTrainerProfileScreen`.

### Update
1. Admin or Trainer opens `EditTrainerProfileScreen` → `EditTrainerProfileCubit.load(id)` → `GET /v1/trainers/{id}`.
2. User edits fields and taps Save → `EditTrainerProfileCubit.save()` → `UpdateTrainerUseCase` → `PATCH /v1/trainers/{id}`.
3. Backend updates `trainers` table (+ `users.phone_number` if altered), records audit `trainer.updated`, and returns refreshed profile.

### Delete (Deactivate)
1. In `EditTrainerProfileScreen`, Admin toggles `Active` switch off (`isActive = false`) and saves.
2. Flutter sends `PATCH /v1/trainers/{id}` with `is_active: false`.
3. Server updates `is_active: false`. The trainer is marked inactive (blocking new client assignments), but their auth credentials remain valid unless suspended via auth/employee controls.

---

## 7. Tests / verification already in tree

- **API Unit / Spec:**
  - `apps/api/src/people/trainer.service.spec.ts` (outbound shaping, rate hiding for members, specializations normalization).
- **API E2E:**
  - `apps/api/test/people-onboarding.e2e.spec.ts` (multi-role onboarding & permissions).
- **Flutter Unit & Cubit Tests:**
  - `app/test/features/people/presentation/trainer_form_cubit_test.dart` (form validation, submission, chip management).
  - `app/test/features/people/data/repositories/people_repository_impl_test.dart` (data source unwrapping, entity mapping).
  - `app/test/features/people/domain/usecases/people_usecases_test.dart` (use case delegation).
- **Flutter Widget & UI Tests:**
  - `app/test/features/people/presentation/add_trainer_screen_test.dart` (form rendering, validation snackbar, FAB permission gate).
  - `app/test/features/people/presentation/edit_trainer_profile_screen_test.dart` (admin vs non-admin field visibility, capability checks, save interaction).
- **API Client Package Tests:**
  - `packages/api_client/test/trainer_test.dart`, `trainer_create_test.dart`, `trainer_update_test.dart`, `trainer_page_test.dart`.

---

## 8. Boundaries (do not confuse with V3 Trainers)

- **In V3 Trainers:** Trainer profiles, directory listing, 1-TX creation (user + profile), profile updates, soft-deactivation (`is_active`), assigned active client counts, member-facing assigned trainer view, and assigned members roster (`GET /trainers/{id}/members`).
- **Same module (PEOPLE), sibling verticals:**
  - Members: `members` CRUD, dossier, KYC documents, medical history, onboarding flow (`archive/todo/vertical-3/V3-05*`).
  - Employees: Staff directory, department, job title, role assignments, suspension/termination via `users.status` (`archive/todo/vertical-3/V3-07`).
  - Emergency Contacts: Emergency contacts table and endpoints (`archive/todo/vertical-3/V3-08`).
  - Media MVP: Signed PUT/GET storage for avatars, id proofs, waivers, and medical certs (`archive/todo/vertical-3/V3-11`).
- **Other modules (distinct vertical slices):**
  - Scheduling: Trainer availability management (`TrainerAvailabilityController`), PT booking, slot scheduling (`apps/api/src/sched/`).
  - Workout & Diet Plans: Workout plan builder, diet plan versions (`apps/api/src/work/`, `apps/api/src/diet/`).

---

## 9. Takeaways & Delta Scoring

1. **Atomic User + Profile Construction:** Unlike standalone catalogue items in V1, Trainers require a combined transaction creating both `users` and `trainers` records via `PersonFactory`.
2. **Dual-Layer Visibility & Data Masking:** Rate transparency is restricted (`hourly_rate` hidden from members) and row-scoping prevents trainers from accessing unassigned peer data.
3. **Capacity & Assignment Gate:** `is_active` acts strictly as an assignment gate; login auth is decouple from trainer active status.
4. **Calculated Roster Metrics:** `assigned_active_count` is dynamically calculated per trainer on directory and detail reads rather than storing denormalized state.
5. **No Dedicated Delete Use Case:** Soft deactivation is handled uniformly through the update flow (`isActive = false` in `TrainerUpdate`).

### vs Vertical 1 (Scoring Table)

| Axis | V1 baseline | V3 Trainers | Score | Evidence |
| :--- | :--- | :--- | :---: | :--- |
| **HTTP surface** | `GET/POST /v1/exercises`, `GET/PATCH /v1/exercises/{id}`; no DELETE | `GET/POST /v1/trainers`, `GET/PATCH /v1/trainers/{id}`, `GET /v1/trainers/{id}/members`; no DELETE | **partial** | `apps/api/src/people/trainer.controller.ts` |
| **Soft-deactivate** | `PATCH { is_active: false }`; no `exercises.delete` | `PATCH { is_active: false }`; no `trainers.delete` (gates assignment, auth untouched) | **match** | `apps/api/src/people/trainer.dto.ts` |
| **Visibility** | Inactive hidden unless actor has `exercises.update` | Inactive visible with badge in directory; `hourly_rate` masked for members; row-scoped for trainers | **different** | `apps/api/src/people/trainer.service.ts` |
| **Permissions** | `exercises.read` all; `exercises.create` admin+trainer; `exercises.update` admin only | `trainers.read` all; `trainers.create` admin only; `trainers.update` admin only | **different** | `apps/api/src/platform/db/seed/roles.ts` |
| **Nest layout** | controller / service / repository / dto / schema / module | controller / service / repository / dto / schema / module + `PersonFactory` + `row-scope` helper | **match** | `apps/api/src/people/` |
| **Audit** | `exercise.created` / `exercise.updated` | `trainer.created` / `trainer.updated` | **match** | `apps/api/src/people/trainer.service.ts` |
| **Flutter layers** | domain → data → presentation; five use cases including deactivate | domain → data → presentation; five use cases (deactivate folded into update; added assigned trainer use case) | **partial** | `app/lib/features/people/domain/usecases/` |
| **Deactivate client** | GET then PATCH (server also accepts partial `{ is_active: false }`) | `EditTrainerProfileScreen` toggles `_isActive` and calls `UpdateTrainerUseCase` | **match** | `app/lib/features/people/presentation/screens/edit_trainer_profile_screen.dart` |
| **Pagination** | Offset; Flutter cursor is offset-as-string | Offset; Flutter cursor is offset-as-string | **match** | `app/lib/features/people/data/repositories/people_repository_impl.dart` |
| **Mapper shims** | `id` int↔String; null→empty; `equipment_needed` string↔`List<String>` | `id` int↔int; `specializations` JSON↔`List<String>`; `hourly_rate` Money string | **partial** | `app/lib/features/people/data/models/people_mapper.dart` |
| **Media** | External `video_url` / `gif_url` only | Dedicated MEDIA MVP signed object storage (`/media/*`), no URL columns on `trainers` | **different** | `apps/api/src/platform/db/schema/trainers.ts` |
| **Contract** | `docs/openapi/v1.yaml` + `packages/api_client` | `docs/openapi/v1.yaml` + `packages/api_client` | **match** | `docs/openapi/v1.yaml` |
