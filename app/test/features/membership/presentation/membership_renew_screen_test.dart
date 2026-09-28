import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_renew_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_renew_screen.dart';
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

class MockMembershipRenewCubit extends MockCubit<MembershipRenewState>
    implements MembershipRenewCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockMembershipRenewCubit renewCubit;
  late MockSessionCubit sessionCubit;

  final membership = Membership(
    id: 'm-1',
    memberId: '1',
    productId: 'prod-1',
    startDate: DateTime.utc(2026, 1, 1),
    endDate: DateTime.utc(2026, 12, 1),
    status: MembershipStatus.active,
    rowVersion: 2,
    product: const MembershipProduct(
      id: 'prod-1',
      name: 'Gold Package',
      code: 'GOLD',
      durationDays: 30,
      basePrice: '99.00',
      isActive: true,
    ),
  );

  final products = [
    const MembershipProduct(
      id: 'prod-1',
      name: 'Gold Package',
      code: 'GOLD',
      durationDays: 30,
      basePrice: '99.00',
      isActive: true,
    ),
    const MembershipProduct(
      id: 'prod-2',
      name: 'Platinum Package',
      code: 'PLAT',
      durationDays: 60,
      basePrice: '199.00',
      isActive: true,
    ),
  ];

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p3',
  );

  const canApprove = Capabilities(
    slugs: ['memberships.read', 'memberships.approve'],
  );
  const noApprove = Capabilities(
    slugs: ['memberships.read'],
  );

  setUp(() {
    renewCubit = MockMembershipRenewCubit();
    sessionCubit = MockSessionCubit();

    when(() => renewCubit.load('m-1')).thenAnswer((_) async {});
    when(() => renewCubit.onProductChanged(any())).thenAnswer((_) {});
    when(() => renewCubit.onReasonChanged(any())).thenAnswer((_) {});
    when(() => renewCubit.submit()).thenAnswer((_) async => true);

    getIt.registerFactory<MembershipRenewCubit>(() => renewCubit);
  });

  tearDown(() => getIt.reset());

  Widget wrapScreen(
    Widget child, {
    Capabilities capabilities = canApprove,
  }) {
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: capabilities,
      ),
    );
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<SessionCubit>.value(
            value: sessionCubit,
            child: child,
          ),
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('renders no permission message when memberships.approve is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapScreen(
        const MembershipRenewScreen(membershipId: 'm-1'),
        capabilities: noApprove,
      ),
    );

    expect(find.text(MembershipStrings.noPermission), findsOneWidget);
  });

  testWidgets('renders loading indicator initially', (tester) async {
    whenListen(
      renewCubit,
      const Stream<MembershipRenewState>.empty(),
      initialState: const MembershipRenewState(status: LoadStatus.loading),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipRenewScreen(membershipId: 'm-1')),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders membership info, product dropdown and submit button on success', (
    tester,
  ) async {
    whenListen(
      renewCubit,
      const Stream<MembershipRenewState>.empty(),
      initialState: MembershipRenewState(
        status: LoadStatus.success,
        membership: membership,
        products: products,
        selectedProductId: 'prod-1',
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipRenewScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Membership ID: m-1'), findsOneWidget);
    expect(find.text('Current package: Gold Package'), findsOneWidget);
    expect(find.text(MembershipStrings.renewSubmit), findsOneWidget);
  });

  testWidgets('submits renew form when button tapped', (tester) async {
    whenListen(
      renewCubit,
      const Stream<MembershipRenewState>.empty(),
      initialState: MembershipRenewState(
        status: LoadStatus.success,
        membership: membership,
        products: products,
        selectedProductId: 'prod-1',
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipRenewScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('renew_reason_field')),
      'Annual renewal',
    );
    await tester.tap(find.byKey(const Key('renew_submit_button')));
    verify(() => renewCubit.submit()).called(1);
  });

  testWidgets('shows conflict message on 409 stale rowVersion failure', (
    tester,
  ) async {
    when(() => renewCubit.submit()).thenAnswer((_) async => false);

    whenListen(
      renewCubit,
      const Stream<MembershipRenewState>.empty(),
      initialState: MembershipRenewState(
        status: LoadStatus.success,
        membership: membership,
        products: products,
        selectedProductId: 'prod-1',
        failure: const ConflictFailure(),
        isConflict: true,
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipRenewScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('renew_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.text(MembershipStrings.rowVersionConflict('renew')),
      findsOneWidget,
    );
  });
}
