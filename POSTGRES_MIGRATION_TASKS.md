# Tasks Register — MySQL 8.4 → PostgreSQL Migration

Derived from [POSTGRES_MIGRATION_PLAN.md](./POSTGRES_MIGRATION_PLAN.md).

**Rule:** each task touches at most 7 files (carried over from `archive/todo/README.md`).
**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`

48 tasks across 13 phases (Phase 12 added after merging `origin/main`). Phases 1–6 leave the tree uncompilable in the middle and must land as
one reviewable unit.

---

## Checklist

**Phase 0 — Decisions (blocking)**
- [x] PG-01 Settle production PostgreSQL hosting <!-- id: 1 --> _(recommendation adopted: managed PostgreSQL; final vendor pick deferred to user before Phase 10 cutover — does not block Phases 1-9)_
- [x] PG-02 Settle and record engineering decisions 1–5 <!-- id: 2 --> _(plan recommendations adopted verbatim — see ADR-0009)_

**Phase 1 — Infrastructure**
- [x] PG-03 Docker Compose + `postgres.conf` <!-- id: 3 -->
- [x] PG-04 Environment variables <!-- id: 4 -->
- [x] PG-05 Dependencies + `drizzle.config.ts` <!-- id: 5 -->

**Phase 2 — Connection layer**
- [x] PG-06 `client.ts` — pg Pool, type parsers, UTC session <!-- id: 6 -->
- [x] PG-07 `drizzle.module.ts` + `transaction-context.ts` <!-- id: 7 -->
- [x] PG-08 `utcDatetime()` → `TIMESTAMPTZ(3)` <!-- id: 8 -->

**Phase 3 — Drizzle schema**
- [x] PG-09 Platform tables (7 files) <!-- id: 9 -->
- [x] PG-10 Catalogue tables (2 files) <!-- id: 10 -->
- [x] PG-11 PEOPLE tables (6 files) <!-- id: 11 -->

**Phase 4 — SQL migrations**
- [x] PG-12 Rewrite `0001`–`0003` <!-- id: 12 -->
- [x] PG-13 Rewrite `0004`–`0005` <!-- id: 13 -->
- [x] PG-14 Rewrite `repeatable/grants.sql` <!-- id: 14 -->
- [x] PG-15 Rewrite `migrate.ts` runner <!-- id: 15 -->
- [x] PG-16 Regenerate journal + baseline snapshot <!-- id: 16 -->
- [ ] PG-17 `0019` partial unique indexes (opportunity) <!-- id: 17 -->

**Phase 5 — Repository layer**
- [x] PG-18 `BaseRepository` — pg types, boolean, `RETURNING` <!-- id: 18 -->
- [x] PG-19 SQLSTATE error mapping <!-- id: 19 -->
- [x] PG-20 `insertId` → `RETURNING` in 7 repositories <!-- id: 20 -->
- [x] PG-21 `PersonFactory` — raw SQL, result shape, dup detection <!-- id: 21 -->
- [x] PG-22 `like()` → `ilike()` in 5 repositories <!-- id: 22 -->
- [x] PG-23 Health controller + JSON normalizer doc drift <!-- id: 23 -->

**Phase 6 — Seeds**
- [x] PG-24 `onDuplicateKeyUpdate` → `onConflictDoUpdate` in 4 seed files <!-- id: 24 -->

**Phase 7 — Tests**
- [x] PG-25 Rename + rewrite E2E helper <!-- id: 25 -->
- [x] PG-26 Update 5 E2E specs + affected unit specs <!-- id: 26 -->
- [x] PG-27 Add PostgreSQL-specific regression tests <!-- id: 27 -->

**Phase 8 — CI & deployment**
- [ ] PG-28 GitHub Actions service container <!-- id: 28 -->
- [ ] PG-29 Deployment scripts + runbook <!-- id: 29 -->

**Phase 9 — Documentation**
- [ ] PG-30 Write ADR-0009 <!-- id: 30 -->
- [ ] PG-31 Supersede ADR-0002; update README + docs <!-- id: 31 -->
- [ ] PG-32 Re-dump OpenAPI and verify parity <!-- id: 32 -->

**Phase 10 — Data migration**
- [ ] PG-33 Extract + load production data <!-- id: 33 -->
- [ ] PG-34 Reset identity sequences + membership counter <!-- id: 34 -->
- [ ] PG-35 Validate migrated data <!-- id: 35 -->
- [ ] PG-36 Production cutover <!-- id: 36 -->

**Phase 11 — Follow-ups (deferred, not part of cutover)**
- [ ] PG-37 `pg_trgm` / `unaccent` search indexes for FR-API-014 <!-- id: 37 -->
- [ ] PG-38 Remaining four "at most one" partial unique indexes <!-- id: 38 -->
- [ ] PG-39 NFR-004 PITR restore drill on PostgreSQL <!-- id: 39 -->

**Phase 12 — Post-merge port (verticals landed on `origin/main` as MySQL, merged in `cbcea77`)**
- [x] PG-40 Port schema files, batch A (6 files) <!-- id: 40 -->
- [x] PG-41 Port schema files, batch B (6 files) <!-- id: 41 -->
- [x] PG-42 Rewrite migrations `0006`–`0011` <!-- id: 42 -->
- [x] PG-43 Rewrite migrations `0012`–`0018` <!-- id: 43 -->
- [x] PG-44 `insertId` → `RETURNING` in main's repositories (~16 files, 3 batches) <!-- id: 44 -->
- [x] PG-45 `onDuplicateKeyUpdate` → `onConflictDoUpdate` (5 files) <!-- id: 45 -->
- [x] PG-46 Raw SQL: `FOR UPDATE` counters, `DATEDIFF`, `like` → `ilike` <!-- id: 46 -->
- [x] PG-47 Journal + snapshot reconciliation; renumber PG-17 to `0019` <!-- id: 47 -->
- [x] PG-48 Grants, E2E reset list, and test fixes for new tables <!-- id: 48 -->

---

## Dependency graph

```
PG-01 ─┬─ PG-03 ─ PG-04 ─ PG-05 ─ PG-06 ─┬─ PG-07 ─ PG-08 ─┬─ PG-09 ─┬─ PG-12 ─ PG-13 ─┬─ PG-16
PG-02 ─┘                                 │                 ├─ PG-10 ─┤                 │
                                         │                 └─ PG-11 ─┘                 │
                                         │                            PG-14 ─ PG-15 ───┤
                                         │                                             │
                                         └─ PG-18 ─┬─ PG-19 ─ PG-20 ─ PG-21 ─ PG-22 ─ PG-23
                                                   └─ PG-24
                                                        │
                                              PG-25 ─ PG-26 ─ PG-27 ─ PG-17
                                                        │
                                              PG-28 ─ PG-29
                                                        │
                            PG-30 ─ PG-31 ─ PG-32       │
                                                        │
                            PG-33 ─ PG-34 ─ PG-35 ─ PG-36
                                                        │
                                              PG-37 · PG-38 · PG-39
