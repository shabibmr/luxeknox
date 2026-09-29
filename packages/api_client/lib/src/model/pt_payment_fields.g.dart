// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_payment_fields.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class PtPaymentFieldsBuilder {
  void replace(PtPaymentFields other);
  void update(void Function(PtPaymentFieldsBuilder) updates);
  String? get discountAmount;
  set discountAmount(String? discountAmount);

  int? get paymentMethodId;
  set paymentMethodId(int? paymentMethodId);

  ListBuilder<TenderLine> get tenders;
  set tenders(ListBuilder<TenderLine>? tenders);

  String? get transactionReference;
  set transactionReference(String? transactionReference);
}

class _$$PtPaymentFields extends $PtPaymentFields {
  @override
  final String? discountAmount;
  @override
  final int? paymentMethodId;
  @override
  final BuiltList<TenderLine>? tenders;
  @override
  final String? transactionReference;

  factory _$$PtPaymentFields(
          [void Function($PtPaymentFieldsBuilder)? updates]) =>
      ($PtPaymentFieldsBuilder()..update(updates))._build();

  _$$PtPaymentFields._(
      {this.discountAmount,
      this.paymentMethodId,
      this.tenders,
      this.transactionReference})
      : super._();
  @override
  $PtPaymentFields rebuild(void Function($PtPaymentFieldsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $PtPaymentFieldsBuilder toBuilder() =>
      $PtPaymentFieldsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $PtPaymentFields &&
        discountAmount == other.discountAmount &&
        paymentMethodId == other.paymentMethodId &&
        tenders == other.tenders &&
        transactionReference == other.transactionReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, tenders.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$PtPaymentFields')
          ..add('discountAmount', discountAmount)
          ..add('paymentMethodId', paymentMethodId)
          ..add('tenders', tenders)
          ..add('transactionReference', transactionReference))
        .toString();
  }
}

class $PtPaymentFieldsBuilder
    implements
        Builder<$PtPaymentFields, $PtPaymentFieldsBuilder>,
        PtPaymentFieldsBuilder {
  _$$PtPaymentFields? _$v;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(covariant String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(covariant int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  ListBuilder<TenderLine>? _tenders;
  ListBuilder<TenderLine> get tenders =>
      _$this._tenders ??= ListBuilder<TenderLine>();
  set tenders(covariant ListBuilder<TenderLine>? tenders) =>
      _$this._tenders = tenders;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(covariant String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  $PtPaymentFieldsBuilder() {
    $PtPaymentFields._defaults(this);
  }

  $PtPaymentFieldsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _discountAmount = $v.discountAmount;
      _paymentMethodId = $v.paymentMethodId;
      _tenders = $v.tenders?.toBuilder();
      _transactionReference = $v.transactionReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $PtPaymentFields other) {
    _$v = other as _$$PtPaymentFields;
  }

  @override
  void update(void Function($PtPaymentFieldsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $PtPaymentFields build() => _build();

  _$$PtPaymentFields _build() {
    _$$PtPaymentFields _$result;
    try {
      _$result = _$v ??
          _$$PtPaymentFields._(
            discountAmount: discountAmount,
            paymentMethodId: paymentMethodId,
            tenders: _tenders?.build(),
            transactionReference: transactionReference,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tenders';
        _tenders?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$PtPaymentFields', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
