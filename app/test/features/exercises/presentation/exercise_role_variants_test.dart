import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:luxeknox/features/exercises/domain/usecases/get_exercise_usecase.dart';
import 'package:luxeknox/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:luxeknox/features/exercises/presentation/bloc/exercise_list_bloc.dart';
import 'package:luxeknox/features/exercises/presentation/cubit/exercise_detail_cubit.dart';
import 'package:luxeknox/features/exercises/presentation/screens/exercise_detail_screen.dart';
import 'package:luxeknox/features/exercises/presentation/screens/exercise_library_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}

class MockGetExerciseUseCase extends Mock implements GetExerciseUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// L8 — the acceptance gate for vertical-01 (ADR-0006 §11). Renders the
/// Exercise Library and Exercise Details screens under a member, trainer,
/// and admin principal and asserts that admin-only controls (add/edit)
/// appear only for admin.
void main() {
  const tExercise = Exercise(
    id: 'ex-1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: ['Triceps'],
    equipmentNeeded: ['Barbell'],
    instructions: 'Lower the bar to your chest, then press up.',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const readOnlyCapabilities = Capabilities(slugs: ['exercises.read']);
  const adminCapabilities = Capabilities(
    slugs: ['exercises.read', 'exercises.create', 'exercises.update'],
  );

  late MockGetExercisesUseCase mockGetExercisesUseCase;
  late MockGetExerciseUseCase mockGetExerciseUseCase;

  setUpAll(() {
    registerFallbackValue(const GetExercisesParams());
  });

  setUp(() {
    mockGetExercisesUseCase = MockGetExercisesUseCase();
    mockGetExerciseUseCase = MockGetExerciseUseCase();

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

  Widget wrapWithSession(
    Widget child,
    Principal principal,
    Capabilities capabilities,
  ) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(value: sessionCubit, child: child),
    );
  }

  group('Exercise Library screen role variants (L8)', () {
    testWidgets('member sees browse only, no add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseLibraryScreen(),
          memberPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Bench Press'), findsOneWidget);
    });

    testWidgets('trainer sees browse only, no add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseLibraryScreen(),
          trainerPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Bench Press'), findsOneWidget);
    });

    testWidgets('admin sees the add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseLibraryScreen(),
          adminPrincipal,
          adminCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });

  group('Exercise Details screen role variants (L8)', () {
    testWidgets('member sees details only, no edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseDetailScreen(exerciseId: 'ex-1'),
          memberPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('Bench Press'), findsOneWidget);
    });

    testWidgets('trainer sees details only, no edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseDetailScreen(exerciseId: 'ex-1'),
          trainerPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('Bench Press'), findsOneWidget);
    });

    testWidgets('admin sees the edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const ExerciseDetailScreen(exerciseId: 'ex-1'),
          adminPrincipal,
          adminCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
    });
  });
}
