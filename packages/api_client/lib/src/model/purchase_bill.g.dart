// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBill extends PurchaseBill {
  @override
  final int id;
  @override
  final String billNumber;
  @override
  final String? supplierInvoiceNo;
  @override
  final int vendorId;
  @override
  final Date billDate;
  @override
  final Date? dueDate;
  @override
  final PurchaseBillStatus status;
  @override
  final String subtotal;
  @override
  final String taxAmount;
  @override
  final String totalAmount;
  @override
  final int? journalEntryId;
  @override
  final int rowVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final BuiltList<PurchaseBillLine> lines;

  factory _$PurchaseBill([void Function(PurchaseBillBuilder)? updates]) =>
      (PurchaseBillBuilder()..update(updates))._build();

  _$PurchaseBill._(
      {required this.id,
      required this.billNumber,
      this.supplierInvoiceNo,
      required this.vendorId,
      required this.billDate,
      this.dueDate,
      required this.status,
      required this.subtotal,
      required this.taxAmount,
      required this.totalAmount,
      this.journalEntryId,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt,
      required this.lines})
      : super._();
  @override
  PurchaseBill rebuild(void Function(PurchaseBillBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillBuilder toBuilder() => PurchaseBillBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBill &&
        id == other.id &&
        billNumber == other.billNumber &&
        supplierInvoiceNo == other.supplierInvoiceNo &&
        vendorId == other.vendorId &&
        billDate == other.billDate &&
        dueDate == other.dueDate &&
        status == other.status &&
        subtotal == other.subtotal &&
        taxAmount == other.taxAmount &&
        totalAmount == other.totalAmount &&
        journalEntryId == other.journalEntryId &&
        rowVersion == other.rowVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, billNumber.hashCode);
    _$hash = $jc(_$hash, supplierInvoiceNo.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, billDate.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, journalEntryId.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PurchaseBill')
          ..add('id', id)
          ..add('billNumber', billNumber)
          ..add('supplierInvoiceNo', supplierInvoiceNo)
          ..add('vendorId', vendorId)
          ..add('billDate', billDate)
          ..add('dueDate', dueDate)
          ..add('status', status)
          ..add('subtotal', subtotal)
          ..add('taxAmount', taxAmount)
          ..add('totalAmount', totalAmount)
          ..add('journalEntryId', journalEntryId)
          ..add('rowVersion', rowVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('lines', lines))
        .toString();
  }
}

class PurchaseBillBuilder
    implements Builder<PurchaseBill, PurchaseBillBuilder> {
  _$PurchaseBill? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _billNumber;
  String? get billNumber => _$this._billNumber;
  set billNumber(String? billNumber) => _$this._billNumber = billNumber;

  String? _supplierInvoiceNo;
  String? get supplierInvoiceNo => _$this._supplierInvoiceNo;
  set supplierInvoiceNo(String? supplierInvoiceNo) =>
      _$this._supplierInvoiceNo = supplierInvoiceNo;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  Date? _billDate;
  Date? get billDate => _$this._billDate;
  set billDate(Date? billDate) => _$this._billDate = billDate;

  Date? _dueDate;
  Date? get dueDate => _$this._dueDate;
  set dueDate(Date? dueDate) => _$this._dueDate = dueDate;

  PurchaseBillStatus? _status;
  PurchaseBillStatus? get status => _$this._status;
  set status(PurchaseBillStatus? status) => _$this._status = status;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  String? _taxAmount;
  String? get taxAmount => _$this._taxAmount;
  set taxAmount(String? taxAmount) => _$this._taxAmount = taxAmount;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  int? _journalEntryId;
  int? get journalEntryId => _$this._journalEntryId;
  set journalEntryId(int? journalEntryId) =>
      _$this._journalEntryId = journalEntryId;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<PurchaseBillLine>? _lines;
  ListBuilder<PurchaseBillLine> get lines =>
      _$this._lines ??= ListBuilder<PurchaseBillLine>();
  set lines(ListBuilder<PurchaseBillLine>? lines) => _$this._lines = lines;

  PurchaseBillBuilder() {
    PurchaseBill._defaults(this);
  }

  PurchaseBillBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _billNumber = $v.billNumber;
      _supplierInvoiceNo = $v.supplierInvoiceNo;
      _vendorId = $v.vendorId;
      _billDate = $v.billDate;
      _dueDate = $v.dueDate;
      _status = $v.status;
      _subtotal = $v.subtotal;
      _taxAmount = $v.taxAmount;
      _totalAmount = $v.totalAmount;
      _journalEntryId = $v.journalEntryId;
      _rowVersion = $v.rowVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBill other) {
    _$v = other as _$PurchaseBill;
  }

  @override
  void update(void Function(PurchaseBillBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBill build() => _build();

  _$PurchaseBill _build() {
    _$PurchaseBill _$result;
    try {
      _$result = _$v ??
          _$PurchaseBill._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PurchaseBill', 'id'),
            billNumber: BuiltValueNullFieldError.checkNotNull(
                billNumber, r'PurchaseBill', 'billNumber'),
            supplierInvoiceNo: supplierInvoiceNo,
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'PurchaseBill', 'vendorId'),
            billDate: BuiltValueNullFieldError.checkNotNull(
                billDate, r'PurchaseBill', 'billDate'),
            dueDate: dueDate,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PurchaseBill', 'status'),
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'PurchaseBill', 'subtotal'),
            taxAmount: BuiltValueNullFieldError.checkNotNull(
                taxAmount, r'PurchaseBill', 'taxAmount'),
            totalAmount: BuiltValueNullFieldError.checkNotNull(
                totalAmount, r'PurchaseBill', 'totalAmount'),
            journalEntryId: journalEntryId,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'PurchaseBill', 'rowVersion'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PurchaseBill', 'createdAt'),
            updatedAt: updatedAt,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PurchaseBill', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
