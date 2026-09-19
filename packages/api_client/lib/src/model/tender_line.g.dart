// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tender_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TenderLine extends TenderLine {
  @override
  final int paymentMethodId;
  @override
  final String amount;
  @override
  final String? transactionReference;

  factory _$TenderLine([void Function(TenderLineBuilder)? updates]) =>
      (TenderLineBuilder()..update(updates))._build();

  _$TenderLine._(
      {required this.paymentMethodId,
      required this.amount,
      this.transactionReference})
      : super._();
  @override
  TenderLine rebuild(void Function(TenderLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TenderLineBuilder toBuilder() => TenderLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TenderLine &&
        paymentMethodId == other.paymentMethodId &&
        amount == other.amount &&
        transactionReference == other.transactionReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TenderLine')
          ..add('paymentMethodId', paymentMethodId)
          ..add('amount', amount)
          ..add('transactionReference', transactionReference))
        .toString();
  }
}

class TenderLineBuilder implements Builder<TenderLine, TenderLineBuilder> {
  _$TenderLine? _$v;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  TenderLineBuilder() {
    TenderLine._defaults(this);
  }

  TenderLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentMethodId = $v.paymentMethodId;
      _amount = $v.amount;
      _transactionReference = $v.transactionReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TenderLine other) {
    _$v = other as _$TenderLine;
  }

  @override
  void update(void Function(TenderLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TenderLine build() => _build();

  _$TenderLine _build() {
    final _$result = _$v ??
        _$TenderLine._(
          paymentMethodId: BuiltValueNullFieldError.checkNotNull(
              paymentMethodId, r'TenderLine', 'paymentMethodId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'TenderLine', 'amount'),
          transactionReference: transactionReference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
