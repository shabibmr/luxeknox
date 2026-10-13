// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemUpdate extends ItemUpdate {
  @override
  final String? name;
  @override
  final int? incomeAccountId;
  @override
  final int? expenseAccountId;
  @override
  final int? taxCodeId;
  @override
  final bool? isActive;
  @override
  final bool? inventoryTracked;

  factory _$ItemUpdate([void Function(ItemUpdateBuilder)? updates]) =>
      (ItemUpdateBuilder()..update(updates))._build();

  _$ItemUpdate._(
      {this.name,
      this.incomeAccountId,
      this.expenseAccountId,
      this.taxCodeId,
      this.isActive,
      this.inventoryTracked})
      : super._();
  @override
  ItemUpdate rebuild(void Function(ItemUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemUpdateBuilder toBuilder() => ItemUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemUpdate &&
        name == other.name &&
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
    return (newBuiltValueToStringHelper(r'ItemUpdate')
          ..add('name', name)
          ..add('incomeAccountId', incomeAccountId)
          ..add('expenseAccountId', expenseAccountId)
          ..add('taxCodeId', taxCodeId)
          ..add('isActive', isActive)
          ..add('inventoryTracked', inventoryTracked))
        .toString();
  }
}

class ItemUpdateBuilder implements Builder<ItemUpdate, ItemUpdateBuilder> {
  _$ItemUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  ItemUpdateBuilder() {
    ItemUpdate._defaults(this);
  }

  ItemUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
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
  void replace(ItemUpdate other) {
    _$v = other as _$ItemUpdate;
  }

  @override
  void update(void Function(ItemUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemUpdate build() => _build();

  _$ItemUpdate _build() {
    final _$result = _$v ??
        _$ItemUpdate._(
          name: name,
          incomeAccountId: incomeAccountId,
          expenseAccountId: expenseAccountId,
          taxCodeId: taxCodeId,
          isActive: isActive,
          inventoryTracked: inventoryTracked,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
