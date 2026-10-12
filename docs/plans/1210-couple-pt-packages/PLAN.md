# Plan: Couple P.T Packages

Tasks register: [TASKS.md](./TASKS.md)
Builds on: [Couple Membership Packages](../1210-couple-membership-packages/PLAN.md) and [ADR-0010](../../adr/0010-couple-memberships.md).

## Context
Couple packages exist for gym memberships only. Every PT package (`pt_products`) still covers one member and one trainer slot. We need **Couple PT packages**: two members buy PT together and train in the same session with the same trainer. Selling one from a member dossier must require picking a second member (the partner).

The app is still in development, so, as for memberships:
- the schema is edited in place
- the local DB is reset
- nothing needs defaults, compatibility shims or migration guards for existing rows.

### Assumptions (change these before building if they are wrong)
- **What "couple PT" means:** two members share one trainer, one weekly slot and one set of sessions. Each session is one hour with both members present.
- **Billing:** the package price is the total for both. One invoice is raised against the primary (dossier) member.
- **Lifecycle:** the two PT subscriptions are fully linked. Renew, reassign trainer and change slot always apply to both, so dates, trainer and slot stay identical. (PT has no freeze or cancel today, so there is nothing else to link.)
- **Eligibility:** each member needs their own active, unexpired gym membership (ADR-0009 §5). It does not have to be a couple membership. *(Superseded: PT now includes a membership, see [ADR-0012](../../adr/0012-pt-includes-membership.md).)*
- **Partner already has an open PT:** the sale is rejected. The replace-and-credit flow from the membership plan is out of scope, because PT has no cancel operation to build it on. See "Open decisions".

## Design: two linked subscription rows, one shared session
Each member gets their own `pt_subscriptions` row. The rows point at each other through `partner_subscription_id`. Same pattern as ADR-0010, and for the same reason: every per-member reader keeps working for the partner without change.
- trainer write access: `PtAccessService` / `hasActiveForMemberAndTrainer`
- the member's current PT in `summaryForMember` and the dossier
- the "one open PT per member" rule
- `members.assigned_trainer_id`
- the trainer-led workout session gate

Sessions are different from membership. A trainer-hour can hold only one `schedules` row (the trainer-busy check is an overlap check), so a couple PT cannot have one session row per member. Instead:
- One `schedules` row per occurrence, `max_capacity = 2`, two `schedule_participants` (one per member). Attendance is already per participant.
- That row's `pt_subscription_id` points at the **primary** row. The primary row is the one that owns the sessions and the invoice (`pt_subscriptions.is_primary = true`).
- The partner row is found through `partner_subscription_id`. A helper `occurrenceOwnerId(sub)` returns the primary row id for any row, and every place that touches sessions (`findFutureOccurrenceIds`, conflict exclusion, "occupied by") goes through it.

Lifecycle operations update both rows in one transaction.

## Backend (`apps/api`)

### 1. Schema, edited in place
- Edit `drizzle/0020_personal_training.sql` and `src/platform/db/schema/personal-training.ts` directly; there is no new migration.
  - `pt_products.package_type VARCHAR(16) NOT NULL`, CHECK it is `single` or `couple`.
  - `pt_subscriptions.partner_subscription_id BIGINT UNSIGNED NULL`, a self-FK with an index.
  - `pt_subscriptions.is_primary BOOLEAN NOT NULL DEFAULT TRUE`. A single subscription is its own primary.
- Seed (`seed/pt-products.ts`): mark `PT-1M` and `PT-3M` as `single`, add "Couple PT 1 Month" (`CPT-1M`) and "Couple PT 3 Month" (`CPT-3M`).
- Reset the local DB on localhost:3308, then `pnpm api:migrate`, `pnpm api:seed`, `pnpm --filter api db:check`.

### 2. Product
Files: `pt/pt.dto.ts`, `pt-product.service.ts`, `pt-product.repository.ts`, Swagger classes in `pt-product.controller.ts`.
- `package_type` is required on create.
- It cannot be changed on PATCH, because linked rows depend on it.
- The list accepts an optional `package_type` filter.

### 3. Schedule service: more than one member
`pt-schedule.service.ts`:
- `findConflicts` takes `memberIds: number[]` instead of `memberId`. A date is a `member_busy` conflict if **any** of them has an overlapping booked session. Excluding a subscription's own sessions uses `occurrenceOwnerId`.
- `buildGrid` accepts optional `partner_member_id` (a new sale). For a re-plan (`exclude_subscription_id`), it works out the partner from the subscription itself. A cell is occupied when either member is busy.
- "Occupied by" for a couple session reads "A & B" (`memberNamesForSubscriptions` joins the partner row).