```

---

## Phase 0 — Decisions

### PG-01 — Settle production PostgreSQL hosting

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Owner** | Product / Tech lead |
| **Risk** | **Critical — blocks everything** |
| **Files** | 0 (decision recorded in PG-30) |

ADR-0002 chose MySQL because Hostinger provisions and backs it up natively. PostgreSQL forfeits
that. Choose: managed PostgreSQL (recommended), self-hosted on the existing VPS, or
Hostinger-provided PostgreSQL if the plan offers it.

**Done when:** the target is named, provisioned or quoted, and its point-in-time-recovery story is
confirmed against NFR-004 — nightly dumps alone do not satisfy it.

### PG-02 — Settle and record engineering decisions 1–5

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Risk** | High — each one changes multiple downstream tasks |
| **Files** | 0 |

Decide: (1) `TIMESTAMPTZ` vs `TIMESTAMP`; (2) the `utf8mb4_0900_ai_ci` replacement strategy
(FR-API-014); (3) `pgEnum` vs `VARCHAR`+`CHECK`; (4) the `int8`→`Number` type parser; (5)
`BIGINT GENERATED ALWAYS AS IDENTITY` plus `CHECK (col >= 0)` where unsignedness carried meaning.

**Done when:** all five are recorded with reasoning, ready to paste into ADR-0009.

---

## Phase 1 — Infrastructure

### PG-03 — Docker Compose + `postgres.conf`

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 3 |

- `docker-compose.yml` — `postgres:17-alpine`, `luxeknox-postgres`, `POSTGRES_*`, port `5432`,
  `postgres_data` volume, `pg_isready` healthcheck.
- `apps/api/docker/mysql.cnf` — delete.
- `apps/api/docker/postgres.conf` — `timezone = 'UTC'`,
  `default_transaction_isolation = 'read committed'`, WAL settings for PITR.

**Done when:** `docker compose up -d` reports healthy on a clean volume and
`psql -c "SHOW timezone"` returns `UTC`.

### PG-04 — Environment variables

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 2 |

`.env.example` and the local `.env`: `postgres://` URL, port `5432`. Keep the `DB_USER` /
`DB_ADMIN_USER` split and its least-privilege comments (fix F-03). Update the
"pool enforces `time_zone='+00:00'`" comment to reference `TIMESTAMPTZ`.

**Done when:** `.env.example` describes a working local PostgreSQL and no MySQL string remains.

### PG-05 — Dependencies + `drizzle.config.ts`

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 3 |

Remove `mysql2`; add `pg` + `@types/pg`. `drizzle.config.ts`: `dialect: 'postgresql'`, default port
`5432`, widen the local `DrizzleConfig['dialect']` literal type.

**Done when:** `pnpm install` resolves, `pnpm-lock.yaml` has no `mysql2`, and `drizzle-kit check`
runs (it may still report drift until PG-16).

