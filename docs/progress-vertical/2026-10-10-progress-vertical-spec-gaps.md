# Progress vertical — spec gap plan

Snapshot: `main` @ `b137885`. Source: two-axis review of the Progress vertical (member tab, trainer dossier, admin dossier, admin Goal Metrics).

This plan fixes **Spec (a) missing, (b) scope creep, (c) wrong behaviour**. Standards constraints below are acceptance rules for those fixes, not a separate cleanup.

Register: [`20-progress-vertical-gap-register.md`](20-progress-vertical-gap-register.md).

`docs/flutter/10-goals-progress.md` stays the “first implementation exists” checklist. It is not this plan.

## Spec sources

| Source | What it requires |
| :--- | :--- |
| `docs/screens/member-app-screens.md` §10 | Overview, measurements + history, photos compare, notes, goal detail with dates and coach notes |
| `docs/screens/trainer-app-screens.md` §8 | Client goals, create/edit, tracking charts (weight, circumference, BMI), measurements, photos, notes, timeline |
| `docs/screens/admin-app-screens.md` §12 | Metric catalog (exists), gym-wide goals monitor, aggregate, measurements audit + archive, photo vault |
| `docs/screens/consolidated-screens.md` 38–41 | Member R on goals; Member E on measurements and own photo upload; Trainer E on goals/measurements/coach notes; Trainer R on photos; Admin F moderate |
| `docs/backend-frd.md` FR-GOAL-001–012, BR-GOAL-001–003 | Rules below override a screen line when they conflict |

Conflicts resolved here:

- FR-GOAL-003: members read goals and do not create or edit them. Screen 38 Member **R** agrees. The create/edit form stays off the member shell.
- FR-GOAL-005: a member may check in on **their own** in-progress goal. That is not goal create.
- FR-GOAL-006: a member may record **their own** measurement session. Screen 39 Member **E**.
- FR-GOAL-009: only the member uploads. Trainer reads assigned photos, including private ones. Admin moderate is delete/hide, not upload. Screen 40 agrees.
- FR-GOAL-001: metric catalog CRUD is admin. `goals.write` must not create metrics.
- “Priority” on the trainer create/edit screen has no column on `goals` and is not in FR-GOAL-002. It is deferred. Do not add a fake field.
- Admin §14 Progress Reports stays in the Reports vertical. Out of this plan.

## Acceptance rules (while touching these screens)

- ADR-0006 §8: cubit is created on the `GoRoute`, not inside `build()`.
- ADR-0006 §7: gates use `Capabilities.can`, plus shell (member / trainer / admin path). Drop `UserType` switches and `isTrainerContext = canCreateGoals`.
- ADR-0006 §6: goal create/edit is a `GoRoute`, not `MaterialPageRoute`.
- Photos, notes, measurements, and overview use the same nested routes on trainer and admin dossier stacks. `Navigator.push` of a member screen is not the trainer path.
- Role-variant widget tests pump `SessionCubit` for member, trainer, and admin on every screen whose actions change by role.

## Current blockers (do these before new screens)

Member role (`apps/api/src/platform/db/seed/roles.ts`) has `goals.read` and `goals.remarks` only. These endpoints require `goals.write`:

- `POST /members/:id/measurements` (FR-GOAL-006)
- `POST /members/:id/progress-photos` (FR-GOAL-009)
- `POST /goals/:id/check-ins` (FR-GOAL-005)

`GoalService.assertCanManageMemberGoal` already rejects member create/edit. Check-in uses `assertMemberAccess` only, so a member who passes the guard can check in on their own goal.

`POST/PATCH /goal-metrics` accepts `goals.create`, `goals.update`, or `goals.write`. A trainer with `goals.write` can create catalog rows. FR-GOAL-001 is admin CRUD.

`ProgressPhotoService.canViewPrivatePhotos` returns true for every `userType === 'admin'`. There is no `progress_photos.moderate` slug. The hub passes `isAssignedTrainer: true` whenever `canCreateGoals` is true, so admin dossier photos show private rows in the client filter too.

