# LuxeKnox Backend — Master Task Register

**Purpose:** executable task register for completing the backend implementation plan.
**Source:** `apps/api/todo/backend-implementation-plan.md` + repository inspection.
**Status values:** `pending`, `in-progress`, `blocked`, `review`, `completed`.
**Last verified against code:** 2026-09-21 (`feature/backend-foundation` worktree — 49 unit test files, 5 e2e specs, 258 tests; `MEM-002`/`MEM-011` in `0010_membership_snapshot_and_constraints.sql`).

> Section numbers in this register are the **delivery order** and match `backend-implementation-plan.md` §6/§7 one-to-one (`V00`–`V17`). Task ID prefixes (`FND`, `AUTH`, `RBAC`, `PPL`, `HLT`, `MED`, `MEM`, `SCH`, `ATT`, `PAY`, `WRK`, `DIT`, `GOA`, `NOT`, `DSH`, `RPT`, `API`, `OPS`) are stable identifiers and never change, even if a section is resequenced.

> Files in this document are separated by explicit markers. Each marker names the intended standalone file under `apps/api/todo/backend-tasks/`. That directory does not exist yet — until it is created (`API-011`), this single file is the authoritative register.

## Status legend for verification notes

- `[x]` — implemented in `apps/api/src` and covered by at least one test.
- `[ ]` — not implemented, or implemented without the behaviour the task requires.
- **Verified:** / **Gap:** annotations record what was actually found in the code on the date above. Do not flip a checkbox without re-checking the cited path.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/00-foundation.md -->
<!-- ================================================================ -->

# Vertical 00 — Foundation

## Blocking gate

- [x] FND-000 **Settle the database engine before any new schema is authored.** — **Partial (feature branch):** MySQL 8.4 path chosen per ADR-0002 addendum (2026-09-21); `SCH-001`+ and `MEM-002` DB constraints authored on this branch. **Gap:** org-wide supersede of any `POSTGRES_MIGRATION_PLAN.md` on `main` and a final production cutover sign-off remain open before `FND-000` is fully closed.
  - Outcome A — stay on MySQL: supersede `POSTGRES_MIGRATION_PLAN.md`/`POSTGRES_MIGRATION_TASKS.md` and record the rejection in ADR-0002. *(in progress on `feature/backend-foundation`)*
  - Outcome B — move to PostgreSQL: execute the migration for the existing 22 tables **first**, then author the remaining 35 directly in `pg-core`. *(deferred)*

## Tasks

- [x] FND-001 Audit all platform helpers and document reusable contracts.
- [x] FND-002 Standardize global error envelope to `code`, `message`, `details`, `request_id`. — **Verified:** `src/platform/errors/exception.filter.ts`, `codes.ts`.
- [x] FND-003 Validate all request bodies through Zod pipes and remove ad-hoc parsing. — **Verified:** `src/platform/http/zod-validation.pipe.ts`.
- [x] FND-004 Standardize pagination, filters, sorting, and maximum page size. — **Verified:** `src/platform/http/pagination.ts`.
- [x] FND-005 Harden CORS/security headers/trusted proxy/rate-limit configuration. — **Verified:** `applySecurityHeaders` + env-driven CORS + `TRUST_PROXY`; `@nestjs/throttler` on `POST /auth/login` (30/15m) and `POST /auth/password/forgot` (5/15m), complements `LoginThrottle`.
- [x] FND-006 Add startup environment validation and fail-fast diagnostics. — **Verified:** `src/platform/config/env.ts` + `env.spec.ts`; `main.ts` calls `validateEnv()` before bind.
- [x] FND-007 Complete request-id propagation through service/job logs. — **Verified:** `src/platform/http/request-id.interceptor.ts` + ALS in `request-id.ts`.
- [x] FND-008 Harden transaction context and nested transaction semantics. — **Verified:** `src/platform/db/transaction-context.ts` + spec.
- [x] FND-009 Standardize optimistic concurrency handling and 409 mapping. — **Verified:** `src/platform/concurrency/row-version.ts`.
- [x] FND-010 Implement generic idempotency store/guard for required mutation endpoints. — **Verified:** `src/platform/idempotency/*`, `idempotency_keys` schema, `drizzle/0003_idempotency.sql`.
- [x] FND-011 Guarantee audit log append-only behaviour at the **service** level. — **Verified:** `src/platform/audit/audit.service.ts` exposes only `recordAudit()` (insert); no update/delete path.
- [x] FND-011a Enforce audit append-only at the **database privilege** level. — **Verified:** `drizzle/repeatable/grants.sql` grants `audit_logs` SELECT+INSERT only.
- [x] FND-012 Define domain event envelope: `event_id`, `event_name`, actor, occurred_at, payload. — **Verified:** `src/platform/events/domain-events.ts` + spec.
- [x] FND-013 Add consistent DB constraint/error translation. — **Verified:** `translateDbError()` in `src/platform/db/db-error.ts`, wired in `exception.filter.ts` + `db-error.spec.ts`.
- [x] FND-014 Add DB pool health/readiness diagnostics. — **Verified:** `getPoolStats()` returned from `/ready` in `health.controller.ts`.
- [x] FND-015 Establish migration + seed + drift-check release pipeline. — **Verified:** `db:migrate`, `db:seed`, `db:check` (`scripts/check-schema-drift.ts`).
- [x] FND-016 Add integration test utilities against real MySQL. — **Verified:** `test/helpers/mysql.ts`, 5 e2e specs.
- [x] FND-017 Add the background job runner/scheduler engine. — **Verified:** `@nestjs/schedule@4` in `package.json`; `ScheduleModule.forRoot()` in `src/job/job.module.ts`; ADR in `docs/adr/0008-background-job-scheduler.md`.
- [x] FND-018 Add the job execution contract and `job_runs` history table. — **Verified:** `drizzle/0007_job_runs.sql`, `src/platform/db/schema/job-runs.ts`, `JobRunRepository`, `JobRunnerService` (`run` + operator `rerun`), `job-runner.service.spec.ts`.
- [ ] FND-019 Add job observability: failure counters, retry counters, last-success timestamps exposed to `/ready` or a metrics endpoint. — Required by plan §10 and verified by `OPS-011`.

