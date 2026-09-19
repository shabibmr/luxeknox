# M0-11 — SQL migration + grants

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-10 |
| **Files** | 3 |

## Files

- `apps/api/drizzle/0001_platform.sql`
- `apps/api/drizzle/0002_grants.sql`
- `apps/api/src/platform/db/migrate.ts`

## Work

Hand-authored SQL. `REVOKE UPDATE, DELETE` on `audit_logs` from the app user.

## Done when

Migrate against compose MySQL succeeds. `UPDATE audit_logs` as the app user fails.
