import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/core/widgets/app_status_chip.dart';
import 'package:luxeknox/features/accounting/domain/entities/journal.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/journal_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/journal_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalDetailCubit extends MockCubit<JournalDetailState>
    implements JournalDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockJournalDetailCubit mockJournalDetailCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  const tLine1 = JournalLine(
    id: 'jl-1',
    journalId: 'j-100',
    accountId: 'acc-1',
    accountCode: '1000',
    accountName: 'Operating Bank Account',
    debit: '150.00',
    credit: '0.00',
    description: 'Deposit payment',
  );

  const tLine2 = JournalLine(
    id: 'jl-2',
    journalId: 'j-100',
    accountId: 'acc-2',
    accountCode: '4000',
    accountName: 'Membership Income',
    debit: '0.00',
    credit: '150.00',
    description: 'Membership revenue',
  );

  final tJournal = Journal(
    id: 'j-100',
    journalNumber: 'JRN-2026-0100',
    entryDate: tDate,
    sourceType: 'payment',
    sourceId: 'pay-777',
    memo: 'October monthly membership deposit',
    status: 'posted',
    isOpening: true,
    isClosing: false,
    lines: const [tLine1, tLine2],
  );

  final tReversedJournal = Journal(
    id: 'j-101',
    journalNumber: 'JRN-2026-0101',
    entryDate: tDate,
    sourceType: 'manual',
    sourceId: 'pay-777',
    memo: 'Reversal of JRN-2026-0100',
    status: 'reversed',
    reversesJournalId: 'j-100',
    lines: const [
      JournalLine(
        id: 'jl-3',
        journalId: 'j-101',
        accountId: 'acc-1',
        accountCode: '1000',
        accountName: 'Operating Bank Account',
        debit: '0.00',
        credit: '150.00',
        description: 'Offsetting entry',
      ),
      JournalLine(
        id: 'jl-4',
        journalId: 'j-101',
        accountId: 'acc-2',
        accountCode: '4000',
        accountName: 'Membership Income',
        debit: '150.00',
        credit: '0.00',
        description: 'Offsetting entry',
      ),
    ],
  );

  final tClosingJournal = Journal(
    id: 'j-102',
    journalNumber: 'JRN-2026-0102',
    entryDate: tDate,
    status: 'posted',
    isClosing: true,
    lines: const [tLine1, tLine2],
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.journals_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['accounting.read'],
  );
  const noCapabilities = Capabilities(
    slugs: [],
  );

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUpAll(() {
    registerFallbackValue(tJournal);
  });

  setUp(() {
    mockJournalDetailCubit = MockJournalDetailCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockJournalDetailCubit.load(any()))
        .thenAnswer((_) async {});
    when(
      () => mockJournalDetailCubit.reverse(
        entryDate: any(named: 'entryDate'),
        memo: any(named: 'memo'),
      ),
    ).thenAnswer((_) async => true);
    when(() => mockJournalDetailCubit.setJournal(any()))
        .thenReturn(null);

    if (getIt.isRegistered<JournalDetailCubit>()) {
      getIt.unregister<JournalDetailCubit>();
    }
    getIt.registerFactory<JournalDetailCubit>(() => mockJournalDetailCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<JournalDetailCubit>()) {
      getIt.unregister<JournalDetailCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    JournalDetailState state = const JournalDetailState(
      status: LoadStatus.success,
    ),
    JournalDetailCubit? cubit,
    String journalId = 'j-100',
    Journal? initialJournal,
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
      mockJournalDetailCubit,
      const Stream<JournalDetailState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: JournalDetailScreen(
          journalId: journalId,
          cubit: cubit ?? mockJournalDetailCubit,
          initialJournal: initialJournal,
        ),
      ),
    );
  }

  group('Permission check', () {
    testWidgets('displays no permission when user lacks accounting.read',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: noCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.text('JRN-2026-0100'), findsNothing);
      expect(find.byKey(const Key('reverse_journal_button')), findsNothing);
    });
  });

  group('Journal Details rendering', () {
    testWidgets(
        'renders journal header, badges, and line items with debits and credits totals',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Screen title
      expect(find.text(AccountingStrings.journalDetailTitle), findsOneWidget);

      // Header section: Journal number
      expect(find.text('JRN-2026-0100'), findsOneWidget);

      // Entry Date formatted yyyy-MM-dd
      expect(find.text('2026-10-15'), findsOneWidget);
      expect(find.text('${AccountingStrings.entryDateLabel}: '), findsOneWidget);

      // Status chip
      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.statusPosted),
        findsOneWidget,
      );

      // Opening badge
      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.openingBadge),
        findsOneWidget,
      );

      // Source type and ID
      expect(find.text('payment'), findsOneWidget);
      expect(find.text('pay-777'), findsOneWidget);

      // Memo
      expect(
        find.text('October monthly membership deposit'),
        findsOneWidget,
      );

      // Line items: Account codes and names
      expect(find.text('1000'), findsOneWidget);
      expect(find.text('Operating Bank Account'), findsOneWidget);
      expect(find.text('4000'), findsOneWidget);
      expect(find.text('Membership Income'), findsOneWidget);

      // Descriptions
      expect(find.text('Deposit payment'), findsOneWidget);
      expect(find.text('Membership revenue'), findsOneWidget);

      // Line debit and credit amounts ($150.00)
      expect(
        find.text(AccountingStrings.formatAmount(150.0)),
        findsAtLeastNWidgets(2),
      );

      // Totals row: labels and amounts
      expect(find.text(AccountingStrings.totalDebit), findsOneWidget);
      expect(find.text(AccountingStrings.totalCredit), findsOneWidget);
      expect(find.byKey(const Key('total_debit_amount')), findsOneWidget);
      expect(find.byKey(const Key('total_credit_amount')), findsOneWidget);
    });

    testWidgets('renders closing badge when isClosing is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tClosingJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.closingBadge),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders reverses journal badge when reversesJournalId is present',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tReversedJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Reverses Journal ID: j-100'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.statusReversed),
        findsOneWidget,
      );
    });
  });

  group('Reverse action button visibility', () {
    testWidgets(
        'reverse button is shown when write capability is present and journal is not reversed',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reverse_journal_button')), findsOneWidget);
      expect(find.text(AccountingStrings.reverse), findsOneWidget);
    });

    testWidgets('reverse button is hidden when user has read-only capability',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reverse_journal_button')), findsNothing);
    });

    testWidgets('reverse button is hidden when journal is already reversed',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tReversedJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reverse_journal_button')), findsNothing);
    });
  });

  group('Reverse confirmation dialog', () {
    testWidgets(
        'clicking reverse shows dialog and confirming triggers cubit.reverse',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap reverse button in AppBar
      final reverseButton = find.byKey(const Key('reverse_journal_button'));
      expect(reverseButton, findsOneWidget);
      await tester.tap(reverseButton);
      await tester.pumpAndSettle();

      // Dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(AccountingStrings.reverseJournalConfirm), findsOneWidget);
      expect(find.text(AccountingStrings.reversalDateLabel), findsOneWidget);
      expect(find.text(AccountingStrings.reversalMemoLabel), findsOneWidget);
      expect(find.text(AccountingStrings.cancel), findsOneWidget);
      expect(find.text(AccountingStrings.confirm), findsOneWidget);

      // Enter reversal memo
      final memoField = find.byKey(const Key('reversal_memo_field'));
      await tester.enterText(memoField, 'Accidental duplicate entry');
      await tester.pump();

      // Confirm
      await tester.tap(find.byKey(const Key('reversal_confirm_button')));
      await tester.pumpAndSettle();

      // Verify cubit.reverse is called with the entered memo
      verify(
        () => mockJournalDetailCubit.reverse(
          entryDate: any(named: 'entryDate'),
          memo: 'Accidental duplicate entry',
        ),
      ).called(1);
    });

    testWidgets('cancelling reverse dialog does not trigger cubit.reverse',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('reverse_journal_button')));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.byKey(const Key('reversal_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(
        () => mockJournalDetailCubit.reverse(
          entryDate: any(named: 'entryDate'),
          memo: any(named: 'memo'),
        ),
      );
    });
  });

  group('Loading and Error states', () {
    testWidgets('handles loading state', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const JournalDetailState(
            status: LoadStatus.loading,
            journal: null,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('handles error state and retry invokes cubit.load',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const JournalDetailState(
            status: LoadStatus.failure,
            failure: NetworkFailure(),
            journal: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);

      // Tap retry
      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockJournalDetailCubit.load('j-100')).called(1);
    });
  });

  group('Notifications via SnackBar', () {
    testWidgets('shows success snackbar when reversal succeeds',
        (tester) async {
      final stateController = Stream<JournalDetailState>.fromIterable([
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tReversedJournal,
          reversalSuccess: tReversedJournal,
        ),
      ]);

      whenListen(
        mockJournalDetailCubit,
        stateController,
        initialState: JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
      );

      whenListen(
        mockSessionCubit,
        const Stream<SessionState>.empty(),
        initialState: const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: writeCapabilities,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: JournalDetailScreen(
              journalId: 'j-100',
              cubit: mockJournalDetailCubit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(AccountingStrings.journalReversedSuccess),
        findsOneWidget,
      );
    });

    testWidgets('shows failure snackbar when reversal fails', (tester) async {
      final stateController = Stream<JournalDetailState>.fromIterable([
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
          failure: const BusinessRuleFailure('Period is locked'),
        ),
      ]);

      whenListen(
        mockJournalDetailCubit,
        stateController,
        initialState: JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
      );

      whenListen(
        mockSessionCubit,
        const Stream<SessionState>.empty(),
        initialState: const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: writeCapabilities,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: JournalDetailScreen(
              journalId: 'j-100',
              cubit: mockJournalDetailCubit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Period is locked'), findsOneWidget);
    });
  });

  group('Pull-to-refresh', () {
    testWidgets('pull to refresh invokes cubit.load', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: JournalDetailState(
            status: LoadStatus.success,
            journal: tJournal,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.fling(
        find.text('JRN-2026-0100'),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => mockJournalDetailCubit.load('j-100')).called(1);
    });
  });

  group('initialJournal support', () {
    testWidgets(
        'calls setJournal when initialJournal is provided and cubit state is initial',
        (tester) async {
      when(() => mockJournalDetailCubit.state)
          .thenReturn(const JournalDetailState(status: LoadStatus.initial));

      await tester.pumpWidget(
        buildTestableWidget(
          state: const JournalDetailState(status: LoadStatus.initial),
          initialJournal: tJournal,
        ),
      );
      await tester.pump();

      verify(() => mockJournalDetailCubit.setJournal(tJournal)).called(1);
    });
  });
}
