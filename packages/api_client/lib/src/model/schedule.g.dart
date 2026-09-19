// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Schedule extends Schedule {
  @override
  final int id;
  @override
  final int? seriesId;
  @override
  final int scheduleTypeId;
  @override
  final int? facilityId;
  @override
  final int? trainerId;
  @override
  final String title;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int? maxCapacity;
  @override
  final ScheduleStatus status;
  @override
  final String? notes;
  @override
  final int rowVersion;
  @override
  final BuiltList<ScheduleParticipant>? participants;

  factory _$Schedule([void Function(ScheduleBuilder)? updates]) =>
      (ScheduleBuilder()..update(updates))._build();

  _$Schedule._(
      {required this.id,
      this.seriesId,
      required this.scheduleTypeId,
      this.facilityId,
      this.trainerId,
      required this.title,
      required this.startTime,
      required this.endTime,
      this.maxCapacity,
      required this.status,
      this.notes,
      required this.rowVersion,
      this.participants})
      : super._();
  @override
  Schedule rebuild(void Function(ScheduleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleBuilder toBuilder() => ScheduleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Schedule &&
        id == other.id &&
        seriesId == other.seriesId &&
        scheduleTypeId == other.scheduleTypeId &&
        facilityId == other.facilityId &&
        trainerId == other.trainerId &&
        title == other.title &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        maxCapacity == other.maxCapacity &&
        status == other.status &&
        notes == other.notes &&
        rowVersion == other.rowVersion &&
        participants == other.participants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, seriesId.hashCode);
    _$hash = $jc(_$hash, scheduleTypeId.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, maxCapacity.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Schedule')
          ..add('id', id)
          ..add('seriesId', seriesId)
          ..add('scheduleTypeId', scheduleTypeId)
          ..add('facilityId', facilityId)
          ..add('trainerId', trainerId)
          ..add('title', title)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('maxCapacity', maxCapacity)
          ..add('status', status)
          ..add('notes', notes)
          ..add('rowVersion', rowVersion)
          ..add('participants', participants))
        .toString();
  }
}

class ScheduleBuilder implements Builder<Schedule, ScheduleBuilder> {
  _$Schedule? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _seriesId;
  int? get seriesId => _$this._seriesId;
  set seriesId(int? seriesId) => _$this._seriesId = seriesId;

  int? _scheduleTypeId;
  int? get scheduleTypeId => _$this._scheduleTypeId;
  set scheduleTypeId(int? scheduleTypeId) =>
      _$this._scheduleTypeId = scheduleTypeId;

  int? _facilityId;
  int? get facilityId => _$this._facilityId;
  set facilityId(int? facilityId) => _$this._facilityId = facilityId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  DateTime? _endTime;
  DateTime? get endTime => _$this._endTime;
  set endTime(DateTime? endTime) => _$this._endTime = endTime;

  int? _maxCapacity;
  int? get maxCapacity => _$this._maxCapacity;
  set maxCapacity(int? maxCapacity) => _$this._maxCapacity = maxCapacity;

  ScheduleStatus? _status;
  ScheduleStatus? get status => _$this._status;
  set status(ScheduleStatus? status) => _$this._status = status;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  ListBuilder<ScheduleParticipant>? _participants;
  ListBuilder<ScheduleParticipant> get participants =>
      _$this._participants ??= ListBuilder<ScheduleParticipant>();
  set participants(ListBuilder<ScheduleParticipant>? participants) =>
      _$this._participants = participants;

  ScheduleBuilder() {
    Schedule._defaults(this);
  }

  ScheduleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _seriesId = $v.seriesId;
      _scheduleTypeId = $v.scheduleTypeId;
      _facilityId = $v.facilityId;
      _trainerId = $v.trainerId;
      _title = $v.title;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _maxCapacity = $v.maxCapacity;
      _status = $v.status;
      _notes = $v.notes;
      _rowVersion = $v.rowVersion;
      _participants = $v.participants?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Schedule other) {
    _$v = other as _$Schedule;
  }

  @override
  void update(void Function(ScheduleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Schedule build() => _build();

  _$Schedule _build() {
    _$Schedule _$result;
    try {
      _$result = _$v ??
          _$Schedule._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Schedule', 'id'),
            seriesId: seriesId,
            scheduleTypeId: BuiltValueNullFieldError.checkNotNull(
                scheduleTypeId, r'Schedule', 'scheduleTypeId'),
            facilityId: facilityId,
            trainerId: trainerId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'Schedule', 'title'),
            startTime: BuiltValueNullFieldError.checkNotNull(
                startTime, r'Schedule', 'startTime'),
            endTime: BuiltValueNullFieldError.checkNotNull(
                endTime, r'Schedule', 'endTime'),
            maxCapacity: maxCapacity,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Schedule', 'status'),
            notes: notes,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'Schedule', 'rowVersion'),
            participants: _participants?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participants';
        _participants?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Schedule', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
