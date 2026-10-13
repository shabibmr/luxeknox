// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Item extends Item {
  @override
  final int id;
  @override
  final String name;
  @override
  final ItemKind itemKind;
  @override
  final bool inventoryTracked;
  @override
  final int incomeAccountId;
  @override
  final int expenseAccountId;
  @override
  final int? taxCodeId;
  @override
  final bool isActive;

  factory _$Item([void Function(ItemBuilder)? updates]) =>
      (ItemBuilder()..update(updates))._build();

  _$Item._(
      {required this.id,
      required this.name,
      required this.itemKind,
      required this.inventoryTracked,
      required this.incomeAccountId,
      required this.expenseAccountId,
      this.taxCodeId,
      required this.isActive})
      : super._();
  @override
  Item rebuild(void Function(ItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemBuilder toBuilder() => ItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Item &&
        id == other.id &&
        name == other.name &&
        itemKind == other.itemKind &&
        inventoryTracked == other.inventoryTracked &&
        incomeAccountId == other.incomeAccountId &&
        expenseAccountId == other.expenseAccountId &&
        taxCodeId == other.taxCodeId &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, itemKind.hashCode);
    _$hash = $jc(_$hash, inventoryTracked.hashCode);
    _$hash = $jc(_$hash, incomeAccountId.hashCode);
    _$hash = $jc(_$hash, expenseAccountId.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Item')
          ..add('id', id)
          ..add('name', name)
          ..add('itemKind', itemKind)
          ..add('inventoryTracked', inventoryTracked)
          ..add('incomeAccountId', incomeAccountId)
          ..add('expenseAccountId', expenseAccountId)
          ..add('taxCodeId', taxCodeId)
          ..add('isActive', isActive))
        .toString();
  }
}

class ItemBuilder implements Builder<Item, ItemBuilder> {
  _$Item? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ItemKind? _itemKind;
  ItemKind? get itemKind => _$this._itemKind;
  set itemKind(ItemKind? itemKind) => _$this._itemKind = itemKind;

  bool? _inventoryTracked;
  bool? get inventoryTracked => _$this._inventoryTracked;
  set inventoryTracked(bool? inventoryTracked) =>
      _$this._inventoryTracked = inventoryTracked;

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

  ItemBuilder() {
    Item._defaults(this);
  }

  ItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _itemKind = $v.itemKind;
      _inventoryTracked = $v.inventoryTracked;
      _incomeAccountId = $v.incomeAccountId;
      _expenseAccountId = $v.expenseAccountId;
      _taxCodeId = $v.taxCodeId;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Item other) {
    _$v = other as _$Item;
  }

  @override
  void update(void Function(ItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Item build() => _build();

  _$Item _build() {
    final _$result = _$v ??
        _$Item._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Item', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Item', 'name'),
          itemKind: BuiltValueNullFieldError.checkNotNull(
              itemKind, r'Item', 'itemKind'),
          inventoryTracked: BuiltValueNullFieldError.checkNotNull(
              inventoryTracked, r'Item', 'inventoryTracked'),
          incomeAccountId: BuiltValueNullFieldError.checkNotNull(
              incomeAccountId, r'Item', 'incomeAccountId'),
          expenseAccountId: BuiltValueNullFieldError.checkNotNull(
              expenseAccountId, r'Item', 'expenseAccountId'),
          taxCodeId: taxCodeId,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'Item', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
