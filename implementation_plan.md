# Plan: Firestore `API_BASE_URL` remote config

## Goal
Store `API_BASE_URL` in Firestore (`config/app`), let the Flutter app fetch it at startup, and persist it in local storage for subsequent launches.

## Decisions (confirmed)
- Document: `config/app`
- Field: `API_BASE_URL` (string)
- Rules: public **read** on `config/app` only; all other docs stay deny
- Seed value: `https://api.dev.luxeknox.com` (current `AppConfig` default)
- Local cache: `shared_preferences` (non-secret URL; matches “local storage”)

## Resolution order
1. Cached value from SharedPreferences (if present)
2. Fresh fetch from Firestore `config/app` → overwrite cache when successful
3. Fallback: existing `--dart-define=API_BASE_URL` / `AppConfig` default

Dio must be built **after** this resolution so the first HTTP call uses the correct base URL. On later cold starts, cache keeps the app usable offline; a successful Firestore read refreshes the cache (and Dio `baseUrl` if already created).

## Files

### [MODIFY] `firestore.rules`
Allow `get`/`list` on `/config/app` for unauthenticated clients; keep deny-all elsewhere. Deploy rules.

### [NEW] seed via Firebase CLI / Admin REST
Create document `config/app` with `{ "API_BASE_URL": "https://api.luxeknox.com" }` on project `luxe-knox-app` (host only; the client appends the Nest `/v1` prefix).

### [MODIFY] `app/pubspec.yaml`
Add `cloud_firestore` and `shared_preferences` (compatible with existing `firebase_core`).

### [NEW] `app/lib/core/config/remote_api_base_url_store.dart`
SharedPreferences key wrapper: `read` / `write` for `api_base_url`.

### [NEW] `app/lib/core/config/firestore_app_config_source.dart`
Reads `FirebaseFirestore.instance.doc('config/app')`, returns `API_BASE_URL` string or null on missing/error.

### [NEW] `app/lib/core/config/api_base_url_resolver.dart`
Orchestrates: cache → Firestore → dart-define fallback; returns resolved URL and whether cache was updated.

### [MODIFY] `app/lib/core/config/app_config.dart`
Keep `fromEnv()` as compile-time fallback. Add factory/`copyWith` so bootstrap can inject the resolved `apiBaseUrl` while keeping `environment` from dart-define.

### [MODIFY] `app/lib/main.dart`
Before `configureDependencies()`:
1. `WidgetsFlutterBinding.ensureInitialized()` (already)
2. `Firebase.initializeApp` when `DefaultFirebaseOptions.isConfigured`
3. Resolve `API_BASE_URL` via resolver
4. Register / pass resolved URL into DI

### [MODIFY] `app/lib/core/di/register_module.dart` (+ regenerate `injector.config.dart`)
Stop hard-coding `AppConfig.fromEnv()` alone. Accept bootstrap-resolved `AppConfig` (e.g. `@preResolve` / manual register in `configureDependencies`, or set a static/bootstrap holder read by the module). Prefer: resolve in `main`, then `getIt.registerSingleton<AppConfig>(resolved)` **before** other registrations, or pass URL into an existing bootstrap hook in `injector.dart`.

### [MODIFY] `app/lib/core/network/dio_client.dart` (if needed)
Ensure `baseUrl` can be updated when a background refresh finds a new URL (`dio.options.baseUrl = ...`).

### [NEW] unit tests
- Store round-trip (mock SharedPreferences)
- Resolver: cache hit, Firestore success, Firestore fail → fallback
- Rules/doc path constants covered by source test with fake Firestore if feasible; otherwise mock the source interface

### [MODIFY] `docs/flutter/firebase-luxe-knox-app-setup.md`
Document `config/app`, field name, public-read rule, and seed value.

## Out of scope
- Remote Config product (Firebase Remote Config)
- Per-environment Firestore docs
- Changing Auth / FCM
- Android SHA-1 / Google Sign-In

## Verification
1. Deploy rules + seed doc on `luxe-knox-app`
2. `flutter pub get` + `dart run build_runner build -d` for injectable if DI changes
3. Unit tests for store + resolver
4. `dart analyze` on touched paths
5. Manual: clear app data → launch → confirm prefs contain URL after Firestore read

## Halt
Await approval before edits or deploys.
