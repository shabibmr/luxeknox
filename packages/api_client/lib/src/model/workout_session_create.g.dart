// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSessionCreate extends WorkoutSessionCreate {
  @override
  final int? memberId;
  @override
  final int? workoutPlanId;
  @override
  final int? workoutPlanVersionId;

  factory _$WorkoutSessionCreate(
          [void Function(WorkoutSessionCreateBuilder)? updates]) =>
      (WorkoutSessionCreateBuilder()..update(updates))._build();

  _$WorkoutSessionCreate._(
      {this.memberId, this.workoutPlanId, this.workoutPlanVersionId})
      : super._();
  @override
  WorkoutSessionCreate rebuild(
          void Function(WorkoutSessionCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSessionCreateBuilder toBuilder() =>
      WorkoutSessionCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSessionCreate &&
        memberId == other.memberId &&
        workoutPlanId == other.workoutPlanId &&
        workoutPlanVersionId == other.workoutPlanVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, workoutPlanId.hashCode);
    _$hash = $jc(_$hash, workoutPlanVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutSessionCreate')
          ..add('memberId', memberId)
          ..add('workoutPlanId', workoutPlanId)
          ..add('workoutPlanVersionId', workoutPlanVersionId))
        .toString();
  }
}

class WorkoutSessionCreateBuilder
    implements Builder<WorkoutSessionCreate, WorkoutSessionCreateBuilder> {
  _$WorkoutSessionCreate? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _workoutPlanId;
  int? get workoutPlanId => _$this._workoutPlanId;
  set workoutPlanId(int? workoutPlanId) =>
      _$this._workoutPlanId = workoutPlanId;

  int? _workoutPlanVersionId;
  int? get workoutPlanVersionId => _$this._workoutPlanVersionId;
  set workoutPlanVersionId(int? workoutPlanVersionId) =>
      _$this._workoutPlanVersionId = workoutPlanVersionId;

  WorkoutSessionCreateBuilder() {
    WorkoutSessionCreate._defaults(this);
  }

  WorkoutSessionCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _workoutPlanId = $v.workoutPlanId;
      _workoutPlanVersionId = $v.workoutPlanVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSessionCreate other) {
    _$v = other as _$WorkoutSessionCreate;
  }

  @override
  void update(void Function(WorkoutSessionCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSessionCreate build() => _build();

  _$WorkoutSessionCreate _build() {
    final _$result = _$v ??
        _$WorkoutSessionCreate._(
          memberId: memberId,
          workoutPlanId: workoutPlanId,
          workoutPlanVersionId: workoutPlanVersionId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
