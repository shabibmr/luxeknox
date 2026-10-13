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
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bills_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/purchase_bills_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPurchaseBillsCubit extends MockCubit<PurchaseBillsState>
    implements PurchaseBillsCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockPurchaseBillsCubit mockPurchaseBillsCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftBill = PurchaseBill(
    id: 'pb-1',
    billNumber: 'BILL-0001',
    vendorId: 'v-1',
    vendorName: 'Acme Fitness Equipments',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '1000.00',
    taxAmount: '180.00',
    totalAmount: '1180.00',
    status: 'draft',
    allocatedAmount: '0.00',
    lines: const [],
  );

  final tPostedBill = PurchaseBill(
    id: 'pb-2',
    billNumber: 'BILL-0002',
    vendorId: 'v-2',
    vendorName: 'Gym Nutrition Co',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 15)),
    subtotal: '500.00',
    taxAmount: '50.00',
    totalAmount: '550.00',
    status: 'posted',
    allocatedAmount: '0.00',
    journalEntryId: 'JRN-2026-0010',
    lines: const [],
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.purchases_write'],
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
    mockPurchaseBillsCubit = MockPurchaseBillsCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockPurchaseBillsCubit.load(
          statusFilter: any(named: 'statusFilter'),
          vendorId: any(named: 'vendorId'),
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
          search: any(named: 'search'),
          clearStatus: any(named: 'clearStatus'),
          clearVendor: any(named: 'clearVendor'),
          clearDates: any(named: 'clearDates'),
          clearSearch: any(named: 'clearSearch'),
          clearFilters: any(named: 'clearFilters'),
        )).thenAnswer((_) async {});
    when(() => mockPurchaseBillsCubit.filterByStatus(any()))
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillsCubit.filterByVendor(any()))
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillsCubit.filterByDateRange(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillsCubit.searchBills(any()))
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillsCubit.clearFilters())
        .thenAnswer((_) async {});

    if (getIt.isRegistered<PurchaseBillsCubit>()) {
      getIt.unregister<PurchaseBillsCubit>();
    }
    getIt.registerFactory<PurchaseBillsCubit>(() => mockPurchaseBillsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<PurchaseBillsCubit>()) {
      getIt.unregister<PurchaseBillsCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    PurchaseBillsState state = const PurchaseBillsState(
      status: LoadStatus.success,
      bills: [],
    ),
    PurchaseBillsCubit? cubit,
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
      mockPurchaseBillsCubit,
      const Stream<PurchaseBillsState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: PurchaseBillsListScreen(
              cubit: cubit ?? mockPurchaseBillsCubit,
            ),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingBillsCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Bill Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/bills/:id',
          builder: (context, routerState) => Scaffold(
            body: Text(
                'Bill Detail Destination ${routerState.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets(
      'renders bills list with billNumber, billDate, vendor name, amount, and status chip',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tDraftBill, tPostedBill],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Screen Title
    expect(find.text(AccountingStrings.billsTitle), findsOneWidget);

    // Verify bills rendered
    expect(find.text('BILL-0001'), findsOneWidget);
    expect(find.text('Acme Fitness Equipments'), findsOneWidget);
    expect(find.text('2026-10-15'), findsAtLeastNWidgets(2));
    expect(find.text(AccountingStrings.formatAmount(1180.00)), findsOneWidget);

    expect(find.text('BILL-0002'), findsOneWidget);
    expect(find.text('Gym Nutrition Co'), findsOneWidget);
    expect(find.text(AccountingStrings.formatAmount(550.00)), findsOneWidget);

    // Status chips
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.statusDraft),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.statusPosted),
      findsOneWidget,
    );
  });

  testWidgets('renders filter chips and tapping invokes cubit filters',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tDraftBill],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // All, Draft, Posted, Void chips
    expect(find.byKey(const Key('status_chip_all')), findsOneWidget);
    expect(find.byKey(const Key('status_chip_draft')), findsOneWidget);
    expect(find.byKey(const Key('status_chip_posted')), findsOneWidget);
    expect(find.byKey(const Key('status_chip_void')), findsOneWidget);

    // Tap Draft filter chip
    await tester.tap(find.byKey(const Key('status_chip_draft')));
    await tester.pumpAndSettle();
    verify(() => mockPurchaseBillsCubit.filterByStatus('draft')).called(1);

    // Tap Posted filter chip
    await tester.tap(find.byKey(const Key('status_chip_posted')));
    await tester.pumpAndSettle();
    verify(() => mockPurchaseBillsCubit.filterByStatus('posted')).called(1);
  });

  testWidgets('tapping bill card navigates to bill detail screen',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tDraftBill],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('BILL-0001'));
    await tester.pumpAndSettle();

    expect(find.text('Bill Detail Destination pb-1'), findsOneWidget);
  });

  testWidgets('FAB is visible when user has purchases_write and navigates to create',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        capabilities: writeCapabilities,
        state: const PurchaseBillsState(status: LoadStatus.success),
      ),
    );
    await tester.pumpAndSettle();

    final fab = find.byKey(const Key('create_bill_button'));
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.text('Create Bill Destination'), findsOneWidget);
  });

  testWidgets('FAB is not rendered when user lacks purchases_write capability',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        capabilities: readOnlyCapabilities,
        state: const PurchaseBillsState(status: LoadStatus.success),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('create_bill_button')), findsNothing);
  });

  testWidgets('shows loading view when status is loading and bills are empty',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const PurchaseBillsState(
          status: LoadStatus.loading,
          bills: [],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('shows empty view when bills list is empty', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const PurchaseBillsState(
          status: LoadStatus.success,
          bills: [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noneFound), findsOneWidget);
  });

  testWidgets('shows error view when status is failure and bills are empty',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const PurchaseBillsState(
          status: LoadStatus.failure,
          failure: NetworkFailure(),
          bills: [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);
  });
}
