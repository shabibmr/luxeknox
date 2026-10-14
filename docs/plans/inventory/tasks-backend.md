# Inventory module — backend task register

**Plan:** [implementation-plan.md](./implementation-plan.md)
**Contract:** [contract.md](./contract.md). The API must match it. Change the contract before the code.
**Frontend tasks:** [tasks-frontend.md](./tasks-frontend.md)
**Updated:** 2026-10-13
**Scope:** `apps/api`, `packages/api_client`, `docs/openapi`, and docs.
**Rule:** This file is the status source for backend tasks. Change the marker here when a task moves. Do not duplicate status into the plan.
**Depends on:** lists direct predecessors only. Start a task when every ID in that cell is `[x]`. `ACC-` IDs refer to [the accounting register](../accounting/tasks-register.md).

## Status markers

| Marker | Meaning |
|---|---|
| `[ ]` | TODO. Not started. |
| `[~]` | DOING. In progress. |
| `[x]` | DONE. Verified. |
| `[!]` | BLOCKED. The blocker is written on the task. |
| `[>]` | LATER. Named so it is not forgotten. Not part of this delivery. |

## Phase 0 — Record the decisions

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-001 | `[ ]` | Write `docs/adr/0011-inventory.md` with the fourteen decisions in the plan. Re-point ACC-203 in the accounting register to this plan | — | ADR is accepted in `docs/adr/README.md`. ACC-203 notes "pulled into inventory plan" |
| INV-002 | `[ ]` | Add an Inventory section to `docs/Entities-List.md` and `docs/database-entities.md`. Update the `items`, `purchase_bill_lines`, and `debit_notes` entries | INV-001, INV-011, INV-012 | Names match `schema/accounting.ts` and `schema/inventory.ts` |
| INV-003 | `[ ]` | Review and freeze `contract.md` with the frontend owner | — | Status line reads "Frozen". Both owners agree. Later changes are noted on the affected tasks in both files |

## Phase 1 — Schema, seed, helpers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-010 | `[ ]` | Add `uoms` and `item_categories`, each with `row_version` and timestamps. Add `sku`, `hsn_sac`, `category_id`, `uom_id`, `sale_rate`, `purchase_rate`, `reorder_level`, `inventory_account_id`, `cogs_account_id`, `row_version`, and timestamps to `items`. Add `inventory` to `ACCOUNT_CONTROL_ROLES`. Edit `schema/accounting.ts` and `0025_accounting.sql` in place, then reset the local database | INV-001 | Migrate from empty succeeds on `localhost:3308`. Drift check is clean. `src/acct` specs still pass |
| INV-011 | `[ ]` | Add `schema/inventory.ts` and export it from `schema/index.ts`. Tables: `item_stock`, `stock_movements`, the counter sale tables, the sales return tables, the stock adjustment tables, and three counters. Write `drizzle/0026_inventory.sql`. Add `counter_sale`, `counter_sale_return`, `stock_adjustment` to `JOURNAL_SOURCE_TYPES` | INV-010 | Migrate from empty succeeds. Drift check is clean. Quantities are `decimal(14,3)`, `unit_cost` is `decimal(14,4)`, money is `decimal(12,2)`. Headers have `row_version` |
| INV-012 | `[ ]` | Change `purchase_bill_lines.quantity` to `decimal(14,3)`. Add `debit_note_lines` with `debit_note_id`, `purchase_bill_line_id`, `quantity` nullable, `net_amount`, `tax_amount`. Edit `0025_accounting.sql` in place | INV-010 | Migrate from empty succeeds. Drift check is clean |
| INV-013 | `[ ]` | Seed UOMs `PCS`, `BOX`, `PKT`, `BTL`, `KG`, `G`, `LTR`, `ML`. Seed accounts `1400 Inventory` (control `inventory`), `4250 Merchandise sales`, `5050 Cost of goods sold`, `5960 Inventory adjustments` | INV-010 | Re-running the seed does not duplicate codes. `KG` and `LTR` allow 3 decimals. `PCS` allows 0 |
| INV-014 | `[ ]` | Seed `INV` permissions (`inventory.read`, `inventory.masters_write`, `inventory.sales_write`, `inventory.adjust`). Grant them to `super_admin` and `admin` only | INV-001 | Slugs match the contract. Other roles are unchanged |
| INV-015 | `[ ]` | Add `mulQtyRate(qty, rate)` to `apps/api/src/platform/money/money.ts`, using integer maths and half-up rounding. Replace `Number(qty) * Number(rate)` in `purchase-bills.service.ts` | — | The spec covers 3-decimal quantities and half-up at `.005`. Purchase bill specs still pass |
| INV-016 | `[ ]` | Extract the tax component split from `sales-bridge.service.ts` into `acct/tax-lines.ts`. It takes a tax code and a side (output or input). The bridge still passes `accounting.default_tax_code` | — | `member-sales-bridge.spec.ts` passes unchanged. A new spec covers an input-side split |

