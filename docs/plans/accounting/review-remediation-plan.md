# Accounting backend: review remediation plan

Source: `/code-review` of `apps/api/src/acct/**`, `platform/db/schema/accounting.ts`, `platform/money/**`, `drizzle/0025_accounting.sql` against `main`, including uncommitted changes.
Spec: ADR-0013, `implementation-plan.md`, `tasks-register.md`. Standards: ADR-0001..0004, `backend-code-quality-review.md`.

Verified by hand before planning: R1, R2, R3, R4, R5, S2 (code read, nothing executed). Everything else is from the subagent reports and must be re-confirmed in the first step of its phase.

The app is in dev (no compat shims): edit migration `0025` in place and reset the DB.

## Phase 0: Unblock (correctness bugs that break features)

| ID | Item | Files | Change | Done when |
|----|------|-------|--------|-----------|
| R1 `[x]` | Item insert fails (`uom_id NOT NULL`, `created_at NOT NULL`). **Resolved in HEAD by inventory-lite IL-01/03/12 (Phase 4 option (a)).** Seed adds `PCS` and other UoMs, `ItemsService.create` validates a required `uom_id` and sets `created_at`, `row_version` has a DB default. `uom_id` stays required because `docs/plans/inventory/contract.md:210` says so. Covered by `test/inventory.e2e.spec.ts` IL-12. | `items.service.ts:~123`, `items.dto.ts`, `seed/accounting.ts` | Seed a default UoM (e.g. `NOS`). Accept optional `uom_id` in the DTO and default it to the seeded UoM. Set timestamps and `row_version`. Decide scope creep (see Phase 4) first: if inventory columns are deferred, remove them from schema and migration instead. | Spec: create item via API succeeds on a fresh DB |
| R2 | GST summary lifetime totals | `reports.repository.ts:~532-561` | Switch to `journalLines` inner-join `journalEntries`, with the date filter in `WHERE`, grouped by account. Keep the tax accounts via a left join from `accounts` only if a zero row is wanted. | Output tax per component equals that account's movement for the range |
| R2b | Taxable value counted per tax code | `reports.repository.ts:~647-656` | Compute taxable value per tax code from source documents (invoice and payment tax lines, bills, expenses, credit and debit notes). Do not assign the global total to every code. | Sum of per-code taxable = total taxable; spec with 2 codes |
| R3 `[x]` | Debit note trusts client tax. **Done:** DTO takes net `amount` + `tax_code_id` (strict schema rejects `tax_amount`); tax computed server-side; open balance subtracts posted debit notes and payment allocations | `debit-notes.service.ts:73,93`, DTO | Remove `tax_amount` and `subtotal` from the DTO. Take lines or a base amount plus a tax code, and compute tax server-side (ADR decision 9). Open balance = bill total minus posted debit notes minus payment allocations (same definition as the AP report). | A client-sent tax amount is ignored or rejected; the balance check matches the AP report |
| R4 `[x]` | Balance sheet breaks from year two. **Done:** `getBalanceSheet` adds `retainedEarnings` (P&L before fiscal year start) to equity; response gains `retained_earnings`. Spec `reports.balance-sheet.spec.ts` | `reports.repository.ts:~283` | Compute retained earnings as P&L from the earliest entry up to the day before `fiscalYearStart`, shown as its own line, plus current-year earnings. Optionally add a year-end close later. | Spec: two fiscal years of data, assets = liabilities + equity |

## Phase 1: Money correctness (Standards hard violations 2 and 3)

1. Add to `platform/money/money.ts`: `prorate(amount, numerator, denominator)` (BigInt, half-up) and `allocate(amount, weights[])` (largest-remainder, sum-preserving). Fold `mulQtyRate`'s `toScaled` into one shared parser.
2. Replace float proration in `go-live.service.ts:157,243` and `revenue-recognition.service.ts:178-179` with `prorate`. Replace `parseFloat().toFixed(2)` on rates at `go-live.service.ts:427,478` with the string helpers.
3. Bill lines (`purchase-bills.service.ts:176-177`): use `mulQtyRate`. Accept 3dp quantity; stop `roundMoney(quantity)`.
4. Move raw BigInt math in `tax-lines.ts`, `debit-notes.service.ts:205-222`, `fund-transfers.service.ts:207` and `payment-vouchers.service.ts:286-436` onto the helpers.
5. Unit specs in `money.spec.ts`: odd cents, 1/3 splits, a total that must not drift, a 3dp quantity.

## Phase 2: Idempotency and tax consistency

