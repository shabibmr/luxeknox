// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Permission extends Permission {
  @override
  final int id;
  @override
  final String module;
  @override
  final PermissionAction action;
  @override
  final String slug;

  factory _$Permission([void Function(PermissionBuilder)? updates]) =>
      (PermissionBuilder()..update(updates))._build();

  _$Permission._(
      {required this.id,
      required this.module,
      required this.action,
      required this.slug})
      : super._();
  @override
  Permission rebuild(void Function(PermissionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionBuilder toBuilder() => PermissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Permission &&
        id == other.id &&
        module == other.module &&
        action == other.action &&
        slug == other.slug;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, module.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Permission')
          ..add('id', id)
          ..add('module', module)
          ..add('action', action)
          ..add('slug', slug))
        .toString();
  }
}

class PermissionBuilder implements Builder<Permission, PermissionBuilder> {
  _$Permission? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _module;
  String? get module => _$this._module;
  set module(String? module) => _$this._module = module;

  PermissionAction? _action;
  PermissionAction? get action => _$this._action;
  set action(PermissionAction? action) => _$this._action = action;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  PermissionBuilder() {
    Permission._defaults(this);
  }

  PermissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _module = $v.module;
      _action = $v.action;
      _slug = $v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Permission other) {
    _$v = other as _$Permission;
  }

  @override
  void update(void Function(PermissionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Permission build() => _build();

  _$Permission _build() {
    final _$result = _$v ??
        _$Permission._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Permission', 'id'),
          module: BuiltValueNullFieldError.checkNotNull(
              module, r'Permission', 'module'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'Permission', 'action'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'Permission', 'slug'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
