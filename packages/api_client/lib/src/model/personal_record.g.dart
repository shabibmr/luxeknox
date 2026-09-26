// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PersonalRecord extends PersonalRecord {
  @override
  final int exerciseId;
  @override
  final String exerciseName;
  @override
  final num maxWeightKg;
  @override
  final int maxReps;
  @override
  final num bestSetVolumeKg;
  @override
  final DateTime achievedAt;

  factory _$PersonalRecord([void Function(PersonalRecordBuilder)? updates]) =>
      (PersonalRecordBuilder()..update(updates))._build();

  _$PersonalRecord._(
      {required this.exerciseId,
      required this.exerciseName,
      required this.maxWeightKg,
      required this.maxReps,
      required this.bestSetVolumeKg,
      required this.achievedAt})
      : super._();
  @override
  PersonalRecord rebuild(void Function(PersonalRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PersonalRecordBuilder toBuilder() => PersonalRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PersonalRecord &&
        exerciseId == other.exerciseId &&
        exerciseName == other.exerciseName &&
        maxWeightKg == other.maxWeightKg &&
        maxReps == other.maxReps &&
        bestSetVolumeKg == other.bestSetVolumeKg &&
        achievedAt == other.achievedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, exerciseId.hashCode);
    _$hash = $jc(_$hash, exerciseName.hashCode);
    _$hash = $jc(_$hash, maxWeightKg.hashCode);
    _$hash = $jc(_$hash, maxReps.hashCode);
    _$hash = $jc(_$hash, bestSetVolumeKg.hashCode);
    _$hash = $jc(_$hash, achievedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PersonalRecord')
          ..add('exerciseId', exerciseId)
          ..add('exerciseName', exerciseName)
          ..add('maxWeightKg', maxWeightKg)
          ..add('maxReps', maxReps)
          ..add('bestSetVolumeKg', bestSetVolumeKg)
          ..add('achievedAt', achievedAt))
        .toString();
  }
}

class PersonalRecordBuilder
    implements Builder<PersonalRecord, PersonalRecordBuilder> {
  _$PersonalRecord? _$v;

  int? _exerciseId;
  int? get exerciseId => _$this._exerciseId;
  set exerciseId(int? exerciseId) => _$this._exerciseId = exerciseId;

  String? _exerciseName;
  String? get exerciseName => _$this._exerciseName;
  set exerciseName(String? exerciseName) => _$this._exerciseName = exerciseName;

  num? _maxWeightKg;
  num? get maxWeightKg => _$this._maxWeightKg;
  set maxWeightKg(num? maxWeightKg) => _$this._maxWeightKg = maxWeightKg;

  int? _maxReps;
  int? get maxReps => _$this._maxReps;
  set maxReps(int? maxReps) => _$this._maxReps = maxReps;

  num? _bestSetVolumeKg;
  num? get bestSetVolumeKg => _$this._bestSetVolumeKg;
  set bestSetVolumeKg(num? bestSetVolumeKg) =>
      _$this._bestSetVolumeKg = bestSetVolumeKg;

  DateTime? _achievedAt;
  DateTime? get achievedAt => _$this._achievedAt;
  set achievedAt(DateTime? achievedAt) => _$this._achievedAt = achievedAt;

  PersonalRecordBuilder() {
    PersonalRecord._defaults(this);
  }

  PersonalRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _exerciseId = $v.exerciseId;
      _exerciseName = $v.exerciseName;
      _maxWeightKg = $v.maxWeightKg;
      _maxReps = $v.maxReps;
      _bestSetVolumeKg = $v.bestSetVolumeKg;
      _achievedAt = $v.achievedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PersonalRecord other) {
    _$v = other as _$PersonalRecord;
  }

  @override
  void update(void Function(PersonalRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PersonalRecord build() => _build();

  _$PersonalRecord _build() {
    final _$result = _$v ??
        _$PersonalRecord._(
          exerciseId: BuiltValueNullFieldError.checkNotNull(
              exerciseId, r'PersonalRecord', 'exerciseId'),
          exerciseName: BuiltValueNullFieldError.checkNotNull(
              exerciseName, r'PersonalRecord', 'exerciseName'),
          maxWeightKg: BuiltValueNullFieldError.checkNotNull(
              maxWeightKg, r'PersonalRecord', 'maxWeightKg'),
          maxReps: BuiltValueNullFieldError.checkNotNull(
              maxReps, r'PersonalRecord', 'maxReps'),
          bestSetVolumeKg: BuiltValueNullFieldError.checkNotNull(
              bestSetVolumeKg, r'PersonalRecord', 'bestSetVolumeKg'),
          achievedAt: BuiltValueNullFieldError.checkNotNull(
              achievedAt, r'PersonalRecord', 'achievedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
