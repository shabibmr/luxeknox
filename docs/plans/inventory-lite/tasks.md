# Inventory Lite — task register

**Plan:** [plan.md](./plan.md). **Updated:** 2026-10-16 (purchase entry and stock ledger core added: IL-30 to IL-35, IL-23 to IL-25; IL-14 to be reworked by IL-31; order reviewed: IL-32 parallel to IL-30, IL-17 gated on IL-33, Flutter client trimmed to the item side; rows re-sorted into dependency order).
**Markers:** `[ ]` todo, `[~]` doing, `[x]` done, `[!]` blocked, `[>]` later. Change the marker here only.
Start a task when every ID in *Needs* is `[x]`.
**Row order:** top to bottom is a valid build order: every ID in a task's *Needs* is listed above it. Tasks in the same section can run in parallel unless one needs another. IDs are stable and not renumbered.

## A. Database

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-01 | `[x]` | Edit `schema/accounting.ts` + `0025_accounting.sql` in place: `items` new columns (`sku`, `hsn_sac`, `category_id`, `uom_id`, `sale_rate`, `purchase_rate`, `reorder_level`, `inventory_account_id`, `cogs_account_id`, `row_version`, timestamps), `uoms`, `item_categories`, `purchase_bill_lines.quantity` to `decimal(14,3)`, `debit_note_lines`, `inventory` control role | — | Migrate from empty works on `localhost:3308` |
| IL-02 | `[x]` | New `schema/inventory.ts` (export in `schema/index.ts`) and `0027_inventory.sql`: `item_stock`, `stock_movements`, `counter_sales`, `counter_sale_lines`, `counter_sale_tenders`, `sales_returns` (+lines, tenders), `stock_adjustments` (+lines), three number counters. Add the new `JOURNAL_SOURCE_TYPES` | IL-01 | Drift check clean; table list matches the full plan |
| IL-03 | `[x]` | Seed: UOMs, accounts `1400/4250/5050/5960`, `INV` permissions to `super_admin` and `admin`. Backfill existing items with `PCS` | IL-01 | Seed twice, no duplicates; existing items have a `uom_id` |

## B. Backend, counter sale (done)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-10 | `[x]` | `mulQtyRate` in `platform/money/money.ts` (integer maths, half-up) with spec | — | Spec covers 3-decimal qty and `.005` rounding |
| IL-11 | `[x]` | Extract the tax component split into `acct/tax-lines.ts` (tax code + side) | — | `member-sales-bridge.spec.ts` unchanged and green |
| IL-12 | `[x]` | Extend `/accounting/items` DTO, repository and service with the new item columns; validate `uom_id` and tracked rules | IL-01 | Create/update with new fields works; existing specs pass |
| IL-13 | `[x]` | `inv` module skeleton imported in `app.module.ts`; item read endpoints (list with search by name or SKU, get) | IL-03, IL-12 | List returns `uom_code`, `category_name`; SKU search works |
| IL-14 | `[x]` | Counter sale create: `SaleWrite` zod DTO, defaults, server totals, tender check, number `SAL-…`, journal in the same transaction, idempotency | IL-02, IL-10, IL-11, IL-13 | Journal balances; tender mismatch gives 422; same key returns same sale |
| IL-15 | `[x]` | Counter sale `get` and `list` | IL-14 | Lists omit lines/tenders; `get` has lines, tenders, journal number |
| IL-16 | `[x]` | Unit and e2e tests for IL-12 to IL-15 | IL-15 | `vitest run src/inv src/acct src/platform/money` green |

## C. Stock ledger and purchase write path (backend, wave 4a — IL-30 and IL-32 in parallel)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-30 | `[x]` | Stock service in `inv`: `receive(item, qty, value, source)` and `issue(item, qty, source)`, called inside the caller's transaction. Row lock on `item_stock`, weighted-average cost, last issue to empty takes the remaining value, `stock_movements` row per call, `insufficient_stock` when an issue exceeds on-hand, tracked items only | IL-02, IL-10 | Spec: 10@100 then 5@130 gives quantity 15, value 1650; issuing 2 takes 220; issuing 14 is refused; emptying stock leaves value 0 |
| IL-32 | `[x]` | Purchase bill write path: item defaults (name, `purchase_rate`, item tax code), `account_id` optional for item lines (tracked: server sets `inventory_account_id`; untracked: `expense_account_id`; no item: required), quantity 3dp limited by UOM decimal places, `mulQtyRate` for line amounts, optional `supplier_invoice_no` unique per vendor among non-void bills (forward migration `0029` + schema; do not rely on editing already-applied `0025`). Needs nothing from IL-30, so start it alongside IL-30 | IL-12, IL-10 | A 3dp quantity on `KG` works and on `PCS` is refused; a client `account_id` on a tracked line is ignored; a duplicate supplier invoice number is refused; existing bill specs pass |