---

## Phase 2 — Connection layer

### PG-06 — `client.ts` — pg Pool, type parsers, UTC session

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | **High — Decision 4 lands here** |
| **Files** | 1 |

`apps/api/src/platform/db/client.ts`: `pg.Pool` + `drizzle-orm/node-postgres`; `uri`→
`connectionString`, `connectionLimit`→`max`; drop `waitForConnections`/`queueLimit`/`dateStrings`
and `mode: 'default'`; `DrizzleDb` → `NodePgDatabase`. Add `pg.types.setTypeParser(20, Number)`
with the `MAX_SAFE_INTEGER` note, and leave OID 1700 (`numeric`) as a string so `Money` stays
exact. Preserve `createAdminConnectionPool`'s guarantee that it never falls back to the app user.

**Done when:** a pool connects, `SELECT 1` succeeds, and a `BIGINT` column read through raw
`.execute()` comes back as `number`.

### PG-07 — `drizzle.module.ts` + `transaction-context.ts`

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 2 |

Swap the `Pool` import to `pg`; `MySqlTransaction` → `PgTransaction`. No structural change to the
`@Global()` module, the two DI tokens, or `runInTransaction`'s ambient-join semantics.

**Done when:** `transaction-context.spec.ts` passes unchanged in substance.

### PG-08 — `utcDatetime()` → `TIMESTAMPTZ(3)`

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | Medium — 40 columns depend on this one helper |
| **Files** | 2 |

`utc-datetime.ts`: `timestamp(name, { precision: 3, withTimezone: true, mode: 'date' })`, return
type from `pg-core`. Update `utc-datetime.spec.ts` metadata expectations and **keep the UTC
round-trip assertion** — it is the regression test for ADR-0002's highest-risk convention.

**Done when:** a known instant round-trips identically from a session in a non-UTC timezone.

---

## Phase 3 — Drizzle schema

### PG-09 — Platform tables

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 7 |

`schema/roles.ts`, `permissions.ts`, `role-permissions.ts`, `users.ts`, `sessions.ts`,
`gym-settings.ts`, `audit-logs.ts`.

`pgTable`; identity PKs; `mysqlEnum` → module-scope `pgEnum` for `user_type` (shared by `users` and
`sessions`) and `users.status`, built from the existing `USER_TYPES` / `USER_STATUSES` tuples;
`json` → `jsonb` on `audit_logs.before_state` / `after_state`; native `boolean` for
`roles.is_system`.

**Done when:** these 7 files typecheck and every `$inferSelect` / `$inferInsert` type is unchanged.

### PG-10 — Catalogue tables

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 2 |

`schema/exercises.ts`, `foods.ts`. `double` → `doublePrecision` (7 columns), `json` → `jsonb`
(`secondary_muscles`, keeping `.$type<string[]>()`), native `boolean` (3 columns), `index()`
builders unchanged.

### PG-11 — PEOPLE tables

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 6 |

`schema/trainers.ts`, `employees.ts`, `members.ts` (also holds `membership_number_counters` and
`emergency_contacts`), `member-health.ts`, `member-documents.ts`, `member-photos.ts`.

`pgEnum` for `employees.status` and `member_documents.document_type`;
`decimal` → `numeric(12,2)` for `trainers.hourly_rate` (still a TS string — `Money` is safe);
`json` → `jsonb` for `specializations`; `doublePrecision` ×4; `membership_number_counters.id` stays
a non-identity `BIGINT` PK.

**Done when:** `pnpm --filter api typecheck` reports no errors in `src/platform/db/schema/`.

---

## Phase 4 — SQL migrations

### PG-12 — Rewrite `0001`–`0003`

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 3 |

`drizzle/0001_platform.sql`, `0002_exercises.sql`, `0003_foods.sql`. Backticks → unquoted lowercase;
drop `ENGINE`/`CHARSET`/`COLLATE`; identity PKs; `TIMESTAMPTZ(3)`; `JSONB`; `DOUBLE PRECISION`;
hoist `CREATE TYPE … AS ENUM` to the top of `0001`; inline `KEY`/`UNIQUE KEY` → separate
`CREATE INDEX` / `CREATE UNIQUE INDEX` statements (4 of them for `sessions`).

### PG-13 — Rewrite `0004`–`0005`

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 2 |

`drizzle/0004_people.sql`, `0005_health_media_meta.sql`. Same conversions, plus:
`INSERT INTO membership_number_counters … ON DUPLICATE KEY UPDATE id = id` → `ON CONFLICT (id) DO
NOTHING`; `CHECK (max_clients_capacity >= 0)` and `CHECK (file_size >= 0)` to replace the lost
`UNSIGNED` semantics; delete the obsolete MariaDB fallback notes from both headers.

**Done when:** `db:migrate` builds all 17 tables on a clean database and `\d` output matches the
Drizzle schema.

