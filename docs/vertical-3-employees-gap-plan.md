# Vertical 3 — Employees: gap-fix plan

> Vertical: V3 Employees (PEOPLE staff subset; FR-PEOPLE-014…016 / FR-RBAC-004).
> Mode: default. This file is the `/implement` handoff.
> Status: Implemented (V3E-G1…G7 Done).
> Stack: `docs/vertical-3-employees-implementation.md`
> UI: `docs/vertical-3-employees-ui-design.md`
> Baseline: Vertical 1 Exercise Library soft-CRUD catalogue.
> Out of this slice: members, trainers, emergency contacts, health/docs/photos, MEDIA.

Scores synthesized from implementation §9 (delta-axis table) and UI §3 plus §9. Match rows (Nest layout, offset pagination, `UnsavedChangesScope`, feature strings, `AppTheme`, `AdaptiveShell` 600/1240, member-no-tab) are not work items. IDs use **V3E-G*** so they do not collide with Trainers **V3-G***.

---

## 1. In scope

Fixes that close a **partial / different / missing** score or a takeaway that breaks live admin behavior (ranked per gap-plan checklist):

| ID | Priority | Problem | Closes |
| :--- | :---: | :--- | :--- |
| **V3E-G1** | P1 | `/admin/employees/:id/roles` is not gated by `roles.update` in `RouteCapabilities`; form/roles omit V1-style in-screen `noPermission` chrome | UI Form **partial**; UI §9.7 permission UX; Role chrome §7 |
| **V3E-G2** | P2 | OpenAPI `Employee` is nested `user` while Nest returns flat fields; `EmployeeUpdate` omits `first_name`/`last_name` that Zod accepts — Flutter stays on raw Dio maps | Stack Contract **partial**; Mapper shims **different**; §9.5 wire-shape shim |
| **V3E-G3** | P2 | Directory is search-only; list API/OpenAPI/`listEmployeesRaw` have no `status` (or department) filter params for roster facets | UI Filter sheet **missing**; List chrome **partial**; UI §8 Directory filters |
| **V3E-G4** | P4 | Directory uses explicit **Load more** instead of ~200px scroll-threshold paging | UI List chrome **partial**; UI §9.3 |
| **V3E-G5** | P3 | Spec still describes Employee Profile / Role modal / Status quick action and a combined Staff Directory; app is directory → edit + full-screen roles | UI §8 Spec gaps; Screens **partial** (document, do not invent a read-only profile) |
| **V3E-G6** | P4 | Create entry is FAB + `person_add_alt_1`, not AppBar `+` | UI Create entry **partial**; UI §9.2 |
| **V3E-G7** | P4 | No 840dp master–detail; directory always pushes full-screen routes | UI Master–detail **missing**; UI §9.1 |

---

## 2. Out of scope (intentional)

| Delta | Why it stays |
| :--- | :--- |
| **PersonFactory 1-TX create** (`user` + `employees`) | Identity vertical, not catalogue row insert. Evidence: implementation §9.1; HTTP/create flow. |
| **Four-way `POST /status` + session revoke** (not `is_active` PATCH) | FR-PEOPLE-016 employment lifecycle. Evidence: Soft-deactivate / Deactivate client rows; UI Deactivate **partial**. |
| **All statuses listed** (no catalogue hide-inactive) | Staff roster must show suspended/terminated. Evidence: Visibility row; `employee.repository.ts`. |
| **Admin-only `employees.*` + `roles.update` seed** | Staff admin surface; do not widen seed to trainers/members. Evidence: Permissions row; `roles.ts`. |
| **No read-only Employee Profile screen** | Product: tap → edit form; Roles is a separate route. Spec text only via V3E-G5. Evidence: UI Screens/Detail rows; §9.5–9.6. |
| **Shared `AppEmptyView` / `AppErrorView` / `AppLoading`** | Deliberate DS reuse vs V1 inline chrome. Evidence: UI Empty/error **different**. |
| **Sibling PEOPLE / MEDIA** | Members, trainers, emergency contacts, health/docs/photos, MEDIA. Evidence: implementation §8 Boundaries. |
| **Extra audit events / use-case count** | `role_assigned` / `status_changed` and six employee use cases are expected richness, not lag. Evidence: Audit / Flutter layers **partial**. |

---

## 3. Work items

