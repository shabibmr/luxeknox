# Accounting module task register

**Plan:** [implementation-plan.md](./implementation-plan.md)
**Updated:** 2026-10-12
**Rule:** This file is the status source. Change the marker here when a task moves. Do not duplicate status into the plan.
**Depends on** lists direct predecessors only. Start a task when every ID in that cell is `[x]`.

## Status markers

| Marker | Meaning |
|---|---|
| `[ ]` | TODO. Not started. |
| `[~]` | DOING. In progress. |
| `[x]` | DONE. Verified. |
| `[!]` | BLOCKED. The blocker is written on the task. |
| `[>]` | LATER. Named so it is not forgotten. Not part of this delivery. |

Later rows stay `[>]` until a new plan pulls them in.

## Phase 0 — Record the decisions

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-001 | `[x]` | Write `docs/adr/0010-accounting-ledger.md` with the twelve decisions in the plan | — | ADR is accepted in `docs/adr/README.md` |
| ACC-002 | `[x]` | Add an Accounting section to `docs/Entities-List.md` and `docs/database-entities.md` | ACC-001 | Names match `schema/accounting.ts` |
| ACC-003 | `[ ]` | Amend ADR-0010 with decision 13 (recognition follows the term) and decision 14 (go-live carries unearned revenue forward). Add `fund_transfers` and the new schedule columns to the entity docs | ACC-001, ACC-002 | ADR lists fourteen decisions. Entity docs match `schema/accounting.ts` after ACC-018 |

## Phase 1 — Schema, seed, settings

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-010 | `[x]` | Add `apps/api/src/platform/db/schema/accounting.ts` and export it from `schema/index.ts` | ACC-001 | Tables match the plan's data model. Money is `decimal(12,2)`. Headers have `row_version` |
| ACC-011 | `[x]` | Add `payment_methods.account_id` | ACC-010 | Nullable FK to `accounts`. Existing rows stay valid |
| ACC-012 | `[x]` | Add `income_account_id` on membership products and PT products | ACC-010 | Nullable FK. Existing sales still post |
| ACC-013 | `[x]` | Add number counters for journal, purchase bill, expense, payment voucher, credit note, debit note | ACC-010 | Same single-row shape as `invoice_number_counters` |
| ACC-014 | `[x]` | Write `apps/api/drizzle/0025_accounting.sql` and apply it on MySQL `localhost:3308` | ACC-010, ACC-011, ACC-012, ACC-013 | Migrate succeeds. Schema drift check is clean |
| ACC-015 | `[x]` | Seed the chart, GST 18% (CGST 9 + SGST 9), IGST 18%, exempt 0%, the current fiscal year, and its months | ACC-014 | Re-running the seed does not duplicate codes |
| ACC-016 | `[x]` | Seed `ACCT` permissions and grant them to `super_admin` and `admin` only | ACC-014 | Slugs match the plan. Other roles are unchanged |
| ACC-017 | `[x]` | Add `accounting.posting_enabled`, `accounting.fiscal_year_start_month`, `accounting.default_tax_code` to the settings catalogue | ACC-015 | Defaults are `false`, `4`, and the GST 18% code. Posting stays off |
| ACC-018 | `[x]` | Add `fund_transfers`, the fund transfer counter, and `recognized_through`, `status`, `paused_from` on `revenue_recognition_schedules`. Edit `schema/accounting.ts` and `0025_accounting.sql` in place, then reset the local database | ACC-014 | Migrate from empty succeeds on `localhost:3308`. Drift check is clean. `src/acct` specs still pass |
| ACC-019 | `[x]` | Seed `1020 Card/UPI clearing` (bank), `4300 Forfeited membership income`, `5500 Bank and processor charges`, `5950 Rounding off` | ACC-015, ACC-018 | Re-running the seed does not duplicate codes. `1020` has `is_bank = true` |

