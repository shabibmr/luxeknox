## Attendance

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

### Notes
- Feature: `app/lib/features/attendance/` (Clean Architecture).
- Member: `/profile/attendance` (pass + QR), `/history`, `/summary`.
- Admin: `/admin/attendance` live feed + footfall; `/scan`, `/manual`.
- Trainer/admin: mark attended/no-show on schedule detail roster.
- Check-in mutations send `Idempotency-Key`; success only after API confirms.
