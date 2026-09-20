# V3-02 — PEOPLE schema + `0004_people.sql`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-01 |
| **Files** | ≤7 |

## Why

`members`, `trainers`, and `employees` are documented in `docs/database-entities.md` but absent
from Drizzle. Vertical 3 APIs need these tables plus a concurrency-safe `membership_number`
sequence. `EmployeeCreate` requires `first_name` / `last_name` — add columns and update entities.

## Files

- `apps/api/src/platform/db/schema/members.ts` (new)
- `apps/api/src/platform/db/schema/trainers.ts` (new)
- `apps/api/src/platform/db/schema/employees.ts` (new)
- `apps/api/src/platform/db/schema/index.ts`
- `apps/api/drizzle/0004_people.sql` (new)
- `apps/api/drizzle/meta/0000_snapshot.json` (refresh for `db:check`)
- `docs/database-entities.md` (`employees` key-attrs + membership_number note)

(If file budget forces a split: snapshot refresh may land with migration apply notes; prefer
keeping schema+migration+entities together.)

## Work

### Tables (align entities + OpenAPI)

**`members`:** `id`, `user_id` (FK users, unique), `membership_number` (unique, immutable),
`first_name`, `last_name`, `gender`, `date_of_birth`, `address`, `assigned_trainer_id`
(FK trainers nullable), `joined_date`, `notes`, timestamps.

**`trainers`:** `id`, `user_id` (unique FK), `first_name`, `last_name`, `bio`,
`specializations` (JSON — MariaDB may store as TEXT; outbound-normalize later like
`secondary_muscles`), `hourly_rate` (decimal/money-compatible), `rating`,
`max_clients_capacity`, `is_active`, timestamps.

**`employees`:** `id`, `user_id` (unique FK), **`first_name`**, **`last_name`**, `job_title`,
`department`, `hire_date`, `status` (`active` | `on_probation` | `suspended` | `terminated`),
timestamps. Document names in entities.md.

**`emergency_contacts` (preferred here):** include in `0004_people.sql` if file budget allows so
V3-08 is routes-only; otherwise V3-08 owns the table migration.

### `membership_number`

- Format: `M` + 8 zero-padded digits (`M00000001`, …).
- Unique + immutable after insert (enforced in service V3-05b; column not updatable by API).
- Design a **MariaDB-safe** concurrency approach in this ticket (document choice in schema
  comment or short note in entities): e.g. counter table with `SELECT … FOR UPDATE` inside the
  person-create TX, or `MAX`+retry on unique violation. Prefer counter table if MAX races are
  ugly under load.

### Migration notes

- Hand-authored SQL; collation `utf8mb4_unicode_ci` for MariaDB verification hosts (same pattern
  as foods — migrate gate may require manual apply + `__drizzle_migrations` row).
- App-user grants: ensure repeatable grants cover new tables.
- `pnpm --filter api db:check` clean after snapshot refresh.

## Done when

- Schema exports wired; `0004_people.sql` applies (or documented MariaDB manual path).
- `db:check` reports no drift.
- entities.md lists employee names + membership_number convention.
- lint/typecheck/test green.
