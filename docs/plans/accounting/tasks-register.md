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

## Phase 2 — Journal engine

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-020 | `[x]` | Create `apps/api/src/acct/` with module, repository, and `AccountingPostingService` | ACC-014 | `AppModule` imports `AcctModule`. SQL stays in the repository |
| ACC-021 | `[x]` | Post a balanced journal inside `runInTransaction` | ACC-020 | Debits equal credits in cents. A line cannot carry both sides. Amounts are positive |
| ACC-022 | `[x]` | Enforce unique `(source_type, source_id)` | ACC-021 | A second post returns the original journal and writes nothing new |
| ACC-023 | `[ ]` | Reject a post whose date falls in a locked period | ACC-021 | The source transaction rolls back |
| ACC-024 | `[ ]` | Reverse a posted journal | ACC-021 | The reversal swaps debit and credit, links `reverses_journal_id`, and does not edit the original |
| ACC-025 | `[ ]` | Manual journal and opening-balance journal endpoints | ACC-021, ACC-016 | `accounting.journals_write` required. Fewer than two lines is rejected |
| ACC-026 | `[ ]` | Vitest for balance, replay, locked period, and reversal | ACC-022, ACC-023, ACC-024 | `pnpm --filter api exec vitest run src/acct` passes |

## Phase 3 — Masters

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-030 | `[ ]` | Accounts list, create, and patch. Deactivate instead of delete | ACC-015, ACC-016, ACC-020 | A control account used by a seed cannot be deactivated |
| ACC-031 | `[ ]` | Tax codes and components | ACC-015, ACC-020 | Component rates sum to the code rate. Components post to seeded tax accounts |
| ACC-032 | `[ ]` | Vendors | ACC-020 | Inactive vendors cannot be used on a new bill |
| ACC-033 | `[ ]` | Items, with `inventory_tracked` fixed `false` | ACC-015, ACC-020 | Income and expense accounts are required. Kind is `service` or `goods` |
| ACC-034 | `[ ]` | List fiscal years and periods. Lock and unlock | ACC-016, ACC-023, ACC-070 | Lock requires `accounting.periods_close`, a balanced trial balance, and an audit row. Response includes draft document counts |

## Phase 4 — Purchases, expenses, money out

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-040 | `[ ]` | Purchase bill draft, lines, and post | ACC-015, ACC-021, ACC-032 | Post credits payable, debits line accounts and input tax, and stores `journal_entry_id`. Drafts are editable. Posted bills are not |
| ACC-041 | `[ ]` | Expense voucher. Credit expense posts to payable. Cash expense credits the chosen bank or cash account | ACC-015, ACC-021, ACC-032 | A cash expense has no payable balance. A credit expense uses a vendor |
| ACC-042 | `[ ]` | Payment voucher and allocations | ACC-040 | Allocations cannot exceed the open bill. The allocation sum equals the voucher total. Post debits payable and credits bank |
| ACC-043 | `[ ]` | Debit note against a posted bill | ACC-040 | Post debits payable and credits the bill accounts and input tax |
| ACC-044 | `[ ]` | Vitest for bill, cash expense, over-allocation, and debit note | ACC-040, ACC-041, ACC-042, ACC-043 | Specs pass |

## Phase 5 — Member sales bridge

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-050 | `[ ]` | Export `AccountingPostingService` and call it from `PaymentService` without a new cycle | ACC-017, ACC-021 | `PayModule` imports `AcctModule`. Posting is a no-op while `accounting.posting_enabled` is `false`. Existing payment specs still pass |
| ACC-051 | `[ ]` | On invoice insert, post receivable, discount, tax, and unearned or income | ACC-012, ACC-017, ACC-050 | Membership credits `2200`. PT credits `2210`. Anything else credits `4200` or the product income account. `source_type = sales_invoice` |
| ACC-052 | `[ ]` | On `payment_received`, debit the method's bank or cash account and credit receivable | ACC-051, ACC-011 | A missing `account_id` fails the collection while posting is on |
| ACC-053 | `[ ]` | On `refunded`, write and post a credit note for a full or proportional refund | ACC-051 | Refund above net paid stays rejected. `source_type = credit_note` |
| ACC-054 | `[ ]` | Refuse to set `accounting.posting_enabled` to `true` while any active payment method has no `account_id` | ACC-017, ACC-052 | The settings update returns a list of the methods that still need an account |
| ACC-055 | `[ ]` | When unearned revenue is credited, write a recognition schedule for the membership or PT term | ACC-051 | Schedule total equals the net credited to unearned |
| ACC-056 | `[ ]` | Vitest the invoice, collection, refund, disabled-posting no-op, and tax rounding gap | ACC-051, ACC-052, ACC-053 | A gap versus `payments.tax_amount` posts to `5900` and the spec shows the amount |

## Phase 6 — Recognition job

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-060 | `[ ]` | Register `accounting.recognize_revenue` on `JobRunnerService` | ACC-055, ACC-024 | The job posts debit unearned, credit income, for the month's straight-line share |
| ACC-061 | `[ ]` | Last month takes the remainder. A second run in the same month posts nothing | ACC-060 | After the term, `recognized_amount` equals `total_amount` and further runs are empty |

## Phase 7 — Reports

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-070 | `[ ]` | Trial balance for a date range | ACC-021 | Debit total equals credit total |
| ACC-071 | `[ ]` | Profit and loss for a date range | ACC-070 | Only income and expense accounts |
| ACC-072 | `[ ]` | Balance sheet as of a date, with current-year earnings under equity | ACC-071 | Assets equal liabilities plus equity |
| ACC-073 | `[ ]` | Day book for one date | ACC-021 | Every journal on that date is listed with its lines |
| ACC-074 | `[ ]` | Open AR from unpaid `payments`. Open AP from bills whose allocations are short | ACC-042, ACC-051 | A paid invoice and a fully allocated bill are absent |

