# Vertical 1 — Flutter task register (Exercise Library)

Source: `docs/adr/0007-first-delivery-vertical.md` (Exercise Library is the first delivery
vertical) and `docs/adr/0006-flutter-state-management-and-routing.md` (Clean Architecture ·
`flutter_bloc` · `go_router` · `get_it`). The repo is specification-only — nothing below exists yet.

**Settled decisions this register assumes:**

| Question | Answer | Effect |
| :--- | :--- | :--- |
| Backend timing | **API-first** — endpoints and the OpenAPI document exist before this work starts | Client is generated on day one; no fake data source, no swap-over task |
| Visual source | **Plain Material 3** + a basic LuxeKnox colour/text theme | Screen tasks specify stock widgets; no design matching |
| Screen sizes | **Phone + tablet + desktop**, adaptive from the start | Keeps the rail, master-detail, and width tasks |

Each task is scoped to roughly one file or one tight cluster of files, so it can be handed to a
model in isolation without holding the whole design in its head. Every row gives the files it
creates and a done-when that can be checked without judgment.

---

## Global rules (apply to every task below)

1. Work only inside the files the task names. If another file must change, stop and report it.
2. **Never invent an endpoint, field, or error code.** The API contract is the committed OpenAPI
   document; requirements are `docs/backend-frd.md`. If something needed is absent, stop and report.
3. Layer rules from ADR-0006 are absolute: `domain/` imports no Flutter and no `data/`;
   `presentation/` imports no `data/` and no `package:api_client`; only `data/` may import
   `package:api_client`.
4. Repositories and use cases return `Either<Failure, T>` (`fpdart`). Never throw across a layer.
5. After adding a class with an `injectable` annotation, run
   `dart run build_runner build --delete-conflicting-outputs`.
6. After any change: `dart format .`, `flutter analyze` (zero issues), `flutter test` (all pass).
7. New widgets are `const` where possible and take data through the constructor — no `getIt` calls
   inside widget build methods.
8. UI strings go in one place per feature; no hardcoded strings scattered through widgets.

---

## Phase A — Project & tooling (8 tasks)

Everything here is once-only and blocks all other phases.

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| A1 | Create the Flutter app at `app/`, org `com.luxeknox`, enable android, ios, windows, macos, linux | `app/` | `flutter run -d windows` shows the counter app |
| A2 | Add dependencies: `flutter_bloc`, `go_router`, `get_it`, `injectable`, `fpdart`, `freezed_annotation`, `json_annotation`, `equatable`, `dio`, `flutter_secure_storage`; dev: `build_runner`, `freezed`, `json_serializable`, `injectable_generator`, `mocktail`, `bloc_test`, `flutter_lints`. Pin latest stable of each | `app/pubspec.yaml` | `flutter pub get` succeeds with no version conflicts |
| A3 | Lint config: enable `flutter_lints` plus `prefer_const_constructors`, `require_trailing_commas`, `always_declare_return_types`; exclude `**/*.g.dart`, `**/*.freezed.dart` | `app/analysis_options.yaml` | `flutter analyze` returns zero issues |
| A4 | Create the empty folder skeleton from ADR-0006 §9, each leaf holding a `.gitkeep` | `app/lib/**` | Tree matches ADR-0006 §9 exactly |
| A5 | Environment config read via `--dart-define`: `API_BASE_URL`, `ENV`; expose through `AppConfig.fromEnv()` with a compile-time default for dev | `app/lib/core/config/app_config.dart` | Running with a different `--dart-define` changes `AppConfig.apiBaseUrl` |
| A6 | CI workflow: `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test` | `.github/workflows/app-ci.yml` | Workflow passes on a clean checkout |
| A7 | CI layering checks — three greps that must return no matches: `presentation/` referencing `data/`; `domain/` importing `package:flutter`; `presentation/` or `domain/` importing `package:api_client` | `.github/workflows/app-ci.yml`, `tool/check_layers.sh` | Script exits 0 now, and exits 1 when a deliberate violation is added |
| A8 | Script wrapping `build_runner` in watch and one-shot modes | `tool/gen.sh` | `bash tool/gen.sh` regenerates without errors |

