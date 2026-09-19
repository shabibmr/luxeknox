// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_permissions_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RolePermissionsWrite extends RolePermissionsWrite {
  @override
  final BuiltList<int> permissionIds;

  factory _$RolePermissionsWrite(
          [void Function(RolePermissionsWriteBuilder)? updates]) =>
      (RolePermissionsWriteBuilder()..update(updates))._build();

  _$RolePermissionsWrite._({required this.permissionIds}) : super._();
  @override
  RolePermissionsWrite rebuild(
          void Function(RolePermissionsWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RolePermissionsWriteBuilder toBuilder() =>
      RolePermissionsWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RolePermissionsWrite &&
        permissionIds == other.permissionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, permissionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RolePermissionsWrite')
          ..add('permissionIds', permissionIds))
        .toString();
  }
}

class RolePermissionsWriteBuilder
    implements Builder<RolePermissionsWrite, RolePermissionsWriteBuilder> {
  _$RolePermissionsWrite? _$v;

  ListBuilder<int>? _permissionIds;
  ListBuilder<int> get permissionIds =>
      _$this._permissionIds ??= ListBuilder<int>();
  set permissionIds(ListBuilder<int>? permissionIds) =>
      _$this._permissionIds = permissionIds;

  RolePermissionsWriteBuilder() {
    RolePermissionsWrite._defaults(this);
  }

  RolePermissionsWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _permissionIds = $v.permissionIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RolePermissionsWrite other) {
    _$v = other as _$RolePermissionsWrite;
  }

  @override
  void update(void Function(RolePermissionsWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RolePermissionsWrite build() => _build();

  _$RolePermissionsWrite _build() {
    _$RolePermissionsWrite _$result;
    try {
      _$result = _$v ??
          _$RolePermissionsWrite._(
            permissionIds: permissionIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissionIds';
        permissionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RolePermissionsWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
