import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise_input.dart';
import '../../domain/usecases/create_workout_plan_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/publish_workout_plan_usecase.dart';
import '../../domain/usecases/replace_workout_plan_exercises_usecase.dart';
import '../../domain/usecases/update_workout_plan_usecase.dart';

part 'workout_plan_builder_cubit.freezed.dart';

@freezed
abstract class WorkoutPlanBuilderState with _$WorkoutPlanBuilderState {
  const WorkoutPlanBuilderState._();

  const factory WorkoutPlanBuilderState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? planId,
    int? rowVersion,
    @Default('') String title,
    @Default('') String description,
    @Default('') String targetGoal,
    @Default('') String difficulty,
    int? durationWeeks,
    @Default(false) bool isTemplate,
    @Default('') String memberId,
    @Default(<WorkoutPlanExerciseInput>[])
    List<WorkoutPlanExerciseInput> exercises,
    @Default(false) bool dirty,
    @Default(false) bool saving,
    /// Local validation such as a missing title. API errors use [failure].
    String? errorMessage,
    Failure? failure,
    WorkoutPlan? savedPlan,
  }) = _WorkoutPlanBuilderState;

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
}

@injectable
class WorkoutPlanBuilderCubit extends Cubit<WorkoutPlanBuilderState> {
  WorkoutPlanBuilderCubit(
    this._getPlan,
    this._createPlan,
    this._updatePlan,
    this._replaceExercises,
    this._publishPlan,
  ) : super(const WorkoutPlanBuilderState());

  final GetWorkoutPlanUseCase _getPlan;
  final CreateWorkoutPlanUseCase _createPlan;
  final UpdateWorkoutPlanUseCase _updatePlan;
  final ReplaceWorkoutPlanExercisesUseCase _replaceExercises;
  final PublishWorkoutPlanUseCase _publishPlan;

  bool get _canEdit =>
      state.status == LoadStatus.success ||
      (state.status == LoadStatus.failure &&
          (state.planId != null ||
              state.title.isNotEmpty ||
              state.exercises.isNotEmpty));

