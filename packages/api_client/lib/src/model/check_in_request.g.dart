// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckInRequest extends CheckInRequest {
  @override
  final int? userId;
  @override
  final AttendanceMethod? method;
  @override
  final String? gateIdentifier;
  @override
  final String? payload;

  factory _$CheckInRequest([void Function(CheckInRequestBuilder)? updates]) =>
      (CheckInRequestBuilder()..update(updates))._build();

  _$CheckInRequest._(
      {this.userId, this.method, this.gateIdentifier, this.payload})
      : super._();
  @override
  CheckInRequest rebuild(void Function(CheckInRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckInRequestBuilder toBuilder() => CheckInRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckInRequest &&
        userId == other.userId &&
        method == other.method &&
        gateIdentifier == other.gateIdentifier &&
        payload == other.payload;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, gateIdentifier.hashCode);
    _$hash = $jc(_$hash, payload.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckInRequest')
          ..add('userId', userId)
          ..add('method', method)
          ..add('gateIdentifier', gateIdentifier)
          ..add('payload', payload))
        .toString();
  }
}

class CheckInRequestBuilder
    implements Builder<CheckInRequest, CheckInRequestBuilder> {
  _$CheckInRequest? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  AttendanceMethod? _method;
  AttendanceMethod? get method => _$this._method;
  set method(AttendanceMethod? method) => _$this._method = method;

  String? _gateIdentifier;
  String? get gateIdentifier => _$this._gateIdentifier;
  set gateIdentifier(String? gateIdentifier) =>
      _$this._gateIdentifier = gateIdentifier;

  String? _payload;
  String? get payload => _$this._payload;
  set payload(String? payload) => _$this._payload = payload;

  CheckInRequestBuilder() {
    CheckInRequest._defaults(this);
  }

  CheckInRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _method = $v.method;
      _gateIdentifier = $v.gateIdentifier;
      _payload = $v.payload;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckInRequest other) {
    _$v = other as _$CheckInRequest;
  }

  @override
  void update(void Function(CheckInRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckInRequest build() => _build();

  _$CheckInRequest _build() {
    final _$result = _$v ??
        _$CheckInRequest._(
          userId: userId,
          method: method,
          gateIdentifier: gateIdentifier,
          payload: payload,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
