# PAR-Q+ Safety Gate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A member can submit the seven PAR-Q+ answers, a trainer can record the screening note, an admin can clear or reject a positive screen, and a member whose latest screen is `pending_clearance` or `rejected` cannot be booked onto a PT occurrence or marked attended.

**Architecture:** `ParQService` in a new `ParQModule` owns the screening rules and `assertCanTrain`. The controller is a thin Nest adapter over that service. `BookingService.book` and `SessionAttendanceService.mark` call `assertCanTrain` only for schedule rows whose `pt_subscription_id` is set. The current screen is the latest `par_q_screenings` row for the member. An older pending row does not block once a newer row is `passed` or `cleared`.

**Tech Stack:** NestJS 10, Drizzle, Zod via `ZodValidationPipe`, Vitest, existing `health.update` / `health.approve` permissions plus a new `health.review` slug.

**Spec:** [../PLAN.md](../PLAN.md) §3.1 and [../TASKS.md](../TASKS.md) PTF-07, PTF-08, PTF-09. Question text is Page 2 of [../Luxe knox pt client  file.md](../Luxe%20knox%20pt%20client%20%20file.md). Column names are `apps/api/src/platform/db/schema/par-q.ts`.

Tasks register: [TASKS.md](./TASKS.md).

## Global Constraints

- Phase 1 is done. Use the existing `par_q_screenings` table. Do not add or rename columns.
- Each task touches at most 7 files, not counting generated code.
- HTTP prefix is `v1` (`app.setGlobalPrefix('v1')`). Paths are `/v1/members/:id/par-q`, `/v1/members/:id/par-q/trainer-review`, and `/v1/members/:id/par-q/clearance`.
- Validate bodies with `ZodValidationPipe`, the same pipe `MedicalHistoryController` uses.
- `BusinessRuleError` responds HTTP 422, body code `business_rule`. The gate message string is `MEDICAL_CLEARANCE_REQUIRED`.
- Clearance statuses are exactly `passed`, `pending_clearance`, `cleared`, `rejected`.
- Questionnaire version stored when the client omits it is `2024.1`.
- Do not edit `docs/openapi/v1.yaml` or run `openapi:check` as a done gate. Contract update is PTF-19.
- Do not gate PT package purchase, class bookings, or `WorkoutSessionService.start`.
- Local database is MySQL on `localhost:3308`. These tasks do not migrate or reseed.
- Row scope goes through `requireScopedMember`. A caller who cannot see the member gets 404.

## Review Focus

These are the inputs the parent spec leaves open. Each one has a test on the task that owns the code.

1. A Yes with blank or whitespace-only details is rejected and nothing is inserted. A Yes without a written detail is not a usable screen.
2. `rejected` blocks PT the same way `pending_clearance` does. A refused clearance must not book or attend.
3. A schedule with no `pt_subscription_id` still books when the member is pending. The gate is PT occurrences only.
4. `attended: false` on a PT occurrence still saves when the member is pending. A no-show is not training.
5. A later all-No submission makes `assertCanTrain` allow the member while an older row is still `pending_clearance`. The gate reads the latest row only.

---

## File map

| File | Responsibility |
|---|---|
| `apps/api/src/health/par-q.dto.ts` | Zod schemas and the response class |
| `apps/api/src/health/par-q.repository.ts` | Latest row, insert, update |
| `apps/api/src/health/par-q.service.ts` | Submit, trainer review, clearance, `assertCanTrain` |
| `apps/api/src/health/par-q.service.spec.ts` | Rules in Review Focus 1, 2, and 5 |
| `apps/api/src/health/par-q.controller.ts` | Three routes and permission decorators |
| `apps/api/src/health/par-q.controller.spec.ts` | Handlers call the service |
| `apps/api/src/health/par-q.module.ts` | `ParQModule`, exports `ParQService` |
| `apps/api/src/app.module.ts` | Import `ParQModule` |
| `apps/api/src/platform/db/seed/permissions.ts` | Slug `health.review` |
| `apps/api/src/platform/db/seed/roles.ts` | Grant `health.review` to `admin` and `trainer` |
| `apps/api/src/sched/booking.service.ts` | Gate PT booking |
| `apps/api/src/attn/session-attendance.service.ts` | Gate PT attendance when `attended` is true |
| `apps/api/src/sched/sched.module.ts`, `apps/api/src/attn/attn.module.ts` | Import `ParQModule` |

