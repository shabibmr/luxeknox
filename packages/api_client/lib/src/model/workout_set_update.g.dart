// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSetUpdate extends WorkoutSetUpdate {
  @override
  final int? repsCompleted;
  @override
  final num? weightLiftedKg;
  @override
  final num? rpeScore;
  @override
  final bool? isCompleted;

  factory _$WorkoutSetUpdate(
          [void Function(WorkoutSetUpdateBuilder)? updates]) =>
      (WorkoutSetUpdateBuilder()..update(updates))._build();

  _$WorkoutSetUpdate._(
      {this.repsCompleted,
      this.weightLiftedKg,
      this.rpeScore,
      this.isCompleted})
      : super._();
  @override
  WorkoutSetUpdate rebuild(void Function(WorkoutSetUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSetUpdateBuilder toBuilder() =>
      WorkoutSetUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSetUpdate &&
        repsCompleted == other.repsCompleted &&
        weightLiftedKg == other.weightLiftedKg &&
        rpeScore == other.rpeScore &&
        isCompleted == other.isCompleted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, repsCompleted.hashCode);
    _$hash = $jc(_$hash, weightLiftedKg.hashCode);
    _$hash = $jc(_$hash, rpeScore.hashCode);
    _$hash = $jc(_$hash, isCompleted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutSetUpdate')
          ..add('repsCompleted', repsCompleted)
          ..add('weightLiftedKg', weightLiftedKg)
          ..add('rpeScore', rpeScore)
          ..add('isCompleted', isCompleted))
        .toString();
  }
}

class WorkoutSetUpdateBuilder
    implements Builder<WorkoutSetUpdate, WorkoutSetUpdateBuilder> {
  _$WorkoutSetUpdate? _$v;

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

  WorkoutSetUpdateBuilder() {
    WorkoutSetUpdate._defaults(this);
  }

  WorkoutSetUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _repsCompleted = $v.repsCompleted;
      _weightLiftedKg = $v.weightLiftedKg;
      _rpeScore = $v.rpeScore;
      _isCompleted = $v.isCompleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSetUpdate other) {
    _$v = other as _$WorkoutSetUpdate;
  }

  @override
  void update(void Function(WorkoutSetUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSetUpdate build() => _build();

  _$WorkoutSetUpdate _build() {
    final _$result = _$v ??
        _$WorkoutSetUpdate._(
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