### PG-14 — Rewrite `repeatable/grants.sql`

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | **High — a missing sequence grant breaks every insert** |
| **Files** | 1 |

Replace the 50-line MySQL stored procedure (cursor + `PREPARE`/`EXECUTE` + 1141/1147 handlers) with
declarative `GRANT`/`REVOKE`. Must include, in order: `GRANT USAGE ON SCHEMA public`;
`REVOKE ALL ON ALL TABLES`; `GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES`;
`REVOKE UPDATE, DELETE ON audit_logs` (NFR-003); **`GRANT USAGE, SELECT ON ALL SEQUENCES`**;
`ALTER DEFAULT PRIVILEGES` for tables and sequences, run as `DB_ADMIN_USER`.

**Done when:** the app user can insert into every table, cannot `UPDATE` or `DELETE` `audit_logs`,
and `test/settings.e2e.spec.ts:87–98` passes.

### PG-15 — Rewrite `migrate.ts` runner

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | Medium |
| **Files** | 2 |

`src/platform/db/migrate.ts` + `migrate.spec.ts`.

- `ensureMigrationsTable`: identity PK, `TIMESTAMPTZ(3)`, no `ENGINE`/`CHARSET`.
- Replace the `utf8mb4_0900_ai_ci` fail-fast guard (fix F-04) with a PostgreSQL equivalent:
  `server_version_num >= 150000`, `server_encoding = 'UTF8'`, plus any extension Decision 2 needs.
- **Delete `splitSqlStatements`** — its `DELIMITER` handling is MySQL client syntax and would
  mis-split `$$`-quoted bodies. Run each migration file as one multi-statement query inside an
  explicit transaction; PostgreSQL's transactional DDL then makes a failed migration atomic.
- Placeholders `?` → `$1`. Keep `requireSafeIdentifier` and the `${DB_USER}`/`${DB_NAME}`
  substitution for repeatable migrations.

**Done when:** `db:migrate` is idempotent across two consecutive runs, and a deliberately broken
migration file leaves the database unchanged.

### PG-16 — Regenerate journal + baseline snapshot

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 2 |

`drizzle/meta/_journal.json` (`"dialect": "postgresql"`) and `drizzle/meta/0000_snapshot.json`
regenerated from the ported schema, reduced to a single `0000_schema_baseline` entry.
`scripts/check-schema-drift.ts` needs no change.

**Done when:** `pnpm --filter api db:check` prints "Schema drift check passed".

### PG-17 — `0019` partial unique indexes (opportunity)

| | |
| :--- | :--- |
| **Status** | pending |
| **Priority** | Should-have — closes two unenforced correctness rules |
| **Files** | 2 |

ADR-0002's headline cost was that MySQL cannot express "at most one X per Y" as a partial unique
index. Two such rules are already in scope and **neither is currently enforced by the database**:

```sql
CREATE UNIQUE INDEX one_primary_contact_per_user
  ON emergency_contacts (user_id) WHERE is_primary;      -- FR-HEALTH-005
CREATE UNIQUE INDEX one_current_avatar_per_member
  ON member_photos (member_id) WHERE is_current_avatar;  -- BR-PEOPLE-004
```

Audit existing rows for violations **before** applying. Add matching Drizzle index declarations and
an E2E test asserting a second primary contact is rejected with 409.

**Done when:** both indexes exist, `db:check` is clean, and the concurrency rules are engine-enforced.

---

## Phase 5 — Repository layer

### PG-18 — `BaseRepository` — pg types, boolean, `RETURNING`

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | Medium — a live bug, not just a port |
| **Files** | 1 |

`src/platform/db/base.repository.ts`: `MySqlTable` → `PgTable`; **`getActiveCondition()` lines 48
and 51 compare `is_active` to the integer `1`**, which is invalid against a native `BOOLEAN` —
change to `eq(col, true)`. Make `create()` return `.returning({ id: table.id })`.

**Done when:** any `activeOnly` list endpoint returns rows, and `create()` yields the new id without
a driver-specific result shape.

### PG-19 — SQLSTATE error mapping

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | **High — silent 409 → 500 regression** |
| **Files** | 2 |

New `src/platform/db/pg-errors.ts` exporting `isUniqueViolation` (23505),
`isForeignKeyViolation` (23503), `isCheckViolation` (23514). Optionally map 23503/23514 in
`src/platform/errors/exception.filter.ts` so constraint failures surface as 4xx.

**Done when:** a duplicate-email create returns 409 with `CONFLICT`, not 500.

### PG-20 — `insertId` → `RETURNING` in 7 repositories

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 7 |

`auth/session.repository.ts:65`, `diet/food.repository.ts:80`, `work/exercise.repository.ts:91`,
`people/emergency-contact.repository.ts:52`, `people/member-health.repository.ts:36`,
`people/member-photo.repository.ts:48`, `people/member-document.repository.ts:68`.

Replace `Number(result?.[0]?.insertId ?? 0)` with `.returning({ id: table.id })` and read
`rows[0].id`.

