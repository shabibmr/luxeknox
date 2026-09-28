# Backend Gaps — Master Task Register

**Source Document:** [`BACKEND_GAPS_AUDIT.md`](file:///Users/admin/code/gym/BACKEND_GAPS_AUDIT.md)  
**Target Codebase:** `gym` (`apps/api`)  
**Status Values:** `[ ] pending`, `[/] in-progress`, `[x] completed`  
**Execution Order:** Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6  
**Last reviewed against code:** 2026-09-25

---

## Phase 1 — Immediate Blockers & Build Fixes

Critical items preventing clean compilation and breaking the test runner.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-001** | Install workspace dependencies so `@nestjs/schedule` resolves | Workspace root `pnpm install` (package is already in `apps/api/package.json` and `pnpm-lock.yaml`) | `node_modules` contains `@nestjs/schedule`. `pnpm --filter api build` (`tsc -p tsconfig.build.json`) exits 0. | [x] |
| **GAP-002** | Deflake attendance summary streak test | [`apps/api/src/attn/attendance.service.spec.ts`](file:///Users/admin/code/gym/apps/api/src/attn/attendance.service.spec.ts#L211-L229) | Freeze time in `returns summary for a member` (`vi.useFakeTimers()` at `'2026-09-21T12:00:00.000Z'`, or pass an explicit `now`). The sibling `computeStreak(..., now)` case is already frozen. | [x] |
| **GAP-003** | Verify complete unit test suite green | `apps/api/src/**/*.spec.ts` | Run `pnpm --filter api test` after GAP-001 and GAP-002. All **67** spec files (~417 `it`/`test` cases) pass with zero failures. | [x] |

---

## Phase 2 — Security & Row-Level Authorization

Remediate authorization bypasses and standardize actor scoping across modules.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-004** | Close the workout-plan **manage** hole | [`apps/api/src/work/workout-plan.service.ts`](file:///Users/admin/code/gym/apps/api/src/work/workout-plan.service.ts) (`assertCanManagePlan`, ~L62) | Remove the unconditional `return` for trainers. Match `DietPlanService.assertCanManagePlan`: owner (`plan.trainer_id === actor.profileId`) or assigned trainer via `plan.member_id`. **Create is already gated** (`rejects a trainer creating a plan for an unassigned member`). Do not change diet. Add publish/archive/update tests for an unassigned trainer (404/403). | [x] |
| **GAP-005** | Wrap existing `assertPeopleRowScope` as async member access | [`apps/api/src/people/row-scope.ts`](file:///Users/admin/code/gym/apps/api/src/people/row-scope.ts), `work/`, `diet/`, `goal/`, `pay/` | Add `assertMemberAccess(actor, memberId)` that loads the member then calls `assertPeopleRowScope`. Delete private `assertCanAccessMember` copies. Map Nest `ForbiddenException` in `goal/` and `notif/` to `ForbiddenError` / `NotFoundError`. | [x] |

---

## Phase 3 — Data Integrity & Membership Lifecycle Consolidation

Eliminate dual ownership and divergent behavior between memberships and payments.

**Ship GAP-006, GAP-007, and GAP-008 as one PR.** IDs stay for tracing.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-006** | Consolidate membership checkout into `MembershipService` | [`apps/api/src/memb/membership.service.ts`](file:///Users/admin/code/gym/apps/api/src/memb/membership.service.ts), [`apps/api/src/pay/payment.service.ts`](file:///Users/admin/code/gym/apps/api/src/pay/payment.service.ts) | Expose a transaction-joinable `createOrRenewForPayment()` on `MembershipService`. Delete `PaymentService.coordinateMembership` and its private `addDays` copy. | [x] |
| **GAP-007** | Align renew product switching and start date | [`apps/api/src/memb/membership.service.ts`](file:///Users/admin/code/gym/apps/api/src/memb/membership.service.ts) | One policy: desk/payment renew may update `product_id`; honor explicit `start_date` (`purchaseMembership` currently accepts it and drops it). | [x] |
| **GAP-008** | Emit domain events and version the SQL update | [`apps/api/src/pay/payment.service.ts`](file:///Users/admin/code/gym/apps/api/src/pay/payment.service.ts), [`apps/api/src/memb/membership.service.ts`](file:///Users/admin/code/gym/apps/api/src/memb/membership.service.ts), [`membership.repository.ts`](file:///Users/admin/code/gym/apps/api/src/memb/membership.repository.ts) | Payment path today writes **audit** `membership.created` / `membership.renewed` and does not `domainEventBus.emit`. Emit those events. Put `expected_row_version` in the `UPDATE … WHERE id = ? AND row_version = ?` predicate (`updateMembership` currently keys on `id` only). | [x] |

---

## Phase 4 — API Contract Parity with Mobile Client (Flutter)

Implement backend routes the Flutter **app** actually calls, so those screens stop 404ing.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-009** | Implement `PUT /settings` write endpoint | [`apps/api/src/sys/settings.controller.ts`](file:///Users/admin/code/gym/apps/api/src/sys/settings.controller.ts), `settings.service.ts`, `settings.repository.ts`, `apps/api/src/platform/db/seed/permissions.ts`, `roles.ts`, `docs/openapi/v1.yaml` | Seed **`settings.update`** (seed today has `settings.read` only). Implement `PUT /settings` with `SettingsWriteDto`. Guard with `settings.update`. Invalidate settings cache. Flip OpenAPI `putSettings` from `x-status: deferred` to `mvp`. `pnpm --filter api openapi:check` passes. | [x] |
| **GAP-010** | Author `medical_histories` schema and migration | `apps/api/src/platform/db/schema/medical-histories.ts`, `drizzle/` | Author Drizzle schema (`id`, `member_id`, `condition_name`, `diagnosed_date`, `notes`, `document_key`, timestamps). Generate and apply migration. | [x] |
| **GAP-011** | Implement Medical History CRUD | `apps/api/src/people/medical-history.*`, `docs/openapi/v1.yaml`, `apps/api/scripts/check-openapi-parity.ts` | Implement list/create/patch/delete under `/members/:id/medical-histories`. Scope with `health.read` / `health.update`. Flip those paths from `x-status: deferred` to `mvp` **and** update `check-openapi-parity.ts` (it currently **fails** if medical-histories leave deferred). Unit + e2e tests. | [x] |

`/health-conditions` stays deferred: generated `api_client` has methods; `app/lib` never calls them.

---

## Phase 5 — Performance & Technical Debt

Refactor high-latency queries and untyped database boundaries.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-013** | Push demographic reporting age bucketing into SQL | [`apps/api/src/reports/reports.repository.ts`](file:///Users/admin/code/gym/apps/api/src/reports/reports.repository.ts) (`getMembersReport`) | Replace in-memory DOB iteration with SQL `CASE` / `GROUP BY` brackets (`<18`, `18-24`, `25-34`, `35-44`, `45-54`, `55+`). | [x] |
| **GAP-014** | Strongly type Drizzle repository database client | `apps/api/src/platform/db/base.repository.ts` | Replace `DrizzleDb<any>` and `AnyTransaction` with a schema-typed Drizzle instance. Remove `as any` casts on repository queries. | [x] |
| **GAP-015** | Split `ScheduleWriteDto` into Create vs Patch schemas | [`apps/api/src/sched/schedule.dto.ts`](file:///Users/admin/code/gym/apps/api/src/sched/schedule.dto.ts), [`schedule.service.ts`](file:///Users/admin/code/gym/apps/api/src/sched/schedule.service.ts) | Required-field schema for `POST /schedules`; partial schema for `PATCH /schedules/:id`. Remove `dto.schedule_type_id!` / `dto.title!` in `ScheduleService.create`. | [x] |

---

## Phase 6 — Governance & Operational Readiness

Documentary alignment and production verification suites.

| ID | Task | Target Files | Verification / Done When | Status |
| :--- | :--- | :--- | :--- | :---: |
| **GAP-016** | Supersede legacy PostgreSQL migration documents | [`POSTGRES_MIGRATION_PLAN.md`](file:///Users/admin/code/gym/POSTGRES_MIGRATION_PLAN.md), [`POSTGRES_MIGRATION_TASKS.md`](file:///Users/admin/code/gym/POSTGRES_MIGRATION_TASKS.md) | Add a deprecation header pointing at ADR-0002 (MySQL 8.4). Archive or move to `archive/`. | [ ] |
| **GAP-017** | Execute real MySQL 8.4 concurrency suite | `apps/api/test/booking-concurrency.e2e.spec.ts` | Run booking concurrency tests against MySQL 8.4 with row-level locks. Race-condition protection passes. | [ ] |
| **GAP-018** | Track Vertical 17 ops checks individually | [`apps/api/todo/backend-task-register.md`](file:///Users/admin/code/gym/apps/api/todo/backend-task-register.md) (`OPS-001`–`OPS-015`) | Do **not** treat this as one ticket. Work the register’s Vertical 17 items (`OPS-006` migrate repro, `OPS-007` seed idempotency, `OPS-008` audit grants, `OPS-004` p95, and the rest) with their FND dependencies. | [ ] |

---

## Deferred (out of this register’s execution order)

Kept for tracing. Do not pull into Phases 1–4 unless PAY MVP is expanded.

| ID | Task | Notes | Status |
| :--- | :--- | :--- | :---: |
| **GAP-012** | Receipt PDF generation (`PAY-012`) | `GET /payments/:id/receipt` exists and returns `receipt_pdf_url: null`. Flutter `app/lib` has no `getReceipt` caller. Backend task register marks `PAY-012` deferred out of MVP. | deferred |
| **PAY-013 / PAY-014** | Payment gateway + webhook | Desk/POS only for MVP. Generated client may list webhook; not a current Flutter 404. | deferred |

---

## Verification Commands Quick Reference

```bash
# 1. Install & Build
pnpm install
pnpm --filter api build

# 2. Targeted Deflake Test
pnpm --filter api test src/attn/attendance.service.spec.ts

# 3. Full Unit Suite (after GAP-001 and GAP-002)
pnpm --filter api test

# 4. OpenAPI Parity Verification (required for GAP-009 and GAP-011)
pnpm --filter api openapi:check
```
