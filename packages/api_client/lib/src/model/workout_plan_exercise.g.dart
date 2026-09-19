// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_exercise.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanExercise extends WorkoutPlanExercise {
  @override
  final int id;
  @override
  final int workoutPlanVersionId;
  @override
  final int dayNumber;
  @override
  final int exerciseId;
  @override
  final int orderIndex;
  @override
  final int? targetSets;
  @override
  final String? targetReps;
  @override
  final num? targetWeightKg;
  @override
  final int? restSeconds;
  @override
  final String? notes;
  @override
  final Exercise? exercise;

  factory _$WorkoutPlanExercise(
          [void Function(WorkoutPlanExerciseBuilder)? updates]) =>
      (WorkoutPlanExerciseBuilder()..update(updates))._build();

  _$WorkoutPlanExercise._(
      {required this.id,
      required this.workoutPlanVersionId,
      required this.dayNumber,
      required this.exerciseId,
      required this.orderIndex,
      this.targetSets,
      this.targetReps,
      this.targetWeightKg,
      this.restSeconds,
      this.notes,
      this.exercise})
      : super._();
  @override
  WorkoutPlanExercise rebuild(
          void Function(WorkoutPlanExerciseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanExerciseBuilder toBuilder() =>
      WorkoutPlanExerciseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanExercise &&
        id == other.id &&
        workoutPlanVersionId == other.workoutPlanVersionId &&
        dayNumber == other.dayNumber &&
        exerciseId == other.exerciseId &&
        orderIndex == other.orderIndex &&
        targetSets == other.targetSets &&
        targetReps == other.targetReps &&
        targetWeightKg == other.targetWeightKg &&
        restSeconds == other.restSeconds &&
        notes == other.notes &&
        exercise == other.exercise;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, workoutPlanVersionId.hashCode);
    _$hash = $jc(_$hash, dayNumber.hashCode);
    _$hash = $jc(_$hash, exerciseId.hashCode);
    _$hash = $jc(_$hash, orderIndex.hashCode);
    _$hash = $jc(_$hash, targetSets.hashCode);
    _$hash = $jc(_$hash, targetReps.hashCode);
    _$hash = $jc(_$hash, targetWeightKg.hashCode);
    _$hash = $jc(_$hash, restSeconds.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, exercise.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlanExercise')
          ..add('id', id)
          ..add('workoutPlanVersionId', workoutPlanVersionId)
          ..add('dayNumber', dayNumber)
          ..add('exerciseId', exerciseId)
          ..add('orderIndex', orderIndex)
          ..add('targetSets', targetSets)
          ..add('targetReps', targetReps)
          ..add('targetWeightKg', targetWeightKg)
          ..add('restSeconds', restSeconds)
          ..add('notes', notes)
          ..add('exercise', exercise))
        .toString();
  }
}

class WorkoutPlanExerciseBuilder
    implements Builder<WorkoutPlanExercise, WorkoutPlanExerciseBuilder> {
  _$WorkoutPlanExercise? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _workoutPlanVersionId;
  int? get workoutPlanVersionId => _$this._workoutPlanVersionId;
  set workoutPlanVersionId(int? workoutPlanVersionId) =>
      _$this._workoutPlanVersionId = workoutPlanVersionId;

  int? _dayNumber;
  int? get dayNumber => _$this._dayNumber;
  set dayNumber(int? dayNumber) => _$this._dayNumber = dayNumber;

  int? _exerciseId;
  int? get exerciseId => _$this._exerciseId;
  set exerciseId(int? exerciseId) => _$this._exerciseId = exerciseId;

  int? _orderIndex;
  int? get orderIndex => _$this._orderIndex;
  set orderIndex(int? orderIndex) => _$this._orderIndex = orderIndex;

  int? _targetSets;
  int? get targetSets => _$this._targetSets;
  set targetSets(int? targetSets) => _$this._targetSets = targetSets;

  String? _targetReps;
  String? get targetReps => _$this._targetReps;
  set targetReps(String? targetReps) => _$this._targetReps = targetReps;

  num? _targetWeightKg;
  num? get targetWeightKg => _$this._targetWeightKg;
  set targetWeightKg(num? targetWeightKg) =>
      _$this._targetWeightKg = targetWeightKg;

  int? _restSeconds;
  int? get restSeconds => _$this._restSeconds;
  set restSeconds(int? restSeconds) => _$this._restSeconds = restSeconds;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ExerciseBuilder? _exercise;
  ExerciseBuilder get exercise => _$this._exercise ??= ExerciseBuilder();
  set exercise(ExerciseBuilder? exercise) => _$this._exercise = exercise;

  WorkoutPlanExerciseBuilder() {
    WorkoutPlanExercise._defaults(this);
  }

  WorkoutPlanExerciseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _workoutPlanVersionId = $v.workoutPlanVersionId;
      _dayNumber = $v.dayNumber;
      _exerciseId = $v.exerciseId;
      _orderIndex = $v.orderIndex;
      _targetSets = $v.targetSets;
      _targetReps = $v.targetReps;
      _targetWeightKg = $v.targetWeightKg;
      _restSeconds = $v.restSeconds;
      _notes = $v.notes;
      _exercise = $v.exercise?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanExercise other) {
    _$v = other as _$WorkoutPlanExercise;
  }

  @override
  void update(void Function(WorkoutPlanExerciseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanExercise build() => _build();

  _$WorkoutPlanExercise _build() {
    _$WorkoutPlanExercise _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanExercise._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkoutPlanExercise', 'id'),
            workoutPlanVersionId: BuiltValueNullFieldError.checkNotNull(
                workoutPlanVersionId,
                r'WorkoutPlanExercise',
                'workoutPlanVersionId'),
            dayNumber: BuiltValueNullFieldError.checkNotNull(
                dayNumber, r'WorkoutPlanExercise', 'dayNumber'),
            exerciseId: BuiltValueNullFieldError.checkNotNull(
                exerciseId, r'WorkoutPlanExercise', 'exerciseId'),
            orderIndex: BuiltValueNullFieldError.checkNotNull(
                orderIndex, r'WorkoutPlanExercise', 'orderIndex'),
            targetSets: targetSets,
            targetReps: targetReps,
            targetWeightKg: targetWeightKg,
            restSeconds: restSeconds,
            notes: notes,
            exercise: _exercise?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'exercise';
        _exercise?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutPlanExercise', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
