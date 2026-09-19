// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendanceSummary extends AttendanceSummary {
  @override
  final int? streakDays;
  @override
  final DateTime? lastCheckIn;
  @override
  final int? visitsThisMonth;

  factory _$AttendanceSummary(
          [void Function(AttendanceSummaryBuilder)? updates]) =>
      (AttendanceSummaryBuilder()..update(updates))._build();

  _$AttendanceSummary._(
      {this.streakDays, this.lastCheckIn, this.visitsThisMonth})
      : super._();
  @override
  AttendanceSummary rebuild(void Function(AttendanceSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceSummaryBuilder toBuilder() =>
      AttendanceSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendanceSummary &&
        streakDays == other.streakDays &&
        lastCheckIn == other.lastCheckIn &&
        visitsThisMonth == other.visitsThisMonth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, streakDays.hashCode);
    _$hash = $jc(_$hash, lastCheckIn.hashCode);
    _$hash = $jc(_$hash, visitsThisMonth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttendanceSummary')
          ..add('streakDays', streakDays)
          ..add('lastCheckIn', lastCheckIn)
          ..add('visitsThisMonth', visitsThisMonth))
        .toString();
  }
}

class AttendanceSummaryBuilder
    implements Builder<AttendanceSummary, AttendanceSummaryBuilder> {
  _$AttendanceSummary? _$v;

  int? _streakDays;
  int? get streakDays => _$this._streakDays;
  set streakDays(int? streakDays) => _$this._streakDays = streakDays;

  DateTime? _lastCheckIn;
  DateTime? get lastCheckIn => _$this._lastCheckIn;
  set lastCheckIn(DateTime? lastCheckIn) => _$this._lastCheckIn = lastCheckIn;

  int? _visitsThisMonth;
  int? get visitsThisMonth => _$this._visitsThisMonth;
  set visitsThisMonth(int? visitsThisMonth) =>
      _$this._visitsThisMonth = visitsThisMonth;

  AttendanceSummaryBuilder() {
    AttendanceSummary._defaults(this);
  }

  AttendanceSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _streakDays = $v.streakDays;
      _lastCheckIn = $v.lastCheckIn;
      _visitsThisMonth = $v.visitsThisMonth;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendanceSummary other) {
    _$v = other as _$AttendanceSummary;
  }

  @override
  void update(void Function(AttendanceSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendanceSummary build() => _build();

  _$AttendanceSummary _build() {
    final _$result = _$v ??
        _$AttendanceSummary._(
          streakDays: streakDays,
          lastCheckIn: lastCheckIn,
          visitsThisMonth: visitsThisMonth,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
