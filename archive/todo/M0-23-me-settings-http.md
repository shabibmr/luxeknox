# M0-23 — `GET /me` and settings reads

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-17, M0-22 |
| **Files** | 6 |

## Files

- `apps/api/src/auth/me.controller.ts`
- `apps/api/src/auth/me.controller.spec.ts`
- `apps/api/src/sys/settings.controller.ts`
- `apps/api/src/sys/settings.controller.spec.ts`
- `apps/api/src/auth/auth.module.ts`
- `apps/api/src/sys/sys.module.ts`

## Work

`GET /me` returns user, role, slugs, `profile: null`. `GET /settings/public` is unauthenticated. `GET /settings` requires `settings.read`. No upsert.

## Done when

Super Admin reads `/settings`. Member gets 403. `/me` includes slugs.
