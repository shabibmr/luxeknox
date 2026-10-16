# Lifestyle Intake and Macrocycle Blueprint Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A staff member, trainer, or member can save and read one lifestyle intake per member, and a workout plan can store the Page 5 program blueprint on create, update, and template assign.

**Architecture:** `LifestyleIntakeService` lives in the existing `PeopleModule`. One row per member in `member_lifestyle_intakes`. PUT replaces that row. GET returns it. Workout blueprint columns already exist on `workout_plans`. `WorkoutPlanService.create`, `update`, and `assign` read and write those columns. No new module and no migration.

**Tech Stack:** NestJS 10, Drizzle, Zod via `ZodValidationPipe`, Vitest, existing `health.read` plus a new `health.lifestyle` slug. Workout routes keep `workouts.read` and `workouts.write`.

**Spec:** [../PLAN.md](../PLAN.md) §3.2 and §3.3 (blueprint only) and [../TASKS.md](../TASKS.md) PTF-10, PTF-11, PTF-12. Field labels are Pages 3 and 5 of [../Luxe knox pt client  file.md](../Luxe%20knox%20pt%20client%20%20file.md). Columns are `apps/api/src/platform/db/schema/lifestyle-intake.ts` and `apps/api/src/platform/db/schema/workout.ts`.

Tasks register: [TASKS.md](./TASKS.md).

## Global Constraints

- Phase 1 is done. Use `member_lifestyle_intakes` and the blueprint columns on `workout_plans`. Do not add or rename columns. Do not migrate or reseed.
- Each task touches at most 7 files, not counting generated code.
- HTTP prefix is `v1` (`app.setGlobalPrefix('v1')`). Lifestyle paths are `GET /v1/members/:id/lifestyle-intake` and `PUT /v1/members/:id/lifestyle-intake`. Both return 200.
- Validate bodies with `ZodValidationPipe`, the same pipe `MedicalHistoryController` uses.
- Parent PTF-11 says class-validator. This API uses Zod.
- Do not edit `docs/openapi/v1.yaml` or run `openapi:check` as a done gate. Contract update is PTF-19.
- Do not change workout session completion, set logging, PAR-Q, or Flutter. Those are later phases.
- Page 3 "Previous injuries / limitations" has no column on this table. Do not store it here.
- `members.next_review_date`, `preferred_training_days_times`, `exercise_preferences`, and `coaching_notes` stay out of this phase.
- `workout_plan_exercises.target_rir` and `target_duration_seconds` stay out of this phase.
- Row scope goes through `requireScopedMember`. A caller who cannot see the member gets 404.
- Activity levels are exactly `sedentary`, `light`, `moderate`, `high` (`ACTIVITY_LEVELS`).
- Priority domains are exactly `sleep`, `nutrition`, `activity`, `recovery`. Paper "Daily activity" is stored as `activity`.
- Progression methods are exactly `load`, `reps`, `volume`, `density`, `technique`. Paper "Other" has no column and is rejected.
- `sleep_hours_typical` is a Drizzle decimal, so the response field is a string with one decimal place, or null. Input is a number.

## Review Focus

These are the inputs the parent spec leaves open. Each one has a test on the task that owns the code.

1. Stress outside 1–10 is rejected and nothing is written. `0` and `11` are not scores.
2. The priorities array must be one of each domain. A missing domain or a duplicate domain is rejected.
3. A second PUT that omits `training_history` stores null. PUT replaces the intake. It does not merge.
4. A trainer PUT stores `conducted_by_trainer_id` as `actor.profileId` when the body names a different trainer.
5. A workout-plan PATCH that sends only `title` does not pass blueprint keys to `updatePlan`. Assign copies the blueprint columns from the template.

---

## File map

| File | Responsibility |
|---|---|
| `apps/api/src/people/lifestyle-intake.dto.ts` | Zod schema and the response class |
| `apps/api/src/people/lifestyle-intake.repository.ts` | Find, insert, update by `member_id` |
| `apps/api/src/people/lifestyle-intake.service.ts` | Upsert, fetch, audit |
| `apps/api/src/people/lifestyle-intake.service.spec.ts` | Rules in Review Focus 1–4 |
| `apps/api/src/people/lifestyle-intake.controller.ts` | GET and PUT |
| `apps/api/src/people/lifestyle-intake.controller.spec.ts` | Handlers call the service |
| `apps/api/src/people/people.module.ts` | Register controller, repository, service |
| `apps/api/src/platform/db/seed/permissions.ts` | Slug `health.lifestyle` |
| `apps/api/src/platform/db/seed/roles.ts` | Grant `health.lifestyle` to `admin`, `trainer`, `employee`, and `member` |
| `apps/api/src/work/workout-plan.dto.ts` | Optional blueprint fields on create and update |
| `apps/api/src/work/workout-plan.service.ts` | Persist blueprint on create, update, and assign |
| `apps/api/src/work/workout-plan.service.spec.ts` | Review Focus 5 and the blueprint bounds |

