# Implementation Plan: Migrate LuxeKnox from MySQL 8.4 to PostgreSQL

Migrate the `apps/api` persistence layer from MySQL 8.4 / `mysql2` / `drizzle-orm/mysql-core` to
PostgreSQL 17 / `pg` / `drizzle-orm/pg-core`, across the Drizzle schema, connection layer,
repositories, seeds, hand-authored SQL migrations, grant model, E2E harness, CI, Docker Compose,
deployment, and the ADR record.

**Scope:** `apps/api` only, plus root-level infra (`docker-compose.yml`, `.env.example`, CI,
`deploy/`) and `docs/`. The Flutter client in `app/` requires **no changes** — it consumes the REST
contract, and the contract (numeric ids, ISO-8601 UTC strings, `Money` as decimal string) is
preserved by this migration.

---

## User Review Required

> [!IMPORTANT]
> This migration reverses [ADR-0002](./docs/adr/0002-database-engine-and-data-access.md), which
> selected MySQL 8.4 *specifically because* "it is the database the deployment target hands us"
> (Hostinger provisions MySQL + phpMyAdmin natively). **Nothing in this plan solves that.** Before
> engineering work starts, the team must settle where production PostgreSQL will live and who
> operates it — see *Decision 0* below. Every other item here is tractable; that one is not a code
> problem.

- **Breaking changes:** Database engine and all persisted data. The HTTP API surface
  (`docs/openapi/v1.yaml`) is unchanged — no client impact.
- **Behavioural changes visible to users:** search case/accent sensitivity (§5), unless the
  mitigation in Decision 2 is implemented.
- **Rollback strategy:** Do the work on a branch. The MySQL stack remains fully functional on
  `main` until cutover. Post-cutover rollback requires a restore from the pre-cutover MySQL
  backup plus replay of any writes taken on PostgreSQL — so the cutover window must be a
  write-freeze, not a live dual-write.

---

## Decisions required before implementation

### Decision 0 — Production hosting (blocking)

ADR-0002's central argument was operational: a managed, backed-up MySQL with no database server to
run. PostgreSQL removes that. Pick one, and record it in the new ADR:

| Option | Consequence |
| :--- | :--- |
| Managed PostgreSQL (Neon / Supabase / RDS / DigitalOcean) | Keeps NFR-004 (PITR) as a provider feature. Adds a vendor + monthly cost. Recommended. |
| Self-hosted PostgreSQL on the existing VPS | No new vendor. The team now owns backups, WAL archiving, PITR drills, upgrades, and tuning — exactly the cost ADR-0002 set out to avoid. |
| Hostinger-provided PostgreSQL, if offered on the current plan | Preserves the ADR-0002 argument. Verify PITR/WAL retention is actually available, not just nightly dumps — NFR-004 needs point-in-time. |

**Recommendation: managed PostgreSQL.** NFR-004 requires point-in-time recovery for the ledger, and
a self-operated PITR setup that is never restore-tested is worth nothing.

### Decision 1 — `TIMESTAMPTZ` vs `TIMESTAMP` for the UTC rule

ADR-0002 names the absence of an engine-enforced time zone "the highest-risk convention in this
schema" and mitigates it with the `utcDatetime()` helper, a pinned pool `time_zone`, a lint rule,
and a round-trip test. PostgreSQL removes the risk at the engine level.

**Recommendation: `timestamp(3) with time zone` (`TIMESTAMPTZ`).** The helper
`src/platform/db/utc-datetime.ts` stays as the single point of definition, so the lint rule and
round-trip test keep their target. This converts a convention into a guarantee and is the single
largest correctness gain of the migration.

### Decision 2 — Replacing `utf8mb4_0900_ai_ci` (case- **and** accent-insensitive)

MySQL's default collation satisfies FR-API-014 for free. PostgreSQL is case- and accent-sensitive by
default. The 13 `like()` calls in §5 and the `users.email` / `users.phone_number` unique indexes all
depend on the MySQL behaviour. Three mechanisms, and they are not interchangeable:

| Mechanism | Gives | Costs |
| :--- | :--- | :--- |
| `ILIKE` | Case-insensitive pattern match | **Not** accent-insensitive. One-word change per call site. |
| ICU nondeterministic collation (`provider=icu, locale='und-u-ks-level1', deterministic=false`) | Case- + accent-insensitive equality *and* unique indexes — the true `ai_ci` equivalent | **Pattern matching (`LIKE`/`ILIKE`) is rejected on columns with a nondeterministic collation.** Cannot be used on the search columns. |
| `unaccent` + `lower()` functional index, queried with `ILIKE unaccent($1)` | Case- + accent-insensitive search, index-backed | Needs the `unaccent` extension and an expression index per searchable column. |

**Recommendation, split by purpose:**