**Done when:** every create endpoint returns a correct non-zero id.

### PG-21 — `PersonFactory` — raw SQL, result shape, dup detection

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | **Critical — the single most failure-prone file** |
| **Files** | 2 |

`src/people/person.factory.ts` + `person.factory.spec.ts`.

- Delete `insertIdFromResult` (lines 106–113); use `.returning({ id })` at lines 324, 357, 365, 373.
- Line 341: backticks are invalid — rewrite the `SELECT … FOR UPDATE` with unquoted identifiers.
  Keep the counter table (gap-free and rollback-safe; a `SEQUENCE` is neither, and membership
  numbers are member-facing).
- **Line 343 is the trap:** mysql2 returns `[rows, fields]`, `node-postgres` returns `{ rows }`.
  The existing `Array.isArray(locked) ? … : []` yields `[]` on PostgreSQL, making `nextValue` `NaN`
  and throwing "membership_number_counters is not initialized" on every member create.
- Lines 311 and 331: replace `/Duplicate|ER_DUP_ENTRY/i.test(message)` with `isUniqueViolation`.
- `person.factory.spec.ts:138` mocks `[{ insertId: id }]` → `[{ id }]`.

**Done when:** `POST /v1/members` returns `membership_number: "M00000001"` on a fresh database, and
consecutive creates increment without gaps.

### PG-22 — `like()` → `ilike()` in 5 repositories

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | **High — silent FR-API-014 regression; queries succeed but stop matching** |
| **Files** | 5 |

13 call sites: `work/exercise.repository.ts:41`, `diet/food.repository.ts:42`,
`people/member.repository.ts:63–67`, `people/employee.repository.ts:74–77`,
`people/trainer.repository.ts:37`.

**Done when:** `GET /v1/exercises?q=barbell` matches a seeded `"Barbell Squat"`.

### PG-23 — Health controller + JSON normalizer doc drift

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 3 |

`platform/health/health.controller.ts` — reword the MySQL references at lines 91 and 123 (they are
`@ApiProperty` / `@ApiOperation` text and land in the OpenAPI spec). `SELECT 1` is portable.
`platform/http/normalize-json-string-array.ts` — keep the defensive normalizer, update the
"MariaDB/mysql2" doc comment. Review `platform/http/normalize-json-string-array.spec.ts`.

---

## Phase 6 — Seeds

### PG-24 — `onDuplicateKeyUpdate` → `onConflictDoUpdate`

| | |
| :--- | :--- |
| **Status** | completed |
| **Risk** | Medium — one genuine semantic change, not just syntax |
| **Files** | 4 |

`src/platform/db/seed/roles.ts` (lines 204, 240), `permissions.ts` (145), `settings.ts` (56),
`admin.ts` (91, 150).

- `sql\`VALUES(\`col\`)\`` → `sql\`excluded.col\``.
- **PostgreSQL requires an explicit conflict target; MySQL matched any unique index.**
  `admin.ts:91` upserts `users`, which has two unique constraints (`email`, `phone_number`) —
  choose `target: users.email` and comment that a phone collision now raises instead of updating.
- `admin.ts:150` — `.onConflictDoNothing({ target: membershipNumberCounters.id })`.
- Preserve `SEED_RESET_PASSWORDS` behaviour (fix F-11): re-seeding must not clobber rotated hashes.

**Done when:** `pnpm --filter api seed` run twice in a row produces no error and no duplicate rows.

---

## Phase 7 — Tests

### PG-25 — Rename + rewrite E2E helper

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 1 |

`test/helpers/mysql.ts` → `test/helpers/postgres.ts`. Rewrite the five multi-table deletes in
`resetTestData()` (lines 44–83) from MySQL `DELETE alias FROM … INNER JOIN` to
`DELETE FROM … USING … WHERE`. Preserve the FK-safe ordering (children → profiles → sessions →
users) and the deliberate omission of `audit_logs` (the app user has no `DELETE` on it after F-03).
Update the three `onDuplicateKeyUpdate` calls at lines 146, 166, 186.

**Done when:** `resetTestData()` leaves seeded roles/permissions/settings intact and removes every
`e2e_%@luxeknox.test` row.

### PG-26 — Update 5 E2E specs + affected unit specs

| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 6 |

Import path updates in `auth.e2e.spec.ts:9`, `exercises.e2e.spec.ts:10`, `foods.e2e.spec.ts:10`,
`people-onboarding.e2e.spec.ts:9`, `settings.e2e.spec.ts:9`. Audit every `.execute()` result
unwrap for the `{ rows }` shape: `exercises.e2e.spec.ts:122`, `foods.e2e.spec.ts:119`,
`people-onboarding.e2e.spec.ts:242`, `settings.e2e.spec.ts:87,93,98`. Revisit the mysql2
JSON-auto-parse comment and assertion at `exercises.e2e.spec.ts:112`.

**Done when:** `pnpm --filter api test` and `test:e2e` are green against PostgreSQL.

