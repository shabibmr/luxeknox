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
import 'package:luxeknox/features/accounting/domain/entities/expense_voucher.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/expenses_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/expenses_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockExpensesCubit extends MockCubit<ExpensesState>
    implements ExpensesCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockExpensesCubit mockExpensesCubit;
  late MockSessionCubit mockSessionCubit;

  final tExpense1 = ExpenseVoucher(
    id: 'exp-1',
    voucherNumber: 'EXP-2026-0001',
    expenseDate: DateTime(2026, 3, 1),
    bankAccountId: 'acc-1',
    totalAmount: '150.00',
    taxAmount: '0.00',
    status: 'draft',
    memo: 'Office Supplies',
  );

  final tExpense2 = ExpenseVoucher(
    id: 'exp-2',
    voucherNumber: 'EXP-2026-0002',
    expenseDate: DateTime(2026, 3, 2),
    vendorId: 'ven-5',
    totalAmount: '450.00',
    taxAmount: '0.00',
    status: 'posted',
    journalEntryId: 'j-123',
    memo: 'Software Subscriptions',
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.expenses_write'],
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
    mockExpensesCubit = MockExpensesCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockExpensesCubit.load(
          status: any(named: 'status'),
          vendorId: any(named: 'vendorId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          search: any(named: 'search'),
          clearStatus: any(named: 'clearStatus'),
          clearVendor: any(named: 'clearVendor'),
          clearDates: any(named: 'clearDates'),
          clearSearch: any(named: 'clearSearch'),
          refresh: any(named: 'refresh'),
        )).thenAnswer((_) async {});
    when(() => mockExpensesCubit.filterByStatus(any()))
        .thenAnswer((_) async {});
    when(() => mockExpensesCubit.filterByVendor(any()))
        .thenAnswer((_) async {});
    when(() => mockExpensesCubit.filterByDateRange(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockExpensesCubit.clearFilters())
        .thenAnswer((_) async {});

    if (getIt.isRegistered<ExpensesCubit>()) {
      getIt.unregister<ExpensesCubit>();
    }
    getIt.registerFactory<ExpensesCubit>(() => mockExpensesCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ExpensesCubit>()) {
      getIt.unregister<ExpensesCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    ExpensesState state = const ExpensesState(
      status: LoadStatus.success,
      expenses: [],
    ),
    ExpensesCubit? cubit,
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
      mockExpensesCubit,
      const Stream<ExpensesState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: ExpensesListScreen(
              cubit: cubit ?? mockExpensesCubit,
            ),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingExpensesCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Expense Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/expenses/:id',
          builder: (context, routerState) => Scaffold(
            body: Text(
                'Expense Detail Destination ${routerState.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('ExpensesListScreen rendering', () {
    testWidgets('renders loading view when loading with empty list',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ExpensesState(
            status: LoadStatus.loading,
            expenses: [],
          ),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('renders error view when failure and retry calls load',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ExpensesState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Failed to load expenses'),
            expenses: [],
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Failed to load expenses'), findsOneWidget);

      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockExpensesCubit.load()).called(1);
    });

    testWidgets('renders empty view when expenses list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ExpensesState(
            status: LoadStatus.success,
            expenses: [],
          ),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text(AccountingStrings.noneFound), findsOneWidget);
    });

    testWidgets('renders expense cards with details', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: ExpensesState(
            status: LoadStatus.success,
            expenses: [tExpense1, tExpense2],
          ),
        ),
      );

      expect(find.text('EXP-2026-0001'), findsOneWidget);
      expect(find.text('Office Supplies'), findsOneWidget);
      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('EXP-2026-0002'), findsOneWidget);
      expect(find.text('Software Subscriptions'), findsOneWidget);
      expect(find.text('\$450.00'), findsOneWidget);
      expect(find.byType(AppStatusChip), findsNWidgets(2));
    });
  });

  group('Permissions & Actions', () {
    testWidgets('shows create FAB and appbar button when user has expenses_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
        ),
      );

      expect(find.byKey(const Key('create_expense_button')), findsOneWidget);
      expect(
          find.byKey(const Key('appbar_create_expense_button')), findsOneWidget);
    });

    testWidgets('hides create FAB and appbar button when read-only',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
        ),
      );

      expect(find.byKey(const Key('create_expense_button')), findsNothing);
      expect(
          find.byKey(const Key('appbar_create_expense_button')), findsNothing);
    });

    testWidgets('clicking status filter chip calls cubit.filterByStatus',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.tap(find.byKey(const Key('status_chip_draft')));
      await tester.pump();

      verify(() => mockExpensesCubit.filterByStatus('draft')).called(1);

      await tester.tap(find.byKey(const Key('status_chip_posted')));
      await tester.pump();

      verify(() => mockExpensesCubit.filterByStatus('posted')).called(1);
    });

    testWidgets('tapping expense card navigates to detail route',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: ExpensesState(
            status: LoadStatus.success,
            expenses: [tExpense1],
          ),
        ),
      );

      await tester.tap(find.text('EXP-2026-0001'));
      await tester.pumpAndSettle();

      expect(find.text('Expense Detail Destination exp-1'), findsOneWidget);
    });
  });
}
