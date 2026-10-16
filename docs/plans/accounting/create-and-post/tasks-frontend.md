# Create, edit and delete: Flutter tasks

**Plan:** [plan.md](./plan.md)
**Markers:** `[ ]` todo, `[~]` doing, `[x]` done and verified, `[!]` blocked, `[>]` later. This file is the status source.
**Paths** are under `app/lib/features/accounting/` unless stated. Counter sale code goes under `app/lib/features/inventory/`. Tests are under `app/test/features/<feature>/`.
**Gate:** every task depends on CP-B44 (client regenerated). Permission tasks also depend on the seed in CP-B35.
**Form rule:** one form screen and one form cubit per type serve create and edit. Opened with an id, the form loads the record and submits an amend with its `row_version`.
**Types in scope:** expenses, journals, purchase bills, payment vouchers, counter sales.
**Not touched:** fund transfer and debit note screens and data layers keep working as they are.

## F0 Shared pieces

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F01 | `[ ]` | Add a shared `JournalChainSection` widget listing the original, reversal and current journal entries from `journal_entries` on the DTO. Tapping an entry opens the journal detail | CP-B44 | Widget test passes |
| CP-F02 | `[ ]` | Add a shared handler for the version-conflict failure: show "Changed by someone else", reload the record, keep the user's input visible | CP-B44 | Cubit test passes |
| CP-F03 | `[ ]` | Add a shared visibility rule for Edit and Delete on a detail screen: the type's `update` or `delete` permission, status not void, the record's period open | CP-F05 | Unit test passes |
| CP-F04 | `[ ]` | Add a shared delete confirm dialog. It says "The ledger entry is reversed and the record is marked void". It takes a type-specific extra line (for example "Bill balances are restored", "Stock is put back") | CP-B44 | Widget test passes |
| CP-F05 | `[ ]` | Extend the capability helper so a check takes a type and an action (create, read, update, delete) and maps to the new slug, for the five types. Remove use of `expenses_write` and `journals_write`. Leave `purchases_write` and `payments_write` for the screens still using them | CP-B35 | Helper unit-tested for all 20 slugs |
| CP-F06 | `[ ]` | `core/router/route_capabilities.dart`: map create routes to `.create`, add edit routes mapped to `.update`, map list and detail routes to `.read`, for the five types. Counter sale routes under `/admin/inventory/sales`. Leave other routes as they are | CP-F05 | Route test passes for each type |

## F1 Expense vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F07 | `[ ]` | Datasource, repository, impl and mappers: remove `postExpense`, keep `updateExpense` with `row_version`, add `deleteExpense` | CP-B44 | Layers compile |
| CP-F08 | `[ ]` | Delete `post_expense_usecase.dart`. Add the update and delete use cases. Regenerate `injector.config.dart` | CP-F07 | No post reference remains |
| CP-F09 | `[ ]` | `expense_form_cubit.dart` and `expense_form_screen.dart`: create and edit in one form, one submit, inline server errors, keep input, go to detail on success | CP-F07, CP-F02 | Create and edit both work |
| CP-F10 | `[ ]` | `expense_detail_cubit.dart` and `expense_detail_screen.dart`: remove Post. Add Edit and Delete per CP-F03, the delete dialog, inline delete errors, the journal chain, and a void state. `expenses_list_screen.dart`: remove draft badge or filter, add a Void chip and status filter | CP-F08, CP-F01, CP-F03, CP-F04 | Posted expense shows Edit, Delete and its chain. Void shows neither |
| CP-F11 | `[ ]` | Update `expense_detail_cubit_test.dart` and `expense_detail_screen_test.dart`. Add form tests for create, edit, server error and conflict | CP-F09, CP-F10 | Tests pass |

