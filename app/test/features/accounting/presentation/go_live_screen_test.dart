import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/go_live.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounts_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/go_live_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/go_live_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGoLiveCubit extends MockCubit<GoLiveState> implements GoLiveCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

class MockAccountsCubit extends MockCubit<AccountsState> implements AccountsCubit {}

void main() {
  late MockGoLiveCubit mockCubit;
  late MockSessionCubit mockSessionCubit;
  late MockAccountsCubit mockAccountsCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  const tPaymentMethod = GoLivePaymentMethodMapping(
    id: 1,
    methodName: 'Cash',
    isActive: true,
    isDigital: false,
    accountId: 10,
    accountCode: '1000',
    accountName: 'Cash on Hand',
  );

  const tUnmappedMethod = GoLivePaymentMethodMapping(
    id: 2,
    methodName: 'UPI',
    isActive: true,
    isDigital: true,
    accountId: null,
  );

  final tChecklistReady = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: false,
    canEnable: true,
    failingReasons: const [],
    openingJournalFound: true,
    openingJournalMatches: true,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '2200.00',
      isMatched: true,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '1500.00',
      isMatched: true,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod],
  );

  final tChecklistFailing = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: false,
    canEnable: false,
    failingReasons: const [
      'Active payment method "UPI" has no mapped accounting account.',
      'No posted opening balance journal found.',
    ],
    openingJournalFound: false,
    openingJournalMatches: false,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '0.00',
      isMatched: false,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '0.00',
      isMatched: false,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod, tUnmappedMethod],
  );

  final tChecklistEnabled = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: true,
    canEnable: false,
    failingReasons: const [],
    openingJournalFound: true,
    openingJournalMatches: true,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '2200.00',
      isMatched: true,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '1500.00',
      isMatched: true,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod],
  );

  const tSessionWithPermission = SessionAuthenticated(
    principal: Principal(
      userId: '1',
      userType: UserType.admin,
      displayName: 'Admin User',
      profileId: 'p1',
    ),
    capabilities: Capabilities(slugs: ['accounting.posting_toggle']),
  );

  const tSessionWithoutPermission = SessionAuthenticated(
    principal: Principal(
      userId: '2',
      userType: UserType.admin,
      displayName: 'Staff User',
      profileId: 'p2',
    ),
    capabilities: Capabilities(slugs: ['accounting.read']),
  );

  const tTestAccount = Account(
    id: '20',
    code: '1020',
    name: 'UPI Clearing',
    type: 'asset',
    isBank: true,
    isActive: true,
  );

  setUp(() {
    mockCubit = MockGoLiveCubit();
    mockSessionCubit = MockSessionCubit();
    mockAccountsCubit = MockAccountsCubit();

    when(() => mockCubit.load(goLiveDate: any(named: 'goLiveDate')))
        .thenAnswer((_) async {});
    when(() => mockCubit.mapPaymentMethod(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockCubit.enablePosting()).thenAnswer((_) async {});

    when(() => mockSessionCubit.state).thenReturn(tSessionWithPermission);
    when(() => mockAccountsCubit.state).thenReturn(
      const AccountsState(
        status: LoadStatus.success,
        accounts: [tTestAccount],
      ),
    );
    when(() => mockAccountsCubit.load(
          accountType: any(named: 'accountType'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
        )).thenAnswer((_) async {});

    if (getIt.isRegistered<SessionCubit>()) {
      getIt.unregister<SessionCubit>();
    }
    getIt.registerSingleton<SessionCubit>(mockSessionCubit);

    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
    getIt.registerFactory<AccountsCubit>(() => mockAccountsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<SessionCubit>()) {
      getIt.unregister<SessionCubit>();
    }
    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
  });

  Widget buildWidget(GoLiveCubit cubit) {
    return MaterialApp(
      home: GoLiveScreen(cubit: cubit),
    );
  }

  testWidgets('renders AppLoading when state is loading without checklist',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.loading,
        selectedDate: tDate,
        checklist: null,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byType(AppLoading), findsOneWidget);
    expect(find.text(AccountingStrings.goLiveTitle), findsOneWidget);
  });

  testWidgets('renders AppErrorView when state is failure without checklist',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.failure,
        selectedDate: tDate,
        checklist: null,
        failure: const BusinessRuleFailure('Connection failed'),
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text('Connection failed'), findsOneWidget);

    await tester.tap(find.text(AccountingStrings.retry));
    verify(() => mockCubit.load()).called(1);
  });

  testWidgets('renders checklist cards when loaded successfully',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    // App Bar Title & Refresh
    expect(find.text(AccountingStrings.goLiveTitle), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // Date Card
    expect(find.text(AccountingStrings.goLiveDateLabel), findsOneWidget);
    expect(find.text('2026-10-15'), findsOneWidget);
    expect(find.text(AccountingStrings.changeDateLabel), findsOneWidget);

    // Payment Methods Card
    expect(find.text(AccountingStrings.paymentMethodMappingsTitle), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('1000 - Cash on Hand'), findsOneWidget);

    // Opening Balance & Unearned Comparison Card
    expect(find.text(AccountingStrings.unearnedComparisonTitle), findsOneWidget);
    expect(find.text(AccountingStrings.unearnedMembershipAccountLabel),
        findsOneWidget);
    expect(find.text(AccountingStrings.unearnedPtAccountLabel), findsOneWidget);
    expect(find.text('\$2200.00'), findsNWidgets(2)); // Expected and actual
    expect(find.text('\$1500.00'), findsNWidgets(2));
    expect(find.text(AccountingStrings.matchedBadge), findsWidgets);

    // Readiness Card
    expect(find.text(AccountingStrings.readinessTitle), findsOneWidget);
    expect(find.text(AccountingStrings.allPrerequisitesMet), findsOneWidget);
  });

  testWidgets('renders failing checks when prerequisites are not met',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistFailing,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    // Unmapped method
    expect(find.text('UPI'), findsOneWidget);
    expect(find.text(AccountingStrings.unmappedAccount), findsWidgets);

    // Mismatched / missing opening journal
    expect(find.text(AccountingStrings.openingJournalMissing), findsWidgets);

    // Readiness card displays failing checks
    expect(find.text(AccountingStrings.prerequisitesNotMet), findsOneWidget);
    expect(
      find.text(
          'Active payment method "UPI" has no mapped accounting account.'),
      findsOneWidget,
    );
    expect(
      find.text('No posted opening balance journal found.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'CRITICAL: Enable posting button is HIDDEN without accounting.posting_toggle capability',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(tSessionWithoutPermission);
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    // Button should be completely hidden
    expect(find.byKey(const Key('enable_posting_btn')), findsNothing);
    expect(find.text(AccountingStrings.enableAutomaticPosting), findsNothing);
  });

  testWidgets(
      'Enable posting button is VISIBLE when user has accounting.posting_toggle capability',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(tSessionWithPermission);
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.byKey(const Key('enable_posting_btn')), findsOneWidget);
    expect(find.text(AccountingStrings.enableAutomaticPosting), findsOneWidget);
  });

  testWidgets(
      'Tapping Enable Posting shows confirmation dialog and confirms action',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(tSessionWithPermission);
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    await tester.ensureVisible(find.byKey(const Key('enable_posting_btn')));
    await tester.tap(find.byKey(const Key('enable_posting_btn')));
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text(AccountingStrings.confirmGoLiveTitle), findsOneWidget);
    expect(find.text(AccountingStrings.enablePostingConfirm), findsOneWidget);

    // Tap confirm
    await tester.tap(find.widgetWithText(ElevatedButton, AccountingStrings.confirm));
    await tester.pumpAndSettle();

    verify(() => mockCubit.enablePosting()).called(1);
  });

  testWidgets('shows Posting is currently ENABLED badge when posting is enabled',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(tSessionWithPermission);
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistEnabled,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    expect(find.text(AccountingStrings.postingAlreadyEnabled), findsOneWidget);
    expect(find.byKey(const Key('enable_posting_btn')), findsNothing);
  });

  testWidgets('mapping payment method opens account picker sheet and calls cubit',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(tSessionWithPermission);
    when(() => mockCubit.state).thenReturn(
      GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistFailing,
      ),
    );

    await tester.pumpWidget(buildWidget(mockCubit));

    // Tap map account button for method id 2 (UPI)
    final mapBtn = find.byKey(const Key('map_account_btn_2'));
    expect(mapBtn, findsOneWidget);

    await tester.tap(mapBtn);
    await tester.pumpAndSettle();

    // Account picker sheet is opened
    expect(find.text('UPI Clearing'), findsOneWidget);

    // Tap the account to pick it
    await tester.tap(find.text('UPI Clearing'));
    await tester.pumpAndSettle();

    verify(() => mockCubit.mapPaymentMethod(2, 20)).called(1);
  });
}
