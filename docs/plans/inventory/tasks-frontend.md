# Inventory module — frontend task register

**Plan:** [implementation-plan.md](./implementation-plan.md)
**Contract:** [contract.md](./contract.md). Code the domain layer against it. Change the contract before the code.
**Backend tasks:** [tasks-backend.md](./tasks-backend.md)
**Updated:** 2026-10-13
**Scope:** `app/` only. The generated `packages/api_client` comes from backend INV-070.
**Rule:** This file is the status source for frontend tasks. Change the marker here when a task moves. Do not duplicate status into the plan.
**Depends on:** lists direct predecessors only. Start a task when every ID in that cell is `[x]`. Backend IDs are in `tasks-backend.md`. `ACC-` IDs are in [the accounting register](../accounting/tasks-register.md).

## Status markers

| Marker | Meaning |
|---|---|
| `[ ]` | TODO. Not started. |
| `[~]` | DOING. In progress. |
| `[x]` | DONE. Verified. |
| `[!]` | BLOCKED. The blocker is written on the task. |
| `[>]` | LATER. Named so it is not forgotten. Not part of this delivery. |

## How this runs alongside the backend

- **Screens first, against the contract.** Screens and cubits are built against the domain repository interface from `contract.md` once it is frozen (INV-003). Cubit and widget tests use a fake repository.
- **Data layer when the client lands.** The data layer (INV-087) waits for the generated `INVApi` from INV-070.
- **No hand-written HTTP.** The generated client is the only HTTP path, matching `features/accounting`.
- **Patterns.** Follow `app/lib/features/foods/` for the slice and `features/accounting` for `CursorPage` lists and `Either<Failure, T>` use cases.
- **Shared widgets.** `AppLoading`, `AppEmptyView`, `AppErrorView`, `AppPickerFormField`, `AppPickerSheet`, `AppCurrencyField`, `DecimalTextInput`, `UnsavedChangesScope`, `AppStatusChip`.
- **Errors.** Map `422 business_rule` details by `rule` to field or banner messages in one place, `inventory_failure_mapper.dart`.

## Phase 8 — Flutter admin

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| INV-080 | `[ ]` | Feature skeleton `app/lib/features/inventory/` with domain entities, value objects, and the `InventoryRepository` interface for every contract operation. Add `inventory_strings.dart` and the failure mapper. Add route constants in `core/router/routes.dart`, `('/admin/inventory', 'inventory.read')` in `route_capabilities.dart`, an Inventory tile on the More hub, and the routes in `admin_routes.dart` | INV-003 | Entities mirror the contract schemas, with money and quantity as strings. The tile and routes are hidden without `inventory.read`. The shell branch index is unchanged. `route_capabilities_test.dart` covers the new prefix |
| INV-081 | `[ ]` | UOM list and form, category list and form, and item list, form, and detail. Item pickers for accounts and tax codes use the existing accounting endpoints | INV-080 | Inactive rows stay visible and cannot be picked. Turning on tracking shows inventory and COGS account pickers, defaulting to `1400` and `5050`. `inventory_tracked` and UOM are read-only when `has_movements`. Write actions are hidden without `inventory.masters_write` |
| INV-082 | `[ ]` | Inventory home, which reads `getInventoryOverview`. Counter sale screen: item search by name or SKU, quantity respecting `uom_decimal_places`, line discount, and an optional member or customer name. The screen computes totals locally with the contract's arithmetic, in a pure `sale_totals.dart` helper, then collects split tenders. Add the sale list and sale detail | INV-080 | Submit is disabled until the tenders equal the computed `total_amount`. One `Idempotency-Key` per sale attempt is reused on retry. Detail shows the journal number and returns. A stock warning shows on any line whose quantity exceeds `stock.qty_on_hand`. A `tender_total_mismatch` response shows the server's `expected` amount |
| INV-083 | `[ ]` | Sales return from sale detail. Pick lines and quantities, compute the refund with the contract's pro-rata rule in `sale_totals.dart`, then collect refund tenders | INV-082 | Quantity per line is capped at sold less `returned_quantity`. Refund tenders must equal the computed total. Hidden without `inventory.sales_write` |
| INV-084 | `[ ]` | Stock adjustment list, form (draft), and post | INV-080 | A positive line requires a unit cost. `opening` blocks negative lines. Posted adjustments are read-only. Write and post are hidden without `inventory.adjust` |
| INV-085 | `[ ]` | Report screens: stock summary, stock ledger (item and date range), low stock, sales register (group by item or category), purchase register, and valuation check | INV-080 | Totals on screen match the response totals. The valuation check highlights a non-zero difference. Loading, empty, and error states use the shared widgets |
| INV-087 | `[ ]` | Data layer: `InventoryRemoteDataSource` on the generated `INVApi` (registered in `core/di/register_module.dart`), mappers, and `InventoryRepositoryImpl`. Regenerate `injector.config.dart` | INV-070, INV-080 | Every repository method calls the generated client. `422` details map through the failure mapper. Datasource and repository tests in `app/test/features/inventory/data/` pass |
| INV-086 | `[ ]` | Widget tests: the sale form tender check, item-form tracked validation, the sales return cap, the adjustment form (positive line needs a cost), and low stock. Unit tests for `sale_totals.dart`: half-up at `.005`, a line discount, a 3-decimal quantity, and a pro-rata return remainder | INV-081, INV-082, INV-083, INV-084 | Tests pass with a fake repository. `dart analyze app/lib/features/inventory` is clean |
| INV-088 | `[ ]` | Integration pass against the local API (`localhost:3308` database). Create an item, post a bill for 10 (via accounting), sell 3 with split tenders, return 1, adjust −1, then check the stock summary (7), the ledger, and the valuation check (zero difference) | INV-087, INV-071, INV-081, INV-082, INV-083, INV-084, INV-085 | Every screen works on real data. Every `business_rule` error seen in the pass shows a readable message |

## Later

| ID | Status | Task | Depends on | Notes |
|---|---|---|---|---|
| INV-204 | `[>]` | Barcode scanning on the sale and item screens | INV-082 | `sku` is the barcode. Needs a camera package decision |

## Coordination with the accounting register

- **ACC-095** (Flutter purchase bills and debit notes) should start after INV-070. The bill form uses the inventory item picker from INV-081 with UOM decimals. The debit-note form takes lines as `contract.md` specifies. Line `account_id` is hidden for tracked items.
- **ACC-099** (go-live setup) needs no change. `opening_stock_mismatch` arrives in the existing failing-checks list.
- **Item entity.** `features/accounting/domain/entities/item.dart` is superseded by the inventory `Item`. Remove it, or re-export the inventory entity, in INV-087.

## Waves

| Wave | Start together | After |
|---|---|---|
| F1 | INV-080 | INV-003 |
| F2 | INV-081, INV-082, INV-084, INV-085 | INV-080 |
| F3 | INV-083, INV-087 | INV-082; INV-087 also needs INV-070 |
| F4 | INV-086 | INV-081, INV-082, INV-083, INV-084 |
| F5 | INV-088 | INV-087, INV-071, and the screens |

One person owns a shared file even when the wave lists the tasks together:

- INV-080 is the only writer of `routes.dart`, `route_capabilities.dart`, `admin_routes.dart`, and the More hub.
- INV-087 is the only writer of `register_module.dart` for this feature.

## Counts

| Marker | Count |
|---|---|
| `[ ]` TODO | 9 |
| `[~]` DOING | 0 |
| `[x]` DONE | 0 |
| `[!]` BLOCKED | 0 |
| `[>]` LATER | 1 |
