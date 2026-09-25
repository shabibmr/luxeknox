# Flutter standards 1–4 (ADR-0006 §4, §5, §8, §11)

Fix the first four Standards findings from the main-branch Flutter review. Work on the working tree. Do not revert uncommitted scheduling edits.

## Out of scope

- SessionState stays a sealed identity union (`SessionUnknown` / `SessionAuthenticated` / `SessionUnauthenticated`). §5 is about keeping list data on screen during refresh, and the router switches on this union.
- Standards findings 5–9 (api_client leakage, data→presentation imports, `context.select`, missing `@injectable` on people cubits, bundled use-case files).
- Spec findings (POS, dashboard cards, reschedule, settings matrix).
- Single-class Equatable states that are not sealed and were not named in finding 1: `DashboardState`, `RestTimerState`, `DietDailyLogState`, `AddMemberWizardState`, `ExerciseDetailState`, `FoodDetailState`.

## Shared shape

[NEW] `app/lib/core/presentation/load_status.dart` — `enum LoadStatus { initial, loading, success, failure }`.

[NEW] `app/lib/core/bloc/event_transformers.dart` — debounce (moved out of the private copies), plus `droppable` and `sequential` behavior. Add `bloc_concurrency` to `app/pubspec.yaml` and call its `droppable()` / `sequential()` rather than a third hand-rolled transformer. Point exercise and food list blocs at the shared debounce.

Each converted state is one `@freezed` class:

```dart
@Default(LoadStatus.initial) LoadStatus status,
// previous items / entity stay populated
Failure? failure,
```

Refresh emits `status: loading` and does not clear items. First load is `loading` with empty data. Failure keeps the last success payload and sets `failure`.

`@injectable` factory cubits/blocs. `build_runner` once at the end (`--delete-conflicting-outputs`) for freezed + injectable.

## 1. Sealed Loading/Loaded/Failure → status field

[MODIFY] every sealed state below, and the screen/widget that switches on its subtypes (`is XLoading` → `state.status`).

- people: `members_directory_cubit`, `trainers_directory_cubit`, `employees_directory_cubit`, `member_dossier_cubit`, `edit_member_cubit`, `edit_profile_cubit`, `edit_trainer_profile_cubit`, `my_trainer_profile_cubit`, `employee_roles_cubit`, `documents_cubit`, `photos_cubit`, `emergency_contacts_cubit`, `health_info_cubit`, `medical_history_cubit`
- membership: `memberships_directory_cubit`, `create_membership_cubit`
- scheduling: `schedule_detail_cubit`, `schedule_calendar_cubit`, `schedule_history_cubit`, `todays_sessions_cubit`, `trainer_availability_cubit`, `facilities_cubit`
- attendance: `AttendancePassState`, `CheckInCubitState`, `AttendanceHistoryState`, `AttendanceSummaryState`, `LiveFeedState` in `attendance_pass_cubit.dart` and `attendance_history_cubit.dart`
- workout: `workout_plan_list_cubit`, `workout_plan_detail_cubit`, `workout_plan_builder_cubit`, `workout_plan_versions_cubit`, `workout_history_cubit`, `active_workout_cubit`
- diet: `diet_plan_list_cubit`, `diet_plan_detail_cubit`, `diet_plan_builder_cubit`, `diet_plan_versions_cubit`, `diet_history_cubit`, `diet_meal_detail_cubit`
- goals: `goals_list_cubit`, `goal_detail_cubit`, `goal_form_cubit`, `goal_metrics_admin_cubit`, `measurements_cubit`, `progress_notes_cubit`, `progress_photos_cubit`
- payments: `payments_ledger_cubit`, `payment_detail_cubit`, `payment_methods_cubit`, `outstanding_dues_cubit`
- notifications: `notifications_inbox_cubit`, `notification_detail_cubit`, `broadcast_cubit`
- reports: `report_cubit`
- settings: `settings_category_cubit`
- alerts: `system_alerts_cubit`

Also rewrite the hand-written status states the review named, onto the same `@freezed` + `LoadStatus` shape:

- [MODIFY] `exercise_list_state.dart`, `food_list_state.dart`
- [MODIFY] `login_cubit.dart`, `forgot_password_cubit.dart`, `reset_password_cubit.dart`, `change_password_cubit.dart` (keep submit flags; map their local status enum onto `LoadStatus`)

## 2. EventTransformer where §4 names one

