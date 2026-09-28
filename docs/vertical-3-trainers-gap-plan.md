# Vertical 3 — Trainers: gap-fix plan

> Vertical: V3 Trainers (PEOPLE vertical, FR-PEOPLE-003 / FR-PEOPLE-007 / FR-PEOPLE-010).
> Mode: default. This file is the `/implement` handoff.
> Status: Planning / Ready for Implementation.
> Stack: `docs/vertical-3-trainers-implementation.md`
> UI: `docs/vertical-3-trainers-ui-design.md`
> Baseline: Vertical 1 Exercise Library soft-CRUD catalogue.

Scores synthesized from implementation §9 (including the delta-axis table) and UI §3 plus §9. Match rows (Nest layout, table schema, audit logging, offset pagination, Flutter Clean Architecture layers, shared M3 theme, `AdaptiveShell` breakpoints) are preserved as architectural alignments.

---

## 1. In scope

Fixes that close a **partial / different / missing** score or an operational edge-case identified during analysis:

| ID | Problem | Closes |
| :--- | :--- | :--- |
| **V3-G1** | `EditTrainerProfileScreen` lacks `UnsavedChangesScope`, risking lost edits on pop/back navigation | UI §3 `UnsavedChangesScope` **partial**; UI §9.6 |
| **V3-G2** | Deactivation in `EditTrainerProfileScreen` toggles `_isActive` via switch without confirmation dialog warning about client assignment impact | UI §3 Deactivate confirm in edit **partial**; UI §9.5 |
| **V3-G3** | `TrainersDirectoryScreen` uses manual "Load more" button instead of 200px scroll extent threshold paging listener | UI §3 List chrome **partial** |
| **V3-G4** | `TrainersDirectoryScreen` lacks active/inactive status filter chip / facet sheet | UI §3 Filter sheet **missing**; UI §8 Directory filtering |
| **V3-G5** | Self-update permission mismatch: `EditTrainerProfileScreen` allows non-admin trainer edit, but backend `PATCH /v1/trainers/:id` route is gated by `@RequirePermission('trainers.update')` | Stack Permissions **different**; UI §1 / §7 role chrome |
| **V3-G6** | Spec doc `admin-app-screens.md` §3 describes multi-tab trainer detail; app routes modularly to separate domain features (Scheduling, Attendance, Reports, Dossier) | UI §8 Spec gaps; Label/spec alignment |
| **V3-G7** | Directory list does not implement master–detail split pane at 840dp breakpoint | UI §3 Master–detail **missing**; Responsive §5 |

---

## 2. Out of scope (intentional)

| Delta | Why it stays |
| :--- | :--- |
| **Atomic 1-TX User + Profile Creation** | Unlike V1 standalone catalogue items, trainers require synced `users` and `trainers` records via `PersonFactory`. Evidence: `docs/vertical-3-trainers-implementation.md` §3 and Table Schema row. |
| **Admin-only `trainers.create`** | Product requirement: only staff/admin may onboard new trainers into the facility. Evidence: `apps/api/src/platform/db/seed/roles.ts`. |
| **Data Masking (`hourly_rate` stripped for members)** | Privacy & business rule (FR-PEOPLE-010). Members cannot inspect trainer billing rates. Evidence: `apps/api/src/people/trainer.service.ts` (`toResponse`). |
| **Row-Scoped Read Access** | Trainers can only inspect their own profile and assigned member roster (`assertPeopleRowScope`). Evidence: `apps/api/src/people/row-scope.ts`. |
| **Dynamic `assigned_active_count` Computation** | Roster metric calculated on-the-fly via `countAssignedMembersForIds` rather than denormalized state. Evidence: `apps/api/src/people/trainer.repository.ts`. |
| **Media Object Storage via Media MVP** | Trainers profile pictures and media use dedicated signed storage (`/media/*`) rather than direct external URLs. Evidence: `apps/api/src/platform/db/schema/trainers.ts`. |
| **Separate Sibling Verticals** | Member dossiers, employee administration, emergency contacts, PT schedule availability, and workout/diet plans remain in their respective modules. Evidence: `docs/vertical-3-trainers-implementation.md` §8 Boundaries. |

---

## 3. Work items

