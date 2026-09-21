# Phase 4 Attendance — status (2026-09-21)

## Implemented
- Clean Architecture feature `features/attendance` (domain / data / presentation)
- `ATTNApi` registered in DI (`register_module` + injectable codegen)
- Digital pass (`GET /attendance/pass`) + QR presentation (`qr_flutter`)
- Member check-out of open gate session; admin check-in via QR scan / manual override
- Check-in **Idempotency-Key** + double-submit guard (never success before server confirm)
- History (`listAttendances`) + summary/streak + personal visit heatmap
- Admin live feed (today’s attendances) + 28-day footfall bars (`listAttendanceHistories`)
- Session attendance mark attended/no-show on schedule detail (trainer/admin)
- Camera/permission error UX on QR scan (`mobile_scanner`) with manual payload fallback
- Routes: member `/profile/attendance` (+ history/summary), admin `/admin/attendance` (+ scan/manual), trainer member attendance summary/history

## Checklist
- [x] digital pass
- [x] QR presentation
- [x] check-in/out
- [x] history
- [x] summary/streak/heatmap
- [x] session attendance
- [x] admin live feed
- [x] manual override
- [x] idempotency keys
- [x] camera/permission errors

## Tests
- `test/features/attendance/check_in_cubit_test.dart` — idempotency reuse, double-submit, success-after-confirm
- `test/features/scheduling/schedule_detail_cubit_test.dart` — updated for mark-attendance DI
- Focused analyze on attendance + schedule detail: clean
- Focused tests: **7/7 passed**

## OPEN / polish (non-blocking)
- Real-time feed polling/websocket (current: pull-to-refresh)
- Admin member dossier nested attendance deep-links (trainer path wired; admin dossier can reuse screens)
- Richer heatmap calendar chrome / a11y
- Device-key gate tablet mode (`X-Device-Key`) — API supports it; no dedicated kiosk shell yet

## Recommended next
Phase 5 Payments (`07-payments.md`)