### 4. Purchase: `PtSubscriptionService.purchase` (`pt-subscription.service.ts:113`)
New field on `PtPurchaseDto`: `partner_member_id?`.

Validation (all before anything is written):
- Couple product requires a partner; a single product rejects one (BadRequestError).
- Partner must exist (NotFoundError) and differ from `member_id` (BadRequestError).
- Both members need an active, unexpired gym membership. The error names the member who fails.
- Neither member may have an open PT overlapping the period (ConflictError, naming the member).
- The slot must be free for both members and the trainer on every date (`findConflicts` with both ids).
- `assertPaymentActivates` is unchanged: it runs on the package's total price.

In one transaction:
1. Lock both members in ascending id order, then the trainer. Keeping one lock order avoids deadlocks between concurrent sales.
2. Re-check overlap and conflicts under the locks.
3. Insert row A (primary, `is_primary = true`), insert row B (`is_primary = false`, `partner_subscription_id = A`), then set A's `partner_subscription_id = B`. Both rows get the same dates, trainer, weekdays, slot and status, and their own `membership_id`.
4. `paymentService.create({member_id: primary, subtotal: base_price, discount_amount, ...}, actor, {ptSubscriptionId: A})`.
5. Generate the occurrences once: capacity 2, both members as participants, `pt_subscription_id = A`, title `PT · A & B`.
6. Set `assigned_trainer_id` for both members, using the same "future PT must not steal an active trainer" rule per member.
7. Audit for both rows.

A single product takes the same path as today (`partner_member_id` absent, capacity 1).

### 5. Linked lifecycle (`pt-subscription.service.ts`)
| Operation | Location | Change |
|---|---|---|
| `renew` | :154 | Also renews the partner. Billed to the primary, whichever row it was started from. The target product must have the same `package_type`. Both memberships must still be active. Creates two new linked rows, each with its own `renewed_from_id`. |
| `reassignTrainer` | :195 | Replans the shared sessions once, updates both rows, writes a `pt_subscription_changes` row for each. |
| `changeSlot` | :221 | Same as `reassignTrainer`. |
| `replan` | :364 | Cancels future occurrences of the owner row, regenerates with both members as participants, bumps `row_version` on both rows, updates `assigned_trainer_id` for both. |
| `runStatusTransitions` | :250 | No logic change: both rows have identical dates so they move together. A spec proves it, including `applyDueTrainerChanges`. |

The partner's `row_version` is re-read inside the transaction. The client sends only the id of the row it is acting on.

Single-to-couple conversion on renew is rejected, in both directions.

### 6. Read model
`present()` and `summaryForMember` return `package_type`, `is_primary`, `partner_subscription_id`, `partner_member_id` and `partner_member_name`. A member-scoped read shows only the partner's name, never other partner data.

### 7. Contract and docs
- Update `docs/openapi/v1.yaml`:
  - `PtProduct` / `PtProductWrite`: `package_type`
  - `PtSubscription`: partner fields
  - `PtPurchase`: `partner_member_id`
  - the schedule-grid query: `partner_member_id`
- Keep `pnpm --filter api openapi:check` green.
- Update the PT rules in `docs/backend-frd.md` (FR-MEMB-009, FR-SCHED-005 and FR-SCHED-016), the PT section of `docs/database-entities.md` and `docs/screens/admin-app-screens.md`.
- Add `docs/adr/0011-couple-pt-subscriptions.md`: "Couple PT as two linked subscriptions sharing one session". Index it in `docs/adr/README.md`. Note in ADR-0009 §3 that capacity is now 1 or 2.

## Flutter (`app/`)

### 1. Regenerate the client and update models
- Run `tool/gen_api.sh`.
- `PtProduct` gets `packageType`, using a new `PtPackageType { single, couple }` enum in the PT feature. This keeps the PT feature free of a dependency on the membership feature. Map it in `pt_mappers.dart` both ways.
- `PtSubscription` gets `isPrimary`, `partnerSubscriptionId`, `partnerMemberId`, `partnerMemberName` and `bool get isCouple`.
- `PurchasePtParams` and the repository, datasource and use case gain `partnerMemberId`. `GetPtScheduleGridParams` gains `partnerMemberId`.

### 2. Package admin screen
`pt_packages_screen.dart`: a required Single/Couple `SegmentedButton` in the package form. It is read-only on edit. Couple rows in the list get a "Couple" chip.

