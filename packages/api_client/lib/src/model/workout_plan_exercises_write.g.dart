// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_exercises_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanExercisesWrite extends WorkoutPlanExercisesWrite {
  @override
  final String? changelog;
  @override
  final int? rowVersion;
  @override
  final BuiltList<WorkoutPlanExercisesWriteExercisesInner> exercises;

  factory _$WorkoutPlanExercisesWrite(
          [void Function(WorkoutPlanExercisesWriteBuilder)? updates]) =>
      (WorkoutPlanExercisesWriteBuilder()..update(updates))._build();

  _$WorkoutPlanExercisesWrite._(
      {this.changelog, this.rowVersion, required this.exercises})
      : super._();
  @override
  WorkoutPlanExercisesWrite rebuild(
          void Function(WorkoutPlanExercisesWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanExercisesWriteBuilder toBuilder() =>
      WorkoutPlanExercisesWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanExercisesWrite &&
        changelog == other.changelog &&
        rowVersion == other.rowVersion &&
        exercises == other.exercises;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changelog.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, exercises.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlanExercisesWrite')
          ..add('changelog', changelog)
          ..add('rowVersion', rowVersion)
          ..add('exercises', exercises))
        .toString();
  }
}

class WorkoutPlanExercisesWriteBuilder
    implements
        Builder<WorkoutPlanExercisesWrite, WorkoutPlanExercisesWriteBuilder> {
  _$WorkoutPlanExercisesWrite? _$v;

  String? _changelog;
  String? get changelog => _$this._changelog;
  set changelog(String? changelog) => _$this._changelog = changelog;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  ListBuilder<WorkoutPlanExercisesWriteExercisesInner>? _exercises;
  ListBuilder<WorkoutPlanExercisesWriteExercisesInner> get exercises =>
      _$this._exercises ??=
          ListBuilder<WorkoutPlanExercisesWriteExercisesInner>();
  set exercises(
          ListBuilder<WorkoutPlanExercisesWriteExercisesInner>? exercises) =>
      _$this._exercises = exercises;

  WorkoutPlanExercisesWriteBuilder() {
    WorkoutPlanExercisesWrite._defaults(this);
  }

  WorkoutPlanExercisesWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changelog = $v.changelog;
      _rowVersion = $v.rowVersion;
      _exercises = $v.exercises.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanExercisesWrite other) {
    _$v = other as _$WorkoutPlanExercisesWrite;
  }

  @override
  void update(void Function(WorkoutPlanExercisesWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanExercisesWrite build() => _build();

  _$WorkoutPlanExercisesWrite _build() {
    _$WorkoutPlanExercisesWrite _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanExercisesWrite._(
            changelog: changelog,
            rowVersion: rowVersion,
            exercises: exercises.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'exercises';
        exercises.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutPlanExercisesWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
