// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseCreate extends ExpenseCreate {
  @override
  final Date expenseDate;
  @override
  final int? paidFromAccountId;
  @override
  final int? vendorId;
  @override
  final String? payeeName;
  @override
  final BuiltList<ExpenseLineCreate> lines;

  factory _$ExpenseCreate([void Function(ExpenseCreateBuilder)? updates]) =>
      (ExpenseCreateBuilder()..update(updates))._build();

  _$ExpenseCreate._(
      {required this.expenseDate,
      this.paidFromAccountId,
      this.vendorId,
      this.payeeName,
      required this.lines})
      : super._();
  @override
  ExpenseCreate rebuild(void Function(ExpenseCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseCreateBuilder toBuilder() => ExpenseCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseCreate &&
        expenseDate == other.expenseDate &&
        paidFromAccountId == other.paidFromAccountId &&
        vendorId == other.vendorId &&
        payeeName == other.payeeName &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expenseDate.hashCode);
    _$hash = $jc(_$hash, paidFromAccountId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, payeeName.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExpenseCreate')
          ..add('expenseDate', expenseDate)
          ..add('paidFromAccountId', paidFromAccountId)
          ..add('vendorId', vendorId)
          ..add('payeeName', payeeName)
          ..add('lines', lines))
        .toString();
  }
}

class ExpenseCreateBuilder
    implements Builder<ExpenseCreate, ExpenseCreateBuilder> {
  _$ExpenseCreate? _$v;

  Date? _expenseDate;
  Date? get expenseDate => _$this._expenseDate;
  set expenseDate(Date? expenseDate) => _$this._expenseDate = expenseDate;

  int? _paidFromAccountId;
  int? get paidFromAccountId => _$this._paidFromAccountId;
  set paidFromAccountId(int? paidFromAccountId) =>
      _$this._paidFromAccountId = paidFromAccountId;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  String? _payeeName;
  String? get payeeName => _$this._payeeName;
  set payeeName(String? payeeName) => _$this._payeeName = payeeName;

  ListBuilder<ExpenseLineCreate>? _lines;
  ListBuilder<ExpenseLineCreate> get lines =>
      _$this._lines ??= ListBuilder<ExpenseLineCreate>();
  set lines(ListBuilder<ExpenseLineCreate>? lines) => _$this._lines = lines;

  ExpenseCreateBuilder() {
    ExpenseCreate._defaults(this);
  }

  ExpenseCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expenseDate = $v.expenseDate;
      _paidFromAccountId = $v.paidFromAccountId;
      _vendorId = $v.vendorId;
      _payeeName = $v.payeeName;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpenseCreate other) {
    _$v = other as _$ExpenseCreate;
  }

  @override
  void update(void Function(ExpenseCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseCreate build() => _build();

  _$ExpenseCreate _build() {
    _$ExpenseCreate _$result;
    try {
      _$result = _$v ??
          _$ExpenseCreate._(
            expenseDate: BuiltValueNullFieldError.checkNotNull(
                expenseDate, r'ExpenseCreate', 'expenseDate'),
            paidFromAccountId: paidFromAccountId,
            vendorId: vendorId,
            payeeName: payeeName,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ExpenseCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