## Phase B — Generated API client (3 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| B1 | Generate a Dart package from the committed OpenAPI document using `openapi-generator` with the `dart-dio` generator, output `packages/api_client/` | `packages/api_client/`, `tool/gen_api.sh` | Package analyzes clean and exposes an exercises API class and an auth API class |
| B2 | Add `api_client` as a path dependency of the app | `app/pubspec.yaml` | `import 'package:api_client/api_client.dart';` resolves inside `data/` |
| B3 | Document the regeneration step and commit policy in a short README | `packages/api_client/README.md` | README states the source document, the command, and that generated files are committed and never hand-edited |

## Phase C — Core contracts (4 tasks)

No dependencies beyond Phase A. Safe to run in parallel.

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| C1 | `Failure` types exactly matching the ADR-0006 §3 table: `ValidationFailure(details)`, `AuthFailure`, `PermissionFailure`, `NotFoundFailure`, `ConflictFailure`, `BusinessRuleFailure(message)`, `RateLimitFailure`, `NetworkFailure`, `UnknownFailure` | `core/error/failures.dart` | Each type exists, extends a common sealed `Failure`, and has value equality |
| C2 | `UseCase<Out, In>` contract from ADR-0006 §2 plus a `NoParams` type | `core/usecase/usecase.dart` | Compiles; `call` returns `Future<Either<Failure, Out>>` |
| C3 | `failureMessage(Failure)` returning a user-facing string for each type; `BusinessRuleFailure` returns its server message verbatim (per ADR-0006 §3) | `core/error/failure_messages.dart` | Every `Failure` subtype returns a non-empty string; switch is exhaustive |
| C4 | Generic `CursorPage<T>` holding `items`, `nextCursor`, `hasMore` | `core/pagination/cursor_page.dart` | Compiles and has value equality |

## Phase D — Network layer (6 tasks)

D3 depends on C1. D5 depends on E1.

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| D1 | Configure the `Dio` instance: base URL from `AppConfig`, 15s connect / 20s receive timeouts, JSON content type | `core/network/dio_client.dart` | A request to a stub URL uses the configured base URL |
| D2 | Attach `Authorization: Bearer <access token>` to every request except `/auth/login` and `/auth/refresh` | `core/network/auth_interceptor.dart` | Header present on a normal call, absent on login |
| D3 | Translate errors into `Failure`: read `{code, message, details, request_id}` per FRD §5.2, map by `code` first then HTTP status; timeouts and socket errors become `NetworkFailure` | `core/network/error_interceptor.dart` | Unit test maps all seven FRD codes plus a timeout correctly |
| D4 | On a 401, refresh once, queue concurrent failures, retry them, and emit a signed-out signal if refresh fails. Never refresh more than once at a time | `core/network/refresh_interceptor.dart` | Test with three concurrent 401s issues exactly one refresh call |
| D5 | Log method, path, status and `request_id` on failures only. **Never log tokens** | `core/network/logging_interceptor.dart` | Failure log line includes `request_id`; no token appears in output |
| D6 | Assemble the interceptor chain in the right order: auth → refresh → error → logging | `core/network/dio_client.dart` | A forced 401 in an integration test triggers refresh, then succeeds |

## Phase E — Storage & dependency injection (3 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| E1 | Token store on `flutter_secure_storage` with `read`/`write`/`clear` for access and refresh tokens. **Never `SharedPreferences`** (ADR-0006) | `core/storage/token_storage.dart` | Round-trip test passes on a device or emulator |
| E2 | `get_it` + `injectable` bootstrap with `configureDependencies()` | `core/di/injector.dart`, `injector.config.dart` | `configureDependencies()` runs with no missing-registration error |
| E3 | Register `Dio`, `TokenStorage`, `AppConfig` and the router as singletons per ADR-0006 §8 | `core/di/register_module.dart` | `getIt<Dio>()` returns the configured instance |

## Phase F — Session (7 tasks)

