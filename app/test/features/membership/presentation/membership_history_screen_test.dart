import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_history_entry.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/presentation/cubit/membership_history_cubit.dart';
import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/features/membership/presentation/screens/membership_history_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockMembershipHistoryCubit extends MockCubit<MembershipHistoryState>
    implements MembershipHistoryCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockMembershipHistoryCubit historyCubit;
  late MockSessionCubit sessionCubit;

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'm-profile-1',
  );

  setUp(() {
    historyCubit = MockMembershipHistoryCubit();
    sessionCubit = MockSessionCubit();

    when(
      () => historyCubit.load(memberId: any(named: 'memberId')),
    ).thenAnswer((_) async {});

    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: memberPrincipal,
        capabilities: Capabilities(slugs: ['memberships.read']),
      ),
    );

    getIt.registerFactory<MembershipHistoryCubit>(() => historyCubit);
  });

  tearDown(() => getIt.reset());

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const MembershipHistoryScreen(),
      ),
    );
  }

  testWidgets('renders history entries with formatted dates', (tester) async {
    final entry1 = MembershipHistoryEntry(
      id: 'h-1',
      membershipId: 'mem-1',
      action: MembershipHistoryAction.created,
      performedByUserId: 'admin-1',
      timestamp: DateTime.utc(2026, 1, 1),
    );
    final entry2 = MembershipHistoryEntry(
      id: 'h-2',
      membershipId: 'mem-1',
      action: MembershipHistoryAction.extended,
      newEndDate: DateTime.utc(2026, 12, 31),
      performedByUserId: 'admin-1',
      timestamp: DateTime.utc(2026, 6, 1),
    );

    whenListen(
      historyCubit,
      const Stream<MembershipHistoryState>.empty(),
      initialState: MembershipHistoryState(
        status: LoadStatus.success,
        membershipId: 'mem-1',
        items: [entry2, entry1],
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(MembershipStrings.historyTitle), findsOneWidget);
    expect(find.text('Extended'), findsOneWidget);
    expect(find.text('New end date: 2026-12-31'), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
  });

  testWidgets('displays no active membership when membershipId is null', (
    tester,
  ) async {
    whenListen(
      historyCubit,
      const Stream<MembershipHistoryState>.empty(),
      initialState: const MembershipHistoryState(
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
