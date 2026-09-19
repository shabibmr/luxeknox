// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleWrite extends ScheduleWrite {
  @override
  final int? seriesId;
  @override
  final int? scheduleTypeId;
  @override
  final int? facilityId;
  @override
  final int? trainerId;
  @override
  final String? title;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final int? maxCapacity;
  @override
  final String? notes;
  @override
  final int? rowVersion;
  @override
  final Date? recurUntil;

  factory _$ScheduleWrite([void Function(ScheduleWriteBuilder)? updates]) =>
      (ScheduleWriteBuilder()..update(updates))._build();

  _$ScheduleWrite._(
      {this.seriesId,
      this.scheduleTypeId,
      this.facilityId,
      this.trainerId,
      this.title,
      this.startTime,
      this.endTime,
      this.maxCapacity,
      this.notes,
      this.rowVersion,
      this.recurUntil})
      : super._();
  @override
  ScheduleWrite rebuild(void Function(ScheduleWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleWriteBuilder toBuilder() => ScheduleWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleWrite &&
        seriesId == other.seriesId &&
        scheduleTypeId == other.scheduleTypeId &&
        facilityId == other.facilityId &&
        trainerId == other.trainerId &&
        title == other.title &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        maxCapacity == other.maxCapacity &&
        notes == other.notes &&
        rowVersion == other.rowVersion &&
        recurUntil == other.recurUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seriesId.hashCode);
    _$hash = $jc(_$hash, scheduleTypeId.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, maxCapacity.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, recurUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleWrite')
          ..add('seriesId', seriesId)
          ..add('scheduleTypeId', scheduleTypeId)
          ..add('facilityId', facilityId)
          ..add('trainerId', trainerId)
          ..add('title', title)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('maxCapacity', maxCapacity)
          ..add('notes', notes)
          ..add('rowVersion', rowVersion)
          ..add('recurUntil', recurUntil))
        .toString();
  }
}

class ScheduleWriteBuilder
    implements Builder<ScheduleWrite, ScheduleWriteBuilder> {
  _$ScheduleWrite? _$v;

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

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  Date? _recurUntil;
  Date? get recurUntil => _$this._recurUntil;
  set recurUntil(Date? recurUntil) => _$this._recurUntil = recurUntil;

  ScheduleWriteBuilder() {
    ScheduleWrite._defaults(this);
  }

  ScheduleWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seriesId = $v.seriesId;
      _scheduleTypeId = $v.scheduleTypeId;
      _facilityId = $v.facilityId;
      _trainerId = $v.trainerId;
      _title = $v.title;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _maxCapacity = $v.maxCapacity;
      _notes = $v.notes;
      _rowVersion = $v.rowVersion;
      _recurUntil = $v.recurUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleWrite other) {
    _$v = other as _$ScheduleWrite;
  }

  @override
  void update(void Function(ScheduleWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleWrite build() => _build();

  _$ScheduleWrite _build() {
    final _$result = _$v ??
        _$ScheduleWrite._(
          seriesId: seriesId,
          scheduleTypeId: scheduleTypeId,
          facilityId: facilityId,
          trainerId: trainerId,
          title: title,
          startTime: startTime,
          endTime: endTime,
          maxCapacity: maxCapacity,
          notes: notes,
          rowVersion: rowVersion,
          recurUntil: recurUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