### PG-27 — Add PostgreSQL-specific regression tests

| | |
| :--- | :--- |
| **Status** | completed |
| **Priority** | Must-have — these cover exactly what `typecheck` cannot |
| **Files** | 4 |

New or extended assertions for the runtime traps:

| Trap | Assertion |
| :--- | :--- |
| `int8` as string | `typeof body.id === 'number'`, `typeof page.total === 'number'` |
| `.execute()` shape | `POST /v1/members` returns `M00000001` |
| Sequence grants | full E2E suite runs as `DB_USER`, never the admin role |
| 23505 → 409 | duplicate-email create returns 409, not 500 |
| Boolean `is_active` | `activeOnly` list path through `BaseRepository` |
| FR-API-014 | `?q=barbell` matches `"Barbell Squat"` |
| Transactional rollback | forced mid-`PersonFactory.create` failure leaves no orphan `users` row |

**Done when:** each row above has a failing-before / passing-after test.

---

## Phase 8 — CI & deployment

### PG-28 — GitHub Actions service container

| | |
| :--- | :--- |
| **Status** | pending |
| **Files** | 1 |

`.github/workflows/api.yml`: `services.mysql` → `services.postgres` (`postgres:17`, `POSTGRES_*`,
`pg_isready` health command, port `5432`); update the six `DATABASE_URL` / `DB_*` job env vars;
point `DB_ADMIN_USER` at the superuser role. The nine-step sequence is unchanged.

**Done when:** CI is green end-to-end on a pull request.

### PG-29 — Deployment scripts + runbook

| | |
| :--- | :--- |
| **Status** | blocked (PG-28) |
| **Files** | 3 |

`deploy/README.md` — rewrite database prerequisites per PG-01, including backup/PITR ownership.
`deploy/deploy.sh` — logic is unchanged (it calls `db:migrate`); verify `SKIP_MIGRATE` still behaves
and that the pm2 environment carries the new `DATABASE_URL`. `deploy/ecosystem.config.js` — check
for hard-coded DB env.

**Done when:** a full `deploy.sh` run against a staging PostgreSQL succeeds.

---

## Phase 9 — Documentation

### PG-30 — Write ADR-0009

| | |
| :--- | :--- |
| **Status** | pending |
| **Files** | 1 |

`docs/adr/0009-postgresql-migration.md`. Must carry PG-01's hosting answer and state plainly what
it costs relative to ADR-0002's core argument; the gains (`TIMESTAMPTZ` turning the
highest-risk convention into a guarantee; partial unique indexes replacing generated columns for
all six "at most one" rules; `generate_series` removing the planned `calendar_dates` spine;
`PERCENTILE_CONT` for the attendance heat map; `JSONB`+GIN for the audit viewer; transactional DDL;
`pgcrypto` as an option alongside `FieldCrypto`); the losses (free case/accent-insensitive search —
the one place ADR-0002 called MySQL "straightforwardly better"; `pg_dump`/WAL replacing
`mysqldump`/binlog, so the NFR-004 restore drill must be re-scoped); and the conventions carried
over unchanged (`NUMERIC(12,2)` money, `row_version`, soft delete, append-only audit by grant,
Read Committed).

**Done when:** the ADR is `Accepted` and links back to ADR-0002.

### PG-31 — Supersede ADR-0002; update README + docs

| | |
| :--- | :--- |
| **Status** | blocked (PG-30) |
| **Files** | 5 |

`docs/adr/0002-*.md` → `Status: Superseded by ADR-0009` (leave the body — it is the best record of
the trade-offs). `README.md` — rewrite the "Database (MySQL 8.4 LTS)" section including the
verification snippet. `docs/project-context.md` §10, `docs/backend-frd.md` §26.2,
`docs/database-entities.md` (its `TIMESTAMPTZ`-style wording is now literal).

### PG-32 — Re-dump OpenAPI and verify parity

| | |
| :--- | :--- |
| **Status** | blocked (PG-23, PG-31) |
| **Files** | 2 |

`pnpm --filter api openapi:dump && openapi:check`. Only the health-endpoint descriptions from PG-23
should change; any schema diff means an unintended contract change.

**Done when:** `openapi:check` passes and the `v1.yaml` diff is description-only.

---

## Phase 10 — Data migration

> Skip Phase 10 entirely if production holds no data worth preserving. If it does, run it now —
> the schema is 17 tables today and will be ~55 after the `PAY` vertical.

### PG-33 — Extract + load production data

| | |
| :--- | :--- |
| **Status** | blocked (PG-32) |
| **Risk** | High |
| **Files** | 1 (`deploy/` migration script) |

`pgloader` (converts `TINYINT(1)`→`BOOLEAN`, `DATETIME`→`TIMESTAMPTZ`, `JSON`→`JSONB` in one pass)
or per-table CSV. Load order: reference tables (`roles`, `permissions`, `role_permissions`,
`gym_settings`) → `users` → profiles → child tables. Run **before** `grants.sql` — the app user
cannot bulk-insert into `audit_logs` under append-only grants.

