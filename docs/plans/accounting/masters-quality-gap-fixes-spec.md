# Spec: Accounting Masters Quality Gap Fixes & Hardening Remediation

**Module:** `accounting-masters-quality`  
**Status:** Approved & Implemented  
**Date:** 2026-10-27  
**Parent Spec:** [`masters-quality-spec.md`](./masters-quality-spec.md)  
**Parent Plan:** [`masters-quality-plan.md`](./masters-quality-plan.md)  
**Origin:** Multi-axis code review findings on slices A–D of [`masters-quality-tasks.md`](./masters-quality-tasks.md)

---

## Assumptions

1. **Scope Boundary:** This spec addresses only the gaps and findings surfaced during the code review of tasks MQ-01 through MQ-05. Tasks MQ-06 through MQ-08 (Items safe parsing, ItemDetail targeted lookups, full verification) will continue after these remediations are locked.
2. **Framework & Platform:** Flutter 3.x / Dart 3.x. No new dependencies or backend schema migrations are introduced.
3. **Test Infrastructure:** Flutter test environment requires settled animations when using `tester.pumpAndSettle()`. Any widget containing an ongoing animation (such as `CircularProgressIndicator` in `AppLoading`) will cause `pumpAndSettle()` to timeout unless properly bounded or terminated in state.

---

## 1. Objective

Remediate quality, correctness, and architectural inconsistencies identified during code review of the Accounting Masters implementation:

1. **Fix Test Timeouts in `vendors_list_screen_test.dart`:** Correct the test setup where `hasReachedMax: false` caused infinite animation from pagination loading indicators, making `tester.pumpAndSettle()` time out.
2. **Resolve Dart Analyzer Violation in `vendors_cubit.dart`:** Fix the `prefer_initializing_formals` lint warning in the `VendorsCubit` constructor to achieve 0 errors and 0 warnings.
3. **Eliminate Redundant `GestureDetector` in `VendorPickerSheet`:** Align `VendorPickerSheet` with the canonical pattern established in `AccountPickerSheet` by removing the redundant outer `GestureDetector` and placing both selection and inactive feedback directly on `ListTile.onTap`.
4. **Harden Concurrent Account Hydration in `AccountFormScreen`:** Add a concurrency race guard to `_loadParentAccount` so delayed responses cannot overwrite newer parent account selections.
5. **Ensure Consistent Debounce & Search State Updates:** Align search state emissions between `AccountsCubit` and `VendorsCubit` so both immediately reflect the input query in state.

---

## 2. Tech Stack & Commands

- **Language / Framework:** Dart 3.x, Flutter 3.x with `flutter_bloc`, `mocktail`, `go_router`.

### Commands
```bash
# Analyze accounting feature (must be 0 errors, 0 warnings, 0 infos)
cd app; dart analyze lib/features/accounting

# Run specific impacted tests
cd app; flutter test test/features/accounting/presentation/vendors_list_screen_test.dart
cd app; flutter test test/features/accounting/presentation/vendor_picker_sheet_test.dart
cd app; flutter test test/features/accounting/presentation/vendors_cubit_test.dart
cd app; flutter test test/features/accounting/presentation/accounts_cubit_test.dart
cd app; flutter test test/features/accounting/presentation/account_form_screen_test.dart

# Run entire accounting presentation test suite
cd app; flutter test test/features/accounting/presentation/
```

---

## 3. Project Structure & Affected Files

```
app/
├── lib/features/accounting/presentation/
│   ├── cubit/
│   │   ├── accounts_cubit.dart            # Synchronous state update on debounce zero
│   │   └── vendors_cubit.dart             # Initializing formal for debounce duration
│   ├── screens/
│   │   └── account_form_screen.dart       # Race guard in _loadParentAccount
│   └── widgets/
│       └── vendor_picker_sheet.dart       # Remove redundant outer GestureDetector
└── test/features/accounting/presentation/
    ├── account_form_screen_test.dart      # Verify race guard behavior
    ├── accounts_cubit_test.dart           # Verify synchronous state emission
    ├── vendor_picker_sheet_test.dart      # Verify single-ListTile gesture feedback
    └── vendors_list_screen_test.dart      # Set hasReachedMax: true to fix pumpAndSettle
```

---

## 4. Code Style & Technical Implementation Patterns

### Pattern A: Clean Single-ListTile Interaction in `VendorPickerSheet`
Remove outer `GestureDetector`. Use `Theme.of(context).disabledColor` for text styling on inactive rows.
```dart
// app/lib/features/accounting/presentation/widgets/vendor_picker_sheet.dart
itemBuilder: (context, vendor) {
  final isSelectable = vendor.isActive;

  void showInactiveSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AccountingStrings.cannotPickInactiveVendor),
      ),
    );
  }

  return ListTile(
    key: Key('vendor_option_${vendor.id}'),
    title: Text(
      vendor.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isSelectable
          ? null
          : TextStyle(color: Theme.of(context).disabledColor),
    ),
    subtitle: subtitleChildren.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: subtitleChildren,
            ),
          ),
    onTap: isSelectable
        ? () => Navigator.of(context).pop(vendor)
        : showInactiveSnackBar,
  );
}
```

