// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_ap_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OpenApItem extends OpenApItem {
  @override
  final int purchaseBillId;
  @override
  final String billNumber;
  @override
  final Date billDate;
  @override
  final Date? dueDate;
  @override
  final int vendorId;
  @override
  final String totalAmount;
  @override
  final String allocatedAmount;
  @override
  final String debitNoteAmount;
  @override
  final String openAmount;
  @override
  final String status;

  factory _$OpenApItem([void Function(OpenApItemBuilder)? updates]) =>
      (OpenApItemBuilder()..update(updates))._build();

  _$OpenApItem._(
      {required this.purchaseBillId,
      required this.billNumber,
      required this.billDate,
      this.dueDate,
      required this.vendorId,
      required this.totalAmount,
      required this.allocatedAmount,
      required this.debitNoteAmount,
      required this.openAmount,
      required this.status})
      : super._();
  @override
  OpenApItem rebuild(void Function(OpenApItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenApItemBuilder toBuilder() => OpenApItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenApItem &&
        purchaseBillId == other.purchaseBillId &&
        billNumber == other.billNumber &&
        billDate == other.billDate &&
        dueDate == other.dueDate &&
        vendorId == other.vendorId &&
        totalAmount == other.totalAmount &&
        allocatedAmount == other.allocatedAmount &&
        debitNoteAmount == other.debitNoteAmount &&
        openAmount == other.openAmount &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, billNumber.hashCode);
    _$hash = $jc(_$hash, billDate.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, allocatedAmount.hashCode);
    _$hash = $jc(_$hash, debitNoteAmount.hashCode);
    _$hash = $jc(_$hash, openAmount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenApItem')
          ..add('purchaseBillId', purchaseBillId)
          ..add('billNumber', billNumber)
          ..add('billDate', billDate)
          ..add('dueDate', dueDate)
          ..add('vendorId', vendorId)
          ..add('totalAmount', totalAmount)
          ..add('allocatedAmount', allocatedAmount)
          ..add('debitNoteAmount', debitNoteAmount)
          ..add('openAmount', openAmount)
          ..add('status', status))
        .toString();
  }
}

class OpenApItemBuilder implements Builder<OpenApItem, OpenApItemBuilder> {
  _$OpenApItem? _$v;

  int? _purchaseBillId;
  int? get purchaseBillId => _$this._purchaseBillId;
  set purchaseBillId(int? purchaseBillId) =>
      _$this._purchaseBillId = purchaseBillId;

  String? _billNumber;
  String? get billNumber => _$this._billNumber;
  set billNumber(String? billNumber) => _$this._billNumber = billNumber;

  Date? _billDate;
  Date? get billDate => _$this._billDate;
  set billDate(Date? billDate) => _$this._billDate = billDate;

  Date? _dueDate;
  Date? get dueDate => _$this._dueDate;
  set dueDate(Date? dueDate) => _$this._dueDate = dueDate;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  String? _allocatedAmount;
  String? get allocatedAmount => _$this._allocatedAmount;
  set allocatedAmount(String? allocatedAmount) =>
      _$this._allocatedAmount = allocatedAmount;

  String? _debitNoteAmount;
  String? get debitNoteAmount => _$this._debitNoteAmount;
  set debitNoteAmount(String? debitNoteAmount) =>
      _$this._debitNoteAmount = debitNoteAmount;

  String? _openAmount;
  String? get openAmount => _$this._openAmount;
  set openAmount(String? openAmount) => _$this._openAmount = openAmount;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  OpenApItemBuilder() {
    OpenApItem._defaults(this);
  }

  OpenApItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purchaseBillId = $v.purchaseBillId;
      _billNumber = $v.billNumber;
      _billDate = $v.billDate;
      _dueDate = $v.dueDate;
      _vendorId = $v.vendorId;
      _totalAmount = $v.totalAmount;
      _allocatedAmount = $v.allocatedAmount;
      _debitNoteAmount = $v.debitNoteAmount;
      _openAmount = $v.openAmount;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenApItem other) {
    _$v = other as _$OpenApItem;
  }

  @override
  void update(void Function(OpenApItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenApItem build() => _build();

  _$OpenApItem _build() {
    final _$result = _$v ??
        _$OpenApItem._(
          purchaseBillId: BuiltValueNullFieldError.checkNotNull(
              purchaseBillId, r'OpenApItem', 'purchaseBillId'),
          billNumber: BuiltValueNullFieldError.checkNotNull(
              billNumber, r'OpenApItem', 'billNumber'),
          billDate: BuiltValueNullFieldError.checkNotNull(
              billDate, r'OpenApItem', 'billDate'),
          dueDate: dueDate,
          vendorId: BuiltValueNullFieldError.checkNotNull(
              vendorId, r'OpenApItem', 'vendorId'),
          totalAmount: BuiltValueNullFieldError.checkNotNull(
              totalAmount, r'OpenApItem', 'totalAmount'),
          allocatedAmount: BuiltValueNullFieldError.checkNotNull(
              allocatedAmount, r'OpenApItem', 'allocatedAmount'),
          debitNoteAmount: BuiltValueNullFieldError.checkNotNull(
              debitNoteAmount, r'OpenApItem', 'debitNoteAmount'),
          openAmount: BuiltValueNullFieldError.checkNotNull(
              openAmount, r'OpenApItem', 'openAmount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OpenApItem', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
