// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleHistory extends ScheduleHistory {
  @override
  final int id;
  @override
  final int scheduleId;
  @override
  final String action;
  @override
  final int? changedByUserId;
  @override
  final String? notes;
  @override
  final DateTime timestamp;

  factory _$ScheduleHistory([void Function(ScheduleHistoryBuilder)? updates]) =>
      (ScheduleHistoryBuilder()..update(updates))._build();

  _$ScheduleHistory._(
      {required this.id,
      required this.scheduleId,
      required this.action,
      this.changedByUserId,
      this.notes,
      required this.timestamp})
      : super._();
  @override
  ScheduleHistory rebuild(void Function(ScheduleHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleHistoryBuilder toBuilder() => ScheduleHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleHistory &&
        id == other.id &&
        scheduleId == other.scheduleId &&
        action == other.action &&
        changedByUserId == other.changedByUserId &&
        notes == other.notes &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, scheduleId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, changedByUserId.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleHistory')
          ..add('id', id)
          ..add('scheduleId', scheduleId)
          ..add('action', action)
          ..add('changedByUserId', changedByUserId)
          ..add('notes', notes)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ScheduleHistoryBuilder
    implements Builder<ScheduleHistory, ScheduleHistoryBuilder> {
  _$ScheduleHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _scheduleId;
  int? get scheduleId => _$this._scheduleId;
  set scheduleId(int? scheduleId) => _$this._scheduleId = scheduleId;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  int? _changedByUserId;
  int? get changedByUserId => _$this._changedByUserId;
  set changedByUserId(int? changedByUserId) =>
      _$this._changedByUserId = changedByUserId;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  ScheduleHistoryBuilder() {
    ScheduleHistory._defaults(this);
  }

  ScheduleHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _scheduleId = $v.scheduleId;
      _action = $v.action;
      _changedByUserId = $v.changedByUserId;
      _notes = $v.notes;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleHistory other) {
    _$v = other as _$ScheduleHistory;
  }

  @override
  void update(void Function(ScheduleHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleHistory build() => _build();

  _$ScheduleHistory _build() {
    final _$result = _$v ??
        _$ScheduleHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ScheduleHistory', 'id'),
          scheduleId: BuiltValueNullFieldError.checkNotNull(
              scheduleId, r'ScheduleHistory', 'scheduleId'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ScheduleHistory', 'action'),
          changedByUserId: changedByUserId,
          notes: notes,
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'ScheduleHistory', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