## Phase 2 — Journal engine

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-020 | `[x]` | Create `apps/api/src/acct/` with module, repository, and `AccountingPostingService` | ACC-014 | `AppModule` imports `AcctModule`. SQL stays in the repository |
| ACC-021 | `[x]` | Post a balanced journal inside `runInTransaction` | ACC-020 | Debits equal credits in cents. A line cannot carry both sides. Amounts are positive |
| ACC-022 | `[x]` | Enforce unique `(source_type, source_id)` | ACC-021 | A second post returns the original journal and writes nothing new |
| ACC-023 | `[x]` | Reject a post whose date falls in a locked period | ACC-021 | The source transaction rolls back |
| ACC-024 | `[x]` | Reverse a posted journal | ACC-021 | The reversal swaps debit and credit, links `reverses_journal_id`, and does not edit the original |
| ACC-025 | `[x]` | Manual journal and opening-balance journal endpoints | ACC-021, ACC-016 | `accounting.journals_write` required. Fewer than two lines is rejected |
| ACC-026 | `[x]` | Vitest for balance, replay, locked period, and reversal | ACC-022, ACC-023, ACC-024 | `pnpm --filter api exec vitest run src/acct` passes |

## Phase 3 — Masters

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-030 | `[x]` | Accounts list, create, and patch. Deactivate instead of delete | ACC-015, ACC-016, ACC-020 | A control account used by a seed cannot be deactivated |
| ACC-031 | `[x]` | Tax codes and components | ACC-015, ACC-020 | Component rates sum to the code rate. Components post to seeded tax accounts |
| ACC-032 | `[x]` | Vendors | ACC-020 | Inactive vendors cannot be used on a new bill |
| ACC-033 | `[x]` | Items, with `inventory_tracked` fixed `false` | ACC-015, ACC-020 | Income and expense accounts are required. Kind is `service` or `goods` |
| ACC-034 | `[x]` | List fiscal years and periods. Lock and unlock | ACC-016, ACC-023 | Lock requires `accounting.periods_close`, a balanced trial balance, and an audit row. Response includes draft document counts. The trial-balance totals live in `PeriodsRepository.calculateTrialBalanceTotals`; ACC-070 reuses them |

## Phase 4 — Purchases, expenses, money out

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-040 | `[x]` | Purchase bill draft, lines, and post | ACC-015, ACC-021, ACC-032 | Post credits payable, debits line accounts and input tax, and stores `journal_entry_id`. Drafts are editable. Posted bills are not |
| ACC-041 | `[x]` | Expense voucher. Credit expense posts to payable. Cash expense credits the chosen bank or cash account | ACC-015, ACC-021, ACC-032 | A cash expense has no payable balance. A credit expense uses a vendor |
| ACC-042 | `[x]` | Payment voucher and allocations | ACC-040 | Allocations cannot exceed the open bill. The allocation sum equals the voucher total. Post debits payable and credits bank |
| ACC-043 | `[x]` | Debit note against a posted bill | ACC-040 | Post debits payable and credits the bill accounts and input tax |
| ACC-044 | `[x]` | Vitest for bill, cash expense, over-allocation, and debit note | ACC-040, ACC-041, ACC-042, ACC-043 | Specs pass |
| ACC-045 | `[x]` | Fund transfer draft and post, with an optional fee line. Covers cash deposits, bank to bank, and card/UPI settlement from `1020` | ACC-018, ACC-019, ACC-021 | Post credits the source for the gross, debits the destination for gross minus fee, and debits the fee account. Both accounts are `is_bank` and differ. `accounting.payments_write` required. `source_type = fund_transfer` |
| ACC-046 | `[x]` | Vitest for a cash deposit, a card settlement with a fee, and a same-account transfer rejected | ACC-045 | Specs pass |

