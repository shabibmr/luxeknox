# V3-09 — `/me` profile + demo seeds + session `profile_id`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-05b, V3-06, V3-07 |
| **Files** | ≤7 |

## Why

`/me` currently hardcodes `profile: null`. Demo trainer/member users have no profile rows.
`sessions.profile_id` exists but is never stamped. Login must resolve profile id for `user_type`
and stamp the session (plan locked decision).

## Files

- `apps/api/src/auth/me.controller.ts` / related DTO mapper
- `apps/api/src/auth/auth.service.ts` (login session create path)
- `apps/api/src/platform/db/seed/admin.ts` (or dedicated people seed) — demo member/trainer/employee
  profiles
- Person factory / `resolveProfileId` from V3-03
- Specs for me + login profile_id

## Work

- On successful login / session issue: resolve profile id (`members`/`trainers`/`employees` by
  `user_id` + `user_type`); set `sessions.profile_id`.
- `GET /me`: return non-null profile summary when a profile row exists (shape per OpenAPI Me /
  Principal — match existing contract).
- Seed: ensure demo admin/trainer/member (passwords per project preference `123456`) have matching
  profile rows; optional demo employee.
- Super Admin may remain without employee row (identity note) — `/me` profile null OK for that case.
- Do not break existing auth e2e; extend assertions for profile_id when profile exists.

## Done when

- Login as seeded trainer/member yields non-null `sessions.profile_id` and `/me.profile`.
- Admin-without-employee behaviour documented/tested.
- lint/typecheck/test green.
