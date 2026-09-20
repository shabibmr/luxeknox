# M0-15 — Health and ready

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-08, M0-14 |
| **Files** | 5 |

## Files

- `apps/api/src/platform/health/health.controller.ts`
- `apps/api/src/platform/health/health.module.ts`
- `apps/api/src/platform/health/health.controller.spec.ts`
- `apps/api/src/app.module.ts`
- `apps/api/src/main.ts`

## Work

`GET /v1/health` — process up. `GET /v1/ready` — MySQL ping. Both public.

## Done when

Health returns 200 without DB. Ready returns 503 if DB is down, 200 if up.
