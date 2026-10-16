// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBillCreate extends PurchaseBillCreate {
  @override
  final int vendorId;
  @override
  final Date billDate;
  @override
  final String? supplierInvoiceNo;
  @override
  final Date? dueDate;
  @override
  final BuiltList<PurchaseBillLineWrite> lines;

  factory _$PurchaseBillCreate(
          [void Function(PurchaseBillCreateBuilder)? updates]) =>
      (PurchaseBillCreateBuilder()..update(updates))._build();

  _$PurchaseBillCreate._(
      {required this.vendorId,
      required this.billDate,
      this.supplierInvoiceNo,
      this.dueDate,
      required this.lines})
      : super._();
  @override
  PurchaseBillCreate rebuild(
          void Function(PurchaseBillCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillCreateBuilder toBuilder() =>
      PurchaseBillCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBillCreate &&
        vendorId == other.vendorId &&
        billDate == other.billDate &&
        supplierInvoiceNo == other.supplierInvoiceNo &&
        dueDate == other.dueDate &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, billDate.hashCode);
    _$hash = $jc(_$hash, supplierInvoiceNo.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PurchaseBillCreate')
          ..add('vendorId', vendorId)
          ..add('billDate', billDate)
          ..add('supplierInvoiceNo', supplierInvoiceNo)
          ..add('dueDate', dueDate)
          ..add('lines', lines))
        .toString();
  }
}

class PurchaseBillCreateBuilder
    implements Builder<PurchaseBillCreate, PurchaseBillCreateBuilder> {
  _$PurchaseBillCreate? _$v;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  Date? _billDate;
  Date? get billDate => _$this._billDate;
  set billDate(Date? billDate) => _$this._billDate = billDate;

  String? _supplierInvoiceNo;
  String? get supplierInvoiceNo => _$this._supplierInvoiceNo;
  set supplierInvoiceNo(String? supplierInvoiceNo) =>
      _$this._supplierInvoiceNo = supplierInvoiceNo;

  Date? _dueDate;
  Date? get dueDate => _$this._dueDate;
  set dueDate(Date? dueDate) => _$this._dueDate = dueDate;

  ListBuilder<PurchaseBillLineWrite>? _lines;
  ListBuilder<PurchaseBillLineWrite> get lines =>
      _$this._lines ??= ListBuilder<PurchaseBillLineWrite>();
  set lines(ListBuilder<PurchaseBillLineWrite>? lines) => _$this._lines = lines;

  PurchaseBillCreateBuilder() {
    PurchaseBillCreate._defaults(this);
  }

  PurchaseBillCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _billDate = $v.billDate;
      _supplierInvoiceNo = $v.supplierInvoiceNo;
      _dueDate = $v.dueDate;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBillCreate other) {
    _$v = other as _$PurchaseBillCreate;
  }

  @override
  void update(void Function(PurchaseBillCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBillCreate build() => _build();

  _$PurchaseBillCreate _build() {
    _$PurchaseBillCreate _$result;
    try {
      _$result = _$v ??
          _$PurchaseBillCreate._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'PurchaseBillCreate', 'vendorId'),
            billDate: BuiltValueNullFieldError.checkNotNull(
                billDate, r'PurchaseBillCreate', 'billDate'),
            supplierInvoiceNo: supplierInvoiceNo,
            dueDate: dueDate,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PurchaseBillCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