## F2 Journal vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F12 | `[ ]` | Data layer: add `updateJournal` with `row_version` and `deleteJournal`. Remove the separate reverse call | CP-B44 | Layers compile |
| CP-F13 | `[ ]` | Journal form: serve create and edit (manual journals) | CP-F12, CP-F02 | Create and edit both work |
| CP-F14 | `[ ]` | `journal_detail_screen.dart`: show Edit and Delete on manual journals per CP-F03. For entries from other modules show a link to the owning document instead. Replace any Reverse action with Delete. Add the chain and a void state. `journals_list_screen.dart`: add a Void chip and filter | CP-F12, CP-F01, CP-F03, CP-F04 | Manual journal shows Edit and Delete. Others link out |
| CP-F15 | `[ ]` | Update journal tests: create, edit, delete, non-manual has no Edit, conflict | CP-F13, CP-F14 | Tests pass |

## F3 Purchase bills

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F16 | `[ ]` | Restore bill update in the datasource, repository, impl and mappers, with `row_version`, and add `deleteBill`. Use the code removed in `87ac714` as a starting point | CP-B44 | Layers compile |
| CP-F17 | `[ ]` | `purchase_bill_form_screen.dart` and its cubit: serve create and edit. Show downstream errors (vendor change blocked, total below settled amount, stock would go negative) inline | CP-F16, CP-F02 | Create and edit both work |
| CP-F18 | `[ ]` | `purchase_bill_detail_cubit.dart` and `purchase_bill_detail_screen.dart`: add Edit and Delete per CP-F03, the delete dialog with "Stock is put back", the chain and a void state. Always show the actions when CP-F03 allows them. The server explains blocked ones. `purchase_bills_list_screen.dart`: Void chip and filter | CP-F16, CP-F01, CP-F03, CP-F04 | Posted bill shows Edit, Delete and its chain |
| CP-F19 | `[ ]` | Update `purchase_bill_detail_cubit_test.dart` and `purchase_bill_detail_screen_test.dart`. Add form tests | CP-F17, CP-F18 | Tests pass |

## F4 Payment vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F20 | `[ ]` | Data layer: remove `postPaymentVoucher`, keep `updatePaymentVoucher` with `row_version`, add `deletePaymentVoucher`. Make allocations required in create and update | CP-B44 | Layers compile |
| CP-F21 | `[ ]` | Delete `post_payment_voucher_usecase.dart`. Add the update and delete use cases. Regenerate `injector.config.dart` | CP-F20 | No post reference remains |
| CP-F22 | `[ ]` | `payment_voucher_form_cubit.dart` and `payment_voucher_form_screen.dart`: collect allocations in the form (pick vendor, list open posted bills, enter an amount per bill). Submit stays disabled until there is at least one allocation and the total matches the voucher amount | CP-F20 | Cannot submit without allocations |
| CP-F23 | `[ ]` | Edit mode: preload the allocations. Show each bill's open balance with this voucher's allocation counted as released | CP-F22 | Editing an allocation does not show a false over-allocation |
| CP-F24 | `[ ]` | Show server errors inline for over-allocation, unposted bill and version conflict. Keep the input | CP-F22, CP-F02 | Error tests pass |
| CP-F25 | `[ ]` | `payment_voucher_detail_cubit.dart` and `payment_voucher_detail_screen.dart`: remove Post and draft allocation editing. Add Edit and Delete per CP-F03, the dialog with "Bill balances are restored", the chain and a void state. `payment_vouchers_list_screen.dart`: no draft state, Void chip and filter | CP-F21, CP-F01, CP-F03, CP-F04 | Posted voucher shows Edit, Delete and its chain |
| CP-F26 | `[ ]` | Update `payment_voucher_detail_cubit_test.dart` and `payment_voucher_detail_screen_test.dart`. Add form tests for allocation validation, create, edit, server error | CP-F22 to CP-F25 | Tests pass |

## F5 Counter sales (new feature)

