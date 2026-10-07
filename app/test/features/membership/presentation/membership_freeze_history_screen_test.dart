import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_freeze.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_freeze_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_freeze_history_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockMembershipFreezeCubit extends MockCubit<MembershipFreezeState>
    implements MembershipFreezeCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockMembershipFreezeCubit freezeCubit;
  late MockSessionCubit sessionCubit;

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'm-profile-1',
  );

  setUp(() {
    freezeCubit = MockMembershipFreezeCubit();
    sessionCubit = MockSessionCubit();

    when(() => freezeCubit.load(memberId: any(named: 'memberId'))).thenAnswer((_) async {});

    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: memberPrincipal,
        capabilities: Capabilities(slugs: ['memberships.read']),
      ),
    );

    getIt.registerFactory<MembershipFreezeCubit>(() => freezeCubit);
  });

  tearDown(() => getIt.reset());

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const MembershipFreezeHistoryScreen(),
      ),
    );
  }

  testWidgets('renders freeze requests in read-only mode with formatted dates', (
    tester,
  ) async {
    final freeze1 = MembershipFreeze(
      id: 'f-1',
      membershipId: 'mem-1',
      startDate: DateTime.utc(2026, 3, 1),
      endDate: DateTime.utc(2026, 3, 15),
      reason: 'Medical recovery',
      status: FreezeStatus.approved,
      reviewedByUserId: 'admin-1',
      reviewedAt: DateTime.utc(2026, 2, 28),
    );

    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeState>.empty(),
      initialState: MembershipFreezeState(
        status: LoadStatus.success,
        membershipId: 'mem-1',
        items: [freeze1],
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(MembershipStrings.freezesTitle), findsOneWidget);
    expect(find.text('2026-03-01 → 2026-03-15'), findsOneWidget);
    expect(find.text('Approved · Medical recovery'), findsOneWidget);

    // Read-only member view should not have approve or reject buttons
    expect(find.text(MembershipStrings.approve), findsNothing);
    expect(find.text(MembershipStrings.reject), findsNothing);
  });

  testWidgets('displays no active membership when membershipId is null', (
    tester,
  ) async {
    whenListen(
      freezeCubit,
      const Stream<MembershipFreezeState>.empty(),
      initialState: const MembershipFreezeState(
        status: LoadStatus.success,
        membershipId: null,
        items: [],
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(MembershipStrings.noActiveMembership), findsOneWidget);
  });
}