  Future<void> init({String? planId}) async {
    if (planId == null) {
      emit(const WorkoutPlanBuilderState(status: LoadStatus.success));
      return;
    }
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        errorMessage: null,
      ),
    );
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (plan) => emit(
        WorkoutPlanBuilderState(
          status: LoadStatus.success,
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

  void _touch(WorkoutPlanBuilderState next) {
    emit(
      next.copyWith(
        dirty: true,
        errorMessage: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
  }

  void setTitle(String value) {
    if (!_canEdit) return;
    _touch(state.copyWith(title: value));
  }

  void setDescription(String value) {
    if (!_canEdit) return;
    _touch(state.copyWith(description: value));
  }

  void setTargetGoal(String value) {
    if (!_canEdit) return;
    _touch(state.copyWith(targetGoal: value));
  }

  void setDifficulty(String value) {
    if (!_canEdit) return;
    _touch(state.copyWith(difficulty: value));
  }

  void setDurationWeeks(int? value) {
    if (!_canEdit) return;
    _touch(state.copyWith(durationWeeks: value));
  }

  void setIsTemplate(bool value) {
    if (!_canEdit) return;
    _touch(state.copyWith(isTemplate: value));
  }

  void setMemberId(String value) {
    if (!_canEdit) return;
    _touch(state.copyWith(memberId: value));
  }

  void addExercise(Exercise exercise, {int dayNumber = 1}) {
    if (!_canEdit) return;
    final dayItems = state.exercises.where((e) => e.dayNumber == dayNumber);
    final nextIndex = dayItems.isEmpty
        ? 0
        : dayItems.map((e) => e.orderIndex).reduce((a, b) => a > b ? a : b) +
              1;
    final next = [
      ...state.exercises,
      WorkoutPlanExerciseInput(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        dayNumber: dayNumber,
        orderIndex: nextIndex,
      ),
    ];
    _touch(state.copyWith(exercises: next));
  }

  void removeExercise({required int dayNumber, required int indexInDay}) {
    if (!_canEdit) return;
    final byDay = state.exercisesByDay;
    final dayList = List<WorkoutPlanExerciseInput>.from(
      byDay[dayNumber] ?? const [],
    );
    if (indexInDay < 0 || indexInDay >= dayList.length) return;
    dayList.removeAt(indexInDay);
    final reindexed = [
      for (var i = 0; i < dayList.length; i++)
        dayList[i].copyWith(orderIndex: i),
    ];
    final others = state.exercises.where((e) => e.dayNumber != dayNumber);
    _touch(state.copyWith(exercises: [...others, ...reindexed]));
  }

  void reorderWithinDay({
    required int dayNumber,
    required int oldIndex,
    required int newIndex,
  }) {
    if (!_canEdit) return;
    final byDay = state.exercisesByDay;
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
    final others = state.exercises.where((e) => e.dayNumber != dayNumber);
    _touch(state.copyWith(exercises: [...others, ...reindexed]));
  }

  void moveToDay({
    required int fromDay,
    required int indexInDay,
    required int toDay,
  }) {
    if (!_canEdit || fromDay == toDay) return;
    final byDay = state.exercisesByDay;
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
    final others = state.exercises
        .where((e) => e.dayNumber != fromDay && e.dayNumber != toDay)
        .toList();
    _touch(
      state.copyWith(exercises: [...others, ...fromReindexed, ...toList]),
    );
  }

  Future<bool> save() async {
    if (!_canEdit) return false;
    final draft = state;
    final title = draft.title.trim();
    if (title.isEmpty) {
      emit(
        draft.copyWith(errorMessage: 'Title is required', failure: null),
      );
      return false;
    }

    emit(
      draft.copyWith(
        saving: true,
        errorMessage: null,
        failure: null,
        savedPlan: null,
        status: LoadStatus.success,
      ),
    );

    WorkoutPlan? plan;
    if (draft.planId == null) {
      final created = await _createPlan(
        CreateWorkoutPlanParams(
          title: title,
          description: draft.description.trim().isEmpty
              ? null
              : draft.description.trim(),
          memberId: draft.memberId.trim().isEmpty
              ? null
              : draft.memberId.trim(),
          targetGoal: draft.targetGoal.trim().isEmpty
              ? null
              : draft.targetGoal.trim(),
          difficulty: draft.difficulty.trim().isEmpty
              ? null
              : draft.difficulty.trim(),
          durationWeeks: draft.durationWeeks,
          isTemplate: draft.isTemplate,
        ),
      );
      final failed = created.fold((failure) {
        emit(
          draft.copyWith(
            saving: false,
            status: LoadStatus.failure,
            failure: failure,
            errorMessage: null,
            savedPlan: null,
          ),
        );
        return true;
      }, (p) {
        plan = p;
        return false;
      });
      if (failed) return false;
    } else {
      final updated = await _updatePlan(
        UpdateWorkoutPlanParams(
          id: draft.planId!,
          rowVersion: draft.rowVersion ?? 0,
          title: title,
          description: draft.description.trim().isEmpty
              ? null
              : draft.description.trim(),
          memberId: draft.memberId.trim().isEmpty
              ? null
              : draft.memberId.trim(),
          targetGoal: draft.targetGoal.trim().isEmpty
              ? null
              : draft.targetGoal.trim(),
          difficulty: draft.difficulty.trim().isEmpty
              ? null
              : draft.difficulty.trim(),
          durationWeeks: draft.durationWeeks,
          isTemplate: draft.isTemplate,
        ),
      );
      final failed = updated.fold((failure) {
        emit(
          draft.copyWith(
            saving: false,
            status: LoadStatus.failure,
            failure: failure,
            errorMessage: null,
            savedPlan: null,
          ),
        );
        return true;
      }, (p) {
        plan = p;
        return false;
      });
      if (failed) return false;
    }

    final savedMeta = plan!;
    final replaced = await _replaceExercises(
      ReplaceWorkoutPlanExercisesParams(
        id: savedMeta.id,
        rowVersion: savedMeta.rowVersion,
        exercises: draft.exercises,
      ),
    );

    return replaced.fold(
      (failure) {
        emit(
          draft.copyWith(
            planId: savedMeta.id,
            rowVersion: savedMeta.rowVersion,
            saving: false,
            status: LoadStatus.failure,
            failure: failure,
            errorMessage: null,
            savedPlan: null,
          ),
        );
        return false;
      },
      (full) {
        emit(
          WorkoutPlanBuilderState(
            status: LoadStatus.success,
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
            savedPlan: full,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> publish() async {
    final draft = state;
    if (!_canEdit || draft.planId == null) return false;
    emit(
      draft.copyWith(
        saving: true,
        errorMessage: null,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _publishPlan(draft.planId!);
    return result.fold(
      (failure) {
        emit(
          draft.copyWith(
            saving: false,
            status: LoadStatus.failure,
            failure: failure,
            errorMessage: null,
          ),
        );
        return false;
      },
      (plan) {
        emit(
          draft.copyWith(
            saving: false,
            dirty: false,
            rowVersion: plan.rowVersion,
            savedPlan: plan,
            status: LoadStatus.success,
            failure: null,
            errorMessage: null,
          ),
        );
        return true;
      },
    );
  }
}
