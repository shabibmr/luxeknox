import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:luxeknox/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/exercise_picker_cubit.dart';
import 'package:luxeknox/features/workout/presentation/widgets/exercise_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}

void main() {
  late _MockGetExercisesUseCase mockGetExercises;

  const testExercise = Exercise(
    id: 'e1',
    name: 'Barbell Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: ['Triceps', 'Shoulders'],
    equipmentNeeded: ['Barbell', 'Bench'],
    instructions: 'Press the bar up.',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  setUpAll(() {
    registerFallbackValue(const GetExercisesParams());
  });

  setUp(() {
    mockGetExercises = _MockGetExercisesUseCase();

    if (getIt.isRegistered<ExercisePickerCubit>()) {
      getIt.unregister<ExercisePickerCubit>();
    }
    getIt.registerFactory<ExercisePickerCubit>(
      () => ExercisePickerCubit(mockGetExercises),
    );

    when(() => mockGetExercises(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [testExercise], nextCursor: null, hasMore: false),
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('ExercisePickerSheet renders exercises and selects on tap', (
    tester,
  ) async {
    Exercise? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                selected = await showExercisePickerSheet(context);
              },
              child: const Text('Pick Exercise'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pick Exercise'));
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Chest'), findsOneWidget);

    await tester.tap(find.text('Barbell Bench Press'));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.id, 'e1');
    expect(selected!.name, 'Barbell Bench Press');
  });

  testWidgets('ExercisePickerField displays selected exercise', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExercisePickerField(selectedExercise: testExercise),
        ),
      ),
    );

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);
  });
}
