import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise_input.dart';
import '../../domain/usecases/create_workout_plan_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/publish_workout_plan_usecase.dart';
import '../../domain/usecases/replace_workout_plan_exercises_usecase.dart';
import '../../domain/usecases/update_workout_plan_usecase.dart';

sealed class WorkoutPlanBuilderState extends Equatable {
  const WorkoutPlanBuilderState();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlanBuilderLoading extends WorkoutPlanBuilderState {
  const WorkoutPlanBuilderLoading();
}

final class WorkoutPlanBuilderReady extends WorkoutPlanBuilderState {
  const WorkoutPlanBuilderReady({
    this.planId,
    this.rowVersion,
    required this.title,
    this.description = '',
    this.targetGoal = '',
    this.difficulty = '',
    this.durationWeeks,
    this.isTemplate = false,
    this.memberId = '',
    this.exercises = const [],
    this.dirty = false,
    this.saving = false,
    this.errorMessage,
    this.savedPlan,
  });

  final String? planId;
  final int? rowVersion;
  final String title;
  final String description;
  final String targetGoal;
  final String difficulty;
  final int? durationWeeks;
  final bool isTemplate;
  final String memberId;
  final List<WorkoutPlanExerciseInput> exercises;
  final bool dirty;
  final bool saving;
  final String? errorMessage;
  final WorkoutPlan? savedPlan;

  bool get isEditMode => planId != null;

  Map<int, List<WorkoutPlanExerciseInput>> get exercisesByDay {
    final map = <int, List<WorkoutPlanExerciseInput>>{};
    for (final e in exercises) {
      map.putIfAbsent(e.dayNumber, () => []).add(e);
    }
    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    return map;
  }

  WorkoutPlanBuilderReady copyWith({
    String? planId,
    int? rowVersion,
    String? title,
    String? description,
    String? targetGoal,
    String? difficulty,
    int? durationWeeks,
    bool? isTemplate,
    String? memberId,
    List<WorkoutPlanExerciseInput>? exercises,
    bool? dirty,
    bool? saving,
    String? errorMessage,
    WorkoutPlan? savedPlan,
    bool clearError = false,
    bool clearSaved = false,
    bool clearDurationWeeks = false,
  }) {
    return WorkoutPlanBuilderReady(
      planId: planId ?? this.planId,
      rowVersion: rowVersion ?? this.rowVersion,
      title: title ?? this.title,
      description: description ?? this.description,
      targetGoal: targetGoal ?? this.targetGoal,
      difficulty: difficulty ?? this.difficulty,
      durationWeeks:
          clearDurationWeeks ? null : (durationWeeks ?? this.durationWeeks),
      isTemplate: isTemplate ?? this.isTemplate,
      memberId: memberId ?? this.memberId,
      exercises: exercises ?? this.exercises,
      dirty: dirty ?? this.dirty,
      saving: saving ?? this.saving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedPlan: clearSaved ? null : (savedPlan ?? this.savedPlan),
    );
  }

  @override
  List<Object?> get props => [
    planId,
    rowVersion,
    title,
    description,
    targetGoal,
    difficulty,
    durationWeeks,
    isTemplate,
    memberId,
    exercises,
    dirty,
    saving,
    errorMessage,
    savedPlan,
  ];
}

final class WorkoutPlanBuilderFailure extends WorkoutPlanBuilderState {
  const WorkoutPlanBuilderFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class WorkoutPlanBuilderCubit extends Cubit<WorkoutPlanBuilderState> {
  WorkoutPlanBuilderCubit(
    this._getPlan,
    this._createPlan,
    this._updatePlan,
    this._replaceExercises,
    this._publishPlan,
  ) : super(const WorkoutPlanBuilderLoading());

  final GetWorkoutPlanUseCase _getPlan;
  final CreateWorkoutPlanUseCase _createPlan;
  final UpdateWorkoutPlanUseCase _updatePlan;
  final ReplaceWorkoutPlanExercisesUseCase _replaceExercises;
  final PublishWorkoutPlanUseCase _publishPlan;

  Future<void> init({String? planId}) async {
    if (planId == null) {
      emit(const WorkoutPlanBuilderReady(title: ''));
      return;
    }
    emit(const WorkoutPlanBuilderLoading());
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(WorkoutPlanBuilderFailure(failureMessage(failure))),
      (plan) => emit(
        WorkoutPlanBuilderReady(
          planId: plan.id,
          rowVersion: plan.rowVersion,
          title: plan.title,
          description: plan.description ?? '',
          targetGoal: plan.targetGoal ?? '',
          difficulty: plan.difficulty ?? '',
          durationWeeks: plan.durationWeeks,
          isTemplate: plan.isTemplate,
          memberId: plan.memberId ?? '',
          exercises: plan.exercises
              .map(
                (e) => WorkoutPlanExerciseInput(
                  exerciseId: e.exerciseId,
                  dayNumber: e.dayNumber,
                  orderIndex: e.orderIndex,
                  targetSets: e.targetSets,
                  targetReps: e.targetReps,
                  targetWeightKg: e.targetWeightKg,
                  restSeconds: e.restSeconds,
                  notes: e.notes,
                  exerciseName: e.exerciseName,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  WorkoutPlanBuilderReady? get _ready {
    final s = state;
    return s is WorkoutPlanBuilderReady ? s : null;
  }

  void setTitle(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(title: value, dirty: true, clearError: true));
  }

  void setDescription(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(description: value, dirty: true, clearError: true));
  }

  void setTargetGoal(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(targetGoal: value, dirty: true, clearError: true));
  }

  void setDifficulty(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(difficulty: value, dirty: true, clearError: true));
  }

  void setDurationWeeks(int? value) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        durationWeeks: value,
        clearDurationWeeks: value == null,
        dirty: true,
        clearError: true,
      ),
    );
  }