- **Search columns** (`exercises.name`, `foods.name`, `members.first_name` / `last_name` /
  `membership_number`, `users.email`, `users.phone_number`, `employees.*`, `trainers.*`):
  switch `like()` → `ilike()` now (Task 12), which restores case-insensitivity and is a
  like-for-like behaviour match for the ASCII data the system actually holds. Add
  `unaccent` + trigram (`pg_trgm` GIN) indexes as a follow-up when FR-API-014 is formally
  re-verified — `ILIKE '%…%'` is a sequential scan without them, and MySQL was no better here.
- **`users.email` uniqueness:** the app already stores lowercase via `normalizeEmail()`
  (`src/people/credentials.ts`), so a plain unique index is equivalent for case. Add a
  `CHECK (email = lower(email))` constraint so the invariant is engine-enforced rather than
  assumed. Do **not** reach for `citext` — it is deprecated in favour of nondeterministic
  collations, and the normalization already exists.

Record whichever is chosen in the new ADR; FR-API-014 is a requirement, and this migration changes
how it is met.

### Decision 3 — `pgEnum` vs `VARCHAR` + `CHECK`

Five enum columns across four distinct types: `user_type` (shared by `users` and `sessions`),
`users.status`, `employees.status`, `member_documents.document_type`.

**Recommendation: `pgEnum`.** These four sets are stable and defined as `as const` tuples in the
schema already, so Drizzle's inferred types carry over unchanged. Note for the migration-review
checklist: `ALTER TYPE … ADD VALUE` cannot be used later in the same transaction that references
the new value, and values cannot be removed. If a future enum is expected to churn, use
`VARCHAR` + `CHECK` for that one.

### Decision 4 — `int8` (BIGINT) returned as string

`node-postgres` returns `int8` (OID 20) as a **string** to avoid silent precision loss. Every
primary key, foreign key, and `count()` in this schema is `BIGINT`. Drizzle's
`bigint({ mode: 'number' })` casts on typed selects, but **raw `db.execute()` results and some
aggregate paths bypass it** — and `Number(result?.[0]?.insertId ?? 0)` style coercions disappear
with `insertId` (§4).

**Recommendation:** register `pg.types.setTypeParser(20, Number)` once in
`src/platform/db/client.ts`, with a comment stating the bound (ids are nowhere near
`Number.MAX_SAFE_INTEGER` = 2^53). Leave `numeric` (OID 1700) as a string — `trainers.hourly_rate`
is `Money` and must never become a float (FR-API-005).

### Decision 5 — `BIGINT UNSIGNED` has no PostgreSQL equivalent

All 17 tables use `BIGINT UNSIGNED AUTO_INCREMENT`. PostgreSQL has no unsigned integers.

**Recommendation:** `BIGINT GENERATED ALWAYS AS IDENTITY` (SQL-standard, preferred over `bigserial`)
for surrogate keys; plain `BIGINT` for FK columns. The usable range halves to 2^63, which is
irrelevant. Where unsignedness was carrying a domain meaning — `member_documents.file_size`,
`trainers.max_clients_capacity` — add an explicit `CHECK (col >= 0)`, since the engine no longer
provides it.

---

## Current state — what the migration has to touch

| Area | Location | Size |
| :--- | :--- | :--- |
| Drizzle schema | `apps/api/src/platform/db/schema/` | 14 table files + `index.ts`, 17 tables |
| Hand-authored SQL migrations | `apps/api/drizzle/000{1..5}_*.sql` | 271 lines |
| Repeatable grants | `apps/api/drizzle/repeatable/grants.sql` | 50 lines, MySQL stored procedure |
| Migration runner | `apps/api/src/platform/db/migrate.ts` | 195 lines |
| Connection / pool | `apps/api/src/platform/db/client.ts` | 92 lines |
| Transaction context | `apps/api/src/platform/db/transaction-context.ts` | MySQL type imports |
| Base repository | `apps/api/src/platform/db/base.repository.ts` | MySQL types + `is_active = 1` |
| Repositories with `insertId` | 7 repositories + `person.factory.ts` | 12 call sites |
| Upserts (`onDuplicateKeyUpdate`) | 4 seed files + `test/helpers/mysql.ts` | 9 call sites |
| Case-insensitive search (`like()`) | 5 repositories | 13 call sites |
| Raw SQL | `person.factory.ts:341`, `health.controller.ts:66`, `test/helpers/mysql.ts` | MySQL-only syntax |
| E2E harness | `apps/api/test/helpers/mysql.ts` + 5 spec files | multi-table `DELETE … JOIN` |
| Infra | `docker-compose.yml`, `apps/api/docker/mysql.cnf`, `.env.example`, `.github/workflows/api.yml` | |
| Docs | `docs/adr/0002-*.md`, `README.md`, `docs/project-context.md`, `docs/backend-frd.md` §26.2 | |

Type mapping across the 17 tables:

