import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_summary.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goals_list_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/progress_hub_screen.dart';
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
import 'package:luxeknox/features/pt/presentation/pt_strings.dart';
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

  const adminPrincipal = Principal(
    userId: '9',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'a1',
  );

  const assignedTrainer = TrainerProfile(
    id: 7,
    userId: 70,
    firstName: 'Alex',
    lastName: 'Coach',
  );

  Membership gymMembership({int daysUntilExpiry = 45}) {
    final end = DateTime.now().add(Duration(days: daysUntilExpiry));
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

  PtSubscription ptSub({PtSubscriptionStatus status = PtSubscriptionStatus.active}) {
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

  void stubExtras({
    Membership? membership,
    MemberPtSummary pt = const MemberPtSummary(),
    int visitsThisMonth = 6,
    TrainerProfile? trainer = assignedTrainer,
  }) {
    when(() => getMemberships(any())).thenAnswer(
      (_) async => Right(
        CursorPage<Membership>(
          items: membership == null ? const [] : [membership],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => getAttendanceSummary(any())).thenAnswer(
      (_) async => Right(
        AttendanceSummaryInfo(visitsThisMonth: visitsThisMonth),
      ),
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
    when(() => getTrainer(any())).thenAnswer((_) async => Right(trainer!));
    when(() => getPtSummary(any())).thenAnswer((_) async => Right(pt));
  }

  void signInAs(Principal principal, List<String> slugs) {
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: Capabilities(slugs: slugs),
      ),
    );
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
    signInAs(trainerPrincipal, [
      'goals.read',
      'goals.write',
      'goals.create',
      'goals.update',
      'memberships.read',
      'pt_subscriptions.read',
    ]);

    when(() => getMember(42)).thenAnswer((_) async => const Right(testPerson));
    when(() => listMemberGoals(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<MemberGoal>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    stubExtras(membership: null);

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

  Future<void> pumpDossier(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const MemberDossierScreen(memberId: 42),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows membership expiry, attendance, and hides inline edit', (
    tester,
  ) async {
    stubExtras(membership: gymMembership(daysUntilExpiry: 12));

    await pumpDossier(tester);

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text(PeopleStrings.membershipExpiry), findsOneWidget);
    expect(find.textContaining('days left'), findsWidgets);
    expect(find.text(PeopleStrings.attendanceThisMonth), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text(PeopleStrings.firstName), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsNothing);
    expect(find.text(PeopleStrings.ptNotPurchased), findsOneWidget);
    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
  });

  testWidgets('edit icon reveals inline editable profile fields', (
    tester,
  ) async {
    stubExtras(membership: gymMembership());

    await pumpDossier(tester);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.firstName), findsOneWidget);
    expect(find.text(PeopleStrings.save), findsOneWidget);
  });

  testWidgets('active PT shows package, slot, trainer and coaching modules', (
    tester,
  ) async {
    stubExtras(
      membership: gymMembership(),
      pt: MemberPtSummary(
        current: ptSub(),
        history: [ptSub()],
        trainerAccess: TrainerAccess.full,
      ),
    );

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.ptActive), findsOneWidget);
    expect(find.text('PT Monthly 3x'), findsOneWidget);
    expect(find.textContaining('Mon / Wed / Fri · 17:00-18:00'), findsOneWidget);
    expect(find.text('Alex Coach'), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsOneWidget);
    expect(find.text(PeopleStrings.workoutPlan), findsOneWidget);
    expect(find.text(PeopleStrings.dietPlan), findsOneWidget);
    expect(find.text(PtStrings.readOnlyBanner), findsNothing);
    // Trainers cannot sell, renew or re-plan PT.
    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
    expect(find.text(PtStrings.renew), findsNothing);
    expect(find.text(PtStrings.changeTrainerSlot), findsNothing);
  });

  testWidgets('trainer with active PT can create goals', (tester) async {
    stubExtras(
      membership: gymMembership(),
      pt: MemberPtSummary(current: ptSub(), trainerAccess: TrainerAccess.full),
    );

    await pumpDossier(tester);

    await tester.tap(find.text(PeopleStrings.goals));
    await tester.pumpAndSettle();

    expect(find.byType(ProgressHubScreen), findsOneWidget);
    expect(find.text(GoalsStrings.hubTitle), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('trainer is read-only after PT ended', (tester) async {
    final ended = ptSub(status: PtSubscriptionStatus.completed);
    stubExtras(
      membership: gymMembership(),
      pt: MemberPtSummary(history: [ended], trainerAccess: TrainerAccess.readOnly),
    );

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.ptExpired), findsOneWidget);
    expect(find.text(PtStrings.readOnlyBanner), findsOneWidget);

    await tester.tap(find.text(PeopleStrings.goals));
    await tester.pumpAndSettle();

    expect(find.byType(ProgressHubScreen), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('admin can add PT when membership is active and no PT is running', (
    tester,
  ) async {
    signInAs(adminPrincipal, ['pt_subscriptions.create', 'pt_subscriptions.manage']);
    stubExtras(membership: gymMembership());

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.addPersonalTraining), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsNothing);
  });

  testWidgets('admin cannot add PT when the membership has expired', (
    tester,
  ) async {
    signInAs(adminPrincipal, ['pt_subscriptions.create']);
    stubExtras(membership: gymMembership(daysUntilExpiry: -3));

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
  });

  testWidgets('admin sees renew and change trainer/slot on an active PT', (
    tester,
  ) async {
    signInAs(adminPrincipal, ['pt_subscriptions.create', 'pt_subscriptions.manage']);
    stubExtras(
      membership: gymMembership(),
      pt: MemberPtSummary(current: ptSub(), history: [ptSub()]),
    );

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
    expect(find.text(PtStrings.renew), findsOneWidget);
    expect(find.text(PtStrings.changeTrainerSlot), findsOneWidget);
  });

  testWidgets('PT summary failure shows unavailable instead of not purchased', (
    tester,
  ) async {
    stubExtras(membership: gymMembership());
    when(() => getPtSummary(any())).thenAnswer((_) async => const Left(NetworkFailure()));

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.ptNotPurchased), findsNothing);
    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
  });

  testWidgets(
    'memberships load failure surfaces an error',
    (tester) async {
      when(() => getMemberships(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
      expect(find.text(PeopleStrings.unavailable), findsWidgets);
      expect(find.text('6'), findsOneWidget);
      expect(
        find.text('Network error. Please check your connection and try again.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('attendance load failure does not show zero visits', (
    tester,
  ) async {
    stubExtras(membership: gymMembership());
    when(() => getAttendanceSummary(any())).thenAnswer(
      (_) async => const Left(NetworkFailure()),
    );

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.attendanceThisMonth), findsOneWidget);
    expect(find.text(PeopleStrings.unavailable), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });
}
