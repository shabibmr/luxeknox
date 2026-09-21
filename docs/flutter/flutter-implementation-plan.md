# LuxeKnox Flutter App — Complete Implementation Plan

## 1. Current state
- Flutter application exists under app/.
- Core networking, auth/session, routing, DI, media helpers and typed failures already exist.
- Exercise and Food verticals are substantially implemented and tested.
- Membership and People have substantial scaffolding and should be completed rather than rebuilt.
- packages/api_client already contains generated APIs/models for nearly the complete OpenAPI surface.
- Major unfinished product areas are Dashboard, Scheduling, Attendance, Payments, Workout Plans/Sessions, Diet Plans/Logs, Goals/Progress, Notifications, Reports, Settings/RBAC and remaining profile/media flows.

## 2. Source of truth
1. Backend OpenAPI and actual backend behavior.
2. docs/backend-frd.md.
3. docs/database-entities.md.
4. docs/screens/consolidated-screens.md.
5. docs/screens/navigation-architecture.md.
6. ADR-0006.
7. Existing Flutter implementation conventions.

## 3. Target architecture
Use Clean Architecture per feature: domain, data and presentation. Generated API models remain inside data. Presentation never imports data. Domain remains pure Dart.
Use flutter_bloc for state, go_router for navigation, get_it/injectable for DI, Dio for HTTP, Freezed/json_serializable for immutable models/states, fpdart for typed failures, and secure storage for refresh credentials.

## 4. Core rules
- Server is authoritative for permissions, business rules, financial state, attendance and booking.
- Repository operations expose typed failures.
- Use Cubit for simple state; Bloc where debounce, sequential or droppable processing is required.
- Use StatefulShellRoute.indexedStack for the five independent root navigation stacks.
- Capability checks control UI visibility and convenience routing; they never replace server authorization.
- Paginate directories, histories and reports.
- Debounce searches and cancel stale requests.
- Use idempotency keys for payment, check-in, booking and freeze mutations.
- Preserve existing list data during refresh/pagination.
- Use Material 3 and adaptive mobile/tablet/desktop layouts.
- No hard-coded user-facing strings; keep localization ready for English and Arabic.

## 5. Five navigation roots
- Member: Home, Membership, Schedule, Progress, Profile.
- Trainer: Home, Members, Schedule, Plans, Profile.
- Admin: Dashboard, Members, Memberships, Payments, More.
Secondary screens remain nested routes, dialogs, sheets or adaptive master-detail panes.

## 6. Delivery phases
Phase 0: Foundation and shell.
Phase 1: Auth, People, Health and Profile.
Phase 2: Membership.
Phase 3: Scheduling and Availability.
Phase 4: Attendance.
Phase 5: Payments/POS.
Phase 6: Workout, Diet and Goals/Progress.
Phase 7: Notifications, Dashboard, Reports, Settings and RBAC.
Phase 8: Testing, accessibility, performance and production hardening.

## 7. Feature completion pattern
For every API capability: generated API method → data source → domain entity → repository contract → repository implementation → use case → Bloc/Cubit → screen/widgets → loading/empty/error states → role variants → tests.

## 8. Critical journeys
1. Login → session restore → role shell.
2. Member dashboard → membership → booking → attendance.
3. Trainer → assigned member → availability → session → workout/diet/progress.
4. Admin → member → membership → POS payment → receipt.
5. Measurement → goal update → progress chart.
6. Notification → deep link → target screen.
7. Session expiry → refresh → logout/redirect.

## 9. Quality gates
- flutter analyze passes.
- Formatting passes.
- Unit, Bloc/Cubit, widget and integration tests pass.
- Role-variant tests cover every adaptive screen.
- Golden tests cover dashboard, calendar, POS, plan builder and major shells.
- Architecture CI verifies presentation does not import data and domain does not import Flutter.
- Generated API client is reproducible and drift is detected.
- Release builds pass for every supported target.