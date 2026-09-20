# V3-13a — `member_health` nested routes

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-11, V3-12 |
| **Files** | ≤7 |

## Why

OpenAPI `/members/{id}/health` GET/PATCH with `health.read` / `health.update`. Onboarding health
declaration without medical_histories catalog.

## Files

- `apps/api/src/people/member-health.repository.ts` (or `health/` module)
- `apps/api/src/people/member-health.service.ts`
- `apps/api/src/people/member-health.controller.ts`
- dto + module wire
- Row-scope reuse

## Work

- GET/PATCH (upsert) member_health for member id.
- Permissions + row-scope 404.
- Audit on update.
- No conditions catalog endpoints.

## Done when

- Nested health routes live and scoped.
- lint/typecheck/test green.