### PG-34 — Reset identity sequences + membership counter

| | |
| :--- | :--- |
| **Status** | blocked (PG-33) |
| **Risk** | **High — the classic post-load failure** |
| **Files** | 1 |

A bulk load with explicit ids leaves every sequence at 1; the first application insert then fails
with a duplicate key. For each identity table:
`SELECT setval(pg_get_serial_sequence('<t>','id'), (SELECT max(id) FROM <t>));`
Also set `membership_number_counters.next_value` to `max(membership_number) + 1`.

**Done when:** an insert into every table succeeds against the loaded data.

### PG-35 — Validate migrated data

| | |
| :--- | :--- |
| **Status** | blocked (PG-34) |
| **Files** | 1 |

Per-table row counts vs MySQL; `audit_logs` count and `max(created_at)`; a UTC round-trip
spot-check on a known instant; `JSONB` spot-check on `specializations` / `secondary_muscles`;
`NUMERIC` spot-check on `hourly_rate`; a login + member-create smoke test against real data.

### PG-36 — Production cutover

| | |
| :--- | :--- |
| **Status** | blocked (PG-35) |
| **Risk** | **Critical — no live rollback path** |
| **Files** | 0 |

Write-freeze → final delta load → PG-34 → apply `grants.sql` → repoint `DATABASE_URL` →
`pm2 reload` → smoke test. Keep MySQL running **read-only** for one full backup cycle.

**Rollback:** restore the pre-cutover MySQL backup and repoint. Any writes taken on PostgreSQL after
cutover are lost — which is why the window must be a write-freeze, not a dual-write.

---

## Phase 11 — Follow-ups (deferred)

### PG-37 — `pg_trgm` / `unaccent` search indexes for FR-API-014

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | PG-36 |

`ILIKE '%…%'` (PG-22) restores case-insensitivity but not accent-insensitivity, and is a sequential
scan — as MySQL's `LIKE` was. Add `unaccent` + GIN trigram indexes on the searchable columns when
FR-API-014 is formally re-verified.

### PG-38 — Remaining four "at most one" partial unique indexes

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | the owning verticals |

FR-HEALTH-001 (current health row), FR-WORK-006 (active assigned plan), FR-WORK-014 (in-progress
session), FR-DIET-004 (active diet plan). One `CREATE UNIQUE INDEX … WHERE` each. Record in ADR-0009
that partial unique indexes are now the normative pattern, replacing ADR-0002's stored-generated-column
workaround — and that these rules are still never implemented in the service layer.

### PG-39 — NFR-004 PITR restore drill on PostgreSQL

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | PG-36 |

ADR-0002 made a restore drill part of the `PAY` vertical's definition of done. The mechanism changed
from binlog replay to WAL archiving, so the drill must be redesigned and actually executed —
an untested PITR setup satisfies nothing.

---

## Phase 12 — Post-merge port

`origin/main` landed the MEMB, SCHED, ATTN, WORK, DIET, GOAL, NOTIF, PAY and JOB verticals against
MySQL while this branch was porting to PostgreSQL. Merge commit `cbcea77` kept the PostgreSQL side of
every conflict and took main's additions, but the new files arrived **unported**, so the tree does
not compile until this phase lands. Everything below is mechanical application of Decisions 1–5
(ADR-0009) and the PG-18/20/22/24 patterns.

Renumbering: main used migration numbers `0006`–`0018`, so PG-17's partial-unique-index migration
moves from `0006` to `0019` (PG-47).

### PG-40 — Port schema files, batch A
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 6 |

`memberships.ts`, `payments.ts`, `password-reset-tokens.ts`, `medical-histories.ts`, `job-runs.ts`,
`idempotency.ts`. `mysqlTable` → `pgTable`; `bigint(unsigned).autoincrement()` →
`.generatedAlwaysAsIdentity()`; `int` → `integer`; `decimal` → `numeric`; `json` → `jsonb`;
`double` → `doublePrecision`; `mysqlEnum` → module-scope `pgEnum`.

### PG-41 — Port schema files, batch B
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 6 |

`attendance.ts`, `scheduling.ts` (`tinyint` → `smallint` + `CHECK`), `workout.ts`, `diet.ts`,
`goals.ts`, `notifications.ts` (3 enums). Same conversions as PG-40. Where `unsigned` carried meaning
(counts, quantities) add a `CHECK (col >= 0)` per Decision 5.

### PG-42 — Rewrite migrations `0006`–`0011`
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 6 |

`0006_memberships`, `0007_job_runs`, `0008_scheduling`, `0009_schedule_calendar_index` (empty),
`0010_attendance`, `0011_workout`. Same conversion rules as PG-12/13.

### PG-43 — Rewrite migrations `0012`–`0018`
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 8 |

