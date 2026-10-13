// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_ar_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OpenArItem extends OpenArItem {
  @override
  final int paymentId;
  @override
  final String invoiceNumber;
  @override
  final Date invoiceDate;
  @override
  final int memberId;
  @override
  final String totalAmount;
  @override
  final String amountPaid;
  @override
  final String openAmount;
  @override
  final String status;

  factory _$OpenArItem([void Function(OpenArItemBuilder)? updates]) =>
      (OpenArItemBuilder()..update(updates))._build();

  _$OpenArItem._(
      {required this.paymentId,
      required this.invoiceNumber,
      required this.invoiceDate,
      required this.memberId,
      required this.totalAmount,
      required this.amountPaid,
      required this.openAmount,
      required this.status})
      : super._();
  @override
  OpenArItem rebuild(void Function(OpenArItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenArItemBuilder toBuilder() => OpenArItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenArItem &&
        paymentId == other.paymentId &&
        invoiceNumber == other.invoiceNumber &&
        invoiceDate == other.invoiceDate &&
        memberId == other.memberId &&
        totalAmount == other.totalAmount &&
        amountPaid == other.amountPaid &&
        openAmount == other.openAmount &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, invoiceNumber.hashCode);
    _$hash = $jc(_$hash, invoiceDate.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, amountPaid.hashCode);
    _$hash = $jc(_$hash, openAmount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenArItem')
          ..add('paymentId', paymentId)
          ..add('invoiceNumber', invoiceNumber)
          ..add('invoiceDate', invoiceDate)
          ..add('memberId', memberId)
          ..add('totalAmount', totalAmount)
          ..add('amountPaid', amountPaid)
          ..add('openAmount', openAmount)
          ..add('status', status))
        .toString();
  }
}

class OpenArItemBuilder implements Builder<OpenArItem, OpenArItemBuilder> {
  _$OpenArItem? _$v;

  int? _paymentId;
  int? get paymentId => _$this._paymentId;
  set paymentId(int? paymentId) => _$this._paymentId = paymentId;

  String? _invoiceNumber;
  String? get invoiceNumber => _$this._invoiceNumber;
  set invoiceNumber(String? invoiceNumber) =>
      _$this._invoiceNumber = invoiceNumber;

  Date? _invoiceDate;
  Date? get invoiceDate => _$this._invoiceDate;
  set invoiceDate(Date? invoiceDate) => _$this._invoiceDate = invoiceDate;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  String? _amountPaid;
  String? get amountPaid => _$this._amountPaid;
  set amountPaid(String? amountPaid) => _$this._amountPaid = amountPaid;

  String? _openAmount;
  String? get openAmount => _$this._openAmount;
  set openAmount(String? openAmount) => _$this._openAmount = openAmount;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  OpenArItemBuilder() {
    OpenArItem._defaults(this);
  }

  OpenArItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _invoiceNumber = $v.invoiceNumber;
      _invoiceDate = $v.invoiceDate;
      _memberId = $v.memberId;
      _totalAmount = $v.totalAmount;
      _amountPaid = $v.amountPaid;
      _openAmount = $v.openAmount;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenArItem other) {
    _$v = other as _$OpenArItem;
  }

  @override
  void update(void Function(OpenArItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenArItem build() => _build();

  _$OpenArItem _build() {
    final _$result = _$v ??
        _$OpenArItem._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'OpenArItem', 'paymentId'),
          invoiceNumber: BuiltValueNullFieldError.checkNotNull(
              invoiceNumber, r'OpenArItem', 'invoiceNumber'),
          invoiceDate: BuiltValueNullFieldError.checkNotNull(
              invoiceDate, r'OpenArItem', 'invoiceDate'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'OpenArItem', 'memberId'),
          totalAmount: BuiltValueNullFieldError.checkNotNull(
              totalAmount, r'OpenArItem', 'totalAmount'),
          amountPaid: BuiltValueNullFieldError.checkNotNull(
              amountPaid, r'OpenArItem', 'amountPaid'),
          openAmount: BuiltValueNullFieldError.checkNotNull(
              openAmount, r'OpenArItem', 'openAmount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OpenArItem', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
