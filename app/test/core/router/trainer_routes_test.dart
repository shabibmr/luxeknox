import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/router/app_router.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:luxeknox/features/people/presentation/bloc/members_directory_bloc.dart';
import 'package:luxeknox/features/people/presentation/cubit/member_dossier_cubit.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/features/workout/presentation/bloc/active_workout_bloc.dart';
import 'package:luxeknox/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:luxeknox/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

class MockMemberDossierCubit extends MockCubit<MemberDossierState>
    implements MemberDossierCubit {}

class MockMembersDirectoryBloc
    extends MockBloc<MembersDirectoryEvent, MembersDirectoryState>
    implements MembersDirectoryBloc {}

class MockActiveWorkoutBloc extends MockBloc<ActiveWorkoutEvent, ActiveWorkoutState>
    implements ActiveWorkoutBloc {}

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

/// Covers the Task 6 trainer route: `/trainer/members/:id/workout/active`
/// resolves through the real GoRouter and builds [ActiveWorkoutScreen] with
/// the member id, workout plan id (from the query string) and a trainer
/// history path — not the member app's own history route.
void main() {
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const readOnlyCapabilities = Capabilities(slugs: []);

  late MockActiveWorkoutBloc activeWorkoutBloc;

  setUpAll(() {
    registerFallbackValue(const ListSchedulesParams());
  });

  setUp(() {
    activeWorkoutBloc = MockActiveWorkoutBloc();
    whenListen(
      activeWorkoutBloc,
      const Stream<ActiveWorkoutState>.empty(),
      initialState: const ActiveWorkoutState(),
    );
    when(() => activeWorkoutBloc.restTimer).thenReturn(RestTimerCubit());

    final memberDossierCubit = MockMemberDossierCubit();
    whenListen(
      memberDossierCubit,
      const Stream<MemberDossierState>.empty(),
      initialState: const MemberDossierState(),
    );
    when(() => memberDossierCubit.load(any())).thenAnswer((_) async {});

    final membersDirectoryBloc = MockMembersDirectoryBloc();
    whenListen(
      membersDirectoryBloc,
      const Stream<MembersDirectoryState>.empty(),
      initialState: const MembersDirectoryState(),
    );

    getIt.registerFactory<ActiveWorkoutBloc>(() => activeWorkoutBloc);
    getIt.registerFactory<MemberDossierCubit>(() => memberDossierCubit);
    getIt.registerFactory<MembersDirectoryBloc>(() => membersDirectoryBloc);

    // The trainer shell's home branch loads (and stays mounted) once the
    // router's initial location redirects an authenticated trainer there,
    // before this test navigates on to the members branch under test.
    final mockGetDashboardUseCase = MockGetDashboardUseCase();
    when(
      () => mockGetDashboardUseCase(const NoParams()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardCubit>(
      () => DashboardCubit(mockGetDashboardUseCase),
    );
    final mockListSchedulesUseCase = MockListSchedulesUseCase();
    when(
      () => mockListSchedulesUseCase(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<DashboardAgendaCubit>(
      () => DashboardAgendaCubit(mockListSchedulesUseCase),
    );
  });

  tearDown(() => getIt.reset());

  Future<GoRouter> pumpRouterAs(WidgetTester tester) async {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: trainerPrincipal,
        capabilities: readOnlyCapabilities,
      ),
    );
    final router = createRouter(sessionCubit);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets(
    'builds ActiveWorkoutScreen with memberId, workoutPlanId and the '
    "trainer's history path",
    (tester) async {
      final router = await pumpRouterAs(tester);
      router.go('/trainer/members/42/workout/active?workoutPlanId=7');
      await tester.pumpAndSettle();

      final screen = tester.widget<ActiveWorkoutScreen>(
        find.byType(ActiveWorkoutScreen),
      );
      expect(screen.memberId, '42');
      expect(screen.workoutPlanId, '7');
      expect(screen.historyPath, '/trainer/members/42/workout-history');

      verify(
        () => activeWorkoutBloc.add(
          const ActiveWorkoutConfigured(memberId: '42', workoutPlanId: '7'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'builds ActiveWorkoutScreen with no workoutPlanId when the query param is absent',
    (tester) async {
      final router = await pumpRouterAs(tester);
      router.go('/trainer/members/42/workout/active');
      await tester.pumpAndSettle();

      final screen = tester.widget<ActiveWorkoutScreen>(
        find.byType(ActiveWorkoutScreen),
      );
      expect(screen.memberId, '42');
      expect(screen.workoutPlanId, isNull);
      expect(screen.historyPath, '/trainer/members/42/workout-history');
    },
  );
}