## Exit criteria

- [x] `FND-000` is closed and the target database engine is recorded in an accepted ADR. — **Partial:** ADR-0002 Accepted + 2026-09-21 addendum records MySQL path for `feature/backend-foundation`; final org-wide closure pending Postgres plan supersede on `main`.
- [ ] New verticals can reuse authz, transactions, audit, events, pagination, idempotency, concurrency, config validation and **the job runner** without local implementations.
- [x] Unit + integration + e2e infrastructure is reusable.
- [x] A constraint violation anywhere in the codebase produces a correct 4xx, not a 500. — **Verified:** `FND-013` + `db-error.spec.ts`.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/01-auth.md -->
<!-- ================================================================ -->

# Vertical 01 — Authentication

## Tasks

- [x] AUTH-001 Review existing auth implementation against FR-AUTH-001..010.
- [x] AUTH-002 Complete login email/phone normalization and ambiguity handling. — **Verified:** `src/auth/auth.service.ts` + `auth.service.spec.ts`.
- [x] AUTH-003 Verify access-token TTL enforcement and refresh-token TTL. — **Verified:** `src/auth/token.ts` + spec.
- [x] AUTH-004 Enforce refresh token family rotation and reuse revocation. — **Verified:** `auth.service.spec.ts` "detects refresh token reuse and revokes entire family".
- [x] AUTH-005 Complete logout current/all-session revocation. — **Verified:** `POST /auth/logout` + `session.cache.ts`.
- [x] AUTH-006 Complete change-password session invalidation. — **Verified:** `POST /auth/password/change` in `auth.controller.ts` + `auth.service.changePassword`.
- [x] AUTH-007 Complete password reset request/consume flow. — **Verified:** `password-reset-tokens` schema, `password-reset.repository.ts`, `forgot`/`reset` routes.
- [x] AUTH-008 Harden login throttling per identifier and IP. — **Verified:** `src/auth/login-throttle.ts`.
- [x] AUTH-009 Ensure inactive/suspended users cannot authenticate. — **Verified:** `auth.service.spec.ts`; `POST /employees/:id/status` revokes sessions on suspend.
- [x] AUTH-010 Complete `/me` projection with role, permissions and profile summary. — **Verified:** `src/auth/me.controller.ts` + spec.
- [x] AUTH-011 Add session cleanup/expiration job. — **Verified:** `SessionCleanupJob` scheduled daily via `ScheduledJobsService` (`0 2 * * *` UTC) with `job_runs` persistence.
- [x] AUTH-012 Add auth unit/e2e/security tests. — **Verified:** `test/auth.e2e.spec.ts` — password change, forgot+reset, reset-token replay rejection, logout-all sessions.

## Exit criteria

- [x] Full auth lifecycle — including password change and password reset — works from Flutter without special backend exceptions. — **Verified:** `test/auth.e2e.spec.ts`.
- [x] Every `/auth/*` path in `docs/openapi/v1.yaml` resolves to a real controller handler.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/02-rbac.md -->
<!-- ================================================================ -->

# Vertical 02 — RBAC

> Management API implemented on this branch (`role.controller.ts`, `role.service.ts`, `rbac.dto.ts`). Role-management authorization e2e matrix complete (`test/rbac.e2e.spec.ts`).

## Tasks

- [x] RBAC-001 Implement role controller and DTOs. — **Verified:** `src/rbac/role.controller.ts`, `rbac.dto.ts`, registered in `rbac.module.ts`.
- [x] RBAC-002 Implement role list/get/create/update. — **Verified:** `role.service.ts` + `role.service.spec.ts`.
- [x] RBAC-003 Implement permission catalogue endpoint. — **Verified:** `GET /permissions` in `role.controller.ts`.
- [x] RBAC-004 Implement role-permission replacement endpoint. — **Verified:** `PUT /roles/:id/permissions` + cache invalidation in `role.service.ts`.
- [x] RBAC-005 Enforce system-role immutability rules. — **Verified:** `role.service.spec.ts` rejects system-role update/replace.
- [x] RBAC-006 Complete employee role assignment integration. — **Verified:** `PUT /employees/:id/role` (`employee.controller.ts`, `roles.update`).
- [x] RBAC-007 Invalidate permission cache after role changes. — **Verified:** `permissionCache.invalidateRole` called from `role.service.ts` on create/update/replace.
- [x] RBAC-008 Verify permission slugs against seeded catalogue. — **Verified:** `src/rbac/permission-slugs.spec.ts`.
- [x] RBAC-009 Test permission guard + role management authorization. — **Verified:** `test/rbac.e2e.spec.ts` — member/trainer forbidden on `GET/POST /roles`; super admin allowed with `rbac.roles_read`/`rbac.roles_write`.

