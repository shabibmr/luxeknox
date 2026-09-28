# Pending Screens — Implementation Task List

Status snapshot as of 2026-09-21. Excludes Payments screens per prior scope decision.

Implemented via three parallel workers: `agy` (Member role), `grok` (Trainer role), and a
Claude subagent (Admin/Office role). Centralized `build_runner` + `flutter analyze` +
`flutter test` pass run afterward by the orchestrator.

## In progress / next up

- [x] Wire `ScheduleHistoryScreen` into `member_routes.dart` (`/schedule/history` → `ScheduleHistoryScreen(role: ScheduleCalendarRole.member, memberId: ...)`)
- [x] Wire `ScheduleHistoryScreen` into `trainer_routes.dart` (`/trainer/schedule/history` → `ScheduleHistoryScreen(role: ScheduleCalendarRole.trainer, trainerId: ...)`)
- [x] Run `dart run build_runner build --delete-conflicting-outputs` once, after all new `@injectable` classes for this batch exist, to register `ScheduleHistoryCubit` (and any others) in `injector.config.dart`

## Member role

- [x] Edit Profile Screen — `/profile/edit` (form-based, pattern: `health_info_screen.dart`, usecases: `update_member_usecase.dart`, `set_avatar_usecase.dart`)
- [x] Meal Details Screen — `/home/diet/meal/:id`
- [x] My Trainer Profile Screen — `/profile/trainer` (entity: `trainer_summary.dart`)

## Trainer role

- [x] Edit Profile Screen — `/trainer/profile/edit`
- [x] Today's Sessions Screen — `/trainer/sessions/today` (`ListSchedulesUseCase` filtered to today)
- [x] Client Schedule View — `/trainer/members/:id/schedule` (reused `ScheduleCalendarScreen` with explicit `memberId`)

## Admin / Office role

- [x] Gym Settings Screens (all categories) — `/admin/settings/:category` (new `features/settings` module; categories mirror backend `SettingCategory` enum)
- [x] Add Member Onboarding Wizard — `/admin/members/add` (3-step wizard, mounted in `admin_routes.dart`)
- [x] Edit Member Screen — `/admin/members/:id/edit` (reuses `update_member_usecase.dart`)
- [x] System Alerts & Notifications Screen — `/admin/alerts` (new `features/alerts` module, backed by existing audit-log endpoint — see note below)
- [x] Staff Role & Permission Assignment — `/admin/employees/:id/roles` (used existing RBAC API infra: `RBACApi`, `Role`, `Permission`, `AssignRoleRequest`)

## Final

- [x] `flutter analyze` clean — 0 errors/warnings (11 pre-existing `info`-level lint suggestions remain, none from this batch)
- [ ] Manual golden-path test of each new screen (emulator/browser) — not yet done

## Verification notes (this pass)

- `flutter test`: 14 failing tests, identical to the pre-existing baseline on `main` before this
  batch (verified via `git stash` diff) — no regressions from Member/Trainer/Admin work.
- One real regression was caught and fixed: `TodaysSessionsScreen` replaced a DI-free placeholder
  route with a real `TodaysSessionsCubit`-backed screen, which broke
  `test/core/router/app_router_test.dart`'s `/trainer/sessions/today` reachability test (GetIt
  registration missing in the test's `setUp`). Fixed by registering a mock
  `TodaysSessionsCubit`/`ListSchedulesUseCase` there, matching the existing `DashboardCubit` pattern.
- Also fixed a pre-existing (unrelated) test bug: `session_usecases_test.dart`'s `LogoutUseCase`
  test only passed 1 constructor arg where 2 are required (repository + `UnregisterDeviceOnLogoutUseCase`).
- Fixed a minor bug introduced in `ScheduleHistoryScreen`: the "loading more" footer spinner was
  keyed only on `hasMore`, so it showed permanently instead of only while a page fetch is in flight;
  now gated on `hasMore && loadingMore`.

## Scope decisions from this batch

- Settings categories mirror the backend `SettingCategory` enum (general, membership,
  attendance_gate, booking_rules, billing, workout, diet, notification, measurement) rather than
  inventing new UI-only categories; the legacy `more_hub_screen.dart` `'gym'` alias now maps to `general`.
- System Alerts screen uses the existing audit-log endpoint (`SYSApi.listAuditLogs`) since there is
  no dedicated "alerts" endpoint — flagged in case the intended semantics differ from an audit feed.
  Broadcast push notifications already have their own screen at `/admin/notifications/broadcast`,
  unaffected by this change.

## Notes

- Follow existing shared-screen-per-role pattern (`WorkoutHistoryScreen`, `DietHistoryScreen`) rather than inventing new role enums where one already fits.
- Route path constants for all screens above already exist in `core/router/routes.dart`.
