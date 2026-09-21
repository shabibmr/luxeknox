import 'package:app/core/error/failures.dart';
import 'package:app/features/exercises/domain/entities/exercise.dart';
import 'package:app/features/workout/domain/entities/workout_plan.dart';
import 'package:app/features/workout/domain/entities/workout_plan_status.dart';
import 'package:app/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/publish_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/replace_workout_plan_exercises_usecase.dart';
import 'package:app/features/workout/domain/usecases/update_workout_plan_usecase.dart';
import 'package:app/features/workout/presentation/cubit/workout_plan_builder_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetWorkoutPlanUseCase {}

class _MockCreate extends Mock implements CreateWorkoutPlanUseCase {}

class _MockUpdate extends Mock implements UpdateWorkoutPlanUseCase {}

class _MockReplace extends Mock
    implements ReplaceWorkoutPlanExercisesUseCase {}

class _MockPublish extends Mock implements PublishWorkoutPlanUseCase {}

void main() {
  late _MockGet getPlan;
  late _MockCreate createPlan;
  late _MockUpdate updatePlan;
  late _MockReplace replaceExercises;
  late _MockPublish publishPlan;

  const exerciseA = Exercise(
    id: '10',
    name: 'Squat',
    primaryMuscleGroup: 'legs',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: '',
    difficultyLevel: 'beginner',
    isActive: true,
  );
  const exerciseB = Exercise(
    id: '11',
    name: 'Bench',
    primaryMuscleGroup: 'chest',
    secondaryMuscles: [],
    equipmentNeeded: [],
    instructions: '',
    difficultyLevel: 'beginner',
    isActive: true,
  );

  WorkoutPlan plan({
    required String id,
    int rowVersion = 1,
    String title = 'Push day',
  }) {
    return WorkoutPlan(
      id: id,
      title: title,
      isTemplate: false,
      status: WorkoutPlanStatus.draft,
      rowVersion: rowVersion,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      const CreateWorkoutPlanParams(title: 'x'),
    );
    registerFallbackValue(
      const UpdateWorkoutPlanParams(id: '1', rowVersion: 1),
    );
    registerFallbackValue(
      const ReplaceWorkoutPlanExercisesParams(
        id: '1',
        rowVersion: 1,
        exercises: [],
      ),
    );
  });

  setUp(() {
    getPlan = _MockGet();
    createPlan = _MockCreate();
    updatePlan = _MockUpdate();
    replaceExercises = _MockReplace();
    publishPlan = _MockPublish();
  });

  WorkoutPlanBuilderCubit buildCubit() => WorkoutPlanBuilderCubit(
    getPlan,
    createPlan,
    updatePlan,
    replaceExercises,
    publishPlan,
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'add/reorder marks dirty and updates orderIndex',
    build: buildCubit,
    act: (cubit) async {
      await cubit.init();
      cubit.addExercise(exerciseA, dayNumber: 1);
      cubit.addExercise(exerciseB, dayNumber: 1);
      cubit.reorderWithinDay(dayNumber: 1, oldIndex: 0, newIndex: 1);
    },
    expect: () => [
      isA<WorkoutPlanBuilderReady>().having((s) => s.dirty, 'dirty', false),
      isA<WorkoutPlanBuilderReady>()
          .having((s) => s.dirty, 'dirty', true)
          .having((s) => s.exercises.length, 'count', 1),
      isA<WorkoutPlanBuilderReady>().having(
        (s) => s.exercises.map((e) => e.exerciseId).toList(),
        'ids',
        ['10', '11'],
      ),
      isA<WorkoutPlanBuilderReady>().having(
        (s) => s.exercises.map((e) => e.exerciseId).toList(),
        'reordered',
        ['11', '10'],
      ),
    ],
    verify: (cubit) {
      final ready = cubit.state as WorkoutPlanBuilderReady;
      expect(ready.exercises.map((e) => e.orderIndex).toList(), [0, 1]);
      expect(ready.dirty, isTrue);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save create then replaceExercises orchestration',
    build: () {
      when(() => createPlan(any())).thenAnswer(
        (_) async => Right(plan(id: '99', rowVersion: 1)),
      );
      when(() => replaceExercises(any())).thenAnswer(
        (_) async => Right(plan(id: '99', rowVersion: 2)),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init();
      cubit.setTitle('New plan');
      cubit.addExercise(exerciseA);
      await cubit.save();
    },
    verify: (cubit) {
      verify(() => createPlan(any())).called(1);
      final captured = verify(() => replaceExercises(captureAny())).captured;
      expect(captured, hasLength(1));
      final params = captured.single as ReplaceWorkoutPlanExercisesParams;
      expect(params.id, '99');
      expect(params.rowVersion, 1);
      expect(params.exercises, hasLength(1));
      final ready = cubit.state as WorkoutPlanBuilderReady;
      expect(ready.planId, '99');
      expect(ready.dirty, isFalse);
      expect(ready.savedPlan, isNotNull);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save edit updates metadata then replaces exercises',
    build: () {
      when(() => getPlan('5')).thenAnswer(
        (_) async => Right(plan(id: '5', title: 'Old')),
      );
      when(() => updatePlan(any())).thenAnswer(
        (_) async => Right(plan(id: '5', rowVersion: 4, title: 'Updated')),
      );
      when(() => replaceExercises(any())).thenAnswer(
        (_) async => Right(plan(id: '5', rowVersion: 5, title: 'Updated')),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init(planId: '5');
      cubit.setTitle('Updated');
      await cubit.save();
    },
    verify: (_) {
      final updateParams =
          verify(() => updatePlan(captureAny())).captured.single
              as UpdateWorkoutPlanParams;
      expect(updateParams.id, '5');
      expect(updateParams.rowVersion, 1);
      expect(updateParams.title, 'Updated');
      final replaceParams =
          verify(() => replaceExercises(captureAny())).captured.single
              as ReplaceWorkoutPlanExercisesParams;
      expect(replaceParams.rowVersion, 4);
    },
  );

  blocTest<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
    'save failure surfaces error without clearing dirty',
    build: () {
      when(() => createPlan(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init();
      cubit.setTitle('Broken');
      await cubit.save();
    },
    verify: (cubit) {
      final ready = cubit.state as WorkoutPlanBuilderReady;
      expect(ready.dirty, isTrue);
      expect(ready.errorMessage, isNotNull);
      expect(ready.saving, isFalse);
    },
  );
}
