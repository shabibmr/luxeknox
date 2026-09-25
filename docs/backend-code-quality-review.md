# Backend code quality review

Date: 2026-09-24
Scope: `apps/api` on `main` (uncommitted working tree)
Verdict: **Do not approve.**

The backend works as a set of vertical slices, but two ownership boundaries are already splitting, and the copies do not agree.

## 1. Membership lifecycle is implemented twice

`MembershipService.create` / `renew` (`apps/api/src/memb/membership.service.ts`) and `PaymentService.coordinateMembership` (`apps/api/src/pay/payment.service.ts`, around line 184) both insert a membership, extend `end_date`, add PT sessions, and write history. They already disagree:

- A desk renew switches `product_id`. `MembershipService.renew` keeps the current product.
- The payment path never emits `membership.created` or `membership.renewed`.
- `purchaseMembership` accepts `start_date` and then drops it. Activation always starts today.
- `renewMembership` checks `expected_row_version` before the transaction. `updateMembership` then writes by id only, so the version is not part of the update.
- Both methods return `payment.membership_id!`. A partial invoice with activation disabled leaves that null.

`purchaseMembership` and `renewMembership` are not two operations. Both call `create()`, and `create()` decides assign versus renew from whatever membership is currently active. The names describe a branch that does not exist.

Move assign and renew into `MembershipService` as transaction-joinable methods (the ambient `runInTransaction` already joins). Delete `coordinateMembership`, the private `addDays` copy, and the two wrappers. POS create should pass a product id and call that one method.

## 2. Member access is copied instead of using the helper that exists

`assertPeopleRowScope` in `apps/api/src/people/row-scope.ts` is the member-visibility rule: staff sees all, a member sees self, a trainer sees assigned members, and everyone else gets 404. The same `if admin / if member / if trainer / load member / compare assigned_trainer_id` block is rewritten in diet plans, diet logs, workout plans, workout sessions, goals, measurements, progress notes, and progress photos. Payments and memberships have a fourth variant (`listScope` plus `assertReadScope`) that uses a fake profile id of `-1`.

The copies do not match. `WorkoutPlanService.assertCanManagePlan` (`apps/api/src/work/workout-plan.service.ts`, around line 62) returns for every trainer. The comment says the assignment check belongs there. It was never written, so any trainer can publish, archive, or replace exercises on any plan. The diet twin actually checks assignment. Goal and notification code throw Nest `ForbiddenException`; people, pay, and diet throw `ForbiddenError` / `NotFoundError`.

One async `assertMemberAccess(actor, memberId)` next to `row-scope.ts`, used by every module. Delete the private copies. Fix the workout-plan hole by calling it.

## 3. Schedule create is an optional bag

`scheduleWriteSchema` makes `schedule_type_id`, `title`, `start_time`, and `end_time` optional so update can send a patch. `ScheduleService.create` then rejects the missing fields at runtime and uses `!` on the insert (`apps/api/src/sched/schedule.service.ts`, around line 188). Split a required create schema from the patch schema and those branches go away.

## 4. The database boundary is `any`

`DrizzleDb<any>` and `AnyTransaction = MySqlTransaction<any, any, any, any>` make `BaseRepository.getDb()` untyped, so repositories cast `as any` on every query. `getActiveCondition` also guesses `is_active` versus `status = 'active'` off the table object. Type the client with the real schema once. The casts and the column probe are the same problem.

## 5. Reports are an untyped row bag

`ReportsRepository` returns `Array<Record<string, any>>`, and `getMembersReport` loads every member date of birth to bucket ages in process (`apps/api/src/reports/reports.repository.ts`, around line 77). Give each report a typed row, and do the age buckets in SQL.

No file is over 1,000 lines. `payment.service.ts` is the one growing toward that, because it absorbed membership. Extract that before adding refund, receipt, or gateway behavior to the same class.
