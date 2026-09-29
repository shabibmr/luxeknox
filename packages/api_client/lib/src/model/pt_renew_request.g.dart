// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_renew_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtRenewRequest extends PtRenewRequest {
  @override
  final int? ptProductId;
  @override
  final String? discountAmount;
  @override
  final int? paymentMethodId;
  @override
  final BuiltList<TenderLine>? tenders;
  @override
  final String? transactionReference;

  factory _$PtRenewRequest([void Function(PtRenewRequestBuilder)? updates]) =>
      (PtRenewRequestBuilder()..update(updates))._build();

  _$PtRenewRequest._(
      {this.ptProductId,
      this.discountAmount,
      this.paymentMethodId,
      this.tenders,
      this.transactionReference})
      : super._();
  @override
  PtRenewRequest rebuild(void Function(PtRenewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtRenewRequestBuilder toBuilder() => PtRenewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtRenewRequest &&
        ptProductId == other.ptProductId &&
        discountAmount == other.discountAmount &&
        paymentMethodId == other.paymentMethodId &&
        tenders == other.tenders &&
        transactionReference == other.transactionReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ptProductId.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, tenders.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtRenewRequest')
          ..add('ptProductId', ptProductId)
          ..add('discountAmount', discountAmount)
          ..add('paymentMethodId', paymentMethodId)
          ..add('tenders', tenders)
          ..add('transactionReference', transactionReference))
        .toString();
  }
}

class PtRenewRequestBuilder
    implements
        Builder<PtRenewRequest, PtRenewRequestBuilder>,
        PtPaymentFieldsBuilder {
  _$PtRenewRequest? _$v;

  int? _ptProductId;
  int? get ptProductId => _$this._ptProductId;
  set ptProductId(covariant int? ptProductId) =>
      _$this._ptProductId = ptProductId;

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

  PtRenewRequestBuilder() {
    PtRenewRequest._defaults(this);
  }

  PtRenewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ptProductId = $v.ptProductId;
      _discountAmount = $v.discountAmount;
      _paymentMethodId = $v.paymentMethodId;
      _tenders = $v.tenders?.toBuilder();
      _transactionReference = $v.transactionReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PtRenewRequest other) {
    _$v = other as _$PtRenewRequest;
  }

  @override
  void update(void Function(PtRenewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtRenewRequest build() => _build();

  _$PtRenewRequest _build() {
    _$PtRenewRequest _$result;
    try {
      _$result = _$v ??
          _$PtRenewRequest._(
            ptProductId: ptProductId,
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
            r'PtRenewRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
