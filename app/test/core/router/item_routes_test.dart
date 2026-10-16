import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/router/app_router.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/entities/tax_code.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_item_categories_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_tax_codes_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounting_home_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/item_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/item_form_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/items_cubit.dart';
import 'package:luxeknox/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockAccountingHomeCubit extends MockCubit<AccountingHomeState>
    implements AccountingHomeCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

class MockItemsCubit extends MockCubit<ItemsState> implements ItemsCubit {}

class MockItemDetailCubit extends MockCubit<ItemDetailState>
    implements ItemDetailCubit {}

class MockItemFormCubit extends MockCubit<ItemFormState>
    implements ItemFormCubit {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockGetTaxCodesUseCase extends Mock implements GetTaxCodesUseCase {}

class MockGetItemCategoriesUseCase extends Mock
    implements GetItemCategoriesUseCase {}

/// Confirms the item routes resolve through the real admin router.
void main() {
  const admin = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: 'p1',
  );

  const tItem = Item(
    id: 5,
    name: 'Test Item',
    kind: 'goods',
    sku: 'SKU-5',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
  );

  setUpAll(() {
    registerFallbackValue(const ListSchedulesParams());
    registerFallbackValue(const GetAccountsParams());
    registerFallbackValue(const GetTaxCodesParams());
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    final dashboard = MockGetDashboardUseCase();
    when(
      () => dashboard(const NoParams()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardCubit>(() => DashboardCubit(dashboard));
    final schedules = MockListSchedulesUseCase();
    when(
      () => schedules(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardAgendaCubit>(
      () => DashboardAgendaCubit(schedules),
    );
    final home = MockAccountingHomeCubit();
    when(() => home.load()).thenAnswer((_) async {});
    when(
      () => home.state,
    ).thenReturn(const AccountingHomeState(status: LoadStatus.loading));
    getIt.registerFactory<AccountingHomeCubit>(() => home);

    final items = MockItemsCubit();
    when(
      () => items.load(
        search: any(named: 'search'),
        kind: any(named: 'kind'),
        isActive: any(named: 'isActive'),
        inventoryTracked: any(named: 'inventoryTracked'),
        clearSearch: any(named: 'clearSearch'),
        clearKind: any(named: 'clearKind'),
        clearActive: any(named: 'clearActive'),
        clearTracked: any(named: 'clearTracked'),
        clearFilters: any(named: 'clearFilters'),
      ),
    ).thenAnswer((_) async {});
    whenListen(
      items,
      const Stream<ItemsState>.empty(),
      initialState: const ItemsState(status: LoadStatus.success, items: []),
    );
    getIt.registerFactory<ItemsCubit>(() => items);

    final detail = MockItemDetailCubit();
    when(() => detail.load(any(), initialItem: any(named: 'initialItem')))
        .thenAnswer((_) async {});
    whenListen(
      detail,
      const Stream<ItemDetailState>.empty(),
      initialState: const ItemDetailState(
        status: LoadStatus.success,
        item: tItem,
      ),
    );
    getIt.registerFactory<ItemDetailCubit>(() => detail);

    final form = MockItemFormCubit();
    when(() => form.loadTaxCodes()).thenAnswer((_) async {});
    when(
      () => form.loadForEdit(any(), initial: any(named: 'initial')),
    ).thenAnswer((_) async {});
    whenListen(
      form,
      const Stream<ItemFormState>.empty(),
      initialState: const ItemFormState(),
    );
    getIt.registerFactory<ItemFormCubit>(() => form);

    final getAccounts = MockGetAccountsUseCase();
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<Account>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    getIt.registerFactory<GetAccountsUseCase>(() => getAccounts);

    final getTaxCodes = MockGetTaxCodesUseCase();
    when(() => getTaxCodes(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<TaxCode>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    getIt.registerFactory<GetTaxCodesUseCase>(() => getTaxCodes);

    final getCategories = MockGetItemCategoriesUseCase();
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right(<ItemCategory>[]));
    getIt.registerFactory<GetItemCategoriesUseCase>(() => getCategories);
  });

  tearDown(() => getIt.reset());

  Future<_H> pump(WidgetTester tester, List<String> slugs) async {
    final session = MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: admin,
        capabilities: Capabilities(slugs: slugs),
      ),
    );
    getIt.registerSingleton<SessionCubit>(session);
    final router = createRouter(session);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) =>
            BlocProvider<SessionCubit>.value(value: session, child: child!),
      ),
    );
    await tester.pumpAndSettle();
    return _H(router);
  }

  testWidgets('deep link /items/5 opens the detail screen', (tester) async {
    final h = await pump(tester, ['inventory.read']);
    h.router.go(Routes.adminAccountingItemById('5'));
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.itemDetailTitle), findsOneWidget);
  });

  testWidgets('create is not swallowed by :id', (tester) async {
    final h = await pump(tester, [
      'inventory.read',
      'accounting.accounts_write',
    ]);
    h.router.go(Routes.adminAccountingItemsCreate);
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.createItemTitle), findsOneWidget);
  });

  testWidgets('edit route opens the form in edit mode', (tester) async {
    final h = await pump(tester, [
      'inventory.read',
      'accounting.accounts_write',
    ]);
    h.router.go(Routes.adminAccountingItemEditById('5'));
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.editItemTitle), findsOneWidget);
  });

  testWidgets('list route opens the list screen', (tester) async {
    final h = await pump(tester, ['inventory.read']);
    h.router.go(Routes.adminAccountingItems);
    await tester.pumpAndSettle();
    expect(find.text(AccountingStrings.itemsTitle), findsOneWidget);
  });
}

class _H {
  _H(this.router);
  final GoRouter router;
}
