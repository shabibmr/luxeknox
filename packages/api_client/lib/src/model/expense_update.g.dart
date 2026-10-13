// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseUpdate extends ExpenseUpdate {
  @override
  final Date? expenseDate;
  @override
  final int? paidFromAccountId;
  @override
  final int? vendorId;
  @override
  final String? payeeName;
  @override
  final BuiltList<ExpenseLineCreate>? lines;

  factory _$ExpenseUpdate([void Function(ExpenseUpdateBuilder)? updates]) =>
      (ExpenseUpdateBuilder()..update(updates))._build();

  _$ExpenseUpdate._(
      {this.expenseDate,
      this.paidFromAccountId,
      this.vendorId,
      this.payeeName,
      this.lines})
      : super._();
  @override
  ExpenseUpdate rebuild(void Function(ExpenseUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseUpdateBuilder toBuilder() => ExpenseUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseUpdate &&
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
    return (newBuiltValueToStringHelper(r'ExpenseUpdate')
          ..add('expenseDate', expenseDate)
          ..add('paidFromAccountId', paidFromAccountId)
          ..add('vendorId', vendorId)
          ..add('payeeName', payeeName)
          ..add('lines', lines))
        .toString();
  }
}

class ExpenseUpdateBuilder
    implements Builder<ExpenseUpdate, ExpenseUpdateBuilder> {
  _$ExpenseUpdate? _$v;

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

  ExpenseUpdateBuilder() {
    ExpenseUpdate._defaults(this);
  }

  ExpenseUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expenseDate = $v.expenseDate;
      _paidFromAccountId = $v.paidFromAccountId;
      _vendorId = $v.vendorId;
      _payeeName = $v.payeeName;
      _lines = $v.lines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpenseUpdate other) {
    _$v = other as _$ExpenseUpdate;
  }

  @override
  void update(void Function(ExpenseUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseUpdate build() => _build();

  _$ExpenseUpdate _build() {
    _$ExpenseUpdate _$result;
    try {
      _$result = _$v ??
          _$ExpenseUpdate._(
            expenseDate: expenseDate,
            paidFromAccountId: paidFromAccountId,
            vendorId: vendorId,
            payeeName: payeeName,
            lines: _lines?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        _lines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ExpenseUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
