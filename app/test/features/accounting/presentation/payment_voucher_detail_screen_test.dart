import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/payment_voucher.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/payment_voucher_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/payment_voucher_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentVoucherDetailCubit
    extends MockCubit<PaymentVoucherDetailState>
    implements PaymentVoucherDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockPaymentVoucherDetailCubit mockPaymentVoucherDetailCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftVoucher = PaymentVoucher(
    id: 'pv-100',
    voucherNumber: 'PV-2026-0100',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: '1020',
    amount: '350.00',
    status: 'draft',
    memo: 'Supplier settlement for bills',
    allocations: const [
      PaymentVoucherAllocation(
        id: 'pva-1',
        paymentVoucherId: 'pv-100',
        purchaseBillId: 'bill-10',
        amount: '350.00',
      ),
    ],
  );

  final tPostedVoucher = PaymentVoucher(
    id: 'pv-100',
    voucherNumber: 'PV-2026-0100',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: '1020',
    amount: '350.00',
    status: 'posted',
    journalEntryId: 'JRN-2026-0888',
    memo: 'Supplier settlement for bills',
    allocations: const [
      PaymentVoucherAllocation(
        id: 'pva-1',
        paymentVoucherId: 'pv-100',
        purchaseBillId: 'bill-10',
        amount: '350.00',
      ),
    ],
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
    registerFallbackValue(tDraftVoucher);
  });

  setUp(() {
    mockPaymentVoucherDetailCubit = MockPaymentVoucherDetailCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockPaymentVoucherDetailCubit.load(any()))
        .thenAnswer((_) async {});
    when(() => mockPaymentVoucherDetailCubit.post())
        .thenAnswer((_) async => true);
    when(() => mockPaymentVoucherDetailCubit.setVoucher(any()))
        .thenReturn(null);

    if (getIt.isRegistered<PaymentVoucherDetailCubit>()) {
      getIt.unregister<PaymentVoucherDetailCubit>();
    }
    getIt.registerFactory<PaymentVoucherDetailCubit>(
        () => mockPaymentVoucherDetailCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<PaymentVoucherDetailCubit>()) {
      getIt.unregister<PaymentVoucherDetailCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    PaymentVoucherDetailState state = const PaymentVoucherDetailState(
      status: LoadStatus.success,
    ),
    PaymentVoucherDetailCubit? cubit,
    String voucherId = 'pv-100',
    PaymentVoucher? initialVoucher,
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
      mockPaymentVoucherDetailCubit,
      const Stream<PaymentVoucherDetailState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: PaymentVoucherDetailScreen(
          voucherId: voucherId,
          cubit: cubit ?? mockPaymentVoucherDetailCubit,
          initialVoucher: initialVoucher,
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
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
    });
  });

  group('Voucher details rendering', () {
    testWidgets('renders voucher header, allocations table, and totals',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      expect(find.byKey(const Key('voucher_number_text')), findsOneWidget);
      expect(find.text('PV-2026-0100'), findsOneWidget);
      expect(find.byKey(const Key('voucher_status_chip')), findsOneWidget);
      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Supplier settlement for bills'), findsOneWidget);
      expect(find.text('Bill #bill-10'), findsOneWidget);
      expect(find.byKey(const Key('voucher_total_amount')), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('350.00')), findsWidgets);
    });

    testWidgets('renders journal entry number when voucher is posted',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tPostedVoucher,
          ),
        ),
      );

      expect(find.byKey(const Key('journal_entry_badge')), findsOneWidget);
      expect(
          find.text(
              '${AccountingStrings.journalNumberLabel}: JRN-2026-0888'),
          findsOneWidget);
      expect(find.text('Posted'), findsOneWidget);
    });
  });

  group('CRITICAL ACC-095: Post button and posting workflow', () {
    testWidgets(
        'shows Post button when draft and user has payments_write capability',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      expect(find.byKey(const Key('post_voucher_button')), findsOneWidget);
    });

    testWidgets('hides Post button when voucher is already posted',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tPostedVoucher,
          ),
        ),
      );

      expect(find.byKey(const Key('post_voucher_button')), findsNothing);
    });

    testWidgets('hides Post button when user lacks payments_write capability',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      expect(find.byKey(const Key('post_voucher_button')), findsNothing);
    });

    testWidgets(
        'clicking Post button shows confirmation dialog and confirming calls cubit.post()',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('post_voucher_button')));
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.postVoucherConfirm), findsOneWidget);

      await tester.tap(find.byKey(const Key('post_confirm_button')));
      await tester.pumpAndSettle();

      verify(() => mockPaymentVoucherDetailCubit.post()).called(1);
    });

    testWidgets(
        'cancelling Post confirmation dialog does not call cubit.post()',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: PaymentVoucherDetailState(
            status: LoadStatus.success,
            voucher: tDraftVoucher,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('post_voucher_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('post_cancel_button')));
      await tester.pumpAndSettle();

      verifyNever(() => mockPaymentVoucherDetailCubit.post());
    });
  });

  group('Loading and Error states', () {
    testWidgets('renders loading widget when loading', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PaymentVoucherDetailState(
            status: LoadStatus.loading,
            voucher: null,
          ),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('renders error view and retrying calls load', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PaymentVoucherDetailState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Error loading voucher'),
            voucher: null,
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Error loading voucher'), findsOneWidget);

      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockPaymentVoucherDetailCubit.load('pv-100')).called(1);
    });
  });
}
