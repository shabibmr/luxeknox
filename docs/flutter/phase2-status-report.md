# Phase 2 Membership — status (updated 2026-09-21)

## Closed this pass (polish)
- Create-membership sales UI (`CreateMembershipScreen` + `CreateMembershipCubit`)
- Router/shell wiring: `/admin/memberships/create`, `/admin/members/:id/assign-membership`, packages FAB, `adminPackages` → catalog
- Directory cubit refactor (`MembershipsDirectoryCubit`); go_router navigation to detail
- Dossier "Sell / assign membership" entry
- Cubit tests for directory filters

## Already present (core)
- Domain/data: products, memberships, freezes, history, renew/cancel/extend/upgrade
- Screens: card, detail, history, freeze history, packages catalog, product form, directory, trainer summary
- Freeze approve/reject; row-version conflicts; role pricing visibility

## Still open (optional)
- Cubit refactor for remaining StatefulWidget screens (detail/card/packages form)
- Broader widget/integration tests beyond directory + pricing visibility

## Recommended next
Phase 3 Scheduling (started) → Phase 4 Attendance
