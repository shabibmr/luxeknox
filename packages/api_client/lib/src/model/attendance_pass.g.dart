// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_pass.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendancePass extends AttendancePass {
  @override
  final int userId;
  @override
  final String payload;
  @override
  final DateTime expiresAt;

  factory _$AttendancePass([void Function(AttendancePassBuilder)? updates]) =>
      (AttendancePassBuilder()..update(updates))._build();

  _$AttendancePass._(
      {required this.userId, required this.payload, required this.expiresAt})
      : super._();
  @override
  AttendancePass rebuild(void Function(AttendancePassBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendancePassBuilder toBuilder() => AttendancePassBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendancePass &&
        userId == other.userId &&
        payload == other.payload &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, payload.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttendancePass')
          ..add('userId', userId)
          ..add('payload', payload)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AttendancePassBuilder
    implements Builder<AttendancePass, AttendancePassBuilder> {
  _$AttendancePass? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _payload;
  String? get payload => _$this._payload;
  set payload(String? payload) => _$this._payload = payload;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AttendancePassBuilder() {
    AttendancePass._defaults(this);
  }

  AttendancePassBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _payload = $v.payload;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendancePass other) {
    _$v = other as _$AttendancePass;
  }

  @override
  void update(void Function(AttendancePassBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendancePass build() => _build();

  _$AttendancePass _build() {
    final _$result = _$v ??
        _$AttendancePass._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'AttendancePass', 'userId'),
          payload: BuiltValueNullFieldError.checkNotNull(
              payload, r'AttendancePass', 'payload'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'AttendancePass', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
