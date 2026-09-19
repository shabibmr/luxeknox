# ADR-0006 — Flutter architecture, state management & routing

| | |
| :--- | :--- |
| **Status** | Proposed |
| **Date** | 2026-09-16 |
| **Revision** | Replaces the initial Riverpod draft of this record (never accepted — amended in place rather than superseded). See *Alternatives considered*. |
| **Resolves** | `project-context.md` §10 — "Exact Flutter state management / routing packages" |
| **Related** | [ADR-0003](./0003-api-style-and-authentication.md), [ADR-0007](./0007-first-delivery-vertical.md) |

## Context

Three product decisions are already fixed and are **not** reopened here
(`project-context.md` §3, `screens/consolidated-screens.md`):

1. **One codebase, role-adaptive UI.** 44 shared screens, not 141 role-duplicated ones. A screen
   toggles between full / edit / read-only / hidden via a capability check.
2. **Exactly 5 root tabs per role**, everything else nested. "Shallow chrome, deep stacks."
3. **Feature-first directory layout**, sketched in `consolidated-screens.md`.

Two constraints are unusually demanding:

- **Independent navigation stacks per tab.** A member deep in `Progress → Goal → Edit` who taps
  `Schedule` and returns must find their stack intact.
- **Role-adaptive screens** read capability *and* server state in the same build method. Screen 29
  renders `F` (CRUD) for Admin and `R` (browse) for Member from one widget tree.

Beyond that the app is dominated by **server state** across 44 screens, with little genuinely local
client state.

**Team direction:** the team has specified `flutter_bloc`, `go_router`, and **Clean Architecture**.
This record implements that direction and fixes the conventions it leaves open — which layers exist,
what crosses them, whether use cases are mandatory, Bloc vs Cubit, and how state is shaped.

## Decision

**Clean Architecture layering · `flutter_bloc` for state · `go_router` for routing ·
`get_it` + `injectable` for dependency injection.**

### 1. Layers and the dependency rule

Three layers per feature. **Dependencies point inward, never outward.**

| Layer | Contains | May import |
| :--- | :--- | :--- |
| **`domain/`** | Entities, abstract repository interfaces, use cases, `Failure` types | Nothing from `data/` or `presentation/`. **Pure Dart — no Flutter SDK import at all** |
| **`data/`** | Generated API models, mappers, remote data sources, repository *implementations* | `domain/` only |
| **`presentation/`** | Blocs / Cubits, states, screens, widgets | `domain/` only — **never `data/`** |

`domain/` being pure Dart is the crisp, mechanically testable form of the rule: if a domain file
imports `package:flutter`, the layering has been violated.

**Enforced in CI**, because a layering rule nothing checks is a layering rule that decays. Two grep
checks, both of which must return no matches:

- `presentation/` must never reference a `data/` path
- `domain/` must never import `package:flutter`

### 2. Use cases are mandatory

One use-case class per operation, implementing a shared contract:

```dart
abstract class UseCase<Out, In> {
  Future<Either<Failure, Out>> call(In params);
}
```

