import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise_filter.dart';
import 'package:luxeknox/features/exercises/domain/repositories/exercise_repository.dart';
import 'package:luxeknox/features/exercises/domain/usecases/create_exercise_usecase.dart';
import 'package:luxeknox/features/exercises/domain/usecases/deactivate_exercise_usecase.dart';
import 'package:luxeknox/features/exercises/domain/usecases/get_exercise_usecase.dart';
import 'package:luxeknox/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:luxeknox/features/exercises/domain/usecases/update_exercise_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late MockExerciseRepository mockRepository;

  const tExercise = Exercise(
    id: '1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: ['Triceps'],
    equipmentNeeded: ['Barbell'],
    instructions: 'Press the bar.',
    videoUrl: 'https://example.com/v.mp4',
    gifUrl: 'https://example.com/g.gif',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  const tPage = CursorPage<Exercise>(
    items: [tExercise],
    nextCursor: 'next_page_token',
    hasMore: true,
  );

  setUp(() {
    mockRepository = MockExerciseRepository();
  });

  group('Exercise UseCases (I4 & L6)', () {
    test('GetExercisesUseCase calls repository.getExercises', () async {
      const filter = ExerciseFilter(searchText: 'bench');
      when(
        () => mockRepository.getExercises(filter, 'c1'),
      ).thenAnswer((_) async => const Right(tPage));

      final useCase = GetExercisesUseCase(mockRepository);
      final result = await useCase(
        const GetExercisesParams(filter: filter, cursor: 'c1'),
      );

      expect(result, const Right(tPage));
      verify(() => mockRepository.getExercises(filter, 'c1')).called(1);
    });

    test('GetExerciseUseCase calls repository.getExercise', () async {
      when(
        () => mockRepository.getExercise('1'),
      ).thenAnswer((_) async => const Right(tExercise));

      final useCase = GetExerciseUseCase(mockRepository);
      final result = await useCase('1');

      expect(result, const Right(tExercise));
      verify(() => mockRepository.getExercise('1')).called(1);
    });

    test('CreateExerciseUseCase calls repository.create', () async {
      when(
        () => mockRepository.create(tExercise),
      ).thenAnswer((_) async => const Right(tExercise));

      final useCase = CreateExerciseUseCase(mockRepository);
      final result = await useCase(tExercise);

      expect(result, const Right(tExercise));
      verify(() => mockRepository.create(tExercise)).called(1);
    });

    test('UpdateExerciseUseCase calls repository.update', () async {
      when(
        () => mockRepository.update(tExercise),
      ).thenAnswer((_) async => const Right(tExercise));

      final useCase = UpdateExerciseUseCase(mockRepository);
      final result = await useCase(tExercise);

      expect(result, const Right(tExercise));
      verify(() => mockRepository.update(tExercise)).called(1);
    });

    test('DeactivateExerciseUseCase calls repository.deactivate', () async {
      when(
        () => mockRepository.deactivate('1'),
      ).thenAnswer((_) async => const Right(null));

      final useCase = DeactivateExerciseUseCase(mockRepository);
      final result = await useCase('1');

      expect(result, const Right(null));
      verify(() => mockRepository.deactivate('1')).called(1);
    });
  });
}
