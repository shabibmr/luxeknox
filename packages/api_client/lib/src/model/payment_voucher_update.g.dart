// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_voucher_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentVoucherUpdate extends PaymentVoucherUpdate {
  @override
  final Date? paymentDate;
  @override
  final int? bankAccountId;
  @override
  final String? totalAmount;
  @override
  final String? memo;
  @override
  final BuiltList<PaymentAllocationWrite>? allocations;

  factory _$PaymentVoucherUpdate(
          [void Function(PaymentVoucherUpdateBuilder)? updates]) =>
      (PaymentVoucherUpdateBuilder()..update(updates))._build();

  _$PaymentVoucherUpdate._(
      {this.paymentDate,
      this.bankAccountId,
      this.totalAmount,
      this.memo,
      this.allocations})
      : super._();
  @override
  PaymentVoucherUpdate rebuild(
          void Function(PaymentVoucherUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentVoucherUpdateBuilder toBuilder() =>
      PaymentVoucherUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentVoucherUpdate &&
        paymentDate == other.paymentDate &&
        bankAccountId == other.bankAccountId &&
        totalAmount == other.totalAmount &&
        memo == other.memo &&
        allocations == other.allocations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentDate.hashCode);
    _$hash = $jc(_$hash, bankAccountId.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, allocations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentVoucherUpdate')
          ..add('paymentDate', paymentDate)
          ..add('bankAccountId', bankAccountId)
          ..add('totalAmount', totalAmount)
          ..add('memo', memo)
          ..add('allocations', allocations))
        .toString();
  }
}

class PaymentVoucherUpdateBuilder
    implements Builder<PaymentVoucherUpdate, PaymentVoucherUpdateBuilder> {
  _$PaymentVoucherUpdate? _$v;

  Date? _paymentDate;
  Date? get paymentDate => _$this._paymentDate;
  set paymentDate(Date? paymentDate) => _$this._paymentDate = paymentDate;

  int? _bankAccountId;
  int? get bankAccountId => _$this._bankAccountId;
  set bankAccountId(int? bankAccountId) =>
      _$this._bankAccountId = bankAccountId;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  ListBuilder<PaymentAllocationWrite>? _allocations;
  ListBuilder<PaymentAllocationWrite> get allocations =>
      _$this._allocations ??= ListBuilder<PaymentAllocationWrite>();
  set allocations(ListBuilder<PaymentAllocationWrite>? allocations) =>
      _$this._allocations = allocations;

  PaymentVoucherUpdateBuilder() {
    PaymentVoucherUpdate._defaults(this);
  }

  PaymentVoucherUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentDate = $v.paymentDate;
      _bankAccountId = $v.bankAccountId;
      _totalAmount = $v.totalAmount;
      _memo = $v.memo;
      _allocations = $v.allocations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentVoucherUpdate other) {
    _$v = other as _$PaymentVoucherUpdate;
  }

  @override
  void update(void Function(PaymentVoucherUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentVoucherUpdate build() => _build();

  _$PaymentVoucherUpdate _build() {
    _$PaymentVoucherUpdate _$result;
    try {
      _$result = _$v ??
          _$PaymentVoucherUpdate._(
            paymentDate: paymentDate,
            bankAccountId: bankAccountId,
            totalAmount: totalAmount,
            memo: memo,
            allocations: _allocations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allocations';
        _allocations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentVoucherUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