`ParQModule` imports `PlatformModule`, `RbacModule`, and `PeopleModule`. It does not import `SchedModule` or `AttnModule`.

## Decisions the parent spec does not pin

- PTF-08 says class-validator. This API uses Zod. PTF-09 says `BusinessRuleError('MEDICAL_CLEARANCE_REQUIRED')`. That class is HTTP 422, not 403. Keep the class. Put the token in `message`.
- There is no `scheduling.service.ts`. The booking method is `BookingService.book`. The attendance method is `SessionAttendanceService.mark`.
- A schedule is a PT occurrence when `pt_subscription_id` is not null.
- `has_positive_answer` is the OR of the seven question booleans. The request body has no such field.
- Any Yes sets `clearance_status` to `pending_clearance` and `referral_required` to true. All No sets `passed` and `referral_required` to false. Submit leaves `referral_reason` null. The trainer writes the reason.
- Submit always inserts a new row. `client_signed_at` is the server clock. `trainer_signed_at`, `cleared_at`, and `cleared_by_user_id` stay null.
- Trainer review updates the latest row only. It sets `trainer_screening_notes`, `referral_required`, `referral_reason`, `trainer_user_id` to `actor.id`, and `trainer_signed_at` to now. It does not change `clearance_status`.
- Clearance updates the latest row only when its status is `pending_clearance`. `decision: 'cleared'` stores `cleared`. `decision: 'rejected'` stores `rejected`. Both set `cleared_at` and `cleared_by_user_id`.
- `assertCanTrain` blocks `pending_clearance` and `rejected`. It allows `passed`, `cleared`, and no row.
- Permissions: submit `health.update`, trainer review `health.review`, clearance `health.approve`. `health.review` is new. Admin and trainer receive it. Member and employee do not.
- When `referral_required` is true on trainer review, `referral_reason` must be a non-empty trimmed string. When it is false, store `referral_reason` null.
- A Yes requires the matching `qN_details` to be a non-empty trimmed string. A No stores that detail as null.
- Question columns, in order: `q1_heart_condition`, `q2_chest_pain_activity`, `q3_chest_pain_rest`, `q4_dizziness_consciousness`, `q5_bone_joint_problem`, `q6_medication_condition`, `q7_other_reason`, each with `qN_details`.

---

### Task 1: PAR-Q service

**Files:**
- Create: `apps/api/src/health/par-q.dto.ts`
- Create: `apps/api/src/health/par-q.repository.ts`
- Create: `apps/api/src/health/par-q.service.ts`
- Test: `apps/api/src/health/par-q.service.spec.ts`

**Interfaces:**
- Consumes: `ParQScreening`, `NewParQScreening`, `ParQClearanceStatus` from `platform/db/schema/par-q.ts`. `requireScopedMember`. `AuditService.recordAudit`. `BusinessRuleError`, `BadRequestError`, `NotFoundError`.
- Produces:
  - `parQSubmitSchema`, `ParQSubmitDto`
  - `parQTrainerReviewSchema`, `ParQTrainerReviewDto`
  - `parQClearanceSchema`, `ParQClearanceDto` with `decision: 'cleared' | 'rejected'`
  - `ParQScreeningDto` (response class)
  - `ParQRepository.latestForMember(memberId: number): Promise<ParQScreening | null>`
  - `ParQRepository.insertScreening(values: NewParQScreening): Promise<number>`
  - `ParQRepository.updateScreening(id: number, memberId: number, values: Partial<NewParQScreening>): Promise<void>`
  - `isPtTrainingBlocked(status: ParQClearanceStatus | null): boolean`
  - `ParQService.submit(memberId, dto, actor): Promise<ParQScreeningDto>`
  - `ParQService.trainerReview(memberId, dto, actor): Promise<ParQScreeningDto>`
  - `ParQService.recordClearance(memberId, dto, actor): Promise<ParQScreeningDto>`
  - `ParQService.assertCanTrain(memberId: number): Promise<void>`

