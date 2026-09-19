// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_receipt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentReceipt extends PaymentReceipt {
  @override
  final int id;
  @override
  final int paymentId;
  @override
  final String receiptNumber;
  @override
  final String? receiptPdfUrl;
  @override
  final DateTime? generatedAt;
  @override
  final Payment? payment;

  factory _$PaymentReceipt([void Function(PaymentReceiptBuilder)? updates]) =>
      (PaymentReceiptBuilder()..update(updates))._build();

  _$PaymentReceipt._(
      {required this.id,
      required this.paymentId,
      required this.receiptNumber,
      this.receiptPdfUrl,
      this.generatedAt,
      this.payment})
      : super._();
  @override
  PaymentReceipt rebuild(void Function(PaymentReceiptBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentReceiptBuilder toBuilder() => PaymentReceiptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentReceipt &&
        id == other.id &&
        paymentId == other.paymentId &&
        receiptNumber == other.receiptNumber &&
        receiptPdfUrl == other.receiptPdfUrl &&
        generatedAt == other.generatedAt &&
        payment == other.payment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, receiptNumber.hashCode);
    _$hash = $jc(_$hash, receiptPdfUrl.hashCode);
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentReceipt')
          ..add('id', id)
          ..add('paymentId', paymentId)
          ..add('receiptNumber', receiptNumber)
          ..add('receiptPdfUrl', receiptPdfUrl)
          ..add('generatedAt', generatedAt)
          ..add('payment', payment))
        .toString();
  }
}

class PaymentReceiptBuilder
    implements Builder<PaymentReceipt, PaymentReceiptBuilder> {
  _$PaymentReceipt? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _paymentId;
  int? get paymentId => _$this._paymentId;
  set paymentId(int? paymentId) => _$this._paymentId = paymentId;

  String? _receiptNumber;
  String? get receiptNumber => _$this._receiptNumber;
  set receiptNumber(String? receiptNumber) =>
      _$this._receiptNumber = receiptNumber;

  String? _receiptPdfUrl;
  String? get receiptPdfUrl => _$this._receiptPdfUrl;
  set receiptPdfUrl(String? receiptPdfUrl) =>
      _$this._receiptPdfUrl = receiptPdfUrl;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  PaymentBuilder? _payment;
  PaymentBuilder get payment => _$this._payment ??= PaymentBuilder();
  set payment(PaymentBuilder? payment) => _$this._payment = payment;

  PaymentReceiptBuilder() {
    PaymentReceipt._defaults(this);
  }

  PaymentReceiptBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _paymentId = $v.paymentId;
      _receiptNumber = $v.receiptNumber;
      _receiptPdfUrl = $v.receiptPdfUrl;
      _generatedAt = $v.generatedAt;
      _payment = $v.payment?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentReceipt other) {
    _$v = other as _$PaymentReceipt;
  }

  @override
  void update(void Function(PaymentReceiptBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentReceipt build() => _build();

  _$PaymentReceipt _build() {
    _$PaymentReceipt _$result;
    try {
      _$result = _$v ??
          _$PaymentReceipt._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PaymentReceipt', 'id'),
            paymentId: BuiltValueNullFieldError.checkNotNull(
                paymentId, r'PaymentReceipt', 'paymentId'),
            receiptNumber: BuiltValueNullFieldError.checkNotNull(
                receiptNumber, r'PaymentReceipt', 'receiptNumber'),
            receiptPdfUrl: receiptPdfUrl,
            generatedAt: generatedAt,
            payment: _payment?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payment';
        _payment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentReceipt', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