| MySQL | PostgreSQL | Count |
| :--- | :--- | :--- |
| `BIGINT UNSIGNED AUTO_INCREMENT` | `BIGINT GENERATED ALWAYS AS IDENTITY` | 16 PKs (+ `membership_number_counters.id`, non-identity) |
| `DATETIME(3)` | `TIMESTAMPTZ(3)` | ~40 columns |
| `JSON` | `JSONB` | 4 (`audit_logs.before_state`/`after_state`, `exercises.secondary_muscles`, `trainers.specializations`) |
| `DOUBLE` | `DOUBLE PRECISION` | 9 |
| `DECIMAL(12,2)` | `NUMERIC(12,2)` | 1 (`trainers.hourly_rate`) |
| `BOOLEAN` (= `TINYINT(1)`) | native `BOOLEAN` | 7 |
| `ENUM(...)` inline | `CREATE TYPE … AS ENUM` | 5 columns / 4 types |
| `TEXT`, `VARCHAR(n)`, `DATE` | unchanged | — |

---

## Proposed Changes

### 1. Infrastructure and configuration

#### [MODIFY] `docker-compose.yml`
- Replace the `mysql:8.4` service with `postgres:17-alpine`, container `luxeknox-postgres`.
- `POSTGRES_DB: luxeknox`, `POSTGRES_USER: luxeknox`, `POSTGRES_PASSWORD: luxeknox_secret`.
  There is no separate root account in the Postgres image — `POSTGRES_USER` **is** the superuser.
  See Task 3 for how `DB_USER` / `DB_ADMIN_USER` separation is reconstructed.
- Port `5432:5432`; volume `postgres_data:/var/lib/postgresql/data`.
- Healthcheck `pg_isready -U luxeknox -d luxeknox` in place of `mysqladmin ping`.
- Mount `./apps/api/docker/postgres.conf` and start with `-c config_file=…`, or drop the file
  and pass `-c` flags directly.

#### [DELETE] `apps/api/docker/mysql.cnf` → [CREATE] `apps/api/docker/postgres.conf`
The MySQL file set five things. Their PostgreSQL status:

| MySQL setting | PostgreSQL |
| :--- | :--- |
| `default-time-zone = '+00:00'` | `timezone = 'UTC'` — and with `TIMESTAMPTZ` (Decision 1) storage is offset-correct regardless |
| `transaction-isolation = READ-COMMITTED` | Already the default. Set `default_transaction_isolation = 'read committed'` explicitly to keep the intent documented |
| `character-set-server = utf8mb4` | `ENCODING 'UTF8'` at `initdb`; no server setting |
| `collation-server = utf8mb4_0900_ai_ci` | **No equivalent** — see Decision 2 |
| `binlog_format = ROW`, `log_bin = ON` | `wal_level = replica` (default) + WAL archiving for PITR (NFR-004) |

#### [MODIFY] `.env.example`
- `DATABASE_URL=postgres://luxeknox:luxeknox_secret@localhost:5432/luxeknox`
- `DB_PORT=5432`.
- Keep the `DB_USER` / `DB_ADMIN_USER` split and its comments — the least-privilege model
  (ADR-0002 "Immutability", fix F-03) survives the migration intact and is *simpler* in PostgreSQL.
- Update the comment "Connection pool enforces `time_zone='+00:00'`" to reference `TIMESTAMPTZ`.

#### [MODIFY] `.github/workflows/api.yml`
- `services.mysql` → `services.postgres`, image `postgres:17`, `POSTGRES_*` env,
  `--health-cmd="pg_isready -U luxeknox"`, port `5432:5432`.
- Update the six `DATABASE_URL` / `DB_*` job env vars.
- `DB_ADMIN_USER` / `DB_ADMIN_PASSWORD` point at the Postgres superuser (`luxeknox` in the
  container, or a dedicated `luxeknox_admin` role created by Task 3).
- The step sequence (lint → typecheck → `db:check` → `db:migrate` → `seed` → test → e2e →
  `openapi:dump` → `openapi:check`) is unchanged.

#### [MODIFY] `deploy/README.md`, `deploy/deploy.sh`
- `deploy.sh` calls `pnpm --filter api db:migrate` and needs no logic change, but the README's
  database prerequisites must be rewritten per Decision 0.

### 2. Dependencies and Drizzle configuration

#### [MODIFY] `apps/api/package.json`
- Remove `mysql2`. Add `pg` and `@types/pg`.
- `drizzle-orm` and `drizzle-kit` versions stay; both dialects ship in the same package.

#### [MODIFY] `apps/api/drizzle.config.ts`
- `dialect: 'mysql'` → `'postgresql'`; default port `3306` → `5432`.
- The local `DrizzleConfig` interface's `dialect: 'mysql'` literal type must widen.

### 3. Connection layer

#### [MODIFY] `apps/api/src/platform/db/client.ts`
- `createPool` from `mysql2/promise` → `Pool` from `pg`; `drizzle` from
  `drizzle-orm/node-postgres`; `MySql2Database` → `NodePgDatabase`.
- `createConnectionPool`: `uri` → `connectionString`; `connectionLimit` → `max`;
  drop `waitForConnections` / `queueLimit` / `dateStrings`.
- `timezone: '+00:00'` → a `pool.on('connect', c => c.query("SET TIME ZONE 'UTC'"))` handler, or
  `options: '-c timezone=UTC'`. Keep it even with `TIMESTAMPTZ` so `now()`-rendered output and any
  future `TIMESTAMP` column stay UTC.