The first full vertical slice through all three layers — **this is the template every later
feature copies.** Review it carefully before Phase I starts; a flaw here propagates to all sixteen
modules.

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| F1 | `Principal` entity: user id, user type, display name, profile id | `session/domain/entities/principal.dart` | Pure Dart, no Flutter import, value equality |
| F2 | `Capabilities` value object wrapping the permission slug list with `can(String slug)` (ADR-0006 §7) | `session/domain/entities/capabilities.dart` | `can('exercises.update')` is true only when the slug is present |
| F3 | Abstract `SessionRepository`: `login`, `logout`, `refresh`, `getMe`, `restore` | `session/domain/repositories/session_repository.dart` | All methods return `Future<Either<Failure, …>>` |
| F4 | Five use cases, one file each | `session/domain/usecases/*.dart` | Each implements `UseCase`; each has a unit test with a mocked repository |
| F5 | Remote data source over the generated auth API, plus model↔entity mappers | `session/data/…` | Generated types appear nowhere outside these files |
| F6 | `SessionRepositoryImpl` — calls the data source, stores tokens on login, clears them on logout | `session/data/repositories/session_repository_impl.dart` | Login writes both tokens; logout clears both |
| F7 | `SessionCubit` with states `unknown`, `authenticated(Principal, Capabilities)`, `unauthenticated`; starts in `unknown` and resolves on `restore()` | `session/presentation/session_cubit.dart` | `bloc_test` covers restore-success, restore-failure, login, and logout |

## Phase G — Routing & app shell (9 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| G1 | All route paths as constants, copied exactly from `docs/screens/navigation-architecture.md` §2–4 | `core/router/routes.dart` | No route string is written anywhere else in the app |
| G2 | `GoRouter` instance driven by `SessionCubit` through `refreshListenable` | `core/router/app_router.dart` | Logging out redirects to `/login` with no imperative navigation |
| G3 | **Exactly one** `redirect`: unauthenticated check first, then role home. Never more than one (ADR-0006 flags redirect loops) | `core/router/app_router.dart` | Test covers signed-out, signed-in-wrong-role, and signed-in-correct-role |
| G4 | Member branch: 5 tabs — Home, Membership, Schedule, Progress, Profile | `core/router/member_routes.dart` | All five tabs reachable, each keeping its own stack |
| G5 | Trainer branch: Home, Members, Schedule, Plans, Profile | `core/router/trainer_routes.dart` | As above |
| G6 | Admin branch: Dashboard, Members, Memberships, Payments, More — with `/admin/workout-library` under More | `core/router/admin_routes.dart` | As above; exercise library reachable from More |
| G7 | Adaptive shell: bottom bar under 600dp, `NavigationRail` 600–1239dp, extended rail at 1240dp and above | `core/widgets/adaptive_shell.dart` | Resizing the desktop window swaps the navigation style without losing the tab stack |
| G8 | Placeholder screen widget, used for all 15 tab roots so the shell runs before features exist | `core/widgets/placeholder_screen.dart` | Every tab in every role opens without error |
| G9 | `context.can('slug')` extension over `SessionCubit`, using `context.select` so only affected widgets rebuild | `core/extensions/capability_extension.dart` | Widget test shows a button appearing for admin and absent for member |

## Phase H — Login & bootstrap (5 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| H1 | Splash screen shown while `SessionCubit` is `unknown`; calls `restore()` on start | `features/auth/presentation/screens/splash_screen.dart` | Cold start with a stored token lands on the role home, not login |
| H2 | `LoginCubit` with `idle`, `submitting`, `failure` states | `features/auth/presentation/cubit/login_cubit.dart` | `bloc_test` covers success and each failure type |
| H3 | Login screen: one identifier field (email **or** phone, per FR-AUTH-001), password field with show/hide, submit button | `features/auth/presentation/screens/login_screen.dart` | Empty fields are rejected client-side; submit is disabled while in flight |
| H4 | Map login errors to messages: wrong credentials, suspended account (FR-AUTH-002 — **must not reveal whether the user exists**), rate limited (429) | `features/auth/presentation/screens/login_screen.dart` | Wrong-password and unknown-user show the identical message |
| H5 | Sign-out action on the Profile tab, with a confirm dialog | `features/auth/presentation/widgets/sign_out_tile.dart` | Confirming clears tokens and lands on login |

## Phase I — Exercises: domain (4 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| I1 | `Exercise` entity with the FR-WORK-001 fields: name, primary muscle group, secondary muscles, equipment needed, instructions, video url, gif url, difficulty level, is active | `features/exercises/domain/entities/exercise.dart` | Pure Dart, value equality, no Flutter import |
| I2 | `ExerciseFilter` value object: search text, muscle group, equipment, difficulty (FR-WORK-002) | `features/exercises/domain/entities/exercise_filter.dart` | Has a `copyWith` and an `isEmpty` |
| I3 | Abstract `ExerciseRepository`: `getExercises(filter, cursor)`, `getExercise(id)`, `create`, `update`, `deactivate` | `features/exercises/domain/repositories/exercise_repository.dart` | List method returns `Either<Failure, CursorPage<Exercise>>` |
| I4 | Five use cases, one file each, each with a unit test | `features/exercises/domain/usecases/*.dart` | All implement `UseCase`; tests use a mocked repository |

