# Phase 8 Reports — status (2026-09-21)

Scoped to **first 3** checklist items only (user: stop after first 3).

## Implemented (first 3)
- Clean Architecture feature `features/reports` (domain / data / presentation)
- **Report navigation** — admin hub `/admin/reports`; More hub opens the hub; category route `/admin/reports/:category`
- **Filters** — product ID / trainer ID fields where the selected type supports them; Apply refreshes query
- **Date ranges** — from/to date pickers (default last 30 days)
- `RPTApi` registered in DI; capability gate `/admin/reports` → `reports.read`

## Checklist
- [x] report navigation
- [x] filters
- [x] date ranges
- [ ] member / membership / attendance / payments / trainer / workout / diet / progress
- [ ] trainer own slice
- [ ] export handling
- [ ] large-result pagination

## Tests
- `test/features/reports/app_report_type_test.dart`
- `test/features/reports/report_cubit_test.dart` (load/filter plumbing)

## OPEN / blockers
- Nest `RPT` module not started — live `GET /reports/{type}` calls 404 until RPT-001+
- Shared viewer/export/pagination/trainer-own code may exist ahead of checklist; do not mark those items done until the next Reports batch claims them

## Recommended next
Next Reports batch: member → progress report types (or export / pagination / trainer own)
