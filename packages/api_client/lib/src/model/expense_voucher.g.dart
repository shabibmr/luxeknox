// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_voucher.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseVoucher extends ExpenseVoucher {
  @override
  final int id;
  @override
  final String expenseNumber;
  @override
  final int? vendorId;
  @override
  final String? payeeName;
  @override
  final Date expenseDate;
  @override
  final int? paidFromAccountId;
  @override
  final ExpenseStatus status;
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
  final BuiltList<ExpenseVoucherLine> lines;

  factory _$ExpenseVoucher([void Function(ExpenseVoucherBuilder)? updates]) =>
      (ExpenseVoucherBuilder()..update(updates))._build();

  _$ExpenseVoucher._(
      {required this.id,
      required this.expenseNumber,
      this.vendorId,
      this.payeeName,
      required this.expenseDate,
      this.paidFromAccountId,
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
  ExpenseVoucher rebuild(void Function(ExpenseVoucherBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseVoucherBuilder toBuilder() => ExpenseVoucherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseVoucher &&
        id == other.id &&
        expenseNumber == other.expenseNumber &&
        vendorId == other.vendorId &&
        payeeName == other.payeeName &&
        expenseDate == other.expenseDate &&
        paidFromAccountId == other.paidFromAccountId &&
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
    _$hash = $jc(_$hash, expenseNumber.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, payeeName.hashCode);
    _$hash = $jc(_$hash, expenseDate.hashCode);
    _$hash = $jc(_$hash, paidFromAccountId.hashCode);
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
    return (newBuiltValueToStringHelper(r'ExpenseVoucher')
          ..add('id', id)
          ..add('expenseNumber', expenseNumber)
          ..add('vendorId', vendorId)
          ..add('payeeName', payeeName)
          ..add('expenseDate', expenseDate)
          ..add('paidFromAccountId', paidFromAccountId)
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

class ExpenseVoucherBuilder
    implements Builder<ExpenseVoucher, ExpenseVoucherBuilder> {
  _$ExpenseVoucher? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _expenseNumber;
  String? get expenseNumber => _$this._expenseNumber;
  set expenseNumber(String? expenseNumber) =>
      _$this._expenseNumber = expenseNumber;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  String? _payeeName;
  String? get payeeName => _$this._payeeName;
  set payeeName(String? payeeName) => _$this._payeeName = payeeName;

  Date? _expenseDate;
  Date? get expenseDate => _$this._expenseDate;
  set expenseDate(Date? expenseDate) => _$this._expenseDate = expenseDate;

  int? _paidFromAccountId;
  int? get paidFromAccountId => _$this._paidFromAccountId;
  set paidFromAccountId(int? paidFromAccountId) =>
      _$this._paidFromAccountId = paidFromAccountId;

  ExpenseStatus? _status;
  ExpenseStatus? get status => _$this._status;
  set status(ExpenseStatus? status) => _$this._status = status;

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

  ListBuilder<ExpenseVoucherLine>? _lines;
  ListBuilder<ExpenseVoucherLine> get lines =>
      _$this._lines ??= ListBuilder<ExpenseVoucherLine>();
  set lines(ListBuilder<ExpenseVoucherLine>? lines) => _$this._lines = lines;

  ExpenseVoucherBuilder() {
    ExpenseVoucher._defaults(this);
  }

  ExpenseVoucherBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _expenseNumber = $v.expenseNumber;
      _vendorId = $v.vendorId;
      _payeeName = $v.payeeName;
      _expenseDate = $v.expenseDate;
      _paidFromAccountId = $v.paidFromAccountId;
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
  void replace(ExpenseVoucher other) {
    _$v = other as _$ExpenseVoucher;
  }

  @override
  void update(void Function(ExpenseVoucherBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseVoucher build() => _build();

  _$ExpenseVoucher _build() {
    _$ExpenseVoucher _$result;
    try {
      _$result = _$v ??
          _$ExpenseVoucher._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ExpenseVoucher', 'id'),
            expenseNumber: BuiltValueNullFieldError.checkNotNull(
                expenseNumber, r'ExpenseVoucher', 'expenseNumber'),
            vendorId: vendorId,
            payeeName: payeeName,
            expenseDate: BuiltValueNullFieldError.checkNotNull(
                expenseDate, r'ExpenseVoucher', 'expenseDate'),
            paidFromAccountId: paidFromAccountId,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ExpenseVoucher', 'status'),
            subtotal: BuiltValueNullFieldError.checkNotNull(
                subtotal, r'ExpenseVoucher', 'subtotal'),
            taxAmount: BuiltValueNullFieldError.checkNotNull(
                taxAmount, r'ExpenseVoucher', 'taxAmount'),
            totalAmount: BuiltValueNullFieldError.checkNotNull(
                totalAmount, r'ExpenseVoucher', 'totalAmount'),
            journalEntryId: journalEntryId,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'ExpenseVoucher', 'rowVersion'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ExpenseVoucher', 'createdAt'),
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
            r'ExpenseVoucher', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
