# Phase 3 Scheduling — status (2026-09-21)

## Implemented
- Clean Architecture feature `features/scheduling` (domain / data / presentation)
- `SCHEDApi` registered in DI (`register_module`)
- Calendar queries (`ListSchedules` + calendar cubit/screen, role-scoped member/trainer/admin)
- Schedule detail + roster/waitlist display; book / unbook; cancel; trainer start/complete
- Schedule types + facilities list/create (admin facilities screen)
- Trainer availability get/put (trainer availability screen)
- PT/class booking screens with client **Idempotency-Key** + double-submit guard
- Router wiring: member `/schedule` (+ book-pt/book-class before `:id`), trainer schedule (+ availability before `:id`), admin `/admin/schedules` (+ facilities)
- Cubit tests: idempotency key reuse + double-submit protection

## Checklist
- [x] calendar queries
- [x] schedule detail/roster
- [x] schedule types (list/create in repository; UI via calendar context)
- [x] facilities
- [x] trainer availability
- [ ] open slots (partial: availability + calendar range; no dedicated open-slot composer)
- [x] PT booking
- [x] class booking
- [ ] recurring series (API `recurUntil` supported on create; no dedicated series UI)
- [x] cancel/reschedule (cancel yes; reschedule via updateSchedule in repo, no dedicated UI)
- [x] waitlist (booking status + leave waitlist)
- [x] trainer start/complete
- [x] double-submit protection

## Still open
- Open-slot finder UX (availability ∩ free windows)
- Recurring series management UI
- Reschedule dedicated flow
- Schedule history screens (still placeholders)
- Create-schedule admin form UI
- Broader widget/integration tests

## Recommended next
Phase 4 Attendance (`06-attendance.md`)