`ParQScreeningDto` fields: `id`, `member_id`, `version`, the seven booleans, the seven detail strings or null, `has_positive_answer`, `trainer_screening_notes`, `referral_required`, `referral_reason`, `declaration_accepted`, `client_signed_at`, `trainer_signed_at`, `trainer_user_id`, `clearance_status`, `cleared_at`, `cleared_by_user_id`. Datetimes are ISO strings or null.

Audit `entityName` is `par_q_screenings`. Actions are `par_q.submitted`, `par_q.trainer_reviewed`, `par_q.cleared`, `par_q.rejected`.

- [ ] **Step 1: Write the failing service tests**

Construct `ParQService` with fake repository, member repository, and audit, the same way `medical-history.service.spec.ts` builds its service. Cover:

```ts
it('submit_all_no_sets_passed', async () => {
  // seven answers false, declaration_accepted true
  // insert payload has has_positive_answer false, clearance_status 'passed',
  // referral_required false, referral_reason null, declaration_accepted true,
  // client_signed_at set, trainer_signed_at null
});

it('submit_any_yes_sets_pending_clearance', async () => {
  // q2_chest_pain_activity true and q2_details 'stops after warm-up'
  // has_positive_answer true, clearance_status 'pending_clearance', referral_required true
});

it('submit_yes_without_details_inserts_nothing', async () => {
  // q1 true, q1_details '   '
  // rejects with BadRequestError
  // insertScreening not called
});

it('submit_schema_requires_declaration_true', () => {
  // parQSubmitSchema.safeParse without declaration_accepted succeeds === false
});

it('trainer_review_does_not_change_clearance_status', async () => {
  // latest row clearance_status 'pending_clearance'
  // update set includes trainer_user_id, trainer_signed_at, notes
  // update set has no clearance_status key
});

it('trainer_review_requires_reason_when_referral_required', async () => {
  // referral_required true, referral_reason null
  // rejects with BadRequestError
  // updateScreening not called
});

it('record_clearance_from_pending_sets_cleared', async () => {
  // decision 'cleared' from pending_clearance
  // stores clearance_status 'cleared', cleared_at, cleared_by_user_id actor.id
});

it('record_clearance_from_pending_sets_rejected', async () => {
  // decision 'rejected' stores clearance_status 'rejected'
});

it('record_clearance_when_not_pending_throws', async () => {
  // latest status 'passed' rejects with BadRequestError
});

it('assertCanTrain_blocks_pending_and_rejected', async () => {
  // each status rejects with BusinessRuleError
  // error message === 'MEDICAL_CLEARANCE_REQUIRED'
  // details[0] is { member_id, clearance_status }
});

it('assertCanTrain_allows_passed_cleared_and_missing', async () => {
  // status 'passed', status 'cleared', and latestForMember null all resolve
});

it('assertCanTrain_uses_the_latest_row_only', async () => {
  // repository returns one row, the latest, with status 'passed'
  // resolves even if the test name records that an older pending row is not loaded
  // expect latestForMember called once and the call to resolve
});
```

`isPtTrainingBlocked` assertions live in the same file: `pending_clearance` and `rejected` are true; `passed`, `cleared`, and `null` are false.

- [ ] **Step 2: Run the tests and confirm they fail**

Run: `pnpm --filter api exec vitest run src/health/par-q.service.spec.ts`

Expected: FAIL because `ParQService` is not defined.

- [ ] **Step 3: Implement the repository, schemas, and service**

`latestForMember` selects by `member_id`, orders by `id` descending, limit 1.

`submit` calls `requireScopedMember`, validates detail pairing, inserts, audits `par_q.submitted`, reloads that id, returns `toDto`. Missing row after insert throws `NotFoundError`.

