import 'package:app/core/error/failures.dart';
import 'package:app/core/presentation/load_status.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/exercises/domain/entities/exercise.dart';
import 'package:app/features/exercises/domain/entities/exercise_filter.dart';
import 'package:app/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:app/features/exercises/presentation/bloc/exercise_list_bloc.dart';
import 'package:app/features/exercises/presentation/bloc/exercise_list_event.dart';
import 'package:app/features/exercises/presentation/bloc/exercise_list_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}

void main() {
  late MockGetExercisesUseCase mockUseCase;

  const tExercise1 = Exercise(
    id: '1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: 'Push',
    difficultyLevel: 'Beginner',
    isActive: true,
  );

  const tExercise2 = Exercise(
    id: '2',
    name: 'Squat',
    primaryMuscleGroup: 'Legs',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: 'Squat down',
    difficultyLevel: 'Advanced',
    isActive: true,
  );

  setUpAll(() {
    registerFallbackValue(const GetExercisesParams());
  });

  setUp(() {
    mockUseCase = MockGetExercisesUseCase();
  });

  group('ExerciseListBloc (K1, K2, K3 & L7)', () {
    test('initial state has initial status and empty items', () {
      final bloc = ExerciseListBloc(getExercisesUseCase: mockUseCase);
      expect(bloc.state.status, LoadStatus.initial);
      expect(bloc.state.items, isEmpty);
    });

    blocTest<ExerciseListBloc, ExerciseListState>(
      'started emits loading then success with items',
      build: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<Exercise>(
              items: [tExercise1],
              nextCursor: 'c1',
              hasMore: true,
            ),
          ),
        );
        return ExerciseListBloc(getExercisesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const ExerciseListStarted()),
      expect: () => [
        const ExerciseListState(status: LoadStatus.loading),
        const ExerciseListState(
          status: LoadStatus.success,
          items: [tExercise1],
          cursor: 'c1',
          hasMore: true,
        ),
      ],
    );

    blocTest<ExerciseListBloc, ExerciseListState>(
      'pagination retains existing items while loading next page and appends them',
      build: () {
        when(
          () => mockUseCase(
            const GetExercisesParams(filter: ExerciseFilter(), cursor: 'c1'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            CursorPage<Exercise>(
              items: [tExercise2],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return ExerciseListBloc(getExercisesUseCase: mockUseCase);
      },
      seed: () => const ExerciseListState(
        status: LoadStatus.success,
        items: [tExercise1],
        cursor: 'c1',
        hasMore: true,
      ),
      act: (bloc) => bloc.add(const ExerciseListNextPageRequested()),
      expect: () => [
        const ExerciseListState(
          status: LoadStatus.loading,
          items: [tExercise1],
          cursor: 'c1',
          hasMore: true,
        ),
        const ExerciseListState(
          status: LoadStatus.success,
          items: [tExercise1, tExercise2],
          cursor: null,
          hasMore: false,
        ),
      ],
    );

    blocTest<ExerciseListBloc, ExerciseListState>(
      'failure emits failure state with Failure object',
      build: () {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return ExerciseListBloc(getExercisesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const ExerciseListStarted()),
      expect: () => [
        const ExerciseListState(status: LoadStatus.loading),
        const ExerciseListState(
          status: LoadStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );

    test('rapid search events debounce to a single call', () async {
      when(() => mockUseCase(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<Exercise>(
            items: [tExercise1],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );

      final bloc = ExerciseListBloc(
        getExercisesUseCase: mockUseCase,
        debounceDuration: const Duration(milliseconds: 100),
      );

      // Rapidly fire 3 events
      bloc.add(const ExerciseListSearchChanged('b'));
      bloc.add(const ExerciseListSearchChanged('be'));
      bloc.add(const ExerciseListSearchChanged('bench'));

      // Wait past debounce
      await Future<void>.delayed(const Duration(milliseconds: 200));

      verify(() => mockUseCase(any())).called(1);
      await bloc.close();
    });
  });
}