- Add the `pg.types.setTypeParser(20, Number)` registration from Decision 4, module-level and
  documented.
- `createDrizzleClient`: drop `mode: 'default'` — it is MySQL-only.
- `createAdminConnectionPool` keeps its shape and its "never falls back to the app user" guarantee.

#### [MODIFY] `apps/api/src/platform/db/drizzle.module.ts`
- `import type { Pool } from 'mysql2/promise'` → `from 'pg'`. No structural change; `@Global()`
  module, both provider tokens, and `forRoot(options)` are dialect-agnostic.

#### [MODIFY] `apps/api/src/platform/db/transaction-context.ts`
- `MySqlTransaction` → `PgTransaction` in the `AnyTransaction` alias.
- `runInTransaction` semantics are unchanged: ambient-join via `AsyncLocalStorage`, commit on
  resolve, rollback on throw. PostgreSQL's default isolation is already Read Committed.

#### [MODIFY] `apps/api/src/platform/db/utc-datetime.ts` + `utc-datetime.spec.ts`
- `datetime(name, { fsp: 3, mode: 'date' })` → `timestamp(name, { precision: 3, withTimezone: true, mode: 'date' })`.
- Return type `MySqlDateTimeBuilderInitial` → the `pg-core` equivalent.
- The spec asserts column metadata; update expectations and keep the UTC round-trip assertion —
  it is the regression test for the highest-risk convention in ADR-0002.

### 4. Schema files — `apps/api/src/platform/db/schema/` (14 files)

Mechanical per-file conversion against the type table above:

- `mysqlTable` → `pgTable`; `mysqlEnum` → module-scope `pgEnum` declarations.
- `bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement()`
  → `bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity()`.
- FK columns: drop `unsigned: true`, keep `{ mode: 'number' }` and `.references(...)`.
- `json(...)` → `jsonb(...)`, preserving `.$type<string[]>()`.
- `double(...)` → `doublePrecision(...)`; `decimal('hourly_rate', { precision: 12, scale: 2 })`
  → `numeric(...)` (still a string in TS — `Money` is safe).
- `boolean(...)` and `date(..., { mode: 'string' })` keep their names.
- `index()` / `uniqueIndex()` keep the same builder API in `pg-core`.
- `membershipNumberCounters.id` stays a non-identity `BIGINT` primary key seeded to `1`.

`index.ts` re-exports need no change. `USER_TYPES` / `USER_STATUSES` / `EMPLOYEE_STATUSES` /
`DOCUMENT_TYPES` `as const` tuples become the `pgEnum` inputs, so every downstream
`typeof table.$inferSelect` type is preserved.

### 5. Repository and service layer

#### [MODIFY] `apps/api/src/platform/db/base.repository.ts`
- `MySqlTable, TableConfig` → `PgTable, TableConfig` from `drizzle-orm/pg-core`.
- **`getActiveCondition()` (lines 48, 51) compares `is_active` to the integer `1`.** Against a
  native PostgreSQL `BOOLEAN` this is a type error at query time, not a silent mismatch. Change to
  `eq(col, true)`. The repositories that build their own conditions already use `true`
  (`exercise.repository.ts:37`), so only the base class is wrong.
- `create()` should return `.returning({ id: table.id })` so callers stop reaching for `insertId`.

#### [MODIFY] 8 files — replace `insertId` with `RETURNING`
MySQL's `insertId` does not exist in PostgreSQL; the equivalent is `INSERT … RETURNING id`.

| File | Line(s) |
| :--- | :--- |
| `src/auth/session.repository.ts` | 65 |
| `src/diet/food.repository.ts` | 80 |
| `src/work/exercise.repository.ts` | 91 |
| `src/people/emergency-contact.repository.ts` | 52 |
| `src/people/member-health.repository.ts` | 36 |
| `src/people/member-photo.repository.ts` | 48 |
| `src/people/member-document.repository.ts` | 68 |
| `src/people/person.factory.ts` | 107–113 (`insertIdFromResult`), 324, 357, 365, 373 |

Delete `insertIdFromResult` outright rather than porting it — `.returning({ id })[0].id` is
unambiguous, whereas the helper exists only to paper over mysql2's result shape.
`src/people/person.factory.spec.ts:138` mocks `[{ insertId: id }]` and must return `[{ id }]`.

#### [CREATE] `apps/api/src/platform/db/pg-errors.ts`
`person.factory.ts:311` and `:331` detect duplicate keys with `/Duplicate|ER_DUP_ENTRY/i.test(message)`
— a MySQL message-text match that will silently never fire on PostgreSQL, turning a 409 Conflict
into a 500. Replace with SQLSTATE inspection:

```ts
export function isUniqueViolation(err: unknown): boolean   // 23505
export function isForeignKeyViolation(err: unknown): boolean // 23503
export function isCheckViolation(err: unknown): boolean      // 23514
```

