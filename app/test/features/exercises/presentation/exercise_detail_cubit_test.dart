import 'package:app/core/error/failures.dart';
import 'package:app/features/exercises/domain/entities/exercise.dart';
import 'package:app/features/exercises/domain/usecases/get_exercise_usecase.dart';
import 'package:app/features/exercises/presentation/cubit/exercise_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExerciseUseCase extends Mock implements GetExerciseUseCase {}

void main() {
  late MockGetExerciseUseCase mockUseCase;

  const tExercise = Exercise(
    id: '1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: ['Triceps'],
    equipmentNeeded: ['Barbell'],
    instructions: 'Press bar',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  setUp(() {
    mockUseCase = MockGetExerciseUseCase();
  });

  group('ExerciseDetailCubit (K7)', () {
    test('initial state has initial status and null exercise', () {
      final cubit = ExerciseDetailCubit(mockUseCase);
      expect(cubit.state.status, ExerciseDetailStatus.initial);
      expect(cubit.state.exercise, isNull);
    });

    blocTest<ExerciseDetailCubit, ExerciseDetailState>(
      'loadExercise success emits [loading, success]',
      build: () {
        when(
          () => mockUseCase('1'),
        ).thenAnswer((_) async => const Right(tExercise));
        return ExerciseDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadExercise('1'),
      expect: () => [
        const ExerciseDetailState(status: ExerciseDetailStatus.loading),
        const ExerciseDetailState(
          status: ExerciseDetailStatus.success,
          exercise: tExercise,
        ),
      ],
    );

    blocTest<ExerciseDetailCubit, ExerciseDetailState>(
      'loadExercise not found emits [loading, failure(NotFoundFailure)]',
      build: () {
        when(
          () => mockUseCase('999'),
        ).thenAnswer((_) async => const Left(NotFoundFailure()));
        return ExerciseDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadExercise('999'),
      expect: () => [
        const ExerciseDetailState(status: ExerciseDetailStatus.loading),
        const ExerciseDetailState(
          status: ExerciseDetailStatus.failure,
          failure: NotFoundFailure(),
        ),
      ],
    );

    blocTest<ExerciseDetailCubit, ExerciseDetailState>(
      'loadExercise network failure emits [loading, failure(NetworkFailure)]',
      build: () {
        when(
          () => mockUseCase('1'),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return ExerciseDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadExercise('1'),
      expect: () => [
        const ExerciseDetailState(status: ExerciseDetailStatus.loading),
        const ExerciseDetailState(
          status: ExerciseDetailStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );
  });
}
