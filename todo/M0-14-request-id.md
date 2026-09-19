# M0-14 — `request_id` interceptor

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-13 |
| **Files** | 4 |

## Files

- `apps/api/src/platform/http/request-id.ts`
- `apps/api/src/platform/http/request-id.interceptor.ts`
- `apps/api/src/platform/http/request-id.interceptor.spec.ts`
- `apps/api/src/platform/errors/exception.filter.ts`

## Work

Stamp `request_id` on the request ALS. Exception filter reads it.

## Done when

Every error body includes a non-empty `request_id`.
