# OpenAPI contract

**File:** [`v1.yaml`](./v1.yaml) — OpenAPI 3.1, REST `/v1`.

This is the shared HTTP contract for the Nest API and the Flutter client. Implement against this file. Do not invent parallel path shapes.

| Side | Use |
| :--- | :--- |
| Backend | Nest handlers, DTOs, and `@nestjs/swagger` must match these `operationId`s and schemas. A dump that drifts is a bug. |
| Frontend | Generate the Dart client from this file. Do not hand-write API models. |

ADR: [`0003-api-style-and-authentication.md`](../adr/0003-api-style-and-authentication.md). Behaviour: [`backend-frd.md`](../backend-frd.md) §24.

## Generate a Dart client

```bash
npx @openapitools/openapi-generator-cli generate \
  -i docs/openapi/v1.yaml \
  -g dart-dio \
  -o apps/mobile/lib/core/network/generated \
  --additional-properties=pubName=luxeknox_api,nullableFields=true
```

Map generated models to domain entities in `data/` (ADR-0006). Generated types never leave `data/`.

## Conventions encoded here

- Prefix `/v1` is on the server URL, not on each path.
- Auth: `Authorization: Bearer gk_at_…`. Refresh is a body field, never a query param.
- Errors: `{ code, message, details[], request_id }`.
- Lists: `{ data, meta }` with cursor and/or offset.
- Money: string with two decimal places (`"1299.00"`), never a JSON number.
- IDs: `int64`.
- Timestamps: UTC ISO-8601.
- Optimistic lock: `row_version` on memberships, schedules, payments, workout plans, diet plans.
- Idempotency: header `Idempotency-Key` on payments, check-in, booking, freeze.

## `x-status` on operations

| Value | Meaning |
| :--- | :--- |
| `module-0` | Platform spine (health, session, `/me`, settings read). |
| `mvp` | Specified for MVP; build with the owning vertical. |
| `deferred` | ADR-0005 — no uploads in MVP. Paths are reserved so the client does not invent them. Do not call. |

## Out of this contract

Webhooks from a future payment gateway, hardware vendor SDKs, and GraphQL. Hardware ingest uses the same check-in path with `X-Device-Key` instead of a user Bearer token.
