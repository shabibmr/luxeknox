// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_exercise.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSessionExercise extends WorkoutSessionExercise {
  @override
  final int id;
  @override
  final int workoutSessionId;
  @override
  final int exerciseId;
  @override
  final int setNumber;
  @override
  final int? repsCompleted;
  @override
  final num? weightLiftedKg;
  @override
  final num? rpeScore;
  @override
  final bool? isCompleted;

  factory _$WorkoutSessionExercise(
          [void Function(WorkoutSessionExerciseBuilder)? updates]) =>
      (WorkoutSessionExerciseBuilder()..update(updates))._build();

  _$WorkoutSessionExercise._(
      {required this.id,
      required this.workoutSessionId,
      required this.exerciseId,
      required this.setNumber,
      this.repsCompleted,
      this.weightLiftedKg,
      this.rpeScore,
      this.isCompleted})
      : super._();
  @override
  WorkoutSessionExercise rebuild(
          void Function(WorkoutSessionExerciseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSessionExerciseBuilder toBuilder() =>
      WorkoutSessionExerciseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSessionExercise &&
        id == other.id &&
        workoutSessionId == other.workoutSessionId &&
        exerciseId == other.exerciseId &&
        setNumber == other.setNumber &&
        repsCompleted == other.repsCompleted &&
        weightLiftedKg == other.weightLiftedKg &&
        rpeScore == other.rpeScore &&
        isCompleted == other.isCompleted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, workoutSessionId.hashCode);
    _$hash = $jc(_$hash, exerciseId.hashCode);
    _$hash = $jc(_$hash, setNumber.hashCode);
    _$hash = $jc(_$hash, repsCompleted.hashCode);
    _$hash = $jc(_$hash, weightLiftedKg.hashCode);
    _$hash = $jc(_$hash, rpeScore.hashCode);
    _$hash = $jc(_$hash, isCompleted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutSessionExercise')
          ..add('id', id)
          ..add('workoutSessionId', workoutSessionId)
          ..add('exerciseId', exerciseId)
          ..add('setNumber', setNumber)
          ..add('repsCompleted', repsCompleted)
          ..add('weightLiftedKg', weightLiftedKg)
          ..add('rpeScore', rpeScore)
          ..add('isCompleted', isCompleted))
        .toString();
  }
}

class WorkoutSessionExerciseBuilder
    implements Builder<WorkoutSessionExercise, WorkoutSessionExerciseBuilder> {
  _$WorkoutSessionExercise? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _workoutSessionId;
  int? get workoutSessionId => _$this._workoutSessionId;
  set workoutSessionId(int? workoutSessionId) =>
      _$this._workoutSessionId = workoutSessionId;

  int? _exerciseId;
  int? get exerciseId => _$this._exerciseId;
  set exerciseId(int? exerciseId) => _$this._exerciseId = exerciseId;

  int? _setNumber;
  int? get setNumber => _$this._setNumber;
  set setNumber(int? setNumber) => _$this._setNumber = setNumber;

  int? _repsCompleted;
  int? get repsCompleted => _$this._repsCompleted;
  set repsCompleted(int? repsCompleted) =>
      _$this._repsCompleted = repsCompleted;

  num? _weightLiftedKg;
  num? get weightLiftedKg => _$this._weightLiftedKg;
  set weightLiftedKg(num? weightLiftedKg) =>
      _$this._weightLiftedKg = weightLiftedKg;

  num? _rpeScore;
  num? get rpeScore => _$this._rpeScore;
  set rpeScore(num? rpeScore) => _$this._rpeScore = rpeScore;

  bool? _isCompleted;
  bool? get isCompleted => _$this._isCompleted;
  set isCompleted(bool? isCompleted) => _$this._isCompleted = isCompleted;

  WorkoutSessionExerciseBuilder() {
    WorkoutSessionExercise._defaults(this);
  }

  WorkoutSessionExerciseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _workoutSessionId = $v.workoutSessionId;
      _exerciseId = $v.exerciseId;
      _setNumber = $v.setNumber;
      _repsCompleted = $v.repsCompleted;
      _weightLiftedKg = $v.weightLiftedKg;
      _rpeScore = $v.rpeScore;
      _isCompleted = $v.isCompleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSessionExercise other) {
    _$v = other as _$WorkoutSessionExercise;
  }

  @override
  void update(void Function(WorkoutSessionExerciseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSessionExercise build() => _build();

  _$WorkoutSessionExercise _build() {
    final _$result = _$v ??
        _$WorkoutSessionExercise._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'WorkoutSessionExercise', 'id'),
          workoutSessionId: BuiltValueNullFieldError.checkNotNull(
              workoutSessionId, r'WorkoutSessionExercise', 'workoutSessionId'),
          exerciseId: BuiltValueNullFieldError.checkNotNull(
              exerciseId, r'WorkoutSessionExercise', 'exerciseId'),
          setNumber: BuiltValueNullFieldError.checkNotNull(
              setNumber, r'WorkoutSessionExercise', 'setNumber'),
          repsCompleted: repsCompleted,
          weightLiftedKg: weightLiftedKg,
          rpeScore: rpeScore,
          isCompleted: isCompleted,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
