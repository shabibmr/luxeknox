import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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
import 'package:luxeknox/features/people/domain/usecases/assign_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_member_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/member_dossier_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/member_dossier_screen.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMemberUseCase extends Mock implements GetMemberUseCase {}

class MockUpdateMemberUseCase extends Mock implements UpdateMemberUseCase {}

class MockAssignTrainerUseCase extends Mock implements AssignTrainerUseCase {}

class MockGetMembershipsUseCase extends Mock implements GetMembershipsUseCase {}

class MockGetAttendanceSummaryUseCase extends Mock
    implements GetAttendanceSummaryUseCase {}

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockListMemberGoalsUseCase extends Mock
    implements ListMemberGoalsUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockGetMemberUseCase getMember;
  late MockUpdateMemberUseCase updateMember;
  late MockAssignTrainerUseCase assignTrainer;
  late MockGetMembershipsUseCase getMemberships;
  late MockGetAttendanceSummaryUseCase getAttendanceSummary;
  late MockGetTrainerUseCase getTrainer;
  late MockListSchedulesUseCase listSchedules;
  late MockListMemberGoalsUseCase listMemberGoals;
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

  Membership ptMembership({int daysUntilExpiry = 20}) {
    final end = DateTime.now().add(Duration(days: daysUntilExpiry));
    return Membership(
      id: 'm1',
      memberId: '42',
      productId: 'p1',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: end,
      remainingPtSessions: 4,
      status: MembershipStatus.active,
      rowVersion: 1,
      product: const MembershipProduct(
        id: 'p1',
        name: 'PT Pack',
        code: 'PT',
        durationDays: 30,
        basePrice: '199.00',
        ptSessionsIncluded: 8,
        isActive: true,
      ),
    );
  }

  Membership gymOnlyMembership({int daysUntilExpiry = 45}) {
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
        ptSessionsIncluded: 0,
        isActive: true,
      ),
    );
  }

  void stubExtras({
    Membership? membership,
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
    assignTrainer = MockAssignTrainerUseCase();
    getMemberships = MockGetMembershipsUseCase();
    getAttendanceSummary = MockGetAttendanceSummaryUseCase();
    getTrainer = MockGetTrainerUseCase();
    listSchedules = MockListSchedulesUseCase();
    listMemberGoals = MockListMemberGoalsUseCase();
    sessionCubit = MockSessionCubit();

    when(() => getMember(42)).thenAnswer((_) async => const Right(testPerson));
    when(() => listMemberGoals(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<MemberGoal>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    when(() => sessionCubit.state).thenReturn(
      const SessionAuthenticated(
        principal: trainerPrincipal,
        capabilities: Capabilities(
          slugs: ['goals.read', 'goals.write', 'goals.create', 'goals.update'],
        ),
      ),
    );
    stubExtras(membership: null);

    getIt.registerFactory<MemberDossierCubit>(
      () => MemberDossierCubit(
        getMember,
        updateMember,
        assignTrainer,
        getMemberships,
        getAttendanceSummary,
        getTrainer,
        listSchedules,
      ),
    );
    getIt.registerFactory<GoalsListCubit>(
      () => GoalsListCubit(listMemberGoals),
    );
    getIt.registerSingleton<SessionCubit>(sessionCubit);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpDossier(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const MemberDossierScreen(memberId: 42),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows membership expiry, attendance, and hides inline edit', (
    tester,
  ) async {
    stubExtras(membership: gymOnlyMembership(daysUntilExpiry: 12));

    await pumpDossier(tester);

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text(PeopleStrings.membershipExpiry), findsOneWidget);
    expect(find.textContaining('days left'), findsWidgets);
    expect(find.text(PeopleStrings.attendanceThisMonth), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text(PeopleStrings.firstName), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsNothing);
    expect(find.text(PeopleStrings.addPersonalTraining), findsOneWidget);
    expect(find.text('Trainer ID'), findsNothing);
    expect(find.text(PeopleStrings.trainerIdHint), findsNothing);
  });

  testWidgets('edit icon reveals inline editable profile fields', (
    tester,
  ) async {
    stubExtras(membership: gymOnlyMembership());

    await pumpDossier(tester);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.firstName), findsOneWidget);
    expect(find.text(PeopleStrings.save), findsOneWidget);
  });

  testWidgets('PT package shows trainer name and coaching modules', (
    tester,
  ) async {
    stubExtras(membership: ptMembership());

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.ptActive), findsOneWidget);
    expect(find.text('Alex Coach'), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsOneWidget);
    expect(find.text(PeopleStrings.workoutPlan), findsOneWidget);
    expect(find.text(PeopleStrings.dietPlan), findsOneWidget);
    expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
    expect(find.text(PeopleStrings.reassignTrainer), findsOneWidget);
  });

  testWidgets(
    'tapping Goals tile navigates to ProgressHubScreen when PT purchased',
    (tester) async {
      stubExtras(membership: ptMembership());

      await pumpDossier(tester);

      await tester.tap(find.text(PeopleStrings.goals));
      await tester.pumpAndSettle();

      expect(find.byType(ProgressHubScreen), findsOneWidget);
      expect(find.text(GoalsStrings.hubTitle), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );

  testWidgets(
    'memberships load failure does not treat member as gym-only',
    (tester) async {
      when(() => getMemberships(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.addPersonalTraining), findsNothing);
      expect(find.text(PeopleStrings.goals), findsNothing);
      expect(find.text(PeopleStrings.unavailable), findsWidgets);
      expect(find.text(PeopleStrings.ptNotPurchased), findsNothing);
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
    stubExtras(membership: gymOnlyMembership());
    when(() => getAttendanceSummary(any())).thenAnswer(
      (_) async => const Left(NetworkFailure()),
    );

    await pumpDossier(tester);

    expect(find.text(PeopleStrings.attendanceThisMonth), findsOneWidget);
    expect(find.text(PeopleStrings.unavailable), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });
}
