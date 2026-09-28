# Vertical 3 — Employees: implementation picture

> **Baseline comparison** against Vertical 1 (`docs/vertical-1-exercise-library-implementation.md`). Section order and delta axes follow `.grok/skills/compare-vertical/references/section-checklist.md`.

Analysis only (no code changes). Scope is **Employees** (staff employees subset: FR-PEOPLE-014 / FR-PEOPLE-015 / FR-PEOPLE-016, FR-RBAC-004, FR-AUTH-008 / FR-AUTH-009), per ADR-0007 and `archive/todo/vertical-3/README.md`.

**Explicitly out of scope for this document:** Members, Trainers, Emergency Contacts, Health / medical histories, member documents & photos, and MEDIA signed upload. Those live in the same Nest `PeopleModule` / Flutter `features/people` tree but are sibling vertical slices.

**Status:** Backend ticket **V3-07** (Employees API + role + status) completed; Vertical 3 backend tickets V3-01…V3-16 completed in `archive/todo/vertical-3/`. Flutter staff directory under `app/lib/features/people/` is implemented and wired on the admin shell.
**UI design refs:** [Admin App Screens — Employees](screens/admin-app-screens.md) §4; [People & Profile](flutter/03-people-profile.md) (employee directory checked).

---

## 1. What “CRUD” means here

| Operation | HTTP | Permission | Notes |
| :--- | :--- | :--- | :--- |
| **Read list** | `GET /v1/employees` | `employees.read` | Staff directory; query `q` (first/last name, job_title, department); offset pagination (`limit`, `offset`). All employment statuses returned (no inactive-hide catalogue policy). |
| **Read one** | `GET /v1/employees/{id}` | `employees.read` | Flat `EmployeeResponseDto` (+ `role_id` from joined `users`). |
| **Create** | `POST /v1/employees` | `employees.create` | 201; 1-TX `PersonFactory` (`user_type=employee`) + `employees` row `status=active`; requires `password`, `first_name`, `last_name`, `job_title`, `role_id`; audit `employee.created`. |
| **Update** | `PATCH /v1/employees/{id}` | `employees.update` | Partial profile: Nest Zod allows `job_title`, `department`, `hire_date`, `first_name`, `last_name`. OpenAPI `EmployeeUpdate` documents only job_title/department/hire_date (**contract drift**). Audit `employee.updated`. |
| **Assign role** | `PUT /v1/employees/{id}/role` | `roles.update` | Exactly one role (FR-RBAC-004); sets `users.role_id`; audit `employee.role_assigned`. |
| **Set status** | `POST /v1/employees/{id}/status` | `employees.update` | Body `{ status }` ∈ `active` \| `on_probation` \| `suspended` \| `terminated`. Suspend/terminate → `users.status` non-authable + revoke all sessions + drop session cache; reactivate/`on_probation` → `users.status=active`. Audit `employee.status_changed`. |
| **Delete** | **None** | — | No `DELETE /employees/{id}` and no `employees.delete` slug. Lifecycle is employment **status**, not catalogue `is_active`. |

There is **no** hard delete. Soft “offboarding” is `POST …/status` with `suspended` or `terminated` (FR-PEOPLE-016), which **blocks login** — unlike V1/V2 catalogue deactivate and unlike trainers’ `is_active` assignment gate.

---

## 2. End-to-end stack

```
Flutter UI
  EmployeesDirectoryScreen / EmployeeFormScreen (create|edit) / EmployeeRolesScreen
    ↓ Cubit (EmployeesDirectoryCubit, EmployeeFormCubit, EmployeeRolesCubit)
  Use cases (ListEmployees, GetEmployee, CreateEmployee, UpdateEmployee,
             SetEmployeeStatus, AssignEmployeeRole, ListRoles)
    ↓
  PeopleRepositoryImpl → PeopleRemoteDataSourceImpl
    (employee paths use raw Dio Map parsers — Nest flat DTO ≠ OpenAPI nested `user`)
    ↓ HTTP /v1/employees*
Nest EmployeeController → EmployeeService
  → EmployeeRepository + PersonFactory + SessionRepository/SessionCache + AuditService
  → MariaDB `employees` + `users` (+ `roles` for assign)
```

**Contract source of truth:** `docs/openapi/v1.yaml` (`listEmployees`, `createEmployee`, `getEmployee`, `updateEmployee`, `assignEmployeeRole`, `setEmployeeStatus`). Client package: `packages/api_client` (generated `Employee*` types exist; live employee reads/writes prefer raw JSON via `*Raw` DS methods because Nest returns a flat shape).

