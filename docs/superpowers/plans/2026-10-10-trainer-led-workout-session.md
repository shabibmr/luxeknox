# Trainer-Led Workout Session Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A personal trainer with an active PT subscription for a member can start (or resume) that member's live workout session from the trainer app and update it — log, edit and delete sets, and complete it.

**Architecture:** The API already accepts trainer-started sessions (`POST /workout-sessions` with `member_id`) and trainers already hold `workouts.write`. We add the PT write gate (`PtAccessService.assertTrainerCanWrite`, already used by workout/diet/goal plans) to every session write, add a "get active session" read so anyone opening the screen resumes instead of hitting the one-active-session 409, and add set edit/delete. In the app, `ActiveWorkoutScreen`/`ActiveWorkoutBloc` become member-id-parameterised and get a trainer route reached from the member dossier and the trainer's plan detail.

**Tech Stack:** NestJS + Drizzle (MySQL 8.4) + Vitest + Zod (`apps/api`); OpenAPI 3 contract (`docs/openapi/v1.yaml`) + generated Dart client (`packages/api_client`, `tool/gen_api.sh`); Flutter + flutter_bloc + go_router + injectable (`app`).

**Spec:** User request (2026-10-10): "Need trainer led session for members with personal trainer mapped. Trainer should have permission to update the session." Background: earlier gap analysis in this session (no resume, no trainer route).

## Global Constraints

- "Personal trainer mapped" = the trainer holds an **active** `pt_subscriptions` row for the member, i.e. `PtAccessService.trainerAccess(trainerId, memberId) === 'full'`. Assigned-but-PT-ended trainers stay read-only (`members.assigned_trainer_id` still grants reads via `assertMemberAccess`).
- Trainer write denial must be `BusinessRuleError('Read-only: an active Personal Training subscription is required to modify this member')` — reuse `assertTrainerCanWrite`, don't write a new message. The app shows it verbatim (ADR-0006 §3).
- Member and admin/employee behaviour is unchanged except: they gain resume, set edit and set delete too (same endpoints, same rules minus the PT gate).
- No schema migration. No session cancel/abandon in this plan (out of scope; noted below).
- Every new/changed route is added to `docs/openapi/v1.yaml` with `x-parity: required`; `npm run openapi:dump && npm run openapi:check` must pass.
- Regenerate the Dart client with `tool/gen_api.sh` but **commit only the workout-session-related generated files** (the generator surfaces unrelated drift — revert it, as in commit `cb88452`).
- Local DB is MySQL 8.4 on `localhost:3308`, not Docker.
- User-facing strings live in `WorkoutStrings` / `PeopleStrings`; no inline literals.

## Review Focus

1. **PT ends mid-session** — trainer's next set log / edit / complete fails with the read-only message shown as a snackbar; the member can still finish on their own device. Test: Task 1 `logSet rejects trainer without active PT`.
2. **Member already started, trainer opens the screen (or vice versa)** — screen resumes the same session with its sets; next set number continues from loaded sets, no 409. Test: Task 5 `resumes active session instead of starting`.
3. **PT scheduled but not yet active** (trainer assigned, start date in future) — start is rejected with the read-only message; the dossier hides the start tile. Test: Task 1 `start rejects trainer without active PT` + Task 6 tile-visibility test.
4. **Set id from another session** — `PATCH/DELETE /workout-sessions/:id/sets/:setId` with a set not in `:id` returns 404, never edits another member's data. Test: Task 2 `updateSet 404s when set belongs to another session`.
5. **Editing a completed session** — edit/delete return `BusinessRuleError('Cannot modify sets of a completed workout session')`; the app disables edit/delete once `completed`. Test: Task 2 `deleteSet rejects completed session`.

---

### Task 1: API — PT write gate on session writes

**Files:**
- Modify: `apps/api/src/work/workout-session.service.ts` (constructor; `start` ~L85; `logSet` ~L150; `complete` ~L178)
- Test: `apps/api/src/work/workout-session.service.spec.ts`

**Interfaces:**
- Consumes: `PtAccessService.assertTrainerCanWrite(actor, memberId): Promise<void>` from `apps/api/src/pt/pt-access.service.ts` (already provided via `PtAccessModule` imported in `work.module.ts`).
- Produces: `WorkoutSessionService` constructor gains a trailing optional `private readonly ptAccess?: PtAccessService` (same optional pattern as `workout-plan.service.ts:42`).

