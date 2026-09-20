# M0-12 — Seed Super Admin and catalog

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-11 |
| **Files** | 5 |

## Files

- `apps/api/src/platform/db/seed/permissions.ts`
- `apps/api/src/platform/db/seed/roles.ts`
- `apps/api/src/platform/db/seed/admin.ts`
- `apps/api/src/platform/db/seed/settings.ts`
- `apps/api/src/platform/db/seed/index.ts`

## Work

Seed all FRD module permission slugs, five system roles, Super Admin, and settings (timezone, currency, page size).

Env: `BOOTSTRAP_ADMIN_EMAIL`, `BOOTSTRAP_ADMIN_PASSWORD`. No `employees` row.

## Done when

Seed is idempotent. Super Admin is selectable by email.
