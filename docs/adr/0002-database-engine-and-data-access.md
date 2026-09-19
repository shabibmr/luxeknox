# ADR-0002 — Database engine & data access

| | |
| :--- | :--- |
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Revision** | Replaces the PostgreSQL draft of this record (never accepted — amended in place rather than superseded). See *Alternatives considered*. |
| **Resolves** | `backend-frd.md` §26.2 — "Database engine" |
| **Related** | [ADR-0001](./0001-backend-language-and-framework.md), [ADR-0004](./0004-tenancy-model.md) |

## Context

55 relational tables with real referential integrity, an immutable financial ledger, and a set of
constraints that are unusually specific. Four requirement families drive the choice:

**1. "At most one X per Y" appears six times.** These are correctness rules, not UI conveniences —
enforcing them in application code alone guarantees they will eventually be violated under
concurrency:

| Rule | Source |
| :--- | :--- |
| One current health row per member | FR-HEALTH-001 |
| At most one `is_primary = true` emergency contact per user | FR-HEALTH-005 |
| One current avatar per member (`member_photos.is_current_avatar`) | BR-PEOPLE-004 |
| One `active` assigned workout plan per member | FR-WORK-006 |
| Only one in-progress workout session per member | FR-WORK-014 |
| One active assigned diet plan per member | FR-DIET-004 |

**2. JSON columns are specified, not optional** — `secondary_muscles`, `specializations`,
`access_facilities`, `data_payload`, and audit before/after snapshots (`database-entities.md` §
"JSON"). Audit before/after in particular must be queryable for the audit viewer.

**3. Money must never be a float** (FR-API-005), the ledger needs point-in-time recovery
(NFR-004), and PII needs encryption at rest with access logged (NFR-005).

**4. Reports (§19)** are ranked, bucketed, period-over-period aggregates — window functions,
date-spine joins, percentile occupancy for the attendance heat map.

## Decision

**MySQL 8.4 LTS (InnoDB), accessed through Drizzle ORM (`drizzle-orm/mysql-core`) with drizzle-kit
migrations.**

Minimum **8.0.16** (the version where `CHECK` constraints are actually enforced rather than parsed
and ignored); **8.0.17** for multi-valued JSON indexes. Pin 8.4 LTS.

**MySQL, not MariaDB.** MariaDB's `JSON` is an alias for `LONGTEXT` with no binary storage and no
multi-valued indexes, which degrades requirement family 2 from "supported" to "string parsing".

### Why MySQL

It is the database the deployment target hands us. The configured Hostinger hosting API exposes
database provisioning and phpMyAdmin directly, so a managed, backed-up MySQL is available without
the team operating a database server — which is the single biggest operational cost this decision
can avoid. Ubiquitous tooling and hiring familiarity follow.

### The cost, stated up front: no partial unique indexes

The six rules above are one line each in Postgres. MySQL has no `WHERE` clause on an index. The
replacement is a **stored generated column that is `NULL` when the predicate is false**, plus an
ordinary unique index — because MySQL unique indexes permit unlimited `NULL`s:

```sql
ALTER TABLE workout_plans
  ADD COLUMN active_plan_member_id BIGINT UNSIGNED
    GENERATED ALWAYS AS (
      CASE WHEN status = 'active' AND is_template = 0 THEN member_id END
    ) STORED,
  ADD UNIQUE KEY one_active_plan_per_member (active_plan_member_id);

ALTER TABLE emergency_contacts
  ADD COLUMN primary_contact_user_id BIGINT UNSIGNED
    GENERATED ALWAYS AS (
      CASE WHEN is_primary = 1 THEN user_id END
    ) STORED,
  ADD UNIQUE KEY one_primary_contact_per_user (primary_contact_user_id);
```

This is **still enforced by the storage engine and still race-proof** — it is not an application
check. What it costs is six extra columns, six migrations that are less obvious to a reader, and a
pattern the team must know. That pattern is normative: **an "at most one" rule is never implemented
in the service layer.** Add it to the migration review checklist, because the seventh such rule is
the one that will quietly be written as a `SELECT` followed by an `INSERT`.

