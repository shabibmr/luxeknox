# PostgreSQL Hardening Tasks Register

Derived from [POSTGRES_HARDENING_PLAN.md](./POSTGRES_HARDENING_PLAN.md).

**Rule:** Each task touches at most 7 files.  
**Status values:** `pending` · `in-progress` · `completed` · `blocked`

---

## Task Checklist Overview

### Part 1: The 5 Critical Error Fixes
- [x] **HARDEN-01:** Deterministic Pagination & Ordering in Food & Exercise Repositories <!-- id: H-01 -->
- [x] **HARDEN-02:** Deterministic Pagination & Ordering in People & System Repositories <!-- id: H-02 -->
- [x] **HARDEN-03:** Comprehensive FK Cascade & Catalogue Purge Graph Enhancements <!-- id: H-03 -->
- [x] **HARDEN-04:** Media Upload Contract Exhaustiveness & DTO Synchronization <!-- id: H-04 -->
- [x] **HARDEN-05:** CI Guardrails & Pre-commit Typecheck Enforcement <!-- id: H-05 -->

### Part 2: Security, Reliability & Performance Pillars
- [x] **HARDEN-06:** Connection Pool TLS/SSL Configuration & Timeout Hardening <!-- id: H-06 -->
- [x] **HARDEN-07:** Least-Privilege Verification & DDL/DML Boundary Audit <!-- id: H-07 -->
- [x] **HARDEN-08:** SQLSTATE Error Classification Expansion (`check_violation`, `serialization_failure`) <!-- id: H-08 -->
- [ ] **HARDEN-09:** Serialization Failure & Deadlock Automatic Retries in `runInTransaction` <!-- id: H-09 -->
- [ ] **HARDEN-10:** Migration `0019_partial_unique_indexes.sql` (Avatars, Active Memberships & Plans) <!-- id: H-10 -->
- [ ] **HARDEN-11:** Audit & Optimization of `SELECT ... FOR UPDATE` Locking Semantics <!-- id: H-11 -->
- [ ] **HARDEN-12:** Trigram Indexing (`pg_trgm`) & Search Query Acceleration <!-- id: H-12 -->

---

## Detailed Task Specifications

### Part 1 — Critical Error Hardening

#### HARDEN-01 — Deterministic Pagination & Ordering in Food & Exercise Repositories
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (4)** | `apps/api/src/diet/food.repository.ts`, `apps/api/src/work/exercise.repository.ts`, `apps/api/test/foods.e2e.spec.ts`, `apps/api/test/exercises.e2e.spec.ts` |

* **Description:** Add explicit `orderBy(desc(table.id))` clauses to `findManyFiltered` queries in `FoodRepository` and `ExerciseRepository`. PostgreSQL does not guarantee heap scan order, leading to unstable pagination when searching with offset/limit.
* **Verification:** Run `pnpm --filter api test:e2e test/foods.e2e.spec.ts test/exercises.e2e.spec.ts`. Verify page 1 and page 2 never return overlapping rows.

---

#### HARDEN-02 — Deterministic Pagination & Ordering in People & System Repositories
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | HARDEN-01 |
| **Files (5)** | `apps/api/src/people/member.repository.ts`, `apps/api/src/people/trainer.repository.ts`, `apps/api/src/people/employee.repository.ts`, `apps/api/src/attn/attendance.repository.ts`, `apps/api/src/reports/reports.repository.ts` |

* **Description:** Ensure all paginated lists and searches in Member, Trainer, Employee, Attendance, and Reports repositories declare deterministic `orderBy` expressions (e.g. `desc(table.created_at), desc(table.id)`).
* **Verification:** Run `pnpm --filter api test` and verify all pagination tests pass with consistent result ordering.

---

#### HARDEN-03 — Comprehensive FK Cascade & Catalogue Purge Graph Enhancements
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (4)** | `apps/api/test/helpers/postgres.ts`, `apps/api/test/booking-concurrency.e2e.spec.ts`, `apps/api/test/people-onboarding.e2e.spec.ts`, `apps/api/test/attendance-hardware.e2e.spec.ts` |

* **Description:** Expand `loadForeignKeyGraph` in `test/helpers/postgres.ts` to identify all multi-column foreign keys and dependent cascades (e.g. `schedule_participants` -> `schedule_histories` -> `schedules`, and `notification_deliveries` -> `users`). Remove brittle manual `DELETE` statements from individual test `afterAll` hooks and route cleanup through `resetTestData(db)`.
* **Verification:** Run `pnpm --filter api test:e2e` repeatedly without database leaks or foreign key constraint violation errors.

---

#### HARDEN-04 — Media Upload Contract Exhaustiveness & DTO Synchronization
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (4)** | `apps/api/src/media/media.dto.ts`, `apps/api/src/media/storage.service.ts`, `apps/api/src/people/member-photo.dto.ts`, `apps/api/test/people-onboarding.e2e.spec.ts` |

* **Description:** Reconcile `MEDIA_PURPOSES` enum with OpenAPI DTOs and client consumers. Ensure all endpoints uploading photos, avatars, waivers, and IDs use strictly typed enum values, with clear error messages for rejected purposes.
* **Verification:** Run `pnpm --filter api test:e2e test/people-onboarding.e2e.spec.ts` and verify unit tests for `StorageService`.

---

#### HARDEN-05 — CI Guardrails & Pre-commit Typecheck Enforcement
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (3)** | `apps/api/package.json`, `.github/workflows/ci.yml`, `package.json` |

* **Description:** Add `typecheck` (`tsc --noEmit`) to the primary test pipeline and CI script so that test files (`**/*.spec.ts`) are type-checked continuously alongside production source code.
* **Verification:** Run `pnpm run typecheck` across root and `apps/api`, ensuring zero TypeScript errors exist.

