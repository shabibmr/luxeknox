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
import 'package:luxeknox/features/accounting/domain/entities/payment_voucher.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/payment_vouchers_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/payment_vouchers_list_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentVouchersCubit extends MockCubit<PaymentVouchersState>
    implements PaymentVouchersCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockPaymentVouchersCubit mockPaymentVouchersCubit;
  late MockSessionCubit mockSessionCubit;

  final tVoucher1 = PaymentVoucher(
    id: 'pv-1',
    voucherNumber: 'PV-2026-0001',
    voucherDate: DateTime(2026, 3, 1),
    vendorId: 'ven-1',
    bankAccountId: '1020',
    amount: '350.00',
    status: 'draft',
    memo: 'Office equipment settlement',
  );

  final tVoucher2 = PaymentVoucher(
    id: 'pv-2',
    voucherNumber: 'PV-2026-0002',
    voucherDate: DateTime(2026, 3, 2),
    vendorId: 'ven-2',
    bankAccountId: '1020',
    amount: '500.00',
    status: 'posted',
    journalEntryId: 'j-456',
    memo: 'Contractor invoice payout',
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.payments_write'],
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
    mockPaymentVouchersCubit = MockPaymentVouchersCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockPaymentVouchersCubit.load(
          status: any(named: 'status'),
          bankAccountId: any(named: 'bankAccountId'),
          from: any(named: 'from'),
          to: any(named: 'to'),
          search: any(named: 'search'),
          clearStatus: any(named: 'clearStatus'),
          clearBank: any(named: 'clearBank'),
          clearDates: any(named: 'clearDates'),
          clearSearch: any(named: 'clearSearch'),
          refresh: any(named: 'refresh'),
        )).thenAnswer((_) async {});
    when(() => mockPaymentVouchersCubit.filterByStatus(any()))
        .thenAnswer((_) async {});
    when(() => mockPaymentVouchersCubit.filterByBankAccount(any()))
        .thenAnswer((_) async {});
    when(() => mockPaymentVouchersCubit.filterByDateRange(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockPaymentVouchersCubit.clearFilters())
        .thenAnswer((_) async {});

    if (getIt.isRegistered<PaymentVouchersCubit>()) {
      getIt.unregister<PaymentVouchersCubit>();
    }
    getIt.registerFactory<PaymentVouchersCubit>(
        () => mockPaymentVouchersCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<PaymentVouchersCubit>()) {
      getIt.unregister<PaymentVouchersCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    PaymentVouchersState state = const PaymentVouchersState(
      status: LoadStatus.success,
      vouchers: [],
    ),
    PaymentVouchersCubit? cubit,
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
      mockPaymentVouchersCubit,
      const Stream<PaymentVouchersState>.empty(),
      initialState: state,
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => BlocProvider<SessionCubit>.value(
            value: mockSessionCubit,
            child: PaymentVouchersListScreen(
              cubit: cubit ?? mockPaymentVouchersCubit,
            ),
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingPaymentVouchersCreate,
          builder: (context, routerState) =>
              const Scaffold(body: Text('Create Voucher Destination')),
        ),
        GoRoute(
          path: '/admin/accounting/payment-vouchers/:id',
          builder: (context, routerState) => Scaffold(
            body: Text(
                'Voucher Detail Destination ${routerState.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('PaymentVouchersListScreen rendering', () {
    testWidgets('renders loading view when loading with empty list',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PaymentVouchersState(
            status: LoadStatus.loading,
            vouchers: [],
          ),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('renders error view when failure and retry calls load',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PaymentVouchersState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Failed to load vouchers'),
            vouchers: [],
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Failed to load vouchers'), findsOneWidget);

      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockPaymentVouchersCubit.load()).called(1);
    });

    testWidgets('renders empty view when vouchers list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PaymentVouchersState(
            status: LoadStatus.success,
            vouchers: [],
          ),
        ),
      );

      expect(find.byType(AppEmptyView), findsOneWidget);
      expect(find.text(AccountingStrings.noneFound), findsOneWidget);
    });

    testWidgets('renders voucher cards with details', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: PaymentVouchersState(
            status: LoadStatus.success,
            vouchers: [tVoucher1, tVoucher2],
          ),
        ),
      );

      expect(find.text('PV-2026-0001'), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('350.00')), findsOneWidget);
      expect(find.text('PV-2026-0002'), findsOneWidget);
      expect(find.text(AccountingStrings.formatMoney('500.00')), findsOneWidget);
      expect(find.byType(AppStatusChip), findsNWidgets(2));
    });
  });

  group('Permissions & Actions', () {
    testWidgets('shows create FAB and appbar button when user has payments_write',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
        ),
      );

      expect(find.byKey(const Key('create_voucher_button')), findsOneWidget);
      expect(
          find.byKey(const Key('appbar_create_voucher_button')), findsOneWidget);
    });

    testWidgets('hides create FAB and appbar button when read-only',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
        ),
      );

      expect(find.byKey(const Key('create_voucher_button')), findsNothing);
      expect(
          find.byKey(const Key('appbar_create_voucher_button')), findsNothing);
    });

    testWidgets('clicking status filter chip calls cubit.filterByStatus',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(),
      );

      await tester.tap(find.byKey(const Key('status_chip_draft')));
      await tester.pump();

      verify(() => mockPaymentVouchersCubit.filterByStatus('draft')).called(1);

      await tester.tap(find.byKey(const Key('status_chip_posted')));
      await tester.pump();

      verify(() => mockPaymentVouchersCubit.filterByStatus('posted')).called(1);
    });

    testWidgets('tapping voucher card navigates to detail route',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: PaymentVouchersState(
            status: LoadStatus.success,
            vouchers: [tVoucher1],
          ),
        ),
      );

      await tester.tap(find.text('PV-2026-0001'));
      await tester.pumpAndSettle();

      expect(find.text('Voucher Detail Destination pv-1'), findsOneWidget);
    });
  });
}
