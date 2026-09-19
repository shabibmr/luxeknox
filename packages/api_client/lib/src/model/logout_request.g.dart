// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoutRequest extends LogoutRequest {
  @override
  final bool? all;

  factory _$LogoutRequest([void Function(LogoutRequestBuilder)? updates]) =>
      (LogoutRequestBuilder()..update(updates))._build();

  _$LogoutRequest._({this.all}) : super._();
  @override
  LogoutRequest rebuild(void Function(LogoutRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutRequestBuilder toBuilder() => LogoutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutRequest && all == other.all;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, all.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogoutRequest')..add('all', all))
        .toString();
  }
}

class LogoutRequestBuilder
    implements Builder<LogoutRequest, LogoutRequestBuilder> {
  _$LogoutRequest? _$v;

  bool? _all;
  bool? get all => _$this._all;
  set all(bool? all) => _$this._all = all;

  LogoutRequestBuilder() {
    LogoutRequest._defaults(this);
  }

  LogoutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _all = $v.all;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutRequest other) {
    _$v = other as _$LogoutRequest;
  }

  @override
  void update(void Function(LogoutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoutRequest build() => _build();

  _$LogoutRequest _build() {
    final _$result = _$v ??
        _$LogoutRequest._(
          all: all,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