## Exit criteria

- [x] All role/permission screens are backed by real endpoints.
- [x] Changing a role's permission set takes effect on the next request without a restart.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/03-people.md -->
<!-- ================================================================ -->

# Vertical 03 — People

> Substantial implementation already exists under `src/people/`: member, trainer, employee, emergency-contact, member-document, member-health and member-photo controllers/services/repositories, plus `person.factory.ts`, `row-scope.ts`, `credentials.ts`. Checkboxes below reflect verified behaviour, not file existence.

## Tasks

- [ ] PPL-001 Review member CRUD against FR-PEOPLE-001..008. — **Partial:** CRUD + assign-trainer implemented; formal FR checklist not closed.
- [ ] PPL-002 Complete member dossier joins for membership, dues, attendance and next schedule. — **Partial:** `membership` populated from `MembershipRepository.findActiveOrFrozenForMember` (`member.service.ts`); `outstanding_balance`, `last_check_in`, `next_schedule` remain `null` (blocked on `PAY`/`SCH`/`ATT`).
- [ ] PPL-003 Add member directory filter coverage and efficient indexes.
- [x] PPL-004 Complete trainer CRUD and trainer directory load query. — **Verified:** `trainer.controller.ts` + `trainer.service.spec.ts`.
- [x] PPL-005 Complete assigned-member trainer query. — **Verified:** `GET /trainers/{id}/members`.
- [x] PPL-006 Enforce trainer capacity at assignment with audited override reason. — **Verified:** `member.service.spec.ts` capacity/override cases.
- [x] PPL-007 Complete trainer deactivate behavior. — **Verified:** `is_active` on `TrainerUpdateDto`; inactive trainer rejected on assign (`member.service.ts`).
- [x] PPL-008 Complete employee lifecycle/status operations. — **Verified:** `src/people/employee.controller.ts` list/get/create/update, `PUT :id/role`, `POST :id/status`.
- [ ] PPL-009 Complete credential updates with unique email/phone handling. — **Partial:** `src/people/credentials.ts` exists; confirm duplicate-identifier collisions return 409 rather than 500 (**depends on `FND-013`**).
- [ ] PPL-010 Add onboarding integration tests. — **Partial:** `test/people-onboarding.e2e.spec.ts` exists. Extend to cover trainer assignment and document/photo attachment.
- [ ] PPL-011 Add row-scope matrix tests. — **Partial:** `src/people/row-scope.spec.ts` exists; the full persona matrix from plan §11 is not covered.

## Exit criteria

- [ ] Admin, trainer and member profile flows remain correct after downstream modules are added.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/04-health.md -->
<!-- ================================================================ -->

# Vertical 04 — Health

> **Contract constraint.** `docs/openapi/v1.yaml` marks `/health-conditions`, `/health-conditions/{id}`, `/members/{id}/medical-histories` and `/members/{id}/medical-histories/{historyId}` as `x-status: deferred`, and `apps/api/scripts/check-openapi-parity.ts` actively fails the build in **both** directions: it throws if a deferred path appears in the required MVP set (line 154), and it throws if those paths stop being `deferred` in the YAML (line 164). `health_conditions` and `medical_histories` are correspondingly absent from `src/platform/db/schema/`. `HLT-002` and `HLT-003` therefore cannot be delivered without first amending the contract — see `HLT-000`.

## Tasks

- [x] HLT-000 **Product decision — promote or keep deferred.** — **Decision:** promoted on this branch; `health-conditions` / `medical-histories` are `x-status: mvp` in OpenAPI and implemented under `src/health/`.
- [ ] HLT-001 Verify current health one-row invariant. — **Partial:** service upsert + `member-health.service.spec.ts`; DB unique constraint not re-verified here.
- [x] HLT-002 Implement health-condition master CRUD. — **Verified:** `health-condition.controller.ts` + service/repository (no dedicated spec).
- [x] HLT-003 Complete medical-history CRUD and clearance rules. — **Verified:** `medical-history.controller.ts` + service.
- [x] HLT-004 Complete emergency-contact CRUD and primary-contact invariant. — **Verified:** `emergency-contact.controller.ts` + `emergency-contact.service.spec.ts`.
- [x] HLT-005 Complete member-document upload/reference/verify/delete flow. — **Verified:** `member-document.controller.ts` + `member-document.service.spec.ts`.
- [ ] HLT-006 Complete member-photo gallery/avatar consistency. — **Partial:** controller/service exist; one-avatar DB invariant not confirmed.
- [x] HLT-007 Enforce trainer restriction on identity-proof documents. — **Verified:** `member-document.service.ts` + `member-document.service.spec.ts`.
- [x] HLT-008 Audit all privileged health reads/writes. — **Verified:** `privileged-audit.ts` + audit calls in health services.
- [ ] HLT-009 Add sensitive-data tests. — **Partial:** document trainer-restriction test only; no full sensitive-data matrix.