## D. Stock ledger consumers (backend, wave 4b — IL-31 and IL-33 in parallel, IL-34 straight after IL-33)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-31 | `[x]` | Rework counter sale (IL-14) to use the ledger: issue tracked lines at average cost, freeze `unit_cost` and `cost_amount`, add Dr `5050` / Cr `1400` per tracked line to the same journal. Update the IL-14 specs | IL-14, IL-30 | Journal balances with COGS; a service-only sale has no COGS; selling above on-hand is refused and nothing is posted |
| IL-33 | `[x]` | Purchase bill post hook: tracked lines debit Inventory and `receive` stock at `net_amount`, in the posting transaction. Replay of a post receives nothing twice. Responses add `item_name`, `uom_code`, `inventory_tracked`, `returned_quantity` (0) | IL-30, IL-32 | Posting a bill for 10 units sets `item_stock` to 10 and debits `1400` for the net; a locked period rolls back journal and stock; a second post returns the original journal |
| IL-34 | `[ ]` | Refuse debit notes against bills with tracked lines (`debit_note_tracked_deferred`). Land it straight after IL-33 so no tracked bill can be debit-noted without a stock reversal | IL-33 | Service-only bills still take debit notes; a tracked bill gives 422 |

## E. API contract and backend tests (wave 5)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-17 | `[ ]` | `openapi:dump`, regenerate `packages/api_client`, `openapi:check` (after the purchase bill changes too). Can start as soon as IL-33 lands, even while IL-31, IL-34 and IL-35 are open; regenerate again if IL-35 changes the contract | IL-15, IL-33 | Check passes; `INVApi` generated; purchase bill line fields present |
| IL-35 | `[ ]` | Vitest and e2e for IL-30 to IL-34: two bills then a sale (average cost and COGS), service plus tracked mixed bill, UOM decimals, replay, period lock, debit-note guard | IL-31, IL-33, IL-34 | `vitest run src/inv src/acct src/platform/money` green; every journal balances |

## F. Flutter, item search (wave 6 — runs in parallel with G)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-20 | `[ ]` | Freezed entity `Item` (counter sale entities wait for IL-94) | IL-17 | Field names match the contract |
| IL-21 | `[ ]` | Datasource on `INVApi`, mapper, repository (`searchItems`, `getItem`); register in `register_module.dart`; regenerate injector | IL-20 | Repository tests pass with a mocked client |
| IL-22 | `[ ]` | `ItemSearchField`: debounced search by name or SKU, with the shared `App*` loading/empty/error widgets | IL-21 | Widget test: typing shows results, selecting returns the item |

## G. Flutter, purchase entry (waves 6 and 7)

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-23 | `[ ]` | Purchase entry data layer: `PurchaseBillLine` gains `itemName`, `uomCode`, `inventoryTracked`; bill entity and mappers gain `supplierInvoiceNo`; regenerate freezed and the injector; `account_id` optional in the write model | IL-17 | Mapper tests cover tracked, untracked and service lines |
| IL-25 | `[ ]` | Purchase bill detail and list: show item name, quantity with UOM, supplier invoice number, and the journal number after posting | IL-23 | Widget test with a tracked and a service line |
| IL-24 | `[ ]` | Purchase entry form (`purchase_bill_form_screen.dart` and its cubit): `ItemSearchField` per line, defaults from the item, UOM suffix and decimal limit on quantity, account picker hidden for tracked items, "rate excludes tax" hint, live totals (display only), supplier invoice number, **Save draft** and **Save & post** (create, then post with its own idempotency key) | IL-22, IL-23 | Cubit test: picking an item fills rate and tax; Save & post calls create then post once; a server error (period locked) shows on the form |

## Later (tables exist, no code)

| ID | Status | Task |
|---|---|---|
| IL-90 | `[>]` | UOM and category API and screens |
| IL-91 | `[>]` | Item form screen; move item writes to `/inventory/items` |
| IL-92 | `[>]` | Stock reports (summary, ledger, low stock), purchase register, valuation check. (Ledger core, COGS, no-negative-stock and the purchase hook moved into IL-30 to IL-33.) |
| IL-93 | `[>]` | Sales returns, debit-note lines and purchase returns (lifts the IL-34 guard), stock adjustments including opening stock, `opening_stock_mismatch` go-live check |
| IL-94 | `[>]` | Overview, counter sale screen, including the Flutter `CounterSale`, `SaleLine`, `Tender` entities and `listCounterSales`, `getCounterSale`, `createCounterSale` on the repository |

## Waves

| Wave | Tasks |
|---|---|
| 1 | IL-01, IL-10, IL-11 |
| 2 | IL-02, IL-03, IL-12 |
| 3 | IL-13, then IL-14, then IL-15 (IL-16 after) |
| 4 | IL-30 and IL-32 in parallel, then IL-31 and IL-33 in parallel, then IL-34 straight after IL-33 |
| 5 | IL-17 as soon as IL-33 is done; IL-35 once IL-31, IL-33, IL-34 are done (regenerate IL-17 if the contract moves) |
| 6 | After IL-17: IL-20 → IL-21 → IL-22, and IL-23 → IL-25 in parallel |
| 7 | IL-24 (needs IL-22 and IL-23) |
