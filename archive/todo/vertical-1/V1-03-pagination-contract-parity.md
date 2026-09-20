# V1-03 — Pagination contract parity

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 3 |

## Why

`GET /exercises` returns `ExercisePage` → `meta: PageMeta` (`docs/openapi/v1.yaml`):
`{ limit, offset, cursor, next_cursor, has_more, total }`, all snake_case, `limit`/`offset` always
present. The current `PaginationHelper.createResponse()` (`apps/api/src/platform/http/pagination.ts`)
emits `{ total?, cursor, hasMore }` — camelCase, no `limit`, no `offset`, no `next_cursor`. Nothing in
production uses it yet (`rg "createResponse|createPaginatedResponse"` only matches its own spec), so
this is safe to change now, before any controller depends on the old shape.

## Files

- `apps/api/src/platform/http/pagination.dto.ts`
- `apps/api/src/platform/http/pagination.ts`
- `apps/api/src/platform/http/pagination.spec.ts`

## Work

- `PaginationMeta` → `{ limit: number; offset: number | null; cursor: string | null; next_cursor: string | null; has_more: boolean; total?: number }`.
- `createPaginatedResponse` / `PaginationHelper.createResponse`: populate `limit` always; `offset`
  when `mode === 'offset'` (else `null`); `cursor` from the *request's* decoded cursor if present
  (else `null`) — this is distinct from `next_cursor`, the encoded cursor for the *next* page.
- Keep `encodeCursor`/`decodeCursor` and the offset/cursor/page normalization in `normalizeParams`
  unchanged — only the response envelope shape changes.
- No NestJS serializer/interceptor exists that renames camelCase → snake_case (confirmed: no
  `ClassSerializerInterceptor` or naming-strategy wiring in `main.ts`/`app.module.ts`). Build the
  object with snake_case keys directly; do not add a global interceptor for this alone.

## Done when

- `pagination.spec.ts` asserts the exact key set `{ limit, offset, cursor, next_cursor, has_more,
  total? }` for both offset-mode and cursor-mode responses.
- `pnpm --filter api test` passes.
- The shape matches `docs/openapi/v1.yaml` `#/components/schemas/PageMeta` field-for-field.
