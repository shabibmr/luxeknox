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

## Checklist
- [x] plan list/detail
- [x] plan builder
- [x] exercise picker
- [x] ordering
- [x] publish/archive
- [ ] template copy
- [ ] versions UI (detail reads `current_version` exercises only)
- [ ] live session
- [ ] set logging
- [ ] rest timer
- [ ] completion
- [ ] history / volume / PR
- [ ] role variants beyond trainer primary

## Tests
- `test/features/workout/workout_plan_list_cubit_test.dart`
- `test/features/workout/workout_plan_builder_cubit_test.dart`
- `test/features/workout/workout_plan_detail_cubit_test.dart`
- Router capability coverage for workouts create/edit

## OPEN / blockers
- Nest `WRK` module still open — live API calls will 404 until backend WRK tickets land
- Archive endpoint is forward-compatible client-side only until OpenAPI/WORKApi regenerates

## Recommended next
Template copy + versions UI, then live session / set logging
