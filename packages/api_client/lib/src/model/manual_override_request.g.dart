// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_override_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ManualOverrideRequest extends ManualOverrideRequest {
  @override
  final int userId;
  @override
  final String? gateIdentifier;
  @override
  final String reason;

  factory _$ManualOverrideRequest(
          [void Function(ManualOverrideRequestBuilder)? updates]) =>
      (ManualOverrideRequestBuilder()..update(updates))._build();

  _$ManualOverrideRequest._(
      {required this.userId, this.gateIdentifier, required this.reason})
      : super._();
  @override
  ManualOverrideRequest rebuild(
          void Function(ManualOverrideRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManualOverrideRequestBuilder toBuilder() =>
      ManualOverrideRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManualOverrideRequest &&
        userId == other.userId &&
        gateIdentifier == other.gateIdentifier &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, gateIdentifier.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManualOverrideRequest')
          ..add('userId', userId)
          ..add('gateIdentifier', gateIdentifier)
          ..add('reason', reason))
        .toString();
  }
}

class ManualOverrideRequestBuilder
    implements Builder<ManualOverrideRequest, ManualOverrideRequestBuilder> {
  _$ManualOverrideRequest? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _gateIdentifier;
  String? get gateIdentifier => _$this._gateIdentifier;
  set gateIdentifier(String? gateIdentifier) =>
      _$this._gateIdentifier = gateIdentifier;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ManualOverrideRequestBuilder() {
    ManualOverrideRequest._defaults(this);
  }

  ManualOverrideRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _gateIdentifier = $v.gateIdentifier;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManualOverrideRequest other) {
    _$v = other as _$ManualOverrideRequest;
  }

  @override
  void update(void Function(ManualOverrideRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManualOverrideRequest build() => _build();

  _$ManualOverrideRequest _build() {
    final _$result = _$v ??
        _$ManualOverrideRequest._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'ManualOverrideRequest', 'userId'),
          gateIdentifier: gateIdentifier,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ManualOverrideRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
