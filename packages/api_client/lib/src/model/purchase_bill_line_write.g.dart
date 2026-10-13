// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_line_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBillLineWrite extends PurchaseBillLineWrite {
  @override
  final int? itemId;
  @override
  final int accountId;
  @override
  final String? description;
  @override
  final String? quantity;
  @override
  final String rate;
  @override
  final int? taxCodeId;

  factory _$PurchaseBillLineWrite(
          [void Function(PurchaseBillLineWriteBuilder)? updates]) =>
      (PurchaseBillLineWriteBuilder()..update(updates))._build();

  _$PurchaseBillLineWrite._(
      {this.itemId,
      required this.accountId,
      this.description,
      this.quantity,
      required this.rate,
      this.taxCodeId})
      : super._();
  @override
  PurchaseBillLineWrite rebuild(
          void Function(PurchaseBillLineWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillLineWriteBuilder toBuilder() =>
      PurchaseBillLineWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBillLineWrite &&
        itemId == other.itemId &&
        accountId == other.accountId &&
        description == other.description &&
        quantity == other.quantity &&
        rate == other.rate &&
        taxCodeId == other.taxCodeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, rate.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PurchaseBillLineWrite')
          ..add('itemId', itemId)
          ..add('accountId', accountId)
          ..add('description', description)
          ..add('quantity', quantity)
          ..add('rate', rate)
          ..add('taxCodeId', taxCodeId))
        .toString();
  }
}

class PurchaseBillLineWriteBuilder
    implements Builder<PurchaseBillLineWrite, PurchaseBillLineWriteBuilder> {
  _$PurchaseBillLineWrite? _$v;

  int? _itemId;
  int? get itemId => _$this._itemId;
  set itemId(int? itemId) => _$this._itemId = itemId;

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

  PurchaseBillLineWriteBuilder() {
    PurchaseBillLineWrite._defaults(this);
  }

  PurchaseBillLineWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _accountId = $v.accountId;
      _description = $v.description;
      _quantity = $v.quantity;
      _rate = $v.rate;
      _taxCodeId = $v.taxCodeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBillLineWrite other) {
    _$v = other as _$PurchaseBillLineWrite;
  }

  @override
  void update(void Function(PurchaseBillLineWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBillLineWrite build() => _build();

  _$PurchaseBillLineWrite _build() {
    final _$result = _$v ??
        _$PurchaseBillLineWrite._(
          itemId: itemId,
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'PurchaseBillLineWrite', 'accountId'),
          description: description,
          quantity: quantity,
          rate: BuiltValueNullFieldError.checkNotNull(
              rate, r'PurchaseBillLineWrite', 'rate'),
          taxCodeId: taxCodeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