## Phase 5 — Member sales bridge

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-050 | `[x]` | Export `AccountingPostingService` and call it from `PaymentService` without a new cycle | ACC-017, ACC-021 | `PayModule` imports `AcctModule`. Posting is a no-op while `accounting.posting_enabled` is `false`. Existing payment specs still pass |
| ACC-051 | `[x]` | On invoice insert, post receivable, discount, tax, and unearned or income | ACC-012, ACC-017, ACC-050 | Membership credits `2200`. PT credits `2210`. Anything else credits `4200` or the product income account. `source_type = sales_invoice` |
| ACC-052 | `[x]` | On `payment_received`, debit the method's bank or cash account and credit receivable | ACC-051, ACC-011 | A missing `account_id` fails the collection while posting is on |
| ACC-053 | `[x]` | On `refunded`, write and post a credit note for a full or proportional refund | ACC-051 | Refund above net paid stays rejected. `source_type = credit_note` |
| ACC-054 | `[x]` | Refuse to set `accounting.posting_enabled` to `true` while any active payment method has no `account_id`, or while `tax_rate_percent` differs from the rate on `accounting.default_tax_code` | ACC-017, ACC-052 | The settings update returns every failing check at once, including the methods that still need an account |
| ACC-055 | `[x]` | When unearned revenue is credited, write a recognition schedule for the membership or PT term | ACC-051, ACC-018 | Schedule total equals the net credited to unearned. `recognized_through` is the day before the term starts. `status = open` |
| ACC-056 | `[x]` | Vitest the invoice, collection, refund, disabled-posting no-op, and tax rounding gap | ACC-051, ACC-052, ACC-053, ACC-019 | A gap versus `payments.tax_amount` posts to `5950` and the spec shows the amount |
| ACC-057 | `[x]` | On `adjusted`, post the change. A decrease writes and posts a credit note. An increase posts a `sales_adjustment` journal. Both resize the recognition schedule by the net share | ACC-053, ACC-055 | Receivable on the ledger equals `total_amount - amount_paid` after any adjustment. A decrease below the unrecognized balance is rejected |
| ACC-058 | `[x]` | Recognition port called from membership and PT services. Re-plan on freeze approval, freeze end, extend, upgrade, and renew, as the plan's table says | ACC-055, ACC-018 | `AcctModule` does not import `MembershipModule` or `PtModule`. Posted recognition is never edited. Only the remaining amount moves. No-op while posting is off |
| ACC-059 | `[x]` | On membership or PT cancellation, forfeit the remaining unearned amount to `4300` after any refund credit note | ACC-058, ACC-019 | The schedule is `closed` with unearned at zero. `source_type = recognition_forfeit` |

## Phase 6 — Recognition job and go-live

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-060 | `[x]` | Register `accounting.recognize_revenue` on `JobRunnerService` | ACC-055, ACC-024, ACC-018 | The job posts debit unearned, credit income, prorated by day from `recognized_through + 1` to month end or `ends_on`. Paused schedules post nothing for frozen days |
| ACC-061 | `[x]` | Last span takes the remainder. A second run in the same month posts nothing | ACC-060 | After the term, `recognized_amount` equals `total_amount`, the schedule is `closed`, and further runs are empty |
| ACC-062 | `[x]` | Period lock refuses while posting is on and the recognition run for that period has not posted | ACC-034, ACC-060 | The error names the period and the missing run |
| ACC-063 | `[x]` | Vitest for a mid-month start, a freeze that pauses then extends, an upgrade, a cancellation forfeit, and an adjustment up and down | ACC-057, ACC-058, ACC-059, ACC-061 | Specs pass. Each case ends with unearned on the ledger equal to the schedule's unrecognized amount |
| ACC-064 | `[x]` | Go-live. `GET /accounting/go-live/unearned-preview` for running memberships and PT terms. Enabling posting also checks that the opening journal's `2200` and `2210` match the preview, then writes the go-live schedules in the same transaction | ACC-054, ACC-060, ACC-025 | A mismatch is refused with both amounts. Go-live schedules have `recognized_through` set to the day before go-live. The spec covers both |