## Phase J — Exercises: data (3 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| J1 | Remote data source calling `GET/POST /exercises` and `GET/PATCH /exercises/{id}` through the generated client | `features/exercises/data/datasources/exercise_remote_datasource.dart` | Filters and cursor are passed as query parameters |
| J2 | Mapper between the generated model and the domain entity, both directions | `features/exercises/data/models/exercise_model.dart` | Round-trip test preserves every field |
| J3 | `ExerciseRepositoryImpl` returning `Either`, wrapping data-source errors as `Failure` | `features/exercises/data/repositories/exercise_repository_impl.dart` | No exception escapes; test covers success and each failure |

## Phase K — Exercises: presentation (11 tasks)

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| K1 | `ExerciseListBloc` events and `freezed` state shaped per ADR-0006 §5 — one class with a status field, not a sealed union | `features/exercises/presentation/bloc/…` | State carries items, filter, cursor, hasMore, failure |
| K2 | Apply the `debounce` transformer to the search event (ADR-0006 §4), 300ms | `features/exercises/presentation/bloc/exercise_list_bloc.dart` | Test proves rapid typing fires exactly one request |
| K3 | Pagination: append the next page on scroll-to-end, never lose the visible list while loading | `features/exercises/presentation/bloc/exercise_list_bloc.dart` | `bloc_test` shows items retained through a loading state |
| K4 | Exercise list item widget: name, muscle group, equipment, difficulty badge | `features/exercises/presentation/widgets/exercise_list_item.dart` | Renders from an `Exercise` with no data fetching inside |
| K5 | Exercise Library screen (screen 29): search field, filter chips, list, empty and error states, pull to refresh | `features/exercises/presentation/screens/exercise_library_screen.dart` | Member and trainer see browse only; admin also sees an add button |
| K6 | Filter sheet: muscle group, equipment, difficulty, with clear-all | `features/exercises/presentation/widgets/exercise_filter_sheet.dart` | Applying a filter re-queries; clearing restores the full list |
| K7 | `ExerciseDetailCubit` and state | `features/exercises/presentation/cubit/exercise_detail_cubit.dart` | `bloc_test` covers load success, not-found, and network failure |
| K8 | Exercise Details screen (screen 30): instructions, primary and secondary muscles, equipment, difficulty | `features/exercises/presentation/screens/exercise_detail_screen.dart` | Opens as a push on phone; admin sees edit, others do not |
| K9 | Media widget for the video and gif links, with loading, broken-link, and no-link states (links are external per ADR-0005) | `features/exercises/presentation/widgets/exercise_media.dart` | A deliberately broken URL shows a fallback, never a crash |
| K10 | Create/edit form with validation, admin-only via `context.can('exercises.create'/'exercises.update')`, plus deactivate with a confirm dialog | `features/exercises/presentation/screens/exercise_form_screen.dart` | Non-admin cannot reach the route; validation blocks an empty name |
| K11 | Master-detail layout at 840dp and above: list on the left, detail on the right instead of a push | `features/exercises/presentation/screens/exercise_library_screen.dart` | Phone pushes a detail page; desktop shows a side pane |

## Phase L — Tests (9 tasks)

L8 is the one that matters most — see Verification.

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| L1 | Test harness: `mocktail` mocks, exercise fixtures, and builders for a member, trainer, and admin principal | `test/helpers/…` | Any test can construct a seeded `SessionCubit` in one line |
| L2 | Error-interceptor tests covering all seven FRD §5.2 codes plus timeout and socket error | `test/core/network/error_interceptor_test.dart` | Nine cases pass |
| L3 | Refresh-interceptor tests: single refresh, concurrent queueing, refresh failure signs the user out | `test/core/network/refresh_interceptor_test.dart` | Three cases pass |
| L4 | `SessionCubit` tests | `test/session/session_cubit_test.dart` | Restore, login, logout, and suspension covered |
| L5 | Router redirect tests, including a guard against redirect loops | `test/core/router/app_router_test.dart` | Signed-out, wrong-role, and correct-role cases pass |
| L6 | Exercise use-case tests | `test/features/exercises/domain/…` | All five covered with a mocked repository |
| L7 | `ExerciseListBloc` tests: debounce, pagination, filter change, failure | `test/features/exercises/presentation/exercise_list_bloc_test.dart` | Four cases pass |
| L8 | **Role-variant widget tests** for the Exercise Library and Details screens under a member, trainer, and admin principal (ADR-0006 §11) | `test/features/exercises/presentation/exercise_role_variants_test.dart` | Six tests: admin sees add/edit/deactivate, member and trainer see none |
| L9 | Golden tests for the library screen at 390dp and 1280dp | `test/goldens/…` | Goldens committed and stable across two consecutive runs |