Use `isUniqueViolation` at both `person.factory.ts` sites. Consider mapping 23503/23514 centrally in
`src/platform/errors/exception.filter.ts` so FK and CHECK failures surface as 4xx rather than 500.

#### [MODIFY] `apps/api/src/people/person.factory.ts` — `allocateMembershipNumber` (line 338)
```sql
SELECT `next_value` AS next_value FROM `membership_number_counters` WHERE `id` = 1 FOR UPDATE
```
Backticks are invalid in PostgreSQL. `SELECT … FOR UPDATE` itself is identical, so keep the counter
pattern (it is rollback-safe and gap-free, which a `SEQUENCE` is not — membership numbers are
member-facing). Two changes:
- Backticks → unquoted lowercase identifiers.
- **Result unwrapping (line 343).** mysql2 returns `[rows, fields]`; `node-postgres` returns
  `{ rows, rowCount, … }`. The defensive `Array.isArray(locked) ? … : []` returns `[]` against a
  PostgreSQL result, so `nextValue` becomes `NaN` and every member creation throws
  "membership_number_counters is not initialized". **This is the highest-risk single line in the
  migration** — it fails closed, loudly, but only on the member-onboarding path.

Audit every `.execute()` call site for this same result-shape assumption:
`person.factory.ts:340`, `health.controller.ts:66`, `test/helpers/mysql.ts` (8 sites),
`test/exercises.e2e.spec.ts:122`, `test/foods.e2e.spec.ts:119`,
`test/people-onboarding.e2e.spec.ts:242`, `test/settings.e2e.spec.ts:87,93,98`.

#### [MODIFY] 5 repositories — `like()` → `ilike()` (13 call sites, per Decision 2)
`exercise.repository.ts:41`, `food.repository.ts:42`,
`member.repository.ts:63–67`, `employee.repository.ts:74–77`, `trainer.repository.ts:37`.

Without this, FR-API-014 regresses silently: queries still succeed, they just stop matching.

