// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'principal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Principal extends Principal {
  @override
  final int userId;
  @override
  final UserType userType;
  @override
  final String role;
  @override
  final int? roleId;
  @override
  final int? profileId;
  @override
  final BuiltList<String> permissions;

  factory _$Principal([void Function(PrincipalBuilder)? updates]) =>
      (PrincipalBuilder()..update(updates))._build();

  _$Principal._(
      {required this.userId,
      required this.userType,
      required this.role,
      this.roleId,
      this.profileId,
      required this.permissions})
      : super._();
  @override
  Principal rebuild(void Function(PrincipalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrincipalBuilder toBuilder() => PrincipalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Principal &&
        userId == other.userId &&
        userType == other.userType &&
        role == other.role &&
        roleId == other.roleId &&
        profileId == other.profileId &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, userType.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jc(_$hash, profileId.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Principal')
          ..add('userId', userId)
          ..add('userType', userType)
          ..add('role', role)
          ..add('roleId', roleId)
          ..add('profileId', profileId)
          ..add('permissions', permissions))
        .toString();
  }
}

class PrincipalBuilder implements Builder<Principal, PrincipalBuilder> {
  _$Principal? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  UserType? _userType;
  UserType? get userType => _$this._userType;
  set userType(UserType? userType) => _$this._userType = userType;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  int? _roleId;
  int? get roleId => _$this._roleId;
  set roleId(int? roleId) => _$this._roleId = roleId;

  int? _profileId;
  int? get profileId => _$this._profileId;
  set profileId(int? profileId) => _$this._profileId = profileId;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  PrincipalBuilder() {
    Principal._defaults(this);
  }

  PrincipalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _userType = $v.userType;
      _role = $v.role;
      _roleId = $v.roleId;
      _profileId = $v.profileId;
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Principal other) {
    _$v = other as _$Principal;
  }

  @override
  void update(void Function(PrincipalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Principal build() => _build();

  _$Principal _build() {
    _$Principal _$result;
    try {
      _$result = _$v ??
          _$Principal._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'Principal', 'userId'),
            userType: BuiltValueNullFieldError.checkNotNull(
                userType, r'Principal', 'userType'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'Principal', 'role'),
            roleId: roleId,
            profileId: profileId,
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Principal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
