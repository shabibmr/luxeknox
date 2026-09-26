# OpenAPI (`docs/openapi/v1.yaml`) vs Nest backend

Updated **2026-09-25**: YAML was aligned to Nest controllers for routes present in code. Deferred / not-yet-built ops (e.g. `/health-conditions`) were **kept**.

`pnpm --filter api openapi:check` passes (8 module-0 + 162 `x-parity: required` ops in the live dump).

## Applied YAML updates (from Nest)

| Area | Change |
| --- | --- |
| Routes | Added `PUT/GET /media/objects` (HMAC query auth, public) |
| Progress photos | `deferred` → `mvp` + `x-parity: required` |
| Status codes | Eight action POSTs `200` → `201` (cancel/start/complete/check-out/mark/refund/adjust) |
| Permissions | Nest-as-is: `schedules.write` / `schedules.cancel`, `workouts.write`, `diets.read\|write`, `goals.write`; check-in cleared (`@Public`) |
| Auth | `LoginRequest` + `identifier`/`phoneNumber`; `RefreshRequest` + `refreshToken`; `SessionResponse` camelCase primary + snake aliases + `tokenType`/`expiresIn` |

## Remaining gaps (not changed)

| Gap | Notes |
| --- | --- |
| `/health-conditions` ×3 | Still `deferred` in YAML; not in Nest (kept on purpose) |
| `GET /reports/{type}` | YAML still documents `x-permission: reports.read`; Nest enforces in service (also `read_own` / `export`) |
| Nest Swagger dump schemas | Dump still uses `*Dto` names and omits many bodies/params; hand YAML remains the client contract |
| Foods vs diet plans | Foods stay `diet.*`; plans/logs use Nest `diets.*` |
)
