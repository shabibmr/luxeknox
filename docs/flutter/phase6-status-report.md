# Phase 6 Workout — status (2026-09-21)

## Implemented (first 5)
- Clean Architecture feature `features/workout` (domain / data / presentation)
- Reuses `GetExercisesUseCase` for exercise picker (no exercise CRUD duplication)
- **Plan list** — `/trainer/plans/workouts/history` with client-side status filters (all/draft/active/archived)
- **Plan detail** — `/trainer/plans/workouts/:id` metadata + exercises by day; Edit / Publish (draft) / Archive
- **Plan builder** — create `/trainer/plans/workouts/create`; edit `/trainer/plans/workouts/:id/edit`
- **Exercise picker** — modal sheet search via Exercise Library use case
- **Ordering** — `ReorderableListView` within day; move-to-day; `orderIndex` renumbered
- **Publish** — `WORKApi.publishWorkoutPlan`
- **Archive** — forward-compatible `POST /workout-plans/{id}/archive` via Dio (not on generated WORKApi yet; WRK-007)
- Route capability gates: create + edit → `workouts.write` (list/detail ungated beyond role)

## Implemented (second 5)
- **Template copy** — detail “Assign to member” (member id dialog) → `WORKApi.assignWorkoutPlan`; snackbar + navigate to assigned plan
- **Versions** — `/trainer/plans/workouts/:id/versions` list with expand for exercise snapshot; `listWorkoutPlanVersions`
- **Live session** — member `/home/workout/active` (`ActiveWorkoutScreen`); optional `?workoutPlanId=`; `sessionProfileId` as memberId
- **Set logging** — `LogWorkoutSetUseCase` / `WORKApi.logWorkoutSet`; appends local sets
- **Rest timer** — client-only `RestTimerCubit`/`RestTimerWidget`; default from plan exercise `restSeconds` (fallback 60); Cancel / Skip / +15s
- New `WorkoutSessionRepository` + datasource; plan repo extended with `assign` + `listVersions`

## Implemented (final 4)
- **Completion** — confirm dialog with optional notes + 1–5 rating; richer summary (duration, volume, set count, times); forward-compat complete body when notes/rating present; CTA to history
- **History** — `ListWorkoutSessionsUseCase` + `WorkoutHistoryCubit`/`WorkoutHistoryScreen` (paginated `GET /workout-sessions`)
- **Volume/PR** — session volume on list tiles; client-side `computePersonalRecords` (max weight per exercise) + total volume on history screen
- **Role variants** — `WorkoutHistoryRole` member `/home/workout/history`, trainer `/trainer/members/:id/workout-history`, admin `/admin/members/:id/workout-history`

## Checklist
- [x] plan list/detail
- [x] plan builder
- [x] exercise picker
- [x] ordering
- [x] publish/archive
- [x] template copy
- [x] versions UI
- [x] live session
- [x] set logging
- [x] rest timer
- [x] completion
- [x] history / volume / PR
- [x] role variants

## Tests
- `test/features/workout/workout_plan_list_cubit_test.dart`
- `test/features/workout/workout_plan_builder_cubit_test.dart`
- `test/features/workout/workout_plan_detail_cubit_test.dart` (includes assign)
- `test/features/workout/workout_plan_versions_cubit_test.dart`
- `test/features/workout/active_workout_cubit_test.dart` (complete + notes/rating)
- `test/features/workout/rest_timer_cubit_test.dart`
- `test/features/workout/workout_history_cubit_test.dart` (load/loadMore/PRs)
- Router capability coverage for workouts create/edit; versions + history route constants

## OPEN / blockers
- Nest `WRK` module still open — live API calls will 404 until backend WRK tickets land
- Archive and complete-with-feedback endpoints are forward-compatible client-side until OpenAPI/WORKApi regenerates

## Recommended next
Phase 6 Diet (or remaining Payments items skipped earlier)
