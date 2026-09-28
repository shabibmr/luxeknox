# Vertical 3 — Employees: UI design picture (live app not opened)

> UI design pass from `/compare-vertical`. Baseline patterns: `.grok/skills/compare-vertical/references/ui-design-checklist.md` (V1 Exercise Library). Stack picture: [`docs/vertical-3-employees-implementation.md`](vertical-3-employees-implementation.md).

Analysis only (no UI code changes). Scope is **Employees** (staff subset) presentation under `app/lib/features/people/presentation/` — directory, create/edit form, and roles assignment (FR-PEOPLE-014 / FR-PEOPLE-015 / FR-PEOPLE-016, FR-RBAC-004).

**Explicitly out of scope:** Members, Trainers, Emergency contacts, Health / medical / documents / photos, MEDIA.

**Browser:** not opened this pass — scores are from code + `docs/screens/*` only.

**Primary screens:** `EmployeesDirectoryScreen`, `EmployeeFormScreen` (create | edit), `EmployeeRolesScreen`.

---

## 1. Screen inventory

| Screen | Role visibility | Route(s) | Spec ref in `docs/screens/` | Dart path |
| :--- | :--- | :--- | :--- | :--- |
| **Employees Directory** | Admin shell (seeded `employees.read`; FAB needs `employees.create`) | `/admin/employees` (`Routes.adminEmployees`) | `admin-app-screens.md` §4 Employees; `consolidated-screens.md` #44 (Staff Directory); `navigation-architecture.md` More | `app/lib/features/people/presentation/screens/employees_directory_screen.dart` |
| **Add Employee** | Admin (`employees.create` via `RouteCapabilities`) | `/admin/employees/create` | `admin-app-screens.md` §4 Add Employee | `…/screens/employee_form_screen.dart` (`EmployeeFormScreen.create`) |
| **Edit Employee** | Admin (`employees.update` via `RouteCapabilities`) | `/admin/employees/:id/edit` | `admin-app-screens.md` §4 Edit Employee (+ Status quick action inlined) | `…/screens/employee_form_screen.dart` (`EmployeeFormScreen.edit`) |
| **Employee Roles** | Admin (no `RouteCapabilities` slug; API expects `roles.update`) | `/admin/employees/:id/roles` | `admin-app-screens.md` §4 Employee Role | `…/screens/employee_roles_screen.dart` |
| **Employee Profile** (read-only detail) | — | **missing** (tap → edit) | `admin-app-screens.md` §4 Employee Profile | `missing` |

Invalid `:id` on edit/roles builders falls back to `PlaceholderScreen(title: ShellStrings.employees)`.

---

## 2. IA & navigation

- **Hub:** Admin `MoreHubScreen` → `ShellStrings.employees` → `/admin/employees`.
- **Deep links:** `/admin/employees`, `/admin/employees/create`, `/admin/employees/:id/edit`, `/admin/employees/:id/roles` on the admin shell branch (`admin_routes.dart`).
- **Push vs master–detail:** Always full-screen `context.push` — **no** 840dp side pane (unlike V1 `ExerciseLibraryScreen._masterDetailBreakpoint`).
- **Create flow:** FAB → create form → on save `pop(id)` → directory reloads query → immediately pushes edit for the new id.
- **Edit flow:** list tap → edit; on save `pop(id)` → directory reloads when a non-null id returns.
- **Roles:** edit form “Manage roles” `ListTile` → push roles route; assign stays on screen (SnackBar), no automatic pop.
- **Trainer / member:** no employees directory or form routes on those shells.

---

## 3. Catalogue pattern score

| Pattern | Score | Evidence |
| :--- | :---: | :--- |
| **Screens** (library / detail / form) | **partial** | Directory + unified create/edit form + roles screen; **no** separate read-only detail (spec’s Employee Profile). |
| **List chrome** (AppBar, search, filter, ~200px paging) | **partial** | AppBar title + search field; **no** filter action/sheet; paging is explicit **Load more** (`PeopleStrings.loadMore`), not ~200px scroll. |
| **Create entry** AppBar `+` + `context.can` | **partial** | `FloatingActionButton` + `Icons.person_add_alt_1` when `context.can('employees.create')` — not AppBar `+`. |
| **Master–detail** **840** | **missing** | No feature breakpoint; always push. |
| **Filter sheet** → new list query | **missing** | Text `q` only (`ListEmployeesUseCase`); no status/department sheet. |
| **List item** pure render | **match** | Inline `ListTile` (name, job · department, status text); no fetch in tile. |
| **Detail** + edit when update | **partial** | No read layout; tap opens edit. Edit route gated by `employees.update`; no detail-screen edit affordance. |
| **Form** create/edit + denied body | **partial** | Single `EmployeeFormScreen` create\|edit (V1-like). **No** in-screen `context.can` / `PeopleStrings.noPermission` body — relies on `RouteCapabilities` redirect. |
| **Deactivate** confirm in edit | **partial** | Employment **status** dropdown (active / on_probation / suspended / terminated); confirm dialog for suspend/terminate (`statusRequiresConfirm`). Not catalogue `is_active` deactivate. |
| **`UnsavedChangesScope`** | **match** | Form wraps `hasUnsavedChanges: dirty` while dirty and not submitting/status-updating. |
| **Feature `*_strings.dart`** | **match** | `people_strings.dart` (`PeopleStrings`) — shared PEOPLE feature file. |
| **Empty / error** inline | **different** | Directory/roles use `AppEmptyView` / `AppErrorView` / `AppLoading` (V1 used inline `Center`/`Text`/`TextButton`). |
| **Theme** `AppTheme` | **match** | Material 3 shared theme. |
| **`AdaptiveShell`** 600 / 1240 | **match** | Admin shell chrome; feature does not redefine shell breakpoints. |
| **Member** no library tab | **match** | No member/trainer employees routes (admin More only). |

