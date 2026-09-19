// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentCreate extends PaymentCreate {
  @override
  final int memberId;
  @override
  final int? membershipId;
  @override
  final int? productId;
  @override
  final String subtotal;
  @override
  final String? discountAmount;
  @override
  final int? paymentMethodId;
  @override
  final BuiltList<TenderLine>? tenders;
  @override
  final String? transactionReference;

  factory _$PaymentCreate([void Function(PaymentCreateBuilder)? updates]) =>
      (PaymentCreateBuilder()..update(updates))._build();

  _$PaymentCreate._(
      {required this.memberId,
      this.membershipId,
      this.productId,
      required this.subtotal,
      this.discountAmount,
      this.paymentMethodId,
      this.tenders,
      this.transactionReference})
      : super._();
  @override
  PaymentCreate rebuild(void Function(PaymentCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentCreateBuilder toBuilder() => PaymentCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentCreate &&
        memberId == other.memberId &&
        membershipId == other.membershipId &&
        productId == other.productId &&
        subtotal == other.subtotal &&
        discountAmount == other.discountAmount &&
        paymentMethodId == other.paymentMethodId &&
        tenders == other.tenders &&
        transactionReference == other.transactionReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, tenders.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentCreate')
          ..add('memberId', memberId)
          ..add('membershipId', membershipId)
          ..add('productId', productId)
          ..add('subtotal', subtotal)
          ..add('discountAmount', discountAmount)
          ..add('paymentMethodId', paymentMethodId)
          ..add('tenders', tenders)
          ..add('transactionReference', transactionReference))
        .toString();
  }
}

class PaymentCreateBuilder
    implements Builder<PaymentCreate, PaymentCreateBuilder> {
  _$PaymentCreate? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  ListBuilder<TenderLine>? _tenders;
  ListBuilder<TenderLine> get tenders =>
      _$this._tenders ??= ListBuilder<TenderLine>();
  set tenders(ListBuilder<TenderLine>? tenders) => _$this._tenders = tenders;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  PaymentCreateBuilder() {
    PaymentCreate._defaults(this);
  }

  PaymentCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _membershipId = $v.membershipId;
      _productId = $v.productId;
      _subtotal = $v.subtotal;
      _discountAmount = $v.discountAmount;
      _paymentMethodId = $v.paymentMethodId;
      _tenders = $v.tenders?.toBuilder();
      _transactionReference = $v.transactionReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentCreate other) {
    _$v = other as _$PaymentCreate;
  }

  @override
  void update(void Function(PaymentCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentCreate build() => _build();

  _$PaymentCreate _build() {
    _$PaymentCreate _$result;
    try {
      _$result = _$v ??
          _$PaymentCreate._(
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'PaymentCreate', 'memberId'),
            membershipId: membershipId,
            productId: productId,
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'PaymentCreate', 'subtotal'),
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
            r'PaymentCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
