# Plan: Couple Membership Packages

Tasks register: [TASKS.md](./TASKS.md)

## Context
Every membership package (`membership_products`) today covers exactly one member. We need **Couple packages**: two members bought together. Selling one from a member dossier must require picking a second member (the partner).

The app is still in development, with no production data or clients. So:
- the schema is edited in place
- the local DB is reset
- nothing needs defaults, compatibility shims or migration guards for existing rows.

Decisions confirmed with the user:
- **Billing:** the package price is the total for both members. One invoice is raised against the primary (dossier) member.
- **Lifecycle:** the two memberships are fully linked. Renew, upgrade, extend, cancel and freeze always apply to both, so their dates stay identical.
- **Partner already has an active or frozen membership:** replace it. Show a pop-up warning first, and offer a discount for the remaining days, pre-filled with a pro-rated credit that staff can edit.

## Design: two linked membership rows
Each member gets their own `memberships` row, and the two rows point at each other through `partner_membership_id`.

The existing per-member logic then works for the partner with no changes, because it all goes through `findActiveOrFrozenForMember` or lists memberships by member:
- gate check-in (`attn/attendance.service.ts:509`)
- PT eligibility (`pt/pt-subscription.service.ts:581`)
- the dashboard
- the member card

Lifecycle operations update both rows in one transaction.

## Backend (`apps/api`)

### 1. Schema, edited in place
- Edit `drizzle/0006_memberships.sql` and `src/platform/db/schema/memberships.ts` directly; there is no new migration.
  - `membership_products.package_type VARCHAR(16) NOT NULL`, with a CHECK that it is `single` or `couple`.
  - `memberships.partner_membership_id INT NULL`, a self-FK with an index.
  - `membership_freezes.paired_freeze_id INT NULL`, a self-FK that links the twin freeze rows.
- Seed (`src/platform/db/seed/membership-products.ts`): mark the existing packages `single`, add "Couple Monthly" and "Couple Annual", and optionally seed one couple pair of members.
- Reset the local DB: drop and recreate the schema on localhost:3308, then run `pnpm api:migrate` and `pnpm api:seed`. Run `pnpm --filter api db:check`.

### 2. Product
Files: `memb/membership-product.dto.ts`, `membership-product.service.ts`, and the Swagger classes in `membership-product.controller.ts`.
- `package_type` is required on create.
- It cannot be changed on PATCH, because linked rows depend on it.

### 3. Create: `MembershipService.create` (`memb/membership.service.ts:147`)
New fields on `MembershipCreateDto` (`membership.dto.ts`): `partner_member_id?`, `replace_partner_membership?` (bool) and `discount_amount?` (money string).

Validation:
- A couple product requires a partner who exists and differs from `member_id`.
- A single product rejects `partner_member_id`.
- The primary member's own active/frozen membership still blocks the sale, as today.
- If the partner has an active/frozen membership:
  - Without `replace_partner_membership=true`, reject it (BusinessRuleError).
  - If that membership is itself a couple membership, block it, so the other person is not left half-linked.
- `0 ≤ discount_amount ≤ base_price`.

In one transaction:
1. Cancel the partner's old row through a private `cancelRow()` extracted from `cancel()` (:365). The history and audit reason is `replaced_by_couple`.
2. Insert row A (primary), insert row B (partner, with `partner_membership_id = A`), then set A's `partner_membership_id = B`. Both rows get the same dates.
3. Write history and audit for both rows.
4. Call `paymentService.create({member_id: primary, membership_id: A, subtotal: base_price, discount_amount})`. `PaymentCreateDto` already supports the discount.
5. Emit `membership.created` for both rows.

### 4. Replacement preview: `GET /memberships/replacement-preview?member_id=`
- Requires the `memberships.create` permission.
- Returns `{membership_id, product_name, status, end_date, remaining_days, is_couple, suggested_credit}`, or 404 if there is nothing to replace.
- `remaining_days = max(0, end_date − max(today, start_date))`.
- `suggested_credit = round2(product.base_price × remaining_days / duration_days)`.
- The backend is the single source of truth for this calculation; the UI never computes money itself.

### 5. Linked lifecycle (`membership.service.ts`)
Add a private helper that loads the partner row and applies the same update, history and audit to it inside the same transaction. It re-reads the partner's `row_version`; the client sends only the version of the row it is acting on.

| Operation | Location | Change |
|---|---|---|
| `renew` | :234 | Also renew the partner. The target product must have the same `package_type`. |
| `upgrade` | :305 | Same as renew. Changing between single and couple is rejected. |
| `cancel` | :365 | Also cancel the partner. |
| `extend` | ~:641 | Also extend the partner. |
| `requestFreeze` | :442 | Also create a twin freeze, cross-linked through `paired_freeze_id`. |
| `approveFreeze` / `rejectFreeze` | :533 / :604 | Also act on the paired freeze. |

`createOrRenewForPayment` (:710), the `/payments` path:
- Renewing a couple membership renews both rows.
- A new couple purchase through this path is rejected with "use POST /memberships".

### 6. Read model
`present()`, `findByIdWithProduct` and the list queries return `package_type`, `partner_membership_id`, `partner_member_id` and `partner_member_name`.

