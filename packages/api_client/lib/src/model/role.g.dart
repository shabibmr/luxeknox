// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Role extends Role {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final bool isSystemRole;
  @override
  final BuiltList<Permission>? permissions;

  factory _$Role([void Function(RoleBuilder)? updates]) =>
      (RoleBuilder()..update(updates))._build();

  _$Role._(
      {required this.id,
      required this.name,
      this.description,
      required this.isSystemRole,
      this.permissions})
      : super._();
  @override
  Role rebuild(void Function(RoleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleBuilder toBuilder() => RoleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Role &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        isSystemRole == other.isSystemRole &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, isSystemRole.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Role')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('isSystemRole', isSystemRole)
          ..add('permissions', permissions))
        .toString();
  }
}

class RoleBuilder implements Builder<Role, RoleBuilder> {
  _$Role? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _isSystemRole;
  bool? get isSystemRole => _$this._isSystemRole;
  set isSystemRole(bool? isSystemRole) => _$this._isSystemRole = isSystemRole;

  ListBuilder<Permission>? _permissions;
  ListBuilder<Permission> get permissions =>
      _$this._permissions ??= ListBuilder<Permission>();
  set permissions(ListBuilder<Permission>? permissions) =>
      _$this._permissions = permissions;

  RoleBuilder() {
    Role._defaults(this);
  }

  RoleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _isSystemRole = $v.isSystemRole;
      _permissions = $v.permissions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Role other) {
    _$v = other as _$Role;
  }

  @override
  void update(void Function(RoleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Role build() => _build();

  _$Role _build() {
    _$Role _$result;
    try {
      _$result = _$v ??
          _$Role._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Role', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'Role', 'name'),
            description: description,
            isSystemRole: BuiltValueNullFieldError.checkNotNull(
                isSystemRole, r'Role', 'isSystemRole'),
            permissions: _permissions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        _permissions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Role', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
