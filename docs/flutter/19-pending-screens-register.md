# FILE: 19-pending-screens-register.md
## Pending Screens & Widgets: Task Register

Source plan: [`PENDING_WORK_ORDERED.md`](../../PENDING_WORK_ORDERED.md). Payments vertical excluded.
Order: foundations → partial screens → missing screens. Do not start a task until everything in its `deps` is checked.
Each screen task follows the existing standard: cubit/bloc + freezed state, `*_strings.dart`, route registration, capability gating, widget test.

Permission slugs referenced below are the seeded backend slugs (`apps/api/src/platform/db/seed/permissions.ts`). Check the `@RequirePermission` on the endpoint before gating.

---

### Phase 0: Foundations

#### F1 People data layer (create/update staff)
deps: none
- [x] F1.1 datasource: wrap `createTrainer`, `createEmployee`, `updateEmployee`, `setEmployeeStatus` (`people_api.dart`)
- [x] F1.2 domain entities: `NewTrainerInput`, `NewEmployeeInput`, `EmployeeUpdateInput` (mirror `TrainerCreate` / `EmployeeCreate`)
- [x] F1.3 `PeopleRepository` + impl methods with failure mapping
- [x] F1.4 use cases: `CreateTrainerUseCase`, `CreateEmployeeUseCase`, `UpdateEmployeeUseCase`, `SetEmployeeStatusUseCase` + DI registration
- [x] F1.5 `people_repository_impl` unit tests for the 4 new methods (success, validation 422, conflict 409) + use-case tests for the 4 new use cases (`people_usecases_test.dart` currently stops at list/get/update member)
- [x] F1.6 make `NewEmployeeInput.roleId` required (API `EmployeeCreate.roleId` is non-null; a null today surfaces as `UnknownFailure`)
- [x] F1.7 domain `EmployeeStatus` enum (active, onProbation, suspended, terminated) instead of a raw `String` in `setEmployeeStatus`

#### F2 Schedule form widgets
deps: none
- [x] F2.1 `TrainerPickerField` (paged `listTrainers`, search)
- [x] F2.2 `FacilityPickerField` (`listFacilities`)
- [x] F2.3 `ScheduleTypePickerField` (`listScheduleTypes`)
- [x] F2.4 `DateTimeRangeField` (date + start/end, validates end > start). Gym timezone comes from `GET /settings/public` (`timezone`); the app has no timezone helper yet, so add one here
- [x] F2.5 `ScheduleFormDraft` value object + validators (capacity > 0, required fields)
- [x] F2.6 widget tests for each field

#### F3 Chart foundation
deps: none
- [x] F3.1 add `fl_chart` to `pubspec.yaml`
- [x] F3.2 base wrappers: `AppBarChart`, `AppLineChart` (on `fl_chart`), `AppHeatmap` (custom grid; `fl_chart` has no heatmap). Theme tokens, light/dark, empty state
- [x] F3.3 golden/widget tests for base wrappers

---

### Phase 1: Partial screens

#### P1 Admin Edit Trainer
deps: none
- [x] P1.1 `EditTrainerProfileScreen` already takes `trainerId`; add an admin mode flag (hide self-only fields, show admin-only fields)
- [x] P1.2 add `Routes.adminTrainersEdit` = `/admin/trainers/:id/edit` + register in `admin_routes.dart`
- [x] P1.3 entry point from `TrainersDirectoryScreen` row / trainer detail
- [x] P1.4 capability gate on `trainers.update` (guards `PATCH /trainers/:id`)
- [x] P1.5 widget test for admin mode
- [ ] P1.6 *(blocked: B1)* commission and employment-terms fields

#### P2 Membership Renew / Freeze standalone screens
deps: none
- [x] P2.1 renew form maps to `MembershipActionRequest` = `productId`, `rowVersion`, `reason` only (no start date). Collect product + reason; always send the current `rowVersion`
- [x] P2.2 `MembershipRenewScreen` + cubit (reuse `renew` use case); gate on `memberships.approve`
- [x] P2.3 `MembershipFreezeScreen` (admin) + cubit calling `POST /memberships/:id/freezes` (date range, reason); gate on `memberships.update`. Admin freezes are created **already approved**, so copy says "Freeze membership", not "Request freeze" (member-initiated requests stay pending)
- [x] P2.4 register `adminMembershipsRenew` / `adminMembershipsFreeze` in `admin_routes.dart` (constants exist, unregistered)
- [x] P2.5 switch `MembershipDetailScreen` renew/freeze actions to push these routes; remove inline-only path
- [x] P2.6 refresh detail on return (result propagation); handle 409 stale `rowVersion`
- [x] P2.7 widget tests (renew success/failure/conflict, freeze validation)

