# FILE: 20-progress-vertical-gap-register.md
## Progress vertical spec gaps

Source plan: [`2026-10-10-progress-vertical-spec-gaps.md`](2026-10-10-progress-vertical-spec-gaps.md).

Snapshot `main` @ `b137885`. Status markers: `[ ]` open, `[x]` done. **deferred** is a decision, not a skipped bug.

Each task lists its direct `deps`. Do not start a task until every id in that line is `[x]`. Follow the chain for earlier work. A group id is done when every task in the group is `[x]`.

---

### P0 Contract (blocks member writes, privacy, and admin lists)

#### P0.1 Metric catalog is admin CRUD
- [x] P0.1.1 `POST/PATCH /goal-metrics` require `goals.create` and `userType === 'admin'`
  deps: none
- [x] P0.1.2 Service test: trainer with `goals.write` receives 403
  deps: P0.1.1
- [x] P0.1.3 OpenAPI permission notes match the guard
  deps: P0.1.1

#### P0.2 Member own writes
- [x] P0.2.1 Member role seed includes `goals.write`
  deps: P0.1.1
- [x] P0.2.2 `assertCanManageMemberGoal` still rejects member create and edit (FR-GOAL-003)
  deps: none
- [x] P0.2.3 Photo create allows the member for their own id only; trainer and admin upload return 403 (FR-GOAL-009)
  deps: P0.2.1
- [x] P0.2.4 Check-in allows member on own in-progress goal, assigned trainer, and admin (FR-GOAL-005)
  deps: P0.2.1
- [x] P0.2.5 Measurement create still allows member on self, assigned trainer, admin on any (FR-GOAL-006)
  deps: P0.2.1

#### P0.3 Private photos and moderate slug
- [x] P0.3.1 Seed slug `progress_photos.moderate` on the admin role only
  deps: none
- [x] P0.3.2 `canViewPrivatePhotos`: owner, assigned trainer, or admin holding the slug (FR-GOAL-012)
  deps: P0.3.1
- [x] P0.3.3 Delete: owner, or admin with `progress_photos.moderate`. Trainer delete stays 403
  deps: P0.3.1
- [x] P0.3.4 Tests for admin with and without the slug
  deps: P0.3.2, P0.3.3

#### P0.4 Mandatory metric ids on the measurement payload
- [x] P0.4.1 `GET` measurement list and chart include `mandatory_metric_ids` from `mandatory_measurement_metrics`
  deps: none
- [x] P0.4.2 API test: configured ids `[1,2]` appear on the list response; a session missing one is 422
  deps: P0.4.1

#### P0.5 Admin list endpoints
- [x] P0.5.1 `GET /goals` paginated, admin, optional `status` and `metric_id`
  deps: none
- [x] P0.5.2 `GET /measurements` audit page (member, recorded_at, recorded_by, values)
  deps: none
- [x] P0.5.3 `GET /progress-photos` vault page, same private filter as P0.3
  deps: P0.3.2
- [x] P0.5.4 `GET /progress/aggregate` counts: active goals, achieved goals, members measured in 30 days, photos in 30 days
  deps: none
- [x] P0.5.5 Regenerate OpenAPI and `packages/api_client`. Map in `features/goals/data` only
  deps: P0.5.1, P0.5.2, P0.5.3, P0.5.4

---

### A Missing / partial

#### A1 Progress Overview
- [x] A1.1 Routes: `/progress/overview`, trainer `goals/overview`, admin dossier `goals/overview`
  deps: none
- [x] A1.2 Cubit on the `GoRoute` (ADR-0006 §8)
  deps: A1.1
- [x] A1.3 Charts: weight and `body_composition` from the measurement chart API
  deps: A1.2
- [x] A1.4 Attendance: weekly visit counts from the existing attendance summary for that member
  deps: A1.2
- [x] A1.5 Hub Overview chip opens this route. Charts chip opens this route, not measurements and not add-measurement
  deps: A1.1, B1.1
- [x] A1.6 Widget test, member and trainer
  deps: A1.3, A1.4, A1.5

#### A2 Measurements summary and history
- [ ] A2.1 Latest-value block for Weight, Body Fat %, Chest, Waist, Biceps, Thighs by metric name
  deps: none
- [ ] A2.2 Chart lists every metric returned, not `metrics.take(3)`
  deps: none
- [ ] A2.3 History child route on member, trainer, and admin dossier: session table + curve per metric
  deps: none
- [ ] A2.4 Session list uses `hasMore` / next cursor
  deps: A2.3
