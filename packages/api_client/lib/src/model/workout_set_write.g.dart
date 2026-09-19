// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSetWrite extends WorkoutSetWrite {
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

  factory _$WorkoutSetWrite([void Function(WorkoutSetWriteBuilder)? updates]) =>
      (WorkoutSetWriteBuilder()..update(updates))._build();

  _$WorkoutSetWrite._(
      {required this.exerciseId,
      required this.setNumber,
      this.repsCompleted,
      this.weightLiftedKg,
      this.rpeScore,
      this.isCompleted})
      : super._();
  @override
  WorkoutSetWrite rebuild(void Function(WorkoutSetWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSetWriteBuilder toBuilder() => WorkoutSetWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSetWrite &&
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
    return (newBuiltValueToStringHelper(r'WorkoutSetWrite')
          ..add('exerciseId', exerciseId)
          ..add('setNumber', setNumber)
          ..add('repsCompleted', repsCompleted)
          ..add('weightLiftedKg', weightLiftedKg)
          ..add('rpeScore', rpeScore)
          ..add('isCompleted', isCompleted))
        .toString();
  }
}

class WorkoutSetWriteBuilder
    implements Builder<WorkoutSetWrite, WorkoutSetWriteBuilder> {
  _$WorkoutSetWrite? _$v;

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

  WorkoutSetWriteBuilder() {
    WorkoutSetWrite._defaults(this);
  }

  WorkoutSetWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(WorkoutSetWrite other) {
    _$v = other as _$WorkoutSetWrite;
  }

  @override
  void update(void Function(WorkoutSetWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSetWrite build() => _build();

  _$WorkoutSetWrite _build() {
    final _$result = _$v ??
        _$WorkoutSetWrite._(
          exerciseId: BuiltValueNullFieldError.checkNotNull(
              exerciseId, r'WorkoutSetWrite', 'exerciseId'),
          setNumber: BuiltValueNullFieldError.checkNotNull(
              setNumber, r'WorkoutSetWrite', 'setNumber'),
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
