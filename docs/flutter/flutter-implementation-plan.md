# LuxeKnox Flutter App — Complete Implementation Plan

## 1. Current State

The Flutter client lives under `app/`. The repository already contains a substantial foundation:

- Core Dio networking, auth/error interceptors, token storage, pagination and typed failures.
- `get_it/injectable` dependency injection.
- `go_router` routing with member/trainer/admin route definitions.
- Session, principal and capability handling.
- Media/upload helpers.
- A generated Dart API client under `packages/api_client`, covering the broad OpenAPI surface.
- Auth/session UI and tests.
- Exercise and Food verticals are substantially implemented with Clean Architecture and tests.
- Membership and People already contain substantial domain/data/presentation work.

The major remaining Flutter implementation is the operational product surface: Dashboard, Scheduling, Attendance, Payments/POS, Workout Plans/Sessions, Diet Plans/Logs, Goals/Progress, Notifications, Reports, Settings/RBAC administration, and completion/hardening of People/Membership/media flows.

## 2. Source of Truth

1. Backend OpenAPI and actual backend behavior.
2. `docs/backend-frd.md`.
3. `docs/database-entities.md`.
4. `docs/screens/consolidated-screens.md`.
5. `docs/screens/navigation-architecture.md`.
6. ADR-0006.
7. Existing Flutter implementation conventions.

The Flutter client must not invent business rules that belong to the backend.

## 3. Target Architecture

Use the existing ADR-0006 direction:

- Clean Architecture.
- `flutter_bloc`.
- `go_router`.
- `get_it` + `injectable`.
- Dio.
- Freezed/json_serializable.
- fpdart typed failures.
- flutter_secure_storage for refresh credentials.

Feature structure:

```
features/<feature>/
  domain/
    entities/
    repositories/
    usecases/
  data/
    datasources/
    models/
    repositories/
  presentation/
    bloc/
    cubit/
    screens/
    widgets/
```

Generated API models remain inside `data/`. Presentation never imports generated API types. Domain remains pure Dart.

## 4. Navigation Architecture

Exactly five top-level navigation areas per role:

| Role | Root Navigation |
|---|---|
| Member | Home · Membership · Schedule · Progress · Profile |
| Trainer | Home · Members · Schedule · Plans · Profile |
| Admin | Dashboard · Members · Memberships · Payments · More |

Use `StatefulShellRoute.indexedStack` so every root tab retains its own navigation stack.

## 5. Cross-Cutting Rules

- Backend authorization is authoritative.
- Capability checks only control client presentation and convenience routing.
- All repository calls map API failures to typed domain failures.
- Use Cubit for simple state and Bloc where event ordering/debounce/throttle/droppable/sequential processing matters.
- Paginate all directories, histories and large reports.
- Debounce searches and cancel stale requests.
- Use `Idempotency-Key` for payment, booking, check-in and freeze mutations.
- Preserve existing list data during refresh/pagination.
- Never display financial/attendance success before server confirmation.
- Handle optimistic-concurrency conflicts with reload/retry UX.
- Material 3 and responsive mobile/tablet/desktop layouts.
- No hard-coded user-facing strings; localization-ready English/Arabic.
- Use reusable widgets rather than duplicating role screens.

## 6. Delivery Phases

### Phase 0 — Foundation
Stabilize DI, networking, session, router, theme, localization, common widgets, pagination and test infrastructure.

### Phase 1 — Identity & People
Complete Auth, Profile, Members, Trainers, Employees, Health, Medical History, Emergency Contacts, Documents and Photos.

### Phase 2 — Membership
Complete package catalogue, membership detail/history, directory, freeze, extension, renewal, upgrade and cancellation.

### Phase 3 — Scheduling
Calendar, availability, facilities, schedule types, PT/class booking, recurring series, cancellation, waitlist and trainer lifecycle.

### Phase 4 — Attendance
Digital pass, QR, check-in/out, trainer session attendance, history, summaries and admin feed.

### Phase 5 — Payments
Member/admin ledger, outstanding dues, POS, split tender, discounts, refunds, adjustments and receipts.

### Phase 6 — Coaching
Workout plans/sessions, Diet plans/logs, Goals, Measurements and Progress Photos/Notes.

### Phase 7 — Operations
Notifications, Dashboard, Reports, Settings, RBAC and Audit screens.

### Phase 8 — Production Hardening
Role-variant coverage, integration tests, accessibility, performance, deep links, platform builds, crash reporting and release validation.

## 7. Standard Feature Implementation Pipeline

Every backend capability follows:

`Generated API → Remote Data Source → DTO/Model → Mapper → Domain Entity → Repository → Use Case → Bloc/Cubit → Screen/Widgets → Tests`

No generated API call should originate directly from a widget.

## 8. Critical User Journeys

1. Login → session restore → role shell.
2. Member dashboard → membership → booking → attendance.
3. Trainer → assigned member → schedule → workout/diet → progress.
4. Admin → member → membership → POS → receipt.
5. Measurement → goal update → progress chart.
6. Notification → deep link → target screen.
7. Session expiry → token refresh → logout/redirect.
8. Role/capability change → UI and route reevaluation.

## 9. Testing Strategy

Every vertical should contain entity/value-object tests, use-case tests, repository/data-source tests, Bloc/Cubit tests, widget tests, role-variant tests, golden tests for high-value adaptive screens, router/guard tests and integration tests for critical journeys.

CI should enforce `flutter analyze`, formatting, tests, architecture boundaries and generated-client drift detection.

## 10. Performance

Use server pagination, debounced search, narrow Bloc rebuilds, lazy route loading, useful caching of immutable catalogs, thumbnail/compressed image loading and real-device profiling of calendar, dashboard, POS, lists and galleries.

## 11. Definition of Done

Every documented consolidated screen has an implementation or explicit intentional omission; every applicable Member/Trainer/Admin variation works; all API access goes through repositories/use cases; authentication and refresh are reliable; deep links and navigation stacks work; server failures render correctly; critical journeys have integration coverage; architecture CI passes; and release builds pass for supported targets.
