# Vertical 3 — Members: implementation picture

> **Baseline comparison** against Vertical 1 (`docs/vertical-1-exercise-library-implementation.md`). Section order and delta axes follow `.agents/skills/compare-vertical/references/section-checklist.md`.

Analysis only (no code changes). Scope is **Members** (FR-PEOPLE-001 / FR-PEOPLE-002 / FR-PEOPLE-004 / FR-PEOPLE-005 / FR-PEOPLE-006 / FR-PEOPLE-008 / FR-PEOPLE-013, FR-AUTH-008 / FR-AUTH-009, BR-PEOPLE-001 / BR-PEOPLE-002 / BR-PEOPLE-003), per ADR-0007 and `archive/todo/vertical-3/README.md`. Sibling features in the same Nest `PeopleModule` (Trainers, Employees, Emergency Contacts, Media MVP, Health Onboarding, Documents, Photos, Medical Histories) and external modules (Memberships, Billing & Payments, Attendance, Scheduling, Workout & Diet plans) are **out of this specific vertical slice**.

**Status:** Backend tickets V3-01…V3-16 all completed in `archive/todo/vertical-3/` (specifically V3-05a/b/c for Members API). Flutter feature under `app/lib/features/people/` is implemented and wired across admin, trainer, and member roles.
**UI Design Specs:** [Admin App Screens — Members](file:///Users/admin/code/gym/docs/screens/admin-app-screens.md) §3; [Trainer App Screens](file:///Users/admin/code/gym/docs/screens/trainer-app-screens.md); [People & Profile Status](file:///Users/admin/code/gym/docs/flutter/03-people-profile.md).

---

## 1. What “CRUD” means here

| Operation | HTTP | Permission | Notes |
| :--- | :--- | :--- | :--- |
| **Read list** | `GET /v1/members` | `members.read` | Directory list; query filters `q` (name, membership number, email, phone search), `status`, `membership_status` (tolerated for future MEMB), `assigned_trainer_id`; offset/cursor pagination (`limit`, `offset`/`cursor`); row-scoped by actor (`all` for staff; `trainer` filtered to assigned clients; `self` filtered to own user id) |
| **Read one** | `GET /v1/members/{id}` | `members.read` | Returns `MemberDossierResponseDto`; row-scoped (trainers see assigned only, members see self only; unassigned throws 404); returns `null` stubs for `membership`, `outstanding_balance`, `last_check_in`, `next_schedule` |
| **Create** | `POST /v1/members` | `members.create` | 201 Created; atomic 1-TX creation of `users` (`user_type: member`, email/phone, password) + `members` profile via `PersonFactory`; auto-allocates `membership_number` (`M` + 8 digits zero-padded via `membership_number_counters`); audit `member.created` |
| **Update** | `PATCH /v1/members/{id}` | `members.update` | Partial patch of profile fields (`first_name`, `last_name`, `gender`, `date_of_birth`, `address`, `assigned_trainer_id`, `notes`) and credentials (`email`, `phone_number`); rejects `membership_number` modification (immutable); row-scoped; audit `member.updated` |
| **Assign Trainer** | `POST /v1/members/{id}/assign-trainer` | `members.update` | Dedicated assignment endpoint (`trainer_id`, `override_capacity`, `reason`); checks trainer active status and max capacity; requires `override_capacity=true` and `reason` when at capacity (staff only); emits audit `member.trainer_assigned` and domain event `member.trainer_assigned` |
| **Delete** | **None** | — | No `DELETE /members/{id}` endpoint and no `members.delete` permission slug. Account offboarding is handled via auth / user lifecycle (`users.status`), not via member catalogue deletion |

There is **no** hard DELETE endpoint and no `members.delete` permission slug. Member lifecycle offboarding/deactivation is decoupled into auth/user status management (`users.status`) and sibling membership cancellation workflows.

---

## 2. End-to-end stack

```
Flutter UI
  MembersDirectoryScreen / AddMemberWizardScreen / MemberDossierScreen / EditMemberScreen
    ↓ Cubit / Bloc (MembersDirectoryBloc, AddMemberWizardCubit, MemberDossierCubit, EditMemberCubit)
  Use cases (ListMembers, GetMember, CreateMember, UpdateMember, AssignTrainer)
    ↓
  PeopleRepositoryImpl → PeopleRemoteDataSourceImpl → PEOPLEApi (generated)
    ↓ HTTP /v1/members*
Nest MemberController → MemberService → MemberRepository + PersonFactory + AuditService + DomainEventBus
    ↓ SQL (Drizzle ORM)
MariaDB `members`, `users`, `membership_number_counters`, `trainers`
```

**Contract source of truth:** `docs/openapi/v1.yaml` (`listMembers`, `createMember`, `getMember`, `updateMember`, `assignTrainer`). Client: `packages/api_client`.

---

## 3. Backend (Nest)

### Layout

| Piece | Path |
| :--- | :--- |
| Controller | `apps/api/src/people/member.controller.ts` |
| Service | `apps/api/src/people/member.service.ts` |
| Repository | `apps/api/src/people/member.repository.ts` |
| Zod DTOs | `apps/api/src/people/member.dto.ts` |
| Schemas | `apps/api/src/platform/db/schema/members.ts` (`members`, `membershipNumberCounters`) |
| Module | `apps/api/src/people/people.module.ts` |
| Person Factory | `apps/api/src/people/person.factory.ts` (1-TX user + member creation & counter allocation) |
| Row Scope Guard | `apps/api/src/people/row-scope.ts` (`assertPeopleRowScope`), `require-scoped-member.ts` |

### Tables (`members` & `membership_number_counters`)

- `members`:
  - `id`: bigint autoincrement PK
  - `user_id`: bigint FK referencing `users.id` (unique index `members_user_id_unique`)
  - `membership_number`: varchar(16) not null (unique index `members_membership_number_unique`), immutable sequence formatted as `M` + 8 digits
  - `first_name`: varchar(100) not null
  - `last_name`: varchar(100) not null
  - `gender`: varchar(32) nullable
  - `date_of_birth`: date string nullable
  - `address`: text nullable
  - `assigned_trainer_id`: bigint FK referencing `trainers.id` nullable (index `members_assigned_trainer_id_idx`)
  - `joined_date`: date string not null
  - `notes`: text nullable
  - `created_at`: utcDatetime not null
  - `updated_at`: utcDatetime nullable
- `membership_number_counters`:
  - `id`: bigint PK
  - `next_value`: bigint not null

### Service behavior

- **List:** Parses `memberFilterQuerySchema` and pagination params (`limit`, `offset`/`cursor`). Joins with `users` to search `q` across names, membership number, email, and phone. Applies role scope: `all` for staff (admin/employee); `trainer` restricted to `assigned_trainer_id = actor.profileId`; `self` restricted to `user_id = actor.id`.
- **Get:** Loads member by id → 404 if missing. Enforces `assertPeopleRowScope`: trainers only access assigned members, members only access self, staff bypass. Wraps member entity into `MemberDossier` with `null` stubs for `membership`, `outstanding_balance`, `last_check_in`, and `next_schedule`.
- **Create:** Invokes `PersonFactory.createPerson` to atomically:
  1. Create `users` row (`user_type: member`, email/phone, hashed password).
  2. Lock `membership_number_counters` with `SELECT … FOR UPDATE`, fetch sequence, increment counter, and format string (`M00000001`).
  3. Insert `members` profile row with `joined_date` (defaulting to current UTC date).
  4. Records `member.created` audit log.
- **Update:** Loads existing member (404 if missing) and enforces row-scope. Strictly rejects attempts to update `membership_number`. In a single transaction, updates `members` profile columns and updates `users` credentials (`email`, `phone_number`) if altered. Emits `member.updated` audit log with before/after state diff.
- **Assign Trainer:** Validates target trainer existence and checks `is_active = true` (422 if inactive). Validates trainer client capacity (`max_clients_capacity`): if at capacity, requires `override_capacity: true` and non-empty `reason` from admin/employee actors. Updates `assigned_trainer_id`, records `member.trainer_assigned` audit log, and dispatches `member.trainer_assigned` domain event.

### Validation (Zod)

- **Create (`memberCreateSchema`):** `first_name` (1..100), `last_name` (1..100), `password` (1..255), optional `email` (valid email format), optional `phone_number` (1..32), optional `gender` (<=32), optional `date_of_birth`, optional `address` (<=2000), optional `assigned_trainer_id` (positive int), optional `notes` (<=5000). `.superRefine` enforces at least one of `email` or `phone_number`.
- **Update (`memberUpdateSchema`):** `.strict()` object with optional `email`, `phone_number`, `first_name`, `last_name`, `gender`, `date_of_birth`, `address`, `assigned_trainer_id`, `notes`.
- **Assign Trainer (`assignTrainerSchema`):** `trainer_id` (positive int), optional `override_capacity` (boolean, default false), optional `reason` (string <=2000).
- **Filter query (`memberFilterQuerySchema`):** Optional `q`, optional `status` (`active` \| `inactive` \| `suspended`), optional `membership_status`, optional `assigned_trainer_id`.

---

## 4. Permissions (seeded)

| Slug | Admin | Trainer | Employee | Member |
| :--- | :---: | :---: | :---: | :---: |
| `members.read` | ✓ | ✓ | ✓ | ✓ |
| `members.create` | ✓ | — | ✓ | — |
| `members.update` | ✓ | — | ✓ | — |
| `members.write` *(legacy alias)* | ✓ | — | ✓ | — |

Super Admin holds `permissionSlugs: 'all'`.

### Implications

- **Admin & Employee (Staff):** Full management capabilities: list directory across all gym members, onboard new members (`members.create`), edit member profiles (`members.update`), and assign/reassign trainers with capacity override authority.
- **Trainers:** Hold `members.read` but row-scoping enforces that directory queries and detail gets return **only assigned clients** (`assigned_trainer_id = trainer.profileId`). Direct queries for unassigned members fail-closed with 404 (BR-PEOPLE-002). Trainers cannot create or update member profiles directly.
- **Members:** Hold `members.read` but row-scoping restricts visibility strictly to their own profile (`user_id = member.id`). Unpermitted access to peer members returns 404 (BR-PEOPLE-003). Members cannot create/update members via `/v1/members`. Self-updates are handled via `/me` profile flows.

---

## 5. Flutter (Clean Architecture)

### Domain

- **Entities:**
  - `Person` (`app/lib/features/people/domain/entities/person.dart`): comprehensive member entity containing personal profile, credentials, and dossier stub fields.
  - `ProfileSummary` (`app/lib/features/people/domain/entities/profile_summary.dart`): directory summary model (`id`, `membershipNumber`, `fullName`, `assignedTrainerId`).
  - `NewMemberInput` (`app/lib/features/people/domain/entities/new_member_input.dart`): member onboarding input model including credentials and initial profile.
  - `MemberFilter` (`app/lib/features/people/domain/entities/member_filter.dart`): filter criteria entity (`query`, `assignedTrainerId`).
- **Repo contract:** `PeopleRepository` (`listMembers`, `getMember`, `createMember`, `updateMember`, `assignTrainer`).
- **Use cases:** `ListMembersUseCase`, `GetMemberUseCase`, `CreateMemberUseCase`, `UpdateMemberUseCase`, `AssignTrainerUseCase`.

### Data

- `PeopleRemoteDataSourceImpl` → generated `PEOPLEApi.listMembers`, `getMember`, `createMember`, `updateMember`, `assignTrainer`.
- List cursor uses **offset-as-string** pagination (`int.tryParse(cursor)`).
- `PeopleRepositoryImpl` converts between generated API models and domain entities in `people_mapper.dart`.

### Presentation

| Screen | Role | Behavior |
| :--- | :--- | :--- |
| `MembersDirectoryScreen` | Admin / Employee / Trainer (`members.read`) | Search bar, infinite scrolling list with `MembersDirectoryBloc`. FAB gated on `members.create` (navigates to add wizard). Renders member cards with name and membership number |
| `AddMemberWizardScreen` | Admin / Employee (`members.create`) | 3-step onboarding wizard (`AddMemberWizardCubit`): Step 1 (Basic info: names, gender), Step 2 (Contact & Account: email, phone, password, address), Step 3 (Review & Submit). On success, redirects to new member dossier |
| `MemberDossierScreen` | Admin / Employee / Trainer / Member | Comprehensive profile dossier view (`MemberDossierCubit`). Displays member info, dossier stubs, in-line quick-save, trainer assignment widget, membership assign action, and navigation hubs to sibling sub-screens |
| `EditMemberScreen` | Admin / Employee (`members.update`) | Dedicated single-purpose edit form (`EditMemberCubit`) with dirty field tracking for personal details, address, and notes |

**Routes**

- Admin: `/admin/members` (`Routes.adminMembers`), `/admin/members/add` (`Routes.adminMembersAdd`), `/admin/members/:id` (`Routes.adminMembersDetail`), `/admin/members/:id/edit` (`Routes.adminMembersEdit`), `/admin/members/:id/assign-membership`
- Trainer: `/trainer/members` (`Routes.trainerMembers`), `/trainer/members/:id` (`Routes.trainerMembersDetail`), `/trainer/members/:id/health`, `/trainer/members/:id/goals`
- Member: `/home/profile` (personal profile)

### Mapper quirks (documented in `people_mapper.dart`)

| Field | OpenAPI / Nest | Flutter domain | Mapping |
| :--- | :--- | :--- | :--- |
| `id` / `user_id` / `assigned_trainer_id` | `int` | `int` | Direct integer mapping (no string conversion) |
| `date_of_birth` / `joined_date` | `api.Date` (year, month, day) | `DateTime?` | Mapped via helper `_apiDateToDateTime` and `_dateTimeToApiDate` |
| `email` / `phone_number` | Nested on OpenAPI `user` / Flat in Nest | `Person.email` / `Person.phoneNumber` | Mapped from `dossier.user?.email` / `phoneNumber` |
| Dossier extras | `membership`, `outstanding_balance`, etc. | `Person` nullable stub fields | Extracted and mapped directly (`membershipStatus`, `outstandingBalance`, `lastCheckIn`, `nextScheduleTitle`) |

---

## 6. Read / Create / Update / Delete flows (UI → API)

### Read
1. **Directory:** Admin/Trainer navigates to `/admin/members` or `/trainer/members` → `MembersDirectoryBloc` receives `MembersDirectoryStarted` → `ListMembersUseCase` → `GET /v1/members?limit=...&offset=...&q=...`.
2. **Dossier:** Actor selects a member row → opens `/admin/members/:id` or `/trainer/members/:id` → `MemberDossierCubit.load(id)` → `GetMemberUseCase` → `GET /v1/members/{id}`.
3. Backend checks row-scope (trainers see assigned only, members see self only, staff see all; others get 404), attaches null dossier extras, and returns `MemberDossierResponseDto`.

### Create
1. Admin/Employee taps FAB on directory screen → navigates to `AddMemberWizardScreen`.
2. User fills 3-step wizard (Basic Info → Contact/Credentials → Review) and taps Create Member → `AddMemberWizardCubit.submit()` → `CreateMemberUseCase` → `POST /v1/members`.
3. Backend `PersonFactory` atomically creates `users` entry, increments `membership_number_counters` to allocate `membership_number` (`M00000001`), creates `members` entry, and writes `member.created` audit log.
4. Screen redirects immediately to `/admin/members/:id` (Member Dossier).

### Update
1. Admin opens `EditMemberScreen` (`/admin/members/:id/edit`) or modifies inline on `MemberDossierScreen`.
2. User edits fields and taps Save → `EditMemberCubit.save()` / `MemberDossierCubit.save()` → `UpdateMemberUseCase` → `PATCH /v1/members/{id}`.
3. Backend checks row-scope, updates `members` profile and `users` credentials (email/phone) in a single transaction, records `member.updated` audit log, and returns refreshed entity.

### Assign Trainer
1. On `MemberDossierScreen`, Admin enters Trainer ID and taps "Assign Trainer" → `MemberDossierCubit.assignTrainer()` → `AssignTrainerUseCase` → `POST /v1/members/:id/assign-trainer`.
2. Backend validates trainer active status and capacity limits (allowing admin override with reason).
3. Backend updates `members.assigned_trainer_id`, records `member.trainer_assigned` audit log, and emits domain event `member.trainer_assigned`.

### Delete (Offboarding)
1. There is no `DELETE /v1/members/:id` endpoint and no `members.delete` slug.
2. Member offboarding is handled at the identity tier via `users.status` or through membership cancellation flows in the `MEMB` vertical.

---

## 7. Tests / verification already in tree

- **API Unit / Spec:**
  - `apps/api/src/people/member.service.spec.ts` (assignTrainer active/capacity validation, override reason checks, immutable membership_number rejection).
  - `apps/api/src/people/person.factory.spec.ts` (1-TX user + member creation, sequential membership number generation, credential validation).
  - `apps/api/src/people/row-scope.spec.ts` (row-scoping validation for staff, trainers, and members; 404 mask enforcement).
  - `apps/api/src/people/member-health.service.spec.ts`, `member-document.service.spec.ts`, `member-photo.service.spec.ts`, `emergency-contact.service.spec.ts`, `medical-history.service.spec.ts`.
- **API E2E:**
  - `apps/api/test/people-onboarding.e2e.spec.ts` (end-to-end multi-role onboarding, trainer assignment, and permission gates).
- **Flutter Unit & Use Case Tests:**
  - `app/test/features/people/domain/usecases/people_usecases_test.dart` (`ListMembersUseCase`, `GetMemberUseCase`, `CreateMemberUseCase`, `UpdateMemberUseCase`, `AssignTrainerUseCase`).
  - `app/test/features/people/data/repositories/people_repository_impl_test.dart` (remote data source delegation, DTO mapping, error handling).
  - `app/test/features/people/domain/entities/person_scope_test.dart` (person scope validation).
- **Flutter Widget & Presentation Tests:**
  - `app/test/features/people/presentation/documents_role_variant_test.dart` (role-variant document permissions and UI rendering).
  - `app/test/features/people/presentation/trainers_directory_screen_test.dart`, `add_trainer_screen_test.dart`, `edit_trainer_profile_screen_test.dart`, `employee_form_cubit_test.dart`, `employee_form_screen_test.dart`.

---

## 8. Boundaries (do not confuse with V3 Members)

- **In V3 Members (this doc):** Member directory listing, 1-TX creation (user + member with sequential `membership_number`), dossier read (with null stubs), profile updates, trainer assignment (`POST /assign-trainer`), and row-scoping access controls.
- **Same module (PEOPLE), sibling verticals:**
  - **Trainers:** Trainer directory, profile CRUD, `is_active` capacity gate, roster listing (`V3-06`; see `docs/vertical-3-trainers-implementation.md`).
  - **Employees:** Staff directory, role assignment (`roles.update`), status changes with auth revocation (`V3-07`; see `docs/vertical-3-employees-implementation.md`).
  - **Emergency Contacts:** Emergency contacts CRUD for users (`V3-08`).
  - **Health Onboarding:** `member_health` metrics, document metadata attachment, photo avatar & gallery (`V3-12`, `V3-13a/b/c`).
  - **Medical Histories:** `medical_histories` condition records (`medical-history.*`).
  - **Media MVP:** Signed PUT/GET storage engine for avatars, documents, and proof files (`V3-10`, `V3-11` / ADR-0008).
- **Other modules (distinct vertical slices):**
  - **Memberships (`MEMB`):** Subscription packages, contracts, renewals, freezes, upgrades (`apps/api/src/membership/`).
  - **Billing & Payments (`PAY`):** Member balances, invoices, POS transactions, refunds (`apps/api/src/payments/`).
  - **Attendance (`ATTN`):** Check-in / check-out records and gate ingest (`apps/api/src/attendance/`).
  - **Scheduling (`SCHED`):** Class bookings, PT scheduling, trainer availability (`apps/api/src/sched/`).
  - **Workouts & Diets:** Workout plans, diet plans, exercise logging (`apps/api/src/work/`, `apps/api/src/diet/`).

---

## 9. Takeaways & Delta Scoring

1. **Atomic Identity & Profile Orchestration:** Member registration requires coordinated creation of `users` (credentials) and `members` (profile) in a single transaction via `PersonFactory`.
2. **Sequential Immutable Identifier:** Unlike arbitrary autoincrement IDs, members receive a human-readable, unique, immutable `membership_number` (`M00000001`) generated from a dedicated table counter.
3. **Row-Scoped Privacy & 404 Fail-Closed:** Strict data isolation where members only see their own profile and trainers only see assigned clients; unpermitted access returns 404 rather than 403 to prevent record enumeration.
4. **Dossier Hub Architecture:** Member detail acts as an aggregation hub (`MemberDossier`) with structured placeholders for future verticals (memberships, billing, attendance, scheduling) and navigation hubs to sibling profile sub-resources.
5. **Dedicated Assignment Domain Flow:** Trainer assignment is decoupled into a dedicated operation (`POST /members/:id/assign-trainer`) enforcing active status, client capacity limits, administrative override policies, and domain event dispatch.
6. **Stepper Onboarding & Multi-Screen Management:** Flutter replaces simple single-form catalogue editing with a multi-step onboarding wizard (`AddMemberWizardScreen`), a dossier overview (`MemberDossierScreen`), and a dedicated profile edit screen (`EditMemberScreen`).

### vs Vertical 1 (Scoring Table)

| Axis | V1 baseline | V3 Members | Score | Evidence |
| :--- | :--- | :--- | :---: | :--- |
| **HTTP surface** | `GET/POST /v1/exercises`, `GET/PATCH /v1/exercises/{id}`; no DELETE | `GET/POST /v1/members`, `GET/PATCH /v1/members/{id}`, `POST /v1/members/{id}/assign-trainer`; no DELETE | **partial** | `apps/api/src/people/member.controller.ts` |
| **Soft-deactivate** | `PATCH { is_active: false }`; no `exercises.delete` | No member-level deactivate PATCH; lifecycle managed via `users.status` / membership status | **different** | `apps/api/src/people/member.dto.ts` |
| **Visibility** | Inactive hidden unless actor has `exercises.update` | Row-scoped (trainer sees assigned only, member sees self only, staff see all); 404 fail-closed | **different** | `apps/api/src/people/row-scope.ts` |
| **Permissions** | `exercises.read` all; `exercises.create` admin+trainer; `exercises.update` admin only | `members.read` all; `members.create` admin+employee; `members.update` admin+employee | **different** | `apps/api/src/platform/db/seed/roles.ts` |
| **Nest layout** | controller / service / repository / dto / schema / module | controller / service / repository / dto / schema / module + `PersonFactory` + `row-scope` helper | **match** | `apps/api/src/people/` |
| **Audit** | `exercise.created` / `exercise.updated` | `member.created` / `member.updated` / `member.trainer_assigned` | **match** | `apps/api/src/people/member.service.ts` |
| **Flutter layers** | domain → data → presentation; five use cases including deactivate | domain → data → presentation; five use cases (list, get, create, update, assign trainer) | **match** | `app/lib/features/people/domain/usecases/` |
| **Deactivate client** | GET then PATCH (server also accepts partial `{ is_active: false }`) | No member deactivate button; member offboarding delegated to auth/membership flows | **different** | `app/lib/features/people/presentation/screens/edit_member_screen.dart` |
| **Pagination** | Offset; Flutter cursor is offset-as-string | Offset; Flutter cursor is offset-as-string | **match** | `app/lib/features/people/data/repositories/people_repository_impl.dart` |
| **Mapper shims** | `id` int↔String; null→empty; `equipment_needed` string↔`List<String>` | `id` int↔int; `date_of_birth`/`joined_date` `Date`↔`DateTime`; flat user credentials mapping | **partial** | `app/lib/features/people/data/models/people_mapper.dart` |
| **Media** | External `video_url` / `gif_url` only | Dedicated MEDIA MVP signed object storage (`/media/*`), photo gallery and avatars in sibling routes | **different** | `apps/api/src/platform/db/schema/members.ts` |
| **Contract** | `docs/openapi/v1.yaml` + `packages/api_client` | `docs/openapi/v1.yaml` + `packages/api_client` | **match** | `docs/openapi/v1.yaml` |

No implementation work proposed from this analysis.
