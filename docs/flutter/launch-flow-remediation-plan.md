# Launch flow: remediation plan

Date: 2026-10-09. Follows `launch-flow-review.md` (first pass, all items done) and the `/code-review xhigh` of `HEAD~1`.
I re-read every cited location in the current code before writing this plan.

## 1. Verdict: patch the current code, don't redo the architecture

The structure is sound:

- `main()` resolves config, builds DI, starts `SessionCubit.restore()` unawaited, then `runApp`.
- The router redirects on `SessionState`.
- FCM runs off the critical path.

The remaining problems are local: ordering, error scope, cancellation and one contract. None needs a new design.

One part is a bounded refactor, not a patch: **FCM startup** (Phase 2). It mixes listener registration, token sync and initial-message handling in one fallible chain, and that causes three of the bugs.

## 2. Findings, re-verified against the code

| ID | Sev | Verified at | Problem |
|----|-----|-------------|---------|
| N1 | P1 | `fcm_messaging_service.dart:70` | `await _syncTokenIfAuthenticated()` (network, up to ~35s) runs before the foreground/opened/token-refresh listeners and local-notification init. Foreground pushes are dropped and the cold-start deep link is late. This re-creates the B5 symptom. |
| N2 | P1 | `fcm_messaging_service.dart:55-59` | Any throw in `_start()` calls `dispose()`, which cancels every listener, including the working session listener. `start()` has one caller (`main`), so the "a later start can try again" comment is false. Push stays dead until restart. |
| N3 | P1 | `session_cubit.dart:100` + `session_repository_impl.dart:144` | `.timeout()` abandons the restore future but does not cancel it. A late `AuthFailure` still runs `_tokenStorage.clear()`, which can wipe the tokens of a login completed after the timeout. |
| N4 | P1 | `resolve_remote_app_config.dart:23` | With Firebase unconfigured, the raw dart-define URL is returned un-normalized, so a host-only URL gets no `/v1` and every call 404s. The documented contract does not hold on this path. |
| N5 | P2 | `api_base_url_resolver.dart:24-31` vs `docs/flutter/firebase-luxe-knox-app-setup.md:23`, `implementation_plan.md`, `deploy/build.sh` | Contradicting docs: the setup doc says Firestore holds `.../v1`, the S8 comment says host only. Both work only because `normalize` is idempotent. |
| N6 | P2 | `api_base_url_resolver.dart:36-43` | The doc says a `/v1` value is "accepted unchanged", but a trailing slash or whitespace is stripped. `.../v2` becomes `/v2/v1`. `/` becomes `/v1`, which is non-empty and so gets cached. |
| N7 | P2 | `failures.dart:12` | `isTransient` is only `NetworkFailure`. A 502/503 during an API restart or a 429 is not retried, so valid-token users land on login. |
| N8 | P2 | `resolve_remote_app_config.dart:27-30` | Only `_initFirebase` is guarded. `SharedPreferences.getInstance()` failing surfaces as a `ParallelWaitError` and aborts `main()` before `runApp` (blank screen), though a fallback URL exists. |
| N9 | P2 | `device_token_service.dart:75-123`, `fcm_messaging_service.dart:140-145` | `syncToken` dedups only by the same `userId\|token`. A refresh during an in-flight sync for the old token starts a second concurrent registration, and the older one can finish last and overwrite device id and marker. `userId` is captured before `await getToken()`, so a user switch in between records the marker under the wrong user. |
| N10 | P3 | `fcm_push_token_provider.dart`, `NoOpCrashReporter` | Logs moved to `CrashReporter` may be dropped in release (`NoOpCrashReporter` logs only in debug). **Check `crash_reporter.dart` before acting**; I have not confirmed the no-op's behavior myself. |
| N11 | P3 | `main.dart:20`, `test/widget_test.dart` | Restore moved from `SplashScreen` to `main()` and the `verify(restore())` test was deleted. Nothing guards the wiring, so removing the line leaves a permanent splash. |

## 3. Plan

Each phase is one commit, tests alongside, in this order (highest user impact first).

### Phase 1: session restore safety (N3, N7, N11)
- Make restore cancellable without a new dependency. Add an `isCancelled` guard (a generation counter on `SessionCubit`) passed into the use case or checked by the repository before it clears tokens. `SessionRepositoryImpl.restore()` must not clear tokens when the restore was superseded.
  - Simplest option: `restore()` on the repository takes a `bool Function() isStale`. Clear tokens only if `!isStale()`.
