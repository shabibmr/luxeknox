# Pending Screens & Widgets: Ordered Build Plan

**Date:** 2026-09-25
**Source:** `PENDING_SCREENS_AND_WIDGETS.md`, checked against `app/lib`, `packages/api_client`, and `docs/flutter/*`.
**Out of scope:** the Payments vertical (POS `/admin/payments/record`, receipts, split tender, coupons, refunds).

**Ordering rules:** shared foundations first. After that, finish partial screens (the screen exists but is incomplete) before building missing screens. Within each group, items are ordered by dependency.

---

## Corrections to the audit

| Audit claim | What the code shows |
| :--- | :--- |
| Edit Trainer (admin) "not implemented" | `EditTrainerProfileScreen` already exists for trainer self-edit (`trainer_routes.dart` `edit`), and `updateTrainer` is wired. Admin needs a route plus a `trainerId` param. This is partial, not missing. |
| Edit Trainer: "commission structures, employment terms" | `TrainerCreate` has only `bio`, `specializations`, `hourlyRate`, `maxClientsCapacity`. It has no commission or employment fields, so the backend contract needs to grow first. |
| Add/Edit Employee and Add Trainer "not implemented" | Correct in the UI. The API client already has `createTrainer`, `createEmployee`, `updateEmployee`, and `setEmployeeStatus`, but `PeopleRepository` doesn't expose them. This is a data-layer gap. |
| Reschedule UI | The API has no reschedule endpoint. Staff reschedule is `updateSchedule` (start/end plus `rowVersion`). Member reschedule is `cancelBooking` + `bookSchedule` on another session. |
| Recurring: "weekly, daily repeat patterns" | `ScheduleWrite` has only `seriesId` and `recurUntil`, with no pattern or frequency field. A picker for daily/weekly patterns needs backend work. Today it can only offer "repeat until". |
| Open slots selector | There's no open-slots endpoint. Slots have to be computed on the client from `getTrainerAvailability` minus `listSchedules`. |
| Dashboard agenda "waiting on server" | The `Dashboard` contract has no agenda. The agenda can be built now from `listSchedules(today)`; `TodaysSessionsCubit` already does this for trainers. |
| Reports "trainer own slice" open | The `trainerReportsOwn` route already renders `ReportViewerScreen`. Only the visual/chart layer is missing. |
| Hardware/biometric widget | The backend has no device or turnstile API. Only four flat `attendance_*` settings keys exist, and they can't be saved from the app until `PUT /settings` ships (GAP-009). |
| Other `PlaceholderScreen` uses in routers | These are fallbacks for an invalid `:id` only, not missing screens. Only `/admin/payments/record` is a real stub. |

---

## Phase 0: Shared foundations

| # | Item | Unblocks |
| :--- | :--- | :--- |
| F1 | **People data layer:** add `createTrainer`, `createEmployee`, `updateEmployee`, `setEmployeeStatus` to `PeopleRepository` / datasource / use cases / DI | M1, M2, M3 |
| F2 | **Schedule form widgets:** trainer picker, facility picker, schedule-type picker, date + time-range field in gym timezone from `GET /settings/public` (repos already have `listFacilities`, `listScheduleTypes`, `listTrainers`) | P3, M4, M5, M6 |
| F3 | **Chart foundation:** add `fl_chart` (none in `pubspec.yaml` today) plus bar and line wrappers and a custom-grid heatmap (`fl_chart` has none) | P5 |

## Phase 1: Partial screens (finish first)

| # | Screen / widget | Current state | Depends on |
| :--- | :--- | :--- | :--- |
| P1 | **Admin Edit Trainer:** mount `EditTrainerProfileScreen` at `/admin/trainers/:id/edit` with an explicit `trainerId`; add an entry point in `TrainersDirectoryScreen` | Self-edit screen exists | none (commission fields need backend) |
| P2 | **Membership Renew / Freeze screens:** register `adminMembershipsRenew` / `adminMembershipsFreeze`; the renew screen collects `MembershipActionRequest` (`productId`, `reason`, plus `rowVersion`; no start date), gated on `memberships.approve`; admin freeze via `POST /memberships/:id/freezes` (`memberships.update`) is created already approved | Routes defined, not registered; renew is a single tap in the detail screen | none |
| P3 | **Reschedule in `ScheduleDetailScreen`:** staff time change through `updateSchedule` (`schedules.write`); member moves to another session through book-new + cancel-old (`schedules.book` + `schedules.cancel`), handling `schedule_member_booking_cap` | Cancel is done | F2 |
| P4 | **Dashboard agenda widgets** (member and trainer "today/upcoming") in the dashboard sections | Only counts are shown | none (reuse `listSchedules`) |
| P5 | **Report charts** in `ReportViewerScreen`, per `AppReportType`: attendance heatmap and peak hours (also `getAttendanceOccupancy`), memberships acquisition/churn, trainer and trainer-own slice | Table only | F3 |
| P6 | **Attendance settings widget:** typed display of the flat keys `attendance_pass_ttl_minutes`, `attendance_debounce_seconds`, `attendance_daily_checkin_cap`, `attendance_auto_checkout_hours` (no category column in `gym_settings`). Read-only now; editing needs `PUT /settings` (GAP-009) | Generic viewer exists; no write endpoint | none for read-only; edit **blocked on GAP-009**; turnstile/RFID sync **blocked on backend** |

## Phase 2: Missing screens

| # | Screen / widget | Depends on |
| :--- | :--- | :--- |
| M1 | **Add Trainer** form (`TrainerCreate`; initial password, no invite flow) | F1 |
| M2 | **Add Employee** form (`EmployeeCreate`, required role through the existing `listRoles`) | F1 |
| M3 | **Edit Employee** (`updateEmployee` covers job title, department, hire date only; status picker for the 4 statuses through `setEmployeeStatus`; link to the existing `EmployeeRolesScreen`) | F1, M2 (shares the form) |
| M4 | **Admin Create / Edit Schedule** (`/admin/schedules/create`, `/:id/edit`); `createSchedule`/`updateSchedule` use cases already exist | F2 |
| M5 | **Recurring series widget** inside M4: "repeat until" (`recurUntil`) plus edit-series scope (`seriesId`); daily/weekly pattern is **blocked on backend** | M4 |
| M6 | **Open slots selector** for member PT booking (`/schedule/book-pt`): derive slots from availability minus booked sessions (`getTrainerAvailability` and `BookScheduleScreen` already exist) | F2 |

## Blocked on backend (not scheduled)

- Trainer commission and employment-terms fields
- Recurrence pattern (daily/weekly/by-day) in `ScheduleWrite`
- Open-slots endpoint (optional; the client-side version works)
- Turnstile/RFID/biometric device API
- Financial report charts (need the Payments vertical)
- `PUT /settings` write endpoint + `settings.update` permission (GAP-009), needed to edit attendance settings
