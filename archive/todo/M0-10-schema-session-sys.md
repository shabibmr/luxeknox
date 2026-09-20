# M0-10 — Schema: sessions, settings, audit

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-09 |
| **Files** | 4 |

## Files

- `apps/api/src/platform/db/schema/sessions.ts`
- `apps/api/src/platform/db/schema/gym-settings.ts`
- `apps/api/src/platform/db/schema/audit-logs.ts`
- `apps/api/src/platform/db/schema/index.ts`

## Work

`sessions` columns: `access_token_hash`, `refresh_token_hash`, `family_id`, `revoked_at`, TTLs, denormalised `user_type` and `profile_id`.

## Done when

`schema/index.ts` exports seven platform tables.