## Phase 8 — Contract

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-080 | `[ ]` | Dump OpenAPI and regenerate `packages/api_client` | ACC-025, ACC-030, ACC-031, ACC-032, ACC-033, ACC-034, ACC-040, ACC-041, ACC-042, ACC-043, ACC-051, ACC-053, ACC-054, ACC-070, ACC-071, ACC-072, ACC-073, ACC-074 | `pnpm --filter api openapi:check` passes |
| ACC-081 | `[ ]` | One e2e path: enable posting, issue a membership invoice, collect it, run recognition, read trial balance | ACC-080, ACC-060 | The trial balance balances and unearned has moved by one month |

## Phase 9 — Flutter admin

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| ACC-090 | `[ ]` | Feature skeleton `app/lib/features/accounting/` with repository, use cases, and generated client | ACC-080 | `@LazySingleton` data layer and `@injectable` cubits, same as payments |
| ACC-091 | `[ ]` | Admin route and shell destination, hidden without `accounting.read` | ACC-090 | Member and trainer shells have no accounting route |
| ACC-092 | `[ ]` | Accounting home: cash, bank, open AR, open AP, current period | ACC-034, ACC-074, ACC-091 | Loading, empty, and error states use the shared widgets |
| ACC-093 | `[ ]` | Chart of accounts list and form | ACC-030, ACC-091 | Deactivated accounts stay visible and cannot be picked on a new document |
| ACC-094 | `[ ]` | Journal list, detail, and manual entry | ACC-025, ACC-091 | An unbalanced entry cannot be submitted |
| ACC-095 | `[ ]` | Vendors, purchase bills, expenses, payment vouchers | ACC-032, ACC-040, ACC-041, ACC-042, ACC-091 | Posting a draft refreshes the detail and shows the journal number |
| ACC-096 | `[ ]` | Trial balance, profit and loss, balance sheet, day book | ACC-070, ACC-071, ACC-072, ACC-073, ACC-091 | Totals on screen match the API totals |
| ACC-097 | `[ ]` | Period list with lock | ACC-034, ACC-091 | A locked period shows locked. The lock action is hidden without `accounting.periods_close` |
| ACC-098 | `[ ]` | Widget tests for home, journal entry validation, and a posted bill detail | ACC-092, ACC-094, ACC-095 | The tests pass. `dart analyze` is clean for the feature |

## Phase 10 — Later

These are recorded so the next plan can start from them. Do not implement them under this register.

| ID | Status | Task | Depends on | Notes |
|---|---|---|---|---|
| ACC-200 | `[>]` | Bank statement lines and reconciliation against `1010` and other bank accounts | ACC-021, ACC-042, ACC-052 | Needs a statement import and a match to journal lines |
| ACC-201 | `[>]` | Fixed assets, cost, accumulated depreciation, and a monthly depreciation journal | ACC-021, ACC-060 | Gym equipment. Uses the journal engine and the monthly job |
| ACC-202 | `[>]` | Payroll: salary structures, payslips, and statutory deductions | ACC-021, ACC-041 | Until then, salaries are expense vouchers to `5200` |
| ACC-203 | `[>]` | Inventory: turn on `items.inventory_tracked`, warehouses, goods receipts, stock movements | ACC-033, ACC-040 | Purchase bills already carry item lines |
| ACC-204 | `[>]` | Budgets per account and period | ACC-034, ACC-070 | Compare to the trial balance |
| ACC-205 | `[>]` | Backfill journals for `payments` dated before go-live | ACC-025, ACC-051 | This plan uses an opening journal instead. A backfill must not run while opening balances exist |

## Waves

Tasks in one wave can run together. A wave starts when every task it depends on is `[x]`.

| Wave | Start together | After |
|---|---|---|
| 1 | ACC-010 | ACC-001 |
| 2 | ACC-011, ACC-012, ACC-013 | ACC-010 |
| 3 | ACC-014 | Wave 2 |
| 4 | ACC-015, ACC-016, ACC-020 | ACC-014 |
| 5 | ACC-017, ACC-021, ACC-030, ACC-031, ACC-032, ACC-033 | Wave 4 |
| 6 | ACC-022, ACC-023, ACC-024, ACC-025, ACC-040, ACC-041, ACC-050, ACC-070, ACC-073 | Wave 5 |
| 7 | ACC-026, ACC-034, ACC-042, ACC-043, ACC-051, ACC-071 | Wave 6 |
| 8 | ACC-044, ACC-052, ACC-053, ACC-055, ACC-072, ACC-074 | Wave 7 |
| 9 | ACC-054, ACC-056, ACC-060 | Wave 8 |
| 10 | ACC-080 | The route tasks named on ACC-080 |
| 11 | ACC-081, ACC-090 | ACC-080. ACC-081 also needs ACC-060 |
| 12 | ACC-091 | ACC-090 |
| 13 | ACC-092, ACC-093, ACC-094, ACC-095, ACC-096, ACC-097 | ACC-091 |
| 14 | ACC-098 | ACC-092, ACC-094, ACC-095 |

One person owns a shared file even when the wave lists the tasks together:

- ACC-022, ACC-023, ACC-024, and ACC-025 edit `AccountingPostingService`.
- ACC-051, ACC-052, and ACC-053 edit `PaymentService`.
- ACC-014 is the only writer of `0025_accounting.sql`.

## Counts

| Marker | Count |
|---|---|
| `[ ]` TODO | 39 |
| `[~]` DOING | 0 |
| `[x]` DONE | 13 |
| `[!]` BLOCKED | 0 |
| `[>]` LATER | 6 |
