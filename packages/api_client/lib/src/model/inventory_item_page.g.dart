// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryItemPage extends InventoryItemPage {
  @override
  final BuiltList<InventoryItem> data;
  @override
  final PageMeta meta;

  factory _$InventoryItemPage(
          [void Function(InventoryItemPageBuilder)? updates]) =>
      (InventoryItemPageBuilder()..update(updates))._build();

  _$InventoryItemPage._({required this.data, required this.meta}) : super._();
  @override
  InventoryItemPage rebuild(void Function(InventoryItemPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryItemPageBuilder toBuilder() =>
      InventoryItemPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryItemPage &&
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
    return (newBuiltValueToStringHelper(r'InventoryItemPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class InventoryItemPageBuilder
    implements Builder<InventoryItemPage, InventoryItemPageBuilder> {
  _$InventoryItemPage? _$v;

  ListBuilder<InventoryItem>? _data;
  ListBuilder<InventoryItem> get data =>
      _$this._data ??= ListBuilder<InventoryItem>();
  set data(ListBuilder<InventoryItem>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  InventoryItemPageBuilder() {
    InventoryItemPage._defaults(this);
  }

  InventoryItemPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryItemPage other) {
    _$v = other as _$InventoryItemPage;
  }

  @override
  void update(void Function(InventoryItemPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryItemPage build() => _build();

  _$InventoryItemPage _build() {
    _$InventoryItemPage _$result;
    try {
      _$result = _$v ??
          _$InventoryItemPage._(
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
            r'InventoryItemPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
