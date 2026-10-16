// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_category_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemCategoryPage extends ItemCategoryPage {
  @override
  final BuiltList<ItemCategory> data;
  @override
  final PageMeta meta;

  factory _$ItemCategoryPage(
          [void Function(ItemCategoryPageBuilder)? updates]) =>
      (ItemCategoryPageBuilder()..update(updates))._build();

  _$ItemCategoryPage._({required this.data, required this.meta}) : super._();
  @override
  ItemCategoryPage rebuild(void Function(ItemCategoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemCategoryPageBuilder toBuilder() =>
      ItemCategoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemCategoryPage &&
        data == other.data &&
        meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'ItemCategoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ItemCategoryPageBuilder
    implements Builder<ItemCategoryPage, ItemCategoryPageBuilder> {
  _$ItemCategoryPage? _$v;

  ListBuilder<ItemCategory>? _data;
  ListBuilder<ItemCategory> get data =>
      _$this._data ??= ListBuilder<ItemCategory>();
  set data(ListBuilder<ItemCategory>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ItemCategoryPageBuilder() {
    ItemCategoryPage._defaults(this);
  }

  ItemCategoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemCategoryPage other) {
    _$v = other as _$ItemCategoryPage;
  }

  @override
  void update(void Function(ItemCategoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemCategoryPage build() => _build();

  _$ItemCategoryPage _build() {
    _$ItemCategoryPage _$result;
    try {
      _$result = _$v ??
          _$ItemCategoryPage._(
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
            r'ItemCategoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
