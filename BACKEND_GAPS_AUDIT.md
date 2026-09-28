# Backend Gaps & Quality Audit Report

**Generated:** 2026-09-25  
**Last reviewed against code:** 2026-09-25  
**Codebase:** `gym` (`apps/api`)  
**Scope:** Architecture, compilation, test suites, API contracts, security boundaries, and operational readiness.

---

## 1. Executive Summary

Inspection of `apps/api`, its unit specs, `docs/openapi/v1.yaml`, Flutter `app/lib` callers, and [`docs/backend-code-quality-review.md`](file:///Users/admin/code/gym/docs/backend-code-quality-review.md) shows:

1. **Broken build:** `@nestjs/schedule` is declared in `apps/api/package.json` and `pnpm-lock.yaml` but is not present in `node_modules` (install was not run).
2. **Flaky test:** Attendance summary streak uses live `new Date()` against fixture dates `'2026-09-21'` / `'2026-09-20'`.
3. **Flutter 404s:** `PUT /settings` and `/members/{id}/medical-histories` are called from `app/lib` and are unimplemented (`x-status: deferred`).
4. **Authz hole on workout-plan manage:** `assertCanManagePlan` returns for every trainer. Create is already assignment-gated. Diet already checks assignment.
5. **Duplicated membership lifecycle** in `MembershipService` and `PaymentService.coordinateMembership`.

---

## 2. Compilation & Dependency Failures

### `@nestjs/schedule` Missing from `node_modules`
* **Command:** `pnpm --filter api build` (`tsc -p tsconfig.build.json`)
* **Status:** Failed with exit code 2 when the package is unresolved.
* **Details:** The dependency is already listed in [`apps/api/package.json`](file:///Users/admin/code/gym/apps/api/package.json#L31) and locked in `pnpm-lock.yaml`. The workspace needs `pnpm install`; the lockfile does not need a restore.
* **Affected Source Files:**
  - [`apps/api/src/attn/attendance-jobs.service.ts`](file:///Users/admin/code/gym/apps/api/src/attn/attendance-jobs.service.ts#L2)
  - [`apps/api/src/job/job.module.ts`](file:///Users/admin/code/gym/apps/api/src/job/job.module.ts#L2)
  - [`apps/api/src/notif/notification-jobs.service.ts`](file:///Users/admin/code/gym/apps/api/src/notif/notification-jobs.service.ts#L2)
* **Test Suite Consequence:** [`src/notif/notification-jobs.service.spec.ts`](file:///Users/admin/code/gym/apps/api/src/notif/notification-jobs.service.spec.ts) fails during module resolution (`Failed to load url @nestjs/schedule`).

---

## 3. Test Flakiness & Failures

### Attendance Streak Calculation Date Sensitivity
* **Failing Test:** [`apps/api/src/attn/attendance.service.spec.ts`](file:///Users/admin/code/gym/apps/api/src/attn/attendance.service.spec.ts#L211-L229) — `returns summary for a member`
* **Already frozen:** `computes streak across consecutive UTC days` passes an explicit `now`.
* **Failure Output (when run after 2026-09-21):**
  ```text
  FAIL src/attn/attendance.service.spec.ts > AttendanceService > returns summary for a member
  AssertionError: expected 0 to be greater than or equal to 1
   ❯ src/attn/attendance.service.spec.ts:228:32
      228| expect(result.streak_days).toBeGreaterThanOrEqual(1);
  ```
* **Root Cause:** Fixture check-in dates `'2026-09-21'` and `'2026-09-20'` with live `new Date()`. After 2026-09-21 the gap is >1 day and streak is 0.
* **Suite size:** 67 `*.spec.ts` files, about 417 `it`/`test` cases (not 497+).

---

## 4. API Contract & Implementation Gaps (Flutter vs Backend)

| Area | Endpoint | Flutter `app/lib` | Backend Reality |
| :--- | :--- | :--- | :--- |
| **Settings Write** | `PUT /settings` | Called by [`SettingsRemoteDataSourceImpl.putSettings`](file:///Users/admin/code/gym/app/lib/features/settings/data/datasources/settings_remote_datasource.dart#L35) from settings save. | Missing. [`SettingsController`](file:///Users/admin/code/gym/apps/api/src/sys/settings.controller.ts) is GET-only. OpenAPI `putSettings` is `x-status: deferred`. Seed has `settings.read` only — **`settings.update` is not seeded**. |
| **Medical History CRUD** | `/members/{id}/medical-histories` (list/create/patch/delete) | Called by [`ProfileRemoteDataSourceImpl`](file:///Users/admin/code/gym/app/lib/features/people/data/datasources/profile_remote_datasource.dart#L103-L136) and `MedicalHistoryCubit`. | Missing schema, controller, and table. OpenAPI `x-status: deferred`. [`check-openapi-parity.ts`](file:///Users/admin/code/gym/apps/api/scripts/check-openapi-parity.ts) **fails if these paths leave deferred** — flipping status is part of the work. |
| **Health Conditions** | `/health-conditions` | Generated `packages/api_client` only. **No `app/lib` caller.** | Missing. Stay `x-status: deferred` until a screen exists. |
| **Receipt PDF** | `GET /payments/:id/receipt` | **No `getReceipt` caller in `app/lib`.** Media purpose `receiptPdf` exists for document upload. | Endpoint exists; `ensureReceipt` stores `receipt_pdf_url: null`. `PAY-012` is deferred out of MVP. |
| **Payment Gateway** | `POST /payments/webhook` | Not a current Flutter 404. | Desk/POS only. `PAY-013` / `PAY-014` deferred out of MVP. |

---

## 5. Architectural & Security Vulnerabilities

*(Cross-referenced with [`docs/backend-code-quality-review.md`](file:///Users/admin/code/gym/docs/backend-code-quality-review.md))*

### 1. Security Hole in Workout Plan **Manage** (not create)
- **Location:** [`apps/api/src/work/workout-plan.service.ts`](file:///Users/admin/code/gym/apps/api/src/work/workout-plan.service.ts) `assertCanManagePlan` (~L62).
- **What the code does:** After `plan.trainer_id === actor.profileId`, it hits `// Or if assigned to a member they train` and **returns for every remaining trainer**.
- **Create is already safe:** `assertCanAccessMember` checks `assigned_trainer_id === actor.profileId`. Spec `rejects a trainer creating a plan for an unassigned member` covers create.
- **Diet is already correct:** `DietPlanService.assertCanManagePlan` loads the member when `plan.member_id` is set. Copy that pattern into workout manage; do not change diet.
- **Impact:** Any trainer can publish, archive, update, or replace exercises on a plan they do not own and are not assigned to.

### 2. Duplicated Membership Mutation Lifecycle
- **Locations:** [`MembershipService.create/renew`](file:///Users/admin/code/gym/apps/api/src/memb/membership.service.ts) and [`PaymentService.coordinateMembership`](file:///Users/admin/code/gym/apps/api/src/pay/payment.service.ts)
- **Discrepancies:**
  - Desk renew via payments switches `product_id`; `MembershipService.renew` keeps the current product.
  - Payment path records **audit** actions `membership.created` / `membership.renewed`. It does not `domainEventBus.emit` those events (`MembershipService` does).
  - `purchaseMembership` accepts `start_date` and never uses it; `coordinateMembership` always starts `today`.
  - `renewMembership` calls `verifyRowVersion` before the transaction. `updateMembership` updates `WHERE id = ?` with no version predicate.
- Ship the consolidation, product/start-date policy, events, and versioned update as **one PR**.

### 3. Copied member-access helpers
- [`assertPeopleRowScope`](file:///Users/admin/code/gym/apps/api/src/people/row-scope.ts) is the PEOPLE rule.
- The same admin/member/trainer block is rewritten as private `assertCanAccessMember` in workout plans, sessions, diet plans, diet logs, goals, measurements, progress notes, and progress photos.
- `goal/` and `notif/` throw Nest `ForbiddenException`; people/pay/diet throw `ForbiddenError` / `NotFoundError`.

### 4. In-Memory Demographic Bucketing in Reports
- **Location:** [`apps/api/src/reports/reports.repository.ts`](file:///Users/admin/code/gym/apps/api/src/reports/reports.repository.ts) (`getMembersReport`, ~L77)
- Loads every member `date_of_birth` into process memory and buckets in a loop.

### 5. Untyped Database Queries
- **Location:** `BaseRepository.getDb()`
- `DrizzleDb<any>` and `AnyTransaction` force `as any` on repository queries.

### 6. Schedule create is an optional bag
- [`scheduleWriteSchema`](file:///Users/admin/code/gym/apps/api/src/sched/schedule.dto.ts) makes create fields optional so PATCH can share it. `ScheduleService.create` then runtime-checks and inserts with `dto.schedule_type_id!` / `dto.title!`.

---

## 6. Operational & Infrastructure Status

*(Cross-referenced with [`apps/api/todo/backend-task-register.md`](file:///Users/admin/code/gym/apps/api/todo/backend-task-register.md))*

- **Database Engine Unification (`FND-000`):** ADR-0002 chose MySQL 8.4. `POSTGRES_MIGRATION_PLAN.md` and `POSTGRES_MIGRATION_TASKS.md` remain at the repo root with no deprecation header.
- **Vertical 17 (`OPS-001`–`OPS-015`):** Fifteen separate checks with FND dependencies. File `apps/api/test/booking-concurrency.e2e.spec.ts` exists; it still needs a real MySQL 8.4 run. Do not collapse OPS-001…015 into one ticket.

---

## 7. Recommended Remediation Order

Matches [`BACKEND_GAPS_TASKS_REGISTER.md`](file:///Users/admin/code/gym/BACKEND_GAPS_TASKS_REGISTER.md).

1. **Immediate (Blockers):** `pnpm install`; freeze the attendance **summary** test clock.
2. **Security & Data Integrity (High):** Fix `assertCanManagePlan`; wrap `assertPeopleRowScope`; consolidate membership in one PR.
3. **API Contract Parity (Medium):** `PUT /settings` (including seed `settings.update`) and medical-histories (including OpenAPI + parity-script updates).
4. **Performance & Optimization (Low):** SQL age buckets; typed Drizzle client; split schedule create/patch schemas.
5. **Stay deferred:** `PAY-012` receipt PDF, `PAY-013`/`PAY-014` gateway, `/health-conditions`.
