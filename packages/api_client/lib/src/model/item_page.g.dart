// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemPage extends ItemPage {
  @override
  final BuiltList<Item> data;
  @override
  final PageMeta meta;

  factory _$ItemPage([void Function(ItemPageBuilder)? updates]) =>
      (ItemPageBuilder()..update(updates))._build();

  _$ItemPage._({required this.data, required this.meta}) : super._();
  @override
  ItemPage rebuild(void Function(ItemPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemPageBuilder toBuilder() => ItemPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'ItemPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ItemPageBuilder implements Builder<ItemPage, ItemPageBuilder> {
  _$ItemPage? _$v;

  ListBuilder<Item>? _data;
  ListBuilder<Item> get data => _$this._data ??= ListBuilder<Item>();
  set data(ListBuilder<Item>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ItemPageBuilder() {
    ItemPage._defaults(this);
  }

  ItemPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemPage other) {
    _$v = other as _$ItemPage;
  }

  @override
  void update(void Function(ItemPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemPage build() => _build();

  _$ItemPage _build() {
    _$ItemPage _$result;
    try {
      _$result = _$v ??
          _$ItemPage._(
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
            r'ItemPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
