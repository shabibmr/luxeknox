# M0-18 — Pagination helper

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-17 |
| **Files** | 4 |

## Files

- `apps/api/src/platform/http/pagination.ts`
- `apps/api/src/platform/http/pagination.dto.ts`
- `apps/api/src/platform/http/pagination.spec.ts`
- `apps/api/src/platform/platform.module.ts`

## Work

Cursor on `(created_at, id)` and offset. Default limit from SettingsService.

## Done when

Unit tests cover cursor encode/decode and the default limit.
