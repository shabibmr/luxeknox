// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemCreate extends ItemCreate {
  @override
  final String name;
  @override
  final ItemKind itemKind;
  @override
  final int incomeAccountId;
  @override
  final int expenseAccountId;
  @override
  final int? taxCodeId;
  @override
  final bool? isActive;
  @override
  final bool? inventoryTracked;

  factory _$ItemCreate([void Function(ItemCreateBuilder)? updates]) =>
      (ItemCreateBuilder()..update(updates))._build();

  _$ItemCreate._(
      {required this.name,
      required this.itemKind,
      required this.incomeAccountId,
      required this.expenseAccountId,
      this.taxCodeId,
      this.isActive,
      this.inventoryTracked})
      : super._();
  @override
  ItemCreate rebuild(void Function(ItemCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemCreateBuilder toBuilder() => ItemCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemCreate &&
        name == other.name &&
        itemKind == other.itemKind &&
        incomeAccountId == other.incomeAccountId &&
        expenseAccountId == other.expenseAccountId &&
        taxCodeId == other.taxCodeId &&
        isActive == other.isActive &&
        inventoryTracked == other.inventoryTracked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, itemKind.hashCode);
    _$hash = $jc(_$hash, incomeAccountId.hashCode);
    _$hash = $jc(_$hash, expenseAccountId.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, inventoryTracked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemCreate')
          ..add('name', name)
          ..add('itemKind', itemKind)
          ..add('incomeAccountId', incomeAccountId)
          ..add('expenseAccountId', expenseAccountId)
          ..add('taxCodeId', taxCodeId)
          ..add('isActive', isActive)
          ..add('inventoryTracked', inventoryTracked))
        .toString();
  }
}

class ItemCreateBuilder implements Builder<ItemCreate, ItemCreateBuilder> {
  _$ItemCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ItemKind? _itemKind;
  ItemKind? get itemKind => _$this._itemKind;
  set itemKind(ItemKind? itemKind) => _$this._itemKind = itemKind;

  int? _incomeAccountId;
  int? get incomeAccountId => _$this._incomeAccountId;
  set incomeAccountId(int? incomeAccountId) =>
      _$this._incomeAccountId = incomeAccountId;

  int? _expenseAccountId;
  int? get expenseAccountId => _$this._expenseAccountId;
  set expenseAccountId(int? expenseAccountId) =>
      _$this._expenseAccountId = expenseAccountId;

  int? _taxCodeId;
  int? get taxCodeId => _$this._taxCodeId;
  set taxCodeId(int? taxCodeId) => _$this._taxCodeId = taxCodeId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _inventoryTracked;
  bool? get inventoryTracked => _$this._inventoryTracked;
  set inventoryTracked(bool? inventoryTracked) =>
      _$this._inventoryTracked = inventoryTracked;

  ItemCreateBuilder() {
    ItemCreate._defaults(this);
  }

  ItemCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _itemKind = $v.itemKind;
      _incomeAccountId = $v.incomeAccountId;
      _expenseAccountId = $v.expenseAccountId;
      _taxCodeId = $v.taxCodeId;
      _isActive = $v.isActive;
      _inventoryTracked = $v.inventoryTracked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemCreate other) {
    _$v = other as _$ItemCreate;
  }

  @override
  void update(void Function(ItemCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemCreate build() => _build();

  _$ItemCreate _build() {
    final _$result = _$v ??
        _$ItemCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ItemCreate', 'name'),
          itemKind: BuiltValueNullFieldError.checkNotNull(
              itemKind, r'ItemCreate', 'itemKind'),
          incomeAccountId: BuiltValueNullFieldError.checkNotNull(
              incomeAccountId, r'ItemCreate', 'incomeAccountId'),
          expenseAccountId: BuiltValueNullFieldError.checkNotNull(
              expenseAccountId, r'ItemCreate', 'expenseAccountId'),
          taxCodeId: taxCodeId,
          isActive: isActive,
          inventoryTracked: inventoryTracked,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
