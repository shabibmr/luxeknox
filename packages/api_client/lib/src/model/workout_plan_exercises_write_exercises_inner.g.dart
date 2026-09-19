// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_exercises_write_exercises_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanExercisesWriteExercisesInner
    extends WorkoutPlanExercisesWriteExercisesInner {
  @override
  final int exerciseId;
  @override
  final int dayNumber;
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

  factory _$WorkoutPlanExercisesWriteExercisesInner(
          [void Function(WorkoutPlanExercisesWriteExercisesInnerBuilder)?
              updates]) =>
      (WorkoutPlanExercisesWriteExercisesInnerBuilder()..update(updates))
          ._build();

  _$WorkoutPlanExercisesWriteExercisesInner._(
      {required this.exerciseId,
      required this.dayNumber,
      required this.orderIndex,
      this.targetSets,
      this.targetReps,
      this.targetWeightKg,
      this.restSeconds,
      this.notes})
      : super._();
  @override
  WorkoutPlanExercisesWriteExercisesInner rebuild(
          void Function(WorkoutPlanExercisesWriteExercisesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanExercisesWriteExercisesInnerBuilder toBuilder() =>
      WorkoutPlanExercisesWriteExercisesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanExercisesWriteExercisesInner &&
        exerciseId == other.exerciseId &&
        dayNumber == other.dayNumber &&
        orderIndex == other.orderIndex &&
        targetSets == other.targetSets &&
        targetReps == other.targetReps &&
        targetWeightKg == other.targetWeightKg &&
        restSeconds == other.restSeconds &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, exerciseId.hashCode);
    _$hash = $jc(_$hash, dayNumber.hashCode);
    _$hash = $jc(_$hash, orderIndex.hashCode);
    _$hash = $jc(_$hash, targetSets.hashCode);
    _$hash = $jc(_$hash, targetReps.hashCode);
    _$hash = $jc(_$hash, targetWeightKg.hashCode);
    _$hash = $jc(_$hash, restSeconds.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'WorkoutPlanExercisesWriteExercisesInner')
          ..add('exerciseId', exerciseId)
          ..add('dayNumber', dayNumber)
          ..add('orderIndex', orderIndex)
          ..add('targetSets', targetSets)
          ..add('targetReps', targetReps)
          ..add('targetWeightKg', targetWeightKg)
          ..add('restSeconds', restSeconds)
          ..add('notes', notes))
        .toString();
  }
}

class WorkoutPlanExercisesWriteExercisesInnerBuilder
    implements
        Builder<WorkoutPlanExercisesWriteExercisesInner,
            WorkoutPlanExercisesWriteExercisesInnerBuilder> {
  _$WorkoutPlanExercisesWriteExercisesInner? _$v;

  int? _exerciseId;
  int? get exerciseId => _$this._exerciseId;
  set exerciseId(int? exerciseId) => _$this._exerciseId = exerciseId;

  int? _dayNumber;
  int? get dayNumber => _$this._dayNumber;
  set dayNumber(int? dayNumber) => _$this._dayNumber = dayNumber;

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

  WorkoutPlanExercisesWriteExercisesInnerBuilder() {
    WorkoutPlanExercisesWriteExercisesInner._defaults(this);
  }

  WorkoutPlanExercisesWriteExercisesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _exerciseId = $v.exerciseId;
      _dayNumber = $v.dayNumber;
      _orderIndex = $v.orderIndex;
      _targetSets = $v.targetSets;
      _targetReps = $v.targetReps;
      _targetWeightKg = $v.targetWeightKg;
      _restSeconds = $v.restSeconds;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanExercisesWriteExercisesInner other) {
    _$v = other as _$WorkoutPlanExercisesWriteExercisesInner;
  }

  @override
  void update(
      void Function(WorkoutPlanExercisesWriteExercisesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanExercisesWriteExercisesInner build() => _build();

  _$WorkoutPlanExercisesWriteExercisesInner _build() {
    final _$result = _$v ??
        _$WorkoutPlanExercisesWriteExercisesInner._(
          exerciseId: BuiltValueNullFieldError.checkNotNull(exerciseId,
              r'WorkoutPlanExercisesWriteExercisesInner', 'exerciseId'),
          dayNumber: BuiltValueNullFieldError.checkNotNull(dayNumber,
              r'WorkoutPlanExercisesWriteExercisesInner', 'dayNumber'),
          orderIndex: BuiltValueNullFieldError.checkNotNull(orderIndex,
              r'WorkoutPlanExercisesWriteExercisesInner', 'orderIndex'),
          targetSets: targetSets,
          targetReps: targetReps,
          targetWeightKg: targetWeightKg,
          restSeconds: restSeconds,
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