`trainerReview` and `recordClearance` call `requireScopedMember`, load latest, throw `NotFoundError('PAR-Q screening not found')` when there is no row. Clearance of a non-pending row throws `BadRequestError('Clearance is only recorded for a screening that is pending clearance')`.

`assertCanTrain` does not check row scope and does not audit. Blocked call:

```ts
throw new BusinessRuleError('MEDICAL_CLEARANCE_REQUIRED', [
  { member_id: memberId, clearance_status: status },
]);
```

Detail strings on the stored row are trimmed. A No stores null for that detail.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/health/par-q.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/health/par-q.dto.ts apps/api/src/health/par-q.repository.ts apps/api/src/health/par-q.service.ts apps/api/src/health/par-q.service.spec.ts
git commit -m "feat: add PAR-Q submission and clearance service"
```

---

### Task 2: PAR-Q endpoints

**Files:**
- Create: `apps/api/src/health/par-q.controller.ts`
- Create: `apps/api/src/health/par-q.controller.spec.ts`
- Create: `apps/api/src/health/par-q.module.ts`
- Modify: `apps/api/src/app.module.ts`
- Modify: `apps/api/src/platform/db/seed/permissions.ts`
- Modify: `apps/api/src/platform/db/seed/roles.ts`

**Interfaces:**
- Consumes: Task 1 schemas and `ParQService` methods.
- Produces: `ParQModule` exporting `ParQService`. Routes under controller path `members/:id/par-q`.

| Method | Path | Permission | Service |
|---|---|---|---|
| POST | `/` | `health.update` | `submit` |
| PATCH | `/trainer-review` | `health.review` | `trainerReview` |
| POST | `/clearance` | `health.approve` | `recordClearance` |

POST handlers return 201. PATCH returns 200. Tag the controller `HEALTH`. Use `@ApiBearerAuth('bearer')`, `ParseIntPipe` on `id`, and `ZodValidationPipe` on each body.

Permission slug to seed: `{ module: 'HEALTH', action: 'review', slug: 'health.review', description: 'Record PAR-Q trainer screening notes and referral' }`. Add `'health.review'` to the `admin` and `trainer` slug lists only.

- [ ] **Step 1: Write the failing controller test**

```ts
it('submit_trainerReview_and_recordClearance_delegate', async () => {
  // each handler is called with (memberId, body, actor)
  // expect the matching ParQService method called with those three arguments
});
```

- [ ] **Step 2: Run the test and confirm it fails**

Run: `pnpm --filter api exec vitest run src/health/par-q.controller.spec.ts`

Expected: FAIL because the controller module is missing.

- [ ] **Step 3: Implement the controller, module, app import, and permission seed**

Follow `MedicalHistoryController` for decorator order. Register `ParQController`, `ParQRepository`, and `ParQService` on `ParQModule`. Export `ParQService`. Import `ParQModule` from `AppModule` next to `PeopleModule`.

The direct handler test does not execute `PermissionGuard`. The permission strings above are the contract. Read the decorators after editing.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/health/par-q.controller.spec.ts src/health/par-q.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/health/par-q.controller.ts apps/api/src/health/par-q.controller.spec.ts apps/api/src/health/par-q.module.ts apps/api/src/app.module.ts apps/api/src/platform/db/seed/permissions.ts apps/api/src/platform/db/seed/roles.ts
git commit -m "feat: expose PAR-Q screening endpoints"
```

---

### Task 3: PT booking and attendance gate

**Files:**
- Modify: `apps/api/src/sched/booking.service.ts`
- Modify: `apps/api/src/sched/booking.service.spec.ts`
- Modify: `apps/api/src/sched/sched.module.ts`
- Modify: `apps/api/src/attn/session-attendance.service.ts`
- Modify: `apps/api/src/attn/session-attendance.service.spec.ts`
- Modify: `apps/api/src/attn/attn.module.ts`

