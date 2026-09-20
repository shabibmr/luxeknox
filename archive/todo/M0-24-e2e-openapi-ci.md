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

MySQL 8.4 from compose locally, GitHub service container in CI. `resetTestData()` isolates runs.
Testcontainers was **not** adopted — the CI service container already provides a clean pinned MySQL 8.4 per run.

E2E: login → `/me` → refresh → logout; refresh reuse; inactive login; Member 403 on `/settings`; UTC round-trip; audit `UPDATE` rejected.

CI: lint, typecheck, unit, e2e, `drizzle-kit check`, OpenAPI dump + module-0 path/method parity against `docs/openapi/v1.yaml`.

## Done when

CI workflow is present. OpenAPI contract (`docs/openapi/v1.yaml`) is committed. E2E is green locally.
CI fails if a shipped `module-0` operation drifts from `docs/openapi/v1.yaml` (path/method parity vs live dump).