## Phase 2 — Stock engine

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-020 | `[ ]` | Create `apps/api/src/inv/` with module and repository. `InvModule` imports `AcctModule`. `AppModule` imports `InvModule` | INV-011 | The app boots. `AcctModule` does not import `InvModule` |
| INV-021 | `[ ]` | `InventoryHooks` registry in `acct/inventory-hooks.ts`, exported from `AcctModule`, with `onPurchaseBillPosting` and `onDebitNotePosting`. It is a no-op when nothing is registered. `InvModule` registers its handler in `onModuleInit` | INV-020 | Hooks run inside the posting transaction. A throw from a hook rolls back the bill or debit note |
| INV-022 | `[ ]` | `StockLedgerService` with `receive`, `issue`, `adjust`. It locks `item_stock` with `FOR UPDATE`, writes `stock_movements` with balances, and recomputes the moving average. It refuses negative stock (`insufficient_stock`) and enforces UOM decimals (`uom_decimals_exceeded`). It returns any zero-quantity residual so the caller can post it to `5960` | INV-020, INV-015 | `item_stock` quantity and value equal the last movement's balances. Value is zero whenever quantity is zero |
| INV-023 | `[ ]` | Vitest: average cost across three receipts at different costs, a refused oversell, the residual rule, and a quantity with too many decimals | INV-022 | `pnpm --filter api exec vitest run src/inv` passes |

## Phase 3 — Masters

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-030 | `[ ]` | UOM `listUoms`, `createUom`, `updateUom`. Deactivate instead of delete. The response includes `in_use` | INV-020, INV-013, INV-014 | `inventory.masters_write` is required for writes. `decimal_places` is `field_frozen` while any item uses the UOM |
| INV-031 | `[ ]` | Category `listItemCategories`, `createItemCategory`, `updateItemCategory`, with one level of parent | INV-020, INV-014 | A self-parent or grandparent is refused with `category_depth`. An inactive category cannot be set on an item |
| INV-032 | `[ ]` | Move item CRUD to `/inventory/items` (`listItems`, `getItem`, `createItem`, `updateItem`), with the contract fields including `stock` and `has_movements`. Delete `acct/items.controller.ts` and the `/accounting/items` routes. `AcctModule` keeps a read-only item lookup for bill lines | INV-030, INV-031 | Tracked items follow `tracked_item_rules`, defaulting accounts to `1400` and `5050`. `inventory_tracked` and `uom_id` are `field_frozen` once movements exist. `search` matches name and SKU. `src/acct` specs pass |
| INV-033 | `[ ]` | Vitest for masters: tracked rules, frozen fields, category depth, UOM in use, and optimistic `row_version` 409 | INV-032 | Specs pass |

