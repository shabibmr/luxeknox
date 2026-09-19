# Vertical 1 — two-axis code review

**Date:** 2026-09-16  
**Fixed point:** `HEAD` `06953860cfab0034282732ae25ed3a79233bad10`  
**Commits `06953860..HEAD`:** none (empty)  
**Diff:** Flutter is entirely untracked vs HEAD. Reviewed working-tree files under `app/`, `packages/api_client/`, `tool/{check_layers,gen,gen_api}.sh`, `.github/workflows/app-ci.yml`.  
**Spec:** `flutter-todo/vertical-1-flutter-tasks.md` (cited ADRs 0006/0007, `docs/screens/navigation-architecture.md`, FRD §5.2).  
**Standards sources:** Global rules in the spec; `docs/adr/0006-flutter-state-management-and-routing.md`; `app/analysis_options.yaml`; `tool/check_layers.sh`; Fowler smell baseline (judgement only).

Axes are separate. Findings are not merged or ranked across axes.

---

## Standards

**Hard — documented standards**

`app/lib/core/di/register_module.dart`, `injector.config.dart` — ADR-0006 §8 / E3: only `AppConfig`, `FlutterSecureStorage`, `TokenStorage`, `Dio` are `@singleton`. No router, no `SessionCubit` `@singleton`, no `@LazySingleton` data sources/repos/use cases, no `@injectable` factory for `ExerciseListBloc` / `ExerciseDetailCubit`. `AUTHApi`/`WORKApi` unregistered. `Dio` is `createDioClient` (bare), not `configureDioClient` — interceptors never attach in DI (D6).

`app/lib/main.dart` — ADR-0006 §6/§8: still `MaterialApp` counter; no `configureDependencies()`, no `MaterialApp.router` / `SessionCubit`.

`app/lib/features/exercises/presentation/bloc/exercise_list_state.dart` — K1 + ADR-0006 §5: Equatable + hand `copyWith`, not `@freezed`. No `@freezed` anywhere (`app/lib`).

`app/lib/core/router/{member,trainer,admin}_routes.dart`, `placeholder_screen.dart` (`'Coming Soon'`), `app_router.dart` titles — Global rule 8: UI strings not one place per feature.

`app/lib/core/network/logging_interceptor.dart` — D5: `logFunction(..., error: err)` forwards full `DioException` (request headers / `Authorization`).

Layering, Either at repo/use-case, no `getIt` in widgets, no `api_client` outside `data/`, no Flutter in `domain/`, `analysis_options.yaml`, `check_layers.sh` + `app-ci.yml` greps: OK. Data-source `throw DioException` is caught in the same `data/` layer.

Cubit vs Bloc: list `Bloc`+debounce, detail/`SessionCubit`: ADR-0006 §4. Session sealed states match F7 (not §5 list-state). One `redirect` in `createRouter`.

**Judgement (smells; standard wins if conflict)**

- **Duplicated Code:** `_mapError` in `session_repository_impl.dart` and `exercise_repository_impl.dart`. Tab labels (`'Home'`, `'Profile'`, …) copied across three route files.
- **Divergent Change:** `dio_client.dart` ships two factories; production DI uses the interceptor-less one.
- **Speculative Generality:** `exercise_list_bloc.dart` ~80-line custom debounce/`switchMap` instead of a shared transformer.
- **Middle Man:** thin use cases — **keep**; ADR-0006 §2 overrides.
- **Primitive Obsession:** `Principal.userType` as `String` (`redirect_logic.dart` `toLowerCase()` + switch).

`redirect_logic.dart` checks `SessionUnknown` before unauthenticated; G3/ADR-0006 §6 say unauthenticated first — splash makes unknown-first reasonable, not a loop.

---

## Spec

**(a) Missing / partial**

- **A4:** No `.gitkeep` anywhere. Extra empty leaves vs ADR-0006 §9: `app/lib/features/auth/**`, `app/lib/core/monitoring/`.
- **E3:** `Register Dio, TokenStorage, AppConfig and the router as singletons` — router unregistered; `Dio` is `createDioClient` with **no interceptors** (`register_module.dart`, `injector.config.dart`). Use cases/Blocs/`SessionCubit` have no `@injectable`.
- **G2/G8/H1–H5:** `main.dart` is still the counter `MaterialApp` (not `GoRouter`). Missing: `splash_screen.dart`, `login_cubit.dart`, `login_screen.dart`, `sign_out_tile.dart`. Login/splash routes use `PlaceholderScreen`.
- **G9:** `capability_extension.dart` exists; **no** widget test (`button appearing for admin and absent for member`).
- **K4–K6, K8–K11:** Named files absent; `presentation/screens/` and `widgets/` empty (`exercise_list_item.dart`, `exercise_library_screen.dart`, `exercise_filter_sheet.dart`, `exercise_detail_screen.dart`, `exercise_media.dart`, `exercise_form_screen.dart`).
- **L1, L8, L9:** `test/helpers/`, `exercise_role_variants_test.dart`, `test/goldens/` do not exist.
- **L4:** `Restore, login, logout, and suspension covered` — `session_cubit_test.dart` has no suspension case; cubit has no suspended state.
- **M1/M2/M6:** No `app/assets/`; labels still `app`/`App`; `core/monitoring/` empty.
- **Verification 4–7:** L8 gate missing; no role UI; DI never attaches refresh; app never boots session/router.

**(b) Scope creep**

- Extra: `redirect_logic.dart`, `FailureDioException`, empty auth tree, `AppEnvironment`, `SessionCubit.onSignedOut`.
- Extra tests not in L: `failures_test`, `usecase_test`, `cursor_page_test`, `auth_interceptor_test`, `logging_interceptor_test`, `dio_client_test`, `routes_test`, `injector_test`, entity tests.

**(c) Present but wrong**

- **K1:** `freezed state shaped per ADR-0006 §5` — `exercise_list_state.dart` is Equatable, not `@freezed`.
- **J1:** `Filters and cursor are passed as query parameters` — `exercise_remote_datasource.dart` puts cursor in `extra`; generated `listExercises` has no `cursor` (offset/`q` only).
- **J2:** Invented comma-split for `equipment_needed` (OpenAPI string).
- **D5:** `Never log tokens` — `logging_interceptor.dart` logs full `DioException` (`error: err`), including `Authorization`.
- **D6:** Chain only on unused `configureDioClient`; live `getIt<Dio>()` has none.
- **L5/G3:** Tests `appRedirectLogic`, never a `GoRouter`. **G1:** `'/admin'`/`'/trainer'` literals in `redirect_logic.dart` (`No route string is written anywhere else`).
- **G6:** More tab *is* `/admin/workout-library`; no More landing/nested More routes.

---

## Summary

**Standards: 5 hard + 5 judgement; worst: production `getIt<Dio>()` has no interceptors (auth/refresh/error mapping never attach).**  
**Spec: 9 missing clusters, 2 scope-creep, 7 wrong; worst: Exercise Library UI (K4–K11) and L8 role-variant gate are absent, and the app still boots the counter.**
