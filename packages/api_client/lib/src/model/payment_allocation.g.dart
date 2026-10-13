// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_allocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentAllocation extends PaymentAllocation {
  @override
  final int id;
  @override
  final int paymentVoucherId;
  @override
  final int? purchaseBillId;
  @override
  final int? expenseVoucherId;
  @override
  final String amount;

  factory _$PaymentAllocation(
          [void Function(PaymentAllocationBuilder)? updates]) =>
      (PaymentAllocationBuilder()..update(updates))._build();

  _$PaymentAllocation._(
      {required this.id,
      required this.paymentVoucherId,
      this.purchaseBillId,
      this.expenseVoucherId,
      required this.amount})
      : super._();
  @override
  PaymentAllocation rebuild(void Function(PaymentAllocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentAllocationBuilder toBuilder() =>
      PaymentAllocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentAllocation &&
        id == other.id &&
        paymentVoucherId == other.paymentVoucherId &&
        purchaseBillId == other.purchaseBillId &&
        expenseVoucherId == other.expenseVoucherId &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, paymentVoucherId.hashCode);
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, expenseVoucherId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentAllocation')
          ..add('id', id)
          ..add('paymentVoucherId', paymentVoucherId)
          ..add('purchaseBillId', purchaseBillId)
          ..add('expenseVoucherId', expenseVoucherId)
          ..add('amount', amount))
        .toString();
  }
}

class PaymentAllocationBuilder
    implements Builder<PaymentAllocation, PaymentAllocationBuilder> {
  _$PaymentAllocation? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _paymentVoucherId;
  int? get paymentVoucherId => _$this._paymentVoucherId;
  set paymentVoucherId(int? paymentVoucherId) =>
      _$this._paymentVoucherId = paymentVoucherId;

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

  PaymentAllocationBuilder() {
    PaymentAllocation._defaults(this);
  }

  PaymentAllocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _paymentVoucherId = $v.paymentVoucherId;
      _purchaseBillId = $v.purchaseBillId;
      _expenseVoucherId = $v.expenseVoucherId;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentAllocation other) {
    _$v = other as _$PaymentAllocation;
  }

  @override
  void update(void Function(PaymentAllocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentAllocation build() => _build();

  _$PaymentAllocation _build() {
    final _$result = _$v ??
        _$PaymentAllocation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentAllocation', 'id'),
          paymentVoucherId: BuiltValueNullFieldError.checkNotNull(
              paymentVoucherId, r'PaymentAllocation', 'paymentVoucherId'),
          purchaseBillId: purchaseBillId,
          expenseVoucherId: expenseVoucherId,
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentAllocation', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