`GET /settings` is `settings.read` (admin). Members cannot read `mandatory_measurement_metrics`. The server already 422s a session that omits them (`measurement.service.ts`). The form never loads the ids (`mandatoryMetricIds` defaults to `[]`).

There is no gym-wide list for goals, measurements, or photos. Per-member routes cannot satisfy admin §12.

## Target route map

Member (`member_routes.dart`):

| Path | Screen |
| :--- | :--- |
| `/progress` | Hub. Chips: Goals (on page), Overview, Measurements, Photos, Notes |
| `/progress/overview` | Weight, body-composition, attendance |
| `/progress/measurements` | Latest values |
| `/progress/measurements/history` | Sessions + curves |
| `/progress/photos` | Compare |
| `/progress/notes` | Stream |
| `/progress/goal/:id` | Detail + check-in. No edit |

Trainer and admin dossier (same children under `.../goals`):

| Path | Screen |
| :--- | :--- |
| `goals` | Hub for that member |
| `goals/overview` | Tracking charts, including BMI |
| `goals/measurements` | Latest values |
| `goals/measurements/history` | History |
| `goals/measurements/new` | Record session (replace `add-measurement` query hack) |
| `goals/photos` | Read-only compare. Admin dossier: delete when moderate |
| `goals/notes` | Trainer assessment, or admin both types |
| `goals/timeline` | Goal histories + measurement sessions since join |
| `goals/goal/:goalId` | Detail: edit, check-in, record |
| `goals/goal/:goalId/edit` and `goals/new` | `GoalFormScreen` |

Admin More (new, next to existing `/admin/goal-metrics`):

| Path | Screen |
| :--- | :--- |
| `/admin/member-goals` | Active goals across members |
| `/admin/progress` | Aggregate counts |
| `/admin/measurements` | Audit table |
| `/admin/measurements/history` | Archive |
| `/admin/progress-photos` | Vault. Private rows only with `progress_photos.moderate` |

## Work

### 0. Contract

1. Metric create/update: admin only, permission `goals.create`. Drop `goals.write` from that guard.
2. Member seed: add `goals.write` so own measurement, own photo upload, and own check-in pass the guard. Goal create/edit stays rejected in `assertCanManageMemberGoal`.
3. Photo create: allow the member for their own `member_id` only. Reject trainer and admin upload (moderate is delete/hide).
4. Photo delete: owner may delete own; admin may delete only with `progress_photos.moderate`. Trainer delete stays forbidden (already).
5. Add slug `progress_photos.moderate`. Seed it on the admin role only. `canViewPrivatePhotos`: owner; assigned trainer; admin who holds the slug. Other admins get public photos only.
6. Check-in: member, assigned trainer, admin. Own or assigned scope. In-progress goals only. Still `recorded_value`, `recorded_date`, `notes`.
7. Measurement list/chart payload includes `mandatory_metric_ids` from `mandatory_measurement_metrics`, so the form does not need `settings.read`.
8. Notes: keep the service rules (member → `member_note` on self; trainer → `trainer_assessment` on assigned; admin → both). UI must offer only the types the service accepts.
9. Admin goal check-in and measurement record: admin is already allowed in `assertCanManageMemberGoal` and measurement service. The Flutter gate is what hides them. Fix the gate (section C). Do not add a second permission.

New admin list endpoints (pagination, `goals.read`, admin actor):

- `GET /goals?status=&metric_id=` across members
- `GET /measurements` audit rows (member, recorded_at, recorded_by, values)
- `GET /progress-photos` vault (same private filter as per-member list)
- `GET /progress/aggregate` small payload: active goals, achieved goals, members with a measurement in the last 30 days, photos in the last 30 days. No report export.

OpenAPI + `packages/api_client` regeneration is part of this step. Flutter calls the generated client only through repository mappers.

### A. Missing / partial

