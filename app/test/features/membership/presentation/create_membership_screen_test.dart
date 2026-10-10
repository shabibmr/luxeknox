import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/presentation/bloc/create_membership_bloc.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/create_membership_screen.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateMembershipBloc
    extends MockBloc<CreateMembershipEvent, CreateMembershipState>
    implements CreateMembershipBloc {}

void main() {
  late MockCreateMembershipBloc bloc;

  const gold = MembershipProduct(
    id: '10',
    name: 'Gold',
    code: 'GOLD',
    durationDays: 30,
    basePrice: '1299.00',
    isActive: true,
  );
  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );

  setUp(() {
    bloc = MockCreateMembershipBloc();
    getIt.registerFactory<CreateMembershipBloc>(() => bloc);
  });

  tearDown(() => getIt.reset());

  Widget wrapScreen() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const CreateMembershipScreen(memberId: '100'),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('shows payment method dropdown on assign membership', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: const CreateMembershipState(
        status: LoadStatus.success,
        products: [gold],
        paymentMethods: [cash],
        selectedMemberId: '100',
        selectedPaymentMethodId: '1',
      ),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.paymentMethodLabel), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('shows empty payment methods message', (tester) async {
    whenListen(
      bloc,
      const Stream<CreateMembershipState>.empty(),
      initialState: const CreateMembershipState(
        status: LoadStatus.success,
        products: [gold],
        selectedMemberId: '100',
      ),
    );

    await tester.pumpWidget(wrapScreen());
    await tester.pump();

    expect(find.text(MembershipStrings.noPaymentMethods), findsOneWidget);
  });
}