- [ ] **Step 1: Write failing tests** in the spec's `buildService` helper add a `ptAccess` mock (`{ assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined) }`, mirroring `workout-plan.service.spec.ts:99`), then:
  - `start rejects trainer without active PT`: `assertTrainerCanWrite` rejects `BusinessRuleError('Read-only')` → `start({ member_id: 100 }, trainerUser)` rejects `BusinessRuleError`; `sessionRepo.insertSession` not called.
  - `logSet rejects trainer without active PT`: same, `insertSessionExercise` not called.
  - `complete rejects trainer without active PT`: same, `completeSession` not called.
  - `start/logSet/complete call assertTrainerCanWrite(actor, session.member_id)` for a trainer actor (one `it` each or `it.each`).
- [ ] **Step 2: Run** `cd apps/api && npx vitest run src/work/workout-session.service.spec.ts` — Expected: new tests FAIL.
- [ ] **Step 3: Implement** — inject `ptAccess` and call `await this.ptAccess?.assertTrainerCanWrite(actor, memberId)` immediately after each existing `assertMemberAccess(...)` in `start`, `logSet`, `complete`. In `complete`, call it before the already-completed early return so a read-only trainer gets the read-only error, not a silent 200.
- [ ] **Step 4: Run** the spec — Expected: PASS (all old tests still pass).
- [ ] **Step 5: Commit** `feat(workout): require active PT for trainer session writes`

---

### Task 2: API — active-session read, set edit, set delete

**Files:**
- Modify: `apps/api/src/work/workout-session.repository.ts`, `workout-session.service.ts`, `workout-session.controller.ts`, `workout-plan.dto.ts`
- Test: `workout-session.service.spec.ts`, `workout-session.controller.spec.ts`

**Interfaces:**
- Consumes: Task 1's `ptAccess`.
- Produces (HTTP):
  - `GET /workout-sessions/active?member_id=` → `200 WorkoutSessionWithSets`, or `404 'No active workout session'`. Members: `member_id` ignored, own profile used. Permission `workouts.read`. **Declare this route before `@Get(':id')`.**
  - `PATCH /workout-sessions/:id/sets/:setId` body `workoutSetUpdateSchema` → `200 WorkoutSessionExercise`. Permission `workouts.write`.
  - `DELETE /workout-sessions/:id/sets/:setId` → `204`. Permission `workouts.write`.
- Produces (TS):
  - Repo: `findSetInSession(sessionId: number, setId: number): Promise<WorkoutSessionExercise | null>`, `updateSessionExercise(setId: number, patch: Partial<Pick<NewWorkoutSessionExercise, 'reps_completed' | 'weight_lifted_kg' | 'rpe_score' | 'is_completed'>>): Promise<WorkoutSessionExercise>`, `deleteSessionExercise(setId: number): Promise<void>`.
  - Service: `getActive(memberId: number | undefined, actor): Promise<WorkoutSessionWithSets>`, `updateSet(sessionId, setId, dto: WorkoutSetUpdateDto, actor): Promise<WorkoutSessionExercise>`, `deleteSet(sessionId, setId, actor): Promise<void>`.
  - DTO: `workoutSetUpdateSchema` = `workoutSetWriteSchema` minus `exercise_id`/`set_number`, all fields optional, `.refine` at least one field present; export `WorkoutSetUpdateDto`.

- [ ] **Step 1: Write failing service tests:**
  - `getActive returns session with sets for member's own profile` (member actor, `member_id` arg ignored).
  - `getActive 404s when none` → `NotFoundError`.
  - `getActive lets assigned trainer read even without active PT` (no `assertTrainerCanWrite` call).
  - `updateSet updates reps/weight and returns row`; `updateSet 404s when set belongs to another session` (`findSetInSession` → null → `NotFoundError('Workout set not found')`).
  - `updateSet rejects trainer without active PT`.
  - `deleteSet rejects completed session` → `BusinessRuleError('Cannot modify sets of a completed workout session')`, `deleteSessionExercise` not called.
  - Controller spec: the three routes carry the permissions above and delegate to the service (follow existing controller spec style).
- [ ] **Step 2: Run** `npx vitest run src/work/workout-session.*.spec.ts` — Expected: FAIL.
- [ ] **Step 3: Implement** repo methods (Drizzle; `findSetInSession` filters on both `id` and `workout_session_id`), service methods (order: load session → 404 → `assertMemberAccess` → `assertTrainerCanWrite` → completed check → set lookup → write), DTO, controller routes. `getActive` = `findActiveSessionForMember` then `findSessionById` for sets. Update numbers are stringified for decimals exactly like `logSet` does.
- [ ] **Step 4: Run** the specs — Expected: PASS.
- [ ] **Step 5: Commit** `feat(workout): add active-session lookup and set edit/delete`