## Exit criteria

- [ ] Health data is scoped, audited and fully usable by documented screens. *(core flows built; OpenAPI still marks some member doc/photo paths `deferred` while implemented)*
- [ ] `pnpm --filter api openapi:check` passes with the deferred set in whichever state `HLT-000` decided.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/05-media.md -->
<!-- ================================================================ -->

# Vertical 05 — Media

> **Resequenced.** Media was previously section 15, after Dashboard and Reports. That ordering was unbuildable: `PAY-012` (receipt PDF generation) consumes Media, `HLT-005`/`HLT-006` (member documents, avatars) consume Media, and `GOA-011` (progress photos) consumes Media. Media now sits ahead of every vertical that depends on it. Task IDs are unchanged.

## Tasks

- [x] MED-001 Finalize storage abstraction interface. — **Verified:** `storage.interface.ts`, `local-disk.adapter.ts`, `s3.adapter.ts`.
- [x] MED-002 Validate upload purposes and MIME/size rules. — **Verified:** `media.dto.ts` + `storage.service.spec.ts`.
- [x] MED-003 Implement signed upload slot generation. — **Verified:** `POST /media/uploads` + `media-signing.ts`.
- [x] MED-004 Implement signed download URLs. — **Verified:** `GET /media/:key` + local adapter GET.
- [x] MED-005 Enforce parent-entity row-scope authorization on downloads. — **Verified:** `media-auth.service.ts` + `media-auth.service.spec.ts`.
- [x] MED-006 Implement allowed deletion rules. — **Verified:** `media-deletion.service.ts` + spec.
- [x] MED-007 Integrate receipt/exercise/member/progress-photo use cases. — **Verified:** `media-use-cases.ts` + `media-use-cases.spec.ts`.
- [x] MED-008 Implement orphan object cleanup job. — **Verified:** `orphan-cleanup.job.ts` scheduled daily via `ScheduledJobsService` (`0 3 * * *` UTC) with `job_runs` persistence.
- [x] MED-009 Document local vs production object-storage deployment. — **Verified:** `src/media/README.md`.
- [x] MED-010 Add storage outage/error handling tests. — **Verified:** `storage.service.spec.ts`.

## Exit criteria

- [x] File references are reliable without putting binary bytes in relational tables. — **Verified:** orphan cleanup job scheduled (`MED-008`).
- [ ] Health documents, member photos, receipts and progress photos all resolve through one storage abstraction. *(member docs/photos wired; receipts/progress photos await PAY/GOA)*

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/06-membership.md -->
<!-- ================================================================ -->

# Vertical 06 — Membership

> Ported from `main` on 2026-09-21: `src/memb/` (12 files), `schema/memberships.ts`, `drizzle/0008_memberships.sql`. People dossier joins active/frozen contract via `member.service.ts`.

## Tasks

- [x] MEM-001 Complete membership product CRUD and active subscriber count. — **Verified:** `membership-product.*` + `membership-product.service.spec.ts` (`active_subscriber_count` via `countActiveSubscribers`).
- [x] MEM-002 Enforce one active/frozen membership per member. — **Verified:** service rule + `membership.service.spec.ts`; DB unique index via `active_member_id` stored generated column in `drizzle/0010_membership_snapshot_and_constraints.sql` (ADR-0002 pattern).
- [x] MEM-003 Enforce active/frozen locker uniqueness. — **Verified:** `membership.service.spec.ts` locker `ConflictError`; `findByLockerNumberActiveOrFrozen` in repository.
- [x] MEM-004 Complete membership create/renew/upgrade/cancel state machine. — **Verified:** `membership.service.spec.ts` create/renew/upgrade/cancel + row_version conflict.
- [x] MEM-005 Complete freeze request/approve/reject/direct-create flow. — **Verified:** `membership.service.spec.ts` requestFreeze (member pending + admin direct), approveFreeze, rejectFreeze.
- [x] MEM-006 Enforce freeze quota and overlap rules. — **Verified:** `membership.service.spec.ts` overlap + `max_freeze_days` quota at request and approval.
- [x] MEM-007 Complete extension flow and history. — **Verified:** `membership.service.spec.ts` extend; `membership_extensions` table in `0008_memberships.sql`.
- [x] MEM-008 Complete immutable membership history. — **Verified:** `insertHistory` on every mutation in service; `listHistory` in `membership.service.spec.ts`; `GET /memberships/{id}/history` in controller.
- [x] MEM-009 Add expiry/grace-period job. — **Verified:** `membership-expiry.job.ts` scheduled daily via `ScheduledJobsService` (`0 4 * * *` UTC) with `job_runs` persistence; grace period from `membership.grace_period_days`; `membership-expiry.job.spec.ts`.
- [x] MEM-010 Emit renewal reminder events. — **Verified:** `membership.renewal_reminder` domain events in `membership-expiry.job.ts` with deterministic per-membership-per-day `eventId`; thresholds from `membership.renewal_reminder_days`.
- [x] MEM-011 Define membership product term snapshot for historical contracts. — **Verified:** `product_term_snapshot` JSON on `memberships` (`drizzle/0010_membership_snapshot_and_constraints.sql`, `schema/memberships.ts`); `buildProductTermSnapshot()` written on create/renew/upgrade in `membership.service.ts`; repository resolves `product` from snapshot for API reads; `membership-product-snapshot.spec.ts` + service spec assertions.
- [ ] MEM-012 Add integration tests with schedule and payment dependencies. — **Blocked on `V09` (`PAY-008`).** `V07` scheduling core is available.

