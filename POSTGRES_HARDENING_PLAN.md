# PostgreSQL Migration Hardening & Quality Assurance Plan

## 1. Context & Objectives

Following the code review of the `postgres-migration` branch and the reconciliation of merged verticals from `origin/main`, this plan establishes the remediation and production hardening framework.

It specifically addresses:
* **The 5 Critical Issues:** Test concurrency isolation, FK cascade graph resolution, media upload contract adherence, build/typecheck CI gates, and deterministic repository pagination.
* **The 3 Security, Reliability & Performance Pillars:**
  1. Connection pool hardening, SSL/TLS enforcement, and least-privilege role boundaries.
  2. SQLSTATE error classification, check constraint handling, and transaction serialization retries.
  3. PostgreSQL partial unique indexes (PG-17 & PG-38), `SELECT ... FOR UPDATE` contention audits, and search indexing strategy (`pg_trgm`).

---

## 2. The 5 Critical Error Fixes

### Area 1: Deterministic Query Pagination & Order By Guarantees
* **Root Cause:** PostgreSQL does not guarantee heap scan order without an explicit `ORDER BY`. In `FoodRepository.findManyFiltered` and `ExerciseRepository.findManyFiltered`, offset pagination (`limit`, `offset`) executed without deterministic sorting. When running consecutive tests or searching under data ingestion, newly inserted rows shifted across pages, causing test assertions and frontend infinite scrolling to skip or repeat rows.
* **Remediation:**
  - Add explicit, indexed tie-breaker ordering (`ORDER BY table.id DESC` or `ORDER BY table.created_at DESC, table.id DESC`) to all repository `findManyFiltered` queries (`FoodRepository`, `ExerciseRepository`, `MemberRepository`, `AuditRepository`, `NotificationRepository`).
  - Verify that matching compound indexes exist in DDL to prevent full table sorts on offset queries.

### Area 2: Robust Foreign Key Teardown & Catalogue Purge Graph
* **Root Cause:** In `test/helpers/postgres.ts`, `loadForeignKeyGraph()` queries the `pg_constraint` catalogue for single-column foreign keys. However, test teardowns encountered FK constraint violations (`schedule_participants_member_id_fk`, `notification_deliveries_user_id_fk`, `schedule_histories_schedule_id_fk`) when individual tests performed ad-hoc manual SQL deletes in `afterAll` without topological traversal.
* **Remediation:**
  - Enhance `purge()` in `test/helpers/postgres.ts` to support multi-column foreign keys and handle multi-parent dependency graphs.
  - Standardize all E2E test suites to rely on `resetTestData(db)` or declarative domain purge helpers rather than manual, brittle `DELETE FROM table WHERE ...` statements.

### Area 3: Media Upload Contract & Purpose Type Consistency
* **Root Cause:** `StorageService` strictly validates upload requests against `MEDIA_PURPOSES` (`['exercise_media', 'avatar', 'progress_photo', 'id_proof', 'waiver', 'medical_cert', 'receipt_pdf']`). In `test/people-onboarding.e2e.spec.ts`, requests passed `purpose: 'member_photo'`, resulting in runtime validation rejections (`400 Bad Request`).
* **Remediation:**
  - Ensure compile-time exhaustiveness between client DTOs, OpenAPI specifications, and `MEDIA_PURPOSES`.
  - Add an automated contract check verifying that every enum variant in `mediaUploadRequestSchema` has a corresponding test and handler limit in `PURPOSE_LIMITS`.

### Area 4: Full Test & Typecheck CI Guardrails
* **Root Cause:** `pnpm build` (`tsc -p tsconfig.build.json`) excludes spec files. Spec type mismatches (such as `membService` typed as a mock dictionary while instantiated as `new MembershipService(...)`) compiled undetected during builds and only surfaced during explicit `tsc --noEmit` executions.
* **Remediation:**
  - Integrate `pnpm typecheck` into `package.json` pre-push and CI workflows alongside `test` and `build`.
  - Add a CI check step preventing any merge if `tsc --noEmit` reports errors on test files.

### Area 5: E2E Test Database Isolation & Serial Execution
* **Root Cause:** Vitest by default executes test files in parallel worker processes. Because all E2E tests share the single local PostgreSQL database (`luxeknox`), concurrent test runs that reset sessions or test users (`DELETE FROM sessions`) cause cross-test authentication and state collisions.
* **Remediation:**
  - Explicitly enforce `--no-file-parallelism` in the `test:e2e` script in `package.json` and `fileParallelism: false` in `vitest.config.e2e.ts`.
  - Structure CI environments to run E2E suites against isolated schemas or ephemeral test database instances.

