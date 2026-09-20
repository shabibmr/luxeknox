# Vertical 1 review-fix tasks

Execute top to bottom on **Grok 4.5**. Check a box when the code change is in. **Skip `flutter test` for now** (user request).

Source: [implementation-plan.md](implementation-plan.md).

## Phase 1 — Network, mapping, DI

- [x] **FIX-01** D5: logging interceptor never logs tokens / `DioException`
- [x] **FIX-02** D6: DI Dio uses `configureDioClient` (auth → refresh → error → logging)
- [x] **FIX-03** Extract `mapThrownToFailure`; both repos call it
- [x] **FIX-04** J1: `offset` query param, opaque cursor, no invented `cursor` extra (nextCursor fallback still pending in repo)
- [x] **FIX-05** J2: equipment string ↔ 0/1-element list, no comma-split
- [x] **FIX-06** E3: annotate + register Dio/APIs/router/SessionCubit/use cases/blocs; build_runner

## Phase 2 — Domain polish + freezed

- [x] **FIX-07** `UserType` enum; redirect uses it
- [ ] **FIX-08** Freezed `ExerciseListState` / events (status field, not sealed union)
- [ ] **FIX-09** rxdart/bloc_concurrency debounce 300ms; delete hand-rolled transformer

## Phase 3 — Bootstrap, session, auth UI

- [x] **FIX-10** A4 gitkeeps; delete empty unused auth data/domain
- [x] **FIX-11** `main.dart` boots `configureDependencies` + `MaterialApp.router`
- [x] **FIX-12** H1 splash + `restore()`
- [x] **FIX-13** H2–H4 login cubit/screen + FR-AUTH-002 identical messages
- [x] **FIX-14** H5 sign-out confirm on Profile (+ Admin More footer)
- [x] **FIX-15** L4 suspension = AuthFailure → unauthenticated + test

## Phase 4 — Routing, strings, G9

- [x] **FIX-16** G1: no raw `'/admin'`/`'/trainer'` outside `routes.dart`
- [x] **FIX-17** G6 More hub + sibling More routes; library nested under More (hub overlays shell — shell stays mounted)
- [x] **FIX-18** Centralize UI strings (shell + auth + exercises)
- [x] **FIX-19** G9 capability widget test
- [x] **FIX-20** L5 `GoRouter` redirect tests + loop guard

## Phase 5 — Exercise presentation

- [ ] **FIX-21** L1 test helpers (member/trainer/admin)
- [ ] **FIX-22** K4–K6, K8–K11 screens/widgets + master-detail 840dp

## Phase 6 — Acceptance tests + release labels

- [ ] **FIX-23** L8 six role-variant tests (acceptance gate)
- [ ] **FIX-24** L7 bloc tests still green after freezed
- [ ] **FIX-25** L9 goldens 390 / 1280
- [x] **FIX-26** M2 display name + bundle ids
- [x] **FIX-27** M6 no-op `CrashReporter` only

## Phase 7 — Verify

- [x] `dart format --set-exit-if-changed .` (foundation pass)
- [x] `flutter analyze` (zero issues)
- [x] `bash tool/check_layers.sh` (exits 0; deliberate-fail probe done + reverted)
- [ ] `flutter test` including L2, L3, L8 — **skipped for now** (per user; foundation suites green)

**Done when:** all boxes checked. Blocked (not silent skips): M1 real-device icon, M6 dashboard, Verification 5–7 live API.
