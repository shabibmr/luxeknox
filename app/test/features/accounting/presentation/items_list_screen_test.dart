import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/items_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/items_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockItemsCubit extends MockCubit<ItemsState> implements ItemsCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockItemsCubit mockItemsCubit;
  late MockSessionCubit mockSessionCubit;

  const tItem1 = Item(
    id: 1,
    name: 'Protein Bar',
    kind: 'goods',
    sku: 'PB-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '50.00',
    inventoryTracked: true,
    isActive: true,
  );

  const tItem2 = Item(
    id: 2,
    name: 'PT Session',
    kind: 'service',
    sku: 'PT-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '1500.00',
    inventoryTracked: false,
    isActive: false,
  );

  const writeCapabilities = Capabilities(
    slugs: ['inventory.read', 'accounting.accounts_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['inventory.read'],
  );
  const noCapabilities = Capabilities(slugs: []);

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUp(() {
    mockItemsCubit = MockItemsCubit();
    mockSessionCubit = MockSessionCubit();

    when(
      () => mockItemsCubit.load(
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
    when(() => mockItemsCubit.searchItems(any())).thenReturn(null);
    when(() => mockItemsCubit.filterByKind(any())).thenAnswer((_) async {});
    when(() => mockItemsCubit.filterByActive(any())).thenAnswer((_) async {});
    when(() => mockItemsCubit.filterByTracked(any())).thenAnswer((_) async {});
    when(() => mockItemsCubit.loadMore()).thenAnswer((_) async {});

    if (getIt.isRegistered<ItemsCubit>()) {
      getIt.unregister<ItemsCubit>();
    }
    getIt.registerFactory<ItemsCubit>(() => mockItemsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ItemsCubit>()) {
      getIt.unregister<ItemsCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    ItemsState state = const ItemsState(status: LoadStatus.success),
  }) {
    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tPrincipal,
        capabilities: capabilities,
      ),
    );

    whenListen(
      mockItemsCubit,
      const Stream<ItemsState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: ItemsListScreen(cubit: mockItemsCubit),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingItemsCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Item Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/items/:id',
          builder: (context, routerState) => Scaffold(
            body: Text(
              'Item Detail Destination ${routerState.pathParameters['id']}',
            ),
          ),
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  group('Permission check', () {
    testWidgets('shows noPermission when user lacks inventory.read',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(capabilities: noCapabilities),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.byKey(const Key('item_list_search_field')), findsNothing);
    });
  });

  group('Loading, Error, and Empty states', () {
    testWidgets('displays AppLoading when loading and list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ItemsState(status: LoadStatus.loading),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('displays AppErrorView when status is failure', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ItemsState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Could not load items'),
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('displays AppEmptyView when items list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ItemsState(
            status: LoadStatus.success,
            items: [],
          ),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text(AccountingStrings.noneFound), findsOneWidget);
    });
  });

  group('List content and actions', () {
    testWidgets(
        'renders rows with name, SKU, kind, UOM, sale rate, tracked and inactive badges',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ItemsState(
            status: LoadStatus.success,
            items: [tItem1, tItem2],
          ),
        ),
      );

      expect(find.text('Protein Bar'), findsOneWidget);
      expect(find.text('PB-001'), findsOneWidget);
      expect(find.byKey(const Key('item_kind_chip_1')), findsOneWidget);
      expect(find.byKey(const Key('item_uom_1')), findsOneWidget);
      expect(find.text('50.00'), findsOneWidget);
      expect(find.byKey(const Key('item_tracked_badge_1')), findsOneWidget);

      expect(find.text('PT Session'), findsOneWidget);
      expect(find.text('PT-001'), findsOneWidget);
      expect(find.byKey(const Key('item_kind_chip_2')), findsOneWidget);
      expect(find.text('1500.00'), findsOneWidget);
      expect(find.byKey(const Key('item_inactive_badge_2')), findsOneWidget);
      expect(find.byKey(const Key('item_tracked_badge_2')), findsNothing);
    });

    testWidgets('FAB is shown when user has accounting.accounts_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: const ItemsState(
            status: LoadStatus.success,
            items: [tItem1],
          ),
        ),
      );

      expect(find.byKey(const Key('create_item_fab')), findsOneWidget);
    });

    testWidgets('FAB is hidden when user lacks accounting.accounts_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: const ItemsState(
            status: LoadStatus.success,
            items: [tItem1],
          ),
        ),
      );

      expect(find.byKey(const Key('create_item_fab')), findsNothing);
    });

    testWidgets('row tap opens item detail', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ItemsState(
            status: LoadStatus.success,
            items: [tItem1],
          ),
        ),
      );

      await tester.tap(find.text('Protein Bar'));
      await tester.pumpAndSettle();

      expect(find.text('Item Detail Destination 1'), findsOneWidget);
    });
  });
}
