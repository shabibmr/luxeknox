# Tasks Register: Couple Membership Packages

Derived from [PLAN.md](./PLAN.md).

**Rule:** each task touches at most 7 files, not counting generated code.
**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`

26 tasks across 8 phases. The app is in development, so the schema is edited in place and the local DB is reset.

---

## Checklist

**Phase 1: Schema and seed**
- [x] CM-01 Edit `0006_memberships.sql` and the Drizzle schema in place, then reset the local DB <!-- id: 1 -->
- [x] CM-02 Seed the couple packages and a sample couple pair <!-- id: 2 -->

**Phase 2: Backend product**
- [x] CM-03 `package_type` on membership products <!-- id: 3 -->

**Phase 3: Backend membership core**
- [x] CM-04 Repository support for partner links and paired freezes <!-- id: 4 -->
- [x] CM-05 Read model: partner fields in `present()` and the responses <!-- id: 5 -->
- [x] CM-06 `GET /memberships/replacement-preview` <!-- id: 6 -->
- [x] CM-07 Create a couple membership (two linked rows, replacement, discount) <!-- id: 7 -->

**Phase 4: Backend linked lifecycle**
- [x] CM-08 Linked renew and upgrade, plus the package-type match rule <!-- id: 8 -->
- [x] CM-09 Linked cancel and extend <!-- id: 9 -->
- [x] CM-10 Paired freezes: request, approve, reject <!-- id: 10 -->
- [x] CM-11 `/payments` path: renew both, reject a new couple purchase <!-- id: 11 -->

**Phase 5: Contract and docs**
- [x] CM-12 OpenAPI `v1.yaml` and the parity check <!-- id: 12 -->
- [x] CM-13 FRD, entities doc, ADR-0010, screens doc <!-- id: 13 -->

**Phase 6: Flutter data and domain**
- [x] CM-14 Regenerate `packages/api_client` <!-- id: 14 -->
- [x] CM-15 `MembershipPackageType` on the product entity and model <!-- id: 15 -->
- [x] CM-16 Partner fields on the membership entity and model <!-- id: 16 -->
- [x] CM-17 Create params and `GetReplacementPreviewUseCase` <!-- id: 17 -->

**Phase 7: Flutter UI**
- [x] CM-18 Product form Single/Couple toggle and catalog chip <!-- id: 18 -->
- [x] CM-19 Member picker `excludeMemberIds` <!-- id: 19 -->
- [x] CM-20 `CreateMembershipBloc` couple state, events and validation <!-- id: 20 -->
- [x] CM-21 Create screen: partner picker, replace dialog, discount summary <!-- id: 21 -->
- [x] CM-22 Dossier "Couple with <partner>" <!-- id: 22 -->
- [x] CM-23 Membership detail, upgrade and renew: partner row and type filter <!-- id: 23 -->
- [x] CM-24 Member card, directory badge, trainer summary <!-- id: 24 -->

**Phase 8: Verification**
- [ ] CM-25 API e2e: couple sale and lifecycle <!-- id: 25 -->
- [ ] CM-26 Full automated pass and manual walkthrough on Edge <!-- id: 26 -->

---

## Dependency graph

```
CM-01 ─ CM-02
  │
  ├─ CM-03 ─ CM-04 ─ CM-05 ─ CM-06 ─ CM-07 ─┬─ CM-08 ─┬─ CM-09
  │                                         │         ├─ CM-10
  │                                         │         └─ CM-11
  │                                         └─ CM-13
  │
  └─ CM-12 (needs CM-03, CM-05, CM-06, CM-07 shapes) ─ CM-14 ─┬─ CM-15 ─ CM-18
                                                              ├─ CM-16 ─┬─ CM-22
                                                              │         ├─ CM-23
                                                              │         └─ CM-24
                                                              └─ CM-17 ─ CM-20 ─┐
                                                       CM-19 ──────────────────┴─ CM-21