### 3. Sell flow (`sell_pt_cubit.dart`, `sell_pt_screen.dart`)
State gains `partner` and `partnerCheck` (a loading/ok/blocked result). New events: `selectPartner(Person?)`.
- Selecting a single package clears the partner.
- For a couple package, show a required "Partner (second member)" `MemberPickerField` right after the package dropdown, with `excludeMemberIds: {memberId}`.
- On selection, the cubit fetches the partner's PT summary and gym membership using the existing use cases, and shows an inline block message ("Priya already has PT until 03 Nov", "Priya's membership has expired") instead of waiting for the server to reject. The server still enforces every rule.
- The grid reload includes `partnerMemberId`, so cells busy for either member show as occupied.
- `canSubmit` additionally needs a valid partner for a couple package.
- The summary card shows the package price as the total for both members.
- A re-plan from either member's dossier shows a note: "This change applies to both members."

### 4. Display
- **Dossier PT card** (`member_dossier_screen.dart`, `member_dossier_pt.dart`): "Couple with <name>", which links to the partner's dossier. On the partner's side, also "Billed to <primary>".
- **Renew dialog** (`_RenewPtDialog`): lists only products of the same `packageType`, with the note that renewal covers both members.
- **Strings:** new text goes in `pt_strings.dart`.

## Tests
**Backend (Vitest)**, in `pt-subscription.service.spec.ts`, `pt-schedule.spec.ts`, a new `pt-product.service.spec.ts` and `payment.service.spec.ts`:
- A couple product without a partner is rejected; a single product with a partner is rejected.
- A member picked as their own partner is rejected.
- Either member without an active membership is rejected, with the right name in the message.
- Either member with an open overlapping PT is rejected.
- The happy path creates two cross-linked rows, one invoice on the primary carrying the discount, and one set of sessions with capacity 2 and two participants.
- The slot is blocked when only the partner is busy.
- Renew, reassign trainer and change slot hit both rows. A cross-type renew is rejected.
- The status job moves both rows together.
- The single-package path is unchanged.

**Flutter (bloc_test + mocktail + widget tests):**
- `sell_pt_cubit_test.dart`: partner required, partner check blocks, partner cleared when switching to a single package, grid params include the partner, submit params carry `partnerMemberId`.
- Widget tests: the partner picker only for couple packages, the PT package form toggle and chip, the dossier "Couple with" line.

## Verification
1. Reset the local DB, then run `pnpm api:migrate`, `pnpm api:seed`, `pnpm --filter api db:check`, `openapi:check` and `test`.
2. Run `bash tool/gen_api.sh`, then in `app/`: `flutter analyze`, `bash tool/check_layers.sh` and `flutter test`.
3. Manual check in the app, run on Edge:
   1. Open member A's dossier, choose "Add Personal Training" and pick "Couple PT 1 Month". Confirm the partner field is mandatory.
   2. Pick member B who has an active gym membership. Choose weekdays, a trainer and an hour. Pay and submit.
   3. Confirm A and B both show "Couple with …" with the same dates, trainer and slot, with one invoice on A.
   4. Confirm the trainer's calendar shows one session per day with two participants.
   5. Renew and change the slot from B's side and confirm both rows change.
   6. As the trainer, confirm both members have write access to goals and plans.

## Risks
- **Capacity 2 on a PT session.** Check that no booking path lets a third member join, and that a member cancelling their own booking from the schedule API is handled for a couple session. The first is covered while building CP-07; any gap found there becomes a follow-up.
- **Rows must never diverge.** Every lifecycle operation touches both rows or neither. The rule is stated in ADR-0011 and each operation has a "both rows" spec.
- **Lock order.** Two members plus a trainer are locked in a fixed order (members ascending, then trainer). A concurrent sale involving the same pair in the opposite roles must not deadlock; CP-07 includes a spec for it.

## Open decisions
1. **Replace the partner's existing PT?** Memberships offer this, with a pro-rated credit. For PT the plan says no: reject the sale. Adding it needs a new "cancel PT" operation (cancel future sessions, free the trainer slot, compute a credit by remaining sessions), which is a feature of its own. Say so if you want it in this plan.
2. **Does a couple PT need a couple gym membership?** The plan says no, only two active memberships. The stricter rule is a small change in CP-07.

## Out of scope
- Replacing or cancelling the partner's existing PT (see decision 1).
- Groups of more than two members.
- Split invoices.
- Converting a single PT into a couple PT on renew.
- Different slots or trainers for the two members of a couple.
- Trainer capacity (`max_clients_capacity`), which ADR-0009 already leaves out of PT.