## Decisions the parent spec does not pin

- There is no `LifestyleModule`. Register the controller and providers on `PeopleModule`. Export `LifestyleIntakeService`.
- DTOs sit next to the service (`lifestyle-intake.dto.ts`), the same place as `medical-history.dto.ts`. The parent path `people/dto/` does not exist.
- GET with no row throws `NotFoundError('Lifestyle intake not found')`.
- PUT inserts when no row exists and updates when one does. Both return the saved row. `created_at` is set only on insert. `updated_at` is set on insert and update.
- Required on PUT: `stress_level` (integer 1 through 10) and `lifestyle_priorities` (length 4, one of each domain, any order).
- Each priority item requires `current_status` and `first_action` as non-empty trimmed strings. Store the trimmed strings. Store the array in the order `sleep`, `nutrition`, `activity`, `recovery`.
- Optional intake strings are trimmed. Empty or whitespace stores null. Omitted optional fields store null. A second PUT therefore clears a field the client left off.
- `activity_level` omitted or null stores null. Any other value fails the schema.
- `sleep_hours_typical` is optional, from 0 to 24 inclusive, at most one decimal place. Store `toFixed(1)` (input `7.5` stores `'7.5'`). More than one decimal place fails the schema.
- `typical_daily_steps` is an optional integer from 0 through 200000.
- `conducted_by_trainer_id` is not accepted from a trainer. The service writes `actor.profileId`. For `admin`, `employee`, and `member`, the field is optional. Omitted stores null. This phase does not check that the id is a real trainer.
- Audit `entityName` is `member_lifestyle_intakes`. Actions are `lifestyle_intake.created` and `lifestyle_intake.updated`.
- Permissions: GET `health.read`, PUT `health.lifestyle`. `health.lifestyle` is new. Admin, trainer, employee, and member receive it. Do not add `health.update` to the trainer role.
- Blueprint fields are optional on create and on update. Omitted means null on create. Omitted means "leave the column unchanged" on update: do not put that key in the `updatePlan` changes object. Explicit `null` clears the column.
- `sessions_per_week` is an integer from 1 through 14. `target_session_duration_minutes` is an integer from 15 through 180. `split_type` is a trimmed string of length 1 through 64. `main_success_measure` is a trimmed string of length 1 through 255. `cardio_protocol`, `mobility_protocol`, and `trainer_programming_notes` are trimmed strings. Empty string stores null on create and clears on update when the key is present.
- `progression_methods` is a unique array of the five tokens. `[]` is valid and means none selected. Duplicates and `other` fail the schema.
- `assign` copies all ten blueprint columns from the template onto the new member plan. It does not copy `is_template` or `status` (those stay `false` and `active`, as today).

Blueprint columns, in write order: `primary_objective_12w`, `milestone_4w`, `sessions_per_week`, `target_session_duration_minutes`, `split_type`, `cardio_protocol`, `mobility_protocol`, `progression_methods`, `main_success_measure`, `trainer_programming_notes`.

---

### Task 1: Lifestyle intake service

**Files:**
- Create: `apps/api/src/people/lifestyle-intake.dto.ts`
- Create: `apps/api/src/people/lifestyle-intake.repository.ts`
- Create: `apps/api/src/people/lifestyle-intake.service.ts`
- Test: `apps/api/src/people/lifestyle-intake.service.spec.ts`

**Interfaces:**
- Consumes: `MemberLifestyleIntake`, `NewMemberLifestyleIntake`, `ACTIVITY_LEVELS`, `LifestylePriorityItem` from `platform/db/schema/lifestyle-intake.ts`. `requireScopedMember`. `AuditService.recordAudit`. `NotFoundError`.
- Produces:
  - `lifestyleIntakePutSchema`, `LifestyleIntakePutDto`
  - `LifestyleIntakeDto`
  - `LifestyleIntakeRepository.findByMemberId(memberId: number): Promise<MemberLifestyleIntake | null>`
  - `LifestyleIntakeRepository.insert(values: NewMemberLifestyleIntake): Promise<number>`
  - `LifestyleIntakeRepository.updateByMemberId(memberId: number, values: Partial<NewMemberLifestyleIntake>): Promise<void>`
  - `LifestyleIntakeService.get(memberId, actor): Promise<LifestyleIntakeDto>`
  - `LifestyleIntakeService.put(memberId, dto, actor): Promise<LifestyleIntakeDto>`

