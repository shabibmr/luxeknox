# Phase 0 Foundation — status (2026-09-21)

## Already complete (verified in codebase)
- DI/injectable (`core/di/`)
- Dio base URL + timeouts (`dio_client` 15s/20s)
- 401 refresh concurrency (`refresh_interceptor` + tests)
- Typed error mapping (`failures` / `error_interceptor` / `failure_messages`)
- Pagination `CursorPage` (+ new `PageRequest`)
- Environment config (`AppConfig` via `--dart-define`)
- Architecture CI (`tool/check_layers.sh` + `app-ci.yml` layering job)

## Newly implemented this pass
- Common widgets: `AppLoading`, `AppErrorView`, `AppEmptyView`
- Material 3 `AppTheme` light/dark wired in `main.dart`
- Localization: `l10n.yaml`, `app_en.arb`, gen-l10n, `AppLocaleConfig`, Material delegates
- Form `Validators` helpers
- Test fixtures (`PrincipalFixtures`) + `pumpApp` helper
- Architecture audit doc; register + split checklists updated (`[x]`); literal `\n` docs fixed; `18-` / `99-` extracted

## Verify
- `flutter analyze` (changed paths): No issues
- Focused tests: **43 passed**
- `check_layers.sh`: OK

## Phase 0 remaining
Checklist items are complete. Optional follow-ups: migrate feature `_ErrorView`/spinners to shared widgets; expand ARB locales; adopt `Validators` in existing forms.

## Recommended next
**Phase 1 — Identity & People** (Auth completion + People/Profile vertical).
