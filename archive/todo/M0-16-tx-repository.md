# M0-16 — Transaction context and base repository

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-08, M0-11 |
| **Files** | 5 |

## Files

- `apps/api/src/platform/db/transaction-context.ts`
- `apps/api/src/platform/db/transaction-context.spec.ts`
- `apps/api/src/platform/db/base.repository.ts`
- `apps/api/src/platform/db/drizzle.module.ts`
- `apps/api/src/app.module.ts`

## Work

ALS transaction. Repositories enlist. No SQL in controllers. Soft-status filter on the base repo.

## Done when

Unit test: two repo calls in one `db.transaction` share the same tx.