## Phase 4 — Purchases and purchase returns

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-040 | `[ ]` | Purchase bill tracked lines. On create and update, a tracked item's `account_id` is set to `item.inventory_account_id`; the field is optional in the DTO and required for lines that are not tracked. Quantity is checked against the UOM. Responses add `item_name`, `uom_code`, `inventory_tracked`, `returned_quantity`. On post, the hook receives stock at `net_amount / quantity` | INV-012, INV-021, INV-022, INV-032 | Posting a bill for 10 units sets `item_stock` to 10 and debits `1400` for the net. A service line posts as before. Matches the contract |
| INV-041 | `[ ]` | Debit-note lines. The body follows the contract: `quantity` for item lines, `amount` for lines without an item. Header totals are the sum of lines. Per-line tax uses the bill line's tax code. Quantity is capped by billed less earlier debit notes (`return_qty_exceeded`) and by on-hand (`insufficient_stock`). On post, the hook issues stock at the bill line's unit cost | INV-040, INV-016 | Post debits AP, credits input tax, and credits each line's account. Open AP still equals bill less allocations less debit notes. The response includes `lines` |
| INV-042 | `[ ]` | Vitest: a bill with tracked and service lines, a partial debit note, a refused over-return, and a debit note that empties stock with a residual to `5960` | INV-040, INV-041 | Specs pass. Every journal balances |

## Phase 5 — Sales, returns, adjustments

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-050 | `[ ]` | `createCounterSale`, `listCounterSales`, `getCounterSale`. Create also posts. It supports lines, line discount, per-line tax code, and split tenders. Stock is issued at average cost and `unit_cost` is frozen on the line. One journal covers tenders, income, output tax, and COGS against Inventory. `source_type = counter_sale` | INV-016, INV-022, INV-032 | `tender_total_mismatch`, `payment_method_unmapped`, and `item_inactive` are raised as the contract says. A replay with the same `Idempotency-Key` returns the original sale. `inventory.sales_write` is required. Totals follow the contract's line and total arithmetic. `tender_total_mismatch` details carry `expected` and `received` |
| INV-051 | `[ ]` | `createSalesReturn`, `listSalesReturns`, `getSalesReturn` against one posted counter sale, with refund tenders. Stock comes back at the sale line's frozen `unit_cost`. A mirror journal covers the returned share. `source_type = counter_sale_return`. The sale's lines expose `returned_quantity` and the sale lists its `returns` | INV-050 | `return_qty_exceeded` is raised when quantity is above sold less returned. Refund tenders sum to the return total. COGS reverses at the frozen cost. The pro-rata rule, with the last return taking the remainder, matches the contract |
| INV-052 | `[ ]` | `createStockAdjustment`, `updateStockAdjustment`, `postStockAdjustment`, `listStockAdjustments`, `getStockAdjustment`. `opening` posts stock only. Other reasons post Inventory against `5960`. `source_type = stock_adjustment` | INV-022, INV-032 | A positive line needs `unit_cost`. `opening` allows positive lines only. A negative line issues at average cost. Posted adjustments raise `document_posted`. `inventory.adjust` is required |
| INV-053 | `[ ]` | Vitest: a balanced sale with COGS, a service-only sale with no COGS, a partial return, a refused over-return, an unmapped method refused, an opening adjustment with no journal, and a count adjustment | INV-050, INV-051, INV-052 | Specs pass |
| INV-054 | `[ ]` | Go-live check. Enabling posting also checks that the opening journal's `1400` equals the sum of posted `opening` adjustments. The failure is added to the existing failing-checks list as `opening_stock_mismatch` | INV-052, ACC-064 | A mismatch is refused with both amounts. The go-live spec covers a match and a mismatch |

## Phase 6 — Reports

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-060 | `[ ]` | `getStockSummary` (as of a date), `getStockLedger`, `getLowStock`, and `getInventoryOverview` | INV-022 | Summary quantity and value as of today equal `item_stock`. The ledger's closing balance equals the summary. Overview numbers match the summary and the day's sales |
| INV-061 | `[ ]` | `getSalesRegister` (by item or category, returns netted, with COGS and margin) and `getPurchaseRegister` (goods lines less debit notes) | INV-041, INV-051 | Register net and tax totals equal the posted documents in the range |
| INV-062 | `[ ]` | `getValuationCheck`: stock value as of a date against the `1400` GL balance, with the difference | INV-060 | The difference is zero after the INV-071 e2e path |
| INV-063 | `[ ]` | Extend `getGstSummary`. Output taxable value adds counter sales less returns. Input taxable value comes from bills less debit notes | INV-041, INV-051, INV-016 | Output tax per component still equals that account's movement. Taxable value includes counter sales. The existing GST spec passes |
| INV-064 | `[ ]` | Vitest for reports | INV-060, INV-061, INV-062, INV-063 | Specs pass |

