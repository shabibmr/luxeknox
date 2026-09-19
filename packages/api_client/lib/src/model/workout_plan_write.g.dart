// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanWrite extends WorkoutPlanWrite {
  @override
  final String? title;
  @override
  final String? description;
  @override
  final int? memberId;
  @override
  final int? trainerId;
  @override
  final String? targetGoal;
  @override
  final String? difficulty;
  @override
  final int? durationWeeks;
  @override
  final bool? isTemplate;
  @override
  final int? rowVersion;

  factory _$WorkoutPlanWrite(
          [void Function(WorkoutPlanWriteBuilder)? updates]) =>
      (WorkoutPlanWriteBuilder()..update(updates))._build();

  _$WorkoutPlanWrite._(
      {this.title,
      this.description,
      this.memberId,
      this.trainerId,
      this.targetGoal,
      this.difficulty,
      this.durationWeeks,
      this.isTemplate,
      this.rowVersion})
      : super._();
  @override
  WorkoutPlanWrite rebuild(void Function(WorkoutPlanWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanWriteBuilder toBuilder() =>
      WorkoutPlanWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanWrite &&
        title == other.title &&
        description == other.description &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        targetGoal == other.targetGoal &&
        difficulty == other.difficulty &&
        durationWeeks == other.durationWeeks &&
        isTemplate == other.isTemplate &&
        rowVersion == other.rowVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, targetGoal.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, durationWeeks.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlanWrite')
          ..add('title', title)
          ..add('description', description)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('targetGoal', targetGoal)
          ..add('difficulty', difficulty)
          ..add('durationWeeks', durationWeeks)
          ..add('isTemplate', isTemplate)
          ..add('rowVersion', rowVersion))
        .toString();
  }
}

class WorkoutPlanWriteBuilder
    implements Builder<WorkoutPlanWrite, WorkoutPlanWriteBuilder> {
  _$WorkoutPlanWrite? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  String? _targetGoal;
  String? get targetGoal => _$this._targetGoal;
  set targetGoal(String? targetGoal) => _$this._targetGoal = targetGoal;

  String? _difficulty;
  String? get difficulty => _$this._difficulty;
  set difficulty(String? difficulty) => _$this._difficulty = difficulty;

  int? _durationWeeks;
  int? get durationWeeks => _$this._durationWeeks;
  set durationWeeks(int? durationWeeks) =>
      _$this._durationWeeks = durationWeeks;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  WorkoutPlanWriteBuilder() {
    WorkoutPlanWrite._defaults(this);
  }

  WorkoutPlanWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _targetGoal = $v.targetGoal;
      _difficulty = $v.difficulty;
      _durationWeeks = $v.durationWeeks;
      _isTemplate = $v.isTemplate;
      _rowVersion = $v.rowVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanWrite other) {
    _$v = other as _$WorkoutPlanWrite;
  }

  @override
  void update(void Function(WorkoutPlanWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanWrite build() => _build();

  _$WorkoutPlanWrite _build() {
    final _$result = _$v ??
        _$WorkoutPlanWrite._(
          title: title,
          description: description,
          memberId: memberId,
          trainerId: trainerId,
          targetGoal: targetGoal,
          difficulty: difficulty,
          durationWeeks: durationWeeks,
          isTemplate: isTemplate,
          rowVersion: rowVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
