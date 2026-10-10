import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_summary.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goals_list_cubit.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_memberships_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_member_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/member_dossier_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/member_dossier_screen.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/features/pt/domain/usecases/pt_usecases.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMemberUseCase extends Mock implements GetMemberUseCase {}

class MockUpdateMemberUseCase extends Mock implements UpdateMemberUseCase {}

class MockGetMembershipsUseCase extends Mock implements GetMembershipsUseCase {}

class MockGetAttendanceSummaryUseCase extends Mock
    implements GetAttendanceSummaryUseCase {}

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockListMemberGoalsUseCase extends Mock
    implements ListMemberGoalsUseCase {}

class MockGetMemberPtSummaryUseCase extends Mock
    implements GetMemberPtSummaryUseCase {}

class MockRenewPtUseCase extends Mock implements RenewPtUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// Covers the Task 6 "Start workout session" tile on the member dossier:
/// shown only for a trainer shell with an active PT subscription that isn't
/// read-only, and it navigates to the trainer's active-session route.
void main() {
  late MockGetMemberUseCase getMember;
  late MockUpdateMemberUseCase updateMember;
  late MockGetMembershipsUseCase getMemberships;
  late MockGetAttendanceSummaryUseCase getAttendanceSummary;
  late MockGetTrainerUseCase getTrainer;
  late MockListSchedulesUseCase listSchedules;
  late MockListMemberGoalsUseCase listMemberGoals;
  late MockGetMemberPtSummaryUseCase getPtSummary;
  late MockRenewPtUseCase renewPt;
  late MockSessionCubit sessionCubit;

  const testPerson = Person(
    id: 42,
    userId: 101,
    membershipNumber: 'MEM-042',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    assignedTrainerId: 7,
  );

  const trainerPrincipal = Principal(
    userId: '1',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 't1',
  );

  const assignedTrainer = TrainerProfile(
    id: 7,
    userId: 70,
    firstName: 'Alex',
    lastName: 'Coach',
  );

  Membership gymMembership() {
    final end = DateTime.now().add(const Duration(days: 45));
    return Membership(
      id: 'm2',
      memberId: '42',
      productId: 'p2',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: end,
      remainingPtSessions: 0,
      status: MembershipStatus.active,
      rowVersion: 1,
      product: const MembershipProduct(
        id: 'p2',
        name: 'Gym Only',
        code: 'GYM',
        durationDays: 30,
        basePrice: '99.00',
        isActive: true,
      ),
    );
  }

  PtSubscription ptSub({
    PtSubscriptionStatus status = PtSubscriptionStatus.active,
  }) {
    final now = DateTime.now();
    return PtSubscription(
      id: 900,
      memberId: 42,
      ptProductId: 3,
      trainerId: 7,
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 21)),
      weekdays: const [1, 3, 5],
      slotStart: '17:00:00',
      status: status,
      rowVersion: 1,
      productName: 'PT Monthly 3x',
      sessionsPerWeek: 3,
      trainerName: 'Alex Coach',
      slotLabel: '17:00-18:00',
    );
  }

  void stubExtras({required MemberPtSummary pt}) {
    when(() => getMemberships(any())).thenAnswer(
      (_) async => Right(
        CursorPage<Membership>(
          items: [gymMembership()],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => getAttendanceSummary(any())).thenAnswer(
      (_) async => const Right(AttendanceSummaryInfo(visitsThisMonth: 6)),
    );
    when(() => listSchedules(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<ScheduleSession>(
          items: [],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(
      () => getTrainer(any()),
    ).thenAnswer((_) async => const Right(assignedTrainer));
    when(() => getPtSummary(any())).thenAnswer((_) async => Right(pt));
  }

  setUpAll(() {
    registerFallbackValue(const MemberIdParams('42'));
    registerFallbackValue(const GetMembershipsParams());
    registerFallbackValue(const GetAttendanceSummaryParams());
    registerFallbackValue(const ListSchedulesParams());
  });

  setUp(() {
    getMember = MockGetMemberUseCase();
    updateMember = MockUpdateMemberUseCase();
    getMemberships = MockGetMembershipsUseCase();
    getAttendanceSummary = MockGetAttendanceSummaryUseCase();
    getTrainer = MockGetTrainerUseCase();
    listSchedules = MockListSchedulesUseCase();
    listMemberGoals = MockListMemberGoalsUseCase();
    getPtSummary = MockGetMemberPtSummaryUseCase();
    renewPt = MockRenewPtUseCase();
    sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: trainerPrincipal,
        capabilities: Capabilities(
          slugs: ['goals.read', 'memberships.read', 'pt_subscriptions.read'],
        ),
      ),
    );

    when(() => getMember(42)).thenAnswer((_) async => const Right(testPerson));
    when(() => listMemberGoals(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<MemberGoal>(items: [], nextCursor: null, hasMore: false),
      ),
    );

    getIt.registerFactory<MemberDossierCubit>(
      () => MemberDossierCubit(
        getMember,
        updateMember,
        getMemberships,
        getAttendanceSummary,
        getTrainer,
        listSchedules,
        getPtSummary,
        renewPt,
      ),
    );
    getIt.registerFactory<GoalsListCubit>(
      () => GoalsListCubit(listMemberGoals),
    );
    getIt.registerSingleton<SessionCubit>(sessionCubit);
  });

  tearDown(() => getIt.reset());

  /// Mounts [MemberDossierScreen] under a real GoRouter at [initialLocation]
  /// so `GoRouterState.of(context).uri.path` resolves the trainer/admin
  /// shell the same way the app's own route tree would. The leaf route
  /// records whether the active-session route was reached.
  Future<bool> pumpDossierAt(
    WidgetTester tester,
    String initialLocation,
  ) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    var reachedActiveSession = false;
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/trainer/members/:id',
          builder: (context, state) => MemberDossierScreen(
            memberId: int.parse(state.pathParameters['id']!),
          ),
          routes: [
            GoRoute(
              path: 'workout/active',
              builder: (context, state) {
                reachedActiveSession = true;
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/admin/members/:id',
          builder: (context, state) => MemberDossierScreen(
            memberId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
            splashFactory: NoSplash.splashFactory,
          ),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return reachedActiveSession;
  }

  testWidgets(
    'shown for trainer shell with an active, non-read-only PT and tapping it '
    'navigates to the active-session route',
    (tester) async {
      stubExtras(
        pt: MemberPtSummary(
          current: ptSub(),
          trainerAccess: TrainerAccess.full,
        ),
      );

      await pumpDossierAt(tester, '/trainer/members/42');

      expect(find.text(PeopleStrings.startWorkoutSession), findsOneWidget);

      await tester.tap(find.text(PeopleStrings.startWorkoutSession));
      await tester.pumpAndSettle();

      expect(find.text(PeopleStrings.startWorkoutSession), findsNothing);
    },
  );

  testWidgets('hidden when the trainer is read-only (PT ended)', (
    tester,
  ) async {
    final ended = ptSub(status: PtSubscriptionStatus.completed);
    stubExtras(
      pt: MemberPtSummary(history: [ended], trainerAccess: TrainerAccess.readOnly),
    );

    await pumpDossierAt(tester, '/trainer/members/42');

    expect(find.text(PeopleStrings.startWorkoutSession), findsNothing);
  });

  testWidgets('hidden when PT is only scheduled (not yet active)', (
    tester,
  ) async {
    stubExtras(
      pt: MemberPtSummary(
        current: ptSub(status: PtSubscriptionStatus.scheduled),
        trainerAccess: TrainerAccess.full,
      ),
    );

    await pumpDossierAt(tester, '/trainer/members/42');

    expect(find.text(PeopleStrings.startWorkoutSession), findsNothing);
  });

  testWidgets('hidden when PT was never purchased', (tester) async {
    stubExtras(pt: const MemberPtSummary());

    await pumpDossierAt(tester, '/trainer/members/42');

    expect(find.text(PeopleStrings.startWorkoutSession), findsNothing);
  });

  testWidgets('hidden in the admin shell even with an active PT', (
    tester,
  ) async {
    stubExtras(
      pt: MemberPtSummary(current: ptSub(), trainerAccess: TrainerAccess.full),
    );

    await pumpDossierAt(tester, '/admin/members/42');

    expect(find.text(PeopleStrings.startWorkoutSession), findsNothing);
  });
}
