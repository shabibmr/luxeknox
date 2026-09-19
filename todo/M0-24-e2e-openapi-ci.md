# M0-24 — Integration, OpenAPI, CI

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-15, M0-23 |
| **Files** | 6 |

## Files

- `apps/api/test/helpers/mysql.ts`
- `apps/api/test/auth.e2e.spec.ts`
- `apps/api/test/settings.e2e.spec.ts`
- `apps/api/scripts/dump-openapi.ts`
- `docs/openapi/v1.yaml`
- `.github/workflows/api.yml`

## Work

Testcontainers MySQL 8.4. E2E: login → `/me` → refresh → logout; refresh reuse; inactive login; Member 403 on `/settings`; UTC round-trip; audit `UPDATE` rejected.

CI: lint, typecheck, unit, e2e, `drizzle-kit check`.

## Done when

CI workflow is present. OpenAPI is committed. E2E is green locally.