---

### Part 2 — Security, Reliability & Performance Pillars

#### HARDEN-06 — Connection Pool TLS/SSL Configuration & Timeout Hardening
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (3)** | `apps/api/src/platform/db/client.ts`, `apps/api/.env.example`, `apps/api/src/platform/db/client.spec.ts` |

* **Description:** Add TLS/SSL configuration support to `createConnectionPool` in `client.ts` (`ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: true } : false` and connection string URL parsing). Configure `connectionTimeoutMillis` (5000ms), `idleTimeoutMillis` (30000ms), and PostgreSQL `statement_timeout` ('15s').
* **Verification:** Unit test `createConnectionPool` with mock SSL options and verify connection limits.

---

#### HARDEN-07 — Least-Privilege Verification & DDL/DML Boundary Audit
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | HARDEN-06 |
| **Files (4)** | `apps/api/src/platform/db/client.ts`, `apps/api/drizzle/repeatable/grants.sql`, `apps/api/test/settings.e2e.spec.ts`, `apps/api/src/platform/health/health.controller.ts` |

* **Description:** Implement bootstrap verification asserting that `DB_USER` (`luxeknox_app`) cannot execute DDL statements (e.g. `CREATE TABLE`, `DROP TABLE`). Re-verify that `audit_logs` UPDATE and DELETE mutations are rejected at the database level.
* **Verification:** Run `pnpm --filter api test:e2e test/settings.e2e.spec.ts`.

---

#### HARDEN-08 — SQLSTATE Error Classification Expansion
| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files (4)** | `apps/api/src/platform/db/pg-errors.ts`, `apps/api/src/platform/db/db-error.ts`, `apps/api/src/platform/db/db-error.spec.ts`, `apps/api/src/platform/db/base.repository.ts` |

* **Description:** Extend `pg-errors.ts` to recognize:
  * `23514` (`check_violation`)
  * `40001` (`serialization_failure`)
  * `40P01` (`deadlock_detected`)
  * `22P02` (`invalid_text_representation`)
  Map `23514` and `22P02` to `BadRequestError` (400), and expose helper functions `isSerializationFailure()` and `isDeadlock()`.
* **Verification:** Unit test error translation in `db-error.spec.ts`.

---

#### HARDEN-09 — Serialization Failure & Deadlock Automatic Retries in `runInTransaction`
| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | HARDEN-08 |
| **Files (3)** | `apps/api/src/platform/db/transaction-context.ts`, `apps/api/src/platform/db/transaction-context.spec.ts`, `apps/api/test/booking-concurrency.e2e.spec.ts` |

* **Description:** Enhance `runInTransaction()` to catch PostgreSQL transient concurrency errors (`40001` serialization failure and `40P01` deadlock) and automatically retry the transaction block up to 3 times with exponential backoff and jitter.
* **Verification:** Run `pnpm --filter api test:e2e test/booking-concurrency.e2e.spec.ts`.

---

#### HARDEN-10 — Migration `0019_partial_unique_indexes.sql`
| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | — |
| **Files (6)** | `apps/api/drizzle/0019_partial_unique_indexes.sql`, `apps/api/drizzle/meta/_journal.json`, `apps/api/drizzle/meta/0000_snapshot.json`, `apps/api/src/platform/db/schema/member-photos.ts`, `apps/api/src/platform/db/schema/memberships.ts`, `apps/api/src/platform/db/schema/workout.ts` |

* **Description:** Implement migration `0019` adding partial unique indexes:
  * `one_current_avatar_per_member` on `member_photos(member_id) WHERE is_current_avatar = true`
  * `one_active_membership_per_member` on `memberships(member_id) WHERE status = 'active'`
  * `one_active_workout_plan_per_member` on `workout_plans(member_id) WHERE is_active = true`
  * `one_active_diet_plan_per_member` on `diet_plans(member_id) WHERE is_active = true`
* **Verification:** Run `pnpm --filter api db:migrate` and verify unique constraints are enforced at the DB level.

---

#### HARDEN-11 — Audit & Optimization of `SELECT ... FOR UPDATE` Locking Semantics
| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | HARDEN-09 |
| **Files (4)** | `apps/api/src/people/person.factory.ts`, `apps/api/src/attn/attendance.repository.ts`, `apps/api/src/sched/booking.service.ts`, `apps/api/test/booking-concurrency.e2e.spec.ts` |

* **Description:** Audit all `FOR UPDATE` queries to ensure they lock only strictly required primary rows and sort row locks in consistent order to prevent deadlocks under high-throughput registration, check-in, and booking races.
* **Verification:** Run `pnpm --filter api test:e2e test/booking-concurrency.e2e.spec.ts test/attendance-hardware.e2e.spec.ts`.

---

#### HARDEN-12 — Trigram Indexing (`pg_trgm`) & Search Query Acceleration
| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | HARDEN-10 |
| **Files (5)** | `apps/api/drizzle/0020_trigram_search.sql`, `apps/api/drizzle/meta/_journal.json`, `apps/api/drizzle/meta/0000_snapshot.json`, `apps/api/src/diet/food.repository.ts`, `apps/api/src/work/exercise.repository.ts` |

* **Description:** Create migration `0020` activating the `pg_trgm` extension in PostgreSQL and adding GIN trigram indexes on `foods(name gin_trgm_ops)` and `exercises(name gin_trgm_ops)` to accelerate `ILIKE` pattern queries.
* **Verification:** Run `EXPLAIN ANALYZE SELECT * FROM foods WHERE name ILIKE '%apple%'` and confirm index scan utilization.
