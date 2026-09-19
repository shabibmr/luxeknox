// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeResponse extends MeResponse {
  @override
  final User user;
  @override
  final Principal principal;
  @override
  final MeResponseProfile profile;

  factory _$MeResponse([void Function(MeResponseBuilder)? updates]) =>
      (MeResponseBuilder()..update(updates))._build();

  _$MeResponse._(
      {required this.user, required this.principal, required this.profile})
      : super._();
  @override
  MeResponse rebuild(void Function(MeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeResponseBuilder toBuilder() => MeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeResponse &&
        user == other.user &&
        principal == other.principal &&
        profile == other.profile;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, principal.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeResponse')
          ..add('user', user)
          ..add('principal', principal)
          ..add('profile', profile))
        .toString();
  }
}

class MeResponseBuilder implements Builder<MeResponse, MeResponseBuilder> {
  _$MeResponse? _$v;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  PrincipalBuilder? _principal;
  PrincipalBuilder get principal => _$this._principal ??= PrincipalBuilder();
  set principal(PrincipalBuilder? principal) => _$this._principal = principal;

  MeResponseProfileBuilder? _profile;
  MeResponseProfileBuilder get profile =>
      _$this._profile ??= MeResponseProfileBuilder();
  set profile(MeResponseProfileBuilder? profile) => _$this._profile = profile;

  MeResponseBuilder() {
    MeResponse._defaults(this);
  }

  MeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _principal = $v.principal.toBuilder();
      _profile = $v.profile.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeResponse other) {
    _$v = other as _$MeResponse;
  }

  @override
  void update(void Function(MeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeResponse build() => _build();

  _$MeResponse _build() {
    _$MeResponse _$result;
    try {
      _$result = _$v ??
          _$MeResponse._(
            user: user.build(),
            principal: principal.build(),
            profile: profile.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'principal';
        principal.build();
        _$failedField = 'profile';
        profile.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