| ID | Fix | Primary paths | Acceptance | Depends on | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **V3-G1** | Wrap `EditTrainerProfileScreen` in `UnsavedChangesScope` tracking dirty form state against loaded `TrainerProfile` | `app/lib/features/people/presentation/screens/edit_trainer_profile_screen.dart` | Attempting to navigate back with modified fields prompts confirmation dialog. Clean form pops without prompt. Widget tests verify unsaved changes handling. | — | Ready |
| **V3-G2** | Add confirmation dialog when admin deactivates a trainer (`isActive = false`) explaining assignment implications | `app/lib/features/people/presentation/screens/edit_trainer_profile_screen.dart`, `app/lib/features/people/presentation/people_strings.dart` | Toggling `Active` switch off prompts confirm dialog with `PeopleStrings.deactivateTrainerConfirm`. Canceling reverts toggle. | — | Ready |
| **V3-G3** | Add `ScrollController` listener to `TrainersDirectoryScreen` triggering `loadMore()` when within 200px of scroll bottom | `app/lib/features/people/presentation/screens/trainers_directory_screen.dart` | Scrolling near end of list automatically requests next page when `hasMore` is true. Replaces/supplements manual button. | — | Ready |
| **V3-G4** | Add filter bar/sheet for status (`all` / `active` / `inactive`) in `TrainersDirectoryScreen` and pass filter to directory cubit | `app/lib/features/people/presentation/screens/trainers_directory_screen.dart`, `app/lib/features/people/presentation/cubit/trainers_directory_cubit.dart` | Admin can filter directory by active/inactive status. Query updates list view accordingly. | — | Ready |
| **V3-G5** | Align trainer self-edit permissions: update `TrainerController.update` to permit self-updates matching `assertPeopleRowScope` or document admin-only constraint | `apps/api/src/people/trainer.controller.ts`, `apps/api/src/people/trainer.service.ts` | Authenticated trainer can successfully save self-profile updates via `PATCH /v1/trainers/:id` when modifying own record without 403 Forbidden. | — | Ready |
| **V3-G6** | Update `docs/screens/admin-app-screens.md` §3 and `consolidated-screens.md` #44 to reflect domain-modular navigation architecture | `docs/screens/admin-app-screens.md`, `docs/screens/consolidated-screens.md` | Specs accurately document direct Edit navigation and linked domain modules (Scheduling, Attendance, Reports, Member Dossier). | — | Ready |
| **V3-G7** | Implement 840dp responsive master–detail view branch in `TrainersDirectoryScreen` | `app/lib/features/people/presentation/screens/trainers_directory_screen.dart` | At screen width >= 840dp, renders list pane on left and selected trainer edit/detail pane on right. | V3-G1 | Ready |

---

## 4. Verification

1. **Flutter Feature & Presentation Tests:**
   ```bash
   cd app && flutter test test/features/people/presentation/edit_trainer_profile_screen_test.dart
   cd app && flutter test test/features/people/presentation/trainers_directory_screen_test.dart
   cd app && flutter test test/features/people/presentation/add_trainer_screen_test.dart
   cd app && flutter test test/features/people/
   ```
2. **Backend People & Trainer Tests:**
   ```bash
   npm run test -- apps/api/src/people/trainer.service.spec.ts
   npm run test -- apps/api/src/people/row-scope.spec.ts
   npm run test:e2e -- apps/api/test/people-onboarding.e2e.spec.ts
   ```
3. **Manual / Web Sanity (Optional):**
   - Admin login → More Hub → Trainers Directory (`/admin/trainers`). Verify search, status filter, 200px infinite scroll, and 840dp split.
   - Create trainer → Verify redirect to edit.
   - Edit trainer → Test `UnsavedChangesScope` and deactivation confirmation dialog.
   - Trainer login → Profile → Edit Profile (`/trainer/profile/edit`). Verify self-edit submission.

---

## 5. Implement handoff

Fix Vertical 3 Trainers gaps outlined in `docs/vertical-3-trainers-gap-plan.md`: (V3-G1) wrap `EditTrainerProfileScreen` with `UnsavedChangesScope`; (V3-G2) add confirmation dialog on trainer deactivation with assignment warnings; (V3-G3) add 200px scroll threshold listener to `TrainersDirectoryScreen`; (V3-G4) introduce status filtering (`all`/`active`/`inactive`) in directory screen and cubit; (V3-G5) align `TrainerController.update` permission checking with `assertPeopleRowScope` for trainer self-updates; (V3-G6) reconcile `docs/screens/admin-app-screens.md` and `consolidated-screens.md` with the modular domain routing architecture; and (V3-G7) implement 840dp master–detail layout for tablet/desktop viewports. Do not alter 1-TX atomic creation, member hourly rate masking, or sibling vertical boundaries. Verify with `flutter test test/features/people/` and `npm run test -- apps/api/src/people/trainer.service.spec.ts`.
