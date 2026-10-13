import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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
    code: '1000',
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

  testWidgets('renders AppLoading when state is loading without data', (tester) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingHomeState(status: LoadStatus.loading),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountingHomeScreen(),
      ),
    );

    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('renders AppErrorView when state is failure without data', (tester) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingHomeState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountingHomeScreen(),
      ),
    );

    expect(find.byType(AppErrorView), findsOneWidget);

    // Tapping retry calls load
    await tester.tap(find.widgetWithText(FilledButton, AccountingStrings.retry));
    verify(() => mockCubit.load()).called(greaterThanOrEqualTo(1));
  });

  testWidgets('renders AppEmptyView when state is success with no data', (tester) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingHomeState(status: LoadStatus.success),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountingHomeScreen(),
      ),
    );

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noneFound), findsOneWidget);
  });

  testWidgets('renders populated dashboard cards and sections when data exists', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingHomeState(
        status: LoadStatus.success,
        currentPeriod: tPeriod,
        openAr: tArReport,
        openAp: tApReport,
        bankAndCashAccounts: const [tBankAccount],
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountingHomeScreen(),
      ),
    );

    // Check title in AppBar
    expect(find.text(AccountingStrings.homeTitle), findsOneWidget);

    // Check current period section
    expect(find.text(AccountingStrings.currentPeriod), findsOneWidget);
    expect(find.text(AccountingStrings.periodOpenBadge), findsOneWidget);

    // Check AR / AP summary
    expect(find.text(AccountingStrings.openReceivables), findsOneWidget);
    expect(find.text('\$2500.00'), findsOneWidget);
    expect(find.text(AccountingStrings.openPayables), findsOneWidget);
    expect(find.text('\$1200.00'), findsOneWidget);

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
  });
}
