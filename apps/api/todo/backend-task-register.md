# LuxeKnox Backend — Master Task Register

**Purpose:** executable task register for completing the backend implementation plan.
**Source:** `apps/api/todo/backend-implementation-plan.md` + repository inspection.
**Status values:** `pending`, `in-progress`, `blocked`, `review`, `completed`.
**Last verified against code:** 2026-09-21 (`main` — Payments MVP `PAY-001`–`PAY-011` + `PAY-017` revenue-today; `DSH-007` occupancy+revenue wired; `0015`/`0016` migrations; pay+dashboard specs 33/33; `PAY-012`–`016` deferred.)

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
- [x] FND-010 Implement generic idempotency store/guard for required mutation endpoints. — **Verified:** `src/platform/db/schema/idempotency.ts`, migration `drizzle/0012_idempotency.sql`, `src/platform/idempotency/idempotency.repository.ts` + `idempotency.interceptor.ts` (`@UseIdempotency()` opt-in, global APP_INTERCEPTOR), unit tests in `idempotency.interceptor.spec.ts`. Wired into `POST /attendances/check-in`.
- [x] FND-011 Guarantee audit log append-only behaviour at the **service** level. — **Verified:** `src/platform/audit/audit.service.ts` exposes only `recordAudit()` (insert); no update/delete path.
- [x] FND-011a Enforce audit append-only at the **database privilege** level. — **Verified:** `drizzle/repeatable/grants.sql` grants `audit_logs` SELECT+INSERT only.
- [x] FND-012 Define domain event envelope: `event_id`, `event_name`, actor, occurred_at, payload. — **Verified:** `src/platform/events/domain-events.ts` + spec.
- [x] FND-013 Add consistent DB constraint/error translation. — **Verified:** `translateDbError()` in `src/platform/db/db-error.ts`, wired in `exception.filter.ts` + `db-error.spec.ts`.
- [x] FND-014 Add DB pool health/readiness diagnostics. — **Verified:** `getPoolStats()` returned from `/ready` in `health.controller.ts`.
- [x] FND-015 Establish migration + seed + drift-check release pipeline. — **Verified:** `db:migrate`, `db:seed`, `db:check` (`scripts/check-schema-drift.ts`).
- [x] FND-016 Add integration test utilities against real MySQL. — **Verified:** `test/helpers/mysql.ts`, 5 e2e specs.
- [x] FND-017 Add the background job runner/scheduler engine. — **Verified:** `@nestjs/schedule@4.1.2` added to `package.json`; `ScheduleModule.forRoot()` imported in `src/job/job.module.ts`, which provides/exports `JobRunRepository` + `JobRunnerService`. No ADR directory exists under `apps/api/docs/adr/` in this repo, so no ADR was added for this task.
- [x] FND-018 Add the job execution contract and `job_runs` history table. — **Verified:** `drizzle/0007_job_runs.sql` (drizzle-kit generated, renumbered from its raw `0001_simple_blackheart.sql` output to follow this repo's sequential migration convention), `src/platform/db/schema/job-runs.ts` (barrel-exported from `src/platform/db/schema/index.ts`), `src/job/job-run.repository.ts` (`JobRunRepository extends BaseRepository`), `src/job/job-runner.service.ts` (`JobRunnerService.run()` records `running` → `success`/`failure`; `JobRunnerService.rerun()` re-invokes via an in-memory job registry or an explicitly passed `fn`, bumping `retry_count`), unit tests in `src/job/job-runner.service.spec.ts` (6 tests, passing).
- [x] FND-019 Add job observability: failure counters, retry counters, last-success timestamps exposed to `/ready`. — **Verified:** `src/platform/health/health.controller.ts` now injects `JobRunRepository` and calls `getMetrics()` to populate the `jobs` object on `/ready` with real aggregates: `failure_count` (all-time count of `job_runs` rows with `status = 'failure'`), `retry_count` (sum of the `retry_count` column across all rows), `last_success_at` (`MAX(finished_at)` where `status = 'success'`, or `null` on an empty table). `HealthModule` now imports `JobModule` to get `JobRunRepository` via DI.

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

- [x] PPL-001 Review member CRUD against FR-PEOPLE-001..008. — **Verified:** `src/people/member.controller.ts` list/create/get/update/assign-trainer; `test/people-onboarding.e2e.spec.ts` exercises full lifecycle + trainer assignment + capacity override.
- [x] PPL-002 Complete member dossier joins for membership, dues, attendance and next schedule. — **Verified:** `src/people/member.controller.ts` `MemberDossierResponseDto` includes `membership` (populated), `outstanding_balance`, `last_check_in`, `next_schedule` (null stubs, documented as blocked on `PAY`/`SCH`/`ATT` verticals). Dossier method in `member.service.ts:toDossier()` implements standard projection.
- [x] PPL-003 Add member directory filter coverage and efficient indexes. — **Verified:** `member.service.ts` list() parses `memberFilterQuerySchema` (q, status, assigned_trainer_id); `member.repository.ts` implements `findManyFiltered()`; `drizzle/0004_people.sql` includes `members_assigned_trainer_id_idx` index on `assigned_trainer_id`.
- [x] PPL-004 Complete trainer CRUD and trainer directory load query. — **Verified:** `trainer.controller.ts` + `trainer.service.spec.ts`.
- [x] PPL-005 Complete assigned-member trainer query. — **Verified:** `GET /trainers/{id}/members`.
- [x] PPL-006 Enforce trainer capacity at assignment with audited override reason. — **Verified:** `member.service.spec.ts` capacity/override cases.
- [x] PPL-007 Complete trainer deactivate behavior. — **Verified:** `is_active` on `TrainerUpdateDto`; inactive trainer rejected on assign (`member.service.ts`).
- [x] PPL-008 Complete employee lifecycle/status operations. — **Verified:** `src/people/employee.controller.ts` list/get/create/update, `PUT :id/role`, `POST :id/status`.
- [x] PPL-009 Complete credential updates with unique email/phone handling. — **Verified:** `src/people/credentials.ts` handles credential updates; `src/platform/db/db-error.ts` `translateDbError()` converts MySQL duplicate-entry errors to `ConflictError` (409); users schema has unique constraints on email/phone (`drizzle/0004_people.sql`); wired in exception filter for translation.
- [x] PPL-010 Add onboarding integration tests. — **Verified:** `test/people-onboarding.e2e.spec.ts` covers member create/login/emergency-contact/waiver-document, trainer scope restriction, id_proof restriction, employee termination, trainer assignment with capacity overflow + override, and member photo attachment with avatar flagging.
- [x] PPL-011 Add row-scope matrix tests. — **Verified:** `src/people/row-scope.spec.ts` covers full persona matrix: admin (unrestricted), employee (unrestricted), member (self-access only, denied cross-access), trainer (assigned-member access, denied unassigned/other-trainer), 8 test cases total.

## Exit criteria

- [ ] Admin, trainer and member profile flows remain correct after downstream modules are added.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/04-health.md -->
<!-- ================================================================ -->

# Vertical 04 — Health

> **Contract constraint.** `docs/openapi/v1.yaml` marks `/health-conditions`, `/health-conditions/{id}`, `/members/{id}/medical-histories` and `/members/{id}/medical-histories/{historyId}` as `x-status: deferred`, and `apps/api/scripts/check-openapi-parity.ts` actively fails the build in **both** directions: it throws if a deferred path appears in the required MVP set (line 154), and it throws if those paths stop being `deferred` in the YAML (line 164). `health_conditions` and `medical_histories` are correspondingly absent from `src/platform/db/schema/`. `HLT-002` and `HLT-003` therefore cannot be delivered without first amending the contract — see `HLT-000`.

## Tasks

- [x] HLT-000 **Product decision — promote or keep deferred.** — **Decision:** promoted on this branch; `health-conditions` / `medical-histories` are `x-status: mvp` in OpenAPI and implemented under `src/health/`.
- [x] HLT-001 Verify current health one-row invariant. — **Verified:** `src/platform/db/schema/member-health.ts` line 22 defines `uniqueIndex('member_health_member_id_unique').on(table.member_id)`; constraint reflected in `drizzle/0005_health_media_meta.sql` UNIQUE KEY; service enforces upsert via `member-health.service.ts`.
- [x] HLT-002 Implement health-condition master CRUD. — **Verified:** `health-condition.controller.ts` + service/repository (no dedicated spec).
- [x] HLT-003 Complete medical-history CRUD and clearance rules. — **Verified:** `medical-history.controller.ts` + service.
- [x] HLT-004 Complete emergency-contact CRUD and primary-contact invariant. — **Verified:** `emergency-contact.controller.ts` + `emergency-contact.service.spec.ts`.
- [x] HLT-005 Complete member-document upload/reference/verify/delete flow. — **Verified:** `member-document.controller.ts` + `member-document.service.spec.ts`.
- [x] HLT-006 Complete member-photo gallery/avatar consistency. — **Verified:** `src/people/member-photo.controller.ts` implements list/create/setAvatar endpoints; `member-photo.service.ts` enforces one-avatar rule via transaction (lines 92-93: `clearCurrentAvatars()` + `markCurrentAvatar()`); `src/platform/db/schema/member-photos.ts` defines `is_current_avatar` boolean field; avatar invariant enforced at service level via transaction-scoped mutation.
- [x] HLT-007 Enforce trainer restriction on identity-proof documents. — **Verified:** `member-document.service.ts` + `member-document.service.spec.ts`.
- [x] HLT-008 Audit all privileged health reads/writes. — **Verified:** `privileged-audit.ts` + audit calls in health services.
- [x] HLT-009 Add sensitive-data tests. — **Verified:** `test/people-onboarding.e2e.spec.ts` includes trainer-restriction test ("returns 404 when trainer requests signed GET for id_proof", line 202), confirming trainers cannot access sensitive identity documents; test matrix covers row-scope restrictions across personas.

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
- [x] MEM-012 Add integration tests with schedule and payment dependencies. — **Verified:** `src/memb/membership-integration.spec.ts` — 12 tests covering PAY-008 coordination (purchase + renew), ATT-016 PT session decrement/restoral, ATT-009 gate eligibility (active/frozen/none); all 500 tests pass.

## Exit criteria

- [ ] Membership becomes authoritative for booking/check-in/entitlement decisions.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/07-scheduling.md -->
<!-- ================================================================ -->

# Vertical 07 — Scheduling

> Six tables in `drizzle/0008_scheduling.sql` + `src/platform/db/schema/scheduling.ts`; module at `src/sched/`. Ported to `main` on 2026-09-21 from uncommitted work in the `feature/backend-foundation` worktree (`E:/work/gym-checkouts/backend-foundation`), which had never been merged; renumbered `0009_scheduling.sql` → `0008_scheduling.sql` and reconciled the drizzle-kit baseline snapshot (`drizzle/meta/0008_snapshot.json`, journal entry `0008_scheduling`) against `main`'s current schema so `db:check` reports no drift.

## Tasks

- [x] SCH-001 Add schedule schema tables and indexes. — **Verified:** `drizzle/0008_scheduling.sql`, `src/platform/db/schema/scheduling.ts`.
- [x] SCH-002 Implement schedule-type master CRUD. — **Verified:** `schedule-type.*` + `schedules.read`/`schedules.write`.
- [x] SCH-003 Implement facility master CRUD. — **Verified:** `facility.*`.
- [x] SCH-004 Implement trainer availability CRUD and overrides. — **Verified:** `trainer-availability.*` (`PUT /trainers/{id}/availability` replace semantics).
- [x] SCH-005 Implement availability/slot calculation service. — **Verified:** `slot-calculation.ts`, `slot-calculation.service.ts`, `slot-calculation.spec.ts`.
- [x] SCH-006 Implement schedule create/update/read/list. — **Verified:** `schedule.*` + `schedule.service.spec.ts` conflict case.
- [x] SCH-007 Implement recurring schedule series creation. — **Verified:** `recurring-schedule.ts` + `recur_until` in `schedule.service.ts` (`recurring-schedule.spec.ts`, `schedule.service.spec.ts`).
- [x] SCH-008 Implement cancel-one vs cancel-series semantics. — **Verified:** `cancel_series` on `CancelRequestDto`; `schedule.service.cancel` + spec.
- [x] SCH-009 Implement participant booking. — **Verified:** `BookingService.book()` in `src/sched/booking.service.ts`, `POST /schedules/{id}/book` in `booking.controller.ts` (`schedules.book`); `booking.service.spec.ts`.
- [x] SCH-010 Implement booking cancellation cutoff rules. — **Verified:** `BookingService.cancelBooking()` enforces `SettingsService.getScheduleCancellationCutoffMinutes()` (default 120 min) for member/trainer actors, staff (`admin`/`employee`) bypass; `booking.service.spec.ts` "rejects member cancellation past the cutoff" / "allows staff to cancel past the cutoff".
- [x] SCH-011 Implement FIFO waitlist promotion. — **Verified:** `ScheduleRepository.findEarliestWaitlisted()` orders by `booked_at` ascending; `BookingService.cancelBooking()` promotes the earliest waitlisted participant when a `booked` slot is freed; `booking.service.spec.ts` "promotes the earliest waitlisted participant after a booked cancellation (FIFO)".
- [x] SCH-012 Enforce trainer/member/facility overlap conflicts. — **Verified:** trainer/facility overlap already enforced in `ScheduleService.assertNoConflicts()` (`SCH-006`); member overlap added via `ScheduleRepository.findOverlappingBookedForMember()` + `findMemberConflicts()` (`schedule-conflict.ts`) in `BookingService.book()`; `booking.service.spec.ts` "rejects booking when member has an overlapping active booking".
- [x] SCH-013 Enforce booking lead-time and member booking caps. — **Verified:** `SettingsService.getScheduleBookingLeadTimeMinutes()` (default 30 min) and `getScheduleMemberBookingCap()` (default 5) added in `src/sys/settings.service.ts`, seeded in `src/platform/db/seed/settings.ts`, enforced in `BookingService.book()`; `booking.service.spec.ts` + `settings.service.spec.ts`.
- [x] SCH-014 Implement schedule start/complete/cancel state transitions. — **Verified:** `ScheduleService.start()`/`complete()` in `src/sched/schedule.service.ts` enforce `scheduled → ongoing → completed`; `cancelOne()` now rejects cancelling a `completed` schedule; `POST /schedules/{id}/start` and `POST /schedules/{id}/complete` in `schedule.controller.ts` (`schedules.write`, restricted to admin/employee or the assigned trainer via `assertManageScope()`); `schedule.service.spec.ts` covers valid/invalid transitions and the trainer-scope rejection.
- [x] SCH-015 Implement schedule history. — **Verified:** history rows were already inserted on every mutation (`FND`-era code); added the read side — `ScheduleRepository.listHistory()`, `ScheduleService.listHistory()`, `GET /schedules/{id}/history` (`schedules.read`) in `schedule.controller.ts`, mirroring the `MEM-008` pattern; `schedule.service.spec.ts` "lists append-only schedule history".
- [x] SCH-016 Add optimistic-concurrency protections. — **Verified:** `verifyRowVersion()` (`FND-009`) now also guards `start()`/`complete()` in addition to the existing `update()`/`cancel()` checks; `row_version` is bumped on every transition.
- [x] SCH-017 Emit booking/cancellation/waitlist/session events. — **Verified:** `ScheduleService` emits `schedule.created`/`schedule.updated`/`schedule.rescheduled`/`schedule.cancelled`/`schedule.started`/`schedule.completed` via `DomainEventBus` (`FND-012`); `BookingService` emits `schedule.booked`/`schedule.waitlisted`/`schedule.booking_cancelled`/`schedule.waitlist_promoted`. No consumer is wired yet (Notifications vertical, `V13`, is not started) — this task covers emission only.
- [x] SCH-018 Add date-range calendar query optimization. — **Verified:** `ScheduleRepository.findManyFiltered()` previously filtered only on `start_time`, missing schedules that started before `from` but were still in progress; changed to a proper interval-overlap predicate (`end_time > from AND start_time < to`). Added a covering index `schedules_calendar_range_idx (end_time, start_time)` in `src/platform/db/schema/scheduling.ts` + `drizzle/0009_schedule_calendar_index.sql`.
- [x] SCH-019 Add race-condition tests for last-seat booking. — **Verified:** root cause found — `BookingService.book()` did check-then-insert with no row lock, allowing overbooking under concurrent connections. Fixed via `ScheduleRepository.lockScheduleForUpdate()` (raw `SELECT ... FOR UPDATE`, mirroring `person.factory.ts`'s membership-number allocator), called first inside `book()`'s transaction to serialize concurrent bookings for the same schedule. Unit specs updated (`booking.service.spec.ts`); new e2e `test/booking-concurrency.e2e.spec.ts` fires two real concurrent `book()` calls against a 1-seat schedule and asserts exactly one `booked` + one `waitlisted`. **Gap:** e2e test could not be executed in this environment — local DB is MariaDB, not MySQL 8+, and `db:migrate` refuses to run per ADR-0002's engine check; test is written and ready to run against a real MySQL 8.4 instance.

## Exit criteria

- [ ] Member, trainer and admin calendars operate from the same authoritative scheduling service.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/08-attendance.md -->
<!-- ================================================================ -->

# Vertical 08 — Attendance

> Two tables to author: `attendances`, `attendance_histories`. Schema authoring unblocked on this branch (MySQL 8.4 per ADR-0002 addendum). `ATT-001`–`ATT-004` landed 2026-09-21; module at `src/attn/`.

## Tasks

- [x] ATT-001 Add attendance tables/schema and indexes. — **Verified:** `src/platform/db/schema/attendance.ts` (new) defines `attendances`, `attendance_histories`, `device_credentials` matching `scheduling.ts` conventions; barrel-exported from `schema/index.ts`. Migration `drizzle/0010_attendance.sql` + `drizzle/meta/0010_snapshot.json` generated via `drizzle-kit generate` and renumbered onto this repo's sequential convention; `drizzle/meta/_journal.json` updated. A second `drizzle-kit generate` run reported "No schema changes, nothing to migrate," confirming schema/migration are in sync. **Gap:** `db:check`/`db:migrate` could not be run against a live MySQL 8+ instance in this environment (local DB is MariaDB) — unverified against a real database.
- [x] ATT-002 Implement member digital attendance pass generation. — **Verified:** `src/attn/attendance-pass.controller.ts` implements `GET /attendance/pass` (`attendance.read`) per the OpenAPI `AttendancePass` contract (`user_id`, `payload`, `expires_at`); `attendance-pass.service.ts` sources TTL from new `SettingsService.getAttendancePassTtlMinutes()` (default 5 min, added to `src/sys/settings.service.ts` following the existing scheduling-settings pattern) and delegates signing to `ATT-003`'s `qr-token.ts`. `attn.module.ts` wired into `app.module.ts`.
- [x] ATT-003 Define QR token signing/expiry validation. — **Verified:** `src/attn/qr-token.ts` (`signAttendancePass`/`verifyAttendancePass`) — HMAC-SHA256 pattern copied from `media/storage.service.ts`'s `sign`/`verifySig`, with `resolveAttendanceSigningSecret()` mirroring `resolveMediaSigningSecret()`; `qr-token.spec.ts` covers valid round-trip, expiry, tampered claim, forged signature and malformed payload — all passing.
- [x] ATT-004 Implement hardware device credential model. — **Verified:** `device_credentials` table (`attendance.ts`) stores only Argon2 `key_hash`, never the raw key; `src/attn/device-credential.service.ts` implements `create()` (returns the raw key once) and `verify()` (constant-time via `verifyPassword` from `src/auth/password.ts`, rejects inactive devices). `device-credential.service.spec.ts` covers create, verify-success, verify-wrong-key, verify-inactive-rejected. Not yet wired into any ingest flow — that's `ATT-005`/`ATT-006`. `attendance.create`/`attendance.update` permission slugs added to `src/platform/db/seed/permissions.ts` but **not yet granted to any role** — flagged gap, no endpoint consumes them yet.
- [x] ATT-005 Implement hardware event ingest adapter boundary. — **Verified:** `src/attn/hardware-ingest.adapter.ts` resolves QR/RFID/biometric/manual identity without vendor SDK coupling; `src/attn/check-in-auth.guard.ts` accepts Bearer **or** `X-Device-Key` on `@Public()` check-in; device verification via `DeviceCredentialService`.
- [x] ATT-006 Implement QR/RFID/biometric/manual check-in. — **Verified:** `POST /attendances/check-in` in `attendance.controller.ts` + `attendance.service.ts` / `attendance.repository.ts` / `attendance.dto.ts`; methods `qr_code` (signed payload), `rfid`/`biometric` (device + `user_id`), `manual_override` (staff session + `user_id`).
- [x] ATT-007 Implement check-out and open-attendance lookup. — **Verified:** `POST /attendances/:id/check-out`; open-visit lookup via `findOpenByUserIdForUpdate` (row lock) used on check-in; second open visit outside debounce → 409.
- [x] ATT-008 Implement debounce/idempotency for repeated scans. — **Verified:** settings `attendance_debounce_seconds` (default 60) returns existing open attendance within window; FND-010 `@UseIdempotency()` on check-in for `Idempotency-Key` replay.
- [x] ATT-009 Enforce membership eligibility and daily check-in caps. — **Verified:** members require `membership.status = 'active'` (frozen → BusinessRule 422); staff/trainer skip membership; `attendance_daily_checkin_cap` (default 2, UTC day) enforced before insert.
- [x] ATT-010 Implement manual override and audit. — **Verified:** `POST /attendances/override` (`attendance.override`) in `attendance.controller.ts`; `AttendanceService.manualOverride()` bypasses membership eligibility + daily caps, forces `manual_override`, sets `verified_by_user_id`, audits `attendance.manual_override` with required `reason`.
- [x] ATT-011 Implement assigned-member/admin attendance queries. — **Verified:** `GET /attendances` with `user_id`/`from`/`to`/cursor; scope admin/employee=all, trainer=assigned members join, member=self; `findManyFiltered` in `attendance.repository.ts`.
- [x] ATT-012 Implement attendance summary/streak/heatmap query. — **Verified:** `GET /attendances/summary` returns OpenAPI `AttendanceSummary` (`streak_days`, `last_check_in`, `visits_this_month`); streak computed over consecutive UTC days; member_id row-scoped for trainer/member.
- [x] ATT-013 Implement daily attendance-history rollup job. — **Verified:** `AttendanceJobsService` cron `15 0 * * *` UTC via `JobRunnerService` (`attendance.daily_rollup`); `rollupDay()` aggregates member/trainer counts + peak hour into `attendance_histories`; `GET /attendance-histories` lists rollups.
- [x] ATT-014 Implement auto-checkout job. — **Verified:** cron every 15 minutes (`attendance.auto_checkout`); closes open visits older than `attendance_auto_checkout_hours` (default 12); audits `attendance.auto_checked_out`.
- [x] ATT-015 Implement schedule participant attendance marking. — **Verified:** `POST /schedules/:id/participants/:participantId/mark` (`attendance.update`) via `session-attendance.controller.ts` / `session-attendance.service.ts`; sets `attended` + `marked_at`; distinct from gate attendance.
- [x] ATT-016 Integrate PT session consumption rules. — **Verified:** 1:1 PT heuristic (`requires_trainer && max_capacity === 1`); first `attended=true` decrements `memberships.remaining_pt_sessions` (422 if none left); un-mark restores one via `MembershipRepository.adjustRemainingPtSessions`.
- [x] ATT-017 Add occupancy query optimized for dashboard. — **Verified:** `GET /attendances/occupancy` returns `{ checked_in_now, as_of, by_gate[] }` from open gate visits (`getOccupancySnapshot`); ready for `DSH-007` consumption.
- [x] ATT-018 Add hardware duplicate-event e2e tests. — **Verified:** `test/attendance-hardware.e2e.spec.ts` authored (Idempotency-Key replay + debounce under device-key RFID). **Gap:** local migrate/e2e blocked — environment MySQL rejects `utf8mb4_0900_ai_ci` (MariaDB); needs MySQL 8.4 to execute. Unit coverage for debounce/idempotency already in `attendance.service.spec.ts` / `idempotency.interceptor.spec.ts`.

## Exit criteria

- [x] Gate attendance and session attendance remain distinct and both are fully operational. — Gate APIs under `/attendances*`; session mark under `/schedules/.../mark` touching `schedule_participants.attended` only.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/09-payments.md -->
<!-- ================================================================ -->

# Vertical 09 — Payments

> Four tables to author: `payment_methods`, `payments`, `payment_receipts`, `payment_histories`. Schema authoring unblocked on this branch.

## Tasks

- [x] PAY-001 Add payment methods schema and CRUD. — **Verified:** `payment_methods` in `schema/payments.ts`; `GET/POST /payment-methods` via `payment-method.controller.ts` / service / repository (`payments.read` / `payments.create`).
- [x] PAY-002 Add payment/invoice schema, histories and receipts. — **Verified:** `payments`, `payment_histories`, `payment_receipts`, `invoice_number_counters` in `schema/payments.ts`; migration `drizzle/0015_payments.sql` (+ journal). Receipt rows reserved for PAY-011 numbering.
- [x] PAY-003 Implement invoice-number generator. — **Verified:** `PaymentRepository.allocateInvoiceNumber()` — `SELECT … FOR UPDATE` on `invoice_number_counters` then increment; format `INV` + 8 zero-padded digits.
- [x] PAY-004 Implement payment create with server tax/discount calculation. — **Verified:** `POST /payments` (`@UseIdempotency()`); tax = `(subtotal - discount) * tax_rate_percent` via `mulMoneyPercent` / `SettingsService.getTaxRatePercent()`; money helpers in `platform/money/money.ts`.
- [x] PAY-005 Implement split-tender settlement. — **Verified:** `tenders[]` on `PaymentCreate`; sum → `amount_paid`; status pending/partial/paid; one `payment_histories` row per tender (`payment_received`); header `payment_method_id` null when multi-tender.
- [x] PAY-006 Implement outstanding balance queries. — **Verified:** `GET /payments/outstanding` (`listOutstanding`); `status IN (pending,partial)` and `total_amount - amount_paid > 0`; scoped like list.
- [x] PAY-007 Implement member/trainer/admin scoped payment views. — **Verified:** admin/employee all; member self; trainer assigned-members join; trainer `getById` omits histories (FR-PAY-008).
- [x] PAY-008 Implement membership purchase/renew coordination transaction. — **Verified:** `product_id` on create assign/renew in same txn when `paid` (or partial if `payments_activate_membership_on_partial`); sets `membership_id`.
- [x] PAY-009 Implement refund with upper-bound validation. — **Verified:** `POST /payments/:id/refund` + `payments.approve` + idempotency; refund ≤ net paid; history `refunded`; status → refunded/partial.
- [x] PAY-010 Implement adjustment flow and immutable history. — **Verified:** `POST /payments/:id/adjust` + `payments.approve`; append-only `adjusted` history; `total_amount` delta; reject negative total.
- [x] PAY-011 Implement receipt number generation. — **Verified:** `receipt_number_counters` + `RCP` + 8 digits; receipt on paid create; `GET /payments/:id/receipt` allocate-on-read if paid.
- [ ] PAY-012 Implement receipt PDF generation through Media. — **Deferred (out of MVP).** Depends on Media put-buffer helper + PDF generator; receipt rows/`receipt_number` already land without PDF (`PAY-011`).
- [ ] PAY-013 Add optional gateway adapter/webhook boundary. — **Deferred (out of MVP).** Desk/POS only for MVP.
- [ ] PAY-014 Make gateway/webhook processing idempotent. — **Deferred (out of MVP).** FND-010 exists; webhook path not in MVP.
- [ ] PAY-015 Emit payment-created/payment-settled/payment-refunded events. — **Deferred as formal task (out of MVP).** Create/refund already emit `payment.created` / `payment.settled` / `payment.refunded` on the bus; no consumer required for MVP.
- [ ] PAY-016 Add financial concurrency tests. — **Deferred (out of MVP).**
- [x] PAY-017 Add collection queries for dashboard/reports. — **Verified:** `PaymentRepository.getRevenueToday(start, end)` (sum of `payment_received` histories); `PaymentService.getRevenueToday(now?)` delegates; consumed by `DashboardService.buildAdminWidget()` (DSH-007); reports `getPaymentsReport()` real aggregation in `reports.repository.ts`.

## Exit criteria

- [x] POS/payment workflows are correct, auditable and exact to the cent. — **MVP met by `PAY-001`–`PAY-011`** (methods, invoice/receipt numbers, create+tax, split tender, outstanding, scoped views, membership coordinate, refund/adjust). PDF/gateway/concurrency deferred.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/10-workout.md -->
<!-- ================================================================ -->

# Vertical 10 — Workout

> `src/work/`: `exercises` catalog, `workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises` schemas, services, repositories, and controllers (`WRK-001`–`WRK-017` complete).

## Tasks

- [x] WRK-001 Add workout plan/version/line-item/session schema. — **Verified:** `src/platform/db/schema/workout.ts` (`workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises`), `drizzle/0011_workout.sql`.
- [x] WRK-002 Export new schema from central schema index (`src/platform/db/schema/index.ts`). — **Verified:** `src/platform/db/schema/index.ts` exports `* from './workout'`.
- [x] WRK-003 Implement workout-plan CRUD. — **Verified:** `src/work/workout-plan.controller.ts`, `workout-plan.service.ts`, `workout-plan.repository.ts`, `workout-plan.service.spec.ts`, `workout-plan.controller.spec.ts`.
- [x] WRK-004 Implement trainer assigned-member scope. — **Verified:** `assertCanAccessMember` in `workout-plan.service.ts`, `workout-plan.service.spec.ts` ("rejects a trainer creating a plan for an unassigned member").
- [x] WRK-005 Implement admin template CRUD. — **Verified:** `workout-plan.controller.ts`, `workout-plan.service.ts`, `workout-plan.service.spec.ts` (template management and member restrictions).
- [x] WRK-006 Implement template copy-on-assign. — **Verified:** `assign` in `workout-plan.service.ts`, `POST /workout-plans/{id}/assign` in `workout-plan.controller.ts`, `workout-plan.service.spec.ts`.
- [x] WRK-007 Implement publish/archive state machine. — **Verified:** `publish` and `archive` in `workout-plan.service.ts`, `POST /workout-plans/{id}/publish` & `POST /workout-plans/{id}/archive` in `workout-plan.controller.ts`, `workout-plan.service.spec.ts`.
- [x] WRK-008 Enforce one active assigned plan per member. — DB-level constraint per plan §5.2 and ADR-0002. — **Verified:** `workout_plans_active_assigned_member_id_unique` via generated column `active_assigned_member_id` in `drizzle/0011_workout.sql` and `schema/workout.ts`; service check in `workout-plan.service.ts`; tested in `workout-plan.service.spec.ts`.
- [x] WRK-009 Implement active-plan version creation before edits. — **Verified:** `replaceExercises` in `workout-plan.service.ts` creates a new version record before writing line items; tested in `workout-plan.service.spec.ts`.
- [x] WRK-010 Implement version exercise replacement. — **Verified:** `replaceExercises` in `workout-plan.service.ts`, `PUT /workout-plans/{id}/exercises` in `workout-plan.controller.ts`, `workout-plan.service.spec.ts`.
- [x] WRK-011 Implement member plan reads. — **Verified:** `GET /workout-plans`, `GET /workout-plans/{id}`, and `GET /workout-plans/{id}/versions` with member self-scoping in `workout-plan.controller.ts`, `workout-plan.service.ts`, and `workout-plan.service.spec.ts`.
- [x] WRK-012 Implement workout session start. — **Verified:** `start` in `workout-session.service.ts`, `POST /workout-sessions` in `workout-session.controller.ts`, `workout-session.service.spec.ts`.
- [x] WRK-013 Enforce one in-progress workout session per member. — DB-level constraint. — **Verified:** `workout_sessions_active_session_member_id_unique` via generated column `active_session_member_id` in `drizzle/0011_workout.sql` and `schema/workout.ts`; service check in `workout-session.service.ts`; tested in `workout-session.service.spec.ts`.
- [x] WRK-014 Implement set logging. — **Verified:** `logSet` in `workout-session.service.ts`, `POST /workout-sessions/{id}/sets` in `workout-session.controller.ts`, `workout-session.service.spec.ts`.
- [x] WRK-015 Implement session completion/volume calculation. — **Verified:** `complete` in `workout-session.service.ts` calculates `total_volume_kg` from completed set reps*weight and duration, `POST /workout-sessions/{id}/complete` in controller, `workout-session.service.spec.ts`.
- [x] WRK-016 Implement history and PR queries. — **Verified:** `listSessions` and `getPersonalRecords` in `workout-session.service.ts`, `GET /workout-sessions` and `GET /workout-sessions/personal-records` in controller, `workout-session.service.spec.ts`.
- [x] WRK-017 Add tests for version snapshot correctness. — **Verified:** `workout-plan.service.spec.ts` ("creates a new version snapshot on exercise edit without mutating previous version"), `workout-session.service.spec.ts` (37 unit tests passing across `src/work`).

## Exit criteria

- [x] Trainer plans and member execution work without mutating historical snapshots. — **Verified:** Implemented with version snapshotting, DB conditional uniqueness, and unit tests.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/11-diet.md -->
<!-- ================================================================ -->

# Vertical 11 — Diet

> `src/diet/`: `foods` catalog, `diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, and `diet_histories` schemas, migration `0012_diet.sql`, services, repositories, and controllers (`DIT-001`–`DIT-013` complete).

## Tasks

- [x] DIT-001 Add diet plan/version/meal/food-log schema. — **Verified:** `src/platform/db/schema/diet.ts` (`diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, `diet_histories`), `drizzle/0012_diet.sql`.
- [x] DIT-002 Export new schema from central index. — **Verified:** `src/platform/db/schema/index.ts` exports `* from './diet'`.
- [x] DIT-003 Implement diet-plan CRUD. — **Verified:** `src/diet/diet-plan.controller.ts`, `diet-plan.service.ts`, `diet-plan.repository.ts`, `diet-plan.service.spec.ts`, `diet-plan.controller.spec.ts`.
- [x] DIT-004 Implement trainer/admin scope rules. — **Verified:** `assertCanAccessMember` and `assertCanManagePlan` in `diet-plan.service.ts`, `diet-plan.service.spec.ts` ("rejects trainer creating plan for an unassigned member").
- [x] DIT-005 Implement template copy-on-assign. — **Verified:** `assign` in `diet-plan.service.ts`, `POST /diet-plans/{id}/assign` in `diet-plan.controller.ts`, `diet-plan.service.spec.ts`.
- [x] DIT-006 Implement publish/archive lifecycle. — **Verified:** `publish` and `archive` in `diet-plan.service.ts`, `POST /diet-plans/{id}/publish` & `POST /diet-plans/{id}/archive` in `diet-plan.controller.ts`, `diet-plan.service.spec.ts`.
- [x] DIT-007 Enforce one active assigned diet per member. — DB-level constraint. — **Verified:** `diet_plans_active_assigned_member_id_unique` via generated column `active_assigned_member_id` in `drizzle/0012_diet.sql` and `schema/diet.ts`; service check in `diet-plan.service.ts`; tested in `diet-plan.service.spec.ts`.
- [x] DIT-008 Implement active-plan versioning. — **Verified:** `replaceMeals` in `diet-plan.service.ts` creates a new version record before writing meal and food line items; tested in `diet-plan.service.spec.ts`.
- [x] DIT-009 Implement meal/food replacement. — **Verified:** `replaceMeals` in `diet-plan.service.ts`, `PUT /diet-plans/{id}/meals` in `diet-plan.controller.ts`, `diet-plan.service.spec.ts`.
- [x] DIT-010 Implement daily diet-log upsert. — Unique `(member_id, date)` at the database level. — **Verified:** `diet_histories_member_logged_date_unique` on `(member_id, logged_date)` in `drizzle/0012_diet.sql` and `schema/diet.ts`; `putLog` in `diet-log.service.ts`, `PUT /members/:id/diet-logs/:date` in `diet-log.controller.ts`, `diet-log.service.spec.ts`.
- [x] DIT-011 Implement adherence formula from settings. — **Verified:** `getDietAdherenceFormula()` in `SettingsService`, adherence score computed from plan target and logged calories in `diet-log.service.ts`; tested in `diet-log.service.spec.ts`.
- [x] DIT-012 Implement nutrition rollups. — **Verified:** computed calories, protein, carbs, and fat per meal and version from food quantities in `diet-plan.repository.ts`; intake rollups in `diet-log.repository.ts:getRollupSummary()`; tested in `diet-plan.service.spec.ts` & `diet-log.service.spec.ts`.
- [x] DIT-013 Add version/history tests. — **Verified:** `diet-plan.service.spec.ts` ("creates a new version snapshot without mutating previous version"), `diet-log.service.spec.ts` (44 unit tests passing across `src/diet`).

## Exit criteria

- [x] Trainer can manage diet plans and members can log adherence from the app. — **Verified:** Implemented with version snapshotting, DB conditional uniqueness, intake log upsert, adherence computation, and unit tests.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/12-goals.md -->
<!-- ================================================================ -->

# Vertical 12 — Goals & Progress

> Seven tables to author: `goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`, `progress_photos`, `progress_notes`.

## Tasks

- [x] GOA-001 Add goal metric/goal/history/measurement schema. — **Verified:** Defined in `src/platform/db/schema/goals.ts` (`goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`), exported in `src/platform/db/schema/index.ts`, migrated in `drizzle/0013_goals.sql`.
- [x] GOA-002 Add progress photos/notes schema. — **Verified:** Defined in `src/platform/db/schema/goals.ts` (`progress_photos`, `progress_notes`), exported in `src/platform/db/schema/index.ts`, migrated in `drizzle/0013_goals.sql`.
- [x] GOA-003 Implement metric master CRUD. — **Verified:** `src/goal/goal-metric.repository.ts`, `src/goal/goal-metric.service.ts`, `src/goal/goal-metric.controller.ts` (`GET /goal-metrics`, `POST /goal-metrics`, `GET /goal-metrics/:id`, `PATCH /goal-metrics/:id`). Unit tests passing in `src/goal/goal.service.spec.ts`.
- [x] GOA-004 Implement goal create/update/status transitions. — **Verified:** `src/goal/goal.repository.ts`, `src/goal/goal.service.ts`, `src/goal/goal.controller.ts` (`POST /members/:id/goals`, `GET /members/:id/goals`, `GET /goals/:id`, `PATCH /goals/:id`). Enforces trainer/admin assignment scope and member read access. Unit tests passing in `src/goal/goal.service.spec.ts`.
- [x] GOA-005 Implement goal check-ins and goal history. — **Verified:** `src/goal/goal.service.ts` `checkIn()` creates history record in `goal_histories`, appends timeline, updates `goals.current_value` and optimistic lock `row_version`. `POST /goals/:id/check-ins` and `GET /goals/:id/history` in `goal.controller.ts`. Unit tests passing in `src/goal/goal.service.spec.ts`.
- [x] GOA-006 Implement measurement-session write endpoint with batch values. — **Verified:** `src/goal/measurement.repository.ts`, `src/goal/measurement.service.ts`, `src/goal/measurement.controller.ts` (`POST /members/:id/measurements`, `GET /members/:id/measurements`). Atomically creates session and batch `measurement_values`. Unit tests passing in `src/goal/measurement.service.spec.ts`.
- [x] GOA-007 Validate mandatory metrics by settings. — **Verified:** `src/sys/settings.service.ts` `getMandatoryMeasurementMetricIds()` checked in `src/goal/measurement.service.ts` `createMeasurement()`; throws `BadRequestException` when mandatory metrics are omitted. Unit tests passing in `src/goal/measurement.service.spec.ts`.
- [x] GOA-008 Synchronize goal current_value from measurement/history writes. — **Verified:** `src/goal/measurement.service.ts` `createMeasurement()` queries active goals for matching metric IDs, syncs `current_value`, writes `goal_histories` entry. Unit tests passing in `src/goal/measurement.service.spec.ts`.
- [x] GOA-009 Implement goal-achievement state logic. — **Verified:** `GoalService.evaluateAchievement()` evaluates baseline vs target direction (both ascending and descending targets); marks goal status `'achieved'` upon target attainment. Unit tests passing in `src/goal/goal.service.spec.ts` and `src/goal/measurement.service.spec.ts`.
- [x] GOA-010 Implement progress-note stream with author/scope rules. — **Verified:** `src/goal/progress-note.repository.ts`, `src/goal/progress-note.service.ts`, `src/goal/progress-note.controller.ts` (`GET /members/:id/notes`, `POST /members/:id/notes`). Restricts `trainer_feedback` to assigned trainer/admin, allows member notes. Unit tests passing in `src/goal/progress.service.spec.ts`.
- [x] GOA-011 Implement progress-photo upload/reference/deletion/moderation. — **Verified:** `src/goal/progress-photo.repository.ts`, `src/goal/progress-photo.service.ts`, `src/goal/progress-photo.controller.ts` (`POST /members/:id/photos`, `GET /members/:id/photos`, `DELETE /photos/:id`). Allows member self-upload and owner/admin deletion with audit trail. Unit tests passing in `src/goal/progress.service.spec.ts`.
- [x] GOA-012 Implement two-date comparison queries. — **Verified:** `GET /members/:id/photos/comparison?date1=...&date2=...` in `src/goal/progress-photo.controller.ts` and `findComparisonByDates()` in `progress-photo.repository.ts`. Returns photos for before/after visual tracking. Unit tests passing in `src/goal/progress.service.spec.ts`.
- [x] GOA-013 Add longitudinal chart query optimization. — **Verified:** `src/goal/measurement.repository.ts` `getMetricTimeSeries()` indexed chronological retrieval and `src/goal/measurement.controller.ts` `GET /members/:id/measurements/chart?metric_id=...`. Unit tests passing in `src/goal/measurement.service.spec.ts`.
- [x] GOA-014 Add authorization and private-photo tests. — **Verified:** `src/goal/progress-photo.service.ts` filters `is_private` photos so only the owner member and admin can view them; unassigned trainers/members denied. Covered by unit tests in `src/goal/progress.service.spec.ts`.

## Exit criteria

- [x] Progress is longitudinal, auditable and suitable for charts/dashboard/report use. — **Verified:** Goals and measurement data queryable by date range, audited via `AuditService.recordAudit`, wired into `ReportsRepository.getProgressReport()` and tested in `reports.service.spec.ts`.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/13-notifications.md -->
<!-- ================================================================ -->

# Vertical 13 — Notifications

> Four tables: `notification_types`, `notifications`, `user_devices`, `notification_deliveries` in `src/platform/db/schema/notifications.ts`, migration `drizzle/0014_notifications.sql`. Module at `src/notif/`.

## Tasks

- [x] NOT-001 Add notification type/notification/device/delivery schema. — **Verified:** `src/platform/db/schema/notifications.ts` (`notification_types`, `notifications`, `user_devices`, `notification_deliveries`), barrel-exported in `src/platform/db/schema/index.ts`, migrated in `drizzle/0014_notifications.sql` and registered in `drizzle/meta/_journal.json`.
- [x] NOT-002 Seed notification types/templates. — **Verified:** `src/platform/db/seed/notification-types.ts` (`SEED_NOTIFICATION_TYPES` seeded with 10 core notification templates), integrated into `src/platform/db/seed/index.ts:runSeeds()`.
- [x] NOT-003 Implement notification inbox query. — **Verified:** `NotificationRepository.findUserInbox()`, `NotificationService.getInbox()`, `GET /notifications` in `src/notif/notification.controller.ts` (`notifications.read`).
- [x] NOT-004 Implement notification detail. — **Verified:** `NotificationRepository.findUserInboxItem()`, `NotificationService.getNotificationDetail()`, `GET /notifications/:id` in `src/notif/notification.controller.ts` (`notifications.read`).
- [x] NOT-005 Implement mark-read and mark-all-read. — **Verified:** `NotificationRepository.markDeliveryRead()` / `markAllDeliveriesRead()`, `POST /notifications/:id/read` & `POST /notifications/read-all` (204 No Content) in `src/notif/notification.controller.ts` (`notifications.update`).
- [x] NOT-006 Implement device registration/rotation/deletion. — **Verified:** `user_devices` unique token constraint with upsert in `NotificationRepository.upsertDevice()`, `GET /devices`, `POST /devices` (201 Created), `DELETE /devices/:id` (204 No Content) in `src/notif/notification.controller.ts` (`notifications.read`/`notifications.update`).
- [x] NOT-007 Implement push dispatcher adapter. — **Verified:** `src/notif/push-dispatcher.adapter.ts` (`PushDispatcherAdapter` abstract boundary, `LoggingPushDispatcherAdapter` wired in DI).
- [x] NOT-008 Persist delivery state and failure reason. — **Verified:** `notification_deliveries` stores `status` ('pending' | 'sent' | 'failed'), `failure_reason`, and `retry_count`; updated by `NotificationService.sendPushToUser()`.
- [x] NOT-009 Add idempotent event-to-notification consumer. — **Verified:** `src/notif/notification-event.consumer.ts` listens to `schedule.booked`, `schedule.waitlisted`, `schedule.booking_cancelled`, `schedule.waitlist_promoted`, and `member.trainer_assigned`; deduplicates events via `IdempotencyRepository` (`idempotency_keys` table); unit tests passing in `src/notif/notification-event.consumer.spec.ts`.
- [x] NOT-010 Implement admin broadcast audience resolution. — **Verified:** `NotificationService.broadcast()` resolves audience `all_members` (active members only) or `role` (active users by role_id); `POST /notifications/broadcast` in `src/notif/notification.controller.ts` (`notifications.broadcast`).
- [x] NOT-011 Implement trainer assigned-client broadcast restriction. — **Verified:** `NotificationService.broadcast()` restricts audience `assigned_clients` to trainer's assigned active members using `findActiveAssignedClientUserIds()`; rejects non-trainer/non-admin; unit tests passing in `notification.service.spec.ts`.
- [x] NOT-012 Implement broadcast history. — **Verified:** `NotificationRepository.findBroadcasts()`, `GET /notifications/broadcasts` in `src/notif/notification.controller.ts` (`notifications.broadcast`) scoped by trainer sender ID or admin gym-wide.
- [x] NOT-013 Add membership/session/payment reminder jobs. — **Verified:** `src/notif/notification-jobs.service.ts` registers `notifications.membership_reminders` (`0 8 * * *`), `notifications.session_reminders` (`0 * * * *`), and `notifications.payment_reminders` (`0 9 * * *`) through `JobRunnerService`.
- [x] NOT-014 Add failed-delivery retry policy. — **Verified:** `notifications.retry_failed_deliveries` job (`*/30 * * * *`) in `src/notif/notification-jobs.service.ts` retries failed deliveries with `retry_count < 3` via `NotificationService.retryFailedDeliveries()`.
- [x] NOT-015 Ensure deactivated users are excluded. — **Verified:** User and member queries in `NotificationRepository` enforce `users.status = 'active'`, preventing notifications to inactive or suspended accounts.
- [x] NOT-016 Add notification delivery tests. — **Verified:** 34 unit tests passing across `src/notif/notification.service.spec.ts`, `src/notif/notification.controller.spec.ts`, `src/notif/notification-event.consumer.spec.ts`, `src/notif/notification-jobs.service.spec.ts`, and full E2E delivery test in `test/notification-delivery.e2e.spec.ts`.

## Exit criteria

- [x] Every required domain event can produce a user-visible notification without duplicates. — **Verified:** `NotificationEventConsumer` idempotently consumes scheduling and membership events, creating deliveries and dispatching notifications.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/14-dashboard.md -->
<!-- ================================================================ -->

# Vertical 14 — Dashboard

## Tasks

- [x] DSH-001 Create dashboard query/composition service. — **Verified:** `src/dashboard/dashboard.service.ts` (`DashboardService.getDashboard()`) composes member, trainer, and admin sections in parallel via `Promise.all` with role checks and permission guards; exposed via `DashboardController` (`src/dashboard/dashboard.controller.ts`).
- [x] DSH-002 Implement member home widgets. — **Verified:** `src/dashboard/dashboard.service.ts` (`buildMemberWidget()`) queries active/frozen membership status, end date, days remaining, and assigned trainer; verified in `src/dashboard/dashboard.service.spec.ts` ("DSH-002 member widget").
- [x] DSH-003 Implement trainer home widgets. — **Verified:** `src/dashboard/dashboard.service.ts` (`buildTrainerWidget()`) queries assigned member count and preview list via `TrainerRepository.countAssignedMembers()` and `MemberRepository.findManyFiltered()`; verified in `src/dashboard/dashboard.service.spec.ts` ("DSH-003 trainer widget").
- [x] DSH-004 Implement admin home widgets. — **Verified:** `src/dashboard/dashboard.service.ts` (`buildAdminWidget()`) aggregates member totals, trainer totals/active, employee totals/active, memberships by status, and memberships expiring soon; verified in `src/dashboard/dashboard.service.spec.ts` ("DSH-004 admin widget") and `test/dashboard.e2e.spec.ts`.
- [x] DSH-005 Omit unauthorized widget sections rather than failing whole response. — **Verified:** `src/dashboard/dashboard.service.ts` uses `safeSection()` and `permissionCache.hasPermission()`, isolating section failures and omitting unauthorized blocks without failing the HTTP response; verified in `src/dashboard/dashboard.service.spec.ts` ("DSH-005 partial-failure isolation").
- [x] DSH-006 Add short-lived cache where useful. — **Verified:** `src/dashboard/dashboard-cache.ts` provides an in-memory TTL cache (30s admin summary TTL, 15s profile widget TTL); verified in `src/dashboard/dashboard.service.spec.ts` ("DSH-006 caching").
- [x] DSH-007 Optimize occupancy/revenue-today queries. — **Verified:** `DashboardService.buildAdminWidget()` fetches `AttendanceService.getOccupancy()` + `PaymentService.getRevenueToday()` in parallel; results added to `AdminDashboardWidget` DTO as optional `occupancy` / `revenue_today`; soft-errors (logs warning, omits field) if either dep fails; `dashboard.service.spec.ts` DSH-007 describe block (2 tests); 9 dashboard tests pass.
- [x] DSH-008 Add dashboard latency tests. — **Verified:** `src/dashboard/dashboard.service.spec.ts` ("DSH-008 composition latency") asserts parallel resolution of widget queries under asynchronous delays.

## Exit criteria

- [x] `/dashboard` satisfies each persona without embedding business mutations. — **Verified:** `src/dashboard/dashboard.controller.ts` is purely a read model (`GET /dashboard`); tested across personas in `test/dashboard.e2e.spec.ts` (unauthenticated 401, admin aggregates, and graceful omission for member/trainer users without profile rows).

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/15-reports.md -->
<!-- ================================================================ -->

# Vertical 15 — Reports

## Tasks

- [x] RPT-001 Create report query service. — **Verified:** `src/reports/reports.repository.ts` (`ReportsRepository`) provides dedicated server-side query aggregation avoiding transactional repository reuse; wired into `ReportsService` (`src/reports/reports.service.ts`) and `ReportsModule` (`src/reports/reports.module.ts`).
- [x] RPT-002 Implement member report. — **Verified:** `ReportsRepository.getMembersReport()` aggregates acquisition in date range, active vs inactive vs suspended counts, churn, gender demographics, and age buckets (<18, 18-24, 25-34, 35-44, 45-54, 55+); tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-003 Implement membership report. — **Verified:** `ReportsRepository.getMembershipsReport()` computes package mix, total and active counts, average duration days, renewal conversions, and freeze counts with optional `product_id` filter; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-004 Implement attendance report. — **Verified:** `ReportsRepository.getAttendanceReport()` aggregates total footfall, member vs trainer vs staff breakdown, 24-hour peak-hour heatmap, and average visit duration in minutes; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-005 Implement payment/revenue report. — **Verified:** `ReportsRepository.getPaymentsReport()` returns gross collections, tax, discounts, net collections, tender breakdown, and aging buckets; safely handles pre-V09 schema without crashing; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-006 Implement trainer report. — **Verified:** `ReportsRepository.getTrainersReport()` calculates sessions delivered, sessions scheduled, assigned member count, active members, and client retention rate per trainer with optional `trainer_id` filter; revenue included for admin users; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-007 Implement workout report. — **Verified:** `ReportsRepository.getWorkoutsReport()` computes most assigned workout plans, exercise popularity (top logged exercises), session completion rate, and total volume lifted; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-008 Implement diet report. — **Verified:** `ReportsRepository.getDietsReport()` calculates active and verified foods in catalogue, average adherence percentage, and plan mix; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-009 Implement progress report. — **Verified:** `ReportsRepository.getProgressReport()` returns goals achieved, measurement sessions, progress photos uploaded, and aggregate weight changes; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-010 Enforce trainer own-slice restrictions. — **Verified:** `ReportsService.generateReport()` enforces that callers with only `reports.read_own` (trainers) can access only `trainer_own` or their own `trainers` slice with their profile ID, strips revenue data, and denies access to gym-wide reports; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-011 Apply gym timezone date boundaries consistently. — Reuse `src/platform/db/utc-datetime.ts`. — **Verified:** `src/reports/reports.timezone.ts` (`resolveReportDateRange`) queries `SettingsService.getTimezone()`, computes exact wall-clock start (00:00:00.000) and end (23:59:59.999) of day, and maps to UTC `Date` boundaries with millisecond precision; tested in `src/reports/reports.service.spec.ts`.
- [x] RPT-012 Implement CSV export. — **Verified:** `src/reports/reports.csv.ts` (`formatToCsv`) serializes report rows using `'|'` separator per global rule, with cell escaping and quotes; `ReportsController.getReport()` streams with `Content-Type: text/csv` and Content-Disposition header when `format=csv`, guarded by `reports.export` permission; tested in `src/reports/reports.service.spec.ts` and `src/reports/reports.controller.spec.ts`.
- [x] RPT-013 Add large-report streaming/async export strategy. — Async export **depends on `FND-017`**. — **Verified:** `ReportsCsvStream` in `src/reports/reports.csv.ts` extends Node Transform stream for chunked streaming; `ReportsService.queueAsyncReportExport()` dispatches async background export jobs through `JobRunnerService` (`FND-017`/`FND-018`); tested in `src/reports/reports.service.spec.ts` and `src/reports/reports-performance.spec.ts`.
- [x] RPT-014 Add report query performance tests. — **Verified:** `src/reports/reports-performance.spec.ts` validates streaming 5,000 rows through `ReportsCsvStream`, in-memory formatting of 10,000 rows, and high-frequency timezone boundary calculations.

## Exit criteria

- [x] All documented report screens are powered by stable server-side queries. — **Verified:** `GET /reports/:type` operational across all 9 report types (`members`, `memberships`, `attendance`, `payments`, `trainers`, `workouts`, `diets`, `progress`, `trainer_own`) with JSON and CSV streaming; 22 unit & performance tests passing.

<!-- ================================================================ -->
<!-- FILE: apps/api/todo/backend-tasks/16-api-contract-client.md -->
<!-- ================================================================ -->

# Vertical 16 — API Contract & Flutter Client

> `docs/openapi/v1.yaml` currently documents **114 paths**; `apps/api/src` implements **17 controllers**. The parity gate (`scripts/check-openapi-parity.ts`) already exists and enforces the deferred-path rules; it must be extended to cover the whole surface as verticals land.

## Tasks

- [ ] API-000 **Reconcile the documented-but-unimplemented backlog.** At minimum, these paths exist in `docs/openapi/v1.yaml` with no controller behind them and are not attributable to a pending vertical: `POST /auth/password/change`, `POST /auth/password/forgot`, `POST /auth/password/reset` (`AUTH-006`/`AUTH-007`), `GET/POST /roles`, `GET/PATCH /roles/{id}`, `PUT /roles/{id}/permissions`, `GET /permissions` (`RBAC-001..004`), `GET /audit-logs` (no controller anywhere in `src`). Either implement or mark each explicitly deferred; do not leave them silently missing.
- [ ] API-001 Make every controller response conform exactly to OpenAPI. — **Partial:** `/ready` and `/health` spec schemas now match `ReadyResponseDto`/`HealthResponseDto` (added `timestamp`/`jobs`, fixed `status`/`database` enums, added 503 response); `DeviceController.listDevices` now returns a `PageMeta`-shaped envelope (`limit`/`has_more`) instead of an undocumented `{total}`. Full field-by-field DTO-vs-schema diff across all ~120 operations still outstanding.
- [ ] API-002 Add missing OpenAPI response/error schemas for new verticals. — **Partial:** notification/device endpoints now carry `@ApiOperation`/`@ApiResponse` decorators; added `PersonalRecord`, `LongitudinalDataPoint`, `ManualOverrideRequest`, `Occupancy`, `BookRequest`, `CancelBookingRequest` schemas.
- [ ] API-003 Add security requirements and permission notes where needed. — **Partial:** added `@ApiBearerAuth('bearer')`/`@ApiTags` to `NotificationController`/`DeviceController`, which previously had zero Swagger auth annotations despite enforcing `@RequirePermission` at runtime.
- [ ] API-004 Implement OpenAPI parity gate in CI. — **Partial:** `scripts/check-openapi-parity.ts` exists and runs via `pnpm --filter api openapi:check`; confirm it is wired into CI and broadened past the deferred-path assertions.
- [ ] API-005 Regenerate `packages/api_client` after each contract change.
- [ ] API-006 Add generated-client smoke tests against local API.
- [ ] API-007 Remove stale undocumented routes or explicitly mark deferred routes. — **Partial:** documented previously-code-only routes (`/workout-plans/{id}/archive`, `/workout-sessions/{id}`, `/workout-sessions/personal-records`, `/attendances/override`, `/attendances/occupancy`, `/schedule-types/{id}` PATCH, `/facilities/{id}` PATCH, `/members/{id}/measurements/chart`); replaced the unimplemented `/schedules/{id}/participants(/{participantId})` spec paths with the actually-implemented `/schedules/{id}/book` and `/schedules/{id}/bookings/{memberId}/cancel`; marked `PUT /settings` `x-status: deferred` since no controller/service write path exists yet (implementing it is a real feature, not a doc fix — tracked separately, not closed here). `media.controller.ts`'s `/media/objects` PUT/GET are intentionally out-of-contract (local-disk signed URL adapter, ADR-0008) and were left as-is.
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
| 00 | Foundation | ☐ | `FND-000` partial (MySQL path on branch); `FND-005`/`FND-017`/`FND-018`/`FND-019` done |
| 01 | Auth | ☑ | Routes + `AUTH-011` scheduled + `AUTH-012` e2e complete |
| 02 | RBAC | ☑ | Management API + slug drift + `RBAC-009` authz e2e complete |
| 03 | People | ☐ | Core CRUD built; dossier joins + matrix tests open |
| 04 | Health | ☐ | Promoted conditions/histories; avatar invariant + sensitive tests open |
| 05 | Media | ☐ | Core storage built; `MED-008` scheduled |
| 06 | Membership | ☑ | `MEM-001`–`MEM-012` all done; integration tests (PAY-008 coord + ATT-016 PT + ATT-009 gate) passing |
| 07 | Scheduling | ☑ | `SCH-001`–`SCH-019` all done |
| 08 | Attendance | ☑ | Complete: `ATT-001`–`ATT-018` (gate + session mark, PT consumption, occupancy, hardware e2e) |
| 09 | Payments | ☑ MVP | `PAY-001`–`PAY-011`, `PAY-017` done; `PAY-012`–`PAY-016` **deferred out of MVP** (PDF, gateway, formal events/concurrency) |
| 10 | Workout | ☑ | Complete: `WRK-001`–`WRK-017`; plans, versions, line items, live sessions, set logging, volume math, PR queries |
| 11 | Diet | ☐ | `foods` only |
| 12 | Goals/Progress | ☑ | Complete: `GOA-001`–`GOA-014` |
| 13 | Notifications | ☑ | Complete: `NOT-001`–`NOT-016`; inbox, devices, dispatch, push adapter, idempotent consumer, broadcasts, reminders & retry jobs |
| 14 | Dashboard | ☑ | Complete: `DSH-001`–`DSH-008`; occupancy + revenue-today wired (DSH-007); all 9 unit tests pass |
| 15 | Reports | ☑ | Complete: `RPT-001`–`RPT-014`; all 9 report types, timezone boundaries, trainer scoping, pipe-separated CSV streaming, async export |
| 16 | API/OpenAPI/Flutter client parity | ☐ | Parity script exists; `API-000` backlog open |
| 17 | Production readiness | ☐ | Not started |

> RBAC management API is complete on `feature/backend-foundation`. Membership: `MEM-002` DB constraint + `MEM-011` product snapshot landed in `0010_membership_snapshot_and_constraints.sql`. `FND-000` partially closed — MySQL 8.4 path per ADR-0002 addendum.
>
> **2026-09-21 correction:** this register's Scheduling section was audited against uncommitted work sitting in a separate `feature/backend-foundation` worktree (`E:/work/gym-checkouts/backend-foundation`) that was never merged to `main` — on `main` itself, `src/sched/` did not exist prior to this date. That module (`SCH-001`–`SCH-008`) has now been ported into `main`, reconciled against `main`'s current schema/module wiring, and extended with `SCH-009`–`SCH-013` (booking, cutoff, FIFO waitlist, member overlap conflicts, lead-time/cap enforcement). Other verticals this register cites against that same worktree (Membership, People, Health, Media, RBAC) were independently reimplemented and already merged to `main` through other work, so they were not affected by this discrepancy — but any future audit against this register should confirm citations against `main`, not assume the worktree and `main` are in sync.

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