## Phase 7 — Reports

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-070 | `[x]` | Trial balance for a date range | ACC-021 | Debit total equals credit total. Uses the same totals query as period lock (ACC-034). One trial-balance query in the codebase |
| ACC-071 | `[x]` | Profit and loss for a date range | ACC-070 | Only income and expense accounts |
| ACC-072 | `[x]` | Balance sheet as of a date, with current-year earnings under equity | ACC-071 | Assets equal liabilities plus equity |
| ACC-073 | `[x]` | Day book for one date | ACC-021 | Every journal on that date is listed with its lines |
| ACC-074 | `[x]` | Open AR from unpaid `payments`. Open AP from bills whose allocations are short | ACC-042, ACC-051 | A paid invoice and a fully allocated bill are absent |
| ACC-075 | `[x]` | GST summary for a date range: taxable value and output CGST, SGST, IGST by tax code, input tax credit, net payable | ACC-070, ACC-040, ACC-041, ACC-051 | Output tax per component equals that tax account's movement for the range. Net payable equals output minus input |
| ACC-076 | `[x]` | Journal list filter by `payment_id` | ACC-025 | Returns the invoice, receipt, credit note, adjustment, and recognition journals for that payment, and nothing else |

## Phase 8 — Contract

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-080 | `[x]` | Dump OpenAPI and regenerate `packages/api_client` | ACC-025, ACC-030, ACC-031, ACC-032, ACC-033, ACC-034, ACC-040, ACC-041, ACC-042, ACC-043, ACC-045, ACC-051, ACC-053, ACC-054, ACC-057, ACC-064, ACC-070, ACC-071, ACC-072, ACC-073, ACC-074, ACC-075, ACC-076 | `pnpm --filter api openapi:check` passes |
| ACC-081 | `[x]` | One e2e path: post the opening journal, enable posting, issue a membership invoice mid-month, collect it, run recognition, freeze, cancel, read trial balance | ACC-080, ACC-060, ACC-058, ACC-059, ACC-064 | The trial balance balances. Unearned moved by the prorated days. After cancellation the schedule's unearned is zero and `4300` holds the rest |

## Phase 9 — Flutter admin

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-090 | `[x]` | Feature skeleton `app/lib/features/accounting/` with repository, use cases, and generated client | ACC-080 | `@LazySingleton` data layer and `@injectable` cubits, same as payments |
| ACC-091 | `[x]` | Admin route and shell destination, hidden without `accounting.read` | ACC-090 | Member and trainer shells have no accounting route |
| ACC-092 | `[ ]` | Accounting home: cash, bank, open AR, open AP, current period | ACC-034, ACC-074, ACC-091 | Loading, empty, and error states use the shared widgets |
| ACC-093 | `[ ]` | Chart of accounts list and form | ACC-030, ACC-091 | Deactivated accounts stay visible and cannot be picked on a new document |
| ACC-094 | `[ ]` | Journal list, detail, and manual entry | ACC-025, ACC-091 | An unbalanced entry cannot be submitted |
| ACC-095 | `[ ]` | Vendors, purchase bills, expenses, payment vouchers, fund transfers | ACC-032, ACC-040, ACC-041, ACC-042, ACC-045, ACC-091 | Posting a draft refreshes the detail and shows the journal number. A transfer shows the fee line |
| ACC-096 | `[ ]` | Trial balance, profit and loss, balance sheet, day book, GST summary | ACC-070, ACC-071, ACC-072, ACC-073, ACC-075, ACC-091 | Totals on screen match the API totals |
| ACC-097 | `[ ]` | Period list with lock | ACC-034, ACC-062, ACC-091 | A locked period shows locked. The lock action is hidden without `accounting.periods_close`. A refused lock shows the reason |
| ACC-098 | `[ ]` | Widget tests for home, journal entry validation, a posted bill detail, and the go-live checklist | ACC-092, ACC-094, ACC-095, ACC-099 | The tests pass. `dart analyze` is clean for the feature |
| ACC-099 | `[ ]` | Go-live setup: map payment methods to accounts, show the unearned preview and opening-journal match, enable posting | ACC-054, ACC-064, ACC-091 | Every failing check is listed. The enable action is hidden without `accounting.posting_toggle` |
| ACC-100 | `[ ]` | Journals link on the existing payment detail screen in `app/lib/features/payments/` | ACC-076, ACC-090 | Hidden without `accounting.read`. Lists the payment's journals and opens the journal detail |