---

## 3. Backend (Nest)

### Layout

| Piece | Path |
| :--- | :--- |
| Controller | `apps/api/src/people/employee.controller.ts` |
| Service | `apps/api/src/people/employee.service.ts` |
| Repository | `apps/api/src/people/employee.repository.ts` |
| Zod DTOs | `apps/api/src/people/employee.dto.ts` |
| Schema | `apps/api/src/platform/db/schema/employees.ts` |
| Module | `apps/api/src/people/people.module.ts` |
| Person Factory | `apps/api/src/people/person.factory.ts` (1-TX user + profile) |
| Unit tests | `apps/api/src/people/employee.service.spec.ts` |

### Table (`employees`)

`id`, `user_id` (unique FK → `users`), `first_name`, `last_name`, `job_title`, `department` (nullable), `hire_date` (date string, nullable), `status` enum (`active` \| `on_probation` \| `suspended` \| `terminated`, default `active`), `created_at`, `updated_at`.

Joined on read: `users.role_id` exposed as `role_id` on `EmployeeWithRole`.

### Service behavior

- **List:** `findManyFiltered` with optional `q` LIKE across name/title/department; offset pagination via shared helper; **no** status filter and **no** “hide terminated unless update” catalogue visibility.
- **Create:** `PersonFactory.createPerson` with `userType: 'employee'`, credentials + `roleId`, profile fields, initial `status: 'active'`; audit `employee.created`.
- **Get:** `findByIdWithRole` or 404.
- **Update:** patch employee columns only (not status/role); audit `employee.updated`.
- **Assign role:** validate `roles.id` exists; update `users.role_id`; audit `employee.role_assigned`.
- **Set status:** update `employees.status`; if `suspended`/`terminated`, set `users.status` to `suspended`/`inactive` and `revokeAllForUser` + `sessionCache.dropByUser`; if `active`/`on_probation`, set `users.status` to `active`; audit `employee.status_changed`.

### Validation (Zod)

- **Create:** email, password (required), first/last name, job_title, role_id required; phone/department/hire_date optional.
- **Update:** strict object; optional job_title, department, hire_date, first_name, last_name.
- **Status:** `z.enum(EMPLOYEE_STATUSES)`.
- **Assign role:** `role_id` positive int.
- **List filter:** optional `q`.

**Recorded drift:** OpenAPI `Employee` nests `user`; Nest `EmployeeResponseDto` is flat (`first_name`/`last_name`/`role_id`). OpenAPI `EmployeeUpdate` omits name fields that Nest accepts. OpenAPI `EmployeeCreate.password` is not marked required; Nest Zod requires it (V3-07).

---

## 4. Permissions (seeded)

| Slug | Admin | Trainer | Employee | Member |
| :--- | :---: | :---: | :---: | :---: |
| `employees.read` | ✓ | — | — | — |
| `employees.create` | ✓ | — | — | — |
| `employees.update` | ✓ | — | — | — |
| `employees.write` *(legacy alias)* | ✓ | — | — | — |
| `roles.update` *(role endpoint)* | ✓ | — | — | — |

Super Admin: `permissionSlugs: 'all'`.

Evidence: `apps/api/src/platform/db/seed/permissions.ts`, `apps/api/src/platform/db/seed/roles.ts`.

### Implications

- **Admin only** staff directory mutate + read in the seeded matrix (unlike V1 `exercises.read` for all roles, and unlike `trainers.read` for all roles).
- Role assignment is a separate RBAC slug (`roles.update`), not `employees.update`.
- Flutter admin routes gate create → `employees.create`, edit → `employees.update`, roles path → `roles.update` (`app/lib/core/router/route_capabilities.dart`).

---

## 5. Flutter (Clean Architecture)

### Domain

- **Entities:** `EmployeeSummary`, `NewEmployeeInput`, `EmployeeUpdateInput`, `EmployeeStatus`, `Role`.
- **Repo contract:** `PeopleRepository` — `listEmployees`, `getEmployee`, `createEmployee`, `updateEmployee`, `setEmployeeStatus`, `assignEmployeeRole`, `listRoles`.
- **Use cases:** `ListEmployeesUseCase`, `GetEmployeeUseCase`, `CreateEmployeeUseCase`, `UpdateEmployeeUseCase`, `SetEmployeeStatusUseCase`, `AssignEmployeeRoleUseCase`, `ListRolesUseCase`.

