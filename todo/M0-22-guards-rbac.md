# M0-22 — Auth guard and PermissionGuard

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-14, M0-21 |
| **Files** | 6 |

## Files

- `apps/api/src/auth/auth.guard.ts`
- `apps/api/src/auth/current-user.decorator.ts`
- `apps/api/src/rbac/permission-cache.ts`
- `apps/api/src/rbac/require-permission.decorator.ts`
- `apps/api/src/rbac/permission.guard.ts`
- `apps/api/src/rbac/permission.guard.spec.ts`

## Work

Public allowlist: health, ready, login, refresh, settings/public. Principal from the session row. Slugs from the role cache, not the token.

## Done when

Missing token returns 401. Member vs `settings.read` returns 403 in the unit test.