#### [MODIFY] `apps/api/src/platform/health/health.controller.ts`
- `SELECT 1` is portable; only the `ReadyResponseDto` `@ApiProperty` description ("MySQL database
  connectivity status", line 91) and the `@ApiOperation` text (line 123) need rewording. These
  strings land in `docs/openapi/v1.yaml`, so `openapi:dump` + `openapi:check` must be re-run.

#### [REVIEW] `apps/api/src/platform/http/normalize-json-string-array.ts`
Written to coerce "MariaDB/mysql2 JSON-or-TEXT" values. `JSONB` always round-trips as a parsed
array, so the string branches become dead code. Keep the function as a defensive normalizer (it is
covered by tests and costs nothing), but update the doc comment — it currently documents an engine
the project no longer targets. `test/exercises.e2e.spec.ts:112` asserts on mysql2 JSON auto-parsing
and needs its comment and expectation reviewed.

#### [NO CHANGE] verified dialect-agnostic
`src/platform/money/money.ts` (string/BigInt arithmetic), `src/platform/http/pagination.ts`
(base64url cursors over `{createdAt, id}`), `src/platform/concurrency/row-version.ts`,
`src/platform/audit/audit.service.ts` (plain insert), `src/media/storage.service.ts` (filesystem),
`src/auth/token.ts`, `src/auth/session.cache.ts`, `src/rbac/*`. `count()` from `drizzle-orm` works
on both dialects once Decision 4's type parser is registered.

### 6. Seeds and upserts (9 call sites)

`ON DUPLICATE KEY UPDATE` → `ON CONFLICT (target) DO UPDATE SET`. Two differences matter:

- **`VALUES(col)` → `excluded.col`.** Affects `seed/permissions.ts:147–149`,
  `seed/settings.ts:58–59`, `seed/roles.ts:206–207,242`.
- **PostgreSQL requires an explicit conflict target; MySQL matches *any* unique index.**
  `seed/admin.ts:91` upserts into `users`, which has two unique constraints (`email`,
  `phone_number`). Pick `target: users.email` — every seeded user has one — and state in a comment
  that a phone-number collision will now raise rather than update. This is a genuine semantic
  change, not a syntax port.
- `seed/admin.ts:150` — `.onDuplicateKeyUpdate({ set: { id: 1 } })` on
  `membership_number_counters` is a no-op upsert; express it as
  `.onConflictDoNothing({ target: membershipNumberCounters.id })`.
- `test/helpers/mysql.ts:146,166,186` — same treatment.

`seed/index.ts` ordering (roles → permissions → role_permissions → settings → admin) is unchanged.

### 7. Hand-authored SQL migrations

#### [REWRITE] `apps/api/drizzle/0001_platform.sql` … `0005_health_media_meta.sql`
Per file: backticks → double quotes or unquoted (all identifiers are already lowercase snake_case,
so unquoted is cleanest); drop every `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=…` clause;
`BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY` → `BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY`;
`DATETIME(3)` → `TIMESTAMPTZ(3)`; `JSON` → `JSONB`; `DOUBLE` → `DOUBLE PRECISION`;
`ENUM(...)` inline → `CREATE TYPE … AS ENUM (...)` hoisted to the top of `0001`; inline
`KEY x (…)` / `UNIQUE KEY x (…)` → separate `CREATE INDEX` / `CREATE UNIQUE INDEX` statements
(PostgreSQL has no inline non-constraint index syntax).

Per-file specifics:
- `0001_platform.sql` — declare the three enum types (`user_type`, `user_status`) first. The
  `sessions` table's four `INDEX` clauses become four `CREATE INDEX` statements.
- `0004_people.sql` — `INSERT INTO membership_number_counters … ON DUPLICATE KEY UPDATE id = id`
  → `… ON CONFLICT (id) DO NOTHING`. Add `CHECK (max_clients_capacity >= 0)` (Decision 5).
- `0005_health_media_meta.sql` — `document_type` enum type; `CHECK (file_size >= 0)`.
- The MariaDB fallback notes in the `0004` / `0005` headers are obsolete — delete them.

**Opportunity worth taking now:** ADR-0002's "cost, stated up front" was that MySQL has no partial
unique indexes, forcing six "at most one X per Y" rules through stored generated columns. Two of the
six are already in scope — `emergency_contacts.is_primary` (FR-HEALTH-005) and
`member_photos.is_current_avatar` (BR-PEOPLE-004) — and **neither is currently enforced by the
database at all**. On PostgreSQL each is one line:

```sql
CREATE UNIQUE INDEX one_primary_contact_per_user
  ON emergency_contacts (user_id) WHERE is_primary;
CREATE UNIQUE INDEX one_current_avatar_per_member
  ON member_photos (member_id) WHERE is_current_avatar;
```

Add these in a new `0006_partial_unique_indexes.sql` **only after** auditing existing rows for
violations. `member_health.member_id` and `members.user_id` are already plain unique constraints and
need no change.

#### [REWRITE] `apps/api/drizzle/repeatable/grants.sql`
The 50-line MySQL stored procedure — cursor over `information_schema.TABLES`, dynamic
`PREPARE`/`EXECUTE`, error handlers for 1141/1147 — collapses to declarative SQL:

```sql
GRANT USAGE ON SCHEMA public TO ${DB_USER};
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM ${DB_USER};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${DB_USER};
REVOKE UPDATE, DELETE ON audit_logs FROM ${DB_USER};        -- NFR-003, append-only
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO ${DB_USER};
```

Three traps:
1. **`GRANT … ON ALL SEQUENCES` is mandatory.** Identity/serial columns draw from sequences, and
   without `USAGE` *every insert by the app user fails*. MySQL has no analogue, so this is easy to
   omit and it breaks everything at once.
2. **`GRANT USAGE ON SCHEMA public`** — PostgreSQL 15+ no longer grants schema `CREATE`/`USAGE` to
   `PUBLIC` by default.
3. `ALTER DEFAULT PRIVILEGES` must be run by the role that will *create* future tables
   (`DB_ADMIN_USER`), or new tables land ungranted after the next migration.

`test/settings.e2e.spec.ts:87–98` asserts the app user cannot `UPDATE`/`DELETE` `audit_logs` — it is
the regression test for this file and must stay green.

#### [MODIFY] `apps/api/src/platform/db/migrate.ts`
- Admin pool import unchanged; `Connection` type from `pg`.
- `ensureMigrationsTable` (line 76): `BIGINT UNSIGNED AUTO_INCREMENT` → `BIGINT GENERATED ALWAYS AS
  IDENTITY`, `DATETIME(3)` → `TIMESTAMPTZ(3)`, drop `ENGINE`/`CHARSET`, backticks → quotes.
- **Replace the `utf8mb4_0900_ai_ci` guard (lines 114–121).** It exists to fail fast on a wrong
  engine (fix F-04) and should keep doing so: assert `SHOW server_version_num >= 150000` and
  `server_encoding = 'UTF8'`, plus whichever extension Decision 2 settles on.
- **Rewrite `splitSqlStatements` (lines 18–70).** Its `DELIMITER` handling is MySQL client syntax
  with no PostgreSQL meaning, and it would mis-split dollar-quoted (`$$ … $$`) bodies. Simplest
  correct replacement: **run each migration file as one multi-statement query inside an explicit
  transaction.** PostgreSQL has transactional DDL, so a failed migration rolls back completely —
  something MySQL could not offer and a real robustness gain. The exported function is covered by
  `migrate.spec.ts`; delete or rewrite those tests alongside.
- Parameter placeholders: `?` → `$1` at line 152–155.
- `${DB_USER}` / `${DB_NAME}` substitution for repeatable migrations and the
  `requireSafeIdentifier` guard stay as-is.

#### [MODIFY] `apps/api/drizzle/meta/_journal.json` and `0000_snapshot.json`
- `"dialect": "mysql"` → `"postgresql"`.
- Regenerate the baseline snapshot from the ported schema (`drizzle-kit generate`, then reset to a
  single `0000_schema_baseline` entry) so `scripts/check-schema-drift.ts` has a valid reference.
  The drift script itself is dialect-agnostic and needs no change.

### 8. Test harness

#### [RENAME] `apps/api/test/helpers/mysql.ts` → `apps/api/test/helpers/postgres.ts`
Update imports in `auth.e2e.spec.ts:9`, `exercises.e2e.spec.ts:10`, `foods.e2e.spec.ts:10`,
`people-onboarding.e2e.spec.ts:9`, `settings.e2e.spec.ts:9`.

`resetTestData()` (lines 44–83) uses MySQL's multi-table delete, which has no PostgreSQL equivalent:

```sql
-- MySQL
DELETE md FROM member_documents md
  INNER JOIN members m ON m.id = md.member_id
  INNER JOIN users u ON u.id = m.user_id
 WHERE u.email LIKE 'e2e_%@luxeknox.test';

-- PostgreSQL
DELETE FROM member_documents md
 USING members m, users u
 WHERE md.member_id = m.id AND m.user_id = u.id
   AND u.email LIKE 'e2e_%@luxeknox.test';
```

Five such statements (`member_documents`, `member_photos`, `member_health`, `emergency_contacts`,
then `members` / `trainers` / `employees` via `users`). FK-safe ordering is already correct and must
be preserved.

#### [MODIFY] `apps/api/vitest.config.e2e.ts`
No change required, but confirm the 30s timeouts still suffice — PostgreSQL container startup
differs from MySQL's.

### 9. Documentation

#### [CREATE] `docs/adr/0009-postgresql-migration.md`
ADR-0002 is `Accepted` and explicitly records that a PostgreSQL draft was written and then
"displaced by team direction". Do not silently edit it — supersede it. The new ADR must state:

- Decision 0's hosting answer, and honestly, what it costs relative to ADR-0002's core argument.
- What the migration **gains**: `TIMESTAMPTZ` converts ADR-0002's self-declared highest-risk
  convention into an engine guarantee; partial unique indexes replace the stored-generated-column
  workaround for all six "at most one" rules; `generate_series` removes the need for the planned
  `calendar_dates` spine table; `PERCENTILE_CONT` removes the `NTILE`/`PERCENT_RANK` workaround for
  the attendance heat map; `JSONB` + GIN makes the audit viewer's ad-hoc filtering viable without
  designing generated columns up front; transactional DDL makes migrations atomic; `pgcrypto`
  becomes an option alongside the application-level `FieldCrypto` (NFR-005).
- What it **costs**: case/accent-insensitive search is no longer free (Decision 2) — the one place
  ADR-0002 called MySQL "straightforwardly better"; backup tooling changes from
  `mysqldump --single-transaction` + binlog to `pg_dump`/`pg_basebackup` + WAL archiving, and the
  NFR-004 restore drill must be re-scoped.
- Conventions carried over unchanged: `NUMERIC(12,2)` money, `row_version` optimistic locking,
  soft delete via `is_active`/`status`, append-only audit enforced by grant, Read Committed.

#### [MODIFY] `docs/adr/0002-database-engine-and-data-access.md`
Set `Status` to `Superseded by ADR-0009` with a link. Leave the body intact — its reasoning is the
best available record of the trade-offs, and the new ADR argues against it directly.

#### [MODIFY] other docs
- `README.md` — the "Database (MySQL 8.4 LTS)" section: credentials, `docker compose` commands, the
  timezone/isolation verification snippet (`psql -c "SHOW timezone; SHOW default_transaction_isolation;"`).
- `docs/project-context.md` §10 and `docs/backend-frd.md` §26.2 — stack statements.
- `docs/database-entities.md` — ADR-0002 already notes it is engine-agnostic once its
  `TIMESTAMPTZ`-style wording is read as "a UTC instant"; that wording is now literal. Verify.
- `docs/openapi/README.md` and `v1.yaml` — regenerate via `openapi:dump` after the health-controller
  description changes; no schema changes expected.
- `archive/todo/README.md` "Locked decisions" table is historical — leave it, or add a one-line
  superseded note.

### 10. Data migration (production cutover)

Only relevant if production MySQL holds live data. Current schema is 17 tables with no ledger yet,
so this is small today and will not be after the `PAY` vertical ships — **do it now if it is going
to happen.**

1. Stand up the target PostgreSQL (Decision 0); run `db:migrate` + `db:seed` to create the schema.
2. Extract with `pgloader` (handles `TINYINT(1)`→`BOOLEAN`, `DATETIME`→`TIMESTAMPTZ`, `JSON`→`JSONB`
   in one pass) or per-table CSV. Load reference tables (`roles`, `permissions`,
   `role_permissions`, `gym_settings`) first, then `users`, then profiles, then children.
3. **Reset every identity sequence** — a bulk load with explicit ids leaves sequences at 1, and the
   first application insert then fails with a duplicate-key error:
   `SELECT setval(pg_get_serial_sequence('users','id'), (SELECT max(id) FROM users));` for each table.
4. Reset `membership_number_counters.next_value` to `max(membership_number) + 1`.
5. Validate: per-table row counts, `audit_logs` count and `max(created_at)`, a UTC round-trip
   spot-check on a known instant, and a login + member-create smoke test against the real data.
6. Apply `grants.sql` **after** the load (the app user cannot bulk-insert into `audit_logs`
   at the required volume under append-only grants, and `ALTER DEFAULT PRIVILEGES` must follow table
   creation).
7. Cutover: write-freeze → final delta load → repoint `DATABASE_URL` → `pm2 reload` → smoke test.
   Keep the MySQL instance running read-only for one full backup cycle.

---

## Verification Plan

### Automated (unchanged commands, new engine)
```bash
pnpm --filter api lint
pnpm --filter api typecheck
pnpm --filter api db:check        # schema drift vs regenerated baseline snapshot
pnpm --filter api db:migrate      # against a clean postgres:17 container
pnpm --filter api seed            # must be idempotent — run it twice
pnpm --filter api test            # unit
pnpm --filter api test:e2e        # 5 suites
pnpm --filter api openapi:dump && pnpm --filter api openapi:check
```

`typecheck` is the migration's strongest ally: every `mysql-core` import, `insertId` read, and
`onDuplicateKeyUpdate` call is a compile error once `client.ts` and the schema files are ported.
It will **not** catch the runtime traps — plan for them explicitly.

### Targeted checks for the failure modes typechecking misses

| Risk | Check |
| :--- | :--- |
| `.execute()` result shape (`{rows}` vs `[rows]`) | `POST /v1/members` end-to-end — exercises `allocateMembershipNumber`. Assert `M00000001` format, not just a 2xx. |
| `int8` returned as string | Assert `typeof body.id === 'number'` and `typeof page.total === 'number'` in a list endpoint E2E. |
| Sequence grants missing | Run the full E2E suite as `DB_USER`, never as the admin role. |
| Duplicate-key → 409 | E2E: create a member, then re-`POST` the same email; expect 409, not 500. |
| `is_active` boolean comparison | Any `activeOnly` list endpoint through `BaseRepository.findById`. |
| Case-insensitive search (FR-API-014) | Seed `"Barbell Squat"`; `GET /v1/exercises?q=barbell` must return it. **Fails today without Task 12.** |
| UTC round-trip | Existing `utc-datetime.spec.ts`, plus: write a known instant, read it back from a session in a non-UTC timezone. |
| Audit append-only (NFR-003) | `test/settings.e2e.spec.ts:87–98` must stay green. |
| Transactional rollback | Force a failure mid-`PersonFactory.create` and assert no orphan `users` row. |

### Manual
- `docker compose up -d` → `pg_isready` healthy → `db:migrate` on an empty volume → `db:seed` twice.
- `psql -c "SHOW timezone; SHOW default_transaction_isolation;"` → `UTC`, `read committed`.
- Log in as the bootstrap admin through the Flutter web build against the PostgreSQL-backed API.
  No client change is expected; this confirms it.
- Full `deploy/deploy.sh` dry run against a staging PostgreSQL before production cutover.

---

## Sequencing

Nine phases. Phases 1–3 leave the tree uncompilable by design — treat 1–6 as one landable unit.

| Phase | Content | Parallelizable |
| :--- | :--- | :--- |
| 0 | Decisions 0–5 settled and recorded | blocking |
| 1 | Infra: compose, `postgres.conf`, `.env.example`, deps, `drizzle.config.ts` | — |
| 2 | Connection layer: `client.ts`, `drizzle.module.ts`, `transaction-context.ts`, `utc-datetime.ts` | — |
| 3 | Schema files (14) | after 2; splittable per file |
| 4 | SQL migrations + `grants.sql` + `migrate.ts` + journal/snapshot | with 3 |
| 5 | Repositories: `insertId`→`RETURNING`, SQLSTATE errors, `ilike`, boolean, `.execute()` shapes | after 3 |
| 6 | Seeds + upserts | after 3 |
| 7 | E2E harness + spec updates | after 5, 6 |
| 8 | CI + deploy | with 7 |
| 9 | ADR-0009, README, docs, OpenAPI re-dump | any time after 0 |
| 10 | Production data migration + cutover | after 1–9 green |

---

## Out of scope

- The remaining ~38 tables in `docs/database-entities.md` (MEMB, PAY, SCHED, RPT). They are unbuilt;
  authoring them on PostgreSQL is cheaper than porting them later, which is an argument for
  migrating now rather than a task here.
- `pg_trgm` / `unaccent` search indexes — a follow-up once FR-API-014 is formally re-verified
  (Decision 2).
- The four unimplemented "at most one" rules (FR-WORK-006, FR-WORK-014, FR-DIET-004,
  FR-HEALTH-001 currents). They belong to their own verticals; the new ADR should record that
  partial unique indexes are now the normative pattern.
- Replacing the application-level `FieldCrypto` (NFR-005) with `pgcrypto`.
- Flutter client (`app/`) — verified to contain no database or SQL coupling.
