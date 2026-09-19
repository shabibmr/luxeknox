// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanVersion extends WorkoutPlanVersion {
  @override
  final int id;
  @override
  final int workoutPlanId;
  @override
  final int versionNumber;
  @override
  final String? changelog;
  @override
  final DateTime? createdAt;
  @override
  final BuiltList<WorkoutPlanExercise>? exercises;

  factory _$WorkoutPlanVersion(
          [void Function(WorkoutPlanVersionBuilder)? updates]) =>
      (WorkoutPlanVersionBuilder()..update(updates))._build();

  _$WorkoutPlanVersion._(
      {required this.id,
      required this.workoutPlanId,
      required this.versionNumber,
      this.changelog,
      this.createdAt,
      this.exercises})
      : super._();
  @override
  WorkoutPlanVersion rebuild(
          void Function(WorkoutPlanVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanVersionBuilder toBuilder() =>
      WorkoutPlanVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanVersion &&
        id == other.id &&
        workoutPlanId == other.workoutPlanId &&
        versionNumber == other.versionNumber &&
        changelog == other.changelog &&
        createdAt == other.createdAt &&
        exercises == other.exercises;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, workoutPlanId.hashCode);
    _$hash = $jc(_$hash, versionNumber.hashCode);
    _$hash = $jc(_$hash, changelog.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, exercises.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlanVersion')
          ..add('id', id)
          ..add('workoutPlanId', workoutPlanId)
          ..add('versionNumber', versionNumber)
          ..add('changelog', changelog)
          ..add('createdAt', createdAt)
          ..add('exercises', exercises))
        .toString();
  }
}

class WorkoutPlanVersionBuilder
    implements Builder<WorkoutPlanVersion, WorkoutPlanVersionBuilder> {
  _$WorkoutPlanVersion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _workoutPlanId;
  int? get workoutPlanId => _$this._workoutPlanId;
  set workoutPlanId(int? workoutPlanId) =>
      _$this._workoutPlanId = workoutPlanId;

  int? _versionNumber;
  int? get versionNumber => _$this._versionNumber;
  set versionNumber(int? versionNumber) =>
      _$this._versionNumber = versionNumber;

  String? _changelog;
  String? get changelog => _$this._changelog;
  set changelog(String? changelog) => _$this._changelog = changelog;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<WorkoutPlanExercise>? _exercises;
  ListBuilder<WorkoutPlanExercise> get exercises =>
      _$this._exercises ??= ListBuilder<WorkoutPlanExercise>();
  set exercises(ListBuilder<WorkoutPlanExercise>? exercises) =>
      _$this._exercises = exercises;

  WorkoutPlanVersionBuilder() {
    WorkoutPlanVersion._defaults(this);
  }

  WorkoutPlanVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _workoutPlanId = $v.workoutPlanId;
      _versionNumber = $v.versionNumber;
      _changelog = $v.changelog;
      _createdAt = $v.createdAt;
      _exercises = $v.exercises?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanVersion other) {
    _$v = other as _$WorkoutPlanVersion;
  }

  @override
  void update(void Function(WorkoutPlanVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanVersion build() => _build();

  _$WorkoutPlanVersion _build() {
    _$WorkoutPlanVersion _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanVersion._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkoutPlanVersion', 'id'),
            workoutPlanId: BuiltValueNullFieldError.checkNotNull(
                workoutPlanId, r'WorkoutPlanVersion', 'workoutPlanId'),
            versionNumber: BuiltValueNullFieldError.checkNotNull(
                versionNumber, r'WorkoutPlanVersion', 'versionNumber'),
            changelog: changelog,
            createdAt: createdAt,
            exercises: _exercises?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'exercises';
        _exercises?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutPlanVersion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