- [ ] A2.5 Cubit created on the route
  deps: A2.1, A2.3
- [ ] A2.6 Widget test: empty metrics, three named metrics, second page
  deps: A2.1, A2.2, A2.4, A2.5

#### A3 Trainer / admin dossier tracking
- [ ] A3.1 Nested routes: `photos`, `notes`, `timeline`, `measurements/new`, `goal/:goalId/edit`, `new`
  deps: none
- [ ] A3.2 Photos and notes use those routes. Remove `Navigator.push` of the member screens from the hub
  deps: A3.1
- [ ] A3.3 BMI from latest weight (kg) and health `height_cm`. Missing height is an empty state
  deps: A1.3
- [ ] A3.4 Timeline: goal histories and measurement sessions, newest first
  deps: A3.1
- [ ] A3.5 `GoalFormScreen` is only reached by `goals/new` and `goals/goal/:goalId/edit`
  deps: A3.1

#### A4 Admin gym-wide screens
- [ ] A4.1 More links: Member Goals, Progress aggregate, Measurements audit, History archive, Progress Photos vault
  deps: P0.5.5
- [ ] A4.2 Each screen calls the P0.5 endpoint for that list
  deps: A4.1
- [ ] A4.3 Vault hides private photos unless `progress_photos.moderate`
  deps: A4.2, P0.3.2
- [ ] A4.4 Goal Metrics screen unchanged in purpose (name, unit, category, active)
  deps: B2.3
- [ ] A4.5 Widget test for the goals monitor empty and one row; vault with moderate on and off
  deps: A4.2, A4.3

#### A5 Goal detail extras
- [ ] A5.1 Detail shows start date, target date, status, progress bar, histories
  deps: none
- [ ] A5.2 Coach notes section lists that member’s `trainer_assessment` notes
  deps: none
- [ ] A5.3 Trainer and admin detail show projected (linear baseline→target over start→target date) and actual (`current_value`)
  deps: A5.1
- [ ] A5.4 **deferred** — priority. No `goals.priority` column and not in FR-GOAL-002. Do not add a form control
  deps: none

#### A6 Member check-in
- [ ] A6.1 Member detail shows check-in when status is `in_progress` and the goal is theirs
  deps: P0.2.4, A5.1, C3.1
- [ ] A6.2 Member detail hides edit and create
  deps: C3.1, A3.5
- [ ] A6.3 Cubit test: check-in success updates `current_value` and history
  deps: A6.1

#### A7 Mandatory metrics in the form
- [ ] A7.1 `MeasurementsCubit` stores `mandatory_metric_ids` from the payload
  deps: P0.4.1, A2.5
- [ ] A7.2 Form marks those metrics required before submit
  deps: A7.1
- [ ] A7.3 Cubit test: ids from the payload replace the default `[]`
  deps: A7.1

#### A8 Photo comparison
- [ ] A8.1 Compare calls `GET .../progress-photos/comparison` with two dates
  deps: A3.2, P0.3.2
- [ ] A8.2 Layout is front, side, and back for date1 and date2
  deps: A8.1
- [ ] A8.3 Cubit test: query params and empty pose slots
  deps: A8.1, A8.2

---

### B Scope creep

#### B1 Hub links that are not progress
- [x] B1.1 Remove Workout Plan and Diet Plan chips from `ProgressHubScreen`
  deps: none
- [x] B1.2 Remove the matching strings if nothing else references them
  deps: B1.1
- [x] B1.3 Widget test: hub does not show those labels
  deps: B1.1

#### B2 Metric create only on the admin catalog
- [x] B2.1 Goal metric search sheet has no create action
  deps: P0.1.1
- [x] B2.2 Sheet loads metrics via `ListGoalMetricsUseCase`
  deps: none
- [x] B2.3 Create/edit stays on `GoalMetricsAdminScreen`, gated by `goals.create`
  deps: P0.1.1, B2.1

#### B3 Debug probe
- [x] B3.1 Remove `[GoalsProbe]` logs from `progress_hub_screen.dart` and `goals_list_cubit.dart`
  deps: none (same deletion as E1.3; mark both `[x]` when either lands)

---

### C Wrong behaviour

#### C1 Photo actions
- [ ] C1.1 Upload FAB only on the member shell, own member id, `goals.write`
  deps: P0.2.3, A8.2, C4.1
- [ ] C1.2 Trainer photos: no upload, no delete
  deps: P0.2.3, P0.3.3, A8.2
