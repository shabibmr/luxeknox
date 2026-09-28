# LuxeKnox Backend — Implementation Plan & Master Task Register Review

**Date:** 2026-09-21  
**Target Directory:** `apps/api/todo`  
**Reviewed Artifacts:**
- `apps/api/todo/backend-implementation-plan.md`
- `apps/api/todo/backend-task-register.md`
- Target contracts & schemas: `docs/backend-frd.md`, `docs/database-entities.md`, `docs/openapi/v1.yaml`, `POSTGRES_MIGRATION_PLAN.md`
- Running codebase: `apps/api/src`

---

## Executive Summary

A comprehensive audit of the backend implementation plan and task register against the current codebase (`apps/api/src`, active tests, Drizzle schema, OpenAPI parity scripts, and architectural decision records) reveals several critical discrepancies, sequencing risks, false-positive completion statuses, and unaddressed infrastructure requirements.

While the existing foundation (`auth`, `rbac`, `people`, `memb`, catalogue items) is solid and unit tests pass cleanly (34 test files, 219 tests), the task register does not accurately reflect the actual implementation state. Furthermore, a pending database engine pivot (MySQL vs. PostgreSQL) and missing cross-cutting infrastructure (idempotency, background job framework) pose significant risks to upcoming vertical deliveries if not aligned immediately.

---

## 1. Vertical Numbering & Dependency Ordering Mismatch

There is a significant disconnect between the phase structure defined in the **Implementation Plan** (`backend-implementation-plan.md` §6 & §7) and the **Task Register** (`backend-task-register.md`):

| Domain | Implementation Plan (`§6`) | Task Register (`backend-task-register.md`) | Discrepancy & Risk |
|---|---|---|---|
| **Auth & RBAC** | `V01 Auth + RBAC completion` | Split into `Vertical 01` (Auth) and `Vertical 02` (RBAC) | Introduces a 1-off vertical index discrepancy across all subsequent domains. |
| **People & Health** | `V02 People + Health + Media hardening` | Split into `Vertical 03` (People) and `Vertical 04` (Health) | Continues the phase index drift. |
| **Media** | Grouped early into `V02` (before Membership, Scheduling, Billing) | Placed at **`Vertical 15`** (after Dashboard & Reports) | **Critical dependency break:** Payments (`Vertical 08` / `PAY-012`) explicitly requires media generation for PDF receipts, and Member onboarding (`Vertical 03`) requires avatar and identity-proof document uploads. Media cannot be scheduled after Reports and Dashboard. |
| **Master Checklist** | Lists 14 delivery stages (`V00`–`V14`) | Lists 18 task sections (`00`–`17` + `99`) | Developers and autonomous agents tracking work will encounter conflicting task identifiers and milestones. |

---

## 2. False Completion Sign-Off in Foundation (`Vertical 00`)

In `backend-task-register.md`, all tasks under **Vertical 00 — Foundation** (`FND-001` through `FND-016`) are marked completed (`[x]`). An inspection of `apps/api/src/platform/` shows that several critical tasks are not implemented or only partially stubbed:

1. **`FND-010` (Generic Idempotency Store/Guard for Mutation Endpoints):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* **No implementation exists.** There is no idempotency interceptor, guard, cache table (`idempotency_keys`), or storage adapter anywhere in `apps/api/src/`. In a gym management system managing POS payments, turnstile check-ins, and membership activations, absent idempotency invites duplicate transactions under client network retries.
2. **`FND-006` (Startup Environment Validation & Fail-Fast Diagnostics):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* `main.ts` directly reads raw `process.env` properties (`process.env.PORT`, `process.env.LOG_LEVEL`) with arbitrary fallbacks. There is no schema validation (e.g., Zod or Envalid) at bootstrap to ensure database credentials, token secrets, or encryption keys are present and valid before serving traffic.
3. **`FND-005` (Harden CORS, Security Headers, Proxy Configuration):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* `main.ts` simply calls `app.enableCors()` with default permissive parameters; neither `helmet` nor custom security response headers are configured.
4. **`FND-013` (Consistent DB Constraint/Error Translation):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* In `src/platform/errors/exception.filter.ts`, native database errors (such as MySQL `ER_DUP_ENTRY` or `ER_NO_REFERENCED_ROW_2`) fall straight through to the generic `exception instanceof Error` branch, producing an opaque HTTP 500 `INTERNAL_ERROR` rather than translating constraint violations to HTTP 409 `CONFLICT` or HTTP 400/404.
5. **`FND-014` (DB Pool Health/Readiness Diagnostics):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* `health.controller.ts` runs a basic `SELECT 1` in `getReady()`. It does not report connection pool stats, worker saturation, or active connections.
6. **`FND-011` (Audit Log Append-Only Guarantees):**
   * *Status in register:* Marked complete (`[x]`).
   * *Actual codebase:* `audit.service.ts` only implements an `insert()` method. No database privilege restrictions (`REVOKE UPDATE, DELETE ON audit_logs FROM ...`) or triggers exist to prevent mutations at the engine level as mandated by ADR-0002.

---

## 3. Out-of-Sync Task Statuses in Already-Implemented Verticals

Conversely, the Task Register marks subsequent verticals as completely pending (`[ ]`), ignoring code that is already built, tested, and passing:

