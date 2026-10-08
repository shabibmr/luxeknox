# Launch flow review: `main()` → app loaded

Date: 2026-10-08. Scope: the uncommitted working tree and the existing code on the path from `main()` to the first real screen.
Sources: `/code-review high`, plus `/simplify` run from four angles (reuse, simplification, efficiency, altitude).
This is a report only. No code was changed.

## 1. Launch sequence (as it is today)

| # | Step | File | Blocks first frame? |
|---|------|------|---------------------|
| 1 | `WidgetsFlutterBinding.ensureInitialized()` | `main.dart:17` | yes |
| 2 | `Firebase.initializeApp`, then `SharedPreferences.getInstance` (one after the other) | `resolve_remote_app_config.dart:22-28` | yes |
| 3 | Firestore `config/app` read, 2s timeout (runs even when a cached URL exists) | `firestore_app_config_source.dart:24-28` | **yes, up to 2s** |
| 4 | `configureDependencies()`: 22 eager `@singleton`s, including 17 API clients plus serializers | `core/di/register_module.dart` | yes (~10-40ms) |
| 5 | `runApp` → router starts with `SessionUnknown` → `/splash` | `main.dart:20`, `redirect_logic.dart` | — |
| 6 | `FcmMessagingService.start()`, not awaited | `main.dart:21` | no |
| 7 | `SplashScreen.initState` → `SessionCubit.restore()` | `splash_screen.dart:20` | holds splash |
| 8 | restore: read tokens → `getMe` (Dio → `RefreshInterceptor` on 401), with retries after 1s, 2s and 4s | `session_cubit.dart:84-101` | **holds splash up to ~67s** |
| 9 | Authenticated or Unauthenticated → redirect to role home, login, or the `?redirect=` target | `redirect_logic.dart` | — |
| 10 | FCM session listener: token sync, then go to the pending notification path | `fcm_messaging_service.dart:122-148` | no (but moves the user later) |

## 2. Bugs (`/code-review`). P0 and P1 should be fixed before committing.

| ID | Sev | Location | Problem | What to do |
|----|-----|----------|---------|------------|
| B1 | **P0** | `core/network/refresh_interceptor.dart:112` | `/auth/refresh` goes through the same Dio client and is not excluded. If refresh returns 401, its `onError` awaits `_inFlightRefresh`, which is waiting on that same refresh, so it **deadlocks**. Restore depends only on this path, so the splash spins forever (expired access token + revoked refresh token). Verified: `AuthInterceptor` excludes `/auth/refresh`, but `RefreshInterceptor` does not. | Skip the refresh logic for `/auth/refresh`, `/auth/login` and `/auth/firebase` (reuse `AuthInterceptor._excludedPaths` as a shared constant). Add a test for refresh returning 401. |
| B2 | **P0** | `refresh_interceptor.dart:123-129` + `session_repository_impl.dart:144` | Any refresh failure, **including NetworkFailure**, calls `onSignedOut()` and forwards the original 401 as `AuthFailure`. `restore()` then **clears the tokens** while offline, which breaks the "never clear tokens on network errors" rule. | Treat only an `AuthFailure` from refresh as a sign-out. On other failures, forward a NetworkFailure instead of the 401. |
| B3 | P1 | `session_cubit.dart:84-101` | The retry loop has no re-entry guard and ignores `onSignedOut()` emitted halfway through. A later retry can emit Authenticated after the user is already on /login. | Add an in-flight `Future` guard. Abort the retries if the state changed. |
| B4 | P1 | `session_cubit.dart:88` | `UnknownFailure` (500s, mapper bugs) is retried. 4 × (15s connect timeout) + 7s ≈ **67s** on the splash. | Retry only `NetworkFailure`. Cap the total at ~5-8s, or show an "Offline – Retry" splash state. |
| B5 | P1 | `fcm_messaging_service.dart:126-135` | The pending deep link waits for the token sync network call. The user lands on home and is pulled away seconds later. | Navigate first, sync after (or `unawaited`). Better: see S1. |
| B6 | P1 | `main.dart:21` | `unawaited(start())` turns errors from `_initLocalNotifications` / `getInitialMessage` into unhandled zone errors. `_started` stays `true`, so FCM stays half-initialized. | Wrap the body of `start()` in try/catch with logging, and reset `_started` on failure. |
| B7 | P2 | `resolve_remote_app_config.dart:40` | The silent `catch (_)` hides `Firebase.initializeApp` failures. | Log or record the error. |
| B8 | P2 | `redirect_logic.dart:35` | Unknown + `/login?redirect=X` → bare `/splash`, so X is lost. | Pass `fullPath` through for `/login` with a query. |

## 3. Efficiency / startup time (`/simplify`)

