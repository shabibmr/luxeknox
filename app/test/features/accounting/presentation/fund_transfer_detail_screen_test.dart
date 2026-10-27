import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/fund_transfer.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/fund_transfer_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/fund_transfer_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockFundTransferDetailCubit extends MockCubit<FundTransferDetailState>
    implements FundTransferDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockFundTransferDetailCubit mockFundTransferDetailCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tTransferWithFee = FundTransfer(
    id: 'ft-101',
    transferNumber: 'TRF-2026-0101',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '1000.00',
    feeAmount: '25.00',
    feeAccountId: '501',
    memo: 'Transfer to operating account',
    status: 'draft',
  );

  final tTransferWithoutFee = FundTransfer(
    id: 'ft-102',
    transferNumber: 'TRF-2026-0102',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '1000.00',
    feeAmount: '0.00',
    status: 'draft',
  );

  final tPostedTransfer = FundTransfer(
    id: 'ft-101',
    transferNumber: 'TRF-2026-0101',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '1000.00',
    feeAmount: '25.00',
    feeAccountId: '501',
    memo: 'Transfer to operating account',
    status: 'posted',
    journalEntryId: 'JRN-2026-9999',
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.payments_write'],
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
    registerFallbackValue(tTransferWithFee);
  });

  setUp(() {
    mockFundTransferDetailCubit = MockFundTransferDetailCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockFundTransferDetailCubit.load(any()))
        .thenAnswer((_) async {});
    when(() => mockFundTransferDetailCubit.setTransfer(any()))
        .thenReturn(null);
    when(() => mockFundTransferDetailCubit.post())
        .thenAnswer((_) async => true);

    if (getIt.isRegistered<FundTransferDetailCubit>()) {
      getIt.unregister<FundTransferDetailCubit>();
    }
    getIt.registerFactory<FundTransferDetailCubit>(
        () => mockFundTransferDetailCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<FundTransferDetailCubit>()) {
      getIt.unregister<FundTransferDetailCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    FundTransferDetailState state = const FundTransferDetailState(
      status: LoadStatus.success,
    ),
    String transferId = 'ft-101',
    FundTransfer? initialTransfer,
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
      mockFundTransferDetailCubit,
      const Stream<FundTransferDetailState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: FundTransferDetailScreen(
          transferId: transferId,
          cubit: mockFundTransferDetailCubit,
          initialTransfer: initialTransfer,
        ),
      ),
    );
  }

  group('Permission check', () {
    testWidgets('shows noPermission when user lacks accounting.read',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: noCapabilities,
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.byKey(const Key('transfer_number_text')), findsNothing);
    });
  });

  group('Loading, Error, and Empty states', () {
    testWidgets('shows AppLoading when status is loading and transfer is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const FundTransferDetailState(status: LoadStatus.loading),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('shows AppErrorView when status is failure and transfer is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const FundTransferDetailState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Could not load transfer'),
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('shows AppEmptyView when transfer is null', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const FundTransferDetailState(
            status: LoadStatus.success,
            transfer: null,
          ),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
    });
  });

  group('Header, Routing, and Gross Amount', () {
    testWidgets('renders transfer details correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tTransferWithFee,
          ),
        ),
      );

      expect(find.text('TRF-2026-0101'), findsOneWidget);
      expect(find.byKey(const Key('transfer_status_chip')), findsOneWidget);
      expect(find.text(AccountingStrings.statusDraft), findsOneWidget);
      expect(find.text('#101'), findsOneWidget);
      expect(find.text('#102'), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('1000.00')), findsOneWidget);
      expect(find.textContaining('Transfer to operating account'), findsOneWidget);
    });
  });

  group('CRITICAL ACC-095: FEE LINE', () {
    testWidgets('assert fee line is shown when fee > 0', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tTransferWithFee,
          ),
        ),
      );

      // Fee line label and amount
      expect(find.text(AccountingStrings.feeLineLabel), findsOneWidget);
      expect(find.byKey(const Key('fee_amount_text')), findsOneWidget);
      expect(find.text(AccountingStrings.formatAmount(-25)), findsOneWidget);

      // Net deposited label and amount (1000 - 25 = 975)
      expect(find.text(AccountingStrings.netTransferAmountLabel), findsOneWidget);
      expect(find.byKey(const Key('net_amount_text')), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('975.00')), findsOneWidget);
    });

    testWidgets('assert fee line is NOT shown when fee == 0', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tTransferWithoutFee,
          ),
        ),
      );

      expect(find.text(AccountingStrings.feeLineLabel), findsNothing);
      expect(find.byKey(const Key('fee_amount_text')), findsNothing);
      expect(find.text(AccountingStrings.netTransferAmountLabel), findsNothing);
      expect(find.byKey(const Key('net_amount_text')), findsNothing);
    });
  });

  group('Post action and permissions', () {
    testWidgets('shows Post button when draft and user has accounting.payments_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tTransferWithFee,
          ),
        ),
      );

      expect(find.byKey(const Key('post_transfer_button')), findsOneWidget);
    });

    testWidgets('hides Post button when user lacks accounting.payments_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tTransferWithFee,
          ),
        ),
      );

      expect(find.byKey(const Key('post_transfer_button')), findsNothing);
    });

    testWidgets('hides Post button when transfer is already posted',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: FundTransferDetailState(
            status: LoadStatus.success,
            transfer: tPostedTransfer,
          ),
        ),
      );

      expect(find.byKey(const Key('post_transfer_button')), findsNothing);
    });
  });

  group('CRITICAL ACC-095: POSTING REFRESHES AND SHOWS JOURNAL NUMBER', () {
    testWidgets(
        'tapping post calls cubit.post(), refreshes and displays journal entry',
        (tester) async {
      final stateController =
          StreamController<FundTransferDetailState>.broadcast();

      whenListen(
        mockSessionCubit,
        const Stream<SessionState>.empty(),
        initialState: const SessionAuthenticated(
          principal: tPrincipal,
          capabilities: writeCapabilities,
        ),
      );

      whenListen(
        mockFundTransferDetailCubit,
        stateController.stream,
        initialState: FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tTransferWithFee,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: FundTransferDetailScreen(
              transferId: 'ft-101',
              cubit: mockFundTransferDetailCubit,
            ),
          ),
        ),
      );
      await tester.pump();

      // Before posting: draft status, no journal link card
      expect(find.text(AccountingStrings.statusDraft), findsOneWidget);
      expect(find.byKey(const Key('journal_link_card')), findsNothing);

      // Tap post button
      final postBtn = find.byKey(const Key('post_transfer_button'));
      expect(postBtn, findsOneWidget);
      await tester.tap(postBtn);
      await tester.pumpAndSettle();

      // Confirm dialog
      expect(find.text(AccountingStrings.postTransferConfirm), findsOneWidget);
      final confirmBtn = find.text(AccountingStrings.confirm);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Verify cubit.post() was called
      verify(() => mockFundTransferDetailCubit.post()).called(1);

      // Now state has updated to posted:
      stateController.add(
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tPostedTransfer,
          postSuccess: true,
        ),
      );
      await tester.pumpAndSettle();

      // Status chip is Posted
      expect(find.text(AccountingStrings.statusPosted), findsOneWidget);

      // Journal link card and journal number are displayed!
      expect(find.byKey(const Key('journal_link_card')), findsOneWidget);
      expect(find.text('${AccountingStrings.journalNumberLabel}: JRN-2026-9999'),
          findsOneWidget);

      await stateController.close();
    });
  });
}
