# M0-13 — Uniform errors

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-06 |
| **Files** | 5 |

## Files

- `apps/api/src/platform/errors/codes.ts`
- `apps/api/src/platform/errors/app-error.ts`
- `apps/api/src/platform/errors/exception.filter.ts`
- `apps/api/src/platform/errors/exception.filter.spec.ts`
- `apps/api/src/platform/platform.module.ts`

## Work

Error body: `{ code, message, details[], request_id }`. Codes from FRD §5.2. No stack traces. `request_id` may be `"pending"` until M0-14.

## Done when

Unit tests cover 401, 403, and 400 shapes.
