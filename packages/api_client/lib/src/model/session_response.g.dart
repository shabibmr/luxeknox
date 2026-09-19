// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionResponse extends SessionResponse {
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final Principal principal;

  factory _$SessionResponse([void Function(SessionResponseBuilder)? updates]) =>
      (SessionResponseBuilder()..update(updates))._build();

  _$SessionResponse._(
      {required this.accessToken,
      required this.refreshToken,
      required this.principal})
      : super._();
  @override
  SessionResponse rebuild(void Function(SessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionResponseBuilder toBuilder() => SessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionResponse &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        principal == other.principal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionResponse')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('principal', principal))
        .toString();
  }
}

class SessionResponseBuilder
    implements Builder<SessionResponse, SessionResponseBuilder> {
  _$SessionResponse? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  PrincipalBuilder? _principal;
  PrincipalBuilder get principal => _$this._principal ??= PrincipalBuilder();
  set principal(PrincipalBuilder? principal) => _$this._principal = principal;

  SessionResponseBuilder() {
    SessionResponse._defaults(this);
  }

  SessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _principal = $v.principal.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionResponse other) {
    _$v = other as _$SessionResponse;
  }

  @override
  void update(void Function(SessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionResponse build() => _build();

  _$SessionResponse _build() {
    _$SessionResponse _$result;
    try {
      _$result = _$v ??
          _$SessionResponse._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'SessionResponse', 'accessToken'),
            refreshToken: BuiltValueNullFieldError.checkNotNull(
                refreshToken, r'SessionResponse', 'refreshToken'),
            principal: principal.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'principal';
        principal.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SessionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