## Phase 7 — Contract handoff

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-070 | `[ ]` | Dump OpenAPI and regenerate `packages/api_client` | INV-003, INV-030, INV-031, INV-032, INV-040, INV-041, INV-050, INV-051, INV-052, INV-054, INV-060, INV-061, INV-062, INV-063 | `pnpm --filter api openapi:check` passes. `INVApi` exists with every operationId in `contract.md`. The `ACCTApi` item methods are gone. Unblocks INV-087 in the frontend register |
| INV-071 | `[ ]` | One e2e path in `apps/api/test/inventory.e2e.spec.ts`: an opening adjustment, a bill for a tracked item, a counter sale with split tenders, a partial sales return, a debit note, and a count adjustment that shrinks stock. Then read the trial balance and the valuation check | INV-070 | The trial balance balances. The valuation-check difference is zero. The stock summary matches the expected quantity |

## Later

These are recorded so the next plan can start from them. Do not implement them under this register.

| ID | Status | Task | Depends on | Notes |
|---|---|---|---|---|
| INV-200 | `[>]` | Warehouses or store locations, and stock transfers | INV-022 | Adds `location_id` to `item_stock` and `stock_movements` |
| INV-201 | `[>]` | Batches and expiry dates | INV-022 | Supplements expire. Needs FEFO on issue and an expiry report |
| INV-202 | `[>]` | Alternate units with a conversion factor | INV-030, INV-040 | For example, buy by the box of 12 and sell by the piece |
| INV-203 | `[>]` | Member credit sales on AR, with collection | INV-050, ACC-074 | Open AR must include counter sales |
| INV-205 | `[>]` | Printed or PDF sale receipt, and invoice round-off to `5950` | INV-050 | Same pattern as `payment_receipts` |
| INV-206 | `[>]` | Grant `inventory.read` and `inventory.sales_write` to the front-desk role, plus `payments.read` for the tender picker | INV-014 | A change in `roles.ts` once the gym decides |
| INV-207 | `[>]` | Landed costs: freight on purchase bills added to item cost | INV-040 | Spreads freight across goods lines |

## Waves

Tasks in one wave can run together. A wave starts when every task it depends on is `[x]`.

| Wave | Start together | After |
|---|---|---|
| 1 | INV-001, INV-003, INV-015, INV-016 | — |
| 2 | INV-010, INV-014 | INV-001 |
| 3 | INV-011, INV-012, INV-013 | INV-010 |
| 4 | INV-002, INV-020 | Wave 3 |
| 5 | INV-021, INV-022, INV-030, INV-031 | INV-020 |
| 6 | INV-023, INV-032, INV-060 | Wave 5 |
| 7 | INV-033, INV-040, INV-050, INV-052, INV-062 | Wave 6 |
| 8 | INV-041, INV-051, INV-054 | Wave 7 |
| 9 | INV-042, INV-053, INV-061, INV-063 | Wave 8 |
| 10 | INV-064, INV-070 | Wave 9 |
| 11 | INV-071 | INV-070 |

One person owns a shared file even when the wave lists the tasks together:

- INV-010 and INV-012 edit `schema/accounting.ts` and `0025_accounting.sql`.
- INV-011 is the only writer of `0026_inventory.sql`.
- INV-021 and INV-032 edit `acct.module.ts`.
- INV-015 and INV-040 edit `purchase-bills.service.ts`.
- INV-016 and INV-063 touch `sales-bridge.service.ts` and `reports.repository.ts`.
- INV-050 and INV-051 share the line computation in one function, `computeSaleLines`.
- INV-054 edits the go-live service.

## Counts

| Marker | Count |
|---|---|
| `[ ]` TODO | 33 |
| `[~]` DOING | 0 |
| `[x]` DONE | 0 |
| `[!]` BLOCKED | 0 |
| `[>]` LATER | 7 |
