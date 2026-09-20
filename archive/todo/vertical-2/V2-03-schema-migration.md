# V2-03 — `foods` schema + migration

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 4 |

## Why

No foods table in the delivery path until this ticket lands schema + hand-authored migration.
Columns follow OpenAPI `Food`/`FoodWrite` and FR-DIET-001 / `docs/database-entities.md` foods
key-attrs (including `is_active`).

## Files

- `apps/api/src/platform/db/schema/foods.ts` (new)
- `apps/api/src/platform/db/schema/index.ts`
- `apps/api/drizzle/0003_foods.sql` (new — hand-authored like `0002_exercises.sql`)
- `docs/database-entities.md` (foods key-attrs include `is_active`)

## Work

Drizzle table, same conventions as `exercises.ts` (`BIGINT UNSIGNED AUTO_INCREMENT` PK,
`utcDatetime()`, table collation `utf8mb4_0900_ai_ci`):

| Column | Type | Notes |
| :--- | :--- | :--- |
| `id` | `BIGINT UNSIGNED AUTO_INCREMENT PK` | |
| `name` | `VARCHAR(150) NOT NULL` | |
| `serving_unit` | `VARCHAR(50) NOT NULL` | grams, ml, pieces, etc. |
| `serving_size` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `calories` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `protein_grams` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `carbs_grams` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `fat_grams` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `fiber_grams` | `DECIMAL(10,2) NULL` | `mode: 'number'` |
| `is_verified` | `BOOLEAN NOT NULL DEFAULT FALSE` | BR-DIET-002 |
| `is_active` | `BOOLEAN NOT NULL DEFAULT TRUE` | soft-deactivate |
| `created_at` | `utcDatetime NOT NULL` | |
| `updated_at` | `utcDatetime NULL` | |

Indexes: `(is_active, is_verified)` for browse; `name` for `q` / LIKE.

Hand-author `0003_foods.sql` mirroring `0002_exercises.sql` style. Apply via
`pnpm --filter api db:migrate` (admin pool). Repeatable grants pick up `foods` without edits.
Update entities foods key-attrs to list `is_active` if missing.

## Done when

- Migrate applies `0003_foods.sql` cleanly; second run is a no-op.
- Schema and migration agree (`db:check` when available).
- Entities foods key-attrs include `is_active`.
