# Tasks Register: Couple P.T Packages

Derived from [PLAN.md](./PLAN.md).

Each task has a **Mirrors** line pointing at the membership task and code it follows ([membership TASKS.md](../1210-couple-membership-packages/TASKS.md)). Read that code before starting the task.

**Rule:** each task touches at most 7 files, not counting generated code.
**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`

22 tasks across 8 phases. The app is in development, so the schema is edited in place and the local DB is reset.

All backend paths are under `apps/api/src/pt/` unless stated. All Flutter paths are under `app/lib/features/pt/` unless stated.

---

## Checklist

**Phase 1: Schema and seed**
- [x] CP-01 Edit `0020_personal_training.sql` and the Drizzle schema in place, then reset the local DB <!-- id: 1 -->
- [x] CP-02 Seed the couple PT packages <!-- id: 2 -->

**Phase 2: Backend product**
- [x] CP-03 `package_type` on PT products <!-- id: 3 -->

**Phase 3: Backend subscription core**
- [x] CP-04 Repository support for partner links, owner resolution and the two-member lock <!-- id: 4 -->
- [x] CP-05 Schedule service: conflicts and grid for more than one member <!-- id: 5 -->
- [x] CP-06 Read model: partner fields in `present()` and the summary <!-- id: 6 -->
- [x] CP-07 Purchase a couple PT (two linked rows, one shared session, one invoice) <!-- id: 7 -->

**Phase 4: Backend linked lifecycle**
- [x] CP-08 Linked renew and the package-type match rule <!-- id: 8 -->
- [x] CP-09 Linked reassign trainer and change slot <!-- id: 9 -->
- [x] CP-10 Status job and trainer access for a linked pair <!-- id: 10 -->

**Phase 5: Contract and docs**
- [x] CP-11 OpenAPI `v1.yaml` and the parity check <!-- id: 11 -->
- [x] CP-12 FRD, entities doc, ADR-0011, screens doc <!-- id: 12 -->

**Phase 6: Flutter data and domain**
- [ ] CP-13 Regenerate `packages/api_client` <!-- id: 13 -->
- [ ] CP-14 `PtPackageType` on the product entity and model <!-- id: 14 -->
- [ ] CP-15 Partner fields on the subscription entity and model <!-- id: 15 -->
- [ ] CP-16 Purchase and grid params carry the partner <!-- id: 16 -->

**Phase 7: Flutter UI**
- [ ] CP-17 PT package form Single/Couple toggle and list chip <!-- id: 17 -->
- [ ] CP-18 `SellPtCubit` couple state, partner check and validation <!-- id: 18 -->
- [ ] CP-19 Sell PT screen: partner picker, summary, re-plan note <!-- id: 19 -->
- [ ] CP-20 Dossier "Couple with <partner>" and the renew dialog filter <!-- id: 20 -->

**Phase 8: Verification**
- [ ] CP-21 API e2e: couple PT sale and lifecycle <!-- id: 21 -->
- [ ] CP-22 Full automated pass and manual walkthrough on Edge <!-- id: 22 -->

---

## Dependency graph

```
CP-01 ─ CP-02
  │
  ├─ CP-03 ─ CP-04 ─┬─ CP-05 ─┐
  │                 └─ CP-06 ─┴─ CP-07 ─┬─ CP-08 ─┐
  │                                     ├─ CP-09 ─┼─ CP-10
  │                                     └─ CP-12  │
  │                                               │
  └─ CP-11 (needs CP-03, CP-05, CP-06, CP-07 shapes) ─ CP-13 ─┬─ CP-14 ─ CP-17
                                                              ├─ CP-15 ─ CP-20
                                                              └─ CP-16 ─ CP-18 ─ CP-19

