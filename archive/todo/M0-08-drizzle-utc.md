# M0-08 — Drizzle client and UTC helper

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-05, M0-07 |
| **Files** | 5 |

## Files

- `apps/api/drizzle.config.ts`
- `apps/api/src/platform/db/client.ts`
- `apps/api/src/platform/db/utc-datetime.ts`
- `apps/api/src/platform/db/utc-datetime.spec.ts`
- `apps/api/src/platform/db/schema/.gitkeep`

## Work

Pool sets `time_zone = '+00:00'`. `utcDatetime()` is the only timestamp helper. Never `NOW()` or `TIMESTAMP`. `.gitkeep` is replaced in M0-09.

## Done when

Unit test round-trips a known UTC instant.