Yes, this produces many thin classes. It is mandatory anyway, for one reason specific to this app:
**the role-variant tests depend on a uniform seam.** Every Bloc test becomes the same shape — mock
the use cases, drive the Bloc, assert the state — across all 44 screens. The alternative ("use cases
only where there's real logic") makes the seam a per-feature judgment call, and the role-variant
tests are the only thing standing behind the 141→44 consolidation thesis.

### 3. Repositories return `Either<Failure, T>`

Using `fpdart`. Repository interfaces live in `domain/`; implementations in `data/`.

This lets the §5.2 error table from [ADR-0003](./0003-api-style-and-authentication.md) be translated
**once**, in a single `core/` interceptor, into typed domain failures for all 16 modules:

| API `code` | HTTP | Domain `Failure` |
| :--- | :-: | :--- |
| `validation_error` | 400 | `ValidationFailure(details)` |
| `unauthenticated` | 401 | `AuthFailure` |
| `forbidden` | 403 | `PermissionFailure` |
| `not_found` | 404 | `NotFoundFailure` |
| `conflict` | 409 | `ConflictFailure` |
| `business_rule` | 422 | `BusinessRuleFailure(message)` |
| `rate_limited` | 429 | `RateLimitFailure` |
| — | — | `NetworkFailure` |

`BusinessRuleFailure` carries the server message straight to the UI — "freeze quota exceeded",
"class full", "PT sessions exhausted" are already user-facing strings in the FRD.

### 4. Bloc vs Cubit — a rule, not a preference

| Use | When | Examples in this app |
| :--- | :--- | :--- |
| **Cubit** (default) | Direct method calls; no event ordering concerns | Detail screens, forms, simple lists, settings |
| **Bloc** | Events need an `EventTransformer` — debounce, throttle, drop, or sequential ordering | Exercise/Food library search (`debounce`), Members directory search, live workout set logging (`sequential`), POS submit and check-in (`droppable`) |

The `droppable` transformer on POS and check-in is not stylistic — it is the client half of
FR-API-008's idempotency requirement, preventing a double-tap from becoming a second charge before
the `Idempotency-Key` ever reaches the server.

### 5. State shape — one class with a status field, not a sealed union

```dart
@freezed
class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState({
    @Default(Status.initial) Status status,     // initial | loading | success | failure
    @Default(<Exercise>[]) List<Exercise> items,
    @Default(ExerciseFilter()) ExerciseFilter filter,
    String? cursor,
    @Default(false) bool hasMore,
    Failure? failure,
  }) = _ExerciseListState;
}
```

A sealed union (`Loading` / `Loaded` / `Error`) forces the existing list to be carried into the
loading variant every time the user pages or refines a filter. Cursor pagination (FR-API-003) plus
filtered search makes "loading more while still showing what's on screen" the normal case, not the
exception. One class with a `status` field models that directly.

### 6. Routing — `go_router`

| Need | Mechanism |
| :--- | :--- |
| 5 root tabs with **independent stacks** | `StatefulShellRoute.indexedStack`, one branch per tab |
| Role-specific route trees (`/`, `/trainer/…`, `/admin/…`) | Router built from the principal's `user_type`; out-of-role routes do not exist |
| Auth gating | Single `redirect`; unauthenticated → `/login`, preserving intended location |
| Permission gating | `redirect` checks the slug list from `GET /me` (FR-RBAC-006). **UI convenience only** — NFR-001 means the server re-checks regardless |
| Adaptive presentation | Same routes; bottom bar on mobile, `NavigationRail` on tablet/desktop; detail as push on mobile, side pane when wide |

`go_router` is driven by the `SessionCubit` stream via `refreshListenable`, so login, logout, and
suspension (FR-AUTH-010) redirect without any imperative navigation.

### 7. Capability handling

A root-level `SessionCubit` holds the `Principal` (user, type, profile id, permission slugs).
`Capabilities` is a **domain** value object with `can(String slug)`.

```dart
final canEdit = context.select<SessionCubit, bool>(
  (c) => c.state.capabilities.can('exercises.update'),
);
```

This is the concrete form of the "role-based widget decorator" named in `consolidated-screens.md`.

### 8. Dependency injection — `get_it` + `injectable`

| Registration | Lifetime |
| :--- | :--- |
| Data sources, repositories, use cases | `@LazySingleton` |
| Blocs / Cubits | `@injectable` (factory — a fresh instance per route) |
| `SessionCubit`, `Dio`, router | `@singleton` |

Blocs are provided at the route via `BlocProvider(create: (_) => getIt<ExerciseListBloc>())`.

### 9. Structure

```text
lib/
├── core/
│   ├── di/injector.dart              # get_it + injectable
│   ├── error/failures.dart
│   ├── network/dio_client.dart       # + auth_interceptor, error_mapper
│   ├── router/app_router.dart        # + guards
│   ├── usecase/usecase.dart
│   └── widgets/
├── session/                          # SessionCubit, Principal, Capabilities
└── features/
    └── exercises/
        ├── domain/
        │   ├── entities/exercise.dart
        │   ├── repositories/exercise_repository.dart      # abstract
        │   └── usecases/get_exercises.dart                # one file per operation
        ├── data/
        │   ├── models/exercise_model.dart                 # generated + mapper
        │   ├── datasources/exercise_remote_datasource.dart
        │   └── repositories/exercise_repository_impl.dart
        └── presentation/
            ├── bloc/exercise_list_bloc.dart               # + event, state
            ├── cubit/exercise_detail_cubit.dart           # + state
            ├── screens/exercise_library_screen.dart
            └── widgets/
```

### 10. Models vs entities

The OpenAPI-generated Dart client from [ADR-0003](./0003-api-style-and-authentication.md) lives in
`data/` and **never leaves it**. Generated models are mapped to hand-written domain entities in
`data/models/`. Domain and presentation never see a generated type.

This refines — it does not contradict — ADR-0003's claim that a breaking API change fails the
Flutter build: it now fails **at the mapper**, in one file per feature, rather than rippling through
widget code.

### 11. Testing conventions (normative)

| Layer | Approach |
| :--- | :--- |
| Use cases | Pure Dart unit tests, mocked repository |
| Blocs / Cubits | `bloc_test` with mocked use cases |
| **Role variants** | **Every screen with a role-varying access level gets a widget or golden test per applicable role**, by pumping it under a `SessionCubit` seeded with a member, trainer, and admin principal |

The role-variant rule carries over from the previous draft unchanged. The entire consolidation
thesis rests on those variants staying correct, and nothing else will catch a regression in them.

### Supporting packages

| Concern | Package |
| :--- | :--- |
| HTTP | `dio` — bearer token, refresh-on-401, `request_id` logging, error mapping |
| Functional error type | `fpdart` |
| Immutable models & states | `freezed` + `json_serializable` |
| Value equality | `equatable` (entities) — `freezed` covers states |
| Secure token storage | `flutter_secure_storage` — refresh token in Keychain/Keystore, **never** `SharedPreferences` |
| Test doubles | `mocktail`, `bloc_test` |

## Consequences

**Positive**

- The layer boundaries are mechanically enforceable, and the CI checks above make "clean
  architecture" a property of the build rather than of code review diligence.
- `StatefulShellRoute` satisfies the 5-tab / deep-stack requirement natively.
- Bloc's `EventTransformer` gives a real mechanism for debounced search and droppable submits that
  a method-call-based approach has to hand-roll — and the droppable case is a correctness
  requirement (FR-API-008), not a nicety.
- The §5.2 error table is translated once in `core/` and every feature inherits typed failures.
- Uniform Bloc test shape across 44 screens, which is what makes the role-variant coverage
  affordable rather than aspirational.

**Negative**

- **This is the most boilerplate-heavy option on the table, by a wide margin.** Per feature
  operation: an entity, a repository interface, a repository implementation, a data source method, a
  model + mapper, a use case, an event, and a state field. Across ~16 modules this is several hundred
  files. **Budget for it explicitly in the vertical-1 estimate, and template it early** — if the
  Exercise Library takes three weeks because of scaffolding, that cost repeats 15 more times.
- The mapper layer means every backend field addition is touched in two places (generated model,
  domain entity). This is the deliberate price of insulating domain from the API contract.
- `freezed` + `injectable` + `json_serializable` means `build_runner` is firmly in the dev loop.
  Real friction on a cold build; mitigate with `--watch`.
- Mandatory use cases will produce genuinely thin classes for simple reads. Accepted for seam
  uniformity — but it is ceremony, and pretending otherwise would be dishonest.
- `go_router` redirect logic is a known source of loops when auth and permission redirects interact.
  Keep exactly one `redirect`, unauthenticated check first.

**Neutral**

- All chosen packages are mainstream with active maintenance; none is an exotic bet.
- Clean Architecture's payoff is proportional to project lifetime. At 55 tables and 44 screens with
  a multi-year horizon, the trade is defensible; on a 6-week prototype it would not be.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **Riverpod + go_router** *(the initial draft of this record)* | Proposed first on the argument that `AsyncValue` models server state with far less ceremony across 44 screens. Displaced by team direction toward `flutter_bloc` and Clean Architecture. The trade is real and worth stating plainly: Riverpod would have meant materially less boilerplate; Bloc gives more prescriptive structure, `EventTransformer` control, and a uniform test seam. **With an explicit Clean Architecture directive, Bloc is the better-matched pairing** — Riverpod's provider graph overlaps with the DI layer that Clean Architecture wants stated separately, whereas Bloc sits cleanly inside `presentation/` and leaves DI to `get_it`. |
| **Cubit everywhere, no Bloc** | Simpler and lighter. Rejected because debounced search and droppable submit need `EventTransformer`; the rule in §4 keeps Cubit as the default and reaches for Bloc only where that mechanism is required. |
| **Use cases only where logic exists** | Saves several hundred thin files. Rejected: it makes the test seam a per-feature judgment call, which is exactly what the role-variant coverage cannot afford. |
| **Sealed-union state classes** | More idiomatic `freezed`, and better for screens with genuinely exclusive states. Rejected as the default because pagination + filtering makes "loading while showing existing data" the common case. Individual screens may still use a union where states really are exclusive. |
| **Two layers (`data` / `presentation`, no `domain`)** | Would remove the mapper and the use cases — most of the boilerplate cost above. Rejected: it is not Clean Architecture, and the team asked for Clean Architecture. |
| **`auto_route`** | Strong compile-time-safe routing with good nested-stack support. Close call; rejected to avoid a fourth code generator alongside `freezed`, `injectable`, and `json_serializable`. |
| **Navigator 1.0** | Cannot express tab-scoped stacks or redirect gating without substantial custom work. |
| **Three separate apps** | Already ruled out by `project-context.md` §3 — this ADR implements that decision rather than revisiting it. |
