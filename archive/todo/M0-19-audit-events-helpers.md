# M0-19 — Audit, events, money, row_version

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-16 |
| **Files** | 7 |

## Files

- `apps/api/src/platform/audit/audit.service.ts`
- `apps/api/src/platform/audit/audit.service.spec.ts`
- `apps/api/src/platform/events/domain-events.ts`
- `apps/api/src/platform/events/domain-events.spec.ts`
- `apps/api/src/platform/money/money.ts`
- `apps/api/src/platform/concurrency/row-version.ts`
- `apps/api/src/platform/platform.module.ts`

## Work

Audit insert only. Events via `@nestjs/event-emitter`. Money half-up to 2dp. `row_version` throws 409; no endpoint uses it yet. Idempotency: header type only, no store.

## Done when

Audit unit test passes. Money maps `1.225` to `1.23`. Event bus delivers in-process.
