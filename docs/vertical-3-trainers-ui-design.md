# Vertical 3 — Trainers: UI design picture

> UI design pass from `/compare-vertical`. Baseline patterns: `.agents/skills/compare-vertical/references/ui-design-checklist.md` (V1 Exercise Library). Stack picture: `docs/vertical-3-trainers-implementation.md`.

Analysis only (no UI code changes). Scope is **Trainers** presentation screens under `app/lib/features/people/presentation/` (FR-PEOPLE-003 / FR-PEOPLE-007 / FR-PEOPLE-010). Sibling screens in the same feature folder (Members directory/dossier/wizard, Employees directory/form/roles, Emergency contacts, Documents/Photos, Health info) and sibling verticals (Scheduling availability, Workout/Diet plans) are out of this specific vertical slice.

**Browser:** not opened this pass — scores are from code + `docs/screens/*` only.

**Primary screens:** `TrainersDirectoryScreen`, `AddTrainerScreen`, `EditTrainerProfileScreen`, `MyTrainerProfileScreen`.

---

## 1. Screen inventory

| Screen | Role visibility | Route(s) | Spec ref in `docs/screens/` | Dart path |
| :--- | :--- | :--- | :--- | :--- |
| **Trainers Directory** | Admin / Staff (`trainers.read`) | `/admin/trainers` (`Routes.adminTrainers`) | `admin-app-screens.md` §3 Trainers; `consolidated-screens.md` #44 (Staff Directory); `navigation-architecture.md` §4 More | `app/lib/features/people/presentation/screens/trainers_directory_screen.dart` |
| **Add Trainer** | Admin (`trainers.create`) | `/admin/trainers/create` (`Routes.adminTrainersCreate`) | `admin-app-screens.md` §3 Add Trainer; `consolidated-screens.md` #44 | `app/lib/features/people/presentation/screens/add_trainer_screen.dart` |
| **Edit Trainer Profile** | Admin (`trainers.update`), Trainer (Self-edit) | `/admin/trainers/:id/edit` (`Routes.adminTrainersEdit`), `/trainer/profile/edit` (`Routes.trainerProfileEdit`) | `admin-app-screens.md` §3 Edit Trainer; `trainer-app-screens.md` §10 Edit Profile; `consolidated-screens.md` #03 | `app/lib/features/people/presentation/screens/edit_trainer_profile_screen.dart` |
| **My Trainer** (Assigned Profile) | Member (`trainers.read`) | `/home/profile/trainer` (`Routes.memberProfileTrainer`) | `member-app-screens.md` §7 My Trainer / Trainer Profile; `consolidated-screens.md` #02; `navigation-architecture.md` §2 Profile | `app/lib/features/people/presentation/screens/my_trainer_profile_screen.dart` |

*Sub-screens & Sibling Modules Note:*
- `Trainer Members` (Roster), `Trainer Schedule`, `Trainer Availability`, `Trainer Attendance`, and `Trainer Performance` listed in `admin-app-screens.md` §3 are handled by their respective domain feature modules (`features/scheduling`, `features/attendance`, `features/reports`, `features/people/presentation/screens/member_dossier_screen.dart`).
- Admin navigation to a trainer currently routes directly to `EditTrainerProfileScreen(isAdmin: true)` rather than a separate read-only detail view.

---

## 2. IA & navigation

- **Admin:** Accessed from `MoreHubScreen` (`/admin/more`) → `Routes.adminTrainers` (`/admin/trainers`). Floating action button (`+`) pushes `Routes.adminTrainersCreate`. Upon creation, `AddTrainerScreen` pops returning the new `trainerId`, causing the directory to reload and push `Routes.adminTrainersEditById(trainerId)`. Tapping any list item navigates to `/admin/trainers/:id/edit`.
- **Trainer:** Accessed via Profile tab (`Routes.trainerProfile` / `/trainer/profile`) → `ProfileTabScreen` link "Edit Profile" → `Routes.trainerProfileEdit` (`/trainer/profile/edit`), which renders `EditTrainerProfileScreen(trainerId: sessionProfileId, isAdmin: false)`.
- **Member:** Accessed via Profile tab (`/home/profile`) → link to `/home/profile/trainer` (`Routes.memberProfileTrainer`), rendering `MyTrainerProfileScreen(memberId: sessionProfileId)`. Includes a primary CTA button "Book Session" navigating to `Routes.memberScheduleBookPt` (`/home/schedule/book-pt`).
- **Push vs Master–Detail:** Unlike V1, `TrainersDirectoryScreen` does **not** employ a master–detail split pane at 840dp; directory items always push full-screen routes (`context.push`).
- **Pop Refresh:** `AddTrainerScreen` returns `state.created!.id` via `context.pop(id)`, allowing `TrainersDirectoryScreen` to reload its query and immediately navigate to edit mode. `EditTrainerProfileScreen` saves in place via cubit and shows a feedback SnackBar.

