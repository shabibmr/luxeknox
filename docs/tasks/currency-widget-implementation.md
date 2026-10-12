# Currency Widget Implementation Task Register

Branch: `feat/shared-currency-field`  
Base: `main`  
Status: In progress

## Phase 1 — Audit

- [x] CUR-001 Inventory monetary fields in membership product, membership creation/renewal, PT package/sale, payment detail/ledger/dues, and member dossier flows.
- [x] CUR-002 Identify existing currency display implementations, including hardcoded `$` in payment formatting and raw price strings in package selectors/catalogues.
- [x] CUR-003 Verify `GymCurrencyProvider`, `currencySymbol`, and `currencyDecimalDigits`.
- [x] CUR-004 Classify editable amount fields separately from display-only amounts and percentage inputs.

## Phase 2 — Shared components

- [x] CUR-005 Define shared `AppCurrencyField` API for optional/required values, limits, read-only state, and custom validation.
- [x] CUR-006 Keep validation side-effect-free; normalize only at controlled focus-loss/submission points.
- [x] CUR-007 Resolve currency through gym settings, with a documented INR fallback when settings are unavailable.
- [x] CUR-008 Add numeric, minimum and maximum validation.
- [x] CUR-009 Keep input decoration theme-driven and expose accessibility-friendly field labels.
- [x] CUR-010 Add reusable `AppCurrencyText` for display-only amounts.
- [x] CUR-011 Add/adjust widget tests for normalization and validation.
- [x] CUR-012 Preserve existing `AppCurrencyField` constructor compatibility.

## Phase 3 — Screen migration

- [x] CUR-013 Verify membership product price uses `AppCurrencyField`.
- [x] CUR-014 Verify membership creation selects catalog products and formats the selected product price; it does not edit the price.
- [x] CUR-015 Verify membership renewal has no editable monetary amount; its renewal amount is server-calculated.
- [x] CUR-016 Verify PT package price uses `AppCurrencyField`; format catalog prices consistently.
- [x] CUR-017 Keep payment detail amount rows read-only and format amounts through the shared display component.
- [x] CUR-018 Audit remaining monetary input candidates and keep percentage fields on `AppPercentField`.
- [x] CUR-019 Standardize package and payment detail displays.
- [x] CUR-020 Standardize payment ledger and outstanding dues displays.
- [ ] CUR-021 Standardize every report/member summary monetary display after a full screen-by-screen audit.
- [x] CUR-022 Preserve existing numeric API payloads; no currency symbol is written into model values.

## Phase 4 — Verification

- [x] CUR-023 Add focused widget tests for the shared field.
- [ ] CUR-024 Repeat a full repository-wide audit and document any remaining raw currency values.
- [ ] CUR-025 Run formatter, analyzer and Flutter tests in a Flutter-capable environment.
- [x] CUR-026 Document shared widget usage.
- [ ] CUR-027 Final acceptance review after runtime validation.

## Notes and limitations

- The GitHub connector can write source files and commits but does not provide a local Flutter SDK, so `flutter analyze` and `flutter test` must still be run in CI or a Flutter development environment.
- Monetary inputs must use `AppCurrencyField`; percentages remain `AppPercentField`. Display-only values use `AppCurrencyText`.
- The INR fallback is used only when gym settings cannot provide a currency code. Screen-specific hardcoded currency symbols should not be introduced.
- A field that is not actually editable (e.g. a renewal total returned/calculated by the backend) must not be converted into an editable input just to use the shared widget.