---

### Task 3: Contract + generated client

**Files:**
- Modify: `docs/openapi/v1.yaml` (under `/workout-sessions` ~L4422), `docs/openapi/v1.json` (via dump)
- Modify (generated, selective): `packages/api_client/lib/src/api/workout_sessions_api.dart` (or whichever `*_api.dart` holds `startWorkoutSession`), new `workout_set_update*.dart` model + its `.g.dart`, `serializers.dart`, matching `doc/` files.

**Interfaces:**
- Produces: Dart client methods (names follow the yaml `operationId`s you set): `getActiveWorkoutSession({int? memberId})`, `updateWorkoutSessionSet({required int id, required int setId, required WorkoutSetUpdate workoutSetUpdate})`, `deleteWorkoutSessionSet({required int id, required int setId})`.

- [ ] **Step 1:** Add the three operations with those `operationId`s, `x-parity: required`, `WorkoutSetUpdate` schema, 404/422 responses (copy structure from `/workout-sessions/{id}/sets`).
- [ ] **Step 2: Run** `cd apps/api && npm run openapi:dump && npm run openapi:check` — Expected: exit 0.
- [ ] **Step 3:** Run `tool/gen_api.sh`, then `git checkout --` every changed generated file unrelated to workout sessions; run `dart run build_runner build --delete-conflicting-outputs` in `packages/api_client`.
- [ ] **Step 4: Run** `cd packages/api_client && dart analyze` — Expected: no errors.
- [ ] **Step 5: Commit** `feat(api): add trainer session endpoints to OpenAPI and regenerate client`

---

### Task 4: App data/domain layer

**Files:**
- Modify: `app/lib/features/workout/data/datasources/workout_session_remote_datasource.dart`, `data/repositories/workout_session_repository_impl.dart`, `domain/repositories/workout_session_repository.dart`
- Create: `domain/usecases/get_active_workout_session_usecase.dart`, `update_workout_set_usecase.dart`, `delete_workout_set_usecase.dart`
- Regenerate: `app/lib/core/di/injector.config.dart` (`dart run build_runner build`)
- Test: `app/test/features/workout/data/workout_session_repository_impl_test.dart` (create if absent; follow nearest existing repo test)

**Interfaces:**
- Consumes: Task 3 client methods.
- Produces:
  - `Future<Either<Failure, WorkoutSession?>> getActiveSession(String memberId)` — 404 maps to `Right(null)`, not a Failure.
  - `Future<Either<Failure, WorkoutSessionSet>> updateSet(String sessionId, String setId, {int? reps, num? weightKg, num? rpe, bool? isCompleted})`
  - `Future<Either<Failure, Unit>> deleteSet(String sessionId, String setId)`
  - Use cases wrap these 1:1 (`@injectable`, same shape as `LogWorkoutSetUseCase`).

- [ ] **Step 1: Write failing tests:** `getActiveSession returns null on 404`; `getActiveSession maps session with sets`; `updateSet sends only provided fields`; `deleteSet maps 422 to Failure carrying server message`.
- [ ] **Step 2: Run** `cd app && flutter test test/features/workout/data/` — Expected: FAIL.
- [ ] **Step 3: Implement** datasource + repo + use cases; regenerate DI.
- [ ] **Step 4: Run** tests — Expected: PASS.
- [ ] **Step 5: Commit** `feat(app): add active-session, set edit and delete to workout data layer`

---

### Task 5: Bloc — resume, edit, delete

**Files:**
- Modify: `app/lib/features/workout/presentation/bloc/active_workout_bloc.dart` (+ `.freezed.dart` regen)
- Test: `app/test/features/workout/active_workout_cubit_test.dart`

**Interfaces:**
- Consumes: Task 4 use cases (added as constructor params after `_getPlan`).
- Produces: events `ActiveWorkoutSetEdited({required String setId, int? reps, num? weightKg, num? rpe})`, `ActiveWorkoutSetDeleted(String setId)`; state field `bool resumed` (true when an existing session was loaded).

