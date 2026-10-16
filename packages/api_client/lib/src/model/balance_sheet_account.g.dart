// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BalanceSheetAccount extends BalanceSheetAccount {
  @override
  final int accountId;
  @override
  final String accountName;
  @override
  final String amount;

  factory _$BalanceSheetAccount(
          [void Function(BalanceSheetAccountBuilder)? updates]) =>
      (BalanceSheetAccountBuilder()..update(updates))._build();

  _$BalanceSheetAccount._(
      {required this.accountId,
      required this.accountName,
      required this.amount})
      : super._();
  @override
  BalanceSheetAccount rebuild(
          void Function(BalanceSheetAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BalanceSheetAccountBuilder toBuilder() =>
      BalanceSheetAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BalanceSheetAccount &&
        accountId == other.accountId &&
        accountName == other.accountName &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BalanceSheetAccount')
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('amount', amount))
        .toString();
  }
}

class BalanceSheetAccountBuilder
    implements Builder<BalanceSheetAccount, BalanceSheetAccountBuilder> {
  _$BalanceSheetAccount? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  BalanceSheetAccountBuilder() {
    BalanceSheetAccount._defaults(this);
  }

  BalanceSheetAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _accountName = $v.accountName;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BalanceSheetAccount other) {
    _$v = other as _$BalanceSheetAccount;
  }

  @override
  void update(void Function(BalanceSheetAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BalanceSheetAccount build() => _build();

  _$BalanceSheetAccount _build() {
    final _$result = _$v ??
        _$BalanceSheetAccount._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'BalanceSheetAccount', 'accountId'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'BalanceSheetAccount', 'accountName'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'BalanceSheetAccount', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
