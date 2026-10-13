// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_voucher_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseVoucherLine extends ExpenseVoucherLine {
  @override
  final int id;
  @override
  final int expenseVoucherId;
  @override
  final int accountId;
  @override
  final String? description;
  @override
  final String amount;
  @override
  final int? taxCodeId;
  @override
  final String taxAmount;

  factory _$ExpenseVoucherLine(
          [void Function(ExpenseVoucherLineBuilder)? updates]) =>
      (ExpenseVoucherLineBuilder()..update(updates))._build();

  _$ExpenseVoucherLine._(
      {required this.id,
      required this.expenseVoucherId,
      required this.accountId,
      this.description,
      required this.amount,
      this.taxCodeId,
      required this.taxAmount})
      : super._();
  @override
  ExpenseVoucherLine rebuild(
          void Function(ExpenseVoucherLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseVoucherLineBuilder toBuilder() =>
      ExpenseVoucherLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseVoucherLine &&
        id == other.id &&
        expenseVoucherId == other.expenseVoucherId &&
        accountId == other.accountId &&
        description == other.description &&
        amount == other.amount &&
        taxCodeId == other.taxCodeId &&
        taxAmount == other.taxAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, expenseVoucherId.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExpenseVoucherLine')
          ..add('id', id)
          ..add('expenseVoucherId', expenseVoucherId)
          ..add('accountId', accountId)
          ..add('description', description)
          ..add('amount', amount)
          ..add('taxCodeId', taxCodeId)
          ..add('taxAmount', taxAmount))
        .toString();
  }
}

class ExpenseVoucherLineBuilder
    implements Builder<ExpenseVoucherLine, ExpenseVoucherLineBuilder> {
  _$ExpenseVoucherLine? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _expenseVoucherId;
  int? get expenseVoucherId => _$this._expenseVoucherId;
  set expenseVoucherId(int? expenseVoucherId) =>
      _$this._expenseVoucherId = expenseVoucherId;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  int? _taxCodeId;
  int? get taxCodeId => _$this._taxCodeId;
  set taxCodeId(int? taxCodeId) => _$this._taxCodeId = taxCodeId;

  String? _taxAmount;
  String? get taxAmount => _$this._taxAmount;
  set taxAmount(String? taxAmount) => _$this._taxAmount = taxAmount;

  ExpenseVoucherLineBuilder() {
    ExpenseVoucherLine._defaults(this);
  }

  ExpenseVoucherLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _expenseVoucherId = $v.expenseVoucherId;
      _accountId = $v.accountId;
      _description = $v.description;
      _amount = $v.amount;
      _taxCodeId = $v.taxCodeId;
      _taxAmount = $v.taxAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpenseVoucherLine other) {
    _$v = other as _$ExpenseVoucherLine;
  }

  @override
  void update(void Function(ExpenseVoucherLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseVoucherLine build() => _build();

  _$ExpenseVoucherLine _build() {
    final _$result = _$v ??
        _$ExpenseVoucherLine._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ExpenseVoucherLine', 'id'),
          expenseVoucherId: BuiltValueNullFieldError.checkNotNull(
              expenseVoucherId, r'ExpenseVoucherLine', 'expenseVoucherId'),
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'ExpenseVoucherLine', 'accountId'),
          description: description,
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'ExpenseVoucherLine', 'amount'),
          taxCodeId: taxCodeId,
          taxAmount: BuiltValueNullFieldError.checkNotNull(
              taxAmount, r'ExpenseVoucherLine', 'taxAmount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