- [ ] **Step 1: Write failing tests:**
  - `resumes active session instead of starting`: `getActive` → session with 2 sets for exercise X → `startSession` never called; `loggedSets.length == 2`; `resumed == true`; plan loaded from `session.workoutPlanId` (ignoring the route's `workoutPlanId`); next `ActiveWorkoutSetLogged` for X uses `set_number` 3.
  - `starts new session when none active` (`getActive` → `Right(null)`).
  - `edit replaces the set in loggedSets`; `delete removes it`.
  - `edit failure surfaces server message` (state `failure.message` equals the read-only text; `loggedSets` unchanged).
  - `edit/delete ignored once completed`.
- [ ] **Step 2: Run** `cd app && flutter test test/features/workout/active_workout_cubit_test.dart` — Expected: FAIL.
- [ ] **Step 3: Implement.** `_onStarted`: call `getActive(memberId)` first; on session → emit success with it (`resumed: true`); on null → existing start path. Register edit/delete with `sequential()` like `_onSetLogged`.
- [ ] **Step 4: Run** tests — Expected: PASS.
- [ ] **Step 5: Commit** `feat(app): resume active workout session and edit/delete sets`

---

### Task 6: App — trainer route, entry points, set edit UI

**Files:**
- Modify: `app/lib/features/workout/presentation/screens/active_workout_screen.dart` (accept `memberId`, `historyPath`; long-press/trailing menu on logged sets → edit sheet / delete)
- Modify: `app/lib/core/router/routes.dart` (add `trainerMembersWorkoutActive = '/trainer/members/:id/workout/active'` + `trainerMembersWorkoutActiveById(String id, {String? workoutPlanId})`)
- Modify: `app/lib/core/router/trainer_routes.dart` (child `workout/active` under `members/:id`, next to `workout-history` ~L235)
- Modify: `app/lib/features/people/presentation/screens/member_dossier_screen.dart` (~L681, add tile)
- Modify: `app/lib/features/workout/presentation/screens/workout_plan_detail_screen.dart` (~L181, trainer start button)
- Modify: `app/lib/features/workout/presentation/workout_strings.dart`, `app/lib/features/people/presentation/people_strings.dart`
- Test: `app/test/features/people/presentation/member_dossier_session_tile_test.dart`, `app/test/core/router/trainer_routes_test.dart` (or extend existing router test)

**Interfaces:**
- Consumes: Task 5 bloc events/state; `trainerHubReadOnly(pt)` and `ptDossierStatus(pt)` from `member_dossier_pt.dart`.
- Produces: `ActiveWorkoutScreen({String? workoutPlanId, String? memberId, String? historyPath})` — `memberId ?? sessionProfileId(context)`; `historyPath ?? Routes.memberHomeWorkoutHistory`.

- [ ] **Step 1: Write failing tests:**
  - Dossier: tile `PeopleStrings.startWorkoutSession` shown when trainer shell && `ptDossierStatus == active` && `!trainerHubReadOnly(pt)`; hidden for expired, scheduled, not-purchased, and admin shell. Tap pushes `/trainer/members/42/workout/active`.
  - Router: `/trainer/members/42/workout/active?workoutPlanId=7` builds `ActiveWorkoutScreen` with `memberId: '42'`, `workoutPlanId: '7'`, `historyPath: '/trainer/members/42/workout-history'`.
  - Plan detail (trainer, not view-only, `plan.memberId != null`): button `WorkoutStrings.startSessionWithMember` pushes `trainerMembersWorkoutActiveById(plan.memberId!, workoutPlanId: plan.id)`; hidden for template plans (`memberId == null`).
- [ ] **Step 2: Run** `cd app && flutter test test/features/people test/core/router` — Expected: FAIL.
- [ ] **Step 3: Implement.** Strings: `startWorkoutSession = 'Start workout session'`, `startSessionWithMember = 'Start session with member'`, `editSet = 'Edit set'`, `deleteSet = 'Delete set'`, `resumedSession = 'Resumed session in progress'` (snackbar when `resumed`). Edit sheet reuses the existing set-entry fields prefilled. Errors show `failure.message` in a snackbar.
- [ ] **Step 4: Run** `cd app && flutter analyze && flutter test` — Expected: no analyzer errors, all tests PASS.
- [ ] **Step 5: Manual check** (MySQL on `:3308`, API + app running): as a trainer with an active PT member — dossier → Start workout session → log 2 sets → edit one → delete one → complete; as the member, start a session on another device first and confirm the trainer screen resumes it. Then end that PT subscription in the DB and confirm the trainer's next log shows the read-only message.
- [ ] **Step 6: Commit** `feat(app): trainer-led workout session for PT members`

---

## Out of scope (follow-ups)

- Cancel/abandon an in-progress session (needs a `cancelled_at` column and an update to the `active_session_member_id` generated column).
- Real-time sync between member and trainer devices (both currently see the other's sets only on resume/refresh).
- Admin-shell session route (API already permits staff).