Note: `04-membership.md` "remaining screen cubit refactors (detail/card/form)" is a separate leftover; P2 does not close it.

#### P3 Reschedule in schedule detail
deps: F2
- [x] P3.1 staff: `RescheduleSheet` using `DateTimeRangeField`, calls `updateSchedule` with `rowVersion`
- [x] P3.2 handle 409 stale `rowVersion` (reload + retry prompt)
- [x] P3.3 member: "Move booking" flow: pick another session of the same type, then `bookSchedule` new → `cancelBooking` old (rollback message if the second call fails). Book-then-cancel fails when the member is already at `schedule_member_booking_cap`: detect the cap error and either offer cancel-then-book (warn that the old seat may be lost) or block with a clear message
- [x] P3.4 `ScheduleDetailCubit` actions + gating: staff reschedule on `schedules.write`; member move on `schedules.book` + `schedules.cancel` (there is no `canRescheduleSession` capability; add the capability mapping if the app gates on capabilities)
- [x] P3.5 strings + widget tests (staff, member, conflict, booking cap)
- [x] P3.6 update `05-scheduling.md` cancel/reschedule line

#### P4 Dashboard agenda widgets
deps: none
- [x] P4.1 `DashboardAgendaCubit` (separate section load) using `listSchedules` for today + next 7 days
- [x] P4.2 `TodayAgendaCard` (member: my bookings; trainer: my sessions; reuse `TodaysSessionsCubit` logic)
- [x] P4.3 `UpcomingAgendaList` with tap → schedule detail
- [x] P4.4 section-level loading/error/empty without blocking the rest of the dashboard
- [x] P4.5 pull-to-refresh integration
- [x] P4.6 widget tests; tick `12-dashboard.md` member/trainer widgets, section loading, refresh

#### P5 Report charts
deps: F3
- [x] P5.1 `ReportChartSection` slot in `ReportViewerScreen` (chart above table, toggle)
- [x] P5.2 client-side aggregation helpers from `ReportResult` rows (per type)
- [x] P5.3 attendance: visits by weekday×hour heatmap + peak hours bar (+ `getAttendanceOccupancy` live tile). Backend peak rows are hour-only today, so the heatmap is a single "All days" row across 24 hours
- [x] P5.4 memberships/members: acquisition/churn and status charts from summary/package_mix rows (bars; no time-series series in the current API payload)
- [x] P5.5 trainers + `trainerOwn`: sessions volume, assigned clients
- [x] P5.6 workouts/diets/progress: summary / top-N bars (optional)
- [x] P5.7 aggregation unit tests + widget tests
- [x] P5.8 add and tick a "report charts" line in `13-reports.md`. Leave the per-type rows (member/membership/attendance/…) open until the table reports themselves are done
- [ ] P5.9 *(blocked: B5)* revenue/payment-mode/tax/aging charts

#### P6 Attendance-gate settings widget
deps: none (P6.4–P6.5 deps: B6)

`gym_settings` is a flat key/value table (no category column); `GET /settings` returns a flat map. Keys: `attendance_pass_ttl_minutes`, `attendance_debounce_seconds`, `attendance_daily_checkin_cap`, `attendance_auto_checkout_hours` (a duration in hours, not a time of day).
- [ ] P6.1 `AttendanceSettings` typed model parsed from the flat map (4 keys above, numeric)
- [ ] P6.2 read-only typed display (`AttendanceSettingsCard`: minutes/seconds/count/hours with units) in `SettingsCategoryScreen`, grouping by `attendance_` key prefix; generic fallback for other keys
- [ ] P6.3 widget test for the read-only display
- [ ] P6.4 *(blocked: B6)* editable `AttendanceSettingsForm` (numeric steppers, validation) saving through `PUT /settings`
- [ ] P6.5 *(blocked: B6)* widget test for save path
- [ ] P6.6 *(blocked: B4)* turnstile/RFID/biometric device sync

---

### Phase 2: Missing screens

