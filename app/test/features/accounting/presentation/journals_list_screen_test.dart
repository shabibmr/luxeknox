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
import 'package:luxeknox/features/accounting/domain/entities/journal.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/journals_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/journals_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalsCubit extends MockCubit<JournalsState>
    implements JournalsCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockJournalsCubit mockJournalsCubit;
  late MockSessionCubit mockSessionCubit;

  final tPostedJournal = Journal(
    id: 'j-1',
    journalNumber: 'J-2026-0001',
    entryDate: DateTime(2026, 3, 1),
    sourceType: 'manual',
    memo: 'Monthly rent accrual',
    status: 'posted',
    lines: const [
      JournalLine(
        id: 'l-1',
        journalId: 'j-1',
        accountId: 'acc-1',
        debit: '1500.00',
        credit: '0.00',
      ),
      JournalLine(
        id: 'l-2',
        journalId: 'j-1',
        accountId: 'acc-2',
        debit: '0.00',
        credit: '1500.00',
      ),
    ],
  );

  final tReversedOpeningJournal = Journal(
    id: 'j-2',
    journalNumber: 'J-2026-0002',
    entryDate: DateTime(2026, 3, 2),
    sourceType: 'opening_balance',
    status: 'reversed',
    reversesJournalId: 'j-1',
    isOpening: true,
    memo: 'Initial balance transfer',
    lines: const [],
  );

  final tClosingJournal = Journal(
    id: 'j-3',
    journalNumber: 'J-2026-0003',
    entryDate: DateTime(2026, 3, 3),
    sourceType: 'sales_invoice',
    status: 'draft',
    isClosing: true,
    lines: const [],
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.journals_write'],
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
    mockJournalsCubit = MockJournalsCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockJournalsCubit.load(
          from: any(named: 'from'),
          to: any(named: 'to'),
          paymentId: any(named: 'paymentId'),
          sourceType: any(named: 'sourceType'),
          clearDates: any(named: 'clearDates'),
          clearPaymentId: any(named: 'clearPaymentId'),
          clearSourceType: any(named: 'clearSourceType'),
        )).thenAnswer((_) async {});
    when(() => mockJournalsCubit.filterByDateRange(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockJournalsCubit.filterByPaymentId(any()))
        .thenAnswer((_) async {});
    when(() => mockJournalsCubit.filterBySourceType(any()))
        .thenAnswer((_) async {});
    when(() => mockJournalsCubit.clearFilters())
        .thenAnswer((_) async {});

    if (getIt.isRegistered<JournalsCubit>()) {
      getIt.unregister<JournalsCubit>();
    }
    getIt.registerFactory<JournalsCubit>(() => mockJournalsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<JournalsCubit>()) {
      getIt.unregister<JournalsCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    JournalsState state = const JournalsState(
      status: LoadStatus.success,
      journals: [],
    ),
    JournalsCubit? cubit,
    String? initialPaymentId,
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
      mockJournalsCubit,
      const Stream<JournalsState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: JournalsListScreen(
              cubit: cubit ?? mockJournalsCubit,
              initialPaymentId: initialPaymentId,
            ),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingJournalsCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Journal Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/journals/:id',
          builder: (context, routerState) => Scaffold(
            body: Text(
                'Journal Detail Destination ${routerState.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets(
      'renders journal entries with number, date, status, source type, and badges',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: JournalsState(
          status: LoadStatus.success,
          journals: [tPostedJournal, tReversedOpeningJournal, tClosingJournal],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify journal numbers and dates
    expect(find.text('J-2026-0001'), findsOneWidget);
    expect(find.text('2026-03-01'), findsOneWidget);
    expect(find.text('J-2026-0002'), findsOneWidget);
    expect(find.text('2026-03-02'), findsOneWidget);
    expect(find.text('J-2026-0003'), findsOneWidget);
    expect(find.text('2026-03-03'), findsOneWidget);

    // Verify status chips
    expect(find.widgetWithText(AppStatusChip, 'posted'), findsOneWidget);
    expect(find.widgetWithText(AppStatusChip, 'reversed'), findsOneWidget);
    expect(find.widgetWithText(AppStatusChip, 'draft'), findsOneWidget);

    // Verify source type chips on cards
    expect(find.widgetWithText(AppStatusChip, 'manual'), findsOneWidget);
    expect(find.widgetWithText(AppStatusChip, 'opening_balance'), findsOneWidget);
    expect(find.widgetWithText(AppStatusChip, 'sales_invoice'), findsOneWidget);

    // Verify memo
    expect(find.text('Monthly rent accrual'), findsOneWidget);

    // Verify debit amount and lines count
    expect(find.text(AccountingStrings.formatAmount(1500.0)), findsOneWidget);
    expect(find.text('2 lines'), findsOneWidget);

    // Verify reversed badge
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.statusReversed),
      findsAtLeastNWidgets(1),
    );

    // Verify opening badge
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.openingBadge),
      findsOneWidget,
    );

    // Verify closing badge
    expect(
      find.widgetWithText(AppStatusChip, AccountingStrings.closingBadge),
      findsOneWidget,
    );
  });

  testWidgets(
      'create button is visible and navigates to create route when user has accounting.journals_write',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(capabilities: writeCapabilities),
    );
    await tester.pumpAndSettle();

    final fab = find.byKey(const Key('create_journal_button'));
    final appbarBtn = find.byKey(const Key('appbar_create_journal_button'));
    expect(fab, findsOneWidget);
    expect(appbarBtn, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();
    expect(find.text('Create Journal Destination'), findsOneWidget);
  });

  testWidgets(
      'appbar create button navigates to create route when tapped',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(capabilities: writeCapabilities),
    );
    await tester.pumpAndSettle();

    final appbarBtn = find.byKey(const Key('appbar_create_journal_button'));
    expect(appbarBtn, findsOneWidget);

    await tester.tap(appbarBtn);
    await tester.pumpAndSettle();
    expect(find.text('Create Journal Destination'), findsOneWidget);
  });

  testWidgets(
      'create button is hidden when user lacks accounting.journals_write',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(capabilities: readOnlyCapabilities),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('create_journal_button')), findsNothing);
    expect(find.byKey(const Key('appbar_create_journal_button')), findsNothing);
  });

  testWidgets('tapping a journal card navigates to journal detail route',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: JournalsState(
          status: LoadStatus.success,
          journals: [tPostedJournal],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final card = find.widgetWithText(Card, 'J-2026-0001');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('Journal Detail Destination j-1'), findsOneWidget);
  });

  testWidgets('source type filter chips trigger cubit.filterBySourceType',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: JournalsState(
          status: LoadStatus.success,
          journals: [tPostedJournal],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap 'manual' filter chip
    await tester.tap(find.byKey(const Key('source_chip_manual')));
    await tester.pump();
    verify(() => mockJournalsCubit.filterBySourceType('manual')).called(1);

    // Tap 'All' filter chip
    await tester.tap(find.byKey(const Key('source_chip_all')));
    await tester.pump();
    verify(() => mockJournalsCubit.filterBySourceType(null)).called(1);
  });

  testWidgets('date range picker triggers cubit.filterByDateRange',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: JournalsState(
          status: LoadStatus.success,
          journals: [tPostedJournal],
          fromDate: DateTime(2026, 3, 1),
          toDate: DateTime(2026, 3, 15),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify date range chip shows dates
    final dateChip = find.byKey(const Key('date_range_filter_chip'));
    expect(dateChip, findsOneWidget);
    expect(find.text('2026-03-01 - 2026-03-15'), findsOneWidget);

    // Tap date range chip to open DateRangePickerDialog
    await tester.tap(dateChip);
    await tester.pumpAndSettle();

    expect(find.byType(DateRangePickerDialog), findsOneWidget);

    // Tap 'Save' on the dialog to confirm the range
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    verify(() => mockJournalsCubit.filterByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 15),
        )).called(1);
  });

  testWidgets('clear filters button triggers cubit.clearFilters',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const JournalsState(
          status: LoadStatus.success,
          journals: [],
          sourceType: 'manual',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final clearBtn = find.byKey(const Key('clear_filters_button'));
    expect(clearBtn, findsOneWidget);
    expect(find.text(AccountingStrings.clearFilter), findsOneWidget);

    await tester.tap(clearBtn);
    await tester.pump();

    verify(() => mockJournalsCubit.clearFilters()).called(1);
  });

  testWidgets(
      'payment ID filter chip renders and onDeleted triggers filterByPaymentId(null)',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const JournalsState(
          status: LoadStatus.success,
          journals: [],
          paymentId: 'pay_12345',
        ),
        initialPaymentId: 'pay_12345',
      ),
    );
    await tester.pumpAndSettle();

    final chip = find.byKey(const Key('payment_id_filter_chip'));
    expect(chip, findsOneWidget);
    expect(find.text('${AccountingStrings.filterByPaymentId}: pay_12345'),
        findsOneWidget);

    // Tap the delete icon on the InputChip
    final chipRect = tester.getRect(chip);
    await tester.tapAt(Offset(chipRect.right - 14, chipRect.center.dy));
    await tester.pump();

    verify(() => mockJournalsCubit.filterByPaymentId(null)).called(1);
  });

  testWidgets('handles loading state with AppLoading', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const JournalsState(
          status: LoadStatus.loading,
          journals: [],
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
        state: const JournalsState(
          status: LoadStatus.failure,
          journals: [],
          failure: NetworkFailure(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);

    await tester.tap(find.text(AccountingStrings.retry));
    await tester.pump();

    verify(() => mockJournalsCubit.load()).called(1);
  });

  testWidgets('handles empty state with AppEmptyView', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: const JournalsState(
          status: LoadStatus.success,
          journals: [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(AccountingStrings.noneFound), findsOneWidget);
  });

  testWidgets('appbar refresh button triggers cubit.load', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        state: JournalsState(
          status: LoadStatus.success,
          journals: [tPostedJournal],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final refreshButton = find.byTooltip(AccountingStrings.refresh);
    expect(refreshButton, findsOneWidget);

    await tester.tap(refreshButton);
    await tester.pump();

    verify(() => mockJournalsCubit.load()).called(1);
  });

  testWidgets('creates cubit via getIt when cubit parameter is omitted',
      (tester) async {
    whenListen(
      mockJournalsCubit,
      const Stream<JournalsState>.empty(),
      initialState: const JournalsState(status: LoadStatus.success),
    );

    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: tPrincipal,
        capabilities: writeCapabilities,
      ),
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: const JournalsListScreen(initialPaymentId: 'pay_init'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    verify(() => mockJournalsCubit.load(paymentId: 'pay_init')).called(1);
  });
}