---

## 3. Catalogue pattern score

| Pattern | Score | Evidence |
| :--- | :---: | :--- |
| **Screens** (directory / detail / form) | **partial** | Directory, Add form, Edit form, and Member view exist; Admin lacks a separate read-only detail screen (routes directly to Edit form). Add and Edit forms are split across two files. |
| **List chrome** (AppBar, search, filter, ~200px paging) | **partial** | `trainers_directory_screen.dart` has AppBar title and search TextField; no filter sheet; pagination uses explicit "Load more" button rather than 200px scroll listener. |
| **Create entry** (AppBar `+` + `context.can`) | **partial** | Uses FloatingActionButton gated by `context.can('trainers.create')` instead of AppBar `+` action. |
| **Master–detail** (**840dp**) | **missing** | `TrainersDirectoryScreen` has no 840dp layout branch; always pushes full-screen routes. |
| **Filter sheet** → new list query | **missing** | Search text query supported; no filter bottom sheet or chips (e.g. specialization or active status filters). |
| **List item** pure render | **match** | `ListTile` renders `fullName`, `specializations` / ID, and active status chip/text; no fetch inside tile. |
| **Detail** + edit when update | **partial** | Member has `MyTrainerProfileScreen` with rate masking; Trainer/Admin route directly to `EditTrainerProfileScreen` with `trainers.update` check. |
| **Form** create/edit + denied body | **partial** | `AddTrainerScreen` and `EditTrainerProfileScreen` are separate; `EditTrainerProfileScreen` displays `PeopleStrings.noPermission` when `isAdmin && !context.can('trainers.update')`. |
| **Deactivate** confirm in edit | **partial** | Admin edits `_isActive` via `SwitchListTile` and saves via update mutation; no separate confirmation dialog. |
| **`UnsavedChangesScope`** | **partial** | Implemented on `AddTrainerScreen` (`UnsavedChangesScope(hasUnsavedChanges: dirty)`); missing on `EditTrainerProfileScreen`. |
| **Feature `*_strings.dart`** | **match** | `people_strings.dart` (`PeopleStrings`). |
| **Empty / error** feedback widgets | **different** | Uses shared `AppEmptyView`, `AppErrorView`, and `AppLoading` (V1 baseline used inline `Center`/`Text` and `TextButton`). |
| **Theme** `AppTheme` | **match** | Material 3 shared theme (`app/lib/core/theme/app_theme.dart`). |
| **`AdaptiveShell`** 600 / 1240 | **match** | Role shells utilize `AdaptiveShell` / standard shell breakpoints. |
| **Member** tab visibility | **match** | Member has no directory browsing tab; accesses assigned trainer profile via `/home/profile/trainer`. |

---

## 4. Design system

- **Theme:** Shared `app/lib/core/theme/app_theme.dart` (Material 3).
- **Strings:** Centralized `PeopleStrings` in `app/lib/features/people/presentation/people_strings.dart` (e.g., `trainersTitle`, `addTrainerTitle`, `myTrainerTitle`, `emptyTrainers`, `noAssignedTrainer`, `bookSession`).
- **Feedback widgets:**
  - Loading: Centered `AppLoading()`.
  - Empty states: `AppEmptyView(message: PeopleStrings.emptyTrainers)` in directory; `AppEmptyView(message: PeopleStrings.noAssignedTrainer)` in member view.
  - Errors: `AppErrorView(message: failureMessage(...), onRetry: ...)` when initial fetch fails; `SnackBar` for subsequent mutations or pagination failures.
  - Submitting: Inline `CircularProgressIndicator` inside `FilledButton` on forms.
  - *(Delta vs V1: V1 used inline Text/Buttons and avoided shared `AppEmptyView`/`AppErrorView`)*.
- **Domain Chrome:**
  - Add form features dynamic specialization tags using `InputChip` with deletion and text addition.
  - Member profile highlights rating star, active client capacity ratio, specialization chips, and a prominent "Book Session" CTA.

---

## 5. Responsive

- **Shell:** Uses `AdaptiveShell` (`AdaptiveShellBreakpoints.compact = 600`, `expanded = 1240`) across role navigation shells (bottom bar on mobile, compact rail on tablet, expanded rail on desktop).
- **Feature Breakpoint:** No feature-specific master–detail breakpoint (no 840dp split in `TrainersDirectoryScreen`). Screen content renders as a responsive single column / ListView across all display widths.

---

## 6. States

