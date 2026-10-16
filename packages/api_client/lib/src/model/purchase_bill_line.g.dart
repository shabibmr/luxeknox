// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBillLine extends PurchaseBillLine {
  @override
  final int id;
  @override
  final int purchaseBillId;
  @override
  final int? itemId;
  @override
  final String itemName;
  @override
  final String uomCode;
  @override
  final bool inventoryTracked;
  @override
  final String returnedQuantity;
  @override
  final int accountId;
  @override
  final String? description;
  @override
  final String quantity;
  @override
  final String rate;
  @override
  final int? taxCodeId;
  @override
  final String netAmount;
  @override
  final String taxAmount;

  factory _$PurchaseBillLine(
          [void Function(PurchaseBillLineBuilder)? updates]) =>
      (PurchaseBillLineBuilder()..update(updates))._build();

  _$PurchaseBillLine._(
      {required this.id,
      required this.purchaseBillId,
      this.itemId,
      required this.itemName,
      required this.uomCode,
      required this.inventoryTracked,
      required this.returnedQuantity,
      required this.accountId,
      this.description,
      required this.quantity,
      required this.rate,
      this.taxCodeId,
      required this.netAmount,
      required this.taxAmount})
      : super._();
  @override
  PurchaseBillLine rebuild(void Function(PurchaseBillLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillLineBuilder toBuilder() =>
      PurchaseBillLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBillLine &&
        id == other.id &&
        purchaseBillId == other.purchaseBillId &&
        itemId == other.itemId &&
        itemName == other.itemName &&
        uomCode == other.uomCode &&
        inventoryTracked == other.inventoryTracked &&
        returnedQuantity == other.returnedQuantity &&
        accountId == other.accountId &&
        description == other.description &&
        quantity == other.quantity &&
        rate == other.rate &&
        taxCodeId == other.taxCodeId &&
        netAmount == other.netAmount &&
        taxAmount == other.taxAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, itemName.hashCode);
    _$hash = $jc(_$hash, uomCode.hashCode);
    _$hash = $jc(_$hash, inventoryTracked.hashCode);
    _$hash = $jc(_$hash, returnedQuantity.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, rate.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, netAmount.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PurchaseBillLine')
          ..add('id', id)
          ..add('purchaseBillId', purchaseBillId)
          ..add('itemId', itemId)
          ..add('itemName', itemName)
          ..add('uomCode', uomCode)
          ..add('inventoryTracked', inventoryTracked)
          ..add('returnedQuantity', returnedQuantity)
          ..add('accountId', accountId)
          ..add('description', description)
          ..add('quantity', quantity)
          ..add('rate', rate)
          ..add('taxCodeId', taxCodeId)
          ..add('netAmount', netAmount)
          ..add('taxAmount', taxAmount))
        .toString();
  }
}

class PurchaseBillLineBuilder
    implements Builder<PurchaseBillLine, PurchaseBillLineBuilder> {
  _$PurchaseBillLine? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _purchaseBillId;
  int? get purchaseBillId => _$this._purchaseBillId;
  set purchaseBillId(int? purchaseBillId) =>
      _$this._purchaseBillId = purchaseBillId;

  int? _itemId;
  int? get itemId => _$this._itemId;
  set itemId(int? itemId) => _$this._itemId = itemId;

  String? _itemName;
  String? get itemName => _$this._itemName;
  set itemName(String? itemName) => _$this._itemName = itemName;

  String? _uomCode;
  String? get uomCode => _$this._uomCode;
  set uomCode(String? uomCode) => _$this._uomCode = uomCode;

  bool? _inventoryTracked;
  bool? get inventoryTracked => _$this._inventoryTracked;
  set inventoryTracked(bool? inventoryTracked) =>
      _$this._inventoryTracked = inventoryTracked;

  String? _returnedQuantity;
  String? get returnedQuantity => _$this._returnedQuantity;
  set returnedQuantity(String? returnedQuantity) =>
      _$this._returnedQuantity = returnedQuantity;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  String? _rate;
  String? get rate => _$this._rate;
  set rate(String? rate) => _$this._rate = rate;

  int? _taxCodeId;
  int? get taxCodeId => _$this._taxCodeId;
  set taxCodeId(int? taxCodeId) => _$this._taxCodeId = taxCodeId;

  String? _netAmount;
  String? get netAmount => _$this._netAmount;
  set netAmount(String? netAmount) => _$this._netAmount = netAmount;

  String? _taxAmount;
  String? get taxAmount => _$this._taxAmount;
  set taxAmount(String? taxAmount) => _$this._taxAmount = taxAmount;

  PurchaseBillLineBuilder() {
    PurchaseBillLine._defaults(this);
  }

  PurchaseBillLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _purchaseBillId = $v.purchaseBillId;
      _itemId = $v.itemId;
      _itemName = $v.itemName;
      _uomCode = $v.uomCode;
      _inventoryTracked = $v.inventoryTracked;
      _returnedQuantity = $v.returnedQuantity;
      _accountId = $v.accountId;
      _description = $v.description;
      _quantity = $v.quantity;
      _rate = $v.rate;
      _taxCodeId = $v.taxCodeId;
      _netAmount = $v.netAmount;
      _taxAmount = $v.taxAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBillLine other) {
    _$v = other as _$PurchaseBillLine;
  }

  @override
  void update(void Function(PurchaseBillLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBillLine build() => _build();

  _$PurchaseBillLine _build() {
    final _$result = _$v ??
        _$PurchaseBillLine._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PurchaseBillLine', 'id'),
          purchaseBillId: BuiltValueNullFieldError.checkNotNull(
              purchaseBillId, r'PurchaseBillLine', 'purchaseBillId'),
          itemId: itemId,
          itemName: BuiltValueNullFieldError.checkNotNull(
              itemName, r'PurchaseBillLine', 'itemName'),
          uomCode: BuiltValueNullFieldError.checkNotNull(
              uomCode, r'PurchaseBillLine', 'uomCode'),
          inventoryTracked: BuiltValueNullFieldError.checkNotNull(
              inventoryTracked, r'PurchaseBillLine', 'inventoryTracked'),
          returnedQuantity: BuiltValueNullFieldError.checkNotNull(
              returnedQuantity, r'PurchaseBillLine', 'returnedQuantity'),
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'PurchaseBillLine', 'accountId'),
          description: description,
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'PurchaseBillLine', 'quantity'),
          rate: BuiltValueNullFieldError.checkNotNull(
              rate, r'PurchaseBillLine', 'rate'),
          taxCodeId: taxCodeId,
          netAmount: BuiltValueNullFieldError.checkNotNull(
              netAmount, r'PurchaseBillLine', 'netAmount'),
          taxAmount: BuiltValueNullFieldError.checkNotNull(
              taxAmount, r'PurchaseBillLine', 'taxAmount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