#### M1 Add Trainer
deps: F1
- [x] M1.1 `TrainerFormCubit` (create mode)
- [x] M1.2 `AddTrainerScreen`: name, email, phone, initial password (`TrainerCreate.password`; no invite flow in the API), bio, specializations chips, hourly rate, max clients
- [x] M1.3 route `/admin/trainers/create` + FAB in `TrainersDirectoryScreen`; gate on `trainers.create`
- [x] M1.4 idempotency / double-submit protection, unsaved-form guard
- [x] M1.5 directory refresh on success → navigate to trainer
- [x] M1.6 widget tests

#### M2 Add Employee
deps: F1
- [x] M2.1 `EmployeeFormCubit` (create/edit modes, shared with M3)
- [x] M2.2 `EmployeeFormScreen` create mode: name, email, phone, initial password (`EmployeeCreate.password`; required by API), job title, department, hire date, role (`listRoles`, required)
- [x] M2.3 route `/admin/employees/create` + FAB in `EmployeesDirectoryScreen`; gate on `employees.create`
- [x] M2.4 double-submit protection, unsaved-form guard
- [x] M2.5 widget tests

#### M3 Edit Employee
deps: F1, M2
- [x] M3.1 `EmployeeFormScreen` edit mode (prefill via `getEmployee`, `updateEmployee`). `EmployeeUpdate` covers only job title, department, hire date; name/email/phone are create-only (read-only in edit mode). Support clearing optional fields (`EmployeeUpdateInput.copyWith` cannot null a field today)
- [x] M3.2 status picker (active / on probation / suspended / terminated) via `setEmployeeStatus`, confirm dialog for suspend/terminate
- [x] M3.3 link to existing `EmployeeRolesScreen` (role changes go through `assignEmployeeRole`)
- [x] M3.4 route `/admin/employees/:id/edit`; gate on `employees.update`
- [x] M3.5 widget tests; tick `14-settings-rbac.md` employee role/status

#### M4 Admin Create / Edit Schedule
deps: F2
- [x] M4.1 `ScheduleFormCubit` (create/edit) using existing `createSchedule` / `updateSchedule` use cases
- [x] M4.2 `ScheduleFormScreen`: type, title, trainer, facility, date/time, capacity, notes
- [x] M4.3 routes `/admin/schedules/create`, `/admin/schedules/:id/edit` + FAB in admin calendar + edit action in detail; gate on `schedules.write`
- [x] M4.4 `rowVersion` conflict handling on edit
- [x] M4.5 trainer reassignment on edit
- [x] M4.6 widget tests

#### M5 Recurring series
deps: M4
- [x] M5.1 "Repeat until" control (`recurUntil`) in `ScheduleFormScreen` (create only)
- [x] M5.2 edit scope prompt for series members: "this session" vs "whole series" (`seriesId`), confirm backend semantics first
- [x] M5.3 recurring indicator in calendar/detail (`isRecurring`)
- [x] M5.4 widget tests; tick `05-scheduling.md` recurring series
- [ ] M5.5 *(blocked: B2)* daily/weekly/by-weekday pattern

#### M6 Open slots selector
deps: F2 (`getTrainerAvailability` and `BookScheduleScreen` already exist; M4 not needed)
- [x] M6.1 `OpenSlotsCalculator`: availability windows − booked sessions → bookable slots (pure, unit-tested)
- [x] M6.2 `OpenSlotsPicker` widget (day strip + slot chips)
- [x] M6.3 integrate into `BookScheduleScreen` PT flow (`/schedule/book-pt`), trainer pre-selected from assigned trainer
- [x] M6.4 stale-slot handling (booking 409 → refresh slots)
- [x] M6.5 widget tests; tick `05-scheduling.md` open slots

---

### Blocked on backend (track, don't start)
- [ ] B1 trainer commission and employment-terms fields (P1.6)
- [ ] B2 recurrence pattern in `ScheduleWrite` (M5.5)
- [ ] B3 open-slots endpoint (optional; replaces M6.1)
- [ ] B4 gate/turnstile/biometric device API (P6.6)
- [ ] B5 Payments vertical → financial charts (P5.9)
- [ ] B6 `PUT /settings` + `settings.update` permission (`BACKEND_GAPS_TASKS_REGISTER.md` GAP-009) → P6.4–P6.5