---

## 4. Design system

- **Theme:** `app/lib/core/theme/app_theme.dart` (Material 3).
- **Strings:** `app/lib/features/people/presentation/people_strings.dart` — employees title, empty/load-more, add/edit copy, status labels, confirm suspend/terminate, roles copy. `PeopleStrings.noPermission` exists but is **unused** on employee screens.
- **Feedback widgets actually used:**
  - Directory / roles: `AppLoading`, `AppErrorView` (+ retry), `AppEmptyView`; mutation/paging failures also `SnackBar`.
  - Form: `AppLoading` on initial edit load; submit/status errors and success via `SnackBar`; status change uses `AlertDialog`.
- **Not used on these screens:** V1-style bare `Center`+`Text` empty/error; `AppEmptyView` on the form itself.

---

## 5. Responsive

- **Shell:** `AdaptiveShell` — `NavigationBar` &lt; 600; compact rail 600–&lt;1240; extended rail at 1240 (`AdaptiveShellBreakpoints`).
- **Feature:** No `_masterDetailBreakpoint` / 840 split on `EmployeesDirectoryScreen`. Single-column `ListView` / form `ListView` at all widths.

---

## 6. States

| State | Where | Behavior |
| :--- | :--- | :--- |
| Loading (list) | Directory, empty items | `AppLoading` |
| Loading (paging) | Directory footer | Load more disabled; label `…` |
| Loading (form) | Edit initial | Scaffold + `AppLoading` |
| Empty | Directory / roles list | `AppEmptyView` (`emptyEmployees` / `emptyRoles`) |
| Error (initial) | Directory / roles | `AppErrorView` + retry |
| Error (paging / mutation) | Directory with items; form; roles assign | `SnackBar` |
| Submitting | Form | Primary button spinner; double-submit blocked; unsaved scope cleared while submitting |
| Status updating | Edit form | Dropdown disabled while `statusUpdating`; confirm before suspend/terminate |
| Permission denied | Create/edit routes | **Redirect** via `RouteCapabilities` (`employees.create` / `employees.update`); form has **no** denied body. FAB hidden without `employees.create`. Roles route **ungated** in chrome. |
| Unsaved | Form | `UnsavedChangesScope` while dirty |
| Offboard analogue | Edit status | Confirm → `SetEmployeeStatus` → SnackBar `statusUpdated` (stays on form) |

---

## 7. Role chrome

| Role | Directory | Create | Edit / status | Roles screen |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | More → `/admin/employees` | FAB if `employees.create` | `/…/edit` if `employees.update`; status dropdown + Manage roles | `/…/roles` (no client `context.can('roles.update')`) |
| **Trainer** | **no route** | — | — | — |
| **Member / Employee user-type** | **no route** (redirected to member home) | — | — | — |

Cited call sites:

- `employees_directory_screen.dart`: `context.can('employees.create')`
- `route_capabilities.dart`: create → `employees.create`; `…/edit` → `employees.update`
- **Absent on form/roles UI:** `context.can('employees.update')`, `context.can('roles.update')`, in-body `noPermission`

Seeded slugs (stack picture §4): `employees.read` / `create` / `update` (admin only). Role assign API uses `roles.update`.

---

## 8. Spec gaps

| Spec | Gap |
| :--- | :--- |
| `admin-app-screens.md` §4 **Employee Profile** | No read-only detail; list opens **Edit Employee**. |
| §4 **Add Employee** “emergency info, salary terms” | Out of Employees UI scope; form is credentials + profile + role_id (create) / job fields (edit). |
| §4 **Employee Role** as “Assignment Modal” | Implemented as full-screen `EmployeeRolesScreen`, not a modal. |
| §4 **Employee Status** as profile quick action | Inlined as edit-form dropdown + confirm (not a separate screen). |
| `consolidated-screens.md` #44 **Staff Directory & Roles** | Split: `/admin/trainers` vs `/admin/employees` (employees slice here). |
| Directory filters | Spec roster implies status/department facets; UI is search-only. |

---

## 9. Takeaways

Largest UI deltas vs V1 Exercise Library (§3):

1. **No 840dp master–detail** — directory always pushes full-screen routes.
2. **FAB create** gated by `employees.create` instead of AppBar `+`.
3. **List chrome** — search without filter sheet; **Load more** button instead of ~200px infinite scroll.
4. **Shared empty/error/loading widgets** (`AppEmptyView` / `AppErrorView` / `AppLoading`) vs V1 inline text/retry.
5. **No read-only detail** — edit form is the record surface; extra **Roles & Permissions** screen beyond V1’s library/detail/form trio.
6. **Employment status + confirm** (suspend/terminate) replaces catalogue deactivate-on-edit.
7. **Permission UX** — route redirects for create/edit; form omits V1’s in-screen `noPermission` body; roles path lacks client capability chrome.

Aligned with V1: unified create/edit form screen, `UnsavedChangesScope`, feature strings, Material 3 `AppTheme`, `AdaptiveShell`, admin-only catalogue (no member tab).
