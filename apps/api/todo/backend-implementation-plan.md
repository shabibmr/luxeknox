# LuxeKnox Backend — Complete Implementation Plan

**Repository:** `shabibmr/luxeknox`
**Scope:** Backend completion for the Gym Management System MVP
**Primary contract:** `docs/backend-frd.md`, `docs/database-entities.md`, `docs/openapi/v1.yaml`
**Status basis:** repository inspected on 2026-09-21; re-verified against `feature/backend-foundation` worktree on the same date (41 unit test files, 5 e2e specs, 19 tables across 18 schema files, ~20 controllers vs. 114 documented OpenAPI paths). This branch implements Foundation/Auth/RBAC/People/Health/Media hardening but does **not** include the Membership (`src/memb/`) vertical present on main.

---

## 1. Executive Summary

LuxeKnox has a solid backend foundation, but it is not yet a complete backend for the documented Flutter application.

The current implementation contains a functioning architectural spine and substantial implementations for:

- Platform/runtime concerns
- Authentication and opaque sessions (login/refresh/logout/**password change and reset** on this branch)
- RBAC permission enforcement **and role-management API** (on this branch)
- People/profile management
- Health, documents and member photos
- Membership products and membership workflows (**not on `feature/backend-foundation` — only on main**)
- Exercise catalogue
- Food catalogue
- Media upload/storage abstraction

The major functional gap is that the database/schema and API contract describe **56 canonical entities and 44 consolidated client screens**, while the running backend implements 22 tables and 17 controllers. Scheduling, attendance, payments, workout plans/sessions, diet plans/logging, goals/progress, notifications, dashboard aggregation, and reports still require complete vertical implementations.

Three cross-cutting gaps must close before those verticals can be built safely, and each is now an explicit blocking task rather than a footnote:

1. **The database engine is undecided** (§2.4). 35 tables remain; authoring them twice is avoidable.
2. **Job runtime is still missing** (`FND-017`–`FND-019`). Idempotency (`FND-010`) is implemented on this branch; POS/attendance retries still need the job layer for cleanup/reminders.
3. **There is no background job runtime** (`FND-017`). Eleven jobs are mandated in §9 and nothing can host them.

The implementation should proceed as a **contract-first, vertical-by-vertical backend completion program**, not as a rewrite of the existing backend.

---

## 2. Current State Assessment

### 2.1 Backend stack

- NestJS + TypeScript
- Drizzle ORM
- MySQL 8.4 currently configured (**engine decision open — see §2.4**)
- REST API under `/v1`
- Swagger/OpenAPI generation and parity checks
- Zod-based DTO validation patterns
- Argon2 password hashing
- Opaque access/refresh sessions stored server-side
- Pino structured HTTP logging
- Domain event bus using Nest event emitter
- Transaction context helper
- Permission guard/cache

**Not present in `apps/api/package.json`:** any job scheduler or queue (`@nestjs/schedule`, BullMQ, Redis, cron), `helmet`, `@nestjs/throttler`, `@nestjs/config`. Any plan step that assumes one of these must first add it.

### 2.2 Existing modules

| Area | Current state | Assessment |
|---|---|---|
| Platform | Implemented, with gaps | Idempotency, env validation, DB error translation, pool diagnostics and audit DB grants are in place; **job runtime and rate limiting still missing** |
| Health/readiness | Implemented | `SELECT 1` plus pool stats on `/ready` |
| Auth/session | Login/refresh/logout/**password change+reset** implemented | `SessionCleanupJob` exists but is **not scheduled** (`FND-017`) |
| RBAC | Guard/cache **and role-management controllers** | `role.controller.ts` + cache invalidation wired; **RBAC-008 slug-drift test** added |
| People | Implemented | Strong; dossier is not yet joined to operational data (blocked on scheduling/attendance/payments) |
| Health/medical | Largely implemented on this branch | `health_conditions` / `medical_histories` **promoted to MVP** here (see §2.5); OpenAPI `x-status: deferred` on member documents/photos/media still mismatches implementation |
| Media | Substantially implemented | Signed upload/download, row-scope auth, deletion rules, local/S3 adapters; orphan cleanup job class exists but **not scheduled** |
| Membership | **Not on this branch** | `src/memb/` absent; defer to after Media hardening on main merge |
| Exercise catalogue | Implemented | Complete for catalogue scope |
| Food catalogue | Implemented | Complete for catalogue scope |
| Scheduling | Not implemented | Major gap |
| Attendance | Not implemented | Major gap |
| Billing/payments | Not implemented | Major gap |
| Workout plans/sessions | Not implemented | Major gap |
| Diet plans/logs | Not implemented | Major gap |
| Goals/measurements/progress | Not implemented | Major gap |
| Notifications/devices | Not implemented | Major gap |
| Dashboard | Not implemented | Major gap |
| Reports | Not implemented | Major gap |
| Jobs/automation | Event bus only — **no scheduler, no queue, no job history** | Needs a full job layer (`FND-017`–`FND-019`) |
| Audit | Append-only at service level | **Not enforced at database privilege level**; ADR-0002 assumes engine-level ledger immutability |
| API client/OpenAPI | Contract exists; parity script exists; generated Flutter package exists | 114 documented paths vs. 17 controllers; parity gate must broaden as the backend grows |

### 2.3 Important implementation observations

1. `docs/backend-frd.md` is the behavioral contract. Do not redesign requirements unless an explicit product decision changes them.
2. `docs/database-entities.md` is the canonical logical relational model, but the physical schema is incomplete.
3. `docs/openapi/v1.yaml` already defines routes for domains not implemented in NestJS. Backend implementation should make the real controller/service behavior match this contract.
4. The current schema is MySQL-specific (`mysql-core`, `mysql2`, MySQL DDL) — **pending §2.4**.
5. The existing `PersonFactory`, row-scope helpers, audit service, domain-event bus, pagination, optimistic concurrency helpers, and opaque session design should be treated as reusable infrastructure.
6. **A file existing is not a feature existing.** The prior revision of this plan and its task register signed off Foundation, Auth and RBAC on the strength of directory listings. `src/rbac/` has five files and zero controllers. Verify behaviour and test coverage before marking anything complete.

### 2.4 Blocking decision — database engine

`docs/adr/0002-database-engine-and-data-access.md` is **Accepted** and selects MySQL 8.4, largely on an operational argument: Hostinger provisions MySQL and phpMyAdmin natively, with backups, and there is no database server to run.

`POSTGRES_MIGRATION_PLAN.md` and `POSTGRES_MIGRATION_TASKS.md` reverse that decision. The migration plan itself flags an unresolved **Decision 0** — where production PostgreSQL will live and who operates it — and states plainly that nothing in the plan solves it.

This is not a footnote, it is a gate. **35 tables remain to be authored.** Writing them in `mysql-core` and then porting them to `pg-core` means redoing every table, every index, every JSON column (`JSON` → `JSONB`), every timestamp (`DATETIME` → `TIMESTAMPTZ`), every partial-unique invariant from §5.2, and the case-insensitive search behaviour of every directory query.

**Rule:** no schema file for Scheduling, Attendance, Billing, Workout-beyond-exercises, Diet-beyond-foods, Goals or Notifications may be authored until `FND-000` is closed with an accepted ADR. The two outcomes are:

- **Stay on MySQL** — supersede both PostgreSQL documents and record the rejection in ADR-0002.
- **Move to PostgreSQL** — migrate the existing 22 tables first, then author the remaining 35 directly in `pg-core`.

Everything in verticals 00–06 except new-table authoring can proceed in parallel with this decision.

### 2.5 Deferred contract surface — health conditions and medical histories

`docs/openapi/v1.yaml` marks `/health-conditions`, `/health-conditions/{id}`, `/members/{id}/medical-histories` and `/members/{id}/medical-histories/{historyId}` as `x-status: deferred`. `apps/api/scripts/check-openapi-parity.ts` enforces this in both directions — it throws if a deferred path enters the required MVP set (line 154) **and** it throws if those paths stop being marked deferred (line 164). Correspondingly, `health_conditions` and `medical_histories` are absent from `src/platform/db/schema/`.

Implementing them without first amending the YAML *and* the parity script breaks CI. `HLT-000` records the product decision; `HLT-002` and `HLT-003` are gated behind it. Until then, those two tables are **out of the MVP table count**.

---

## 3. Source-of-Truth Hierarchy

When implementing a backend feature, resolve conflicts in this order:

1. Explicit product decisions from the current project conversation/repository decisions.
2. Accepted ADRs under `docs/adr/`.
3. `docs/backend-frd.md` for business behavior.
4. `docs/database-entities.md` for logical entities and relationships.
5. `docs/openapi/v1.yaml` for HTTP contract.
6. Existing code conventions for implementation style.
7. Existing migration documents for database-engine concerns only.

Do not let an older implementation file silently redefine a newer requirement. Equally, do not let a *proposed* document (an unaccepted ADR draft, or a migration plan with an open blocking decision) override an accepted one — that is exactly the state §2.4 exists to resolve.

---

## 4. Target Backend Architecture

### 4.1 Layering

Each vertical should follow the same structure:

```text
vertical/
  *.module.ts
  *.controller.ts
  *.dto.ts
  *.service.ts
  *.repository.ts
  *.mapper.ts       # only when API representation differs from persistence
  *.policy.ts       # only when domain authorization rules are non-trivial
  *.events.ts       # when domain events are vertical-specific
  *.spec.ts
```

Use the existing platform helpers rather than recreating infrastructure in each vertical.

A vertical that enforces permissions but exposes no controller is half a vertical. If the OpenAPI contract documents management endpoints for a domain, the module must register controllers for them.

### 4.2 Request path

```text
Flutter Client
   ↓
REST Controller
   ↓
Auth Guard
   ↓
Permission Guard / row-scope policy
   ↓
Zod DTO validation
   ↓
Idempotency guard (mutations that clients retry)
   ↓
Application Service
   ↓
Repository / Transaction Context
   ↓
Drizzle + relational engine
   ↓
Domain Event / Audit / Job trigger
   ↓
API response DTO
```

### 4.3 Transaction rule

Use a transaction whenever an operation changes more than one authoritative record or needs a history/audit invariant.

Typical transactional units:

- Person creation
- Membership create/renew/upgrade/freeze/extension/cancel
- Schedule cancellation + participant state changes
- Booking + waitlist promotion
- Session attendance + PT-session consumption
- Payment + tender history + membership activation
- Workout version creation + line-item replacement
- Diet version creation + meal/food replacement
- Measurement + goal current value/history
- Notification persistence + delivery fan-out metadata where atomicity is required

### 4.4 Authorization rule

Never rely on Flutter UI hiding.

Every endpoint must enforce:

```text
authenticated principal
+ permission
+ role scope
+ row ownership / assigned-trainer scope
+ business state rules
```

Permission slugs referenced by `@RequirePermission` must exist in the seeded catalogue (`src/platform/db/seed/permissions.ts`, 78 slugs). A drifted slug fails closed and silently; `RBAC-008` makes that a test failure instead.

### 4.5 API response discipline

All list endpoints should support the repository's standard pagination shape. Use stable identifiers, explicit nullable fields, and server-computed derived fields where clients would otherwise duplicate business logic.

Do not return internal password/token hashes, unrestricted sensitive health documents, or unscoped records.

### 4.6 Error discipline

A database constraint violation must surface as a correct 4xx, never a 500. `src/platform/errors/exception.filter.ts` currently has no driver-error branch, so `ER_DUP_ENTRY` and `ER_NO_REFERENCED_ROW_2` become opaque `INTERNAL_ERROR` responses. Every uniqueness invariant in §5.2 depends on `FND-013` landing first — otherwise enforcing invariants in the database makes the API *worse*, not better.

---

## 5. Database Completion Strategy

### 5.1 Complete the canonical model — accounting

`docs/database-entities.md` states a table count of **56**. It enumerates **57** table headings; the discrepancy is in domain 1, where the summary table says 8 and the body lists 9 (`membership_number_counters` was added after the summary was written). Reconcile the document as part of `API-002`; the figures below use the enumerated 57.

| | Tables |
|---|---:|
| Canonical (enumerated in `database-entities.md`) | 57 |
| Implemented in `src/platform/db/schema/` (16 files) | 22 |
| Deferred by contract (`health_conditions`, `medical_histories` — §2.5) | 2 |
| **Remaining to author for MVP** | **33** |

**Implemented (22):** `users`, `sessions`, `roles`, `permissions`, `role_permissions`, `members`, `membership_number_counters`, `trainers`, `employees`, `member_health`, `emergency_contacts`, `member_documents`, `member_photos`, `membership_products`, `memberships`, `membership_freezes`, `membership_extensions`, `membership_histories`, `exercises`, `foods`, `gym_settings`, `audit_logs`.

**Remaining 33, by vertical:**

| Vertical | Count | Tables |
|---|---:|---|
| Scheduling | 6 | `schedule_types`, `facilities`, `schedules`, `schedule_participants`, `trainer_availabilities`, `schedule_histories` |
| Attendance | 2 | `attendances`, `attendance_histories` |
| Billing | 4 | `payment_methods`, `payments`, `payment_receipts`, `payment_histories` |
| Workout (beyond `exercises`) | 5 | `workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises` |
| Diet (beyond `foods`) | 5 | `diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, `diet_histories` |
| Goals/progress | 7 | `goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`, `progress_photos`, `progress_notes` |
| Notifications | 4 | `notification_types`, `notifications`, `user_devices`, `notification_deliveries` |

**Plus infrastructure tables outside the canonical 57**, each justified by a cross-cutting requirement in this plan:

- `idempotency_keys` — required by `FND-010`, consumed by `PAY-004`, `PAY-014`, `ATT-006`, `ATT-008`, `NOT-009`.
- `job_runs` — required by `FND-018`, the execution contract in §9.
- a password-reset token store — required by `AUTH-007`.

Document each of these in `database-entities.md` when added, so the canonical count stays honest.

**All 33 remaining canonical tables are blocked on `FND-000` (§2.4).**

### 5.2 Enforce invariants in the database

Enforce key invariants at DB level in addition to service checks:

- Unique role/permission pairs
- Unique memberships and invoice/receipt numbers
- Unique participant membership per schedule
- One primary emergency contact per user
- One active membership per member
- One current avatar per member
- One active assigned workout plan per member
- One active assigned diet plan per member
- One in-progress workout session per member
- Unique daily diet log per member
- Unique metric definitions where appropriate
- `audit_logs` is insert-only at the **privilege** level (`REVOKE UPDATE, DELETE`, or a rejection trigger) — `FND-011a`

Service rules remain mandatory because DB constraints alone do not provide authorization or user-friendly errors. `FND-013` is the bridge: without constraint-error translation, a database-enforced invariant returns a 500.

The exact mechanism for "at most one X per Y" differs by engine (MySQL functional/generated-column unique index vs. PostgreSQL partial unique index), which is another reason `FND-000` precedes schema authoring.

### 5.3 Money

Use exact decimal values for all monetary persistence and calculations. Never use floating-point amounts in the API domain model. `src/platform/money/money.ts` is the single entry point.

### 5.4 Time

Persist UTC; convert to gym timezone only for business-day calculations and display-oriented derived data. `src/platform/db/utc-datetime.ts` is the single entry point, and report date boundaries (`RPT-011`) must use it.

### 5.5 Search and indexing

Add explicit indexes for:

- Membership status/end date/member
- Schedule time range/trainer/facility/status
- Participant schedule/member/status
- Attendance user/check-in
- Payment member/status/date/reference
- Workout plan member/status
- Diet plan member/status
- Measurement member/recorded_at
- Notification delivery user/is_read
- Common directory search columns

Search should remain case-insensitive and avoid accidental N+1 queries. Case-insensitivity is engine-dependent (MySQL `utf8mb4_0900_ai_ci` collation vs. PostgreSQL `CITEXT`/`lower()` indexes) — see `POSTGRES_MIGRATION_PLAN.md` §5 and §2.4 above.

---

## 6. Backend Vertical Delivery Order

Delivery order. **These numbers match `backend-task-register.md` section numbers exactly** — `V05` is section `05-media.md`, and so on. Task ID prefixes (`FND`, `MED`, `MEM`, …) are stable and never change if a vertical is resequenced.

```text
V00 Foundation hardening (incl. DB-engine gate, idempotency, job runtime)
V01 Auth completion
V02 RBAC completion
V03 People
V04 Health
V05 Media
V06 Membership completion
V07 Scheduling
V08 Attendance / biometric integration boundary
V09 Billing / Payments
V10 Workout
V11 Diet
V12 Goals / Progress
V13 Notifications / Devices
V14 Dashboard
V15 Reports
V16 API client / OpenAPI parity
V17 Integration / performance / security / production readiness
```

The dependency chain is intentional:

- **Media precedes Membership, Scheduling, Attendance and Payments**, because member documents/avatars (`HLT-005`, `HLT-006`), receipt PDFs (`PAY-012`) and progress photos (`GOA-011`) all consume it. A prior revision of this plan placed Media after Reports; that ordering could not be executed.
- Scheduling depends on members, trainers and memberships.
- Attendance depends on membership eligibility and scheduling.
- Payments interacts with memberships and receipts/media.
- Workout/diet depend on trainers, members and goals/measurements.
- Notifications consume events generated by these modules and require the job runtime from V00.
- Dashboard/reports are downstream read models over completed transactional domains.

Verticals 01–06 may proceed in parallel with the `FND-000` decision **except** for authoring new canonical tables.

---

## 7. Vertical Implementation Plan

### V00 — Foundation Hardening

Complete shared backend infrastructure before adding major domains.

**Blocking first:** close `FND-000`, the database engine decision (§2.4).

Already in place: global error envelope, Zod validation pipe, pagination primitives, request-id propagation and ALS, transaction context, optimistic locking helper, service-level append-only audit, domain-event envelope, migration/seed/drift pipeline, real-MySQL integration test harness.

Still to build:

- Startup environment validation, fail-fast (`FND-006`)
- Security headers/CORS/trusted-proxy/rate-limiting policy (`FND-005`)
- Idempotency store and guard (`FND-010`)
- Database constraint/error translation (`FND-013`)
- DB pool health/readiness diagnostics (`FND-014`)
- Database-privilege-level audit immutability (`FND-011a`)
- Background job runner/scheduler engine (`FND-017`)
- Job execution contract and `job_runs` history (`FND-018`)
- Job observability: failure/retry counters, last-success timestamps (`FND-019`)

**Exit condition:** new verticals can be implemented without inventing their own cross-cutting mechanics — including retries, scheduled work and constraint-error mapping.

### V01 — Auth Completion

Harden the current authentication implementation and finish the documented surface.

Already in place: login with email/phone normalization, access/refresh TTLs, refresh-token family rotation with reuse revocation, logout with cache invalidation, per-identifier/IP login throttle, inactive/suspended rejection, `/me` projection.

Required outputs:

- Password change with session invalidation (`POST /auth/password/change`)
- Password reset request/consume with single-use, expiring tokens (`POST /auth/password/forgot`, `POST /auth/password/reset`)
- Session cleanup/expiration job (depends on `FND-017`)
- Security tests for reset-token replay and throttle bypass

### V02 — RBAC Completion

Finish role management. The enforcement half — `PermissionGuard`, `PermissionCache`, `RoleRepository`, `PermissionRepository` — is built and tested. **The management half does not exist:** `rbac.module.ts` registers no controllers, and `/roles`, `/roles/{id}`, `/roles/{id}/permissions` and `/permissions` are documented with nothing behind them.

Required outputs:

- Role controller and DTOs
- Role list/get/create/update
- Permission catalogue endpoint (expose the 78 seeded slugs)
- Role-permission replacement endpoint
- System-role immutability rules
- Permission cache invalidation wired to role-permission mutations (`PermissionCache.invalidateRole` exists and has no callers)
- A test asserting every `@RequirePermission` slug exists in the seeded catalogue
- Role-management authorization tests

Employee role assignment (`PUT /employees/:id/role`) is already integrated.

### V03 — People

Existing functionality should be stabilized around future domain integrations.

Already in place: member CRUD and trainer assignment, trainer CRUD and assigned-member query, employee lifecycle with role and status operations, `PersonFactory`, row-scope helpers, onboarding e2e coverage.

Required outputs:

- Member dossier joins for membership/payment/attendance/schedule summaries (the last three land incrementally as V07–V09 complete)
- Directory filter coverage and efficient indexes
- Trainer capacity enforcement at assignment with audited override reason
- Trainer deactivation behaviour
- Credential updates returning 409 on duplicate identifiers (depends on `FND-013`)
- Full row-scope matrix tests

### V04 — Health

Already in place: current-health one-row model, emergency contacts with primary-contact invariant, member documents with verification, member photo gallery and avatar.

**Gated:** `health_conditions` and `medical_histories` are deferred in the contract and enforced as deferred by the parity script (§2.5). `HLT-000` records the promote-or-defer decision before any code is written for them.

Required outputs:

- Confirm one-row and one-avatar invariants at the database level
- Trainer restriction on identity-proof documents
- Auditing of all privileged health reads/writes
- Sensitive-data tests

### V05 — Media

Make the storage abstraction durable and row-scoped before the verticals that depend on it.

Required outputs:

- Finalized storage abstraction interface
- Upload purpose/MIME/size validation
- Signed upload slot generation
- Signed download URLs
- Parent-entity row-scope authorization on downloads
- Allowed-deletion rules
- Integration with receipt, exercise, member document/photo and progress-photo use cases
- Orphan object cleanup job (depends on `FND-017`)
- Local vs production object-storage deployment documentation
- Storage outage/error handling tests

### V06 — Membership Completion

Keep existing membership services but make them the authoritative membership lifecycle used by Payments, Scheduling and Attendance.

Already in place: product CRUD with active subscriber count, freeze request/approve/reject/direct-create, and all five membership tables.

Required outputs:

- Full lifecycle state machine, every transition and every rejected transition verified
- Active/frozen uniqueness and locker uniqueness at the database level
- Freeze quota/overlap rules and freeze/extension accounting
- Immutable membership history
- Expiry/grace-period job (depends on `FND-017`)
- Renewal reminder events
- PT entitlement counters
- Membership product snapshot semantics
- Membership/payment coordination hooks

### V07 — Scheduling

Implement the complete calendar and booking engine. **Schema blocked on `FND-000`.**

Important design requirement: slot availability must be computed server-side from trainer availability, room/facility rules, existing schedules, membership entitlement and booking settings.

Required outputs:

- Schedule masters
- Facilities
- Trainer availability
- Schedule CRUD
- Recurring series creation
- Participant booking/cancellation
- Waitlist FIFO promotion
- Double-book conflict detection
- Concurrency handling (reuse `row-version.ts`)
- Start/complete/cancel transitions
- Schedule history
- Calendar queries optimized for date ranges

### V08 — Attendance / Hardware Boundary

Separate gate attendance from class/PT attendance. **Schema blocked on `FND-000`.**

Required outputs:

- Digital member pass
- QR validation
- RFID/biometric ingest endpoint
- Device credential authentication
- Hardware-to-user mapping boundary
- Manual override
- Check-in/out
- Debounce/idempotency (depends on `FND-010`)
- Auto checkout job (depends on `FND-017`)
- Occupancy query
- Daily attendance aggregation
- Session participant attendance marking
- PT session counter integration

Hardware SDK/vendor specifics should live outside the domain service. The backend should expose a stable ingest adapter contract.

### V09 — Billing / Payments

Implement invoices and tender history without contaminating membership business rules. **Schema blocked on `FND-000`.**

Required outputs:

- Payment methods
- Invoice creation
- Tax/discount computation (server-side, exact decimal)
- Split tender
- Outstanding balances
- Receipts
- Refunds
- Adjustments
- Payment history
- Membership payment coupling
- Payment idempotency (depends on `FND-010` — a retried POS charge must not double-bill)
- Receipt media generation (depends on V05 and `FND-017`)
- Dashboard/report collection queries

For external gateway support, place webhooks behind an adapter and idempotent reconciliation path. Do not couple controllers directly to a gateway SDK.

### V10 — Workout

Implement plan lifecycle and live workout execution using version snapshots. **Schema blocked on `FND-000`.**

Required outputs:

- Workout plan CRUD
- Template creation/copy
- Plan publishing
- Versioning
- Exercise line-item replacement
- Active-plan uniqueness (database-enforced)
- Assigned-client scope
- Live session start
- Set logging
- Session completion
- Total volume calculation
- PR queries
- Workout history

### V11 — Diet

Mirror the workout plan architecture where appropriate without forcing accidental coupling. **Schema blocked on `FND-000`.**

Required outputs:

- Diet plan CRUD
- Template/copy flow
- Versioning
- Meals and food rows
- Nutritional aggregation
- Publish/assign lifecycle
- Active-plan uniqueness (database-enforced)
- Daily diet log upsert (unique per member per date, database-enforced)
- Adherence computation
- Client/trainer/admin scope

### V12 — Goals / Progress

Implement longitudinal measurements instead of storing only the latest number. **Schema blocked on `FND-000`.**

Required outputs:

- Goal metric master
- Goal lifecycle
- Goal history/check-ins
- Measurement sessions and values
- Goal current-value synchronization
- Target-achievement logic
- Progress notes
- Progress photos (depends on V05)
- Comparison queries
- Sensitive photo access rules

### V13 — Notifications / Devices

Turn the existing event bus into a durable notification pipeline. **Schema blocked on `FND-000`; jobs blocked on `FND-017`.**

Required outputs:

- Notification type/template registry
- Device registration
- Notification inbox
- Read state
- Push dispatcher adapter
- Delivery tracking
- Broadcast engine
- Event consumer idempotency (depends on `FND-010`)
- Scheduled reminders: membership expiry, payment due, session, freeze pending, trainer assignment
- Failed-delivery retry policy

Jobs should be observable and rerunnable. A failed job must not silently lose domain events.

### V14 — Dashboard

Build read-oriented aggregation services over completed modules.

Prefer separate query services per widget group and a single composition layer for `GET /dashboard`.

Unauthorized widget sections are omitted rather than failing the whole response. Avoid making the dashboard service own business state.

### V15 — Reports

Implement server-side reporting queries with explicit date/timezone rules using `utc-datetime.ts`.

Reports should use dedicated query/repository code and avoid reusing transactional repositories blindly.

Export should be streamed or generated asynchronously for large result sets; async export depends on `FND-017`.

### V16 — OpenAPI / Flutter API Client

Make the OpenAPI file and generated client a release gate. `scripts/check-openapi-parity.ts` already exists and enforces the deferred-path rules; broaden it to the full surface.

Required:

- Reconcile the documented-but-unimplemented backlog (`API-000`): `/auth/password/*`, `/roles*`, `/permissions`, `/audit-logs`
- Every implemented controller matches OpenAPI.
- Every documented path is implemented or explicitly marked `x-status: deferred`.
- Response schemas match actual JSON exactly.
- Error schemas are stable.
- Nullable/enum semantics match.
- Generated Dart API client is regenerated after contract changes.
- Flutter request models do not need special-case JSON patching.
- Backend-to-frontend endpoint matrix for all 44 consolidated screens.
- Reconcile `database-entities.md`'s stated count of 56 with its 57 enumerated tables, and document the infrastructure tables from §5.1.

### V17 — Production Readiness

Final hardening:

- Full unit/integration/e2e suite
- Concurrency tests
- Idempotency tests
- Authorization matrix tests
- PII access tests
- Performance tests for check-in/POS/calendar/dashboard
- Migration reproducibility
- Seed idempotency
- Audit append-only enforcement verified at the database privilege level
- Backup/restore drill
- Storage failure handling
- Job failure/retry tests and operator rerun path
- DB pool exhaustion behaviour
- Rate limit/security verification
- Production environment validation
- Deployment smoke tests

---

## 8. Critical Cross-Vertical Workflows

### Member onboarding

```text
create user
→ create member profile
→ optional trainer assignment
→ optional health/doc/photo data
→ optionally create membership
→ optionally create payment/invoice
→ emit onboarding events
→ notify trainer/member
```

### Membership purchase

```text
select product
→ calculate tax/discount on server
→ create invoice
→ collect tender(s)
→ settle invoice
→ activate membership
→ write membership history
→ generate receipt
→ emit payment + membership events
```

### PT booking

```text
member eligibility
→ remaining PT sessions > 0
→ trainer availability
→ no member overlap
→ no trainer overlap
→ create schedule/participant
→ confirmation notification
→ decrement PT sessions only on attended completion
```

### Class cancellation

```text
cancel schedule
→ cancel participants
→ record schedule history
→ do NOT consume PT entitlement
→ promote/reconcile waitlist if applicable
→ notify affected users
```

### Gate attendance

```text
QR/RFID/biometric/manual event
→ authenticate source
→ resolve user
→ verify active membership for members
→ enforce debounce/idempotency
→ create attendance
→ update occupancy read model
→ optional auto-checkout later
```

### Measurement update

```text
measurement session
→ validate metrics
→ store measurement values
→ match active goals
→ append goal history
→ update denormalized current_value
→ determine achieved state
→ emit progress event
```

---

## 9. Jobs / Background Processing

**There is no job runtime today.** `apps/api/package.json` declares no scheduler or queue. `FND-017` selects and installs the engine, `FND-018` defines the execution contract and `job_runs` table, `FND-019` adds observability. Every job below is blocked on those three.

Common job contract (persisted to `job_runs`):

```text
job name
schedule
attempt count
started_at
finished_at
status
error summary
correlation/request id
idempotency key
```

Required jobs:

1. Membership expiry/grace evaluation (`MEM-009`)
2. Freeze-end evaluation (`MEM-006`)
3. Membership renewal reminders (`MEM-010`, `NOT-013`)
4. Auto-checkout (`ATT-014`)
5. Attendance daily rollup (`ATT-013`)
6. Session reminders (`NOT-013`)
7. Payment due reminders (`NOT-013`)
8. Notification delivery retry (`NOT-014`)
9. Receipt PDF generation (`PAY-012`)
10. Orphan media cleanup (`MED-008`)
11. Expired session/token cleanup (`AUTH-011`)

For every job, define:

- schedule
- timezone source
- retry policy
- idempotency key
- failure logging
- operational manual rerun path

---

## 10. Observability

Minimum metrics:

- HTTP request count/latency/error rate
- Login failures
- Auth guard rejects
- DB pool saturation (requires `FND-014`)
- Check-in latency
- Booking conflicts
- Payment creation/settlement failures
- Job failures/retries and last-success timestamps (requires `FND-019`)
- Notification delivery success/failure
- Dashboard query latency
- Slow report queries

Every log should carry a request/correlation id when applicable; `src/platform/http/request-id.ts` already provides ALS-based propagation, and jobs must join it.

---

## 11. Testing Strategy

### Unit

Business rules isolated from HTTP and DB.

### Repository/integration

Run against a real database instance/container, not only mocked repositories. `test/helpers/mysql.ts` is the existing harness; it follows the engine chosen in `FND-000`.

### E2E

One representative happy path and failure path for every resource family. Current coverage: `auth`, `exercises`, `foods`, `people-onboarding`, `settings`.

### Authorization matrix

At minimum test:

- member own vs another member
- trainer assigned vs unassigned member
- receptionist vs manager/admin
- staff inactive/suspended
- missing permissions
- every `@RequirePermission` slug resolves in the seeded catalogue

### Concurrency

Explicit races for:

- two members booking last seat
- two bookings for same trainer
- two check-ins at the same time
- two payments settling one invoice
- two admins updating same high-contention record

### Idempotency

Explicit replays for:

- retried POS payment creation
- duplicate turnstile scan
- redelivered gateway webhook
- redelivered domain event to the notification consumer

### Contract

Run:

```bash
pnpm --filter api typecheck
pnpm --filter api test
pnpm --filter api test:e2e
pnpm --filter api openapi:dump
pnpm --filter api openapi:check
```

---

## 12. Definition of Backend Complete

Backend MVP is complete only when all of the following are true:

- The database engine decision is recorded in an accepted ADR and the schema matches it.
- All documented MVP domain tables exist and are migrated.
- All documented `/v1` resource families are implemented or explicitly marked deferred in `docs/openapi/v1.yaml`.
- All three application personas can complete their core workflows end-to-end.
- Authorization is enforced server-side for every resource.
- History/audit invariants are transactionally preserved, and `audit_logs` is immutable at the database privilege level.
- Constraint violations surface as correct 4xx responses.
- Money and time semantics are deterministic.
- Retried mutations are idempotent on every client-retryable path.
- Scheduled jobs run on a real runtime, record their runs, and can be rerun by an operator.
- Attendance hardware has a stable adapter boundary.
- Notification events are idempotent.
- Dashboard/report queries are performant on realistic gym-day data.
- OpenAPI and generated Flutter client are in parity.
- Full automated tests pass.
- Backup/restore and deployment procedures are verified.

---

## 13. Immediate Next Steps

1. **Close `FND-000`** — decide MySQL vs PostgreSQL and record it in an accepted ADR. Nothing else in §5.1 can start.
2. Build the three missing foundation mechanisms: idempotency (`FND-010`), job runtime (`FND-017`–`FND-019`), constraint-error translation (`FND-013`). Add env validation (`FND-006`) and security headers/rate limiting (`FND-005`) alongside.
3. Finish Auth (`AUTH-006`, `AUTH-007`, `AUTH-011`) and RBAC management (`RBAC-001`–`005`, `007`–`009`) — these are documented, unimplemented, and every subsequent vertical's authorization story assumes them.
4. Harden Media (V05) before Payments and Goals need it.
5. Finish Membership integration boundaries before Scheduling/Attendance.
6. Implement Scheduling next, because it is the central dependency for trainer workflows and PT attendance.
7. Implement Attendance and Payments as the two operational critical paths.
8. Implement Workout/Diet/Goals, then Notifications, Dashboard, and Reports.
9. Keep contract parity green throughout; run `openapi:check` on every vertical.

---

## 14. Repository Layout

Current and target layout. Planning documents live under `apps/api/todo/`, **not** `docs/` — a prior revision of this plan referenced `docs/backend-implementation-plan.md` and `docs/backend-tasks/`, neither of which exists.

```text
apps/api/src/
  auth/          # implemented
  rbac/          # guard/cache implemented; controllers pending
  people/        # implemented
  memb/          # implemented
  media/         # partial
  work/          # exercises only
  diet/          # foods only
  sys/           # implemented
  platform/      # implemented, with gaps (§2.2)
  sched/         # to build
  attn/          # to build
  pay/           # to build
  goal/          # to build
  notif/         # to build
  dash/          # to build
  rpt/           # to build

apps/api/src/platform/db/schema/
  ...22 tables today, 33 canonical tables to add (§5.1),
     plus idempotency_keys, job_runs and the password-reset token store...

apps/api/scripts/
  check-openapi-parity.ts
  check-schema-drift.ts
  dump-openapi.ts

apps/api/test/
  helpers/mysql.ts
  auth.e2e.spec.ts
  exercises.e2e.spec.ts
  foods.e2e.spec.ts
  people-onboarding.e2e.spec.ts
  settings.e2e.spec.ts

apps/api/todo/
  backend-implementation-plan.md
  backend-task-register.md
  backend-plan-and-tasks-review.md
  backend-tasks/               # created by API-011, or the FILE markers are dropped
    00-foundation.md
    01-auth.md
    02-rbac.md
    03-people.md
    04-health.md
    05-media.md
    06-membership.md
    07-scheduling.md
    08-attendance.md
    09-payments.md
    10-workout.md
    11-diet.md
    12-goals.md
    13-notifications.md
    14-dashboard.md
    15-reports.md
    16-api-contract-client.md
    17-production-readiness.md
    99-master-checklist.md

docs/
  backend-frd.md
  database-entities.md
  openapi/v1.yaml
  adr/
```

*End of backend implementation plan.*
