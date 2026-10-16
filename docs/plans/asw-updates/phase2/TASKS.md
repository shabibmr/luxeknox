# Tasks Register: Phase 2 — Backend PAR-Q+ & Safety Gate

Derived from [PLAN.md](./PLAN.md).
Parent spec: [../PLAN.md](../PLAN.md) §3.1 and [../TASKS.md](../TASKS.md) PTF-07, PTF-08, PTF-09.

**Rule:** each task touches at most 7 files, not counting generated code.
**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`

3 tasks. Phase 1 schema and seed are already in the tree (`par_q_screenings`, PTF-01 and PTF-06). This phase does not migrate.

Steps, signatures, and test names are in [PLAN.md](./PLAN.md). This register is the checklist.

---

## Checklist

**Phase 2: Backend PAR-Q+ & Safety Gate**
- [ ] P2-01 `ParQService`: submit, trainer review, clearance, `assertCanTrain` <!-- id: 1 -->
- [ ] P2-02 `ParQController` endpoints, `ParQModule`, `health.review` permission <!-- id: 2 -->
- [ ] P2-03 Scheduling gate: block PT booking and attended-true marking <!-- id: 3 -->

Maps to the parent register as P2-01 = PTF-07, P2-02 = PTF-08, P2-03 = PTF-09.

---

## Dependency graph

```
Phase 1 par_q_screenings (done)
  │
  └─ P2-01 service
       ├─ P2-02 endpoints
       └─ P2-03 booking and attendance gate
```

P2-02 and P2-03 both need `ParQService` from P2-01. They do not need each other.

---

## Detailed task specifications

### P2-01: `ParQService`

* **Parent:** PTF-07
* **Plan:** Task 1
* **Files:** `apps/api/src/health/par-q.dto.ts`, `apps/api/src/health/par-q.repository.ts`, `apps/api/src/health/par-q.service.ts`, `apps/api/src/health/par-q.service.spec.ts`
* **Produces:** `submit`, `trainerReview`, `recordClearance`, `assertCanTrain`, `isPtTrainingBlocked`, and the three Zod schemas.
* **Rules:** All No stores `passed`. Any Yes stores `pending_clearance` and `referral_required`. A Yes with a blank detail inserts nothing. Clearance runs only from `pending_clearance` and stores `cleared` or `rejected`. `assertCanTrain` throws `BusinessRuleError` message `MEDICAL_CLEARANCE_REQUIRED` for `pending_clearance` and `rejected`, and allows `passed`, `cleared`, and no row. The latest row wins.
* **Done criteria:** `pnpm --filter api exec vitest run src/health/par-q.service.spec.ts` passes.

### P2-02: `ParQController`

* **Parent:** PTF-08
* **Plan:** Task 2
* **Files:** `apps/api/src/health/par-q.controller.ts`, `apps/api/src/health/par-q.controller.spec.ts`, `apps/api/src/health/par-q.module.ts`, `apps/api/src/app.module.ts`, `apps/api/src/platform/db/seed/permissions.ts`, `apps/api/src/platform/db/seed/roles.ts`
* **Routes:** `POST /v1/members/:id/par-q` (`health.update`), `PATCH /v1/members/:id/par-q/trainer-review` (`health.review`), `POST /v1/members/:id/par-q/clearance` (`health.approve`).
* **Done criteria:** Controller spec passes, and `health.review` is seeded for `admin` and `trainer` only. OpenAPI yaml stays unchanged.

### P2-03: Scheduling gate

* **Parent:** PTF-09
* **Plan:** Task 3
* **Files:** `apps/api/src/sched/booking.service.ts`, `apps/api/src/sched/booking.service.spec.ts`, `apps/api/src/sched/sched.module.ts`, `apps/api/src/attn/session-attendance.service.ts`, `apps/api/src/attn/session-attendance.service.spec.ts`, `apps/api/src/attn/attn.module.ts`
* **Rules:** Call `assertCanTrain` when `pt_subscription_id` is set. Booking calls it for that member. Attendance calls it only when `attended` is true. A class booking and a PT no-show do not call it.
* **Done criteria:** `pnpm --filter api exec vitest run src/sched/booking.service.spec.ts src/attn/session-attendance.service.spec.ts src/health/par-q.service.spec.ts` passes.

---

## Not in this phase

OpenAPI (PTF-19), Flutter (PTF-23, PTF-27), workout-session start (Phase 4), and PT package purchase. Phase 4 can call the `assertCanTrain` from P2-01 when it grows a PT-specific start path.