### Data

- `PeopleRemoteDataSource` employee methods: `listEmployeesRaw`, `getEmployeeRaw`, `createEmployeeRaw`, `updateEmployeeRaw`, `setEmployeeStatusRaw`, `assignEmployeeRoleRaw` (Dio `/employees*`).
- List cursor is **offset-as-string** (`int.tryParse(cursor)`).
- Prefer `employeeSummaryFromJson` for live Nest flat payloads; `employeeSummaryFromApi` kept for generated nested `Employee`.

### Presentation

| Screen | Role | Behavior |
| :--- | :--- | :--- |
| `EmployeesDirectoryScreen` | Admin (`/admin/employees`) | Searchable list; status trailing; FAB if `employees.create`; tap → edit |
| `EmployeeFormScreen.create` | Admin | Create fields + role picker; gate `employees.create` |
| `EmployeeFormScreen.edit` | Admin | Profile patch + status dropdown (confirm on suspend/terminate) + link to Manage Roles |
| `EmployeeRolesScreen` | Admin | List roles; assign via `roles.update` |

Routes: `/admin/employees`, `/admin/employees/create`, `/admin/employees/:id/edit`, `/admin/employees/:id/roles` (`app/lib/core/router/routes.dart`, `admin_routes.dart`). No trainer/member employee routes in tree.

### Mapper quirks (documented in `people_mapper.dart`)

| Field | OpenAPI / Nest | Flutter domain | Mapping |
| :--- | :--- | :--- | :--- |
| Wire shape | OpenAPI nested `user`; Nest flat DTO | `EmployeeSummary` | Live path: `employeeSummaryFromJson` |
| `id` / `user_id` / `role_id` | `int` | `int` | Direct |
| Names | Nest `first_name`/`last_name` | `fullName` | Concatenate; fallback `Employee #id` |
| `status` | enum string | `String?` on summary; `EmployeeStatus` on form | `.name` / `.wire` |
| Create body | OpenAPI may omit required password | `NewEmployeeInput` | Raw map includes password + `role_id` |

---

## 6. Read / Create / Update / Delete flows (UI → API)

### Read
1. Admin opens More → Employees → `EmployeesDirectoryCubit` loads `ListEmployeesUseCase`.
2. `GET /v1/employees?limit&offset&q`.
3. Tap row → `EmployeeFormScreen.edit` → `GetEmployeeUseCase` → `GET /v1/employees/{id}`.

### Create
1. FAB (if `employees.create`) → create form; load roles via `ListRolesUseCase`.
2. Submit → `CreateEmployeeUseCase` → `POST /v1/employees`.
3. On success, navigate to edit for the new id.

### Update
1. Edit form dirty fields → `UpdateEmployeeUseCase` → `PATCH /v1/employees/{id}`.
2. Manage Roles tile → `EmployeeRolesScreen` → `AssignEmployeeRoleUseCase` → `PUT /v1/employees/{id}/role`.

### Delete (status / offboard)
1. Edit form status dropdown; suspend/terminate requires confirm dialog.
2. `SetEmployeeStatusUseCase` → `POST /v1/employees/{id}/status` with `{ status }`.
3. Server updates employment status, may block auth + revoke sessions (no catalogue `is_active` PATCH).

---

## 7. Tests / verification already in tree

**API**
- `apps/api/src/people/employee.service.spec.ts` — `EmployeeService.setStatus` (terminate → non-authable + session revoke).
- `apps/api/test/people-onboarding.e2e.spec.ts` — create employee + status change path.
- Shared person-factory / permissions seeds covered under V3-01 / V3-03 / V3-15 matrix work.

**Flutter**
- `app/test/features/people/presentation/employee_form_cubit_test.dart`
- `app/test/features/people/presentation/employee_form_screen_test.dart`
- `app/test/features/people/domain/usecases/people_usecases_test.dart` (employee use cases)
- `app/test/features/people/data/repositories/people_repository_impl_test.dart`

---

## 8. Boundaries (do not confuse with V3 Employees)

