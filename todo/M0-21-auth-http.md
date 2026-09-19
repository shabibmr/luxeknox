# M0-21 — Login, refresh, logout

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-12, M0-13, M0-20 |
| **Files** | 6 |

## Files

- `apps/api/src/auth/auth.service.ts`
- `apps/api/src/auth/auth.service.spec.ts`
- `apps/api/src/auth/auth.controller.ts`
- `apps/api/src/auth/auth.dto.ts`
- `apps/api/src/auth/login-throttle.ts`
- `apps/api/src/auth/auth.module.ts`

## Work

FR-AUTH-001 to 004. Same message for unknown user and wrong password. Reject non-`active`. Refresh reuse revokes `family_id`. Rate-limit identifier and IP.

## Done when

Unit tests cover login success, bad password, inactive, refresh reuse, and throttle.
