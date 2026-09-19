// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Payment extends Payment {
  @override
  final int id;
  @override
  final String invoiceNumber;
  @override
  final int memberId;
  @override
  final int? membershipId;
  @override
  final int? paymentMethodId;
  @override
  final String subtotal;
  @override
  final String taxAmount;
  @override
  final String discountAmount;
  @override
  final String totalAmount;
  @override
  final String amountPaid;
  @override
  final PaymentStatus status;
  @override
  final String? transactionReference;
  @override
  final int? cashierUserId;
  @override
  final DateTime? paymentDate;
  @override
  final int rowVersion;
  @override
  final BuiltList<PaymentHistory>? histories;

  factory _$Payment([void Function(PaymentBuilder)? updates]) =>
      (PaymentBuilder()..update(updates))._build();

  _$Payment._(
      {required this.id,
      required this.invoiceNumber,
      required this.memberId,
      this.membershipId,
      this.paymentMethodId,
      required this.subtotal,
      required this.taxAmount,
      required this.discountAmount,
      required this.totalAmount,
      required this.amountPaid,
      required this.status,
      this.transactionReference,
      this.cashierUserId,
      this.paymentDate,
      required this.rowVersion,
      this.histories})
      : super._();
  @override
  Payment rebuild(void Function(PaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentBuilder toBuilder() => PaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Payment &&
        id == other.id &&
        invoiceNumber == other.invoiceNumber &&
        memberId == other.memberId &&
        membershipId == other.membershipId &&
        paymentMethodId == other.paymentMethodId &&
        subtotal == other.subtotal &&
        taxAmount == other.taxAmount &&
        discountAmount == other.discountAmount &&
        totalAmount == other.totalAmount &&
        amountPaid == other.amountPaid &&
        status == other.status &&
        transactionReference == other.transactionReference &&
        cashierUserId == other.cashierUserId &&
        paymentDate == other.paymentDate &&
        rowVersion == other.rowVersion &&
        histories == other.histories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, invoiceNumber.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, amountPaid.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jc(_$hash, cashierUserId.hashCode);
    _$hash = $jc(_$hash, paymentDate.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, histories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Payment')
          ..add('id', id)
          ..add('invoiceNumber', invoiceNumber)
          ..add('memberId', memberId)
          ..add('membershipId', membershipId)
          ..add('paymentMethodId', paymentMethodId)
          ..add('subtotal', subtotal)
          ..add('taxAmount', taxAmount)
          ..add('discountAmount', discountAmount)
          ..add('totalAmount', totalAmount)
          ..add('amountPaid', amountPaid)
          ..add('status', status)
          ..add('transactionReference', transactionReference)
          ..add('cashierUserId', cashierUserId)
          ..add('paymentDate', paymentDate)
          ..add('rowVersion', rowVersion)
          ..add('histories', histories))
        .toString();
  }
}

class PaymentBuilder implements Builder<Payment, PaymentBuilder> {
  _$Payment? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _invoiceNumber;
  String? get invoiceNumber => _$this._invoiceNumber;
  set invoiceNumber(String? invoiceNumber) =>
      _$this._invoiceNumber = invoiceNumber;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  String? _taxAmount;
  String? get taxAmount => _$this._taxAmount;
  set taxAmount(String? taxAmount) => _$this._taxAmount = taxAmount;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  String? _amountPaid;
  String? get amountPaid => _$this._amountPaid;
  set amountPaid(String? amountPaid) => _$this._amountPaid = amountPaid;

  PaymentStatus? _status;
  PaymentStatus? get status => _$this._status;
  set status(PaymentStatus? status) => _$this._status = status;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  int? _cashierUserId;
  int? get cashierUserId => _$this._cashierUserId;
  set cashierUserId(int? cashierUserId) =>
      _$this._cashierUserId = cashierUserId;

  DateTime? _paymentDate;
  DateTime? get paymentDate => _$this._paymentDate;
  set paymentDate(DateTime? paymentDate) => _$this._paymentDate = paymentDate;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  ListBuilder<PaymentHistory>? _histories;
  ListBuilder<PaymentHistory> get histories =>
      _$this._histories ??= ListBuilder<PaymentHistory>();
  set histories(ListBuilder<PaymentHistory>? histories) =>
      _$this._histories = histories;

  PaymentBuilder() {
    Payment._defaults(this);
  }

  PaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _invoiceNumber = $v.invoiceNumber;
      _memberId = $v.memberId;
      _membershipId = $v.membershipId;
      _paymentMethodId = $v.paymentMethodId;
      _subtotal = $v.subtotal;
      _taxAmount = $v.taxAmount;
      _discountAmount = $v.discountAmount;
      _totalAmount = $v.totalAmount;
      _amountPaid = $v.amountPaid;
      _status = $v.status;
      _transactionReference = $v.transactionReference;
      _cashierUserId = $v.cashierUserId;
      _paymentDate = $v.paymentDate;
      _rowVersion = $v.rowVersion;
      _histories = $v.histories?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Payment other) {
    _$v = other as _$Payment;
  }

  @override
  void update(void Function(PaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Payment build() => _build();

  _$Payment _build() {
    _$Payment _$result;
    try {
      _$result = _$v ??
          _$Payment._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Payment', 'id'),
            invoiceNumber: BuiltValueNullFieldError.checkNotNull(
                invoiceNumber, r'Payment', 'invoiceNumber'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'Payment', 'memberId'),
            membershipId: membershipId,
            paymentMethodId: paymentMethodId,
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'Payment', 'subtotal'),
            taxAmount: BuiltValueNullFieldError.checkNotNull(
                taxAmount, r'Payment', 'taxAmount'),
            discountAmount: BuiltValueNullFieldError.checkNotNull(
                discountAmount, r'Payment', 'discountAmount'),
            totalAmount: BuiltValueNullFieldError.checkNotNull(
                totalAmount, r'Payment', 'totalAmount'),
            amountPaid: BuiltValueNullFieldError.checkNotNull(
                amountPaid, r'Payment', 'amountPaid'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Payment', 'status'),
            transactionReference: transactionReference,
            cashierUserId: cashierUserId,
            paymentDate: paymentDate,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'Payment', 'rowVersion'),
            histories: _histories?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'histories';
        _histories?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Payment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
