# Tasks Register: Phase 3 — Backend Lifestyle Intake & Macrocycle Program Design

Derived from [PLAN.md](./PLAN.md).
Parent spec: [../PLAN.md](../PLAN.md) §3.2 and §3.3 (blueprint only) and [../TASKS.md](../TASKS.md) PTF-10, PTF-11, PTF-12.

**Rule:** each task touches at most 7 files, not counting generated code.
**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`

3 tasks. Phase 1 schema is already in the tree (`member_lifestyle_intakes`, workout blueprint columns, PTF-02 and PTF-04). This phase does not migrate.

Steps, signatures, and test names are in [PLAN.md](./PLAN.md). This register is the checklist.

---

## Checklist

**Phase 3: Backend Lifestyle Intake & Macrocycle Program Design**
- [x] P3-01 `LifestyleIntakeService`: replace-style upsert and fetch <!-- id: 1 -->
- [x] P3-02 `LifestyleIntakeController` endpoints, `PeopleModule` registration, `health.lifestyle` <!-- id: 2 -->
- [ ] P3-03 `WorkoutPlanService` blueprint on create, update, and template assign <!-- id: 3 -->

Maps to the parent register as P3-01 = PTF-10, P3-02 = PTF-11, P3-03 = PTF-12.

---

## Dependency graph

```
Phase 1 member_lifestyle_intakes (done)
  │
  └─ P3-01 service
       └─ P3-02 endpoints

Phase 1 workout_plans blueprint columns (done)
  │
  └─ P3-03 plan create, update, and assign
```

P3-03 does not use the lifestyle service. It can run beside P3-01.

---

## Detailed task specifications

### P3-01: `LifestyleIntakeService`

* **Parent:** PTF-10
* **Plan:** Task 1
* **Files:** `apps/api/src/people/lifestyle-intake.dto.ts`, `apps/api/src/people/lifestyle-intake.repository.ts`, `apps/api/src/people/lifestyle-intake.service.ts`, `apps/api/src/people/lifestyle-intake.service.spec.ts`
* **Produces:** `get`, `put`, `lifestyleIntakePutSchema`, `LifestyleIntakeDto`.
* **Rules:** One row per member. PUT replaces the row. Stress is an integer 1–10. Priorities are exactly `sleep`, `nutrition`, `activity`, `recovery`, stored in that order. Omitted optional text stores null. A trainer write sets `conducted_by_trainer_id` to `actor.profileId`. `sleep_hours_typical` is stored as a one-decimal string.
* **Done criteria:** `pnpm --filter api exec vitest run src/people/lifestyle-intake.service.spec.ts` passes.

### P3-02: `LifestyleIntakeController`

* **Parent:** PTF-11
* **Plan:** Task 2
* **Files:** `apps/api/src/people/lifestyle-intake.controller.ts`, `apps/api/src/people/lifestyle-intake.controller.spec.ts`, `apps/api/src/people/people.module.ts`, `apps/api/src/platform/db/seed/permissions.ts`, `apps/api/src/platform/db/seed/roles.ts`
* **Routes:** `GET /v1/members/:id/lifestyle-intake` (`health.read`), `PUT /v1/members/:id/lifestyle-intake` (`health.lifestyle`). Both return 200.
* **Done criteria:** Controller spec passes, and `health.lifestyle` is seeded for `admin`, `trainer`, `employee`, and `member` only. OpenAPI yaml stays unchanged.

### P3-03: Workout plan blueprint

* **Parent:** PTF-12
* **Plan:** Task 3
* **Files:** `apps/api/src/work/workout-plan.dto.ts`, `apps/api/src/work/workout-plan.service.ts`, `apps/api/src/work/workout-plan.service.spec.ts`
* **Rules:** Optional fields on create and update: `primary_objective_12w`, `milestone_4w`, `sessions_per_week` (1–14), `target_session_duration_minutes` (15–180), `split_type` (1–64), `cardio_protocol`, `mobility_protocol`, `progression_methods` (`load`, `reps`, `volume`, `density`, `technique` only), `main_success_measure` (1–255), `trainer_programming_notes`. Update writes a blueprint key only when the body includes it. Assign copies all ten columns from the template.
* **Done criteria:** `pnpm --filter api exec vitest run src/work/workout-plan.service.spec.ts` passes.

---

## Not in this phase

OpenAPI (PTF-19), Flutter lifestyle and plan-builder screens (PTF-24, PTF-29), workout set logging and session ratings (PTF-13, PTF-14), the pain hook (PTF-15), PAR-Q (PTF-07 through PTF-09), and member preference columns from PTF-05. Page 3 previous injuries stay on medical history.
