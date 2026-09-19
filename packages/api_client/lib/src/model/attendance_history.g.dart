// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendanceHistory extends AttendanceHistory {
  @override
  final int id;
  @override
  final Date date;
  @override
  final int totalMemberCheckins;
  @override
  final int? totalTrainerCheckins;
  @override
  final int? peakHour;
  @override
  final int? peakCount;

  factory _$AttendanceHistory(
          [void Function(AttendanceHistoryBuilder)? updates]) =>
      (AttendanceHistoryBuilder()..update(updates))._build();

  _$AttendanceHistory._(
      {required this.id,
      required this.date,
      required this.totalMemberCheckins,
      this.totalTrainerCheckins,
      this.peakHour,
      this.peakCount})
      : super._();
  @override
  AttendanceHistory rebuild(void Function(AttendanceHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceHistoryBuilder toBuilder() =>
      AttendanceHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendanceHistory &&
        id == other.id &&
        date == other.date &&
        totalMemberCheckins == other.totalMemberCheckins &&
        totalTrainerCheckins == other.totalTrainerCheckins &&
        peakHour == other.peakHour &&
        peakCount == other.peakCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, totalMemberCheckins.hashCode);
    _$hash = $jc(_$hash, totalTrainerCheckins.hashCode);
    _$hash = $jc(_$hash, peakHour.hashCode);
    _$hash = $jc(_$hash, peakCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttendanceHistory')
          ..add('id', id)
          ..add('date', date)
          ..add('totalMemberCheckins', totalMemberCheckins)
          ..add('totalTrainerCheckins', totalTrainerCheckins)
          ..add('peakHour', peakHour)
          ..add('peakCount', peakCount))
        .toString();
  }
}

class AttendanceHistoryBuilder
    implements Builder<AttendanceHistory, AttendanceHistoryBuilder> {
  _$AttendanceHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _totalMemberCheckins;
  int? get totalMemberCheckins => _$this._totalMemberCheckins;
  set totalMemberCheckins(int? totalMemberCheckins) =>
      _$this._totalMemberCheckins = totalMemberCheckins;

  int? _totalTrainerCheckins;
  int? get totalTrainerCheckins => _$this._totalTrainerCheckins;
  set totalTrainerCheckins(int? totalTrainerCheckins) =>
      _$this._totalTrainerCheckins = totalTrainerCheckins;

  int? _peakHour;
  int? get peakHour => _$this._peakHour;
  set peakHour(int? peakHour) => _$this._peakHour = peakHour;

  int? _peakCount;
  int? get peakCount => _$this._peakCount;
  set peakCount(int? peakCount) => _$this._peakCount = peakCount;

  AttendanceHistoryBuilder() {
    AttendanceHistory._defaults(this);
  }

  AttendanceHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _totalMemberCheckins = $v.totalMemberCheckins;
      _totalTrainerCheckins = $v.totalTrainerCheckins;
      _peakHour = $v.peakHour;
      _peakCount = $v.peakCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendanceHistory other) {
    _$v = other as _$AttendanceHistory;
  }

  @override
  void update(void Function(AttendanceHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendanceHistory build() => _build();

  _$AttendanceHistory _build() {
    final _$result = _$v ??
        _$AttendanceHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AttendanceHistory', 'id'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AttendanceHistory', 'date'),
          totalMemberCheckins: BuiltValueNullFieldError.checkNotNull(
              totalMemberCheckins, r'AttendanceHistory', 'totalMemberCheckins'),
          totalTrainerCheckins: totalTrainerCheckins,
          peakHour: peakHour,
          peakCount: peakCount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
