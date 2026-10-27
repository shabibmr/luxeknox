import 'package:equatable/equatable.dart';

/// Item master row as read from `/inventory/items`. Money and quantity
/// values stay decimal strings; parse them only for display and validation.
class Item extends Equatable {
  const Item({
    required this.id,
    required this.name,
    required this.kind,
    required this.uomId,
    required this.uomCode,
    required this.uomDecimalPlaces,
    required this.incomeAccountId,
    required this.expenseAccountId,
    this.sku,
    this.hsnSac,
    this.categoryId,
    this.categoryName,
    this.saleRate,
    this.purchaseRate,
    this.taxCodeId,
    this.taxRatePercent,
    this.inventoryAccountId,
    this.cogsAccountId,
    this.inventoryTracked = false,
    this.qtyOnHand,
    this.reorderLevel,
    this.hasMovements = false,
    this.isActive = true,
    this.rowVersion = 1,
  });

  final int id;
  final String name;

  /// `goods` or `service`.
  final String kind;
  final String? sku;
  final String? hsnSac;
  final int? categoryId;
  final String? categoryName;
  final int uomId;
  final String uomCode;
  final int uomDecimalPlaces;
  final String? saleRate;
  final String? purchaseRate;
  final int? taxCodeId;

  /// Tax code rate percent (2 decimals), null when the item has no tax code.
  final String? taxRatePercent;
  final int incomeAccountId;
  final int expenseAccountId;
  final int? inventoryAccountId;
  final int? cogsAccountId;
  final bool inventoryTracked;

  /// On-hand qty for tracked items (including `"0.000"`); null when untracked.
  final String? qtyOnHand;
  final String? reorderLevel;
  final bool hasMovements;
  final bool isActive;
  final int rowVersion;

  @override
  List<Object?> get props => [
    id,
    name,
    kind,
    sku,
    hsnSac,
    categoryId,
    categoryName,
    uomId,
    uomCode,
    uomDecimalPlaces,
    saleRate,
    purchaseRate,
    taxCodeId,
    taxRatePercent,
    incomeAccountId,
    expenseAccountId,
    inventoryAccountId,
    cogsAccountId,
    inventoryTracked,
    qtyOnHand,
    reorderLevel,
    hasMovements,
    isActive,
    rowVersion,
  ];
}

/// Form values for creating or updating an item. Rates and the reorder
/// level are raw user text; the mapper normalises them for the API.
class ItemDraft extends Equatable {
  const ItemDraft({
    required this.name,
    required this.kind,
    required this.uomId,
    required this.incomeAccountId,
    required this.expenseAccountId,
    this.sku,
    this.hsnSac,
    this.categoryId,
    this.saleRate,
    this.purchaseRate,
    this.taxCodeId,
    this.inventoryAccountId,
    this.cogsAccountId,
    this.inventoryTracked = false,
    this.reorderLevel,
    this.isActive = true,
  });

  final String name;
  final String kind;
  final String? sku;
  final String? hsnSac;
  final int? categoryId;
  final int uomId;
  final String? saleRate;
  final String? purchaseRate;
  final int? taxCodeId;
  final int incomeAccountId;
  final int expenseAccountId;
  final int? inventoryAccountId;
  final int? cogsAccountId;
  final bool inventoryTracked;
  final String? reorderLevel;
  final bool isActive;

  @override
  List<Object?> get props => [
    name,
    kind,
    sku,
    hsnSac,
    categoryId,
    uomId,
    saleRate,
    purchaseRate,
    taxCodeId,
    incomeAccountId,
    expenseAccountId,
    inventoryAccountId,
    cogsAccountId,
    inventoryTracked,
    reorderLevel,
    isActive,
  ];
}

class Uom extends Equatable {
  const Uom({
    required this.id,
    required this.code,
    required this.name,
    required this.decimalPlaces,
    this.isActive = true,
  });

  final int id;
  final String code;
  final String name;
  final int decimalPlaces;
  final bool isActive;

  @override
  List<Object?> get props => [id, code, name, decimalPlaces, isActive];
}

class ItemCategory extends Equatable {
  const ItemCategory({
    required this.id,
    required this.name,
    this.parentId,
    this.isActive = true,
  });

  final int id;
  final String name;
  final int? parentId;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, parentId, isActive];
}