### 7. Contract and docs
- Update `docs/openapi/v1.yaml`:
  - `MembershipProduct`/`Write` (~7718)
  - `Membership`/`MembershipCreate` (~8043)
  - the preview path
- Keep `pnpm --filter api openapi:check` green.
- Update FR-MEMB-005/006 in `docs/backend-frd.md` and §3 of `docs/database-entities.md`.
- Add an ADR in `docs/adr/`: "Couple memberships as two linked rows".

## Flutter (`app/`)

### 1. Regenerate the client and update models
- Run `tool/gen_api.sh`, which regenerates `packages/api_client`.
- Domain `MembershipProduct` gets `packageType` (new `MembershipPackageType {single, couple}`). Map it in both `toDomain` and `toWriteModel` in `data/models/membership_product_model.dart`.
- Domain `Membership` gets `partnerMembershipId`, `partnerMemberId` and `partnerMemberName`; map them in `membership_model.dart`.
- `createMembership` gains `partnerMemberId`, `replacePartnerMembership` and `discountAmount` at every layer: repository (:41), `membership_repository_impl.dart:140`, and `CreateMembershipParams`.
- Add a new `GetReplacementPreviewUseCase`.

### 2. Package admin screens
- `membership_product_form_screen.dart`: a required Single/Couple `SegmentedButton` before the Active switch (~l.274). It is read-only on edit and counts toward the dirty check (l.195).
- `membership_packages_catalog_screen.dart` (l.126): a "Couple" chip on couple rows.

### 3. Sell flow (`create_membership_screen.dart` and `bloc/create_membership_bloc.dart`)
Bloc state gains `selectedPartner`, `partnerReplacement`, `replaceConfirmed` and `discountAmount`.

New events:
- `PartnerSelected`, which fetches the preview.
- `ReplaceConfirmed`.
- `DiscountChanged`.

Selecting a single package clears the partner.

Screen:
- For a couple package, show a required "Partner (second member)" `MemberPickerField` right after the package dropdown (l.146).
- If the preview returns a membership, show a dialog right away. Example text: *"Priya's current membership 'Monthly' (ends 03 Nov, 22 days left) will be cancelled and replaced by this couple membership."*
  - Confirm keeps the partner; Cancel clears the partner.
  - If the existing membership is a couple membership, show an error instead.
- After confirmation, show a summary: price, a "Discount for remaining days" field pre-filled with `suggested_credit` and editable within 0..price, and the total.

Validation in `_onSubmitted` (l.253):
- Partner required for a couple package.
- Partner differs from the member.
- Replacement confirmed.
- Discount in range.

Picker change: `widgets/member_picker_sheet.dart` gets `excludeMemberIds`, so the primary member cannot be picked as their own partner.

### 4. Display
- **Dossier:** `_MembershipSection` (`member_dossier_screen.dart:534`) shows "Couple with <name>", which links to the partner's dossier.
- **Admin detail:** `membership_detail_screen.dart` (~l.350) gets a partner row. On the partner's side it also shows "Billed to <primary>".
  - The upgrade dialog (l.226) lists only products of the same type.
- **Other screens:** `membership_card_screen.dart` (l.219), the `memberships_directory_screen.dart` badge (l.122), and the renew screen (l.127, filtered by type).
- **Strings:** new text goes in `membership_strings.dart`.

## Tests
**Backend (Vitest)**, in `membership.service.spec.ts`, `membership-product.service.spec.ts` and `payment.service.spec.ts`:
- A couple product without a partner is rejected.
- A member picked as their own partner is rejected.
- Two cross-linked rows are created, with one payment carrying the discount.
- Replacement with the flag works; without the flag it is rejected.
- Replacing a partner who is already in a couple is blocked.
- The preview maths: active, frozen and not-yet-started memberships.
- Every lifecycle operation hits both rows.
- A cross-type upgrade is rejected.

**Flutter (bloc_test + mocktail):**
- `create_membership_bloc_test.dart`: partner required, preview and confirmation, discount bounds, partner cleared when switching to a single package.
- Widget tests: the partner picker appears only for couple packages, the replace dialog, the product form toggle, and the dossier "Couple with" line.

## Verification
1. Reset the local DB, then run `pnpm api:migrate`, `pnpm api:seed`, `pnpm --filter api db:check`, `openapi:check` and `test`.
2. Run `bash tool/gen_api.sh`, then in `app/`: `flutter analyze`, `bash tool/check_layers.sh` and `flutter test`.
3. Manual check in the app, run on Edge:
   1. Open member A's dossier, choose "Sell / assign membership" and pick "Couple Monthly". Confirm the partner field is mandatory.
   2. Pick member B, who has an active single membership. Confirm the replace pop-up appears with the pro-rated discount, then submit.
   3. Confirm A and B both show "Couple with …" with the same dates, B's old membership is cancelled, and there is one invoice on A with the discount.
   4. Freeze or renew from either side and confirm both rows change.
   5. Confirm member B can check in at the gate.

## Out of scope
- Converting a single membership to a couple membership through upgrade.
- Families or groups of more than two members.
- Split invoices.
- The dashboard's active-membership count will count a couple as 2. That matches the member count, and revenue is unaffected.