- Widen `isTransient` to include network errors, 429 and 502/503/504. This needs `mapThrownToFailure` to expose the status. Add a `ServerUnavailableFailure` subtype, or a `retryable` flag on `UnknownFailure`. The existing `restoreTimeout` still bounds the total.
- Add a launch-wiring test: pumping `LuxeKnoxApp`/`main` wiring resolves `SessionUnknown`. Or move the `restore()` call into a small `bootstrap()` function that the test can call.
- Tests: late `AuthFailure` after timeout does not clear tokens; a 503 is retried then succeeds; `bootstrap()` triggers restore.

### Phase 2: FCM startup restructure (N1, N2, N9, N10)
Split `_start()` into independent steps, each with its own try/catch:
1. Register the session listener, then listeners for foreground, opened-app and token refresh as soon as `ensureStarted()` reports live. Do this **before** any network call.
2. Local-notification init: its failure only disables foreground display. Log it and continue.
3. Token sync: `unawaited`, error-contained (it already is, inside `_syncTokenIfAuthenticated`).
4. `getInitialMessage()`: guarded on its own, so its failure never tears down the listeners.
5. Delete the `dispose()` call on failure. Keep `_started = true` once the listeners are registered, and fix the comment.
- `_syncTokenIfAuthenticated`: read `userId` **after** `await getToken()` (or re-check `_sessionCubit.state` afterwards) so a user switch cannot record the marker under the wrong user.
- `DeviceTokenService.syncToken`: serialize syncs per device. Chain onto the previous in-flight sync (a single `Future` tail) instead of keying by marker, so the last call always wins. Alternatively drop a stale result by comparing a monotonic sequence number before writing the device id and marker.
- N10: if `NoOpCrashReporter` drops logs in release, keep `CrashReporter` for errors but log FCM init failures through whatever sink release builds do have. Decide after reading the file.
- Tests: sync that never completes does not block `onMessage`; `getInitialMessage` throwing leaves the listeners live; overlapping refresh syncs end with the newest token's marker; a user switch mid-`getToken` does not mark the wrong user.

### Phase 3: config bootstrap and URL contract (N4, N5, N6, N8)
- **Decide the contract** (my recommendation: host only, client appends `/v1`, which keeps what S8 documented). Then apply it everywhere:
  - Normalize in one place, `resolveRemoteAppConfig`, on every path including the Firebase-unconfigured early return (N4).
  - Fix `docs/flutter/firebase-luxe-knox-app-setup.md`, `implementation_plan.md` and `deploy/build.sh` to say host only. Check which of these are real instructions before editing.
  - Confirm the live Firestore value by reading it. I have not checked it; the earlier "no data change needed" is an assumption.
- Tighten `normalize` (N6): strip a trailing `/v1` or `/v1/` and re-append, so the output is stable. Treat a result that is empty after stripping slashes (such as `/`) as blank. Reject, or at least don't cache, values without a scheme.
  - Fix the doc comment to match the real behavior ("canonicalized", not "unchanged").
  - Leave a non-`/v1` version suffix (`/v2`) as an explicit decision: either fail fast or leave it untouched. Don't produce `/v2/v1`.
- N8: wrap `SharedPreferences.getInstance()` so a failure falls back to `normalize(fallbackUrl)` with the store disabled. Never abort `main()` on config.
- Tests: Firebase unconfigured + host-only define gets `/v1`; `/`, whitespace, `/v2` and trailing-slash cases; prefs failure still reaches `runApp` with the fallback URL.

### Phase 4: housekeeping
- Update `launch-flow-review.md` §5 (it says S8 needs "no data change", which Phase 3 must verify) and link this plan.
- Run the full `flutter test` and `flutter analyze`. Known unrelated failures: 3 tests in `exercise_routes_test.dart`.

## 4. Out of scope
- Replacing `SessionCubit`, the router redirect logic or DI. They hold up under review.
- The P.T Selection Builder. It is a different change and needs its own review once its code is located.

## 5. Decisions (2026-10-09)
1. URL contract: **host only**; the client appends `/v1`. Phase 3 fixes the docs that say otherwise.
2. A new failure type (or `retryable` flag) for 5xx/429 is approved (N7).
3. A restore that times out **keeps going to login**; no retry screen.

## 6. Status (2026-10-09)
- Phase 1 (N3, N7, N11): done. Late restore failures no longer clear newer tokens; 502/503/504 and 429 are retried; `startSessionRestore()` is tested.
- Phase 2 (N1, N2, N9): done. N10 confirmed: `NoOpCrashReporter` drops all logs in release until a vendor is wired.
- Phase 3 (N4, N5, N6, N8): done. `normalize` applies on every path, is stable, and leaves `/vN` suffixes alone; a prefs failure falls back to the dart-define URL (no unit test: the path needs a seam around `SharedPreferences`). Docs and `deploy/build.sh` now say host only.
- Open: read the live Firestore `config/app` value to confirm it is a host or `/v1` URL.