No counter sale screens exist yet. This replaces INV-082 in the inventory plan. Check whether INV-080 (the inventory data layer) is done and reuse it. If it is not done, build only the counter sale parts here.

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F27 | `[ ]` | Create `features/inventory` with the counter sale data layer: entities, mappers, datasource, repository, use cases for list, get, create, update and delete. Create sends one `Idempotency-Key` per attempt, reused on retry | CP-B44 | Layers compile and have tests |
| CP-F28 | `[ ]` | Add a pure `sale_totals.dart` helper that computes line, discount, tax and total with the contract's arithmetic, and a unit test against the server's rounding | CP-F27 | Helper tests pass |
| CP-F29 | `[ ]` | Counter sale form screen and cubit at `/admin/inventory/sales/new`: item search by name or SKU, quantity respecting `uom_decimal_places`, line discount, optional member or customer name, split tenders. Submit stays disabled until tenders equal the computed total | CP-F28, CP-F02 | Create works. A stock warning shows on a line above `stock.qty_on_hand` |
| CP-F30 | `[ ]` | Edit mode on the same form: load the sale, preload lines and tenders, submit an amend with `row_version`. Show `tender_total_mismatch` with the server's expected amount, and the "sale has a return" error | CP-F29 | Edit works |
| CP-F31 | `[ ]` | Counter sale list screen: sale number, date, customer, total, status. Search, date filter, Void chip and status filter | CP-F27 | List renders and filters |
| CP-F32 | `[ ]` | Counter sale detail screen: lines, tenders, totals, COGS, journal chain. Edit and Delete per CP-F03, the dialog with "Stock is put back", inline delete errors, a void state | CP-F27, CP-F01, CP-F03, CP-F04 | Detail shows actions by permission and state |
| CP-F33 | `[ ]` | Routes and home: register the inventory sale routes, add the inventory home entry, and gate each by `inventory.counter_sales.*` via CP-F05 and CP-F06 | CP-F29, CP-F31, CP-F32 | Navigation works. Entry hidden without `.read` |
| CP-F34 | `[ ]` | Tests: cubit tests for create, edit, delete, tender mismatch, return-blocked, conflict. Widget tests for form, list and detail | CP-F29 to CP-F33 | Tests pass |

## F6 Permissions and cross-cutting

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F35 | `[ ]` | Gate controls by permission on the five types: Create button needs `.create`, a list needs `.read`, Edit needs `.update`, Delete needs `.delete`. Update `purchase_bills_list_screen.dart`, `purchase_bill_form_screen.dart` and the other lists and forms that reference the removed slugs | CP-F05, CP-F06 | A read-only user sees no create, edit or delete controls |
| CP-F36 | `[ ]` | Accounting home screen: tiles for the four accounting types show only with their `.read` permission. Fund transfer and debit note tiles are unchanged | CP-F05 | Tile test passes |
| CP-F37 | `[ ]` | Gating tests: for each of the five types, a user with only `.read`, one with `.read` and `.update`, and one with all four sees the right controls | CP-F35 | Tests pass |
| CP-F38 | `[ ]` | Remove unused strings and dead routes for Post and Reverse. Add strings for Edit, Delete, Void, "Changed by someone else" and the journal chain labels | CP-F10, CP-F14, CP-F25 | `flutter analyze` shows no unused symbols from this change |
| CP-F39 | `[ ]` | Run `dart run build_runner build` for freezed and injectable output. Do not hand-edit `*.freezed.dart` | CP-F38, CP-F34 | Generated files match the source |
| CP-F40 | `[ ]` | Regression: run the existing fund transfer tests and the other accounting tests unchanged | CP-F39 | They pass without edits |
| CP-F41 | `[ ]` | Run `flutter analyze` and `flutter test` for accounting and inventory | CP-F11, CP-F15, CP-F19, CP-F26, CP-F34, CP-F37, CP-F40 | Both pass |
| CP-F42 | `[ ]` | Manual run against the local API. Check the Firestore API URL first so the build does not hit production. Create, edit and delete one record of each of the five types, confirm the detail, journal chain and trial balance at each step, then sign in as a read-only user and confirm the controls are hidden | CP-F41 | One note per type |

## F7 Deferred: fund transfers and debit notes

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-F43 | `[>]` | Fund transfers: same form, detail, list and test changes as expenses. Switch to their own four permissions | CP-B50, CP-F41 | Same checks as expenses |
| CP-F44 | `[>]` | Debit notes: data layer changes only. No screens | CP-B51, CP-F41 | Layers compile |