## Exit criteria

- [ ] Membership becomes authoritative for booking/check-in/entitlement decisions.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/07-scheduling.md -->
<!-- ================================================================ -->

# Vertical 07 — Scheduling

> Six tables in `drizzle/0009_scheduling.sql` + `src/platform/db/schema/scheduling.ts`; module at `src/sched/`.

## Tasks

- [x] SCH-001 Add schedule schema tables and indexes. — **Verified:** `drizzle/0009_scheduling.sql`, `src/platform/db/schema/scheduling.ts`.
- [x] SCH-002 Implement schedule-type master CRUD. — **Verified:** `schedule-type.*` + `schedules.read`/`schedules.write`.
- [x] SCH-003 Implement facility master CRUD. — **Verified:** `facility.*`.
- [x] SCH-004 Implement trainer availability CRUD and overrides. — **Verified:** `trainer-availability.*` (`PUT /trainers/{id}/availability` replace semantics).
- [x] SCH-005 Implement availability/slot calculation service. — **Verified:** `slot-calculation.ts`, `slot-calculation.service.ts`, `slot-calculation.spec.ts`.
- [x] SCH-006 Implement schedule create/update/read/list. — **Verified:** `schedule.*` + `schedule.service.spec.ts` conflict case.
- [x] SCH-007 Implement recurring schedule series creation. — **Verified:** `recurring-schedule.ts` + `recur_until` in `schedule.service.ts` (`recurring-schedule.spec.ts`, `schedule.service.spec.ts`).
- [x] SCH-008 Implement cancel-one vs cancel-series semantics. — **Verified:** `cancel_series` on `CancelRequestDto`; `schedule.service.cancel` + spec.
- [ ] SCH-009 Implement participant booking.
- [ ] SCH-010 Implement booking cancellation cutoff rules.
- [ ] SCH-011 Implement FIFO waitlist promotion.
- [ ] SCH-012 Enforce trainer/member/facility overlap conflicts.
- [ ] SCH-013 Enforce booking lead-time and member booking caps.
- [ ] SCH-014 Implement schedule start/complete/cancel state transitions.
- [ ] SCH-015 Implement schedule history.
- [ ] SCH-016 Add optimistic-concurrency protections. — Reuse `src/platform/concurrency/row-version.ts` (`FND-009`).
- [ ] SCH-017 Emit booking/cancellation/waitlist/session events.
- [ ] SCH-018 Add date-range calendar query optimization.
- [ ] SCH-019 Add race-condition tests for last-seat booking.

## Exit criteria

- [ ] Member, trainer and admin calendars operate from the same authoritative scheduling service.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/08-attendance.md -->
<!-- ================================================================ -->

# Vertical 08 — Attendance

> Two tables to author: `attendances`, `attendance_histories`. Schema authoring unblocked on this branch (MySQL 8.4 per ADR-0002 addendum).

## Tasks

- [ ] ATT-001 Add attendance tables/schema and indexes.
- [ ] ATT-002 Implement member digital attendance pass generation.
- [ ] ATT-003 Define QR token signing/expiry validation.
- [ ] ATT-004 Implement hardware device credential model.
- [ ] ATT-005 Implement hardware event ingest adapter boundary.
- [ ] ATT-006 Implement QR/RFID/biometric/manual check-in.
- [ ] ATT-007 Implement check-out and open-attendance lookup.
- [ ] ATT-008 Implement debounce/idempotency for repeated scans. — **Blocked on `FND-010`.**
- [ ] ATT-009 Enforce membership eligibility and daily check-in caps.
- [ ] ATT-010 Implement manual override and audit.
- [ ] ATT-011 Implement assigned-member/admin attendance queries.
- [ ] ATT-012 Implement attendance summary/streak/heatmap query.
- [ ] ATT-013 Implement daily attendance-history rollup job.
- [ ] ATT-014 Implement auto-checkout job.
- [ ] ATT-015 Implement schedule participant attendance marking.
- [ ] ATT-016 Integrate PT session consumption rules.
- [ ] ATT-017 Add occupancy query optimized for dashboard.
- [ ] ATT-018 Add hardware duplicate-event e2e tests.

## Exit criteria

- [ ] Gate attendance and session attendance remain distinct and both are fully operational.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/09-payments.md -->
<!-- ================================================================ -->

# Vertical 09 — Payments

> Four tables to author: `payment_methods`, `payments`, `payment_receipts`, `payment_histories`. Schema authoring unblocked on this branch.

## Tasks

