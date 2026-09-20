# V3-16 — e2e extras + mvp OpenAPI dump/compare

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-14 |
| **Files** | ≤7 |

## Why

CI must prove Nest dump matches frozen `docs/openapi/v1.yaml` for **new mvp** people/media/health
ops (same spirit as V1-11 / V2-09) — not module-0-only `openapi:check`. medical-histories and
health-conditions stay deferred and must **not** appear as mvp parity targets.

## Files

- Extend `apps/api/scripts/check-openapi-parity.ts` (or foods-era helper) for people/media/health
  path allowlist
- Additional e2e cases if gaps remain after V3-14 (terminate blocks login; capacity; id_proof deny)
- CI workflow touch only if needed (`.github/workflows/api.yml`)

## Work

- Dump OpenAPI from Nest; compare mvp ops for:
  - `/members`, `/members/{id}`, `/members/{id}/assign-trainer`
  - `/trainers`, `/trainers/{id}`, `/trainers/{id}/members`
  - `/employees`, `/employees/{id}`, `/employees/{id}/role`, `/employees/{id}/status`
  - `/users/{id}/emergency-contacts` (+ contactId)
  - `/members/{id}/health`
  - `/members/{id}/documents` (+ verify/delete) — after V3-13b
  - `/members/{id}/photos` (+ avatar) — after V3-13c
  - `/media/uploads`, `/media/{key}`
- Assert deferred: medical-histories, health-conditions **absent** from mvp set.
- Fill any remaining e2e exit criteria from README.

## Done when

- Parity script green in CI locally (`pnpm --filter api` script as established).
- Exit criteria in `vertical-3/README.md` satisfied.
- Full lint/typecheck/unit/e2e green.
