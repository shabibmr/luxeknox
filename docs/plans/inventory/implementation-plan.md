# Inventory module implementation plan

**Status:** Draft.
**Registers:** [tasks-backend.md](./tasks-backend.md) and [tasks-frontend.md](./tasks-frontend.md) are the status sources. Update markers there as work moves.
**Contract:** [contract.md](./contract.md) lists every endpoint, schema, and error rule shared by the API and the Flutter feature. Where this plan and the contract differ, the contract wins.
**Worktree:** a new worktree on `feat/inventory`, cut from `feat/accounting`. Rebase it when accounting merges.
**Date:** 2026-10-13.
**Pulls in:** ACC-203 from [the accounting register](../accounting/tasks-register.md).

## Goal

Add a basic perpetual inventory for one gym store. The store sells supplements, merchandise, water, and accessories at the counter. The module covers:

- Masters: items and services, categories, and units of measure.
- Documents: purchases, sales, purchase returns, sales returns, and stock adjustments for opening stock and counts.
- Reports.

Every stock document posts to the general ledger through the existing `AccountingPostingService`.

## Does this wait for accounting?

No. The backend pieces inventory needs are done:

| Need | Accounting tasks |
|---|---|
| Journal engine | ACC-021 to ACC-026 |
| Items, vendors, tax codes, periods | ACC-030 to ACC-034 |
| Bills, debit notes, payment vouchers | ACC-040 to ACC-043 |
| Payment-method accounts | ACC-011 |
| Reports | ACC-070 to ACC-075 |
| Contract | ACC-080 |

What remains in accounting is ACC-003 (docs) and the Flutter screens ACC-092 to ACC-100. Two places need coordination:

1. **ACC-095**, the Flutter screens for purchase bills and debit notes. Inventory changes bill lines and gives debit notes lines. Start ACC-095 after INV-070, so the forms are written once against the final contract. The other ACC-09x tasks do not touch inventory.
2. **Go-live.** INV-054 adds one more go-live check: the opening journal's `1400` must equal the opening stock value. ACC-099 lists failing checks generically and needs no change.

## Decisions locked by this plan

1. **Perpetual inventory, moving weighted-average cost.** Every stock movement updates the item's quantity, value, and average cost in the same transaction as the document. This is the transaction that also posts the journal.
2. **Single location.** No warehouses, batches, expiry dates, or serial numbers. They are listed as later work.
3. **No negative stock.** A sale, purchase return, or negative adjustment larger than the quantity on hand is refused.
4. **Value is zero when quantity is zero.** When on-hand reaches zero, any leftover value is posted to `5960 Inventory adjustments`, inside the same journal. Leftover value comes from rounding, or from a return at a cost that differs from the average.
5. **One items table.** The accounting `items` table is extended rather than duplicated.
   - `service` items are never tracked. `goods` items may be tracked.
   - `inventory_tracked` and `uom_id` cannot change once the item has a stock movement.
6. **One stock UOM per item.** UOM is a master with `decimal_places` between 0 and 3. A quantity with more decimals than its UOM allows is rejected.
7. **Inventory documents always post.** This matches purchase bills. `accounting.posting_enabled` stays the gate for the member-sales bridge only.
8. **Counter sales use a new document.**
   - The member is optional. A sale can be fully paid with one or more tenders.
   - `payments` and `PaymentService` are not touched.
   - Every tender's payment method must have `account_id`. A sale with a method that lacks one is refused.
9. **Purchases and purchase returns reuse accounting documents.**
   - Purchases use `purchase_bills`.
   - Purchase returns use `debit_notes`, which gain lines.
   - AP, payment vouchers, and open-items reports keep working unchanged.
