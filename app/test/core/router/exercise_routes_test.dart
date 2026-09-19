import 'package:app/core/di/injector.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/exercises/domain/entities/exercise.dart';
import 'package:app/features/exercises/domain/usecases/get_exercise_usecase.dart';
import 'package:app/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:app/features/exercises/presentation/bloc/exercise_list_bloc.dart';
import 'package:app/features/exercises/presentation/cubit/exercise_detail_cubit.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}

class MockGetExerciseUseCase extends Mock implements GetExerciseUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// Covers the newly wired member/trainer exercise routes (the gap flagged
/// against FR-WORK-002): confirms they actually resolve through the real
/// GoRouter and redirect logic, not just that the path constants exist.
void main() {
  const tExercise = Exercise(
    id: 'ex-1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: 'Push.',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  const trainerPrincipal = Principal(
    userId: '2',
    userType: 'trainer',
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const memberPrincipal = Principal(
    userId: '1',
    userType: 'member',
    displayName: 'Member One',
    profileId: 'p1',
  );
  const readOnlyCapabilities = Capabilities(slugs: ['exercises.read']);

  setUpAll(() {
    registerFallbackValue(const GetExercisesParams());
  });

  setUp(() {
    final mockGetExercisesUseCase = MockGetExercisesUseCase();
    final mockGetExerciseUseCase = MockGetExerciseUseCase();

    when(() => mockGetExercisesUseCase(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [tExercise], nextCursor: null, hasMore: false),
      ),
    );
    when(
      () => mockGetExerciseUseCase(any()),
    ).thenAnswer((_) async => const Right(tExercise));

    getIt.registerFactory<ExerciseListBloc>(
      () => ExerciseListBloc(getExercisesUseCase: mockGetExercisesUseCase),
    );
    getIt.registerFactory<ExerciseDetailCubit>(
      () => ExerciseDetailCubit(mockGetExerciseUseCase),
    );
  });

  tearDown(() => getIt.reset());

  Future<GoRouter> pumpRouterAs(
    WidgetTester tester,
    Principal principal,
  ) async {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
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

  testWidgets('trainer can reach /trainer/plans/exercises (the list)', (
    tester,
  ) async {
    final router = await pumpRouterAs(tester, trainerPrincipal);
    router.go('/trainer/plans/exercises');
    await tester.pumpAndSettle();

    expect(find.text('Exercise Library'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);
  });

  testWidgets('trainer can reach /trainer/plans/exercises/:id (the detail)', (
    tester,
  ) async {
    final router = await pumpRouterAs(tester, trainerPrincipal);
    router.go('/trainer/plans/exercises/ex-1');
    await tester.pumpAndSettle();

    expect(find.text('Exercise Details'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);
  });

  testWidgets('member can reach /home/workout/exercises/:id (the detail)', (
    tester,
  ) async {
    final router = await pumpRouterAs(tester, memberPrincipal);
    router.go('/home/workout/exercises/ex-1');
    await tester.pumpAndSettle();

    expect(find.text('Exercise Details'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);
  });
}