## Phase M — Build & release (3 tasks)

Android/iOS signing and release builds, and desktop window config, are out of scope for this
register (require real credentials, a physical device, or platform accounts not available here).

| ID | Task | Creates | Done when |
| :--- | :--- | :--- | :--- |
| M1 | App icon and splash from the LuxeKnox branding, all platforms | `app/assets/`, platform folders | Icon correct on a real Android and iOS device |
| M2 | App display name, bundle identifiers, and a version scheme | Platform config files | `flutter build` produces correctly named artifacts |
| M6 | Crash reporting wired to the chosen service, with the release build symbolicated | `core/monitoring/` | A forced test crash appears in the dashboard |

---

## Verification

Run in order; each step gates the next.

1. **Static:** `dart format --set-exit-if-changed .`, `flutter analyze` (zero issues),
   `bash tool/check_layers.sh` (exits 0).
2. **Layering is real, not aspirational:** temporarily add `import '../data/…';` to a presentation
   file and confirm `check_layers.sh` **fails**. Revert. A check that has never failed has not been
   tested.
3. **Unit and widget:** `flutter test` — all pass, including the nine error-mapping cases and the
   concurrent-refresh case.
4. **Role variants (L8) — the acceptance gate for the vertical.** Six tests must pass: the library
   and detail screens rendered as member, trainer, and admin, asserting that create, edit and
   deactivate controls appear **only** for admin. The entire 141→44 screen consolidation rests on
   these staying green; if a screen turns out to need per-role forks, this vertical is where that
   must surface.
5. **Manual, against the live API:** sign in as each of the three roles; confirm each sees its own
   five tabs; browse and search the library; confirm admin can create, edit and deactivate while the
   others cannot; deep-navigate one tab, switch tabs, switch back, confirm the stack survived.
6. **Adaptive:** run on desktop, resize from narrow to wide, confirm bottom bar → rail → extended
   rail and push → side pane, with no state loss.
7. **Token lifecycle:** let an access token expire, make a request, confirm exactly one refresh and
   a successful retry; then revoke the session server-side and confirm the app lands on login.

---

## Notes

- **63 tasks. Roughly 40 are once-only.** Vertical 2 (the food library) repeats only Phases I, J, K
  and L6–L9 with different labels. ADR-0007 designates that vertical as the checkpoint: if it is not
  dramatically faster, the template is wrong and should be fixed before more features land on it.
- **Phase F is the reference implementation.** It is the first slice through all three layers, and
  every later feature is copied from its shape. It is worth a careful human review before Phase I
  begins, because a flaw there propagates to all sixteen modules.
- **Deliberately excluded:** anything requiring file upload. ADR-0005 defers `MEDIA`, so exercise
  video and gif are external links an admin pastes (K9). No avatars, no documents, no progress
  photos in this vertical.
- **Model routing (Haiku vs. a stronger model):** most of Phases A, C, I, J, and the bulk of K are
  safe for a smaller model — one file, a stated pattern, a pass/fail check. Route these to a
  stronger model instead: D4/D6 (refresh-interceptor concurrency), all of Phase F (the template
  every later module copies — a flaw here is expensive), G3/G7/K11 (redirect-loop safety and
  `StatefulShellRoute` adaptive layout), and L8/L9 (the acceptance gate and goldens, which need to
  assert the right thing, not just pass). M6 is not a model task at all — it needs a crash-reporting
  account and a real release build to verify against.
- **Open gap, not yet decided:** K9 assumes exercise video links are playable inline, but ADR-0005
  only says "an externally hosted URL" — a YouTube link and a raw `.mp4` need different playback
  handling. Settle this before K9 starts; otherwise whichever model picks it up will guess.
