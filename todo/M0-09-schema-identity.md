# M0-09 — Schema: identity

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-08 |
| **Files** | 5 |

## Files

- `apps/api/src/platform/db/schema/users.ts`
- `apps/api/src/platform/db/schema/roles.ts`
- `apps/api/src/platform/db/schema/permissions.ts`
- `apps/api/src/platform/db/schema/role-permissions.ts`
- `apps/api/src/platform/db/schema/index.ts`

## Work

Drizzle tables for identity. No `token_version`. Unique email and phone where not null.

## Done when

Schema exports the four tables.