| ID | Item | Change |
|----|------|--------|
| R6 | Replay creates a second schedule | In `sales-bridge.service.ts`, make `insertSchedule` upsert-or-skip keyed on `payment_id`. Run it only when `postJournal` reports a fresh post. For refunds and credit notes, derive the idempotency key from the source event (payment or refund id), not a fresh `creditNote.id`. Specs: post twice, refund retry. |
| R8 | Two tax-split algorithms | One implementation in `tax-lines.ts` used by invoice, refund and adjustment paths. Decide rounding rule (ADR: per line, half-up) and use `allocate` so components sum to `payments.tax_amount` exactly. Delete the `buildTaxComponentLines` wrapper (Middle Man). |
| R10c | `validateOpeningJournalMatch` ignores date | Filter by go-live date. |
| R10a | Refund rejected above unrecognized balance | Re-read ADR; limit that rule to adjustments, or document it as intended. |
| R10b | Go-live preview treats frozen as unpaused | Mirror the live pause logic. |

## Phase 3: Reports and period lock

| ID | Item | Change |
|----|------|--------|
| R7 | Period-lock recognition check | Replace the in-process `Set` and loose `jobRuns` test. Persist per-period status (`recognition_runs`: period, status, completed_at), or check that every active schedule has its lines for that period. Fix the fallthrough `return false` vs doc comment. |
| R9 | Open AP omits credit expense vouchers | Add them to the AP report. Add a reconciliation spec: open AP = account `2000` balance. Update ACC-074 text. |
| M1 | Credit-notes controller and DTO missing | Add `GET/POST /credit-notes` and `POST /credit-notes/:id/post` with permissions and idempotency decorators, as in the plan. |
| M2 | Unlock permission | Add a distinct `accounting.periods_unlock` slug, or amend the plan if sharing `periods_close` is intended. |

## Phase 4: Scope-creep decision (needs the owner, before Phase 0 R1)

Uncommitted inventory groundwork: tables `uoms`, `item_categories`, `debit_note_lines` (unused); item columns `sku`, `hsn_sac`, `sale_rate`, `purchase_rate`, `reorder_level`, `inventory_account_id`, `cogs_account_id`; control role `inventory`; source types `counter_sale`, `counter_sale_return`, `stock_adjustment`.
Options: (a) keep it and update the plan, ADR-0013 and the `inventory-lite` task register to own it; (b) strip it from `0025` and the schema, and park it on an inventory branch. Recommend (b) for anything unused (`debit_note_lines`) and (a) only if `docs/plans/inventory-lite` is the next milestone.

## Phase 5: Standards refactors (after correctness; each independently shippable)

1. **ADR-0004 (SQL in services).** Extract repositories: `GoLiveRepository`, `SalesBridgeRepository`, `RecognitionRepository` (covers the port service). Cross-module tables (`payments`, `memberships`, `pt_products`) get read methods in their owning modules' repositories. Remove `(this.db as any)`.
2. **Dedup.** Shared `allocateNumber`, `insertId` and `totalCount` helpers for the four repositories and about ten call sites. A single date-helper module (`addDays`, `dayAfter`, `countDaysInclusive`, `toDateString`).
3. **Typing.** Replace `DrizzleDb<any>` and `getDb() as any` in the acct repositories with the schema-typed db. This is a repo-wide issue, so either do it for acct only or raise it separately.
4. **Naming.** Stop deriving `sourceId` from `journalNumber.replace(/\D/g,'')` at `accounting-posting.service.ts:170`. Carry `sourceId` explicitly.
5. **Remove speculative parameters** (`accountKind: 'input'`, `vendorId` in `tax-lines.ts`) unless a caller lands in the same PR.
6. **Split large files** only if still unwieldy after steps 1 and 2: `sales-bridge.service.ts` (747), `go-live.service.ts` (611), `reports.repository.ts` (693).

## Order and PR slicing

1. PR-A: Phase 4 decision, then R1 (small, unblocks the dev DB).
2. PR-B: R2 and R2b (GST), with specs.
3. PR-C: Phase 1 (money helpers and call sites).
4. PR-D: R3 and R4.
5. PR-E: Phase 2.
6. PR-F: Phase 3.
7. PR-G..: Phase 5, one concern per PR.

## Verification (every PR)

- `npm run test` for the touched specs. DB-backed specs run against the local MySQL 8.4 at `localhost:3308`, after resetting the DB (migration 0025 is edited in place).
- Re-run the double-entry invariant spec: total debit = total credit across all journals.
- After PR-D and PR-F, add reconciliation specs: balance sheet balances over two years, AP report = account `2000`, GST output = tax account movement.
- Before any UI run, check which API the app targets (the URL comes from Firestore).

## Open questions

1. Phase 4 option (a) or (b)?
2. Is a year-end close (journal to retained earnings) wanted, or is the computed retained-earnings line enough for R4?
3. Should unlock get its own permission slug (M2)?
