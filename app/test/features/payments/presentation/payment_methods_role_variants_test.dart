import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/payments/presentation/cubit/payment_methods_cubit.dart';
import 'package:luxeknox/features/payments/presentation/payment_strings.dart';
import 'package:luxeknox/features/payments/presentation/screens/payment_methods_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentMethodsCubit extends MockCubit<PaymentMethodsState>
    implements PaymentMethodsCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

/// Create is shown only with `payments.create` (ADR-0006 §11).
void main() {
  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const readOnly = Capabilities(slugs: ['payments.read']);
  const canCreate = Capabilities(slugs: ['payments.read', 'payments.create']);

  late MockPaymentMethodsCubit methods;

  setUp(() {
    methods = MockPaymentMethodsCubit();
    whenListen(
      methods,
      const Stream<PaymentMethodsState>.empty(),
      initialState: const PaymentMethodsState(
        status: LoadStatus.success,
        items: [cash],
      ),
    );
    when(() => methods.load()).thenAnswer((_) async {});
    when(() => methods.close()).thenAnswer((_) async {});
    getIt.registerFactory<PaymentMethodsCubit>(() => methods);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Principal principal, Capabilities capabilities) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const PaymentMethodsScreen(),
      ),
    );
  }

  testWidgets('member does not see create', (tester) async {
    await tester.pumpWidget(wrap(memberPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('trainer does not see create', (tester) async {
    await tester.pumpWidget(wrap(trainerPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Cash'), findsOneWidget);
  });

  testWidgets('admin with payments.create sees create', (tester) async {
    await tester.pumpWidget(wrap(adminPrincipal, canCreate));
    await tester.pumpAndSettle();

    expect(find.byTooltip(PaymentStrings.addMethodTooltip), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
  });
}
