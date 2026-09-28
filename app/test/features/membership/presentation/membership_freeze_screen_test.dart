import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_freeze_form_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_freeze_screen.dart';
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

class MockMembershipFreezeFormCubit
    extends MockCubit<MembershipFreezeFormState>
    implements MembershipFreezeFormCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockMembershipFreezeFormCubit freezeCubit;
  late MockSessionCubit sessionCubit;

  final membership = Membership(
    id: 'm-1',
    memberId: '1',
    productId: 'prod-1',
    startDate: DateTime.utc(2026, 1, 1),
    endDate: DateTime.utc(2026, 12, 1),
    status: MembershipStatus.active,
    rowVersion: 1,
  );

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p3',
  );

  const canUpdate = Capabilities(
    slugs: ['memberships.read', 'memberships.update'],
  );
  const noUpdate = Capabilities(
    slugs: ['memberships.read'],
  );

  setUp(() {
    freezeCubit = MockMembershipFreezeFormCubit();
    sessionCubit = MockSessionCubit();

    when(() => freezeCubit.load('m-1')).thenAnswer((_) async {});
    when(() => freezeCubit.onStartDateChanged(any())).thenAnswer((_) {});
    when(() => freezeCubit.onEndDateChanged(any())).thenAnswer((_) {});
    when(() => freezeCubit.onReasonChanged(any())).thenAnswer((_) {});
    when(() => freezeCubit.submit()).thenAnswer((_) async => true);

    getIt.registerFactory<MembershipFreezeFormCubit>(() => freezeCubit);
  });

  tearDown(() => getIt.reset());

  Widget wrapScreen(
    Widget child, {
    Capabilities capabilities = canUpdate,
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

  testWidgets('renders no permission message when memberships.update is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapScreen(
        const MembershipFreezeScreen(membershipId: 'm-1'),
        capabilities: noUpdate,
      ),
    );

    expect(find.text(MembershipStrings.noPermission), findsOneWidget);
  });

  testWidgets('renders dates, reason field, and Freeze membership button', (
    tester,
  ) async {
    final start = DateTime(2026, 3, 1);
    final end = DateTime(2026, 3, 15);

    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeFormState>.empty(),
      initialState: MembershipFreezeFormState(
        status: LoadStatus.success,
        membership: membership,
        startDate: start,
        endDate: end,
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipFreezeScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Membership ID: m-1'), findsOneWidget);
    expect(find.text('2026-03-01'), findsOneWidget);
    expect(find.text('2026-03-15'), findsOneWidget);
    expect(find.text(MembershipStrings.freezeSubmit), findsOneWidget);
  });

  testWidgets('submits freeze form when submit button tapped', (tester) async {
    final start = DateTime(2026, 3, 1);
    final end = DateTime(2026, 3, 15);

    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeFormState>.empty(),
      initialState: MembershipFreezeFormState(
        status: LoadStatus.success,
        membership: membership,
        startDate: start,
        endDate: end,
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipFreezeScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('freeze_reason_field')),
      'Medical reason',
    );
    await tester.tap(find.byKey(const Key('freeze_submit_button')));
    verify(() => freezeCubit.submit()).called(1);
  });

  testWidgets('displays validation error if dates are invalid', (
    tester,
  ) async {
    when(() => freezeCubit.submit()).thenAnswer((_) async => false);

    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeFormState>.empty(),
      initialState: MembershipFreezeFormState(
        status: LoadStatus.success,
        membership: membership,
        startDate: DateTime(2026, 3, 15),
        endDate: DateTime(2026, 3, 1),
        validationError: 'End date cannot be before start date',
      ),
    );

    await tester.pumpWidget(
      wrapScreen(const MembershipFreezeScreen(membershipId: 'm-1')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('freeze_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('End date cannot be before start date'),
      findsWidgets,
    );
  });
}