**Interfaces:**
- Consumes: `ParQService.assertCanTrain(memberId: number): Promise<void>` from Task 1.
- Produces: no new exports. PT booking and attended-true marking surface `BusinessRuleError` message `MEDICAL_CLEARANCE_REQUIRED`.

Append `ParQService` as the last constructor argument on both services so existing positional fakes stay in front of it. Import `ParQModule` from `SchedModule` and `AttnModule`.

`book`: after the schedule and member are loaded, when `schedule.pt_subscription_id != null`, `await this.parQService.assertCanTrain(memberId)` before the transaction. A thrown error must leave `insertParticipant` uncalled.

`mark`: after the participant is loaded, when `dto.attended === true` and `schedule.pt_subscription_id != null`, `await this.parQService.assertCanTrain(participant.member_id)` before `updateParticipant`.

Existing specs: pass `parQService = { assertCanTrain: vi.fn().mockResolvedValue(undefined) }` into both constructors. Do not add `pt_subscription_id` to the fixtures those existing tests already use. The current attendance fixture is named PT and has no `pt_subscription_id`; leave it, so the old test stays on the ungated path.

- [ ] **Step 1: Write the failing gate tests**

```ts
it('book_pt_occurrence_blocks_when_clearance_pending', async () => {
  // schedule.pt_subscription_id = 900
  // assertCanTrain rejects with BusinessRuleError('MEDICAL_CLEARANCE_REQUIRED')
  // book rejects with that error
  // insertParticipant not called
});

it('book_class_does_not_check_clearance', async () => {
  // schedule has no pt_subscription_id
  // book resolves
  // assertCanTrain not called
});

it('mark_attended_true_on_pt_blocks_when_rejected', async () => {
  // schedule.pt_subscription_id = 900, attended true
  // assertCanTrain rejects with message MEDICAL_CLEARANCE_REQUIRED
  // updateParticipant not called
});

it('mark_attended_false_on_pt_skips_clearance', async () => {
  // schedule.pt_subscription_id = 900, attended false
  // mark resolves
  // assertCanTrain not called
  // updateParticipant called with attended false
});
```

- [ ] **Step 2: Run the tests and confirm the new ones fail**

Run: `pnpm --filter api exec vitest run src/sched/booking.service.spec.ts src/attn/session-attendance.service.spec.ts`

Expected: FAIL on the four new tests because `assertCanTrain` is not called. Existing tests still pass once the constructor fake is in place. If the constructor change is not in yet, the run fails earlier on argument count. Add the fake in this step so only the new assertions fail.

- [ ] **Step 3: Call `assertCanTrain` from `book` and `mark`**

Keep the call outside the write. Do not catch the error.

- [ ] **Step 4: Run the tests and confirm they pass**

Run: `pnpm --filter api exec vitest run src/sched/booking.service.spec.ts src/attn/session-attendance.service.spec.ts src/health/par-q.service.spec.ts`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/sched/booking.service.ts apps/api/src/sched/booking.service.spec.ts apps/api/src/sched/sched.module.ts apps/api/src/attn/session-attendance.service.ts apps/api/src/attn/session-attendance.service.spec.ts apps/api/src/attn/attn.module.ts
git commit -m "feat: block PT booking without medical clearance"
```

---

## Spec coverage

| Parent requirement | Task |
|---|---|
| PTF-07 submit, positive flag, doctor referral, trainer review, admin clearance | Task 1 |
| PTF-08 three endpoints and validation | Task 2 |
| PTF-09 block PT booking when clearance is pending | Task 3, plus `rejected` from Review Focus 2 |
| Walkthrough: positive PAR-Q blocks PT until clearance | Task 1 statuses + Task 3 call sites |
| OpenAPI, Flutter, workout-session start | Later phases. `assertCanTrain` is the function Phase 4 can call |

## Out of scope

- `docs/openapi/v1.yaml`, `packages/api_client`, Flutter screens.
- `WorkoutSessionService.start` and `PtSubscriptionService.purchase`.
- Changing `par_q_screenings` or the Phase 1 seed. The seed's passed row may carry `cleared_by_user_id`. New `passed` submissions leave that column null.
