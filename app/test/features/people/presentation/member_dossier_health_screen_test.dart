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
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_memberships_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/lifestyle_intake.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/usecases/get_lifestyle_intake_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_par_q_usecase.dart';
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

class MockGetMemberPtSummaryUseCase extends Mock
    implements GetMemberPtSummaryUseCase {}

class MockRenewPtUseCase extends Mock implements RenewPtUseCase {}

class MockGetParQUseCase extends Mock implements GetParQUseCase {}

class MockGetLifestyleIntakeUseCase extends Mock
    implements GetLifestyleIntakeUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockGetMemberUseCase getMember;
  late MockGetTrainerUseCase getTrainer;
  late MockGetParQUseCase getParQ;
  late MockGetLifestyleIntakeUseCase getLifestyle;
  late MockSessionCubit sessionCubit;

  const person = Person(
    id: 42,
    userId: 101,
    membershipNumber: 'MEM-042',
    firstName: 'John',
    lastName: 'Doe',
  );

  const trainer = Principal(
    userId: '9',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: '9',
  );

  const admin = Principal(
    userId: '2',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: '2',
  );

  const manager = Principal(
    userId: '3',
    userType: UserType.employee,
    displayName: 'Manager',
    profileId: '3',
  );

  ParQScreening screening(ParQClearanceStatus status) => ParQScreening(
    id: 5,
    memberId: 42,
    version: 'PAR-Q+ 2024',
    answers: List.filled(7, ParQAnswer.no),
    hasPositiveAnswer: status != ParQClearanceStatus.passed,
    referralRequired: false,
    declarationAccepted: true,
    clearanceStatus: status,
    createdAt: DateTime.utc(2026, 3, 1),
  );

  final intake = LifestyleIntake(
    id: 3,
    memberId: 42,
    stressLevel: 7,
    sleepHoursTypical: 6.5,
    activityLevel: ActivityLevel.moderate,
    priorities: const [
      LifestylePriority(
        domain: LifestylePriorityDomain.sleep,
        currentStatus: 'Wakes at 3am',
        firstAction: 'No screens after 10pm',
      ),
      LifestylePriority(
        domain: LifestylePriorityDomain.nutrition,
        currentStatus: 'Skips breakfast',
        firstAction: 'Protein at breakfast',
      ),
      LifestylePriority(
        domain: LifestylePriorityDomain.activity,
        currentStatus: '4k steps a day',
        firstAction: 'Daily 20 min walk',
      ),
      LifestylePriority(
        domain: LifestylePriorityDomain.recovery,
        currentStatus: 'No rest days',
        firstAction: 'One full rest day',
      ),
    ],
    createdAt: DateTime.utc(2026, 3, 1),
  );

  void signInWith(List<String> slugs, {Principal principal = admin}) {
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
    registerFallbackValue(const GetMembershipsParams());
    registerFallbackValue(const GetAttendanceSummaryParams());
    registerFallbackValue(const ListSchedulesParams());
    registerFallbackValue(0);
  });

  setUp(() {
    getMember = MockGetMemberUseCase();
    getTrainer = MockGetTrainerUseCase();
    when(() => getTrainer(any())).thenAnswer(
      (_) async => const Right(
        TrainerProfile(id: 9, userId: 9, firstName: 'Trainer', lastName: 'One'),
      ),
    );
    final getMemberships = MockGetMembershipsUseCase();
    final getAttendance = MockGetAttendanceSummaryUseCase();
    final listSchedules = MockListSchedulesUseCase();
    final getPtSummary = MockGetMemberPtSummaryUseCase();
    getParQ = MockGetParQUseCase();
    getLifestyle = MockGetLifestyleIntakeUseCase();
    sessionCubit = MockSessionCubit();
    signInWith(['health.read', 'memberships.read', 'pt_subscriptions.read']);

    when(() => getMember(42)).thenAnswer((_) async => const Right(person));
    when(() => getMemberships(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<Membership>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    when(() => getAttendance(any())).thenAnswer(
      (_) async => const Right(AttendanceSummaryInfo(visitsThisMonth: 1)),
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
      () => getPtSummary(42),
    ).thenAnswer((_) async => const Right(MemberPtSummary()));
    when(
      () => getParQ(42),
    ).thenAnswer((_) async => const Left(NotFoundFailure()));
    when(
      () => getLifestyle(42),
    ).thenAnswer((_) async => const Left(NotFoundFailure()));

    getIt.registerFactory<MemberDossierCubit>(
      () => MemberDossierCubit(
        getMember,
        MockUpdateMemberUseCase(),
        getMemberships,
        getAttendance,
        getTrainer,
        listSchedules,
        getPtSummary,
        MockRenewPtUseCase(),
        getParQ,
        getLifestyle,
      ),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpDossier(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const MaterialApp(home: MemberDossierScreen(memberId: 42)),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('health clearance banner', () {
    testWidgets('is green when the latest screening passed', (tester) async {
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => Right(screening(ParQClearanceStatus.passed)));

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceCleared), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-green')), findsOneWidget);
    });

    testWidgets('is green once a pending screening is cleared', (tester) async {
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => Right(screening(ParQClearanceStatus.cleared)));

      await pumpDossier(tester);

      expect(find.byKey(const ValueKey('clearance-green')), findsOneWidget);
    });

    testWidgets('is red while clearance is pending', (tester) async {
      when(() => getParQ(42)).thenAnswer(
        (_) async => Right(screening(ParQClearanceStatus.pendingClearance)),
      );

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearancePending), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-red')), findsOneWidget);
    });

    testWidgets('is red when clearance was rejected', (tester) async {
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => Right(screening(ParQClearanceStatus.rejected)));

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceRejected), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-red')), findsOneWidget);
    });

    testWidgets('is neutral when no screening is on file', (tester) async {
      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceNone), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-green')), findsNothing);
      expect(find.byKey(const ValueKey('clearance-red')), findsNothing);
    });

    testWidgets('says unavailable when the screening could not be loaded', (
      tester,
    ) async {
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceUnavailable), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-neutral')), findsOneWidget);
      expect(find.byKey(const ValueKey('clearance-green')), findsNothing);
      expect(find.byKey(const ValueKey('clearance-red')), findsNothing);
    });

    testWidgets('is hidden from users without health.read', (tester) async {
      signInWith(['memberships.read', 'pt_subscriptions.read']);
      when(() => getParQ(42)).thenAnswer(
        (_) async => Right(screening(ParQClearanceStatus.pendingClearance)),
      );

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearancePending), findsNothing);
      expect(find.text(PeopleStrings.dossierTabLifestyle), findsNothing);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('hides banner and Lifestyle tab from an unassigned trainer', (
      tester,
    ) async {
      signInWith([
        'health.read',
        'memberships.read',
        'pt_subscriptions.read',
      ], principal: trainer);
      when(() => getMember(42)).thenAnswer(
        (_) async => const Right(
          Person(
            id: 42,
            userId: 101,
            membershipNumber: 'MEM-042',
            firstName: 'John',
            lastName: 'Doe',
            assignedTrainerId: 4,
          ),
        ),
      );
      when(() => getParQ(42)).thenAnswer(
        (_) async => Right(screening(ParQClearanceStatus.pendingClearance)),
      );

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearancePending), findsNothing);
      expect(find.text(PeopleStrings.dossierTabLifestyle), findsNothing);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('shows banner and Lifestyle tab to the assigned trainer', (
      tester,
    ) async {
      signInWith([
        'health.read',
        'memberships.read',
        'pt_subscriptions.read',
      ], principal: trainer);
      when(() => getMember(42)).thenAnswer(
        (_) async => const Right(
          Person(
            id: 42,
            userId: 101,
            membershipNumber: 'MEM-042',
            firstName: 'John',
            lastName: 'Doe',
            assignedTrainerId: 9,
          ),
        ),
      );
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => Right(screening(ParQClearanceStatus.cleared)));

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceCleared), findsOneWidget);
      expect(find.text(PeopleStrings.dossierTabLifestyle), findsOneWidget);
    });

    testWidgets('shows banner and Lifestyle tab to a manager for any member', (
      tester,
    ) async {
      signInWith([
        'health.read',
        'memberships.read',
        'pt_subscriptions.read',
      ], principal: manager);
      when(
        () => getParQ(42),
      ).thenAnswer((_) async => Right(screening(ParQClearanceStatus.rejected)));

      await pumpDossier(tester);

      expect(find.text(PeopleStrings.clearanceRejected), findsOneWidget);
      expect(find.text(PeopleStrings.dossierTabLifestyle), findsOneWidget);
    });
  });

  group('Lifestyle & Habits tab', () {
    Future<void> openLifestyleTab(WidgetTester tester) async {
      await pumpDossier(tester);
      await tester.tap(find.text(PeopleStrings.dossierTabLifestyle));
      await tester.pumpAndSettle();
    }

    testWidgets('keeps the overview as the first tab', (tester) async {
      await pumpDossier(tester);

      expect(find.text(PeopleStrings.dossierTabOverview), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('shows stress score, sleep and the four priorities', (
      tester,
    ) async {
      when(() => getLifestyle(42)).thenAnswer((_) async => Right(intake));

      await openLifestyleTab(tester);

      expect(find.text(PeopleStrings.stressScore(7)), findsOneWidget);
      expect(find.text(PeopleStrings.sleepHours(6.5)), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      for (final label in [
        PeopleStrings.lifestyleDomainSleep,
        PeopleStrings.lifestyleDomainNutrition,
        PeopleStrings.lifestyleDomainActivity,
        PeopleStrings.lifestyleDomainRecovery,
      ]) {
        expect(find.text(label), findsWidgets);
      }
      expect(find.text('Wakes at 3am'), findsOneWidget);
      expect(find.text('Skips breakfast'), findsOneWidget);
      expect(find.text('4k steps a day'), findsOneWidget);
      expect(find.text('No rest days'), findsOneWidget);
    });

    testWidgets('shows each first action as a badge', (tester) async {
      when(() => getLifestyle(42)).thenAnswer((_) async => Right(intake));

      await openLifestyleTab(tester);

      expect(find.byType(Chip), findsNWidgets(4));
      expect(find.text('No screens after 10pm'), findsOneWidget);
      expect(find.text('Protein at breakfast'), findsOneWidget);
      expect(find.text('Daily 20 min walk'), findsOneWidget);
      expect(find.text('One full rest day'), findsOneWidget);
    });

    testWidgets('says so when there is no consultation yet', (tester) async {
      await openLifestyleTab(tester);

      expect(find.text(PeopleStrings.lifestyleNone), findsOneWidget);
    });

    testWidgets('says unavailable when the intake could not be loaded', (
      tester,
    ) async {
      when(
        () => getLifestyle(42),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      await openLifestyleTab(tester);

      expect(find.text(PeopleStrings.lifestyleUnavailable), findsOneWidget);
      expect(find.text(PeopleStrings.lifestyleNone), findsNothing);
    });
  });
}
