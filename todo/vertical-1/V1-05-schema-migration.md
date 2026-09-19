# V1-05 — `exercises` schema + migration

| | |
| :--- | :--- |
| **Status** | completed, verified live |
| **Depends** | none |
| **Files** | 3 |

## Why

No `exercises` table exists yet (`apps/api/src/platform/db/schema/` has no `exercises.ts`). Fields
per `docs/database-entities.md` §7 and `docs/openapi/v1.yaml` `Exercise`/`ExerciseWrite` schemas.

## Files

- `apps/api/src/platform/db/schema/exercises.ts` (new)
- `apps/api/src/platform/db/schema/index.ts`
- `apps/api/drizzle/0002_exercises.sql` (new — next free numbered migration; `0002_grants.sql` was
  removed by F-03 and replaced with `drizzle/repeatable/grants.sql`, so `0002` is free)

## Work

Drizzle table, following the conventions already used by `roles.ts`/`gym-settings.ts`
(`BIGINT UNSIGNED AUTO_INCREMENT` PK, `utcDatetime()` helper, `utf8mb4_0900_ai_ci` — inherited from
table-level collation, not set per-column):

| Column | Type | Notes |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT PK` | |
| `name` | `VARCHAR(150) NOT NULL` | |
| `primary_muscle_group` | `VARCHAR(100) NULL` | |
| `secondary_muscles` | `JSON NULL` | array of strings — `Exercise.secondary_muscles` |
| `equipment_needed` | `VARCHAR(150) NULL` | single string, not an array — locked decision |
| `instructions` | `TEXT NULL` | |
| `video_url` | `VARCHAR(500) NULL` | external URL, ADR-0005 |
| `gif_url` | `VARCHAR(500) NULL` | external URL, ADR-0005 |
| `difficulty_level` | `VARCHAR(50) NULL` | |
| `is_active` | `BOOLEAN NOT NULL DEFAULT TRUE` | soft-deactivate target |
| `created_at` | `utcDatetime NOT NULL` | |
| `updated_at` | `utcDatetime NULL` | |

Index: `(is_active, primary_muscle_group)` for the browse/filter path (FR-WORK-002); a `FULLTEXT` or
plain index on `name` if `q` search needs it beyond `LIKE` — decide against actual query patterns in
V1-06, don't over-index speculatively here.

After F-03, the app user has no DDL — run `pnpm --filter api db:migrate` (uses
`createAdminConnectionPool()`) to apply this, not a manual `CREATE TABLE`. The repeatable grants
script (`drizzle/repeatable/grants.sql`) re-runs automatically on every migrate and will pick up
`exercises` for DML grants without edits.

## Done when

- `pnpm --filter api db:migrate` applies `0002_exercises.sql` cleanly against a fresh compose
  database, and a second run is a no-op.
- `pnpm --filter api db:check` (once F-14 adds it) reports no drift between `schema/exercises.ts` and
  the migration.
- App-user grants cover `exercises` (SELECT/INSERT/UPDATE/DELETE) after the repeatable pass —
  confirm with `SHOW GRANTS FOR CURRENT_USER()` as the app user.

## Live verification (2026-09-19)

Ran against a real, reachable MariaDB 10.4.22 server (not the target MySQL 8.4 — see
`todo/vertical-1/README.md` "Environment limitation"; credentials `user2grey`/`user2grey`, the only
user on this server, per user instruction). `pnpm --filter api db:migrate` applied
`0002_exercises.sql` cleanly; `DESCRIBE exercises` confirmed the column set matches the schema
exactly. Collation fell back from `utf8mb4_0900_ai_ci` to `utf8mb4_unicode_ci` as MariaDB doesn't
support the former — this is the exact gap `todo/fixes/F-04-collation-fail-fast.md` (still open)
is meant to close by failing the migration instead. The repeatable grants script was deliberately
**not** run this pass (moved aside, restored after) — this server has only one, unrestricted user, so
there is no scoped app user for it to restrict; see the README note.