  void setIsTemplate(bool value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(isTemplate: value, dirty: true, clearError: true));
  }

  void setMemberId(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(memberId: value, dirty: true, clearError: true));
  }

  void addExercise(Exercise exercise, {int dayNumber = 1}) {
    final ready = _ready;
    if (ready == null) return;
    final dayItems =
        ready.exercises.where((e) => e.dayNumber == dayNumber).toList();
    final nextIndex = dayItems.isEmpty
        ? 0
        : dayItems.map((e) => e.orderIndex).reduce((a, b) => a > b ? a : b) + 1;
    final next = [
      ...ready.exercises,
      WorkoutPlanExerciseInput(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        dayNumber: dayNumber,
        orderIndex: nextIndex,
      ),
    ];
    emit(ready.copyWith(exercises: next, dirty: true, clearError: true));
  }

  void removeExercise({required int dayNumber, required int indexInDay}) {
    final ready = _ready;
    if (ready == null) return;
    final byDay = ready.exercisesByDay;
    final dayList = List<WorkoutPlanExerciseInput>.from(
      byDay[dayNumber] ?? const [],
    );
    if (indexInDay < 0 || indexInDay >= dayList.length) return;
    dayList.removeAt(indexInDay);
    final reindexed = [
      for (var i = 0; i < dayList.length; i++)
        dayList[i].copyWith(orderIndex: i),
    ];
    final others =
        ready.exercises.where((e) => e.dayNumber != dayNumber).toList();
    emit(
      ready.copyWith(
        exercises: [...others, ...reindexed],
        dirty: true,
        clearError: true,
      ),
    );
  }

  void reorderWithinDay({
    required int dayNumber,
    required int oldIndex,
    required int newIndex,
  }) {
    final ready = _ready;
    if (ready == null) return;
    final byDay = ready.exercisesByDay;
    final dayList = List<WorkoutPlanExerciseInput>.from(
      byDay[dayNumber] ?? const [],
    );
    if (oldIndex < 0 || oldIndex >= dayList.length) return;
    // Expects onReorderItem indices (already adjusted for removal).
    if (newIndex < 0 || newIndex >= dayList.length) return;
    final item = dayList.removeAt(oldIndex);
    final insertAt = newIndex.clamp(0, dayList.length);
    dayList.insert(insertAt, item);
    final reindexed = [
      for (var i = 0; i < dayList.length; i++)
        dayList[i].copyWith(orderIndex: i),
    ];
    final others =
        ready.exercises.where((e) => e.dayNumber != dayNumber).toList();
    emit(
      ready.copyWith(
        exercises: [...others, ...reindexed],
        dirty: true,
        clearError: true,
      ),
    );
  }

  void moveToDay({
    required int fromDay,
    required int indexInDay,
    required int toDay,
  }) {
    final ready = _ready;
    if (ready == null || fromDay == toDay) return;
    final byDay = ready.exercisesByDay;
    final fromList = List<WorkoutPlanExerciseInput>.from(
      byDay[fromDay] ?? const [],
    );
    if (indexInDay < 0 || indexInDay >= fromList.length) return;
    final moving = fromList.removeAt(indexInDay);
    final fromReindexed = [
      for (var i = 0; i < fromList.length; i++)
        fromList[i].copyWith(orderIndex: i),
    ];
    final toList = List<WorkoutPlanExerciseInput>.from(
      byDay[toDay] ?? const [],
    );
    final nextIndex = toList.isEmpty
        ? 0
        : toList.map((e) => e.orderIndex).reduce((a, b) => a > b ? a : b) + 1;
    toList.add(moving.copyWith(dayNumber: toDay, orderIndex: nextIndex));
    final others = ready.exercises
        .where((e) => e.dayNumber != fromDay && e.dayNumber != toDay)
        .toList();
    emit(
      ready.copyWith(
        exercises: [...others, ...fromReindexed, ...toList],
        dirty: true,
        clearError: true,
      ),
    );
  }

  Future<bool> save() async {
    final ready = _ready;
    if (ready == null) return false;
    final title = ready.title.trim();
    if (title.isEmpty) {
      emit(ready.copyWith(errorMessage: 'Title is required'));
      return false;
    }

    emit(ready.copyWith(saving: true, clearError: true, clearSaved: true));

    WorkoutPlan? plan;
    if (ready.planId == null) {
      final created = await _createPlan(
        CreateWorkoutPlanParams(
          title: title,
          description: ready.description.trim().isEmpty
              ? null
              : ready.description.trim(),
          memberId: ready.memberId.trim().isEmpty
              ? null
              : ready.memberId.trim(),
          targetGoal: ready.targetGoal.trim().isEmpty
              ? null
              : ready.targetGoal.trim(),
          difficulty: ready.difficulty.trim().isEmpty
              ? null
              : ready.difficulty.trim(),
          durationWeeks: ready.durationWeeks,
          isTemplate: ready.isTemplate,
        ),
      );
      final failureOrPlan = created;
      var failed = false;
      failureOrPlan.fold(
        (failure) {
          failed = true;
          emit(
            ready.copyWith(
              saving: false,
              errorMessage: failureMessage(failure),
            ),
          );
        },
        (p) => plan = p,
      );
      if (failed) return false;
    } else {
      final updated = await _updatePlan(
        UpdateWorkoutPlanParams(
          id: ready.planId!,
          rowVersion: ready.rowVersion ?? 0,
          title: title,
          description: ready.description.trim().isEmpty
              ? null
              : ready.description.trim(),
          memberId: ready.memberId.trim().isEmpty
              ? null
              : ready.memberId.trim(),
          targetGoal: ready.targetGoal.trim().isEmpty
              ? null
              : ready.targetGoal.trim(),
          difficulty: ready.difficulty.trim().isEmpty
              ? null
              : ready.difficulty.trim(),
          durationWeeks: ready.durationWeeks,
          isTemplate: ready.isTemplate,
        ),
      );
      var failed = false;
      updated.fold(
        (failure) {
          failed = true;
          emit(
            ready.copyWith(
              saving: false,
              errorMessage: failureMessage(failure),
            ),
          );
        },
        (p) => plan = p,
      );
      if (failed) return false;
    }

    final savedMeta = plan!;
    final replaced = await _replaceExercises(
      ReplaceWorkoutPlanExercisesParams(
        id: savedMeta.id,
        rowVersion: savedMeta.rowVersion,
        exercises: ready.exercises,
      ),
    );

    return replaced.fold(
      (failure) {
        emit(
          ready.copyWith(
            planId: savedMeta.id,
            rowVersion: savedMeta.rowVersion,
            saving: false,
            errorMessage: failureMessage(failure),
          ),
        );
        return false;
      },
      (full) {
        emit(
          WorkoutPlanBuilderReady(
            planId: full.id,
            rowVersion: full.rowVersion,
            title: full.title,
            description: full.description ?? '',
            targetGoal: full.targetGoal ?? '',
            difficulty: full.difficulty ?? '',
            durationWeeks: full.durationWeeks,
            isTemplate: full.isTemplate,
            memberId: full.memberId ?? '',
            exercises: full.exercises
                .map(
                  (e) => WorkoutPlanExerciseInput(
                    exerciseId: e.exerciseId,
                    dayNumber: e.dayNumber,
                    orderIndex: e.orderIndex,
                    targetSets: e.targetSets,
                    targetReps: e.targetReps,
                    targetWeightKg: e.targetWeightKg,
                    restSeconds: e.restSeconds,
                    notes: e.notes,
                    exerciseName: e.exerciseName,
                  ),
                )
                .toList(),
            dirty: false,
            saving: false,
            savedPlan: full,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> publish() async {
    final ready = _ready;
    if (ready == null || ready.planId == null) return false;
    emit(ready.copyWith(saving: true, clearError: true));
    final result = await _publishPlan(ready.planId!);
    return result.fold(
      (failure) {
        emit(
          ready.copyWith(
            saving: false,
            errorMessage: failureMessage(failure),
          ),
        );
        return false;
      },
      (plan) {
        emit(
          ready.copyWith(
            saving: false,
            dirty: false,
            rowVersion: plan.rowVersion,
            savedPlan: plan,
          ),
        );
        return true;
      },
    );
  }
}