- [ ] PAY-001 Add payment methods schema and CRUD.
- [ ] PAY-002 Add payment/invoice schema, histories and receipts.
- [ ] PAY-003 Implement invoice-number generator. — Follow the `membership_number_counters` pattern already in `src/platform/db/schema/`.
- [ ] PAY-004 Implement payment create with server tax/discount calculation. — Use `src/platform/money/money.ts`; **requires `FND-010`** so a retried POS charge cannot double-bill.
- [ ] PAY-005 Implement split-tender settlement.
- [ ] PAY-006 Implement outstanding balance queries.
- [ ] PAY-007 Implement member/trainer/admin scoped payment views.
- [ ] PAY-008 Implement membership purchase/renew coordination transaction.
- [ ] PAY-009 Implement refund with upper-bound validation.
- [ ] PAY-010 Implement adjustment flow and immutable history.
- [ ] PAY-011 Implement receipt number generation.
- [ ] PAY-012 Implement receipt PDF generation through Media. — **Depends on `V05` (`MED-007`) and `FND-017`.**
- [ ] PAY-013 Add optional gateway adapter/webhook boundary.
- [ ] PAY-014 Make gateway/webhook processing idempotent. — **Blocked on `FND-010`.**
- [ ] PAY-015 Emit payment-created/payment-settled/payment-refunded events.
- [ ] PAY-016 Add financial concurrency tests.
- [ ] PAY-017 Add collection queries for dashboard/reports.

## Exit criteria

- [ ] POS/payment workflows are correct, auditable and exact to the cent.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/10-workout.md -->
<!-- ================================================================ -->

# Vertical 10 — Workout

> `exercises` exists (`src/work/`). Five tables remain: `workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises`.

## Tasks

- [ ] WRK-001 Add workout plan/version/line-item/session schema.
- [ ] WRK-002 Export new schema from central schema index (`src/platform/db/schema/index.ts`).
- [ ] WRK-003 Implement workout-plan CRUD.
- [ ] WRK-004 Implement trainer assigned-member scope.
- [ ] WRK-005 Implement admin template CRUD.
- [ ] WRK-006 Implement template copy-on-assign.
- [ ] WRK-007 Implement publish/archive state machine.
- [ ] WRK-008 Enforce one active assigned plan per member. — DB-level constraint per plan §5.2 and ADR-0002.
- [ ] WRK-009 Implement active-plan version creation before edits.
- [ ] WRK-010 Implement version exercise replacement.
- [ ] WRK-011 Implement member plan reads.
- [ ] WRK-012 Implement workout session start.
- [ ] WRK-013 Enforce one in-progress workout session per member. — DB-level constraint.
- [ ] WRK-014 Implement set logging.
- [ ] WRK-015 Implement session completion/volume calculation.
- [ ] WRK-016 Implement history and PR queries.
- [ ] WRK-017 Add tests for version snapshot correctness.

## Exit criteria

- [ ] Trainer plans and member execution work without mutating historical snapshots.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/11-diet.md -->
<!-- ================================================================ -->

# Vertical 11 — Diet

