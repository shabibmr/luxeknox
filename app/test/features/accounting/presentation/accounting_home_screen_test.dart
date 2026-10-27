import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/accounting_period.dart';
import 'package:luxeknox/features/accounting/domain/entities/accounting_reports.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounting_home_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/accounting_home_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingHomeCubit extends MockCubit<AccountingHomeState>
    implements AccountingHomeCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

Widget wrapHome({List<String> slugs = const [], GoRouter? router}) {
  final sessionCubit = MockSessionCubit();
  whenListen(
    sessionCubit,
    const Stream<SessionState>.empty(),
    initialState: SessionAuthenticated(
      principal: const Principal(
        userId: '1',
        userType: UserType.admin,
        displayName: 'Admin User',
        profileId: 'p1',
      ),
      capabilities: Capabilities(slugs: slugs),
    ),
  );
  return BlocProvider<SessionCubit>.value(
    value: sessionCubit,
    child: router != null
        ? MaterialApp.router(routerConfig: router)
        : const MaterialApp(home: AccountingHomeScreen()),
  );
}

void main() {
  late MockAccountingHomeCubit mockCubit;

  final tDate = DateTime.utc(2026, 1, 1);

  final tPeriod = AccountingPeriod(
    id: '1',
    fiscalYearId: '1',
    periodNumber: 1,
    name: 'Jan 2026',
    startDate: tDate,
    endDate: tDate,
    isLocked: false,
  );

  const tArReport = OpenItemsReport(
    kind: 'ar',
    totalOpenAmount: '2500.00',
    items: [],
  );

  const tApReport = OpenItemsReport(
    kind: 'ap',
    totalOpenAmount: '1200.00',
    items: [],
  );

  const tBankAccount = Account(
    id: '1',
    name: 'Bank of Baroda',
    type: 'asset',
    isBank: true,
    isActive: true,
  );

  setUp(() {
    mockCubit = MockAccountingHomeCubit();
    when(() => mockCubit.load()).thenAnswer((_) async {});

    if (getIt.isRegistered<AccountingHomeCubit>()) {
      getIt.unregister<AccountingHomeCubit>();
    }
    getIt.registerFactory<AccountingHomeCubit>(() => mockCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<AccountingHomeCubit>()) {
      getIt.unregister<AccountingHomeCubit>();
    }
  });

  testWidgets('renders AppLoading when state is loading without data', (
    tester,
  ) async {
    when(
      () => mockCubit.state,
    ).thenReturn(const AccountingHomeState(status: LoadStatus.loading));

    await tester.pumpWidget(wrapHome());

    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('renders AppErrorView when state is failure without data', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingHomeState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
    );

    await tester.pumpWidget(wrapHome());

    expect(find.byType(AppErrorView), findsOneWidget);

    // Tapping retry calls load
    await tester.tap(
      find.widgetWithText(FilledButton, AccountingStrings.retry),
    );
    verify(() => mockCubit.load()).called(greaterThanOrEqualTo(1));
  });

  testWidgets('renders AppEmptyView when state is success with no data', (
    tester,
  ) async {
    when(
      () => mockCubit.state,
    ).thenReturn(const AccountingHomeState(status: LoadStatus.success));

    await tester.pumpWidget(wrapHome());

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noneFound), findsOneWidget);
  });

  testWidgets(
    'renders populated dashboard cards and sections when data exists',
    (tester) async {
      when(() => mockCubit.state).thenReturn(
        AccountingHomeState(
          status: LoadStatus.success,
          currentPeriod: tPeriod,
          openAr: tArReport,
          openAp: tApReport,
          bankAndCashAccounts: const [tBankAccount],
        ),
      );

      await tester.pumpWidget(wrapHome());

      // Check title in AppBar
      expect(find.text(AccountingStrings.homeTitle), findsOneWidget);

      // Check current period section
      expect(find.text(AccountingStrings.currentPeriod), findsOneWidget);
      expect(find.text(AccountingStrings.periodOpenBadge), findsOneWidget);

      // Check AR / AP summary
      expect(find.text(AccountingStrings.openReceivables), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('2500.00')), findsOneWidget);
      expect(find.text(AccountingStrings.openPayables), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('1200.00')), findsOneWidget);

      // Check Bank accounts
      expect(find.text(AccountingStrings.cashAndBank), findsOneWidget);
      expect(find.text('Bank of Baroda'), findsOneWidget);

      // Check Quick actions
      expect(find.text(AccountingStrings.quickActions), findsOneWidget);

      // Tap refresh icon in AppBar
      final refreshBtn = find.byIcon(Icons.refresh);
      expect(refreshBtn, findsOneWidget);
      await tester.tap(refreshBtn);
      verify(() => mockCubit.load()).called(greaterThanOrEqualTo(1));
    },
  );

  testWidgets('renders periodLockedBadge when current period is locked', (
    tester,
  ) async {
    final tLockedPeriod = AccountingPeriod(
      id: '2',
      fiscalYearId: '1',
      periodNumber: 2,
      name: 'Feb 2026',
      startDate: tDate,
      endDate: tDate,
      isLocked: true,
    );

    when(() => mockCubit.state).thenReturn(
      AccountingHomeState(
        status: LoadStatus.success,
        currentPeriod: tLockedPeriod,
      ),
    );

    await tester.pumpWidget(wrapHome());

    expect(find.text(AccountingStrings.currentPeriod), findsOneWidget);
    expect(find.text('Feb 2026'), findsOneWidget);
    expect(find.text(AccountingStrings.periodLockedBadge), findsOneWidget);
    expect(find.text(AccountingStrings.periodOpenBadge), findsNothing);
  });

  testWidgets(
    'renders draft documents warning banner when period has draft documents',
    (tester) async {
      final tPeriodWithDrafts = AccountingPeriod(
        id: '1',
        fiscalYearId: '1',
        periodNumber: 1,
        name: 'Jan 2026',
        startDate: tDate,
        endDate: tDate,
        isLocked: false,
        draftCounts: const DraftDocumentCounts(
          billsCount: 3,
          expensesCount: 0,
          paymentVouchersCount: 1,
          debitNotesCount: 0,
        ),
      );

      when(() => mockCubit.state).thenReturn(
        AccountingHomeState(
          status: LoadStatus.success,
          currentPeriod: tPeriodWithDrafts,
        ),
      );

      await tester.pumpWidget(wrapHome());

      expect(
        find.text(AccountingStrings.draftDocumentsWarning),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'does not render draft warning banner when draftCounts has no pending drafts',
    (tester) async {
      final tPeriodNoDrafts = AccountingPeriod(
        id: '1',
        fiscalYearId: '1',
        periodNumber: 1,
        name: 'Jan 2026',
        startDate: tDate,
        endDate: tDate,
        isLocked: false,
        draftCounts: const DraftDocumentCounts(
          billsCount: 0,
          expensesCount: 0,
          paymentVouchersCount: 0,
          debitNotesCount: 0,
        ),
      );

      when(() => mockCubit.state).thenReturn(
        AccountingHomeState(
          status: LoadStatus.success,
          currentPeriod: tPeriodNoDrafts,
        ),
      );

      await tester.pumpWidget(wrapHome());

      expect(find.text(AccountingStrings.draftDocumentsWarning), findsNothing);
    },
  );

  testWidgets(
    'renders cash and bank accounts with distinct icons based on name',
    (tester) async {
      const tCashByName = Account(
        id: 'c2',
        name: 'Petty Cash',
        type: 'asset',
        isBank: true,
        isActive: true,
      );

      const tBank = Account(
        id: 'b1',
        name: 'HDFC Current Account',
        type: 'asset',
        isBank: true,
        isActive: true,
      );

      const tBankNoCashInName = Account(
        id: 'c1',
        name: 'Main Safe',
        type: 'asset',
        isBank: true,
        isActive: true,
      );

      when(() => mockCubit.state).thenReturn(
        const AccountingHomeState(
          status: LoadStatus.success,
          bankAndCashAccounts: [tBankNoCashInName, tCashByName, tBank],
        ),
      );

      await tester.pumpWidget(wrapHome());

      expect(find.text(AccountingStrings.cashAndBank), findsOneWidget);
      expect(find.text('Main Safe'), findsOneWidget);
      expect(find.text('Petty Cash'), findsOneWidget);
      expect(find.text('HDFC Current Account'), findsOneWidget);

      // Cash heuristic: isBank && name contains "cash" (list tile icons are size 20)
      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.payments_outlined && w.size == 20,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.account_balance && w.size == 20,
        ),
        findsNWidgets(2),
      );
    },
  );

  testWidgets('pull to refresh invokes cubit load', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingHomeState(status: LoadStatus.success, currentPeriod: tPeriod),
    );

    await tester.pumpWidget(wrapHome());

    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    verify(() => mockCubit.load()).called(greaterThanOrEqualTo(1));
  });

  group('Items quick action', () {
    setUp(() {
      when(() => mockCubit.state).thenReturn(
        AccountingHomeState(
          status: LoadStatus.success,
          currentPeriod: tPeriod,
          openAr: tArReport,
          openAp: tApReport,
          bankAndCashAccounts: const [tBankAccount],
        ),
      );
    });

    testWidgets('is visible with inventory.read', (tester) async {
      await tester.pumpWidget(wrapHome(slugs: const ['inventory.read']));
      expect(
        find.widgetWithText(ActionChip, AccountingStrings.itemsTitle),
        findsOneWidget,
      );
    });

    testWidgets('is hidden without inventory.read', (tester) async {
      await tester.pumpWidget(wrapHome(slugs: const ['accounting.read']));
      expect(
        find.widgetWithText(ActionChip, AccountingStrings.itemsTitle),
        findsNothing,
      );
    });

    testWidgets('tap navigates to the items route', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const AccountingHomeScreen()),
          GoRoute(
            path: Routes.adminAccountingItems,
            builder: (_, _) => const Text('items-list'),
          ),
        ],
      );
      await tester.pumpWidget(
        wrapHome(slugs: const ['inventory.read'], router: router),
      );
      await tester.tap(
        find.widgetWithText(ActionChip, AccountingStrings.itemsTitle),
      );
      await tester.pumpAndSettle();
      expect(find.text('items-list'), findsOneWidget);
    });
  });
}
