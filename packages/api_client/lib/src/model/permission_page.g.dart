// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionPage extends PermissionPage {
  @override
  final BuiltList<Permission> data;
  @override
  final PageMeta meta;

  factory _$PermissionPage([void Function(PermissionPageBuilder)? updates]) =>
      (PermissionPageBuilder()..update(updates))._build();

  _$PermissionPage._({required this.data, required this.meta}) : super._();
  @override
  PermissionPage rebuild(void Function(PermissionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionPageBuilder toBuilder() => PermissionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'PermissionPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PermissionPageBuilder
    implements Builder<PermissionPage, PermissionPageBuilder> {
  _$PermissionPage? _$v;

  ListBuilder<Permission>? _data;
  ListBuilder<Permission> get data =>
      _$this._data ??= ListBuilder<Permission>();
  set data(ListBuilder<Permission>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PermissionPageBuilder() {
    PermissionPage._defaults(this);
  }

  PermissionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionPage other) {
    _$v = other as _$PermissionPage;
  }

  @override
  void update(void Function(PermissionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionPage build() => _build();

  _$PermissionPage _build() {
    _$PermissionPage _$result;
    try {
      _$result = _$v ??
          _$PermissionPage._(
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
            r'PermissionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
