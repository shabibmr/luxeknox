// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RolePage extends RolePage {
  @override
  final BuiltList<Role> data;
  @override
  final PageMeta meta;

  factory _$RolePage([void Function(RolePageBuilder)? updates]) =>
      (RolePageBuilder()..update(updates))._build();

  _$RolePage._({required this.data, required this.meta}) : super._();
  @override
  RolePage rebuild(void Function(RolePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RolePageBuilder toBuilder() => RolePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RolePage && data == other.data && meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RolePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class RolePageBuilder implements Builder<RolePage, RolePageBuilder> {
  _$RolePage? _$v;

  ListBuilder<Role>? _data;
  ListBuilder<Role> get data => _$this._data ??= ListBuilder<Role>();
  set data(ListBuilder<Role>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  RolePageBuilder() {
    RolePage._defaults(this);
  }

  RolePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RolePage other) {
    _$v = other as _$RolePage;
  }

  @override
  void update(void Function(RolePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RolePage build() => _build();

  _$RolePage _build() {
    _$RolePage _$result;
    try {
      _$result = _$v ??
          _$RolePage._(
            data: data.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RolePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
