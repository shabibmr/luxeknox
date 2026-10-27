# Task Register: Accounting Masters Quality & Hardening

**Plan:** [`masters-quality-plan.md`](./masters-quality-plan.md)  
**Spec:** [`masters-quality-spec.md`](./masters-quality-spec.md)  
**Legend:** `[ ]` todo, `[~]` in progress, `[x]` done  

---

## Slice A: Accounts Data & Logic

- [x] **Task MQ-01: Add `parentId` to `Account` and fix search clear in `AccountsCubit`**
  - **Acceptance:**
    - `Account` domain entity declares `final String? parentId;` and updates `props`.
    - `accounting_mappers.dart` maps `api.Account.parentId` to `Account.parentId`.
    - `AccountsCubit.load` supports `clearSearch: bool`, resetting search to `null`.
    - `AccountsCubit.setSearch` debounces input (~300ms) and uses `_loadEpoch` to ignore stale out-of-order responses.
  - **Verify:** `flutter test test/features/accounting/presentation/accounts_cubit_test.dart` passes.
  - **Files:**
    - `app/lib/features/accounting/domain/entities/account.dart`
    - `app/lib/features/accounting/data/models/accounting_mappers.dart`
    - `app/lib/features/accounting/presentation/cubit/accounts_cubit.dart`
    - `app/test/features/accounting/presentation/accounts_cubit_test.dart`

---

## Slice B: Accounts UI Hardening

- [x] **Task MQ-02: Fix search reset and gesture handling in Accounts UI**
  - **Acceptance:**
    - In `chart_of_accounts_screen.dart`, clearing the search field or tapping the `(x)` clear button triggers `cubit.setSearch(null)` and properly loads all accounts.
    - In `account_picker_sheet.dart`, remove redundant outer `GestureDetector` that wraps `ListTile`; maintain disabled state and snackbar on `ListTile.onTap`.
  - **Verify:**
    - `flutter test test/features/accounting/presentation/chart_of_accounts_screen_test.dart`
    - `flutter test test/features/accounting/presentation/account_picker_sheet_test.dart`
  - **Files:**
    - `app/lib/features/accounting/presentation/screens/chart_of_accounts_screen.dart`
    - `app/lib/features/accounting/presentation/widgets/account_picker_sheet.dart`
    - `app/test/features/accounting/presentation/chart_of_accounts_screen_test.dart`
    - `app/test/features/accounting/presentation/account_picker_sheet_test.dart`

- [x] **Task MQ-03: Hydrate parent ID and use `AccountPickerField` in `AccountFormScreen`**
  - **Acceptance:**
    - When editing an existing account with `parentId`, the form initializes with the parent account selected and does not clear it on save.
    - Replace the raw `_parentIdController` text field with `AccountPickerField` (excluding self).
  - **Verify:** `flutter test test/features/accounting/presentation/account_form_screen_test.dart` passes.
  - **Files:**
    - `app/lib/features/accounting/presentation/screens/account_form_screen.dart`
    - `app/test/features/accounting/presentation/account_form_screen_test.dart`

---

## Slice C: Vendors Logic & Navigation

- [x] **Task MQ-04: Add debouncing/epoch tracking to `VendorsCubit` and GoRouter to `VendorsListScreen`**
  - **Acceptance:**
    - `VendorsCubit` introduces `_debounceTimer` (300ms) and `_loadEpoch` counter, dropping responses from stale search requests.
    - `VendorsListScreen` replaces imperative `Navigator.push(MaterialPageRoute(...))` with `context.push(Routes.adminAccountingVendorsCreate)` and `context.push(Routes.adminAccountingVendorEditById(vendor.id))`.
  - **Verify:**
    - `flutter test test/features/accounting/presentation/vendors_cubit_test.dart`
    - `flutter test test/features/accounting/presentation/vendors_list_screen_test.dart`
  - **Files:**
    - `app/lib/features/accounting/presentation/cubit/vendors_cubit.dart`
    - `app/lib/features/accounting/presentation/screens/vendors_list_screen.dart`
    - `app/test/features/accounting/presentation/vendors_cubit_test.dart`
    - `app/test/features/accounting/presentation/vendors_list_screen_test.dart`

---

## Slice D: Canonical Vendor Picker Component

- [x] **Task MQ-05: Create `VendorPickerSheet` and `VendorPickerField`**
  - **Acceptance:**
    - Implement `VendorPickerSheet` using `AppPagedPickerSheet<Vendor>`.
    - Inactive vendors are listed with an `Inactive` badge, disabled from selection, and show an explanatory snackbar if tapped.
    - Implement `VendorPickerField` using `AppPickerFormField<Vendor>`.
    - Provide unit and widget tests covering active selection, inactive tap feedback, and debounced search.
  - **Verify:** `flutter test test/features/accounting/presentation/vendor_picker_sheet_test.dart` passes.
  - **Files:**
    - `app/lib/features/accounting/presentation/widgets/vendor_picker_sheet.dart`
    - `app/test/features/accounting/presentation/vendor_picker_sheet_test.dart`

---

## Slice E: Items Hardening & Optimization

- [x] **Task MQ-06: Safe ID parsing in `ItemFormCubit` and clear-icon optimization in `ItemsListScreen`**
  - **Acceptance:**
    - `ItemFormCubit.buildDraft()` safely parses `incomeAccountId` and `expenseAccountId` with `int.tryParse`, emitting a validation error if malformed rather than throwing `FormatException`.
    - `ItemsListScreen` replaces whole-screen `setState` on keystroke with `ValueListenableBuilder<TextEditingValue>` on `_searchController` for the clear icon.
  - **Verify:**
    - `flutter test test/features/accounting/presentation/item_form_test.dart`
    - `flutter test test/features/accounting/presentation/items_list_screen_test.dart`
  - **Files:**
    - `app/lib/features/accounting/presentation/cubit/item_form_cubit.dart`
    - `app/lib/features/accounting/presentation/screens/items_list_screen.dart`
    - `app/test/features/accounting/presentation/item_form_test.dart`
    - `app/test/features/accounting/presentation/items_list_screen_test.dart`

- [x] **Task MQ-07: Replace 500-item bulk queries in `ItemDetailScreen` with targeted parallel ID lookups**
  - **Acceptance:**
    - `ItemDetailScreen._loadNames()` fetches only the specific 4 account IDs and 1 tax code ID present on the item using `Future.wait` on `getAccount` and `getTaxCode`.
    - Eliminates the `GetAccountsParams(limit: 500)` and `GetTaxCodesParams(limit: 500)` bulk downloads.
  - **Verify:** `flutter test test/features/accounting/presentation/item_detail_screen_test.dart` passes.
  - **Files:**
    - `app/lib/features/accounting/presentation/screens/item_detail_screen.dart`
    - `app/test/features/accounting/presentation/item_detail_screen_test.dart`

---

## Slice F: Verification & Quality Gate

- [x] **Task MQ-08: Full test suite verification and static analysis check**
  - **Acceptance:**
    - `dart analyze lib/features/accounting` passes with 0 errors and 0 warnings.
    - All accounting presentation tests pass.
  - **Verify:**
    - `cd app; dart analyze lib/features/accounting`
    - `cd app; flutter test test/features/accounting/presentation/`
