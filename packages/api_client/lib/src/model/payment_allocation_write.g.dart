// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_allocation_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentAllocationWrite extends PaymentAllocationWrite {
  @override
  final int? purchaseBillId;
  @override
  final int? expenseVoucherId;
  @override
  final String amount;

  factory _$PaymentAllocationWrite(
          [void Function(PaymentAllocationWriteBuilder)? updates]) =>
      (PaymentAllocationWriteBuilder()..update(updates))._build();

  _$PaymentAllocationWrite._(
      {this.purchaseBillId, this.expenseVoucherId, required this.amount})
      : super._();
  @override
  PaymentAllocationWrite rebuild(
          void Function(PaymentAllocationWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentAllocationWriteBuilder toBuilder() =>
      PaymentAllocationWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentAllocationWrite &&
        purchaseBillId == other.purchaseBillId &&
        expenseVoucherId == other.expenseVoucherId &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, expenseVoucherId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentAllocationWrite')
          ..add('purchaseBillId', purchaseBillId)
          ..add('expenseVoucherId', expenseVoucherId)
          ..add('amount', amount))
        .toString();
  }
}

class PaymentAllocationWriteBuilder
    implements Builder<PaymentAllocationWrite, PaymentAllocationWriteBuilder> {
  _$PaymentAllocationWrite? _$v;

  int? _purchaseBillId;
  int? get purchaseBillId => _$this._purchaseBillId;
  set purchaseBillId(int? purchaseBillId) =>
      _$this._purchaseBillId = purchaseBillId;

  int? _expenseVoucherId;
  int? get expenseVoucherId => _$this._expenseVoucherId;
  set expenseVoucherId(int? expenseVoucherId) =>
      _$this._expenseVoucherId = expenseVoucherId;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  PaymentAllocationWriteBuilder() {
    PaymentAllocationWrite._defaults(this);
  }

  PaymentAllocationWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purchaseBillId = $v.purchaseBillId;
      _expenseVoucherId = $v.expenseVoucherId;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentAllocationWrite other) {
    _$v = other as _$PaymentAllocationWrite;
  }

  @override
  void update(void Function(PaymentAllocationWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentAllocationWrite build() => _build();

  _$PaymentAllocationWrite _build() {
    final _$result = _$v ??
        _$PaymentAllocationWrite._(
          purchaseBillId: purchaseBillId,
          expenseVoucherId: expenseVoucherId,
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentAllocationWrite', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