- **In V3 Employees (this doc):** Staff directory, employee profile fields, create via PersonFactory, profile PATCH, role assign (`roles.update`), employment status with auth revoke (FR-PEOPLE-014…016 / FR-RBAC-004).
- **Same module (PEOPLE), out of scope here:**
  - **Members** — directory/dossier/onboarding (`V3-05*`).
  - **Trainers** — profiles, `is_active`, roster (`V3-06`; see `docs/vertical-3-trainers-implementation.md`).
  - **Emergency Contacts** — `V3-08` (FR-PEOPLE-014 mentions EC on employees; EC API is sibling, not this slice).
  - **Health / docs / photos** — `V3-12` / `V3-13*`.
  - **MEDIA** — signed PUT/GET (`V3-11` / ADR-0008).
- **Other modules:** RBAC role *editor* UI, attendance staff clock, dashboard `employees_total`/`employees_active` counters (consume employee counts but are not Employees CRUD).

---

## 9. Takeaways & Delta Scoring

1. **Person identity, not catalogue row:** Create always goes through `PersonFactory` (user + employee profile in one TX) — closer to Trainers than to V1 exercises.
2. **Status replaces soft-delete:** Four-way `employees.status` plus dedicated `POST /status`; suspend/terminate **revokes sessions** and blocks login (FR-PEOPLE-016).
3. **Role is a first-class mutation:** `PUT /role` under `roles.update`, separate from `employees.update`.
4. **Admin-only seed matrix:** Unlike V1 (all roles can read catalogue) and Trainers (`trainers.read` for all), seeded `employees.*` are admin/super_admin only.
5. **Wire-shape shim:** Nest flat DTO vs OpenAPI nested `user` forces Flutter raw Dio + `employeeSummaryFromJson` (documented mapper quirk).
6. **No dedicated detail screen in Flutter tree:** Directory → edit form; roles are a separate admin route.

### vs Vertical 1 (Scoring Table)

| Axis | V1 baseline | V3 Employees | Score | Evidence |
| :--- | :--- | :--- | :---: | :--- |
| **HTTP surface** | `GET/POST /v1/exercises`, `GET/PATCH /v1/exercises/{id}`; no DELETE | `GET/POST /v1/employees`, `GET/PATCH /v1/employees/{id}`, `PUT …/role`, `POST …/status`; no DELETE | **different** | `apps/api/src/people/employee.controller.ts` |
| **Soft-deactivate** | `PATCH { is_active: false }`; no `exercises.delete` | `POST /status` enum; suspend/terminate blocks auth + revokes sessions | **different** | `apps/api/src/people/employee.service.ts` |
| **Visibility** | Inactive hidden unless actor has `exercises.update` | All statuses listed; no catalogue hide-inactive helper | **different** | `apps/api/src/people/employee.repository.ts` |
| **Permissions** | `exercises.read` all; create admin+trainer; update admin | `employees.*` + `roles.update` admin only in seed | **different** | `apps/api/src/platform/db/seed/roles.ts` |
| **Nest layout** | controller / service / repository / dto / schema / module | Same + `PersonFactory` + session revoke deps | **match** | `apps/api/src/people/` |
| **Audit** | `exercise.created` / `exercise.updated` | `employee.created` / `updated` / `role_assigned` / `status_changed` | **partial** | `apps/api/src/people/employee.service.ts` |
| **Flutter layers** | domain → data → presentation; five use cases incl. deactivate | Same layers; six employee mutators/readers + list roles | **partial** | `app/lib/features/people/domain/usecases/` |
| **Deactivate client** | GET then PATCH `{ is_active: false }` | Dedicated `SetEmployeeStatusUseCase` → `POST /status` | **different** | `app/lib/features/people/presentation/cubit/employee_form_cubit.dart` |
| **Pagination** | Offset; Flutter cursor offset-as-string | Offset; Flutter cursor offset-as-string | **match** | `app/lib/features/people/data/repositories/people_repository_impl.dart` |
| **Mapper shims** | `id` int↔String; null→empty; equipment list shim | Flat Nest JSON vs nested OpenAPI; `fullName` concat; raw Dio | **different** | `app/lib/features/people/data/models/people_mapper.dart` |
| **Media** | External `video_url` / `gif_url` only | None on employees (MEDIA sibling out of scope) | **different** | `apps/api/src/platform/db/schema/employees.ts` |
| **Contract** | `docs/openapi/v1.yaml` + `packages/api_client` | Same YAML + package; live employee I/O uses raw maps for shape drift | **partial** | `docs/openapi/v1.yaml`, `people_remote_datasource.dart` |

No implementation work proposed from this analysis.