`LifestyleIntakeDto` fields: `id`, `member_id`, `activity_level`, `training_history`, `current_pain_discomfort`, `sleep_hours_typical`, `stress_level`, `work_activity_demands`, `typical_daily_steps`, `nutrition_approach`, `hydration_habits`, `recovery_habits`, `other_notes`, `lifestyle_priorities`, `conducted_by_trainer_id`, `created_at`, `updated_at`. Datetimes are ISO strings. `sleep_hours_typical` is `string | null`.

- [ ] **Step 1: Write the failing service tests**

Construct `LifestyleIntakeService` with fake repository, member repository, and audit, the same way `medical-history.service.spec.ts` builds its service. Cover:

```ts
it('put_inserts_when_no_row', async () => {
  // findByMemberId returns null
  // stress_level 4, four priorities, activity_level 'moderate', sleep_hours_typical 7.5
  // insert payload stress_level 4, sleep_hours_typical '7.5', activity_level 'moderate'
  // priorities ordered sleep, nutrition, activity, recovery
  // audit action lifestyle_intake.created
});

it('put_updates_when_row_exists', async () => {
  // findByMemberId returns a row
  // insert is not called
  // updateByMemberId is called
  // audit action lifestyle_intake.updated
});

it('put_omitted_text_stores_null', async () => {
  // existing row has training_history set
  // body omits training_history
  // update payload training_history is null
});

it('put_trainer_overwrites_conducted_by', async () => {
  // actor.userType 'trainer', actor.profileId 9
  // body conducted_by_trainer_id 4
  // stored conducted_by_trainer_id is 9
});

it('put_non_trainer_stores_body_trainer_or_null', async () => {
  // actor.userType 'admin', body omits conducted_by_trainer_id
  // stored null
});

it('get_missing_throws', async () => {
  // findByMemberId null rejects with NotFoundError message 'Lifestyle intake not found'
});

it('schema_rejects_stress_outside_1_to_10', () => {
  // stress_level 0 and 11: safeParse success === false
  // stress_level 1 and 10: success === true when the four priorities are present
});

it('schema_rejects_priority_gaps_and_duplicates', () => {
  // three items, missing recovery: success === false
  // two sleep items and no recovery: success === false
  // first_action '   ' on an otherwise complete matrix: success === false
});

it('schema_rejects_bad_activity_and_sleep', () => {
  // activity_level 'athlete' fails
  // sleep_hours_typical 24.1 fails
  // sleep_hours_typical 7.25 fails
  // sleep_hours_typical 0 and 24 pass
});
```

- [ ] **Step 2: Run the tests and confirm they fail**

Run: `pnpm --filter api exec vitest run src/people/lifestyle-intake.service.spec.ts`

Expected: FAIL because `LifestyleIntakeService` is not defined.

- [ ] **Step 3: Implement the repository, schema, and service**

`findByMemberId` selects by `member_id`, limit 1.

`put` calls `requireScopedMember`, builds the replace payload, inserts or updates, audits, reloads by `member_id`, returns `toDto`. Missing row after write throws `NotFoundError('Lifestyle intake not found')`.

`get` calls `requireScopedMember` and uses the same not-found error. It does not audit.

Sort priorities to `sleep`, `nutrition`, `activity`, `recovery` before write.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/people/lifestyle-intake.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/people/lifestyle-intake.dto.ts apps/api/src/people/lifestyle-intake.repository.ts apps/api/src/people/lifestyle-intake.service.ts apps/api/src/people/lifestyle-intake.service.spec.ts
git commit -m "feat: add lifestyle intake upsert"
```

---

### Task 2: Lifestyle intake endpoints

**Files:**
- Create: `apps/api/src/people/lifestyle-intake.controller.ts`
- Create: `apps/api/src/people/lifestyle-intake.controller.spec.ts`
- Modify: `apps/api/src/people/people.module.ts`
- Modify: `apps/api/src/platform/db/seed/permissions.ts`
- Modify: `apps/api/src/platform/db/seed/roles.ts`

**Interfaces:**
- Consumes: Task 1 `lifestyleIntakePutSchema` and `LifestyleIntakeService.get` / `put`.
- Produces: routes on controller path `members/:id/lifestyle-intake`. `PeopleModule` exports `LifestyleIntakeService`.

| Method | Path | Permission | Service | Status |
|---|---|---|---|---|
| GET | `/` | `health.read` | `get` | 200 |
| PUT | `/` | `health.lifestyle` | `put` | 200 |

Tag the controller `HEALTH`. Use `@ApiBearerAuth('bearer')`, `ParseIntPipe` on `id`, and `ZodValidationPipe` on the PUT body.

Permission slug to seed: `{ module: 'HEALTH', action: 'lifestyle', slug: 'health.lifestyle', description: 'Create or replace a member lifestyle intake' }`. Add `'health.lifestyle'` to the `admin`, `trainer`, `employee`, and `member` slug lists only.

- [ ] **Step 1: Write the failing controller test**

```ts
it('get_and_put_delegate', async () => {
  // get handler calls LifestyleIntakeService.get(memberId, actor)
  // put handler calls LifestyleIntakeService.put(memberId, body, actor)
});
```

- [ ] **Step 2: Run the test and confirm it fails**

Run: `pnpm --filter api exec vitest run src/people/lifestyle-intake.controller.spec.ts`

Expected: FAIL because the controller module is missing.

- [ ] **Step 3: Implement the controller, module registration, and permission seed**

Follow `MedicalHistoryController` for decorator order. Add `LifestyleIntakeController` to `controllers`, and `LifestyleIntakeRepository` plus `LifestyleIntakeService` to `providers` and `exports`.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/people/lifestyle-intake.controller.spec.ts src/people/lifestyle-intake.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/people/lifestyle-intake.controller.ts apps/api/src/people/lifestyle-intake.controller.spec.ts apps/api/src/people/people.module.ts apps/api/src/platform/db/seed/permissions.ts apps/api/src/platform/db/seed/roles.ts
git commit -m "feat: expose lifestyle intake endpoints"
```