`0012_diet`, `0012_idempotency`, `0013_goals`, `0014_notifications`, `0015_payments`,
`0016_receipt_counters`, `0017_password_reset_tokens`, `0018_medical_histories`. Note the duplicate
`0012_` prefix — keep the ordering main established (`diet` before `idempotency`). Counter-table seed
inserts use `ON CONFLICT (id) DO NOTHING`.

### PG-44 — `insertId` → `RETURNING` in main's repositories
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | ~16, in 3 batches |

`notification`, `job-run`, `workout-plan`, `workout-session`, `goal`, `measurement`, `attendance`,
`device-credential.service`, `diet-plan`, `payment`, `payment-method`, `membership-product`,
`membership`, `facility`, `schedule`, `schedule-type`, `medical-history`. Note main's
`Number(result?.[0]?.insertId ?? result?.insertId ?? 0)` variants and the insert-then-reselect
patterns that key off `insertId`.

### PG-45 — `onDuplicateKeyUpdate` → `onConflictDoUpdate`
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 5 |

`notification.repository.ts:241`, `attendance.repository.ts:284`, `settings.repository.ts:39`,
`diet-log.repository.ts:77`, `seed/notification-types.ts:70`. Explicit conflict target required;
`VALUES(col)` → `excluded.col`.

### PG-46 — Raw SQL
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 7 |

`payment.repository.ts` (invoice/receipt counters — backticks, and the `{ rows }` result shape trap
from PG-21), `schedule.repository.ts:203` (`FOR UPDATE`), `reports.repository.ts:162`
(`DATEDIFF(a,b)` → `(a - b)`), and `like` → `ilike` in `workout-plan`, `goal-metric`, `diet-plan`,
`membership-product`, `employee` repositories.

### PG-47 — Journal + snapshot reconciliation
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 4 |

The merged `_journal.json` mixes dialects and main's `0007`–`0010` snapshots are MySQL. Regenerate a
single PostgreSQL baseline snapshot for the full 30-ish table schema (superseding PG-16's), delete
main's MySQL snapshots, and reduce the journal accordingly. Rename PG-17's planned file to
`0019_partial_unique_indexes.sql` and update the comment in `members.ts`.

**Done when:** `pnpm --filter api db:check` passes.

### PG-48 — Grants, E2E reset list, and tests
| | |
| :--- | :--- |
| **Status** | completed |
| **Files** | 4 |

`resetTestData()` in `test/helpers/postgres.ts` must delete the new tables in FK-safe order. Check
`grants.sql` covers new tables/sequences and any `audit_logs`-style append-only tables. Fix mysql2
result-shape assumptions in main's new specs.

**Done when:** `pnpm --filter api test` and `test:e2e` are green.

### Phase 12 outcome

Ported and verified against PostgreSQL 17 (scratch database, since dropped):

- All 13 new migrations apply cleanly; column and index sets match what `drizzle-kit generate`
  produces from the TypeScript schema (one gap found and fixed: `password_reset_tokens_user_id_idx`
  existed in SQL but not in the schema).
- The three MySQL generated-column + `UNIQUE KEY` workarounds (`workout_plans`, `diet_plans`,
  `workout_sessions`) became **partial unique indexes** — this closes PG-38 for FR-WORK-006,
  FR-WORK-014 and FR-DIET-004. Only FR-HEALTH-001 remains, plus PG-17's two.
- Runtime traps beyond `insertId` that `tsc` could not see (`any`-typed): `affectedRows` →
  `rowCount` in the notification, workout-plan and diet-plan repositories (the optimistic
  `row_version` check and device delete were broken), and `[rows, fields]` unwrapping in the
  payment counters and schedule lock.
- Four goal services used `repository.create()` as if it returned the entity; under MySQL it
  returned an insert header, so those audit rows would have had `entityId: undefined`. They now
  read the id from `RETURNING` and re-fetch.
- `resetTestData()` now walks the catalogue's FK graph instead of a hand-maintained delete list.
- `booking-concurrency` relied on user ids coinciding with member ids; fixed.
- `pnpm test`: 528/528. `db:check`: passes. `test:e2e`: 52/52, three consecutive runs.

**Stale e2e specs fixed (they were wrong against main's code, not port bugs):**
`settings` expected an unwrapped body but `GET /v1/settings` returns `{ data }`;
`people-onboarding` photo test used a non-existent `member_photo` purpose, the wrong body field
(`photo_url`, not `file_url`), and `is_current_avatar` via `POST …/avatar`; its terminate test also
used mysql2's `[rows]` result shape; `notification-delivery` needed a `members` row for `e2e_member`.
Two controllers returned 201 where their own `@ApiResponse` documents 200 (`POST /notifications/:id/read`,
`POST /members/:id/photos/:photoId/avatar`); both now have `@HttpCode(200)`. `exercises` e2e now
deletes its rows in `afterAll` (leftovers pushed new rows off the first page, causing flaky failures).
Remaining: one pre-existing type error in `memb/membership-integration.spec.ts`.
