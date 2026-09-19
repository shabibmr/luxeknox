// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleWrite extends RoleWrite {
  @override
  final String name;
  @override
  final String? description;

  factory _$RoleWrite([void Function(RoleWriteBuilder)? updates]) =>
      (RoleWriteBuilder()..update(updates))._build();

  _$RoleWrite._({required this.name, this.description}) : super._();
  @override
  RoleWrite rebuild(void Function(RoleWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleWriteBuilder toBuilder() => RoleWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleWrite &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleWrite')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class RoleWriteBuilder implements Builder<RoleWrite, RoleWriteBuilder> {
  _$RoleWrite? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  RoleWriteBuilder() {
    RoleWrite._defaults(this);
  }

  RoleWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleWrite other) {
    _$v = other as _$RoleWrite;
  }

  @override
  void update(void Function(RoleWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleWrite build() => _build();

  _$RoleWrite _build() {
    final _$result = _$v ??
        _$RoleWrite._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'RoleWrite', 'name'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
