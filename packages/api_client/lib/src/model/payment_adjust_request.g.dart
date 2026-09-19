// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_adjust_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentAdjustRequest extends PaymentAdjustRequest {
  @override
  final String amount;
  @override
  final int? paymentMethodId;
  @override
  final String? notes;
  @override
  final int? rowVersion;

  factory _$PaymentAdjustRequest(
          [void Function(PaymentAdjustRequestBuilder)? updates]) =>
      (PaymentAdjustRequestBuilder()..update(updates))._build();

  _$PaymentAdjustRequest._(
      {required this.amount, this.paymentMethodId, this.notes, this.rowVersion})
      : super._();
  @override
  PaymentAdjustRequest rebuild(
          void Function(PaymentAdjustRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentAdjustRequestBuilder toBuilder() =>
      PaymentAdjustRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentAdjustRequest &&
        amount == other.amount &&
        paymentMethodId == other.paymentMethodId &&
        notes == other.notes &&
        rowVersion == other.rowVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentAdjustRequest')
          ..add('amount', amount)
          ..add('paymentMethodId', paymentMethodId)
          ..add('notes', notes)
          ..add('rowVersion', rowVersion))
        .toString();
  }
}

class PaymentAdjustRequestBuilder
    implements Builder<PaymentAdjustRequest, PaymentAdjustRequestBuilder> {
  _$PaymentAdjustRequest? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  PaymentAdjustRequestBuilder() {
    PaymentAdjustRequest._defaults(this);
  }

  PaymentAdjustRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _paymentMethodId = $v.paymentMethodId;
      _notes = $v.notes;
      _rowVersion = $v.rowVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentAdjustRequest other) {
    _$v = other as _$PaymentAdjustRequest;
  }

  @override
  void update(void Function(PaymentAdjustRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentAdjustRequest build() => _build();

  _$PaymentAdjustRequest _build() {
    final _$result = _$v ??
        _$PaymentAdjustRequest._(
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentAdjustRequest', 'amount'),
          paymentMethodId: paymentMethodId,
          notes: notes,
          rowVersion: rowVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