### Conventions

| Concern | Decision |
| :--- | :--- |
| **Money** | `DECIMAL(12,2)`. Exact decimal, never float (FR-API-005). Tax and discount computed **per line**, rounded half-up to 2dp, invoice total = sum of rounded lines. This rounding rule is normative — document it in `gym_settings` and test it against split payments. |
| **Currency** | Not stored per row. Single gym, single currency from `gym_settings` (FR-API-005). Revisit under [ADR-0004](./0004-tenancy-model.md) if multi-gym arrives. |
| **Timestamps** | `DATETIME(3)`, always UTC (FR-API-004). **Not `TIMESTAMP`** — it is capped at 2038 and silently converts against the session time zone. Connections set `time_zone = '+00:00'`; application SQL uses `UTC_TIMESTAMP(3)` and never `NOW()`. Display timezone is a `gym_settings` presentation concern and never touches storage. |
| **Primary keys** | `BIGINT UNSIGNED AUTO_INCREMENT` internally; UUIDv7 stored as `BINARY(16)` only where an id is exposed in a URL a member could enumerate (documents, receipts, progress photos). Never `CHAR(36)` — it is carried in every secondary index. UUIDv7 is time-ordered, so it does not fragment the InnoDB clustered index the way v4 would. |
| **Text & search** | `utf8mb4` / `utf8mb4_0900_ai_ci`. The default collation is accent- and case-insensitive, which satisfies **FR-API-014 with no extra work** — this is one place MySQL is straightforwardly better than the alternative, which needed `citext` or a functional index. |
| **JSON** | Native `JSON`. For the audit viewer's filters, plan the queried paths up front and expose each as a stored generated column with an index (`JSON_UNQUOTE(before->'$.status')`); use multi-valued indexes for array containment. Ad-hoc querying of arbitrary JSON paths is not fast here — design the audit filters before shipping `SYS`. |
| **Soft delete** | `is_active` / `status` columns per FR-API-010. No row referenced by history is ever hard-deleted. No global soft-delete filter — it hides bugs; filter explicitly at the repository. |
| **Immutability** | History and audit tables (NFR-003) get `REVOKE UPDATE, DELETE ON <db>.<table> FROM <app_user>`. Enforced by grant, not by convention. MySQL's table-level grants cover this cleanly. |
| **Concurrency** | FR-API-009 optimistic locking via an explicit **`row_version INT UNSIGNED`** incremented on every write to `schedules`, `memberships`, `payments`, and plan tables; mismatch → 409. An `updated_at` token is *not* used: `DATETIME(3)` has millisecond resolution and two updates can land in the same millisecond under a POS or check-in burst, which would make the check silently pass. |
| **Isolation** | Set `transaction_isolation = READ-COMMITTED` with `binlog_format = ROW`. InnoDB's default `REPEATABLE READ` takes gap locks on range scans, which produces deadlocks precisely on the concurrent-insert paths this app has (turnstile check-in, POS). Read-committed also matches the semantics the rest of these ADRs assume. |
| **PII at rest** (NFR-005) | Full-disk encryption on the host, plus **application-level AES-256-GCM** in one `FieldCrypto` helper for `member_health` and `medical_histories` free text, key from the secret store. **Do not use MySQL's `AES_ENCRYPT()`** — the key appears as a literal in the statement and therefore in the binary log and the slow query log, which turns encryption-at-rest into key-disclosure-at-rest. Access logging for these two is already mandated by FR-HEALTH-010. |
| **Backups** (NFR-004) | `mysqldump --single-transaction` (or XtraBackup) daily, **plus binary log retention** for point-in-time recovery: `log_bin = ON`, `binlog_format = ROW`, `binlog_expire_logs_seconds` at least twice the full-backup interval. PITR is required for the ledger — a nightly dump alone cannot satisfy NFR-004. |

### Reporting (§19) — two gaps to plan around

MySQL 8 has window functions and recursive CTEs, so the ranked and period-over-period aggregates are
fine. Two things are missing relative to the Postgres draft:

- **No `generate_series`.** Ship a seeded `calendar_dates` table (2020–2040) as the date spine for
  bucketed reports. Simpler and faster than a recursive CTE evaluated per report.
- **No `PERCENTILE_CONT`.** The attendance heat map's percentile occupancy uses `NTILE` /
  `PERCENT_RANK`, or is computed in the service layer over a bounded result set.

### Why Drizzle

- SQL-first: the `RPT` module (§19) and the dashboard read models (§18) are aggregate queries.
  Drizzle lets them be written as SQL with type inference, rather than fought through a
  query-builder abstraction or dropped to raw strings that lose all typing.
- Transaction ergonomics: FR-API-006 requires mutation + history row in one transaction on nearly
  every write path. Drizzle's `db.transaction(tx => …)` composes cleanly with the request-scoped
  transaction context from [ADR-0001](./0001-backend-language-and-framework.md).
- Migrations are plain, reviewable SQL files. The generated-column unique indexes and the `REVOKE`
  grants above are written directly in hand-authored migration files, with no escape hatch needed.
- It supports MySQL first-class via `drizzle-orm/mysql-core` on the `mysql2` driver, so this decision
  did not change with the engine.

## Consequences

**Positive**

- The deployment target provisions and backs up the database natively, so the team is not operating
  a database server for the MVP.
- Case-insensitive search (FR-API-014) is the default collation behaviour rather than a schema
  decision.
- Six correctness rules still move from "hopefully the service layer checks" to "the database
  refuses" — via generated columns rather than partial indexes, but engine-enforced either way.
- Schema and migrations are readable SQL, reviewable by anyone, with ubiquitous tooling.

**Negative**

- **No engine-enforced time zone is the highest-risk convention in this schema.** `DATETIME` carries
  no offset, so a single write that stores local time corrupts attendance windows and billing
  periods silently, and the corruption is not visible until someone reconciles a month. Mitigation:
  one `utcDatetime()` helper in the Drizzle schema module, `time_zone = '+00:00'` pinned on the
  connection pool, a lint rule banning `NOW()` in application SQL, and a test that asserts the
  round-trip of a known instant.
- Each "at most one" rule costs a generated column and a less-obvious migration. The pattern must be
  taught, not discovered.
- Audit-log JSON filtering needs its query paths designed up front as generated columns; arbitrary
  JSON path filtering will not perform.
- Column-level PII encryption is now application code the team owns and must key-manage, rather than
  a database extension.
- Backup verification remains the team's job regardless of who runs the server. **A restore drill
  must be part of the definition of done for the `PAY` vertical** — NFR-004 is worthless untested.

**Neutral**

- `database-entities.md` is engine-agnostic once its `TIMESTAMPTZ`-style wording is read as "a UTC
  instant". No table definition in it requires a Postgres-only feature.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **PostgreSQL 16+** *(the initial draft of this record)* | Proposed first, on the strength of partial unique indexes expressing all six "at most one" rules in one line each, `TIMESTAMPTZ` making the UTC rule engine-enforced rather than conventional, richer `JSONB`/GIN querying for the audit viewer, `pgcrypto`, and `generate_series` for report spines. Displaced by team direction. The trade is real and worth stating plainly: **everything above is still achievable on MySQL, but four of them become conventions or workarounds rather than guarantees** — the time-zone one being the only one with no engine-level substitute. |
| **MariaDB** | Drop-in on the surface, but `JSON` is a `LONGTEXT` alias with no binary storage and no multi-valued indexes. Requirement family 2 would regress to string parsing. |
| **SQLite** | Fine for a single-gym read-mostly app, and genuinely tempting at NFR-002 load. Rejected on NFR-004 (point-in-time recovery for the ledger) and concurrent write behaviour during a POS + turnstile burst. |
| **MongoDB** | The model is 55 tables of explicitly relational data with FK integrity and transactional history writes. Wrong shape entirely. |
| **Prisma (on MySQL)** | Close call, and better DX for plain CRUD. Rejected for the reporting and raw-SQL reasons above; the engine binary and its migration shadow-database model also complicate deployment. |