Cubit method + in-flight flag is not the transformer.

| Case | Becomes | Transformer |
| :--- | :--- | :--- |
| Members directory search (`MembersDirectoryCubit.load`) | [MODIFY] `members_directory_bloc.dart` | debounce 300ms, same duration as exercise/food search |
| Check-in submit (`CheckInCubit.submit`) | [MODIFY] check-in bloc in `attendance_pass_cubit.dart` (split file if the pass cubit stays a cubit) | `droppable()` |
| Live set logging (`ActiveWorkoutCubit.logSet`) | [MODIFY] `active_workout_bloc.dart` | `sequential()` |
| Create membership submit | [MODIFY] `create_membership_bloc.dart` | `droppable()` |
| Book schedule (`_BookAction._book` in `book_schedule_screen.dart`) | [NEW] `book_schedule_bloc.dart` | `droppable()` |

Pass load, attendance history, and schedule detail stay cubits (no ordering requirement). Delete the `actionInFlight` early-returns those blocs replace.

Update route `BlocProvider` call sites that today do `getIt<MembersDirectoryCubit>()..load()` / `getIt<CheckInCubit>()` / `ActiveWorkout` construction / create-membership / book screen.

## 3. Server state leaves the widget

These call use cases through `getIt` and `setState`. Each gets an `@injectable` cubit (or the bloc from §2) provided at the route. Widgets only `context.read` / `BlocBuilder`.

[NEW] cubits + [MODIFY] callers:

- `membership_detail_cubit.dart` ← `membership_detail_screen.dart` (load, approve, reject, freeze, cancel)
- `membership_history_cubit.dart` ← `membership_history_screen.dart`, `membership_history_list.dart`
- `membership_freeze_cubit.dart` ← `membership_freeze_history_screen.dart`, `membership_freeze_list.dart`
- `membership_card_cubit.dart` ← `membership_card_screen.dart`
- `trainer_membership_summary_cubit.dart` ← `trainer_membership_summary_screen.dart`
- `membership_packages_catalog_cubit.dart` ← `membership_packages_catalog_screen.dart`
- `membership_product_form_cubit.dart` ← `membership_product_form_screen.dart`
- `exercise_form_cubit.dart` ← `exercise_form_screen.dart`
- `food_form_cubit.dart` ← `food_form_screen.dart`
- `exercise_picker_cubit.dart` ← `exercise_picker_sheet.dart`
- `food_picker_cubit.dart` ← `food_picker_sheet.dart`

Form dirty flags and sheet-local selection may stay in the widget. Anything that hits a repository or use case moves.

## 4. Role-variant widget tests

Copy the pump + seeded `SessionCubit` pattern in `app/test/features/exercises/presentation/exercise_role_variants_test.dart`. One test per applicable role. Assert the capability-gated control, not the whole screen.

[NEW]

- `app/test/features/membership/presentation/membership_detail_role_variants_test.dart` — `memberships.approve` actions visible for admin, hidden for member and trainer
- `app/test/features/membership/presentation/membership_packages_catalog_role_variants_test.dart` — create/update only with `memberships.create` / `memberships.update`
- `app/test/features/membership/presentation/membership_product_form_role_variants_test.dart` — form gated by the same slugs
- `app/test/features/notifications/presentation/notifications_inbox_role_variants_test.dart` — broadcast entry only with `notifications.send` or `notifications.broadcast`
- `app/test/features/payments/presentation/payment_methods_role_variants_test.dart` — create only with `payments.create`
- `app/test/features/reports/presentation/report_viewer_role_variants_test.dart` — export only with `reports.export`
- `app/test/features/scheduling/presentation/schedule_calendar_role_variants_test.dart` — member vs trainer vs admin controls that already branch on role
- `app/test/features/goals/presentation/progress_photos_role_variants_test.dart` — member vs trainer vs admin visibility already on that screen

Mock the new cubits/use cases. Do not call the network.

## Verify

From `app/`: `dart run build_runner build --delete-conflicting-outputs`, then `dart analyze`, then `flutter test` on the new role-variant tests plus any existing test that imported a converted state type.

## Closed slices

- Payments MVP: `PAY-001`–`PAY-011` (PDF/gateway `PAY-012`–`016` deferred).
- DSH-007 unblocked: `PaymentRepository.getRevenueToday` sums today's `payment_received` histories; dashboard admin widget already wired.
