import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/accounting_reports.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounting_reports_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/accounting_reports_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingReportsCubit extends MockCubit<AccountingReportsState>
    implements AccountingReportsCubit {}

void main() {
  late MockAccountingReportsCubit mockCubit;

  final tDate = DateTime.utc(2026, 4, 30);
  final tFrom = DateTime.utc(2026, 4, 1);

  final tTrialBalance = TrialBalanceReport(
    fromDate: tFrom,
    toDate: tDate,
    totalDebit: '1500.00',
    totalCredit: '1500.00',
    accounts: const [
      TrialBalanceAccountItem(
        accountId: '1',
        accountCode: '1000',
        accountName: 'Cash',
        debit: '1500.00',
        credit: '0.00',
      ),
      TrialBalanceAccountItem(
        accountId: '2',
        accountCode: '2000',
        accountName: 'Payables',
        debit: '0.00',
        credit: '1500.00',
      ),
    ],
  );

  final tProfitAndLoss = ProfitAndLossReport(
    fromDate: tFrom,
    toDate: tDate,
    totalIncome: '900.00',
    totalExpense: '300.00',
    netProfit: '600.00',
    incomeAccounts: const [
      ReportAccountItem(
        accountId: '3',
        accountCode: '4000',
        accountName: 'Membership Income',
        amount: '900.00',
      ),
    ],
    expenseAccounts: const [
      ReportAccountItem(
        accountId: '4',
        accountCode: '5000',
        accountName: 'Rent',
        amount: '300.00',
      ),
    ],
  );

  final tBalanceSheet = BalanceSheetReport(
    asOfDate: tDate,
    fiscalYearStart: DateTime.utc(2026, 4, 1),
    totalAssets: '2000.00',
    totalLiabilities: '800.00',
    totalEquity: '1200.00',
    currentYearEarnings: '600.00',
    totalLiabilitiesAndEquity: '2000.00',
    assetAccounts: const [
      ReportAccountItem(
        accountId: '1',
        accountCode: '1000',
        accountName: 'Cash',
        amount: '2000.00',
      ),
    ],
    liabilityAccounts: const [
      ReportAccountItem(
        accountId: '2',
        accountCode: '2000',
        accountName: 'Payables',
        amount: '800.00',
      ),
    ],
    equityAccounts: const [
      ReportAccountItem(
        accountId: '5',
        accountCode: '3000',
        accountName: 'Capital',
        amount: '600.00',
      ),
    ],
  );

  final tDayBook = DayBookReport(
    date: tDate,
    totalDebit: '250.00',
    totalCredit: '250.00',
    journals: [
      DayBookJournalItem(
        journalId: 'j-1',
        journalNumber: 'J-2026-0009',
        date: tDate,
        memo: 'Expense post',
        lines: const [
          DayBookLineItem(
            id: 'l-1',
            accountId: '4',
            accountCode: '5000',
            accountName: 'Rent',
            debit: '250.00',
            credit: '0.00',
          ),
          DayBookLineItem(
            id: 'l-2',
            accountId: '1',
            accountCode: '1000',
            accountName: 'Cash',
            debit: '0.00',
            credit: '250.00',
          ),
        ],
      ),
    ],
  );

  final tGstSummary = GstSummaryReport(
    fromDate: tFrom,
    toDate: tDate,
    totalTaxableValue: '1000.00',
    outputCgst: '90.00',
    outputSgst: '90.00',
    outputIgst: '0.00',
    totalOutputTax: '180.00',
    totalInputTax: '45.00',
    netTaxPayable: '135.00',
    codeSummaries: const [
      GstTaxCodeSummary(
        taxCodeId: 'tc-1',
        taxCodeName: 'GST 18%',
        ratePercent: '18.00',
        taxableValue: '1000.00',
        cgstAmount: '90.00',
        sgstAmount: '90.00',
        igstAmount: '0.00',
        totalTax: '180.00',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(AccountingReportType.trialBalance);
    registerFallbackValue(DateTime.utc(2026, 1, 1));
  });

  setUp(() {
    mockCubit = MockAccountingReportsCubit();
    when(() => mockCubit.load()).thenAnswer((_) async {});
    when(() => mockCubit.selectReportType(any())).thenAnswer((_) async {});
    when(
      () => mockCubit.setDateRange(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((_) async {});
  });

  Widget buildWidget(AccountingReportsCubit cubit) {
    return MaterialApp(
      home: AccountingReportsScreen(cubit: cubit),
    );
  }

  testWidgets('renders AppLoading when loading without a report', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingReportsState(status: LoadStatus.loading),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byType(AppLoading), findsOneWidget);
  });

  testWidgets('renders AppErrorView when failure without a report', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      const AccountingReportsState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byType(AppErrorView), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, AccountingStrings.retry));
    verify(() => mockCubit.load()).called(greaterThanOrEqualTo(1));
  });

  testWidgets('renders empty state and totals for trial balance with no rows', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.trialBalance,
        fromDate: tFrom,
        toDate: tDate,
        trialBalance: TrialBalanceReport(
          fromDate: tFrom,
          toDate: tDate,
          totalDebit: '0.00',
          totalCredit: '0.00',
        ),
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noReportData), findsOneWidget);
    expect(find.text(AccountingStrings.formatMoney('0.00')), findsNWidgets(2));
  });

  testWidgets('trial balance totals and account rows match report values', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.trialBalance,
        fromDate: tFrom,
        toDate: tDate,
        trialBalance: tTrialBalance,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Payables'), findsOneWidget);
    expect(
      find.text(AccountingStrings.formatMoney('1500.00')),
      findsWidgets,
    );
  });

  testWidgets('profit and loss totals match report values', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.profitAndLoss,
        fromDate: tFrom,
        toDate: tDate,
        profitAndLoss: tProfitAndLoss,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text('Membership Income'), findsOneWidget);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text(AccountingStrings.formatMoney('900.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('300.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('600.00')), findsWidgets);
  });

  testWidgets('balance sheet totals match report values', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.balanceSheet,
        toDate: tDate,
        balanceSheet: tBalanceSheet,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text(AccountingStrings.formatMoney('2000.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('800.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('1200.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('600.00')), findsWidgets);
    expect(find.textContaining('2026-04-01'), findsOneWidget);
  });

  testWidgets('day book shows journal lines and debit/credit totals', (
    tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.dayBook,
        toDate: tDate,
        dayBook: tDayBook,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text('J-2026-0009'), findsOneWidget);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text(AccountingStrings.formatMoney('250.00')), findsWidgets);
  });

  testWidgets('gst summary totals match report values', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.gstSummary,
        fromDate: tFrom,
        toDate: tDate,
        gstSummary: tGstSummary,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text('GST 18%'), findsOneWidget);
    expect(find.text(AccountingStrings.formatMoney('1000.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('180.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('45.00')), findsWidgets);
    expect(find.text(AccountingStrings.formatMoney('135.00')), findsWidgets);
  });

  testWidgets('report type chip selects profit and loss', (tester) async {
    when(() => mockCubit.state).thenReturn(
      AccountingReportsState(
        status: LoadStatus.success,
        selectedReportType: AccountingReportType.trialBalance,
        fromDate: tFrom,
        toDate: tDate,
        trialBalance: tTrialBalance,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));
    await tester.tap(find.byKey(const Key('report_type_chip_profitAndLoss')));
    await tester.pump();

    verify(
      () => mockCubit.selectReportType(AccountingReportType.profitAndLoss),
    ).called(1);
  });
}