CP-07..CP-10 ─ CP-21 ─┐
CP-17..CP-20 ─────────┴─ CP-22
```

You can write CP-11 contract-first, as soon as the shapes in the plan are agreed. After that, the backend (phases 2–4) and Flutter (phases 6–7) can proceed in parallel.

The member picker already supports `excludeMemberIds` (membership task CM-19), so no picker work is needed here.

---

## Phase 1: Schema and seed

### CP-01: Edit the schema in place and reset the local DB

**Mirrors:** CM-01. `0006_memberships.sql` and `schema/memberships.ts`: `package_type`, `partner_membership_id` (self-FK + index). PT needs no paired-freeze column.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Risk** | Medium. Rewrites an applied migration, so every dev DB must be reset. |
| **Files** | `apps/api/drizzle/0020_personal_training.sql`, `apps/api/src/platform/db/schema/personal-training.ts`, `apps/api/drizzle/meta/*` (only if `db:check` needs it) |

Changes:
- `pt_products.package_type VARCHAR(16) NOT NULL`, with `CHECK (package_type IN ('single','couple'))`.
- `pt_subscriptions.partner_subscription_id BIGINT UNSIGNED NULL`, a self-FK to `pt_subscriptions(id)` with an index.
- `pt_subscriptions.is_primary BOOLEAN NOT NULL DEFAULT TRUE`.

Reset the local MySQL schema on localhost:3308 (drop and recreate the database), then run `pnpm api:migrate`.

**Done when:**
- The migration runs cleanly on an empty DB.
- `pnpm --filter api db:check` reports no drift.
- Type errors appear only where `package_type` is now required. CP-02 and CP-03 fix those.

### CP-02: Seed the couple PT packages

**Mirrors:** CM-02. `seed/membership-products.ts` (Couple Monthly / Couple Annual).

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-01 |
| **Files** | `apps/api/src/platform/db/seed/pt-products.ts` |

- Mark `PT-1M` and `PT-3M` as `single`.
- Add "Couple PT 1 Month" (`CPT-1M`) and "Couple PT 3 Month" (`CPT-3M`) as `couple`.

**Done when:** `pnpm api:seed` runs on a fresh DB and creates both couple packages.

---

## Phase 2: Backend product

### CP-03: `package_type` on PT products

**Mirrors:** CM-03. `memb/membership-product.dto.ts` and `membership-product.service.ts` (required on create, rejected on PATCH, list filter).

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-01 |
| **Files** | `pt.dto.ts`, `pt-product.service.ts`, `pt-product.repository.ts`, `pt-product.controller.ts` (Swagger classes), new `pt-product.service.spec.ts` |

- The Zod enum `package_type: 'single' | 'couple'` is required on create.
- It is rejected on PATCH (BadRequestError: "package_type cannot be changed").
- It is returned in every product response.
- The list accepts an optional `package_type` filter.

**Done when:** specs cover create with each type, the PATCH rejection and the list filter, and they pass.

---

## Phase 3: Backend subscription core

### CP-04: Repository support

**Mirrors:** CM-04. `memb/membership.repository.ts`: `setPartner` (~:328), `findPartner` (~:337) and the partner alias joins (~:45). There is no paired-freeze equivalent here.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-03 |
| **Files** | `pt-subscription.repository.ts` |

Add these methods:
- `setPartner(id, partnerId)`
- `findPartner(sub)`, which loads the row by `partner_subscription_id`
- `occurrenceOwnerId(sub)`, which returns the primary row id for any row
- `lockMembers(ids)`, which locks in ascending id order (replaces calling `lockMember` twice)

Change these queries:
- `insertSubscription` accepts the new link columns.
- `memberNamesForSubscriptions` returns "A & B" when the subscription is linked.
- `findOpenOverlappingForMember` is unchanged (it is per member, which is what we want).

**Done when:** the repository compiles and the existing specs pass. The new methods are exercised by the specs in CP-05 to CP-09.

### CP-05: Schedule service for more than one member

**Mirrors:** No membership counterpart. This is PT-specific (trainer-hour conflicts and the grid).

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-04 |
| **Files** | `pt-schedule.service.ts`, `pt.dto.ts` (grid query), `pt-schedule.spec.ts`, `pt-subscription.controller.ts` (only if the query handling changes) |

- `findConflicts` takes `memberIds: number[]`; any member busy is a `member_busy` conflict. `excludeSubscriptionId` is resolved to the owner row.
- `buildGrid`: new optional `partner_member_id`. With `exclude_subscription_id`, the partner comes from the subscription itself. A cell is occupied when either member is busy.
- Existing callers pass a one-element list, so single behaviour is unchanged.

**Done when:** specs cover a partner busy on one date (cell occupied, conflict reported), a re-plan excluding its own shared sessions, and the single-member path unchanged.

### CP-06: Read model, partner fields

**Mirrors:** CM-05. `MembershipService` read model (~:136), which hides the partner id for member-scoped reads and keeps only the name; plus the repository partner joins.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-04 |
| **Files** | `pt-subscription.service.ts` (`present()`, `summaryForMember`), `pt-subscription.controller.ts` (Swagger response classes), `pt-subscription.service.spec.ts` |

Responses add:
- `is_primary`
- `partner_subscription_id`
- `partner_member_id`
- `partner_member_name`
- `package_type`

A member-scoped read shows only the partner's name, never other partner data.

**Done when:** a spec asserts the partner fields appear for a linked row and are `null` for a single row.

### CP-07: Purchase a couple PT

**Mirrors:** CM-07. `MembershipService.create` (~:323): validation order (~:335–370), insert A, insert B, `setPartner` in one transaction (~:397–446), events after commit (~:485). Differences: no replacement or preview, the invoice link is `ptSubscriptionId`, and both members share one session.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-05, CP-06 |
| **Risk** | High. This is the core rule set. |
| **Files** | `pt.dto.ts`, `pt-subscription.service.ts`, `pt-subscription.service.spec.ts`, `apps/api/src/pay/payment.service.spec.ts` (only if the invoice link needs a new case) |

DTO: add `partner_member_id?` to `ptPurchaseSchema`.

Service `purchase()` (:113) and `createPaidSubscription` (:272):

Validation:
- Couple product without a partner → BadRequestError.
- Partner equal to `member_id` → BadRequestError.
- Single product with a partner → BadRequestError.
- Partner not found → NotFoundError.
- Either member without an active, unexpired gym membership → BusinessRuleError naming the member.
- Either member with an open PT overlapping the period → ConflictError naming the member.
- Slot conflicts use both member ids.

Steps, in one transaction:
1. Lock both members (ascending id), then the trainer.
2. Re-check overlap and conflicts under the locks.
3. Insert A (primary), insert B (`is_primary = false`, `partner_subscription_id = A`), `setPartner(A, B)`.
4. `paymentService.create(..., { ptSubscriptionId: A })`.
5. `generateOccurrences` once with both members: capacity 2, two participants, `pt_subscription_id = A`, title `PT · A & B`.
6. Set `assigned_trainer_id` for both members.
7. Audit for both rows.

**Done when:** every validation branch has a spec, and the happy path asserts:
- two cross-linked rows with the same dates, trainer, weekdays and slot
- one payment on A that carries the discount
- one schedule row per date with capacity 2 and two participants
- the single-package path is unchanged
- two concurrent sales for the same pair in opposite roles do not deadlock.

Also check, and note any gap as a follow-up: no schedule booking path lets a third member join a couple session, and a member cancelling their own booking from the schedule API is handled.

---

## Phase 4: Backend linked lifecycle

### CP-08: Linked renew

**Mirrors:** CM-08. `MembershipService.renew` (~:508) with `loadPartner` (~:213) and `renewRow`, plus the package-type match rule.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-07 |
| **Files** | `pt-subscription.service.ts`, `pt-subscription.service.spec.ts` |

- `renew` (:154), started from either row, creates two new linked rows continuing the day after the current end date, billed to the primary, each with its own `renewed_from_id`.
- The target product's `package_type` must equal the current product's; otherwise BusinessRuleError.
- Both memberships must still be active; the error names the member who fails.
- If the shared slot is no longer free for either member or the trainer, the call fails with the clashing dates (existing behaviour).

**Done when:** specs show both new rows get the same dates, one invoice on the new primary, a renew from the partner's side behaves the same, a type mismatch is rejected in both directions, and the single path is unchanged.

### CP-09: Linked reassign trainer and change slot

**Mirrors:** CM-08 and CM-09 pattern. `upgrade` (~:580) and `cancel` (~:646) load the partner with `loadPartner`, apply the same change inside the same transaction, then emit per row.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-07 |
| **Files** | `pt-subscription.service.ts`, `pt-subscription.service.spec.ts` |

- `reassignTrainer` (:195), `changeSlot` (:221) and `replan` (:364) resolve the pair from either row.
- Future sessions are cancelled and regenerated once, on the shared session, with both members as participants.
- Both rows get the `row_version` bump, the `pt_subscription_changes` row and the audit entry.
- `assigned_trainer_id` is updated for both members when the change takes effect.

**Done when:** specs show both rows change from either side, a future-dated handover is applied to both by `applyDueTrainerChanges`, and a partner-only clash blocks the change.

### CP-10: Status job and trainer access

**Mirrors:** CM-10 intent (both rows move together), but PT only needs verification specs.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-08, CP-09 |
| **Files** | `pt-subscription.service.spec.ts`, `pt-access.service.spec.ts`, `pt-subscription.service.ts` (only if a gap is found) |

Mostly verification: the existing per-row logic should already work.
- `runStatusTransitions` moves both rows `scheduled → active → completed` together.
- `PtAccessService.trainerAccess` returns `full` for both members while the pair is active, and `read_only` for both after it ends.

**Done when:** specs cover all three, and any gap found is fixed in the service.

---

## Phase 5: Contract and docs

### CP-11: OpenAPI contract

**Mirrors:** CM-12. Membership additions in `docs/openapi/v1.yaml` (`MembershipProduct`, `Membership`, `MembershipCreate`).

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | Shapes from CP-03, CP-05, CP-06, CP-07 (can be written contract-first) |
| **Files** | `docs/openapi/v1.yaml` |

Update these schemas:
- `PtProduct` and `PtProductWrite`: `package_type` enum.
- `PtSubscription`: partner fields and `is_primary`.
- `PtPurchase`: `partner_member_id`.
- The `/pt/schedule-grid` query: `partner_member_id`.

**Done when:** `pnpm --filter api openapi:check` passes against the running API.

### CP-12: Documentation

**Mirrors:** CM-13. `docs/adr/0010-couple-memberships.md` is the template for ADR-0011; also the FR-MEMB-005/006 edits in `docs/backend-frd.md`.

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CP-07 |
| **Files** | `docs/backend-frd.md`, `docs/database-entities.md`, `docs/adr/0011-couple-pt-subscriptions.md`, `docs/adr/0009-personal-training-subscriptions.md`, `docs/adr/README.md`, `docs/screens/admin-app-screens.md` |

- **FRD:** update the PT rules (FR-MEMB-009, FR-SCHED-005, FR-SCHED-016) for the couple rules and the shared session.
- **Entities doc:** add the new columns to the PT section.
- **ADR-0011:** two linked rows and one shared session. Cover why, the trade-offs (lifecycle fan-out, sessions owned by the primary row) and what to revisit (groups of more than two, replacing an existing PT).
- **ADR-0009 §3:** a one-line note that session capacity is 1, or 2 for a couple PT.

**Done when:** the docs match the shipped behaviour and the ADR is indexed in the README.

---

## Phase 6: Flutter data and domain

### CP-13: Regenerate the API client

**Mirrors:** CM-14. Same `tool/gen_api.sh` run.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-11 |
| **Files** | generated `packages/api_client/**` (excluded from the 7-file rule) |

Run `bash tool/gen_api.sh`.

**Done when:** `PtProduct.packageType`, the `PtSubscription` partner fields, `PtPurchase.partnerMemberId` and the grid `partnerMemberId` parameter all exist.

### CP-14: Product package type

**Mirrors:** CM-15. `membership_product.dart` and `membership_product_model.dart` (`MembershipPackageType`). PT uses its own `PtPackageType` to avoid a dependency on the membership feature.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-13 |
| **Files** | `domain/entities/pt_product.dart`, `data/models/pt_mappers.dart`, and test fixtures that construct `PtProduct` |

- Add `enum PtPackageType { single, couple }`.
- Add the `packageType` field, including `props` and `copyWith`.
- Map it in both directions.

**Done when:** `flutter analyze` is clean and the existing PT tests pass.

### CP-15: Partner fields on `PtSubscription`

**Mirrors:** CM-16. `membership.dart` and `membership_model.dart` (partner fields, `isCouple`).

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-13 |
| **Files** | `domain/entities/pt_subscription.dart`, `data/models/pt_mappers.dart`, affected fixtures |

- Add `isPrimary`, `partnerSubscriptionId?`, `partnerMemberId?`, `partnerMemberName?` and the getter `bool get isCouple`.

**Done when:** the mapping compiles and is covered by the tests in CP-20.

### CP-16: Purchase and grid params

**Mirrors:** CM-17. `createMembership` params (`partnerMemberId`) through repository, datasource and use case.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-13 |
| **Files** | `domain/repositories/pt_repository.dart`, `data/repositories/pt_repository_impl.dart`, `data/datasources/pt_remote_datasource.dart`, `domain/usecases/pt_usecases.dart`, `test/features/pt/data/pt_repository_impl_test.dart` |

- `PurchasePtParams` gains `partnerMemberId`.
- `GetPtScheduleGridParams` gains `partnerMemberId`.
- Both are passed through the repository and datasource.

**Done when:** it compiles, `bash tool/check_layers.sh` passes, and the repository test asserts the partner id reaches the API call.

---

## Phase 7: Flutter UI

### CP-17: PT package form toggle and list chip

**Mirrors:** CM-18. `membership_product_form_screen.dart` (Single/Couple `SegmentedButton`) and `membership_packages_catalog_screen.dart` (chip).

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-14 |
| **Files** | `presentation/screens/pt_packages_screen.dart`, `presentation/cubit/pt_packages_cubit.dart`, `presentation/pt_strings.dart`, `app/test/features/pt/presentation/pt_packages_screen_test.dart` |

- Add a Single/Couple `SegmentedButton` to the package form (`_PtPackageForm`).
- It is required on create, disabled on edit, and included in the dirty check.
- Couple rows in the list get a "Couple" chip.

**Done when:** widget tests cover the toggle on create, the disabled toggle on edit, and the chip being rendered.

### CP-18: `SellPtCubit` couple logic

**Mirrors:** CM-20. `create_membership_bloc.dart` (partner state, partner-selected event, validation in `_onSubmitted`) and its bloc test.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-15, CP-16 |
| **Files** | `presentation/cubit/sell_pt_cubit.dart` (plus its generated file), `app/test/features/pt/presentation/sell_pt_cubit_test.dart` |

- **State:** `partner`, `partnerCheck`, plus a getter `isCoupleSelected`.
- **Method:** `selectPartner(Person?)` sets the partner and runs the check using the existing PT summary and membership use cases (the partner has an open PT, or no active membership, blocks).
- Selecting a product of a different type clears the partner and the grid.
- The grid params include `partnerMemberId` when a partner is set.
- **`canSubmit`:** a couple package needs a partner whose check passed.
- **Submit** sends `partnerMemberId`; the idempotency key changes when the partner changes.

**Done when:** a test exists for every method and every `canSubmit` branch.

### CP-19: Sell PT screen UI

**Mirrors:** CM-21. `create_membership_screen.dart` (`MemberPickerField` after the package dropdown, `excludeMemberIds`) and its screen test.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-18 |
| **Files** | `presentation/screens/sell_pt_screen.dart`, `presentation/pt_strings.dart`, `app/test/features/pt/presentation/sell_pt_screen_test.dart` (new) |

- For a couple package, show a required "Partner (second member)" `MemberPickerField` after the package dropdown. It excludes the primary member.
- Show the partner check result inline: blocked messages in the error style, a loading line while checking.
- The summary card shows the price as the total for both members.
- In re-plan mode, show "This change applies to both members." when the subscription is a couple one.

**Done when:** widget tests cover:
- the picker hidden for a single package and shown for a couple package
- a blocked partner disabling submit
- the summary total
- the re-plan note.

### CP-20: Dossier "Couple with" and renew filter

**Mirrors:** CM-22 and CM-23. Both are still pending in the membership register and edit the same `member_dossier_screen.dart`, so build them together or in sequence to avoid conflicts.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-15 |
| **Files** | `app/lib/features/people/presentation/screens/member_dossier_screen.dart`, `app/lib/features/people/presentation/member_dossier_pt.dart`, `presentation/pt_strings.dart`, `app/test/features/people/presentation/member_dossier_screen_test.dart` |

- The PT card shows "Couple with <name>", which pushes the partner's dossier route. On the partner's side (`isPrimary == false`) it also shows "Billed to <primary>".
- `_RenewPtDialog` lists only products of the same `packageType` and shows a note that renewal covers both members.

**Done when:** widget tests show the line for a couple PT and hide it for a single one, and the renew dialog's product list is filtered.

---

## Phase 8: Verification

### CP-21: API e2e for couple PT

**Mirrors:** CM-25. Still pending in the membership register; share fixtures and helpers.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CP-07 to CP-10 |
| **Files** | new `apps/api/test/pt-couple.e2e.spec.ts`, and `apps/api/test/helpers/*` if fixtures are needed |

Against real MySQL, cover:
- sell a couple PT with a discount
- one invoice on the primary
- one shared session per date with two participants
- the partner busy elsewhere blocks the slot
- renew
- change slot
- reassign trainer
- the status job moves both rows
- both members get trainer write access while active.

**Done when:** `pnpm api:test:e2e` passes.

### CP-22: Full pass and manual walkthrough

**Mirrors:** CM-26. Run the PT and membership walkthroughs in the same pass.

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | all |
| **Files** | 0 |

Automated checks:
- API: `pnpm api:typecheck`, `api:lint`, `api:test`, `--filter api db:check`, `--filter api openapi:check`.
- App: `flutter analyze`, `bash tool/check_layers.sh`, `flutter test`.

Manual walkthrough on Edge:
1. Seed the data.
2. Open member A's dossier, choose "Add Personal Training" and pick "Couple PT 1 Month". Confirm the partner is required.
3. Pick B, who has an active gym membership. Choose weekdays, a trainer and an hour, pay and submit.
4. Confirm A and B both show "Couple with …" with matching dates, trainer and slot, and there is one invoice on A that includes the discount.
5. Confirm the trainer's calendar shows one session per day with two participants.
6. Renew and change the slot from B's side and confirm both rows change.
7. As the trainer, confirm both members have write access to goals and plans.

**Done when:** everything is green and the walkthrough has been observed working.