**A1 Overview.** Hub chip Overview opens `/progress/overview` (member) or `goals/overview` (trainer/admin). Charts come from the existing measurement chart API: weight and body-composition metrics (catalog category `body_composition`, plus circumference on the trainer tracking screen). Attendance is the existing attendance summary/history for that member (visit counts by week beside the weight series). The Charts chip stops opening measurements or add-measurement.

**A2 Measurements.** Summary shows the latest value for Weight, Body Fat %, Chest, Waist, Biceps, Thighs when those metric names exist. Matching is by metric name, not `metrics.take(3)`. History is the child route: session table and a curve per metric. `hasMore` pages the session list.

**A3 Trainer tracking.** Nested routes above. BMI = latest weight (kg) and `height_cm` from the member health profile. Missing height shows an empty line, not a computed number. Timeline lists goal histories and measurement sessions for that member, newest first.

**A4 Admin gym-wide.** More hub links to the five routes. Each list is the new endpoint, not N per-member calls. Vault uses the private filter. Goal Metrics screen stays the catalog CRUD (name, unit, category, `is_active`).

**A5 Goal detail and form.** Detail shows `startDate`, `targetDate`, status, progress bar, and `goal_histories`. Coach notes are that member’s `trainer_assessment` notes (notes are member-scoped, not goal-scoped). Trainer tracking shows projected vs actual: expected value is linear from baseline to target across start→target date; actual is `current_value`. Form fields stay metric, baseline, target, current, start, target, status. Priority is deferred.

**A6 Member check-in.** After contract step 2 and 6, member detail shows the check-in form when the goal is `in_progress`. Edit and “new goal” stay hidden (FR-GOAL-003).

**A7 Mandatory metrics.** Cubit reads `mandatory_metric_ids` from the measurement payload and marks those inputs. Submit still relies on the server 422.

**A8 Comparison.** Call `GET /members/:id/progress-photos/comparison?date1&date2`. Render front, side, and back for both dates. Drop the one-pose local pair.

**A9 Latest summary** is A2’s summary screen.

### B. Scope creep (remove)

**B1.** Remove hub chips Workout Plan and Diet Plan, and their strings and routes from `progress_hub_screen.dart`. Those destinations stay on their own tabs.

**B2.** Metric create/edit UI lives only on `GoalMetricsAdminScreen`. Remove create from `goal_metric_search_sheet.dart` (the trainer goal form). The sheet lists active metrics through `ListGoalMetricsUseCase`, not `getIt<GoalMetricsRepository>()`.

**B3.** Delete `[GoalsProbe]` `debugPrint` in `progress_hub_screen.dart` and `goals_list_cubit.dart`.

### C. Present but wrong

**C1 Photos.** Upload FAB only when shell is member and `goals.write` and the member id is the session profile. Trainer: no FAB, no delete. Admin: delete/hide when `progress_photos.moderate`. `isAssignedTrainer` is true only when the member’s `assigned_trainer_id` equals the trainer profile id.

**C2 Notes compose.** Member shell: `member_note` only. Trainer shell: `trainer_assessment` only. Admin shell: both. Default type follows the shell, not `UserType`.

**C3 Admin detail actions.** `resolveGoalViewActions`: admin shell with `goals.write` shows edit, record measurement, and check-in on in-progress goals. Trainer shell shows them only for the assigned trainer. Member shell shows check-in only. Record measurement uses the dossier `measurements/new` route on admin and trainer, and the member measurements route on the member shell. It must not always push `trainerMemberGoalsAddMeasurementById`.

**C4 Privacy flag.** Stop setting `isAssignedTrainer: true` from `canCreateGoals`. Admin without `progress_photos.moderate` does not receive private photos (server) and does not bypass the client filter.

## Tests

- API: member check-in own goal succeeds; member goal create 403; trainer photo upload 403; member photo upload own succeeds; admin without moderate omits private photos; admin with moderate lists them; metric create with only `goals.write` is 403; measurement missing mandatory id is 422; list payload includes the ids.
- Flutter: role-variant widget tests for hub, detail, form, measurements, photos, notes, goal metrics, and one admin monitor screen. Cubit tests for overview chart selection, comparison query params, note-type lock, and view actions.
- Router test: member has no `goals/new`; trainer hub Charts opens overview; admin More lists the new paths.

