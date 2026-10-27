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
import 'package:luxeknox/core/widgets/app_status_chip.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounts_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/chart_of_accounts_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountsCubit extends MockCubit<AccountsState>
    implements AccountsCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockAccountsCubit mockAccountsCubit;
  late MockSessionCubit mockSessionCubit;

  const tBankAssetAccount = Account(
    id: '1',
    name: 'Operating Bank Account',
    type: 'asset',
    isBank: true,
    isControl: false,
    isActive: true,
  );

  const tControlAccount = Account(
    id: '2',
    name: 'Accounts Receivable',
    type: 'asset',
    isBank: false,
    isControl: true,
    isActive: true,
    description: 'AR Control',
  );

  const tInactiveLiabilityAccount = Account(
    id: '3',
    name: 'Old Equipment Loan',
    type: 'liability',
    isBank: false,
    isControl: false,
    isActive: false,
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.accounts_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['accounting.read'],
  );

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUp(() {
    mockAccountsCubit = MockAccountsCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockAccountsCubit.load(
          accountType: any(named: 'accountType'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
          clearType: any(named: 'clearType'),
          clearActive: any(named: 'clearActive'),
        )).thenAnswer((_) async {});
    when(() => mockAccountsCubit.filterByType(any()))
        .thenAnswer((_) async {});
    when(() => mockAccountsCubit.filterByActive(any()))
        .thenAnswer((_) async {});
    when(() => mockAccountsCubit.setSearch(any())).thenAnswer((_) async {});

    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
    getIt.registerFactory<AccountsCubit>(() => mockAccountsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    AccountsState state = const AccountsState(
      status: LoadStatus.success,
      accounts: [tBankAssetAccount, tControlAccount, tInactiveLiabilityAccount],
    ),
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
      mockAccountsCubit,
      const Stream<AccountsState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: ChartOfAccountsScreen(cubit: mockAccountsCubit),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingAccountsCreate,
          builder: (context, state) =>
              const Scaffold(body: Text('Create Account Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/accounts/:id/edit',
          builder: (_, state) => Scaffold(
            body: Text('Edit Account Destination ${state.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('renders accounts with name and badges', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Verify account name only (codes are not shown in UI references)
    expect(find.text('1000'), findsNothing);
    expect(find.text('Operating Bank Account'), findsOneWidget);
    expect(find.text('1200'), findsNothing);
    expect(find.text('Accounts Receivable'), findsOneWidget);

    // Verify bank icon and badge
    expect(find.byIcon(Icons.account_balance), findsOneWidget);
    expect(find.text('Bank'), findsOneWidget);

    // Verify control badge and description
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Control'), findsOneWidget);
    expect(find.text('AR Control'), findsAtLeastNWidgets(1));

    // Verify active status badges on account cards
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.activeBadge),
      findsNWidgets(2),
    );
  });

  testWidgets(
      'ACC-093: deactivated accounts stay visible and display inactive badge',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Inactive account remains visible in the list by default
    expect(find.text('2000'), findsNothing);
    expect(find.text('Old Equipment Loan'), findsOneWidget);

    // Inactive account is clearly marked with inactive badge
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.inactiveBadge),
      findsOneWidget,
    );
  });

  testWidgets('type filter chips trigger cubit.filterByType', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Asset chip
    await tester.tap(find.byKey(const Key('type_chip_asset')));
    await tester.pump();
    verify(() => mockAccountsCubit.filterByType('asset')).called(1);

    // Tap All chip
    await tester.tap(find.byKey(const Key('type_chip_all')));
    await tester.pump();
    verify(() => mockAccountsCubit.filterByType(null)).called(1);
  });

  testWidgets('status filter chips trigger cubit.filterByActive',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Active chip
    await tester.tap(find.byKey(const Key('status_chip_active')));
    await tester.pump();
    verify(() => mockAccountsCubit.filterByActive(true)).called(1);

    // Tap Inactive chip
    await tester.tap(find.byKey(const Key('status_chip_inactive')));
    await tester.pump();
    verify(() => mockAccountsCubit.filterByActive(false)).called(1);

    // Tap All chip
    await tester.tap(find.byKey(const Key('status_chip_all')));
    await tester.pump();
    verify(() => mockAccountsCubit.filterByActive(null)).called(1);
  });

  testWidgets('search text field triggers cubit.setSearch', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('search_accounts_field'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Operating');
    await tester.pump();
    verify(() => mockAccountsCubit.setSearch('Operating')).called(1);

    // Clear button should be visible when search is not empty
    final clearButton = find.byKey(const Key('clear_search_button'));
    expect(clearButton, findsOneWidget);

    // Tapping clear button clears text and triggers cubit.setSearch(null)
    await tester.tap(clearButton);
    await tester.pump();
    verify(() => mockAccountsCubit.setSearch(null)).called(1);
    expect(tester.widget<TextField>(searchField).controller?.text, isEmpty);
  });

  testWidgets('clearing search text triggers cubit.setSearch(null)', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('search_accounts_field'));
    await tester.enterText(searchField, 'Operating');
    await tester.pump();
    verify(() => mockAccountsCubit.setSearch('Operating')).called(1);

    await tester.enterText(searchField, '');
    await tester.pump();
    verify(() => mockAccountsCubit.setSearch(null)).called(1);
  });

  testWidgets(
      'New Account button is shown and navigates when user has accounting.accounts_write',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(capabilities: writeCapabilities));
    await tester.pumpAndSettle();

    final fab = find.byKey(const Key('create_account_button'));
    expect(fab, findsOneWidget);
    expect(find.text(AccountingStrings.createAccountTitle), findsAtLeastNWidgets(1));

    // Tap FAB navigates to create route
    await tester.tap(fab);
    await tester.pumpAndSettle();
    expect(find.text('Create Account Destination'), findsOneWidget);
  });

  testWidgets(
      'New Account button is hidden and tile onTap is disabled when read-only',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(capabilities: readOnlyCapabilities),
    );
    await tester.pumpAndSettle();

    // FAB should not exist
    expect(find.byKey(const Key('create_account_button')), findsNothing);
    expect(find.byKey(const Key('appbar_create_account_button')), findsNothing);

    // Tile should not have onTap navigation
    final tile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Operating Bank Account'),
    );
    expect(tile.onTap, isNull);
  });

  testWidgets('tapping account tile navigates to edit route when write permitted',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget(capabilities: writeCapabilities));
    await tester.pumpAndSettle();

    final tile = find.widgetWithText(ListTile, 'Operating Bank Account');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Edit Account Destination 1'), findsOneWidget);
  });

  testWidgets('handles loading state', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const AccountsState(
          status: LoadStatus.loading,
          accounts: [],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('handles error state and retry button triggers cubit.load',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const AccountsState(
          status: LoadStatus.failure,
          accounts: [],
          failure: NetworkFailure(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);

    await tester.tap(find.text(AccountingStrings.retry));
    await tester.pump();
    verify(() => mockAccountsCubit.load()).called(1);
  });

  testWidgets('handles empty state', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const AccountsState(
          status: LoadStatus.success,
          accounts: [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noneFound), findsOneWidget);
  });

  testWidgets('refresh button in app bar triggers cubit.load', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final refreshButton = find.byTooltip(AccountingStrings.refresh);
    expect(refreshButton, findsOneWidget);

    await tester.tap(refreshButton);
    await tester.pump();
    verify(() => mockAccountsCubit.load()).called(1);
  });
}