- [ ] C1.3 Admin delete shown only with `progress_photos.moderate`
  deps: P0.3.3, A8.2
- [ ] C1.4 Role-variant widget test (extend `progress_photos_role_variants_test.dart`)
  deps: C1.1, C1.2, C1.3, C4.3

#### C2 Note types
- [ ] C2.1 Member compose offers `member_note` only
  deps: C2.4
- [ ] C2.2 Trainer compose offers `trainer_assessment` only
  deps: C2.4
- [ ] C2.3 Admin compose offers both
  deps: C2.4
- [ ] C2.4 Default type comes from the shell, not `UserType`
  deps: A3.2
- [ ] C2.5 Role-variant widget test
  deps: C2.1, C2.2, C2.3

#### C3 Detail actions and record route
- [x] C3.1 `resolveGoalViewActions` uses shell + `goals.write` + assigned-trainer flag. Remove `isTrainerUser` / `UserType`
  deps: none
- [ ] C3.2 Admin in-progress goal: edit, check-in, record measurement
  deps: C3.1
- [ ] C3.3 Trainer: those actions only when assigned and `goals.write`
  deps: C3.1, C4.1
- [ ] C3.4 Record measurement route: member measurements, trainer `measurements/new`, admin `measurements/new`
  deps: C3.1, A3.1
- [ ] C3.5 Unit tests in `goal_view_actions_test.dart` plus a detail widget test per shell
  deps: C3.2, C3.3, C3.4, A6.1, A6.2

#### C4 Assigned-trainer flag
- [x] C4.1 `isAssignedTrainer` is true only when `assigned_trainer_id` matches the session trainer profile
  deps: P0.3.2
- [x] C4.2 Delete `isTrainerContext = canCreateGoals` on the hub
  deps: C4.1
- [x] C4.3 Admin without moderate does not set a client bypass that shows private photos
  deps: C4.2, P0.3.2

---

### Done when

- [ ] D1 Register sections P0, A, B, C are `[x]` except A5.4 (stays deferred)
  deps: P0.1, P0.2, P0.3, P0.4, P0.5, A1, A2, A3, A4, A5.1, A5.2, A5.3, A6, A7, A8, B1, B2, B3, C1, C2, C3, C4
- [ ] D2 `flutter test` for `app/test/features/goals` and the new router cases
  deps: A1.6, A2.6, A3.2, A3.3, A3.4, A3.5, A4.5, A5.2, A5.3, A6.3, A7.3, A8.3, B1.3, B2.3, B3.1, C1.4, C2.5, C3.5, C4.3
- [ ] D3 API goal/progress service specs for P0.1–P0.5
  deps: P0.1, P0.2, P0.3, P0.4, P0.5

---

### E Goal tap freeze

Runtime hang. Not a spec gap. Plan: [Goal tap freeze](2026-10-10-progress-vertical-spec-gaps.md#goal-tap-freeze). Does not wait on P0–C. D1 does not include this section.

A goal just created has no `goal_histories` row. The empty chart is not the lock on that tap. E1 is. E2 locks once a series has a small x gap on a long span (measurement timestamps, or a later check-in range).

#### E1 Router lookup off the gesture
- [x] E1.1 Delete the hub `Listener`. `onPointerDown` must not call `GoRouterState.of`
  deps: E1.2
- [x] E1.2 Read the path in `_ProgressHubBody.build`. Card `onTap` pushes the detail location and does not call `GoRouterState.of`
  deps: none
- [x] E1.3 Delete `[GoalsProbe]` in `progress_hub_screen.dart` and `goals_list_cubit.dart` (same change as B3.1). Mark B3.1 `[x]` when this lands
  deps: E1.1, E1.2

#### E2 Chart axis
- [x] E2.1 `appLineChartAxisInterval` returns at least `span / 6` when the smallest gap would take more than 6 steps
  deps: none
- [x] E2.2 `GoalHistorySection` and `MeasurementsScreen._chartSeries` plot days from the first date, not `millisecondsSinceEpoch`
  deps: none
- [x] E2.3 Widget test: epoch x values (1 second gap, 30 day span) stay at or above `span / 6`, and `GoalHistorySection` with those three points finishes pumping
  deps: E2.1, E2.2

#### E3 Done when
- [x] E3.1 E1 and E2 are `[x]`
  deps: E1.3, E2.3
- [x] E3.2 `flutter test` for `app/test/core/widgets/app_line_chart_test.dart` and `app/test/features/goals/goal_detail_screen_test.dart`
  deps: E3.1
