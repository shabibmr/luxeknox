import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/progress_notes_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goal_detail_cubit.dart';
import 'package:luxeknox/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';

class _MockGetGoal extends Mock implements GetGoalUseCase {}

class _MockCheckIn extends Mock implements CheckInGoalUseCase {}

class _MockListNotes extends Mock implements ListProgressNotesUseCase {}

class _MockGetMember extends Mock implements GetMemberUseCase {}

class _MockGetTrainer extends Mock implements GetTrainerUseCase {}

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

const _trainerProfile = TrainerProfile(
  id: 7,
  userId: 2,
  firstName: 'Terry',
  lastName: 'Trainer',
);

void main() {
  const goalId = '1';
  const memberId = '9';

  const goal = MemberGoal(
    id: goalId,
    memberId: memberId,
    metricId: '4',
    baselineValue: 80,
    targetValue: 70,
    currentValue: 76,
    startDate: null,
    targetDate: null,
    status: GoalStatus.inProgress,
    metric: GoalMetric(
      id: '4',
      name: 'Weight',
      unitOfMeasure: 'kg',
      category: GoalMetricCategory.bodyComposition,
      isActive: true,
    ),
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member',
    profileId: memberId,
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer',
    profileId: '7',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: '1',
  );

  late _MockGetGoal getGoal;
  late _MockCheckIn checkIn;
  late _MockListNotes listNotes;
  late _MockGetMember getMember;
  late _MockGetTrainer getTrainer;

  setUpAll(() {
    registerFallbackValue(const ListProgressNotesParams(memberId: '0'));
    registerFallbackValue(
      const CheckInGoalParams(id: '0', recordedValue: 0),
    );
  });

  setUp(() {
    getGoal = _MockGetGoal();
    checkIn = _MockCheckIn();
    listNotes = _MockListNotes();
    getMember = _MockGetMember();
    getTrainer = _MockGetTrainer();

    when(() => getGoal(any())).thenAnswer((_) async => const Right(goal));
    when(() => listNotes(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: <ProgressNote>[], nextCursor: null, hasMore: false),
      ),
    );
    when(() => getMember(any())).thenAnswer(
      (_) async => const Right(
        Person(
          id: 9,
          userId: 1,
          membershipNumber: 'M9',
          firstName: 'Pat',
          lastName: 'Member',
          assignedTrainerId: 7,
        ),
      ),
    );
    when(() => getTrainer(any())).thenAnswer(
      (_) async => const Right(_trainerProfile),
    );

    getIt.registerFactory<GoalDetailCubit>(
      () => GoalDetailCubit(getGoal, checkIn, listNotes),
    );
    getIt.registerSingleton<GetMemberUseCase>(getMember);
    getIt.registerSingleton<GetTrainerUseCase>(getTrainer);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpDetail(
    WidgetTester tester, {
    required Principal principal,
    required Capabilities capabilities,
    required String location,
    bool isAssignedTrainer = false,
  }) async {
    final session = _MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    getIt.registerSingleton<SessionCubit>(session);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: '/progress/goal/:id',
          builder: (context, state) => GoalDetailScreen(
            goalId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/trainer/members/:id/goals/goal/:goalId',
          builder: (context, state) => GoalDetailScreen(
            goalId: state.pathParameters['goalId']!,
            isAssignedTrainer: isAssignedTrainer,
          ),
        ),
        GoRoute(
          path: '/admin/members/:id/goals/goal/:goalId',
          builder: (context, state) => GoalDetailScreen(
            goalId: state.pathParameters['goalId']!,
          ),
        ),
        GoRoute(
          path: '/progress/measurements',
          builder: (context, state) => const Scaffold(body: Text('member-meas')),
        ),
        GoRoute(
          path: '/trainer/members/:id/goals/measurements/new',
          builder: (context, state) =>
              const Scaffold(body: Text('trainer-meas-new')),
        ),
        GoRoute(
          path: '/admin/members/:id/goals/measurements/new',
          builder: (context, state) =>
              const Scaffold(body: Text('admin-meas-new')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('member shell shows check-in only', (tester) async {
    await pumpDetail(
      tester,
      principal: memberPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/progress/goal/$goalId',
    );

    expect(find.byKey(const Key('goal-view-check-in')), findsOneWidget);
    expect(find.byKey(const Key('goal-view-edit')), findsNothing);
    expect(find.byKey(const Key('goal-view-record')), findsNothing);
  });

  testWidgets('assigned trainer shows edit, record, and check-in', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      principal: trainerPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/trainer/members/$memberId/goals/goal/$goalId',
      isAssignedTrainer: true,
    );

    expect(find.byKey(const Key('goal-view-check-in')), findsOneWidget);
    expect(find.byKey(const Key('goal-view-edit')), findsOneWidget);
    expect(find.byKey(const Key('goal-view-record')), findsOneWidget);
  });

  testWidgets('unassigned trainer shows no detail actions', (tester) async {
    when(() => getMember(any())).thenAnswer(
      (_) async => const Right(
        Person(
          id: 9,
          userId: 1,
          membershipNumber: 'M9',
          firstName: 'Pat',
          lastName: 'Member',
        ),
      ),
    );

    await pumpDetail(
      tester,
      principal: trainerPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/trainer/members/$memberId/goals/goal/$goalId',
      isAssignedTrainer: false,
    );

    expect(find.byKey(const Key('goal-view-check-in')), findsNothing);
    expect(find.byKey(const Key('goal-view-edit')), findsNothing);
    expect(find.byKey(const Key('goal-view-record')), findsNothing);
  });

  testWidgets('admin shell shows edit, record, and check-in', (tester) async {
    await pumpDetail(
      tester,
      principal: adminPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/admin/members/$memberId/goals/goal/$goalId',
    );

    expect(find.byKey(const Key('goal-view-check-in')), findsOneWidget);
    expect(find.byKey(const Key('goal-view-edit')), findsOneWidget);
    expect(find.byKey(const Key('goal-view-record')), findsOneWidget);
  });

  testWidgets('admin record opens measurements/new', (tester) async {
    await pumpDetail(
      tester,
      principal: adminPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/admin/members/$memberId/goals/goal/$goalId',
    );

    await tester.tap(find.byKey(const Key('goal-view-record')));
    await tester.pumpAndSettle();

    expect(find.text('admin-meas-new'), findsOneWidget);
  });

  testWidgets('member record is not shown; no push to trainer add-measurement', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      principal: memberPrincipal,
      capabilities: const Capabilities(slugs: ['goals.write']),
      location: '/progress/goal/$goalId',
    );

    expect(find.byKey(const Key('goal-view-record')), findsNothing);
  });
}