| ID | Location | Problem | What to do | Gain |
|----|----------|---------|------------|------|
| E1 | `resolve_remote_app_config.dart`, `api_base_url_resolver.dart` | Firestore read blocks every cold start | **Stale-while-revalidate**: return the cached URL right away, refresh with `unawaited` for the next launch, block only when there is no cache | 0.15-2s |
| E2 | `resolve_remote_app_config.dart:22-28` | Firebase init and prefs run one after the other | `Future.wait` (prefs/cache don't need Firebase) | 10-50ms |
| E3 | `core/di/register_module.dart` | 17 API clients and serializers built eagerly | `@lazySingleton` | 10-40ms |
| E4 | `splash_screen.dart:20` | restore starts only after the first frame | call `getIt<SessionCubit>().restore()` in `main` after DI | 30-100ms |
| E5 | `session_repository_impl.dart:129-130` | 2 secure-storage reads one after the other, repeated on each retry | `Future.wait`, or keep an in-memory cache in `TokenStorage` | 5-30ms each |
| E6 | `fcm_messaging_service.dart:59,127` | `registerOrRotate` POST on every login and cold start, can run twice at once | skip if the token is unchanged; share one in-flight future | 1 request |
| E7 | `fcm_messaging_service.dart:98` | notification permission requested twice (FCM + local plugin) | drop `requestNotificationsPermission` | 1 platform call |

## 4. Simplification / reuse / altitude (`/simplify`)

| ID | Location | Problem | What to do |
|----|----------|---------|------------|
| S1 | `fcm_messaging_service.dart:44,122-148,195-210` | `_pendingNotificationPath` duplicates the router's `?redirect=` parking and the drop on `explicitSignOut` | Always call `_router.go(path)` and let `appRedirectLogic` park and restore it. Delete the pending field, both listener branches and `handleIncomingPushForTest` (also fixes B5) |
| S2 | `redirect_logic.dart:17-30,57-58` | forgot/reset routes hard-coded 3 times; `isRoot` check repeated 3 times | Add `Routes.isPublicAuthPath()` / `Routes.isRecoveryPath()` next to `Routes.isAdminPath`, and a local `isRoot` |
| S3 | `redirect_logic.dart:12-27` + `app_router.dart:45-51` | `currentPath` + nullable `uri` passed separately; `fullPath` built by string concat | Take one required `Uri`; `uri.path` / `uri.toString()` |
| S4 | `redirect_logic.dart:32-66` | Unknown and Unauthenticated branches have extra returns; capability checks repeat `routeAllowsCapabilities` | Flatten the branches (public first, then `explicitSignOut ? login : loginWithRedirect`); reuse `routeAllowsCapabilities` |
| S5 | `firestore_app_config_source.dart:23-40`, `api_base_url_resolver.dart:36-48`, `resolve_remote_app_config.dart:21-43` | 3 nested catch-alls (the resolver's "remote fetch threw" can never fire) | Let the source throw; one catch in the resolver; log Firebase init separately (B7) |
| S6 | `resolve_remote_app_config.dart:17,38,41` | `AppConfigBootstrap.resolved` assigned 3 times; `main` ignores the return value | One assignment, or return `void` |
| S7 | store / source / `normalize` | URL trimmed 3 times | Trim only in `normalize` |
| S8 | `api_base_url_resolver.dart:22-31` | `/v1` appended client-side to make up for bad Firestore data | Fix the Firestore doc, or document "host only, client appends version" as the contract |
| S9 | `session_repository_impl.dart:139-157` | Same `AuthFailure → clear` check in the fold and the catch | One check after `getMe()` |
| S10 | `session_cubit.dart:95-132` | `SessionAuthenticated(...)` fold repeated 3 times | `_emitFrom(result)` helper |
| S11 | `session_cubit.dart:88` | transient test written inline | `Failure.isTransient` getter in `core/error/failures.dart` |
| S12 | `fcm_messaging_service.dart:58-62,126-130` | try/catch around token sync duplicated | Move it inside `_syncTokenIfAuthenticated` |
| S13 | FCM + config `debugPrint`s | Bypasses the `CrashReporter` seam | `CrashReporter.recordError` in FCM; `log` in config |
| S14 | `app_router.dart:22-26` | `asBroadcastStream()` on a Cubit stream that is already broadcast | Remove it |

## 5. Recommended order

1. ✅ **B1 + B2** (refresh interceptor): one file, plus tests. Fixes the forever-hang and the token wipe while offline.
2. ✅ **B3 + B4 + S11**: make restore safe and bounded.
3. ✅ **S1** (also fixes B5 and E6 partly): remove FCM's parallel deep-link parking. **B6**: guard `start()`. (S12 done alongside.)
4. ✅ **E1 + E2 + S5 + S6 + S7 + B7**: rewrite the config bootstrap (stale-while-revalidate, one catch).
5. ✅ **S2 + S3 + S4 + B8**: clean up `redirect_logic`; the existing `redirect_logic_test.dart` covers it.
6. ✅ **E3, E4, E5, E7, S9, S10, S12-S14**: small cleanups. (E6 second half — skip unchanged token re-registration — still open.)
7. **S8**: a data/contract decision for the team. Not a code change by itself.

Known unrelated failures: 3 tests in `test/core/router/exercise_routes_test.dart` (they fail on the base commit too).
