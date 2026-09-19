// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Attendance extends Attendance {
  @override
  final int id;
  @override
  final int userId;
  @override
  final DateTime checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final AttendanceMethod method;
  @override
  final String? gateIdentifier;
  @override
  final int? verifiedByUserId;

  factory _$Attendance([void Function(AttendanceBuilder)? updates]) =>
      (AttendanceBuilder()..update(updates))._build();

  _$Attendance._(
      {required this.id,
      required this.userId,
      required this.checkInTime,
      this.checkOutTime,
      required this.method,
      this.gateIdentifier,
      this.verifiedByUserId})
      : super._();
  @override
  Attendance rebuild(void Function(AttendanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceBuilder toBuilder() => AttendanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Attendance &&
        id == other.id &&
        userId == other.userId &&
        checkInTime == other.checkInTime &&
        checkOutTime == other.checkOutTime &&
        method == other.method &&
        gateIdentifier == other.gateIdentifier &&
        verifiedByUserId == other.verifiedByUserId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, checkInTime.hashCode);
    _$hash = $jc(_$hash, checkOutTime.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, gateIdentifier.hashCode);
    _$hash = $jc(_$hash, verifiedByUserId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Attendance')
          ..add('id', id)
          ..add('userId', userId)
          ..add('checkInTime', checkInTime)
          ..add('checkOutTime', checkOutTime)
          ..add('method', method)
          ..add('gateIdentifier', gateIdentifier)
          ..add('verifiedByUserId', verifiedByUserId))
        .toString();
  }
}

class AttendanceBuilder implements Builder<Attendance, AttendanceBuilder> {
  _$Attendance? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  DateTime? _checkInTime;
  DateTime? get checkInTime => _$this._checkInTime;
  set checkInTime(DateTime? checkInTime) => _$this._checkInTime = checkInTime;

  DateTime? _checkOutTime;
  DateTime? get checkOutTime => _$this._checkOutTime;
  set checkOutTime(DateTime? checkOutTime) =>
      _$this._checkOutTime = checkOutTime;

  AttendanceMethod? _method;
  AttendanceMethod? get method => _$this._method;
  set method(AttendanceMethod? method) => _$this._method = method;

  String? _gateIdentifier;
  String? get gateIdentifier => _$this._gateIdentifier;
  set gateIdentifier(String? gateIdentifier) =>
      _$this._gateIdentifier = gateIdentifier;

  int? _verifiedByUserId;
  int? get verifiedByUserId => _$this._verifiedByUserId;
  set verifiedByUserId(int? verifiedByUserId) =>
      _$this._verifiedByUserId = verifiedByUserId;

  AttendanceBuilder() {
    Attendance._defaults(this);
  }

  AttendanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _checkInTime = $v.checkInTime;
      _checkOutTime = $v.checkOutTime;
      _method = $v.method;
      _gateIdentifier = $v.gateIdentifier;
      _verifiedByUserId = $v.verifiedByUserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Attendance other) {
    _$v = other as _$Attendance;
  }

  @override
  void update(void Function(AttendanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Attendance build() => _build();

  _$Attendance _build() {
    final _$result = _$v ??
        _$Attendance._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Attendance', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'Attendance', 'userId'),
          checkInTime: BuiltValueNullFieldError.checkNotNull(
              checkInTime, r'Attendance', 'checkInTime'),
          checkOutTime: checkOutTime,
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'Attendance', 'method'),
          gateIdentifier: gateIdentifier,
          verifiedByUserId: verifiedByUserId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
