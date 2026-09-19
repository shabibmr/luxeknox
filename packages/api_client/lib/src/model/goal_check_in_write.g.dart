// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_check_in_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoalCheckInWrite extends GoalCheckInWrite {
  @override
  final num recordedValue;
  @override
  final Date? recordedDate;
  @override
  final String? notes;

  factory _$GoalCheckInWrite(
          [void Function(GoalCheckInWriteBuilder)? updates]) =>
      (GoalCheckInWriteBuilder()..update(updates))._build();

  _$GoalCheckInWrite._(
      {required this.recordedValue, this.recordedDate, this.notes})
      : super._();
  @override
  GoalCheckInWrite rebuild(void Function(GoalCheckInWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalCheckInWriteBuilder toBuilder() =>
      GoalCheckInWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalCheckInWrite &&
        recordedValue == other.recordedValue &&
        recordedDate == other.recordedDate &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recordedValue.hashCode);
    _$hash = $jc(_$hash, recordedDate.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoalCheckInWrite')
          ..add('recordedValue', recordedValue)
          ..add('recordedDate', recordedDate)
          ..add('notes', notes))
        .toString();
  }
}

class GoalCheckInWriteBuilder
    implements Builder<GoalCheckInWrite, GoalCheckInWriteBuilder> {
  _$GoalCheckInWrite? _$v;

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

  GoalCheckInWriteBuilder() {
    GoalCheckInWrite._defaults(this);
  }

  GoalCheckInWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recordedValue = $v.recordedValue;
      _recordedDate = $v.recordedDate;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalCheckInWrite other) {
    _$v = other as _$GoalCheckInWrite;
  }

  @override
  void update(void Function(GoalCheckInWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalCheckInWrite build() => _build();

  _$GoalCheckInWrite _build() {
    final _$result = _$v ??
        _$GoalCheckInWrite._(
          recordedValue: BuiltValueNullFieldError.checkNotNull(
              recordedValue, r'GoalCheckInWrite', 'recordedValue'),
          recordedDate: recordedDate,
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