---

### Task 3: Workout plan blueprint

**Files:**
- Modify: `apps/api/src/work/workout-plan.dto.ts`
- Modify: `apps/api/src/work/workout-plan.service.ts`
- Test: `apps/api/src/work/workout-plan.service.spec.ts`

**Interfaces:**
- Consumes: existing `WorkoutPlanService.create`, `update`, and `assign`. Existing `WorkoutPlanRepository.insertPlan` and `updatePlan`.
- Produces: `workoutPlanCreateSchema` and `workoutPlanUpdateSchema` accept the ten blueprint fields listed above. `create` and `assign` persist them. `update` writes a blueprint key only when the request includes that key.

This task does not depend on Task 1 or Task 2.

- [ ] **Step 1: Write the failing service tests**

Add cases to the existing `WorkoutPlanService` spec. Cover:

```ts
it('create_persists_blueprint_fields', async () => {
  // primary_objective_12w 'Squat 100kg', milestone_4w 'Squat 80kg',
  // sessions_per_week 4, target_session_duration_minutes 60,
  // split_type 'upper lower', cardio_protocol 'Zone 2 20 min',
  // mobility_protocol 'hips daily', progression_methods ['load', 'reps'],
  // main_success_measure 'Squat load', trainer_programming_notes 'pause reps'
  // insertPlan called with those values
});

it('create_omitted_blueprint_stores_null', async () => {
  // body is title only
  // insertPlan blueprint fields are null, progression_methods null
});

it('update_title_only_does_not_send_blueprint_keys', async () => {
  // dto is { title: 'Renamed', row_version: 1 }
  // updatePlan changes object has title and has no primary_objective_12w key
  // and no progression_methods key
});

it('update_null_clears_objective', async () => {
  // dto.primary_objective_12w is null
  // updatePlan changes include primary_objective_12w: null
});

it('assign_copies_blueprint_from_template', async () => {
  // template row has all ten blueprint fields set
  // insertPlan for the new plan copies those ten values
  // is_template false, status 'active'
});

it('schema_rejects_bad_blueprint_bounds', () => {
  // sessions_per_week 0 and 15 fail; 1 and 14 pass
  // target_session_duration_minutes 14 and 181 fail; 15 and 180 pass
  // progression_methods ['other'] fails
  // progression_methods ['load', 'load'] fails
  // progression_methods [] passes
  // split_type longer than 64 fails
});
```

- [ ] **Step 2: Run the tests and confirm they fail**

Run: `pnpm --filter api exec vitest run src/work/workout-plan.service.spec.ts`

Expected: FAIL on the new cases. Existing cases still pass.

- [ ] **Step 3: Extend the schemas and the three write paths**

Add the ten fields to both Zod objects. On `create`, pass each field into `insertPlan`, using null when omitted. Empty trimmed strings become null.

On `update`, copy a blueprint field into the `updatePlan` changes object only when `dto` has that key. Do not spread `undefined` into the changes for those keys.

On `assign`, copy the ten columns from `template` into `insertPlan`.

Leave exercise line items unchanged.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/work/workout-plan.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/work/workout-plan.dto.ts apps/api/src/work/workout-plan.service.ts apps/api/src/work/workout-plan.service.spec.ts
git commit -m "feat: persist workout plan blueprint fields"
```

---

## Spec coverage check

| Spec item | Task |
|---|---|
| PTF-10 upsert habits, stress, four priorities | Task 1 |
| PTF-11 GET and PUT, stress 1–10, four domains | Task 2 uses Task 1 schema |
| PTF-12 create/update blueprint fields | Task 3 |
| Page 5 cardio, mobility, success measure, trainer notes | Task 3, because those columns already exist |
| OpenAPI, Flutter, session ratings, pain hook | Not this phase |