> `foods` exists (`src/diet/`). Five tables remain: `diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, `diet_histories`.

## Tasks

- [ ] DIT-001 Add diet plan/version/meal/food-log schema.
- [ ] DIT-002 Export new schema from central index.
- [ ] DIT-003 Implement diet-plan CRUD.
- [ ] DIT-004 Implement trainer/admin scope rules.
- [ ] DIT-005 Implement template copy-on-assign.
- [ ] DIT-006 Implement publish/archive lifecycle.
- [ ] DIT-007 Enforce one active assigned diet per member. — DB-level constraint.
- [ ] DIT-008 Implement active-plan versioning.
- [ ] DIT-009 Implement meal/food replacement.
- [ ] DIT-010 Implement daily diet-log upsert. — Unique `(member_id, date)` at the database level.
- [ ] DIT-011 Implement adherence formula from settings.
- [ ] DIT-012 Implement nutrition rollups.
- [ ] DIT-013 Add version/history tests.

## Exit criteria

- [ ] Trainer can manage diet plans and members can log adherence from the app.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/12-goals.md -->
<!-- ================================================================ -->

# Vertical 12 — Goals & Progress

> Seven tables to author: `goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`, `progress_photos`, `progress_notes`.

## Tasks

- [ ] GOA-001 Add goal metric/goal/history/measurement schema.
- [ ] GOA-002 Add progress photos/notes schema.
- [ ] GOA-003 Implement metric master CRUD.
- [ ] GOA-004 Implement goal create/update/status transitions.
- [ ] GOA-005 Implement goal check-ins and goal history.
- [ ] GOA-006 Implement measurement-session write endpoint with batch values.
- [ ] GOA-007 Validate mandatory metrics by settings.
- [ ] GOA-008 Synchronize goal current_value from measurement/history writes.
- [ ] GOA-009 Implement goal-achievement state logic.
- [ ] GOA-010 Implement progress-note stream with author/scope rules.
- [ ] GOA-011 Implement progress-photo upload/reference/deletion/moderation. — **Depends on `V05` (`MED-005`, `MED-007`).**
- [ ] GOA-012 Implement two-date comparison queries.
- [ ] GOA-013 Add longitudinal chart query optimization.
- [ ] GOA-014 Add authorization and private-photo tests.

## Exit criteria

- [ ] Progress is longitudinal, auditable and suitable for charts/dashboard/report use.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/13-notifications.md -->
<!-- ================================================================ -->

# Vertical 13 — Notifications

> Four tables to author: `notification_types`, `notifications`, `user_devices`, `notification_deliveries`.

## Tasks

- [ ] NOT-001 Add notification type/notification/device/delivery schema.
- [ ] NOT-002 Seed notification types/templates.
- [ ] NOT-003 Implement notification inbox query.
- [ ] NOT-004 Implement notification detail.
- [ ] NOT-005 Implement mark-read and mark-all-read.
- [ ] NOT-006 Implement device registration/rotation/deletion.
- [ ] NOT-007 Implement push dispatcher adapter.
- [ ] NOT-008 Persist delivery state and failure reason.
- [ ] NOT-009 Add idempotent event-to-notification consumer. — **Blocked on `FND-010`.**
- [ ] NOT-010 Implement admin broadcast audience resolution.
- [ ] NOT-011 Implement trainer assigned-client broadcast restriction.
- [ ] NOT-012 Implement broadcast history.
- [ ] NOT-013 Add membership/session/payment reminder jobs.
- [ ] NOT-014 Add failed-delivery retry policy. — Attempt counters live in `job_runs`.
- [ ] NOT-015 Ensure deactivated users are excluded.
- [ ] NOT-016 Add notification delivery tests.

## Exit criteria

- [ ] Every required domain event can produce a user-visible notification without duplicates.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/14-dashboard.md -->
<!-- ================================================================ -->

# Vertical 14 — Dashboard

## Tasks

- [ ] DSH-001 Create dashboard query/composition service.
- [ ] DSH-002 Implement member home widgets.
- [ ] DSH-003 Implement trainer home widgets.
- [ ] DSH-004 Implement admin home widgets.
- [ ] DSH-005 Omit unauthorized widget sections rather than failing whole response.
- [ ] DSH-006 Add short-lived cache where useful.
- [ ] DSH-007 Optimize occupancy/revenue-today queries. — **Depends on `ATT-017`, `PAY-017`.**
- [ ] DSH-008 Add dashboard latency tests.

## Exit criteria

- [ ] `/dashboard` satisfies each persona without embedding business mutations.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/15-reports.md -->
<!-- ================================================================ -->

# Vertical 15 — Reports

## Tasks

- [ ] RPT-001 Create report query service.
- [ ] RPT-002 Implement member report.
- [ ] RPT-003 Implement membership report.
- [ ] RPT-004 Implement attendance report.
- [ ] RPT-005 Implement payment/revenue report.
- [ ] RPT-006 Implement trainer report.
- [ ] RPT-007 Implement workout report.
- [ ] RPT-008 Implement diet report.
- [ ] RPT-009 Implement progress report.
- [ ] RPT-010 Enforce trainer own-slice restrictions.
- [ ] RPT-011 Apply gym timezone date boundaries consistently. — Reuse `src/platform/db/utc-datetime.ts`.
- [ ] RPT-012 Implement CSV export.
- [ ] RPT-013 Add large-report streaming/async export strategy. — Async export **depends on `FND-017`**.
- [ ] RPT-014 Add report query performance tests.

## Exit criteria

- [ ] All documented report screens are powered by stable server-side queries.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/16-api-contract-client.md -->
<!-- ================================================================ -->

# Vertical 16 — API Contract & Flutter Client

> `docs/openapi/v1.yaml` currently documents **114 paths**; `apps/api/src` implements **17 controllers**. The parity gate (`scripts/check-openapi-parity.ts`) already exists and enforces the deferred-path rules; it must be extended to cover the whole surface as verticals land.

## Tasks

- [ ] API-000 **Reconcile the documented-but-unimplemented backlog.** At minimum, these paths exist in `docs/openapi/v1.yaml` with no controller behind them and are not attributable to a pending vertical: `POST /auth/password/change`, `POST /auth/password/forgot`, `POST /auth/password/reset` (`AUTH-006`/`AUTH-007`), `GET/POST /roles`, `GET/PATCH /roles/{id}`, `PUT /roles/{id}/permissions`, `GET /permissions` (`RBAC-001..004`), `GET /audit-logs` (no controller anywhere in `src`). Either implement or mark each explicitly deferred; do not leave them silently missing.
- [ ] API-001 Make every controller response conform exactly to OpenAPI.
- [ ] API-002 Add missing OpenAPI response/error schemas for new verticals.
- [ ] API-003 Add security requirements and permission notes where needed.
- [ ] API-004 Implement OpenAPI parity gate in CI. — **Partial:** `scripts/check-openapi-parity.ts` exists and runs via `pnpm --filter api openapi:check`; confirm it is wired into CI and broadened past the deferred-path assertions.
- [ ] API-005 Regenerate `packages/api_client` after each contract change.
- [ ] API-006 Add generated-client smoke tests against local API.
- [ ] API-007 Remove stale undocumented routes or explicitly mark deferred routes.
- [ ] API-008 Verify pagination/filter/query parameter parity with Flutter usage.
- [ ] API-009 Verify nullable/enum/date/money serialization across Dart/TS.
- [ ] API-010 Create a backend-to-frontend endpoint matrix for all 44 consolidated screens.
- [ ] API-011 Split this register into `apps/api/todo/backend-tasks/*.md` per the FILE markers, or drop the markers and keep one file. Update the path references in `backend-implementation-plan.md` §14 to match whichever is chosen.

## Exit criteria

- [ ] Flutter does not need custom patches to consume API responses.
- [ ] Every path in `docs/openapi/v1.yaml` is implemented or carries an explicit `x-status: deferred`.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/17-production-readiness.md -->
<!-- ================================================================ -->

# Vertical 17 — Production Readiness

## Tasks

- [ ] OPS-001 Run full unit/typecheck/lint/e2e suite on clean environment.
- [ ] OPS-002 Add authorization matrix integration suite.
- [ ] OPS-003 Add race/concurrency suite for booking/check-in/payment.
- [ ] OPS-004 Add p95 latency tests for check-in, POS and dashboard.
- [ ] OPS-005 Add backup/restore verification.
- [ ] OPS-006 Add migration reproducibility check on clean DB.
- [ ] OPS-007 Verify seed idempotency. — Seeds in `src/platform/db/seed/` are written idempotently; add the assertion.
- [ ] OPS-008 Verify audit append-only enforcement **at the database privilege level**. — Verifies `FND-011a`; a test that only exercises `AuditService` does not satisfy this.
- [ ] OPS-009 Verify sensitive data is excluded from logs.
- [ ] OPS-010 Verify secret/config handling in deployment. — **Depends on `FND-006`.**
- [ ] OPS-011 Verify job retries and operator reruns. — **Depends on `FND-017`/`FND-018`/`FND-019`.**
- [ ] OPS-012 Verify media storage outage behavior.
- [ ] OPS-013 Verify database pool exhaustion behavior. — **Depends on `FND-014`.**
- [ ] OPS-014 Run production smoke-test script.
- [ ] OPS-015 Freeze API contract and regenerate client for release.

## Exit criteria

- [ ] Backend can be deployed to a production-like environment with repeatable recovery procedures.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/99-master-checklist.md -->
<!-- ================================================================ -->

# Master Completion Checklist

| # | Vertical | Status | Note |
|---:|---|---|---|
| 00 | Foundation | ☐ | `FND-000` partial (MySQL path on branch); `FND-019` open; `FND-005`/`FND-017`/`FND-018` done |
| 01 | Auth | ☑ | Routes + `AUTH-011` scheduled + `AUTH-012` e2e complete |
| 02 | RBAC | ☑ | Management API + slug drift + `RBAC-009` authz e2e complete |
| 03 | People | ☐ | Core CRUD built; dossier joins + matrix tests open |
| 04 | Health | ☐ | Promoted conditions/histories; avatar invariant + sensitive tests open |
| 05 | Media | ☐ | Core storage built; `MED-008` scheduled |
| 06 | Membership | ☐ | `MEM-001`–`MEM-011` done; `MEM-012` blocked on `V09` |
| 07 | Scheduling | ☐ | `SCH-001`–`SCH-008` done; booking/waitlist/conflicts open |
| 08 | Attendance | ☐ | Not started |
| 09 | Payments | ☐ | Not started; needs `FND-010` |
| 10 | Workout | ☐ | `exercises` only |
| 11 | Diet | ☐ | `foods` only |
| 12 | Goals/Progress | ☐ | Not started |
| 13 | Notifications | ☐ | Not started |
| 14 | Dashboard | ☐ | Not started |
| 15 | Reports | ☐ | Not started |
| 16 | API/OpenAPI/Flutter client parity | ☐ | Parity script exists; `API-000` backlog open |
| 17 | Production readiness | ☐ | Not started |

> RBAC management API is complete on `feature/backend-foundation`. Membership: `MEM-002` DB constraint + `MEM-011` product snapshot landed in `0010_membership_snapshot_and_constraints.sql`. `FND-000` partially closed — MySQL 8.4 path per ADR-0002 addendum.

## Delivery order

`FND(00) → AUTH(01) → RBAC(02) → PPL(03) → HLT(04) → MED(05) → MEM(06) → SCH(07) → ATT(08) → PAY(09) → WRK(10) → DIT(11) → GOA(12) → NOT(13) → DSH(14) → RPT(15) → API(16) → OPS(17)`

Section numbers **are** the delivery order and match `backend-implementation-plan.md` §6/§7 exactly.

## Global definition of done for every task

- [ ] Code implemented
- [ ] Database schema/migration updated when applicable
- [ ] Permission/row scope enforced
- [ ] Audit/history added when applicable
- [ ] Domain events added when applicable
- [ ] OpenAPI updated
- [ ] Tests added
- [ ] Typecheck/lint/test/e2e pass
- [ ] Flutter generated client refreshed when contract changed
- [ ] Task status updated **with a one-line code-path citation**, so the next audit can confirm it without re-deriving

## Rule for marking a task complete

A checkbox may only be ticked when the behaviour is present in `apps/api/src` **and** covered by a test. "A file with a plausible name exists" is not completion — that is precisely how Foundation, Auth and RBAC came to be signed off while `/roles`, `/permissions` and `/auth/password/*` had no handler.
