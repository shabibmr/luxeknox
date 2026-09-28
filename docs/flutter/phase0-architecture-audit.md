# Phase 0 — Architecture audit (Foundation)

**Date:** 2026-09-21  
**Scope:** `app/lib` Clean Architecture vs ADR-0006

## Verdict

Foundation networking, DI, session, errors, pagination, and layer CI are in place. Remaining product work is feature verticals (Phase 1+), not core plumbing.

## Inventory (present)

| Area | Location | Notes |
|------|----------|--------|
| DI | `core/di/` | get_it + injectable; `configureDependencies` covered by tests |
| Config | `core/config/app_config.dart` | `--dart-define` ENV + API_BASE_URL |
| Dio | `core/network/dio_client.dart` | 15s connect / 20s receive timeouts |
| Auth header | `core/network/auth_interceptor.dart` | Bearer from secure storage |
| 401 refresh | `core/network/refresh_interceptor.dart` | Single in-flight refresh + retry |
| Typed errors | `core/error/` + `error_interceptor.dart` | Sealed `Failure` + message mapping |
| Pagination | `core/pagination/` | `CursorPage` + `PageRequest` |
| Common UI | `core/widgets/app_*.dart` | Loading / error / empty |
| Theme | `core/theme/app_theme.dart` | Material 3 light/dark |
| L10n hooks | `l10n.yaml`, `lib/l10n/`, `AppLocaleConfig` | gen-l10n + delegates |
| Validation | `core/validation/validators.dart` | Shared field validators |
| Layer CI | `tool/check_layers.sh` + `app-ci.yml` | presentation↛data, domain↛flutter/api_client |
| Test fixtures | `test/fixtures/`, `test/helpers/pump_app.dart` | Shared principals + pump helper |

## Layer boundaries

Enforced by `tool/check_layers.sh` (CI job `layering-check`):

1. `presentation/` must not import `data/`
2. `domain/` must not import `package:flutter`
3. `presentation/` and `domain/` must not import `package:api_client`

## Gaps deferred (not Phase 0 blockers)

- Migrate feature `_ErrorView` / inline spinners to shared widgets (incremental)
- Expand ARB beyond English shell strings
- Wire `Validators` into existing login/forms (optional cleanup)