10. **Tax is per line.** Each line carries a tax code, defaulting to the item's.
    - Tax journal lines use the component `output_account_id` or `input_account_id`.
    - The component-split helper in `sales-bridge.service.ts` is extracted so it takes a tax code. The bridge keeps passing `accounting.default_tax_code`.
    - Line tax is rounded on the code's total rate. Components split it, with the last component taking the remainder.
    - There is no quote endpoint. Clients reproduce the totals with the same rule (see the contract's line and total arithmetic), and the server recomputes on create.
11. **Quantities and costs.**
    - Quantities are `decimal(14,3)`, rates and money `decimal(12,2)`, and `unit_cost` `decimal(14,4)`.
    - Money arithmetic stays in `apps/api/src/platform/money/money.ts`. A new `mulQtyRate(qty, rate)` uses integer maths and rounds half-up. Purchase bills switch to it from `Number(qty) * Number(rate)`.
12. **One-way module dependency.** `InvModule` imports `AcctModule`.
    - `AcctModule` exports an `InventoryHooks` registry. `InvModule` registers its handler in `onModuleInit`, the way `JobRunnerService.register` works.
    - Accounting calls `onPurchaseBillPosting` and `onDebitNotePosting` inside the posting transaction.
    - `AcctModule` never imports `InvModule`.
13. **Optimistic concurrency.** New inventory headers compare the client's `row_version` and return 409 on a mismatch.
14. **Opening stock posts no journal.** The go-live opening journal carries `1400`. Enabling posting checks that `1400` equals the sum of posted `opening` adjustments.

## What already exists

Use these. Do not replace them.

| Piece | Where |
|---|---|
| Items | `items` in `apps/api/src/platform/db/schema/accounting.ts`. CRUD in `apps/api/src/acct/items.*` |
| Purchase bills with item lines | `apps/api/src/acct/purchase-bills.*` |
| Debit notes, amount only | `apps/api/src/acct/debit-notes.*` |
| Posting engine | `AccountingPostingService.postJournal` in `apps/api/src/acct/accounting-posting.service.ts` |
| Tax component split | `buildTaxComponentLines` in `apps/api/src/acct/sales-bridge.service.ts` |
| Payment methods with ledger accounts | `payment_methods.account_id` in `schema/payments.ts` |
| Number counters | Single-row `*_number_counters`, allocated with `SELECT … FOR UPDATE` (see `allocateBillNumber`) |
| Idempotency | `@UseIdempotency()` in `apps/api/src/platform/idempotency/` |
| Permission guard | `@RequirePermission` in `apps/api/src/rbac/require-permission.decorator.ts` |
| Go-live checks | `apps/api/src/acct/go-live.*` |
| GST summary | `getGstSummary` in `apps/api/src/acct/reports.repository.ts` |
| Flutter patterns | `app/lib/features/foods/` for a CRUD slice. `app/lib/core/widgets/` for shared states and pickers |

## Out of scope

- Warehouses and stock transfers.
- Batches, expiry dates, and serial numbers.
- Alternate units with conversion factors.
- Member credit sales on AR. A counter sale is paid at the time of sale.
- Barcode scanning, receipt printing, and round-off.
- Landed costs.
- Changing POS or `payments`.

## Data model

### Item master

Edit `schema/accounting.ts` and `drizzle/0025_accounting.sql` in place, then reset the local database.

| Table | Change |
|---|---|
| `uoms` | New. `code` unique, `name`, `decimal_places` 0 to 3, `is_active`, timestamps |
| `item_categories` | New. `name` unique, `parent_id` nullable (one level), `is_active`, timestamps |
| `items` | Add `sku` (unique, nullable), `hsn_sac`, `category_id`, `uom_id` (not null), `sale_rate`, `purchase_rate`, `reorder_level` `decimal(14,3)`, `inventory_account_id`, `cogs_account_id`, `row_version`, timestamps |
| `purchase_bill_lines` | `quantity` becomes `decimal(14,3)` |
| `debit_note_lines` | New. `debit_note_id`, `purchase_bill_line_id`, `quantity`, `net_amount`, `tax_amount`. Header totals equal the sum of lines |

`ACCOUNT_CONTROL_ROLES` gains `inventory`. `JOURNAL_SOURCE_TYPES` gains `counter_sale`, `counter_sale_return`, and `stock_adjustment`. The column is `varchar`, so this is a TypeScript change only.

### Stock ledger and documents

New file `schema/inventory.ts`, exported from `schema/index.ts`. New migration `drizzle/0026_inventory.sql`.

| Table | Role |
|---|---|
| `item_stock` | One row per tracked item: `qty_on_hand`, `stock_value`, `avg_cost`, `row_version`. Locked with `SELECT … FOR UPDATE` before every movement |
| `stock_movements` | Append-only. `item_id`, `movement_date`, `source_type`, `source_id`, `source_line_id`, `qty_in`, `qty_out`, `unit_cost`, `value`, `balance_qty`, `balance_value` |
| `counter_sales` | `sale_number`, `sale_date`, `member_id` nullable, `customer_name` nullable, `subtotal`, `discount_amount`, `tax_amount`, `total_amount`, `cogs_amount`, `status` (`posted`), `journal_entry_id`, `row_version`, timestamps |
| `counter_sale_lines` | `item_id`, `quantity`, `rate`, `discount_amount`, `tax_code_id`, `net_amount`, `tax_amount`, `unit_cost` frozen at sale, `cost_amount` |
| `counter_sale_tenders` | `payment_method_id`, `amount`, `reference`. Tenders sum to the sale total |
| `sales_returns` | `return_number`, `counter_sale_id`, `return_date`, `reason`, totals, `cogs_amount`, `status`, `journal_entry_id`, `row_version` |
| `sales_return_lines` | `counter_sale_line_id`, `quantity`, `net_amount`, `tax_amount`, `cost_amount` |
| `sales_return_tenders` | Refund tenders, same shape as sale tenders |
| `stock_adjustments` | `adjustment_number`, `adjustment_date`, `reason` (`opening`, `count`, `damage`, `expiry`, `other`), `status` (`draft`, `posted`), `journal_entry_id`, `row_version` |
| `stock_adjustment_lines` | `item_id`, `qty_delta` (signed), `unit_cost` (required when positive), `value` |
| Counters | `counter_sale_`, `sales_return_`, `stock_adjustment_number_counters`. Prefixes `SAL`, `SRN`, `ADJ` |

### Seed

| Code | Name | Type |
|---|---|---|
| 1400 | Inventory | asset, control `inventory` |
| 4250 | Merchandise sales | income |
| 5050 | Cost of goods sold | expense |
| 5960 | Inventory adjustments | expense |

Seeded UOMs: `PCS` (0), `BOX` (0), `PKT` (0), `BTL` (0), `KG` (3), `G` (0), `LTR` (3), `ML` (0).

Re-running the seed must not duplicate codes.

## Posting rules

Every post runs in the same transaction as the document and its stock movements. A locked period, an unbalanced journal, or a refused stock movement rolls everything back.

### Purchase bill, tracked line

- **Stock in.** Quantity at `net_amount / quantity`. The movement value is exactly the line's `net_amount`.
- **Journal.** The server sets the line's debit account to `item.inventory_account_id` and ignores the client's value. Input tax and AP are unchanged.

### Debit note (purchase return)

- **Lines.** Each line references a bill line.
- **Quantity cap.** Quantity is capped by the billed quantity less earlier debit notes, and, for tracked items, by the quantity on hand.
- **Stock out.** At the bill line's unit cost. Decision 4 applies when on-hand reaches zero.
- **Journal.** Debit AP. Credit input tax. Credit each line's account; for tracked items that is Inventory.

### Counter sale

`source_type = counter_sale`. It is created and posted in one call.

| Line | Account |
|---|---|
| Debit, per tender | That tender's `payment_methods.account_id` |
| Credit, per line, net after discount | `item.income_account_id`, default `4250` |
| Credit, per line, tax | The line tax code's component output accounts |
| Debit, cost of tracked lines | `item.cogs_account_id`, default `5050` |
| Credit, cost of tracked lines | `item.inventory_account_id`, default `1400` |

- **Stock out** for tracked lines at the current average cost. `unit_cost` and `cost_amount` are frozen on the line.
- **Service lines** post income and tax only.

### Sales return

`source_type = counter_sale_return`. It is created and posted in one call, against one posted counter sale.

- Quantity per line is at most sold less already returned.
- The journal mirrors the sale for the returned share: debit income and output tax, credit the refund tender accounts.
- Debit Inventory and credit COGS at the sale line's frozen `unit_cost`.
- Stock comes back in at that same cost.

### Stock adjustment

`source_type = stock_adjustment`. It is a draft until posted.

- **`opening`.** Stock in, no journal. The go-live check matches `1400` (decision 14).
- **Other reasons.** Positive lines debit Inventory and credit `5960`. Negative lines go out at average cost: debit `5960`, credit Inventory.

## API

New Nest module `apps/api/src/inv/`, imported from `app.module.ts`. It has the same shape as `acct`: controllers, zod DTOs, repositories (the only SQL), and services that call `runInTransaction`. Controllers carry `@ApiTags('INV')`. Document `POST`s use `@UseIdempotency()`. Lists use the existing pagination DTO.

Permissions, module `INV`, granted to `super_admin` and `admin` only:

| Slug | Use |
|---|---|
| `inventory.read` | Masters, documents, reports |
| `inventory.masters_write` | Items, categories, UOMs |
| `inventory.sales_write` | Counter sales and sales returns |
| `inventory.adjust` | Stock adjustments |

Purchases and debit notes keep `accounting.purchases_write`.

Routes, all under `/inventory`:

- `GET/POST /uoms`, `PATCH /uoms/:id`
- `GET/POST /categories`, `PATCH /categories/:id`
- `GET/POST /items`, `GET/PATCH /items/:id`
  - Item CRUD moves here from `/accounting/items`, and the accounting routes are deleted.
  - `AcctModule` keeps a read-only item lookup for bill lines.
- `GET /overview`
- `GET/POST /sales`, `GET /sales/:id`
- `GET/POST /sales-returns`, `GET /sales-returns/:id`
- `GET/POST /adjustments`, `GET/PATCH /adjustments/:id`, `POST /adjustments/:id/post`
- `GET /reports/stock-summary?as_of&category_id`
- `GET /reports/stock-ledger?item_id&from&to`
- `GET /reports/low-stock`
- `GET /reports/sales-register?from&to&group_by=item|category`
- `GET /reports/purchase-register?from&to`
- `GET /reports/valuation-check?as_of`

Reports:

- **Stock summary.** Quantity, average cost, and value per tracked item as of a date, from `stock_movements`.
- **Stock ledger.** One item's movements in a range, with running balance quantity and value.
- **Low stock.** Tracked active items with quantity on hand at or below `reorder_level`.
- **Sales register.** Counter sales less returns for the range: quantity, net, tax, COGS, and margin, grouped by item or category.
- **Purchase register.** Goods lines on posted bills less posted debit-note lines.
- **Valuation check.** Stock value against the GL balance of `1400` as of a date, with the difference. The difference is zero when the books are right.

Accounting changes made by this plan:

- `purchase-bills.service.ts`: force the inventory account on tracked lines, use `mulQtyRate`, and call the hook.
- `debit-notes.*`: lines and the hook.
- `reports.repository.ts` `getGstSummary`:
  - Output taxable value includes counter sales less sales returns.
  - Input taxable value comes from bills less debit notes.
- `go-live.*`: the `1400` check.

After the controllers exist, run `pnpm --filter api openapi:dump` and regenerate `packages/api_client`. `openapi:check` must pass.

## Flutter

New feature `app/lib/features/inventory/` with `data`, `domain`, and `presentation`, matching `features/foods`:

- The generated `INVApi`, registered in `app/lib/core/di/register_module.dart`.
- `@LazySingleton` datasource and repository. Use cases return `Either<Failure, T>`.
- `@injectable` cubits with freezed state.
- Shared widgets: `AppLoading`, `AppEmptyView`, `AppErrorView`, `AppPickerFormField`, `AppCurrencyField`, `UnsavedChangesScope`.

Entry point:

- Put an Inventory tile on the More hub (`app/lib/core/widgets/more_hub_screen.dart`), shown only with `context.can('inventory.read')`. This leaves the hard-coded shell branch index in `admin_routes.dart` alone.
- Add the route constants to `app/lib/core/router/routes.dart`.
- Add `('/admin/inventory', 'inventory.read')` to `route_capabilities.dart`.

Screens:

- Inventory home: stock value, low-stock count, today's sales.
- UOM, category, and item list and form.
- Counter sale: item search by name or SKU, quantity, line discount, and split tenders. The server returns the final totals.
- Sale detail with a Return action, and the sales return form.
- Stock adjustment form, draft then post.
- Stock summary, stock ledger, low stock, sales register, purchase register, and valuation check.

Strings live in `inventory_strings.dart`. Tests go in `app/test/features/inventory/`.

## File map

**New**

- `docs/adr/0011-inventory.md`
- `apps/api/src/platform/db/schema/inventory.ts`
- `apps/api/drizzle/0026_inventory.sql`
- `apps/api/src/platform/db/seed/inventory.ts`
- `apps/api/src/inv/`: the module, `StockLedgerService`, master and document services, reports, controllers, DTOs, repositories, and specs.
- `apps/api/src/acct/inventory-hooks.ts`
- `apps/api/src/acct/tax-lines.ts`: the extracted component split.
- `apps/api/test/inventory.e2e.spec.ts`
- `app/lib/features/inventory/` and `app/test/features/inventory/`

**Modify**

- `apps/api/src/platform/db/schema/accounting.ts`, `schema/index.ts`, `drizzle/0025_accounting.sql`
- `apps/api/src/platform/db/seed/index.ts`, `accounting.ts`, `permissions.ts`, `roles.ts`
- `apps/api/src/platform/money/money.ts`
- `apps/api/src/acct/`: `acct.module.ts`, `purchase-bills.*`, `debit-notes.*`, `sales-bridge.service.ts`, `reports.repository.ts`, `go-live.*`. Delete `items.controller.ts`.
- `apps/api/src/app.module.ts`
- `docs/openapi/v1.yaml` and `packages/api_client/`, via the generators
- `docs/Entities-List.md`, `docs/database-entities.md`, `docs/adr/README.md`
- `app/lib/core/di/register_module.dart`, `app/lib/core/router/routes.dart`, `route_capabilities.dart`, `admin_routes.dart`, and the More hub

## Verification

Backend, from the repo root, against MySQL 8.4 on `localhost:3308` (not Docker):

- Reset, migrate from empty with the repo's migrate script, and seed. Run the seed a second time and confirm nothing duplicates.
- `pnpm --filter api exec vitest run src/inv src/acct src/platform/money`
- `pnpm --filter api exec vitest run src/pay/payment.service.spec.ts`. The member-sales bridge must be unchanged.
- `pnpm --filter api openapi:check`
- `test/inventory.e2e.spec.ts`. The trial balance must balance and the valuation-check difference must be zero.

Flutter:

- `dart analyze app/lib/features/inventory`
- The new widget tests

Manual check:

1. Create a tracked item and post a bill for 10 units.
2. Sell 3 for cash.
3. Stock summary shows 7.
4. The sale's journal shows COGS.
5. The valuation check shows a zero difference.

## Risks

- **GST summary sources.** The summary must sum both `payments` invoices and counter sales. INV-063 covers this.
- **GST summary bug, separate from this plan.** The summary repeats the full totals under every CGST and SGST code. Log it as a separate accounting bug.
- **Sales before go-live.** Because inventory documents always post, sales recorded before accounting go-live land in the ledger. Record pre-go-live stock as `opening` adjustments, and start counter sales after go-live.
- **Moving item CRUD** removes the generated `ACCTApi` item methods. No Flutter use case calls them yet.
- **Average-cost drift.** Costs are stored at `decimal(14,4)`, but movement values round to cents. Decision 4 clears the drift whenever stock reaches zero, and the valuation check shows any gap.