### Pattern B: Initializing Formal in `VendorsCubit`
Conform to `prefer_initializing_formals`:
```dart
// app/lib/features/accounting/presentation/cubit/vendors_cubit.dart
@injectable
class VendorsCubit extends Cubit<VendorsState> {
  VendorsCubit(
    this._getVendors, {
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const VendorsState());

  final GetVendorsUseCase _getVendors;
  final Duration debounceDuration;
  Timer? _debounceTimer;
  int _loadEpoch = 0;
  // ...
}
```

### Pattern C: Race Guard in `AccountFormScreen`
Ensure asynchronous lookup results are applied only if the targeted parent ID is still selected:
```dart
// app/lib/features/accounting/presentation/screens/account_form_screen.dart
Future<void> _loadParentAccount(String parentId) async {
  if (!getIt.isRegistered<GetAccountUseCase>()) return;
  final useCase = getIt<GetAccountUseCase>();
  final result = await useCase(GetAccountParams(id: parentId));
  result.fold(
    (_) {},
    (acc) {
      if (mounted && _parentId == parentId) {
        setState(() {
          _parentAccount = acc;
        });
      }
    },
  );
}
```

### Pattern D: Test State Configuration in `vendors_list_screen_test.dart`
Configure `hasReachedMax: true` so no pagination spinner is rendered during navigation tests:
```dart
// app/test/features/accounting/presentation/vendors_list_screen_test.dart
Widget buildTestableWidget({
  Capabilities capabilities = writeCapabilities,
  VendorsState state = const VendorsState(
    status: LoadStatus.success,
    hasReachedMax: true,
  ),
})
```

---

## 5. Testing Strategy

1. **Widget Navigation Tests:**
   - In `vendors_list_screen_test.dart`: verify tapping FAB navigates to `Routes.adminAccountingVendorsCreate` within `pumpAndSettle()`.
   - Verify tapping vendor item navigates to `Routes.adminAccountingVendorEditById(vendor.id)` within `pumpAndSettle()`.
2. **Picker Interaction Tests:**
   - In `vendor_picker_sheet_test.dart`: verify tapping an inactive vendor item displays the snackbar `AccountingStrings.cannotPickInactiveVendor` and does not pop the sheet, with no competing gesture recognizers.
3. **Cubit Unit Tests:**
   - In `vendors_cubit_test.dart`: confirm debouncing and immediate query state emissions pass with clean lifecycle handling.
   - In `accounts_cubit_test.dart`: verify `setSearch` emits intermediate query state consistently.
4. **Static Analysis:**
   - Run `dart analyze lib/features/accounting` to verify 0 errors, 0 warnings, 0 infos.

---

## 6. Boundaries

- **Always:**
  - Keep `dart analyze lib/features/accounting` at 0 issues.
  - Maintain backwards compatibility for existing cubit consumers and widgets.
  - Verify every change with automated widget/unit tests before marking done.
- **Ask First:**
  - Introducing any changes to OpenAPI generated models or backend DTOs.
- **Never:**
  - Use `tester.pumpAndSettle()` on widgets displaying continuous animations (such as un-terminated `AppLoading`).
  - Wrap `ListTile` in outer `GestureDetector` when `ListTile.onTap` can natively handle the interaction.

---

## 7. Success Criteria

1. `cd app; flutter test test/features/accounting/presentation/vendors_list_screen_test.dart` passes completely (all 11 tests green, 0 failures, 0 timeouts).
2. `cd app; dart analyze lib/features/accounting` reports `No issues found!`.
3. `VendorPickerSheet` has no outer `GestureDetector` and matches `AccountPickerSheet` styling and interaction.
4. `AccountFormScreen._loadParentAccount` is protected against concurrent/out-of-order parent selection updates.
5. All 428+ accounting presentation tests run and pass cleanly.

---

## 8. Open Questions

1. **`toAccountUpdate` Nullable Parent Field:** In OpenAPI/NestJS, unsetting an account's parent (`parent_id = null`) is currently a no-op because the generated built_value serializer omits `null` fields from JSON PATCH payloads. Should this be formally tracked in `implementation_plan.md` under backend contract updates for the Create-and-Post / Phase 9 overhaul?
2. **`setSearch` naming standardization:** Should `VendorsCubit.searchVendors(String? query)` be provided an alias `setSearch(String? query)` to align with `AccountsCubit`, or keep `searchVendors` as the canonical API for vendors?
