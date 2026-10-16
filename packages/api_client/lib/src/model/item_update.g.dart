// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemUpdate extends ItemUpdate {
  @override
  final String? name;
  @override
  final int? uomId;
  @override
  final int? incomeAccountId;
  @override
  final int? expenseAccountId;
  @override
  final String? sku;
  @override
  final String? hsnSac;
  @override
  final int? categoryId;
  @override
  final String? saleRate;
  @override
  final String? purchaseRate;
  @override
  final String? reorderLevel;
  @override
  final int? taxCodeId;
  @override
  final bool? isActive;
  @override
  final bool? inventoryTracked;
  @override
  final int? inventoryAccountId;
  @override
  final int? cogsAccountId;

  factory _$ItemUpdate([void Function(ItemUpdateBuilder)? updates]) =>
      (ItemUpdateBuilder()..update(updates))._build();

  _$ItemUpdate._(
      {this.name,
      this.uomId,
      this.incomeAccountId,
      this.expenseAccountId,
      this.sku,
      this.hsnSac,
      this.categoryId,
      this.saleRate,
      this.purchaseRate,
      this.reorderLevel,
      this.taxCodeId,
      this.isActive,
      this.inventoryTracked,
      this.inventoryAccountId,
      this.cogsAccountId})
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
        uomId == other.uomId &&
        incomeAccountId == other.incomeAccountId &&
        expenseAccountId == other.expenseAccountId &&
        sku == other.sku &&
        hsnSac == other.hsnSac &&
        categoryId == other.categoryId &&
        saleRate == other.saleRate &&
        purchaseRate == other.purchaseRate &&
        reorderLevel == other.reorderLevel &&
        taxCodeId == other.taxCodeId &&
        isActive == other.isActive &&
        inventoryTracked == other.inventoryTracked &&
        inventoryAccountId == other.inventoryAccountId &&
        cogsAccountId == other.cogsAccountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, uomId.hashCode);
    _$hash = $jc(_$hash, incomeAccountId.hashCode);
    _$hash = $jc(_$hash, expenseAccountId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, hsnSac.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, saleRate.hashCode);
    _$hash = $jc(_$hash, purchaseRate.hashCode);
    _$hash = $jc(_$hash, reorderLevel.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, inventoryTracked.hashCode);
    _$hash = $jc(_$hash, inventoryAccountId.hashCode);
    _$hash = $jc(_$hash, cogsAccountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemUpdate')
          ..add('name', name)
          ..add('uomId', uomId)
          ..add('incomeAccountId', incomeAccountId)
          ..add('expenseAccountId', expenseAccountId)
          ..add('sku', sku)
          ..add('hsnSac', hsnSac)
          ..add('categoryId', categoryId)
          ..add('saleRate', saleRate)
          ..add('purchaseRate', purchaseRate)
          ..add('reorderLevel', reorderLevel)
          ..add('taxCodeId', taxCodeId)
          ..add('isActive', isActive)
          ..add('inventoryTracked', inventoryTracked)
          ..add('inventoryAccountId', inventoryAccountId)
          ..add('cogsAccountId', cogsAccountId))
        .toString();
  }
}

class ItemUpdateBuilder implements Builder<ItemUpdate, ItemUpdateBuilder> {
  _$ItemUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _uomId;
  int? get uomId => _$this._uomId;
  set uomId(int? uomId) => _$this._uomId = uomId;

  int? _incomeAccountId;
  int? get incomeAccountId => _$this._incomeAccountId;
  set incomeAccountId(int? incomeAccountId) =>
      _$this._incomeAccountId = incomeAccountId;

  int? _expenseAccountId;
  int? get expenseAccountId => _$this._expenseAccountId;
  set expenseAccountId(int? expenseAccountId) =>
      _$this._expenseAccountId = expenseAccountId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _hsnSac;
  String? get hsnSac => _$this._hsnSac;
  set hsnSac(String? hsnSac) => _$this._hsnSac = hsnSac;

  int? _categoryId;
  int? get categoryId => _$this._categoryId;
  set categoryId(int? categoryId) => _$this._categoryId = categoryId;

  String? _saleRate;
  String? get saleRate => _$this._saleRate;
  set saleRate(String? saleRate) => _$this._saleRate = saleRate;

  String? _purchaseRate;
  String? get purchaseRate => _$this._purchaseRate;
  set purchaseRate(String? purchaseRate) => _$this._purchaseRate = purchaseRate;

  String? _reorderLevel;
  String? get reorderLevel => _$this._reorderLevel;
  set reorderLevel(String? reorderLevel) => _$this._reorderLevel = reorderLevel;

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

  int? _inventoryAccountId;
  int? get inventoryAccountId => _$this._inventoryAccountId;
  set inventoryAccountId(int? inventoryAccountId) =>
      _$this._inventoryAccountId = inventoryAccountId;

  int? _cogsAccountId;
  int? get cogsAccountId => _$this._cogsAccountId;
  set cogsAccountId(int? cogsAccountId) =>
      _$this._cogsAccountId = cogsAccountId;

  ItemUpdateBuilder() {
    ItemUpdate._defaults(this);
  }

  ItemUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _uomId = $v.uomId;
      _incomeAccountId = $v.incomeAccountId;
      _expenseAccountId = $v.expenseAccountId;
      _sku = $v.sku;
      _hsnSac = $v.hsnSac;
      _categoryId = $v.categoryId;
      _saleRate = $v.saleRate;
      _purchaseRate = $v.purchaseRate;
      _reorderLevel = $v.reorderLevel;
      _taxCodeId = $v.taxCodeId;
      _isActive = $v.isActive;
      _inventoryTracked = $v.inventoryTracked;
      _inventoryAccountId = $v.inventoryAccountId;
      _cogsAccountId = $v.cogsAccountId;
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
          uomId: uomId,
          incomeAccountId: incomeAccountId,
          expenseAccountId: expenseAccountId,
          sku: sku,
          hsnSac: hsnSac,
          categoryId: categoryId,
          saleRate: saleRate,
          purchaseRate: purchaseRate,
          reorderLevel: reorderLevel,
          taxCodeId: taxCodeId,
          isActive: isActive,
          inventoryTracked: inventoryTracked,
          inventoryAccountId: inventoryAccountId,
          cogsAccountId: cogsAccountId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