* **Authentication (`Vertical 01`):** `AUTH-002` (phone/email normalization), `AUTH-004` (family rotation & refresh tokens), `AUTH-005` (logout revocation), `AUTH-008` (login throttle in `login-throttle.ts`), and `AUTH-010` (`/me` projection in `me.controller.ts`) are already fully implemented and verified in `auth.service.spec.ts`.
* **Membership (`Vertical 05`):** `MEM-001` (product CRUD) and `MEM-005` (freeze workflows) already possess working controllers, services, and repositories in `apps/api/src/memb`.
* **People (`Vertical 03` & `04`):** Emergency contacts, member documents, member photos, and member health profiles already exist under `apps/api/src/people`.

---

## 4. Database Engine Conflict: MySQL 8.4 vs. PostgreSQL Migration

* **The Conflict:** `backend-implementation-plan.md` establishes that the current schema is MySQL 8.4 (`drizzle-orm/mysql-core`), and proposes implementing 33+ remaining tables in MySQL.
* However, the repository has an active, detailed migration proposal in the root directory: `POSTGRES_MIGRATION_PLAN.md` and `POSTGRES_MIGRATION_TASKS.md`.
* **The Gap:** The implementation plan briefly notes in Section 13 (line 756) to resolve this decision before authoring remaining migrations, but the delivery roadmap does **not** make this an explicit prerequisite milestone. Building 39 tables, indexes, and stored generated columns in MySQL first, only to immediately rewrite them for Postgres (`pg-core`, `TIMESTAMPTZ`, JSONB, partial indexes), introduces huge duplicated engineering effort.

---

## 5. Table Count & Entity Accounting Discrepancy

* `docs/database-entities.md` specifies **56 canonical tables**.
* Currently, `apps/api/src/platform/db/schema` contains 16 table schemas.
* In `backend-implementation-plan.md` §5.1, the plan lists missing schemas as:
  * Schedule (6) + Attendance (2) + Billing (4) + Workout (5) + Diet (5) + Goals (7) + Notifications (4) = **33 tables**.
  * 16 existing + 33 missing = **49 tables**.
* **Missing Tables:** The plan's §5.1 count omits **7 tables** defined in `database-entities.md`:
  1. `membership_number_counters` (MariaDB/MySQL-safe sequence counter for member IDs)
  2. `medical_histories`
  3. `health_conditions`
  4. `emergency_contacts` (currently only exists in service types, not as an isolated schema definition if counted against the 6 health tables)
  5. Missing membership lifecycle tables (`membership_freezes`, `membership_extensions`, `membership_histories` are partially bundled or missing from the standalone table count).

---

## 6. Missing Background Job Infrastructure

* In `backend-implementation-plan.md` §9, 11 background jobs are mandated (auto-checkout, attendance daily rollup, membership expiry, payment reminders, etc.) with strict execution metadata (job name, schedule, attempt count, correlation ID).
* **The Gap:**
  * `package.json` contains **no job scheduling or queue dependencies** (no `@nestjs/schedule`, BullMQ, Redis, or cron engine).
  * Neither `Vertical 00` (Foundation) nor `Vertical 10` (Notifications/Jobs) defines a task to create the base job runner/scheduler abstraction or job history table. The tasks only mention individual business jobs (e.g. `MEM-009`, `ATT-014`, `NOT-013`) with no runtime engine to host them.

---

## 7. Contract Conflict: Deferred Health Endpoints vs. OpenAPI Parity

* In `Vertical 04` of the Task Register:
  * `HLT-002: Implement health-condition master CRUD`
  * `HLT-003: Complete medical-history CRUD and clearance rules`
* **The Conflict:** In `apps/api/scripts/check-openapi-parity.ts`, `medical-histories` and `health-conditions` are explicitly marked as `x-status: deferred` in `docs/openapi/v1.yaml`.
* In fact, `check-openapi-parity.ts` actively throws an error if these endpoints appear in the MVP parity set:
  ```typescript
  // check-openapi-parity.ts line 153
  if (deferredLeaked.length > 0) {
    throw new Error(`OpenAPI parity failed: deferred medical-histories/health-conditions appeared in required mvp set`);
  }
  ```
* Including them as required MVP tasks in `HLT-002` / `HLT-003` will break CI contract checks unless `docs/openapi/v1.yaml` and the parity script are explicitly amended first.

---

## 8. File Structure & Path Referencing Issues

* In `backend-task-register.md`, each section includes a comment header like:
  `<!-- FILE: docs/backend-tasks/00-foundation.md -->`
* However, the directory `docs/backend-tasks/` does not exist; the entire register is kept as a single file in `apps/api/todo/backend-task-register.md`.
* The plan also links to `docs/backend-implementation-plan.md` and `docs/backend-task-register.md` as canonical paths (lines 788–809), whereas they currently reside under `apps/api/todo/`.

---

## Recommended Remediation Steps

1. **Re-align Vertical Order:** Move Media hardening (`Vertical 15`) up to precede Scheduling, Attendance, and Payments (or keep it in `V02` as originally structured in the plan).
2. **Correct Foundation Status:** Reopen `FND-005`, `FND-006`, `FND-010`, `FND-013`, and `FND-014` in the register until the idempotency store, startup env validation, and MySQL error translation are implemented.
3. **Decide DB Target (MySQL vs Postgres):** Settle whether to proceed with Hostinger MySQL 8.4 or execute `POSTGRES_MIGRATION_PLAN.md` *before* writing the remaining 39 table schemas.
4. **Add Job Infrastructure Task:** Create a foundational task in `V00` or `V10` to add `@nestjs/schedule` (or queue worker) and define the common execution harness required by Section 9.
5. **Harmonize OpenAPI Parity:** Either formally promote `medical-histories` and `health-conditions` to MVP status in `docs/openapi/v1.yaml` and update `check-openapi-parity.ts`, or mark `HLT-002` and `HLT-003` as post-MVP deferred tasks.
