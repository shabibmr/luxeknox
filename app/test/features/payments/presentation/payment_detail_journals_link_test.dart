import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/payments/domain/entities/payment.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_status.dart';
import 'package:luxeknox/features/payments/presentation/cubit/payment_detail_cubit.dart';
import 'package:luxeknox/features/payments/presentation/payment_strings.dart';
import 'package:luxeknox/features/payments/presentation/screens/payment_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentDetailCubit extends MockCubit<PaymentDetailState>
    implements PaymentDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// ACC-100: the journals link is shown only with `accounting.read` and opens
/// the journal list filtered to this payment.
void main() {
  const payment = Payment(
    id: '42',
    invoiceNumber: 'INV-0042',
    memberId: '7',
    subtotal: '1000.00',
    taxAmount: '180.00',
    discountAmount: '0.00',
    totalAmount: '1180.00',
    amountPaid: '1180.00',
    status: PaymentStatus.paid,
    rowVersion: 1,
  );

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const paymentsOnly = Capabilities(slugs: ['payments.read']);
  const withAccounting =
      Capabilities(slugs: ['payments.read', 'accounting.read']);

  late MockPaymentDetailCubit detail;

  setUp(() {
    detail = MockPaymentDetailCubit();
    whenListen(
      detail,
      const Stream<PaymentDetailState>.empty(),
      initialState: const PaymentDetailState(
        status: LoadStatus.success,
        payment: payment,
      ),
    );
    when(() => detail.load(any())).thenAnswer((_) async {});
    when(() => detail.close()).thenAnswer((_) async {});
    getIt.registerFactory<PaymentDetailCubit>(() => detail);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Capabilities capabilities, {void Function(Uri)? onJournals}) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: capabilities,
      ),
    );
    final router = GoRouter(
      initialLocation: '/admin/payments/42',
      routes: [
        GoRoute(
          path: '/admin/payments/:id',
          builder: (context, state) =>
              PaymentDetailScreen(paymentId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/admin/accounting/journals',
          builder: (context, state) {
            onJournals?.call(state.uri);
            return const Scaffold(body: Text('journals screen'));
          },
        ),
      ],
    );
    return BlocProvider<SessionCubit>.value(
      value: sessionCubit,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('hidden without accounting.read', (tester) async {
    await tester.pumpWidget(wrap(paymentsOnly));
    await tester.pumpAndSettle();

    expect(find.textContaining('INV-0042'), findsOneWidget);
    expect(find.byKey(const Key('payment_journals_link')), findsNothing);
    expect(find.text(PaymentStrings.journalsLink), findsNothing);
  });

  testWidgets('opens the journal list filtered by payment', (tester) async {
    Uri? opened;
    await tester.pumpWidget(
      wrap(withAccounting, onJournals: (uri) => opened = uri),
    );
    await tester.pumpAndSettle();

    final link = find.byKey(const Key('payment_journals_link'));
    expect(link, findsOneWidget);

    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(find.text('journals screen'), findsOneWidget);
    expect(opened?.path, '/admin/accounting/journals');
    expect(opened?.queryParameters['paymentId'], '42');
  });
}