## Out of scope

- Reports → Progress report (`admin-app-screens.md` §14).
- Goal `priority` column.
- Rewriting use-case files into one file per class (ADR-0006 §9 example). Classes are already one per operation.
- Unchecking `docs/flutter/10-goals-progress.md`.

## Goal tap freeze

Runtime hang on the member dossier Goals screen. The list shows the goal. Tapping the card locks the app. This is not a spec gap. It does not wait on P0–C. Register section **E**.

`GoalService.createGoal` does not insert `goal_histories`. A goal that was just added has an empty history. `GoalHistorySection` then takes the empty-chart path and does not build `LineChart`. The lock on that tap is the hub gesture (E1). The chart (E2) locks later, once a series has a small x gap on a long span.

### E1. Router lookup off the gesture

`progress_hub_screen.dart` wraps the scaffold in a `Listener`. `onPointerDown` calls `GoRouterState.of(context)` and prints `[GoalsProbe]`. The card `onTap` calls `GoRouterState.of` again, prints the probe, then `await context.push(...)`. `GoRouterState.of` uses `dependOnInheritedWidgetOfExactType`, so the hub subscribes to the router during the pointer event. The push notifies the router and rebuilds the hub while the gesture is in flight.

Fix in `app/lib/features/goals/presentation/screens/progress_hub_screen.dart` and `app/lib/features/goals/presentation/cubit/goals_list_cubit.dart`:

1. Delete the `Listener`.
2. Delete every `[GoalsProbe]` `debugPrint`. That is register B3.1. B3.1 alone leaves the `GoRouterState.of` calls inside `onPointerDown` and `onTap`.
3. Read `GoRouterState.of(context).uri.path` in `_ProgressHubBody.build`. The tap pushes `Routes.adminMemberGoalById`, `Routes.trainerMemberGoalById`, or `Routes.memberProgressGoalById` from that path. The callback does not call `GoRouterState.of`.

The probe lines already in the tap tell which section you hit, before they are deleted:

- No `tap goal=` line: E1 (pointer-down lookup).
- `tap goal=` and the detail route never paints: E1 (push during the subscribed rebuild).
- Detail paints, then the app locks: E2.

### E2. Chart axis cannot walk epoch steps

`GoalHistorySection` and `MeasurementsScreen._chartSeries` set x to `millisecondsSinceEpoch` (~1.7e12). `appLineChartAxisInterval` returns the smallest positive gap, or `1` when there is a single x. `AppLineChart` passes that gap as `SideTitles.interval`. fl_chart `iterateThroughAxis` walks min to max by that interval, and the side-title widget builds one widget per step. A long span with one small gap runs that loop on the UI isolate until the app stops responding.

`goal_histories.recorded_date` is a date. Two different days are at least one day apart, so goal history alone is a hitch. `MeasurementsScreen` uses session `recordedAt` timestamps on the same `AppLineChart`. A pair one second apart across a month is enough to stop the UI. A single point stays one step only while min x equals max x. Callers still leave epoch milliseconds.

Fix:

1. `appLineChartAxisInterval` (`app/lib/core/widgets/app_line_chart.dart`): when `span / minGap` is greater than 6, return `span / 6`. fl_chart then takes a handful of steps. Keep the filter that draws a title only when the value is a data x.
2. `goal_history_section.dart` and `measurements_screen.dart` `_chartSeries`: plot x as days from the first date. Format the label with that date. Do not pass `millisecondsSinceEpoch`.

### E3. Test

- `appLineChartAxisInterval` on three epoch x values — closest gap 1 second, span 30 days — returns at least `span / 6`.
- A widget test pumps `GoalHistorySection` with those three points and finishes.
- The existing `AppLineChart` test uses x = 0, 1, 2. It stays green without this fix, so it is not the guard.
