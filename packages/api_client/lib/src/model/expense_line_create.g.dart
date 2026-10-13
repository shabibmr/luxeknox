// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_line_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseLineCreate extends ExpenseLineCreate {
  @override
  final int accountId;
  @override
  final String? description;
  @override
  final String amount;
  @override
  final int? taxCodeId;

  factory _$ExpenseLineCreate(
          [void Function(ExpenseLineCreateBuilder)? updates]) =>
      (ExpenseLineCreateBuilder()..update(updates))._build();

  _$ExpenseLineCreate._(
      {required this.accountId,
      this.description,
      required this.amount,
      this.taxCodeId})
      : super._();
  @override
  ExpenseLineCreate rebuild(void Function(ExpenseLineCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseLineCreateBuilder toBuilder() =>
      ExpenseLineCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseLineCreate &&
        accountId == other.accountId &&
        description == other.description &&
        amount == other.amount &&
        taxCodeId == other.taxCodeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExpenseLineCreate')
          ..add('accountId', accountId)
          ..add('description', description)
          ..add('amount', amount)
          ..add('taxCodeId', taxCodeId))
        .toString();
  }
}

class ExpenseLineCreateBuilder
    implements Builder<ExpenseLineCreate, ExpenseLineCreateBuilder> {
  _$ExpenseLineCreate? _$v;

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

  ExpenseLineCreateBuilder() {
    ExpenseLineCreate._defaults(this);
  }

  ExpenseLineCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _description = $v.description;
      _amount = $v.amount;
      _taxCodeId = $v.taxCodeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpenseLineCreate other) {
    _$v = other as _$ExpenseLineCreate;
  }

  @override
  void update(void Function(ExpenseLineCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseLineCreate build() => _build();

  _$ExpenseLineCreate _build() {
    final _$result = _$v ??
        _$ExpenseLineCreate._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'ExpenseLineCreate', 'accountId'),
          description: description,
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'ExpenseLineCreate', 'amount'),
          taxCodeId: taxCodeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