| ID | Fix | Primary paths | Acceptance | Depends on | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **V3E-G1** | Gate `/admin/employees/:id/roles` with `roles.update` in `RouteCapabilities`. Add in-screen `context.can` / `PeopleStrings.noPermission` on `EmployeeRolesScreen` (and optionally `EmployeeFormScreen` create/edit as defense in depth matching V1). | `app/lib/core/router/route_capabilities.dart`; `app/lib/features/people/presentation/screens/employee_roles_screen.dart`; `employee_form_screen.dart`; router/capability tests under `app/test/` | Unauthenticated capability for `roles.update` redirects away from roles route. Roles (and form, if touched) show `noPermission` when slug missing. Existing create/edit redirects for `employees.create` / `employees.update` unchanged. | — | Done |
| **V3E-G2** | Align OpenAPI `Employee` (+ page items) with Nest flat `EmployeeResponseDto` (`first_name`, `last_name`, email/phone as returned). Add `first_name` / `last_name` to `EmployeeUpdate`. Regen `packages/api_client` and migrate employee list/get/create/update/status/role off raw Dio where the generated client matches. Keep mapper `fullName` concat if still needed. | `docs/openapi/v1.yaml`; `packages/api_client/`; `app/lib/features/people/data/datasources/people_remote_datasource.dart`; `people_mapper.dart`; `people_repository_impl.dart` | Generated client parses live employee JSON without raw-map shims for the flat shape. PATCH with name fields is documented and accepted. Repository/mapper tests pass against flat fixtures. | — | Done |
| **V3E-G3** | Add list query `status` (enum; optional `department` if cheap) on Nest list + OpenAPI `listEmployees`. Forward from `listEmployeesRaw` / use case / `EmployeesDirectoryCubit`. Add directory filter sheet or chips (status facets; department if wired). | `apps/api/src/people/employee.repository.ts`; `employee.service.ts`; `employee.controller.ts`; `docs/openapi/v1.yaml`; `people_remote_datasource.dart`; `employees_directory_cubit.dart`; `employees_directory_screen.dart`; `people_strings.dart` | Changing status filter changes `GET /v1/employees` query and list contents. OpenAPI parameters match Nest. Widget/cubit or API unit coverage for the new query. | Prefer after V3E-G2 if regenerating client for list params; else Flutter raw forward is OK interim | Done |
| **V3E-G4** | Replace or supplement **Load more** with a `ScrollController` listener that calls `loadMore` within ~200px of extent (V1 catalogue pattern). | `app/lib/features/people/presentation/screens/employees_directory_screen.dart` | Near-end scroll requests next page when `hasMore`; no reliance on the button alone. | — | Done |
| **V3E-G5** | Update `admin-app-screens.md` §4 and `consolidated-screens.md` #44 so Employees match live IA: directory → edit (no separate profile), status on edit form, roles full-screen route, trainers vs employees split. | `docs/screens/admin-app-screens.md`; `docs/screens/consolidated-screens.md` | Specs no longer require Employee Profile / Role modal / Status quick-action screens for this slice. No new Flutter profile route. | — | Done |
| **V3E-G6** | Move create entry to AppBar `+` gated by `context.can('employees.create')`; remove FAB (or keep only if AppBar parity is explicitly rejected — default is AppBar `+`). | `employees_directory_screen.dart`; related widget tests | Admin with `employees.create` sees AppBar `+`; without it, no create control. | — | Done |
| **V3E-G7** | At width ≥ 840dp, directory uses master–detail (list + selected edit/roles pane) instead of always pushing. | `employees_directory_screen.dart` (and edit/roles embedding as needed) | ≥840dp shows split; narrow keeps push navigation. | V3E-G1 (roles chrome), soft-dep V3E-G6 | Done |

---

## 4. Verification

1. **Flutter (people / employees):**
   ```bash
   cd app && flutter test test/features/people/presentation/employee_form_cubit_test.dart
   cd app && flutter test test/features/people/presentation/employee_form_screen_test.dart
   cd app && flutter test test/features/people/domain/usecases/people_usecases_test.dart
   cd app && flutter test test/features/people/data/repositories/people_repository_impl_test.dart
   cd app && flutter test test/features/people/
   ```
2. **API:**
   ```bash
   npm run test -- apps/api/src/people/employee.service.spec.ts
   npm run test:e2e -- apps/api/test/people-onboarding.e2e.spec.ts
   ```
3. **Optional web sanity:** Admin → More → `/admin/employees` — search, status filter, infinite scroll, AppBar `+`, edit status confirm, Manage roles gated by `roles.update`, 840dp split when wide.

---

## 5. Implement handoff

Fix Vertical 3 Employees gaps in `docs/vertical-3-employees-gap-plan.md`: (V3E-G1) gate `/admin/employees/:id/roles` with `roles.update` and add in-screen `noPermission` chrome; (V3E-G2) align OpenAPI flat `Employee` / `EmployeeUpdate` name fields, regen `api_client`, and drop raw Dio where possible; (V3E-G3) add list `status` (optional department) filter through Nest + OpenAPI + directory UI; (V3E-G4) ~200px infinite scroll on the directory; (V3E-G5) update `admin-app-screens.md` §4 and consolidated #44 to match directory→edit + roles route; (V3E-G6) AppBar `+` create instead of FAB; (V3E-G7) 840dp master–detail. Do not change PersonFactory 1-TX create, employment `POST /status` revoke semantics, admin-only seed, hide-inactive policy, or sibling members/trainers/EC/health/MEDIA. Verify with `flutter test test/features/people/` and `npm run test -- apps/api/src/people/employee.service.spec.ts`.
