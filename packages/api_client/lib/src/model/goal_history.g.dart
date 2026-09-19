// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoalHistory extends GoalHistory {
  @override
  final int id;
  @override
  final int goalId;
  @override
  final num recordedValue;
  @override
  final Date recordedDate;
  @override
  final String? notes;

  factory _$GoalHistory([void Function(GoalHistoryBuilder)? updates]) =>
      (GoalHistoryBuilder()..update(updates))._build();

  _$GoalHistory._(
      {required this.id,
      required this.goalId,
      required this.recordedValue,
      required this.recordedDate,
      this.notes})
      : super._();
  @override
  GoalHistory rebuild(void Function(GoalHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalHistoryBuilder toBuilder() => GoalHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalHistory &&
        id == other.id &&
        goalId == other.goalId &&
        recordedValue == other.recordedValue &&
        recordedDate == other.recordedDate &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, goalId.hashCode);
    _$hash = $jc(_$hash, recordedValue.hashCode);
    _$hash = $jc(_$hash, recordedDate.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoalHistory')
          ..add('id', id)
          ..add('goalId', goalId)
          ..add('recordedValue', recordedValue)
          ..add('recordedDate', recordedDate)
          ..add('notes', notes))
        .toString();
  }
}

class GoalHistoryBuilder implements Builder<GoalHistory, GoalHistoryBuilder> {
  _$GoalHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _goalId;
  int? get goalId => _$this._goalId;
  set goalId(int? goalId) => _$this._goalId = goalId;

  num? _recordedValue;
  num? get recordedValue => _$this._recordedValue;
  set recordedValue(num? recordedValue) =>
      _$this._recordedValue = recordedValue;

  Date? _recordedDate;
  Date? get recordedDate => _$this._recordedDate;
  set recordedDate(Date? recordedDate) => _$this._recordedDate = recordedDate;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  GoalHistoryBuilder() {
    GoalHistory._defaults(this);
  }

  GoalHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _goalId = $v.goalId;
      _recordedValue = $v.recordedValue;
      _recordedDate = $v.recordedDate;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalHistory other) {
    _$v = other as _$GoalHistory;
  }

  @override
  void update(void Function(GoalHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalHistory build() => _build();

  _$GoalHistory _build() {
    final _$result = _$v ??
        _$GoalHistory._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'GoalHistory', 'id'),
          goalId: BuiltValueNullFieldError.checkNotNull(
              goalId, r'GoalHistory', 'goalId'),
          recordedValue: BuiltValueNullFieldError.checkNotNull(
              recordedValue, r'GoalHistory', 'recordedValue'),
          recordedDate: BuiltValueNullFieldError.checkNotNull(
              recordedDate, r'GoalHistory', 'recordedDate'),
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
