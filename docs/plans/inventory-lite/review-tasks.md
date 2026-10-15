# Inventory Lite — IL-13 review tasks

**Source:** `/code-review` of `be3a9df` against `53979f5` (inventory-lite through IL-13). Counter sales in `4b3deaa` and the uncommitted working tree were out of scope.
**Plan:** [plan.md](./plan.md). **Register:** [tasks.md](./tasks.md).
**Updated:** 2026-10-16.
**Markers:** `[ ]` todo, `[~]` doing, `[x]` done, `[!]` blocked, `[>]` later.
**Order:** highest impact first. Do them in this order.

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-R1 | `[ ]` | Land the IL-01 schema on databases that already applied `0025`. `migrate.ts` will not re-run `0025_accounting.sql`, and `0027_inventory.sql` does not add `uoms`, `item_categories`, the new `items` columns, `debit_note_lines`, or `purchase_bill_lines.quantity DECIMAL(14,3)`. Add a new migration that applies those changes and is safe when the edited `0025` already created them. In that migration, add `uom_id` so the PCS backfill can match rows, then set it `NOT NULL`. The current seed update `WHERE uom_id IS NULL` matches nothing. | — | A database that already has `0025` recorded ends with the new columns, every item has `uom_id`, and a second seed changes nothing |
| IL-R2 | `[ ]` | Refresh the Drizzle journal through `0027`. `apps/api/drizzle/meta/_journal.json` still ends at `0017_password_reset_tokens`, so the IL-02 drift check cannot pass. The journal was already behind `0020`–`0026`. | IL-R1 | `check-schema-drift` reports no changes |
| IL-R3 | `[ ]` | Write `items.updated_at` on create and update. The patch in `apps/api/src/acct/items.service.ts` only bumps `row_version`, so reads keep `updated_at` null after edits. | — | Create and update both store `updated_at`, and the item specs assert it |
| IL-R4 | `[ ]` | Update the OpenAPI contract. `docs/openapi/v1.yaml` has no `GET /inventory/items` or `GET /inventory/items/:id`, and `Item`, `ItemCreate`, and `ItemUpdate` omit `sku`, `uom_id`, rates, inventory accounts, and `row_version` while create now requires `uom_id`. | — | `openapi:dump` and `openapi:check` pass, and the generated client includes the new fields and both read routes |
| IL-R5 | `[ ]` | Accept item money only as a decimal string. `moneySchema` in `apps/api/src/acct/items.dto.ts` allows a JSON number and `roundMoney` goes through `Number`. | — | `sale_rate` and `purchase_rate` reject JSON numbers, and the specs cover a 3-decimal quantity and a `.005` rate |
| IL-R6 | `[ ]` | Honor `cursor` on `GET /inventory/items`. A cursor is parsed, then the service uses `pagination.offset ?? 0` and returns the first page. | — | A cursor returns the following page, and an unknown cursor is refused |
| IL-R7 | `[ ]` | Read `has_movements` from `stock_movements`. `inv/items.service.ts` always returns `false`. That matches today only because nothing writes movements yet. Do this before IL-30. | — | The flag is true once a movement exists, and false when none does |
| IL-R8 | `[ ]` | Constrain `items.item_kind` in the database. It is a `VARCHAR(16)` with an index and no `CHECK`, while `status`, `source_type`, and `reason` in this slice use `CHECK`. | IL-R1 | A value outside the allowed kinds fails the insert |
| IL-R9 | `[ ]` | Return a business-rule error for a duplicate SKU. `items_sku_unique` already blocks the duplicate. `validateSku` is a check-then-insert, so a concurrent create surfaces a raw duplicate-key error. | — | That race returns the same error as the pre-check |
| IL-R10 | `[ ]` | Share the item mapping and the decimal scaling. `roundQty3` repeats the private `toScaled` shape in `money.ts`, and `ItemsService.toDto` and `InventoryItemsService.toDto` map the same columns apart. | — | One scaler and one item mapper serve both call sites |
| IL-R11 | `[ ]` | Remove the unused tax-line inputs. `accountKind: 'input'` and `vendorId` on `buildTaxComponentLines` have no caller in this slice. Leave this until IL-32 if that task is the caller that posts input tax. Until then this is cleanup only. | — | Those parameters are gone, or IL-32 is the caller that posts input tax |
