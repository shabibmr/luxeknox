# M0-17 — SettingsService

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-12, M0-16 |
| **Files** | 5 |

## Files

- `apps/api/src/sys/settings.repository.ts`
- `apps/api/src/sys/settings.service.ts`
- `apps/api/src/sys/settings.service.spec.ts`
- `apps/api/src/sys/sys.module.ts`
- `apps/api/src/app.module.ts`

## Work

`SettingsService` is the only reader of `gym_settings` (ADR-0004). No upsert API.

## Done when

Service returns seeded timezone and page size.
