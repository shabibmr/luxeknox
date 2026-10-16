// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryItem extends InventoryItem {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? sku;
  @override
  final String? hsnSac;
  @override
  final ItemKind itemKind;
  @override
  final int? categoryId;
  @override
  final String? categoryName;
  @override
  final int uomId;
  @override
  final String uomCode;
  @override
  final int uomDecimalPlaces;
  @override
  final String? saleRate;
  @override
  final String? purchaseRate;
  @override
  final String? reorderLevel;
  @override
  final int? taxCodeId;
  @override
  final int incomeAccountId;
  @override
  final int expenseAccountId;
  @override
  final int? inventoryAccountId;
  @override
  final int? cogsAccountId;
  @override
  final bool inventoryTracked;
  @override
  final bool hasMovements;
  @override
  final bool isActive;
  @override
  final int rowVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$InventoryItem([void Function(InventoryItemBuilder)? updates]) =>
      (InventoryItemBuilder()..update(updates))._build();

  _$InventoryItem._(
      {required this.id,
      required this.name,
      this.sku,
      this.hsnSac,
      required this.itemKind,
      this.categoryId,
      this.categoryName,
      required this.uomId,
      required this.uomCode,
      required this.uomDecimalPlaces,
      this.saleRate,
      this.purchaseRate,
      this.reorderLevel,
      this.taxCodeId,
      required this.incomeAccountId,
      required this.expenseAccountId,
      this.inventoryAccountId,
      this.cogsAccountId,
      required this.inventoryTracked,
      required this.hasMovements,
      required this.isActive,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  InventoryItem rebuild(void Function(InventoryItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryItemBuilder toBuilder() => InventoryItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryItem &&
        id == other.id &&
        name == other.name &&
        sku == other.sku &&
        hsnSac == other.hsnSac &&
        itemKind == other.itemKind &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        uomId == other.uomId &&
        uomCode == other.uomCode &&
        uomDecimalPlaces == other.uomDecimalPlaces &&
        saleRate == other.saleRate &&
        purchaseRate == other.purchaseRate &&
        reorderLevel == other.reorderLevel &&
        taxCodeId == other.taxCodeId &&
        incomeAccountId == other.incomeAccountId &&
        expenseAccountId == other.expenseAccountId &&
        inventoryAccountId == other.inventoryAccountId &&
        cogsAccountId == other.cogsAccountId &&
        inventoryTracked == other.inventoryTracked &&
        hasMovements == other.hasMovements &&
        isActive == other.isActive &&
        rowVersion == other.rowVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, hsnSac.hashCode);
    _$hash = $jc(_$hash, itemKind.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, uomId.hashCode);
    _$hash = $jc(_$hash, uomCode.hashCode);
    _$hash = $jc(_$hash, uomDecimalPlaces.hashCode);
    _$hash = $jc(_$hash, saleRate.hashCode);
    _$hash = $jc(_$hash, purchaseRate.hashCode);
    _$hash = $jc(_$hash, reorderLevel.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, incomeAccountId.hashCode);
    _$hash = $jc(_$hash, expenseAccountId.hashCode);
    _$hash = $jc(_$hash, inventoryAccountId.hashCode);
    _$hash = $jc(_$hash, cogsAccountId.hashCode);
    _$hash = $jc(_$hash, inventoryTracked.hashCode);
    _$hash = $jc(_$hash, hasMovements.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryItem')
          ..add('id', id)
          ..add('name', name)
          ..add('sku', sku)
          ..add('hsnSac', hsnSac)
          ..add('itemKind', itemKind)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('uomId', uomId)
          ..add('uomCode', uomCode)
          ..add('uomDecimalPlaces', uomDecimalPlaces)
          ..add('saleRate', saleRate)
          ..add('purchaseRate', purchaseRate)
          ..add('reorderLevel', reorderLevel)
          ..add('taxCodeId', taxCodeId)
          ..add('incomeAccountId', incomeAccountId)
          ..add('expenseAccountId', expenseAccountId)
          ..add('inventoryAccountId', inventoryAccountId)
          ..add('cogsAccountId', cogsAccountId)
          ..add('inventoryTracked', inventoryTracked)
          ..add('hasMovements', hasMovements)
          ..add('isActive', isActive)
          ..add('rowVersion', rowVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class InventoryItemBuilder
    implements Builder<InventoryItem, InventoryItemBuilder> {
  _$InventoryItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _hsnSac;
  String? get hsnSac => _$this._hsnSac;
  set hsnSac(String? hsnSac) => _$this._hsnSac = hsnSac;

  ItemKind? _itemKind;
  ItemKind? get itemKind => _$this._itemKind;
  set itemKind(ItemKind? itemKind) => _$this._itemKind = itemKind;

  int? _categoryId;
  int? get categoryId => _$this._categoryId;
  set categoryId(int? categoryId) => _$this._categoryId = categoryId;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  int? _uomId;
  int? get uomId => _$this._uomId;
  set uomId(int? uomId) => _$this._uomId = uomId;

  String? _uomCode;
  String? get uomCode => _$this._uomCode;
  set uomCode(String? uomCode) => _$this._uomCode = uomCode;

  int? _uomDecimalPlaces;
  int? get uomDecimalPlaces => _$this._uomDecimalPlaces;
  set uomDecimalPlaces(int? uomDecimalPlaces) =>
      _$this._uomDecimalPlaces = uomDecimalPlaces;

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

  int? _incomeAccountId;
  int? get incomeAccountId => _$this._incomeAccountId;
  set incomeAccountId(int? incomeAccountId) =>
      _$this._incomeAccountId = incomeAccountId;

  int? _expenseAccountId;
  int? get expenseAccountId => _$this._expenseAccountId;
  set expenseAccountId(int? expenseAccountId) =>
      _$this._expenseAccountId = expenseAccountId;

  int? _inventoryAccountId;
  int? get inventoryAccountId => _$this._inventoryAccountId;
  set inventoryAccountId(int? inventoryAccountId) =>
      _$this._inventoryAccountId = inventoryAccountId;

  int? _cogsAccountId;
  int? get cogsAccountId => _$this._cogsAccountId;
  set cogsAccountId(int? cogsAccountId) =>
      _$this._cogsAccountId = cogsAccountId;

  bool? _inventoryTracked;
  bool? get inventoryTracked => _$this._inventoryTracked;
  set inventoryTracked(bool? inventoryTracked) =>
      _$this._inventoryTracked = inventoryTracked;

  bool? _hasMovements;
  bool? get hasMovements => _$this._hasMovements;
  set hasMovements(bool? hasMovements) => _$this._hasMovements = hasMovements;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  InventoryItemBuilder() {
    InventoryItem._defaults(this);
  }

  InventoryItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _sku = $v.sku;
      _hsnSac = $v.hsnSac;
      _itemKind = $v.itemKind;
      _categoryId = $v.categoryId;
      _categoryName = $v.categoryName;
      _uomId = $v.uomId;
      _uomCode = $v.uomCode;
      _uomDecimalPlaces = $v.uomDecimalPlaces;
      _saleRate = $v.saleRate;
      _purchaseRate = $v.purchaseRate;
      _reorderLevel = $v.reorderLevel;
      _taxCodeId = $v.taxCodeId;
      _incomeAccountId = $v.incomeAccountId;
      _expenseAccountId = $v.expenseAccountId;
      _inventoryAccountId = $v.inventoryAccountId;
      _cogsAccountId = $v.cogsAccountId;
      _inventoryTracked = $v.inventoryTracked;
      _hasMovements = $v.hasMovements;
      _isActive = $v.isActive;
      _rowVersion = $v.rowVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryItem other) {
    _$v = other as _$InventoryItem;
  }

  @override
  void update(void Function(InventoryItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryItem build() => _build();

  _$InventoryItem _build() {
    final _$result = _$v ??
        _$InventoryItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'InventoryItem', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'InventoryItem', 'name'),
          sku: sku,
          hsnSac: hsnSac,
          itemKind: BuiltValueNullFieldError.checkNotNull(
              itemKind, r'InventoryItem', 'itemKind'),
          categoryId: categoryId,
          categoryName: categoryName,
          uomId: BuiltValueNullFieldError.checkNotNull(
              uomId, r'InventoryItem', 'uomId'),
          uomCode: BuiltValueNullFieldError.checkNotNull(
              uomCode, r'InventoryItem', 'uomCode'),
          uomDecimalPlaces: BuiltValueNullFieldError.checkNotNull(
              uomDecimalPlaces, r'InventoryItem', 'uomDecimalPlaces'),
          saleRate: saleRate,
          purchaseRate: purchaseRate,
          reorderLevel: reorderLevel,
          taxCodeId: taxCodeId,
          incomeAccountId: BuiltValueNullFieldError.checkNotNull(
              incomeAccountId, r'InventoryItem', 'incomeAccountId'),
          expenseAccountId: BuiltValueNullFieldError.checkNotNull(
              expenseAccountId, r'InventoryItem', 'expenseAccountId'),
          inventoryAccountId: inventoryAccountId,
          cogsAccountId: cogsAccountId,
          inventoryTracked: BuiltValueNullFieldError.checkNotNull(
              inventoryTracked, r'InventoryItem', 'inventoryTracked'),
          hasMovements: BuiltValueNullFieldError.checkNotNull(
              hasMovements, r'InventoryItem', 'hasMovements'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'InventoryItem', 'isActive'),
          rowVersion: BuiltValueNullFieldError.checkNotNull(
              rowVersion, r'InventoryItem', 'rowVersion'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'InventoryItem', 'createdAt'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