## Phase 10 — Later

These are recorded so the next plan can start from them. Do not implement them under this register.

| ID | Status | Task | Depends on | Notes |
|---|---|---|---|---|
| ACC-200 | `[>]` | Bank statement lines and reconciliation against `1010` and other bank accounts | ACC-021, ACC-042, ACC-052 | Needs a statement import and a match to journal lines. Card/UPI settlements via ACC-045 make `1020` reconcilable too |
| ACC-201 | `[>]` | Fixed assets, cost, accumulated depreciation, and a monthly depreciation journal | ACC-021, ACC-060 | Gym equipment. Uses the journal engine and the monthly job |
| ACC-202 | `[>]` | Payroll: salary structures, payslips, and statutory deductions | ACC-021, ACC-041 | Until then, salaries are expense vouchers to `5200` |
| ACC-203 | `[>]` | Inventory: turn on `items.inventory_tracked`, warehouses, goods receipts, stock movements | ACC-033, ACC-040 | Purchase bills already carry item lines |
| ACC-204 | `[>]` | Budgets per account and period | ACC-034, ACC-070 | Compare to the trial balance |
| ACC-205 | `[>]` | Backfill journals for `payments` dated before go-live | ACC-025, ACC-051 | This plan uses an opening journal instead. A backfill must not run while opening balances exist |
| ACC-206 | `[>]` | TDS on rent and contractor or freelance trainer fees: deduct on bills and payment vouchers, TDS payable account, deposit voucher | ACC-040, ACC-042 | Sections 194I and 194J are the common cases for a gym |
| ACC-207 | `[>]` | Member advances and refundable deposits: locker key deposits, wallet credit | ACC-051, ACC-052 | A liability per member, not revenue. Needs a counter flow in POS |

## Waves

Tasks in one wave can run together. A wave starts when every task it depends on is `[x]`. Waves 1 to 5 are complete. Wave 6 onward lists only open tasks.

| Wave | Start together | After |
|---|---|---|
| 1 | ACC-010 | ACC-001 |
| 2 | ACC-011, ACC-012, ACC-013 | ACC-010 |
| 3 | ACC-014 | Wave 2 |
| 4 | ACC-015, ACC-016, ACC-020 | ACC-014 |
| 5 | ACC-017, ACC-021–ACC-026, ACC-030–ACC-034 | Wave 4 |
| 6 | ACC-003, ACC-018, ACC-040, ACC-041, ACC-050, ACC-070, ACC-073, ACC-076 | Wave 5 |
| 7 | ACC-019, ACC-042, ACC-043, ACC-051, ACC-071 | Wave 6 |
| 8 | ACC-044, ACC-045, ACC-052, ACC-053, ACC-055, ACC-072, ACC-074, ACC-075 | Wave 7 |
| 9 | ACC-046, ACC-054, ACC-056, ACC-057, ACC-058, ACC-060 | Wave 8 |
| 10 | ACC-059, ACC-061, ACC-062, ACC-064 | Wave 9 |
| 11 | ACC-063, ACC-080 | Wave 10 |
| 12 | ACC-081, ACC-090 | ACC-080 |
| 13 | ACC-091 | ACC-090 |
| 14 | ACC-092, ACC-093, ACC-094, ACC-095, ACC-096, ACC-097, ACC-099, ACC-100 | ACC-091 |
| 15 | ACC-098 | ACC-092, ACC-094, ACC-095, ACC-099 |

One person owns a shared file even when the wave lists the tasks together:

- ACC-051, ACC-052, ACC-053, and ACC-057 edit `PaymentService`.
- ACC-058 and ACC-059 edit `MembershipService` and `PtSubscriptionService`.
- ACC-054 and ACC-064 edit the posting toggle in settings.
- ACC-018 is the only writer of `0025_accounting.sql` from here on.

## Counts

| Marker | Count |
|---|---|
| `[ ]` TODO | 10 |
| `[~]` DOING | 0 |
| `[x]` DONE | 57 |
| `[!]` BLOCKED | 0 |
| `[>]` LATER | 8 |
