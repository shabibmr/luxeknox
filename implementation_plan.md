# #23 Settle with one payment method

## Seams (confirmed)
- Widget: `CounterSaleScreen` + real `CounterSaleCubit`
- Fakes: `GetItemsUseCase`, `GetPaymentMethodsUseCase`, `ListMembersUseCase`, `CreateCounterSaleUseCase`
- Assert visible UI + create-call payload

## Flow
Grid → Continue → tender step (buyer deferred to #24; create may send neither). Cubit holds optional `memberId` / `buyerName` for later.

## Files
- [NEW] `app/lib/features/inventory/domain/entities/counter_sale.dart` — posted sale + tender summary
- [NEW] `app/lib/features/inventory/domain/entities/create_counter_sale_input.dart` — create params
- [NEW] `app/lib/features/inventory/domain/repositories/inventory_repository.dart`
- [NEW] `app/lib/features/inventory/domain/usecases/create_counter_sale_usecase.dart`
- [NEW] `app/lib/features/inventory/data/datasources/inventory_remote_datasource.dart` — Dio `POST /inventory/sales`
- [NEW] `app/lib/features/inventory/data/repositories/inventory_repository_impl.dart` — map structured 422 rules
- [MODIFY] `counter_sale_cubit.dart` — steps, methods, select, confirm, idempotency, reset
- [MODIFY] `counter_sale_screen.dart` — tender UI, success, errors, PopScope discard
- [MODIFY] `inventory_strings.dart`
- [MODIFY] `counter_sale_screen_test.dart`
- [MODIFY] `injector.config.dart` via build_runner

## Out of scope
Split (#25), full buyer UI (#24), OpenAPI client regen