| State | Screen / Context | Behavior |
| :--- | :--- | :--- |
| **Loading (Initial)** | Directory, Edit, Member Profile | Centered `AppLoading()` when items/profile are null. |
| **Loading (Paging)** | Directory list bottom | "Load more" button shows `…` and disables user interaction. |
| **Empty** | Directory | `AppEmptyView(message: PeopleStrings.emptyTrainers)`. |
| **Empty (Assigned)** | Member My Trainer | `AppEmptyView(message: PeopleStrings.noAssignedTrainer)`. |
| **Error (Initial)** | Directory, Edit, Member Profile | Full-body `AppErrorView` with retry button. |
| **Error (Mutation)** | Add / Edit Forms | `SnackBar` displaying error string or mapped failure message. |
| **Submitting** | Add / Edit Forms | Buttons display progress spinner; duplicate submissions blocked (`alreadySubmitting`). |
| **Permission Denied** | Edit Trainer Profile | Centered `PeopleStrings.noPermission` text when `isAdmin && !context.can('trainers.update')`. FAB hidden on directory when `!can('trainers.create')`. |
| **Unsaved Changes** | Add Trainer | `UnsavedChangesScope` prevents accidental navigation when form is dirty. |
| **Deactivate (Inactive)** | Edit Trainer Form | Admin toggles `Active` switch; updates status on save. |

---

## 7. Role chrome

| Role | Directory Path | Create Action | Detail / Edit Access | Form Visibility & Controls |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | More → `/admin/trainers` | FAB visible if `trainers.create` | Opens `/admin/trainers/:id/edit` | Full edit form: includes `maxClientsCapacity` and `isActive` toggle. Denied body if `!trainers.update`. |
| **Trainer** | *(No directory route)* | — | Profile → `/trainer/profile/edit` | Self-edit mode: `maxClientsCapacity` and `isActive` toggle are hidden. |
| **Member** | *(No directory route)* | — | Profile → `/home/profile/trainer` | Read-only summary card: avatar, rating, active clients, specializations, "Book Session" CTA. Hourly rate masked. |

**Capability Call Sites:**
- `trainers_directory_screen.dart`: `context.can('trainers.create')` (controls FAB visibility).
- `edit_trainer_profile_screen.dart`: `context.can('trainers.update')` (enforces admin permission check).

---

## 8. Spec gaps

| Spec Reference | Spec Description | Implementation Status / Gap |
| :--- | :--- | :--- |
| `admin-app-screens.md` §3 | **Trainer Profile** (Detail Screen with tabs for Assigned Members, Schedule, Availability, Attendance, Performance) | Routed directly to `EditTrainerProfileScreen`. Ancillary sections are accessible through dedicated domain modules (Scheduling, Reports, Member Dossier). |
| `admin-app-screens.md` §3 | **Edit Trainer** (Hourly rates / commissions) | Profile includes `hourlyRate`; commission structures are not modeled in current UI/API. |
| `consolidated-screens.md` #44 | **Staff Directory & Roles** (Combined Trainer & Employee management) | Separated into `/admin/trainers` and `/admin/employees` routes. |
| Directory Filtering | Filter sheet for specialization and active/inactive status | Only text search (`q`) is implemented in UI search bar; filter sheet is missing. |
| Navigation Architecture §3 | Member browse trainers catalog | Intentionally omitted in favor of assigned trainer profile (`/home/profile/trainer`). |

---

## 9. Takeaways

Key UI deltas vs V1 Exercise Library baseline:

1. **Split Create and Edit Forms** — Unlike V1's single `ExerciseFormScreen`, Trainers splits creation (`AddTrainerScreen`) from modification (`EditTrainerProfileScreen`) due to 1-TX user credential handling (`email`, `password`) upon onboarding.
2. **Shared Feedback Widgets** — Utilizes `AppEmptyView`, `AppErrorView`, and `AppLoading` instead of V1's inline `Center`/`Text` components.
3. **No 840dp Master–Detail Split** — Directory does not implement an 840dp side-pane breakpoint, utilizing push navigation across all viewports.
4. **FAB for Creation** — Creation action uses a FloatingActionButton gated by `trainers.create` instead of an AppBar icon button.
5. **Inline Status Toggle without Confirm Dialog** — Deactivation is handled via a `SwitchListTile` in the edit form rather than a dedicated deactivate button with a confirmation popup.
6. **Partial `UnsavedChangesScope` Implementation** — `AddTrainerScreen` tracks dirty state via `UnsavedChangesScope`, but `EditTrainerProfileScreen` does not yet wrap its form in this scope.
7. **Role-Specific Member Detail Presentation** — `MyTrainerProfileScreen` provides a member-facing card with rate data masking and a direct "Book Session" CTA.