CM-07..CM-11 ─ CM-25 ─┐
CM-18..CM-24 ─────────┴─ CM-26
```

You can write CM-12 contract-first, as soon as the shapes in this plan are agreed. After that, the backend (phases 2–4) and Flutter (phases 6–7) can proceed in parallel.

---

## Phase 1: Schema and seed

### CM-01: Edit the schema in place and reset the local DB

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Risk** | Medium. Rewrites an applied migration, so every dev DB must be reset. |
| **Files** | `apps/api/drizzle/0006_memberships.sql`, `apps/api/src/platform/db/schema/memberships.ts`, `apps/api/drizzle/meta/*` (only if `db:check` needs it) |

Changes:
- `membership_products.package_type VARCHAR(16) NOT NULL`, with `CHECK (package_type IN ('single','couple'))`.
- `memberships.partner_membership_id INT NULL`, a self-FK to `memberships(id)` with an index.
- `membership_freezes.paired_freeze_id INT NULL`, a self-FK to `membership_freezes(id)`.

Reset the local MySQL schema on localhost:3308 (drop and recreate the database), then run `pnpm api:migrate`.

**Done when:**
- The migration runs cleanly on an empty DB.
- `pnpm --filter api db:check` reports no drift.
- Type errors appear only where `package_type` is now required. CM-02 and CM-03 fix those.

### CM-02: Seed the couple packages

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-01 |
| **Files** | `apps/api/src/platform/db/seed/membership-products.ts`, plus the member/membership seed file if a sample couple is seeded |

- Mark Monthly, Quarterly and Annual as `single`.
- Add "Couple Monthly" (`CPL-M`) and "Couple Annual" (`CPL-A`) as `couple`.
- Optionally seed one linked couple pair for manual QA.

**Done when:** `pnpm api:seed` runs on a fresh DB and creates both couple packages.

---

## Phase 2: Backend product

### CM-03: `package_type` on membership products

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-01 |
| **Files** | `apps/api/src/memb/membership-product.dto.ts`, `membership-product.service.ts`, `membership-product.repository.ts`, `membership-product.controller.ts` (Swagger classes), `membership-product.service.spec.ts` |

- The Zod enum `package_type: 'single' | 'couple'` is required on create.
- It is rejected on PATCH (BadRequestError: "package_type cannot be changed").
- It is returned in every product response.
- List queries accept an optional `package_type` filter.

**Done when:** specs cover create with each type, the PATCH rejection and the list filter, and they pass.

---

## Phase 3: Backend membership core

### CM-04: Repository support for partner links and paired freezes

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-03 |
| **Files** | `apps/api/src/memb/membership.repository.ts` |

Add these methods:
- `setPartner(id, partnerId)`
- `findPartner(membership)`, which loads the row by `partner_membership_id`
- `setPairedFreeze(freezeId, pairedId)`
- `findFreezeById` (if it is missing)

Change these queries:
- `insertMembership` and `insertFreeze` accept the new link columns.
- `findByIdWithProduct` and the list queries join the partner membership and the partner member, returning `partner_member_id` and `partner_member_name`.
- Product joins expose `package_type`.

**Done when:** the repository compiles, the existing specs pass, and the new methods are exercised by the specs in CM-07 to CM-10.

### CM-05: Read model, partner fields

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-04 |
| **Files** | `memb/membership.service.ts` (`present()`), `memb/membership.controller.ts` (Swagger response classes), `memb/membership.service.spec.ts` |

Responses add:
- `partner_membership_id`
- `partner_member_id`
- `partner_member_name`
- `product.package_type`

A member-scoped read shows only the partner's name, never other partner data.

**Done when:** a spec asserts the partner fields appear for a linked row and are `null` for a single row.

### CM-06: Replacement preview endpoint

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-05 |
| **Files** | `memb/membership.dto.ts`, `memb/membership.service.ts`, `memb/membership.controller.ts`, `memb/membership.service.spec.ts` |

- Route: `GET /memberships/replacement-preview?member_id=`, guarded by `memberships.create`. Declare it before `/:id` so the routes do not collide.
- Service: `getReplacementPreview(memberId)` returns `{ membership_id, product_name, status, end_date, remaining_days, is_couple, suggested_credit }`.
  - `remaining_days = max(0, end_date − max(today, start_date))`
  - `suggested_credit = round2(base_price × remaining_days / duration_days)`, capped at `base_price`.
- Returns 404 (NotFoundError) when the member has no active or frozen membership.

**Done when:** the specs cover an active membership mid-term, a frozen one, one not yet started (full credit), one ending today, a couple membership (`is_couple: true`) and no membership (404).

### CM-07: Create a couple membership

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-06 |
| **Risk** | High. This is the core rule set. |
| **Files** | `memb/membership.dto.ts`, `memb/membership.service.ts`, `memb/membership.service.spec.ts` |

DTO: add `partner_member_id?`, `replace_partner_membership?` (boolean) and `discount_amount?` (money string).

Service `create()` (:147):

Validation:
- Couple product without a partner → BadRequestError.
- Partner equal to `member_id` → BadRequestError.
- Single product with a partner → BadRequestError.
- Partner not found → NotFoundError.
- The primary member's own active or frozen membership still blocks the sale, as today.
- Partner has an active or frozen membership:
  - Without the flag → BusinessRuleError ("Partner has an active membership; confirm replacement").
  - If that membership is a couple membership → BusinessRuleError.
- `0 ≤ discount ≤ base_price` → otherwise BadRequestError.

Steps:
1. Extract a private `cancelRow(before, reason, actor, now)` from `cancel()` (:365).
2. In one transaction:
   1. Cancel the partner's old row with reason `replaced_by_couple`.
   2. Insert A (primary).
   3. Insert B (partner, `partner_membership_id = A`).
   4. `setPartner(A, B)`.
   5. Write history and audit for both rows.
   6. Call `paymentService.create({ member_id: primary, membership_id: A, payment_method_id, subtotal: base_price, discount_amount })`.
3. After commit, emit `membership.created` for A and B. If a row was replaced, also emit `membership.cancelled` for it.
4. Lockers apply only to the primary member.

**Done when:** every validation branch has a spec, and the happy path asserts:
- two cross-linked rows with the same dates
- one payment on A that carries the discount
- the replaced row is cancelled with a `replaced_by_couple` audit entry
- the single-package path is unchanged.

---

## Phase 4: Backend linked lifecycle

### CM-08: Linked renew and upgrade

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-07 |
| **Files** | `memb/membership.service.ts`, `memb/membership.service.spec.ts` |

- Add a private helper `applyToPartner(membership, fn)`. It loads the partner, re-reads its `row_version`, and runs the same update, history and audit inside the current transaction.
- `renew` (:234) and `upgrade` (:305) apply to both rows.
- The target product's `package_type` must equal the current product's; otherwise BusinessRuleError.
- Emit an event for each row.

**Done when:** specs show both rows get the same `end_date` and `product_id`, a type mismatch is rejected in both directions, and the single path is unchanged.

### CM-09: Linked cancel and extend

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-08 |
| **Files** | `memb/membership.service.ts`, `memb/membership.service.spec.ts` |

- `cancel` (:365) cancels both rows.
- `extend` (~:641) creates an extension record on each row and moves both end dates.

**Done when:** specs show both rows change, each with its own history row.

### CM-10: Paired freezes

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-08 |
| **Files** | `memb/membership.service.ts`, `memb/membership.service.spec.ts`, `memb/freeze.controller.ts` (only if the response shape changes) |

- `requestFreeze` (:442) also creates a twin freeze on the partner row, with the same dates and status, cross-linked through `paired_freeze_id`.
- The `max_freeze_days` and overlap checks run against both rows. If either fails, the whole request is rejected.
- `approveFreeze` (:533) and `rejectFreeze` (:604) act on the paired freeze too. Both memberships become `frozen` and both end dates move by the same number of days.
- A member may request a freeze for their own couple membership; the twin is created automatically.

**Done when:** specs cover a staff direct approval, a member pending request followed by approval, rejection, and a quota breach caused by the partner's quota.

### CM-11: `/payments` path

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-08 |
| **Files** | `memb/membership.service.ts` (`createOrRenewForPayment` :710), `memb/membership.service.spec.ts`, `pay/payment.service.spec.ts` |

- Renewing an existing couple membership through a payment renews both rows.
- No existing membership plus a couple product → BusinessRuleError ("Couple packages must be sold via POST /memberships").

**Done when:** both branches have specs and the payment specs pass.

---

## Phase 5: Contract and docs

### CM-12: OpenAPI contract

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | Shapes from CM-03, CM-05, CM-06, CM-07 (can be written contract-first) |
| **Files** | `docs/openapi/v1.yaml` |

Update these schemas and paths:
- `MembershipProduct` and `MembershipProductWrite` (~7718): `package_type` enum.
- `Membership` (~8043): partner fields.
- `MembershipCreate`: `partner_member_id`, `replace_partner_membership`, `discount_amount`.
- New path `/memberships/replacement-preview` with a `MembershipReplacementPreview` schema, marked `x-parity: required`.

**Done when:** `pnpm --filter api openapi:check` passes against the running API.

### CM-13: Documentation

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-07 |
| **Files** | `docs/backend-frd.md`, `docs/database-entities.md`, `docs/adr/0010-couple-memberships.md`, `docs/adr/README.md`, `docs/screens/admin-app-screens.md` |

- **FRD:** update FR-MEMB-005/006 for the couple and replacement rules, and add FR-MEMB rules for linked lifecycle and the preview credit.
- **Entities doc:** add the new columns to §3.
- **ADR-0010:** two linked rows instead of a group table. Cover why, the trade-offs (lifecycle fan-out, couple counted as 2) and what to revisit if groups larger than two are ever needed.

**Done when:** the docs match the shipped behaviour and the ADR is indexed in the README.

---

## Phase 6: Flutter data and domain

### CM-14: Regenerate the API client

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-12 |
| **Files** | generated `packages/api_client/**` (excluded from the 7-file rule) |

Run `bash tool/gen_api.sh`.

**Done when:** `MembershipProduct.packageType`, the `Membership` partner fields, the new `MembershipCreate` fields and the preview API method all exist.

### CM-15: Product package type

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-14 |
| **Files** | `app/lib/features/membership/domain/entities/membership_product.dart`, `data/models/membership_product_model.dart`, and test fixtures that construct `MembershipProduct` |

- Add `enum MembershipPackageType { single, couple }`.
- Add the `packageType` field, including `props` and `copyWith`.
- Map it in `toDomain` and `toWriteModel`.

**Done when:** `flutter analyze` is clean and the existing membership tests pass.

### CM-16: Partner fields on `Membership`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-14 |
| **Files** | `domain/entities/membership.dart`, `data/models/membership_model.dart`, affected fixtures |

- Add `partnerMembershipId?`, `partnerMemberId?`, `partnerMemberName?` and the getter `bool get isCouple`.

**Done when:** the mapping is compiled and covered by the tests in CM-22 to CM-24.

### CM-17: Create params and the preview use case

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-14 |
| **Files** | `domain/repositories/membership_repository.dart`, `data/repositories/membership_repository_impl.dart`, `data/datasources/membership_remote_datasource.dart`, `domain/usecases/create_membership_usecase.dart`, new `domain/entities/membership_replacement_preview.dart`, new `domain/usecases/get_replacement_preview_usecase.dart` |

- `createMembership` and `CreateMembershipParams` gain `partnerMemberId`, `replacePartnerMembership` and `discountAmount`.
- The preview returns `MembershipReplacementPreview?`, with a 404 mapped to `null`.
- Run `dart run build_runner build` so `injector.config.dart` picks up the new use case.

**Done when:** it compiles, `bash tool/check_layers.sh` passes, and DI resolves the new use case.

---

## Phase 7: Flutter UI

### CM-18: Product form toggle and catalog chip

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-15 |
| **Files** | `presentation/screens/membership_product_form_screen.dart`, `presentation/screens/membership_packages_catalog_screen.dart`, `presentation/membership_strings.dart`, `test/.../membership_product_form_role_variants_test.dart`, `test/.../membership_packages_catalog_role_variants_test.dart` |

- Add a Single/Couple `SegmentedButton` before the Active switch (~l.274).
- It is required on create, disabled on edit, and included in the dirty check (l.195).
- Couple rows in the catalog get a "Couple" chip (~l.126).

**Done when:** widget tests cover the toggle on create, the disabled toggle on edit, and the chip being rendered.

### CM-19: Member picker exclusion

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | — |
| **Files** | `app/lib/features/people/presentation/widgets/member_picker_sheet.dart`, `app/test/features/people/presentation/member_picker_sheet_test.dart` |

- Add `excludeMemberIds` (a `Set<int>`) to `showMemberPickerSheet`, `MemberPickerField` and `MemberPickerSheet`.
- Excluded members are filtered out of the results.

**Done when:** a test shows an excluded member is not listed.

### CM-20: `CreateMembershipBloc` couple logic

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-17 |
| **Files** | `presentation/bloc/create_membership_bloc.dart` (plus its generated file if any), `test/features/membership/presentation/create_membership_bloc_test.dart` |

- **State:** `selectedPartner`, `partnerReplacement`, `replaceConfirmed`, `discountAmount`, plus a getter `isCoupleSelected`.
- **Events:**
  - `CreateMembershipPartnerSelected`: sets the partner and fetches the preview.
  - `CreateMembershipReplaceConfirmed(bool)`: when false, clears the partner.
  - `CreateMembershipDiscountChanged`.
- Selecting a product of a different type clears the partner, the preview and the discount.
- The suggested credit pre-fills `discountAmount`.
- **Validation in `_onSubmitted` (l.253):**
  - partner required for a couple package
  - partner differs from the member
  - replacement confirmed when a preview exists
  - the preview is not a couple membership
  - discount within 0..price
- **Submit** sends the new params.

**Done when:** a `blocTest` exists for every event and every validation branch.

### CM-21: Create screen UI

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-19, CM-20 |
| **Files** | `presentation/screens/create_membership_screen.dart`, `presentation/membership_strings.dart`, `test/features/membership/presentation/create_membership_screen_test.dart` |

- For a couple package, show a required "Partner (second member)" `MemberPickerField` after the package dropdown (l.146). It excludes the primary member.
- When a preview exists, show a replace dialog on partner selection.
  - It names the partner, the package, the end date and the days left.
  - Confirm keeps the partner; Cancel clears it.
  - When the existing membership is a couple membership, show an error message instead.
- A summary card shows the price, an editable "Discount for remaining days" field (`AppCurrencyField`) and the total.

**Done when:** widget tests cover:
- the picker hidden for a single package and shown for a couple package
- a submit error when no partner is picked
- the dialog's Confirm and Cancel paths
- the discount pre-filled from the preview.

### CM-22: Dossier "Couple with"

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-16 |
| **Files** | `app/lib/features/people/presentation/screens/member_dossier_screen.dart`, `app/test/features/people/presentation/member_dossier_screen_test.dart` |

- `_MembershipSection` (~l.534) shows "Couple with <name>", which pushes the partner's dossier route.

**Done when:** a widget test shows the line for a couple membership and hides it for a single one.

### CM-23: Detail, upgrade and renew screens

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-16 |
| **Files** | `presentation/screens/membership_detail_screen.dart`, `presentation/screens/membership_renew_screen.dart`, `presentation/membership_strings.dart`, `test/.../membership_detail_role_variants_test.dart` |

- **Detail (~l.350):** add a Partner row. On the partner's side, add "Billed to <primary>". Show a note that actions apply to both members.
- **Upgrade dialog (l.226) and renew product list (l.127):** show only products of the same `packageType`.

**Done when:** tests cover the partner row and the filtered product list.

### CM-24: Member card, directory and trainer summary

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | CM-16 |
| **Files** | `presentation/screens/membership_card_screen.dart`, `presentation/screens/memberships_directory_screen.dart`, `presentation/screens/trainer_membership_summary_screen.dart`, `test/.../membership_card_screen_test.dart` |

- **Member card:** a "Couple with <name>" row.
- **Directory:** a couple badge.
- **Trainer summary:** a partner name line.

**Done when:** the card test covers the couple row.

---

## Phase 8: Verification

### CM-25: API e2e for couple memberships

| | |
| :--- | :--- |
| **Status** | pending |
| **Depends** | CM-07 to CM-11 |
| **Files** | new `apps/api/test/memberships-couple.e2e.spec.ts`, and `apps/api/test/helpers/*` if fixtures are needed |

Against real MySQL, cover:
- create a couple membership with the replacement flag
- the preview credit
- renew
- freeze, then approve
- cancel
- the partner passes the check-in membership gate.

**Done when:** `pnpm api:test:e2e` passes.

### CM-26: Full pass and manual walkthrough

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
2. Open member A's dossier, choose "Sell / assign membership" and pick "Couple Monthly". Confirm the partner is required.
3. Pick B, who has an active single membership. Confirm the replace dialog appears with the pro-rated discount, then submit.
4. Confirm A and B both show "Couple with …" with matching dates, B's old membership is cancelled, and there is one invoice on A that includes the discount.
5. Renew and freeze from B's side and confirm both rows change.
6. Confirm B can check in at the gate.

**Done when:** everything is green and the walkthrough has been observed working.
