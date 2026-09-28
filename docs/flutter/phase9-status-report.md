# Phase 9 Goals & Progress — status (2026-09-21)

## Implemented
- Clean Architecture feature `app/lib/features/goals` (domain / data / presentation)
- **Metrics** — admin CRUD at `/admin/goal-metrics` (`GoalMetricsAdminScreen`)
- **Goals** — member hub `/progress`; trainer member goals `/trainer/members/:id/goals` with create/edit (capability-gated); member cannot create
- **Check-ins** — `GoalDetailScreen` form (value / date / notes) via `checkInGoal` (member route + trainer push from hub)
- **Measurements** — history + create form; trainer add-measurement route; mandatory metric client validation (FR-GOAL-008)
- **Charts** — dependency-free `MetricChart` (`CustomPaint`) from measurement values over time
- **Progress photos** — gallery by pose, URL upload placeholder, privacy toggle, delete; **comparison** mode (date A/B × pose); trainer opens assigned-member gallery from hub
- **Privacy** — `filterPhotosForViewer` (owner / assigned trainer / `progress_photos.moderate`)
- **Notes / trainer assessments** — chronological stream; note type by role (`member_note` vs `trainer_assessment`); trainer compose from hub
- **Server-derived achievement** — UI shows server `status` + display-only `%` via `goalProgressFraction`; no client achievement writes
- `GOALApi` registered in DI next to `RPTApi`

## Architecture
- Domain: entities, helpers (`goal_progress`, `mandatory_metrics`, `photo_privacy`), repositories, usecases
- Data: `GoalsRemoteDataSource` → GOALApi; mappers; repository impls with `Either` + `mapThrownToFailure`
- Presentation: cubits (`@injectable`), screens, widgets, `goals_strings.dart`
- Presentation never imports `api_client`

## Routes wired
| Route | Screen |
| --- | --- |
| `/progress` | `ProgressHubScreen` |
| `/progress/goal/:id` | `GoalDetailScreen` |
| `/progress/measurements` | `MeasurementsScreen` |
| `/progress/photos` | `ProgressPhotosScreen` |
| `/progress/notes` | `ProgressNotesScreen` |
| `/trainer/members/:id/goals` | `ProgressHubScreen` (create enabled) |
| `/trainer/members/:id/goals/add-measurement` | `MeasurementsScreen` |
| `/admin/goal-metrics` | `GoalMetricsAdminScreen` |

## Tests (`app/test/features/goals/`)
- `goal_progress_test.dart`
- `mandatory_metrics_test.dart`
- `photo_privacy_filter_test.dart`
- `goals_list_cubit_test.dart`
- `measurements_cubit_test.dart`

All passed (`flutter test test/features/goals`). `flutter analyze lib/features/goals` — no issues.

## OPEN / blockers
- **Nest GOAL backend is not started** (GOA-* open). Live `GOALApi` calls may **404** until backend lands. Flutter client is forward-compatible against generated OpenAPI models.

## Recommended next
- Notifications (Phase inbox) or Nest GOAL (GOA-001+) so progress screens can load live data.
