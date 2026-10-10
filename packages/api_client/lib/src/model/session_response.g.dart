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
  final String? tokenType;
  @override
  final int? expiresIn;
  @override
  final Principal principal;

  factory _$SessionResponse([void Function(SessionResponseBuilder)? updates]) =>
      (SessionResponseBuilder()..update(updates))._build();

  _$SessionResponse._(
      {required this.accessToken,
      required this.refreshToken,
      this.tokenType,
      this.expiresIn,
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
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        principal == other.principal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, tokenType.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionResponse')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
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

  String? _tokenType;
  String? get tokenType => _$this._tokenType;
  set tokenType(String? tokenType) => _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

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
      _tokenType = $v.tokenType;
      _expiresIn = $v.expiresIn;
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
            tokenType: tokenType,
            expiresIn: expiresIn,
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