---

## 3. Security, Reliability & Performance Analysis

### Pillar 1: Security & Connection Pool Hardening (Least Privilege + TLS/SSL)
* **SSL/TLS Configuration:**
  - Update `createConnectionPool` in `src/platform/db/client.ts` to support secure SSL connections when running in non-local environments (`ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: true } : false`).
  - Add `sslmode=require` parameter parsing for `DATABASE_URL`.
* **Connection Lifecycle & Resource Limits:**
  - Configure pool timeouts: `connectionTimeoutMillis: 5000`, `idleTimeoutMillis: 30000`, and PostgreSQL statement timeouts (`statement_timeout = '15s'`) to prevent rogue queries from locking connections indefinitely.
* **Least-Privilege Enforcement:**
  - Enforce runtime verification in app bootstrap ensuring the application pool is connected as `DB_USER` (`luxeknox_app`), never as `DB_ADMIN_USER`.
  - Maintain the tamper-evident security posture of `audit_logs` where `UPDATE` and `DELETE` privileges are strictly revoked from `luxeknox_app`.

### Pillar 2: Reliability & Comprehensive SQLSTATE Error Handling
* **Extended SQLSTATE Mapping:**
  - Expand `pg-errors.ts` and `db-error.ts` to classify:
    * `23505` (`unique_violation`) → `ConflictError` (409)
    * `23503` (`foreign_key_violation`) → `ConflictError` / `BadRequestError` (409/400)
    * `23514` (`check_violation`) → `BadRequestError` (400)
    * `40001` (`serialization_failure`) & `40P01` (`deadlock_detected`) → Transient database error with retry capability.
* **Transaction Serialization & Retries:**
  - Update `runInTransaction()` in `transaction-context.ts` to catch `40001` (serialization failure) and `40P01` (deadlock) and retry up to 3 times with exponential backoff and jitter, critical for concurrent high-load booking and membership counter increments.

### Pillar 3: Performance, Locking & Partial Unique Indexes (PG-17 & PG-38)
* **Partial Unique Indexes (DDL Migration `0019`):**
  - Leverage PostgreSQL's native support for partial unique indexes to replace fragile application-level checks:
    1. `member_photos_one_current_avatar`: `CREATE UNIQUE INDEX member_photos_one_current_avatar_idx ON member_photos (member_id) WHERE is_current_avatar = true;`
    2. `memberships_one_active`: `CREATE UNIQUE INDEX memberships_one_active_idx ON memberships (member_id) WHERE status = 'active';`
    3. `workout_plans_one_active`: `CREATE UNIQUE INDEX workout_plans_one_active_idx ON workout_plans (member_id) WHERE is_active = true;`
    4. `diet_plans_one_active`: `CREATE UNIQUE INDEX diet_plans_one_active_idx ON diet_plans (member_id) WHERE is_active = true;`
* **Concurrency & Lock Optimization:**
  - Audit all `SELECT ... FOR UPDATE` statements across `PersonFactory.allocateMembershipNumber()`, `BookingService`, and `AttendanceService` to ensure queries lock only required rows and order keys deterministically to avoid deadlocks.
* **Search Performance Roadmap (PG-37):**
  - Enable `pg_trgm` extension in migration `0020_trigram_search.sql` and add GIN trigram indexes on `foods.name` and `exercises.name` to replace sequential table scans during `ILIKE %query%` searches.

---

## 4. Verification & Quality Gates

Each task must pass the following verification gates before promotion to `main`:
1. `pnpm --filter api run build` compiles with zero warnings or errors.
2. `pnpm --filter api run typecheck` passes with zero type errors across `src/` and `test/`.
3. `pnpm --filter api run lint` exits cleanly with zero errors.
4. `pnpm --filter api test` executes all 68 unit test suites and 528+ tests successfully.
5. `pnpm --filter api test:e2e` executes all 9 E2E test suites and 52+ tests sequentially against PostgreSQL 17 with 100% pass rate.
6. `pnpm --filter api db:migrate` and `pnpm --filter api db:seed` run idempotently on a fresh PostgreSQL instance.
