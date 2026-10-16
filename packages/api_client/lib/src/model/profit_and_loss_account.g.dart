// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_and_loss_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfitAndLossAccount extends ProfitAndLossAccount {
  @override
  final int accountId;
  @override
  final String accountName;
  @override
  final String amount;

  factory _$ProfitAndLossAccount(
          [void Function(ProfitAndLossAccountBuilder)? updates]) =>
      (ProfitAndLossAccountBuilder()..update(updates))._build();

  _$ProfitAndLossAccount._(
      {required this.accountId,
      required this.accountName,
      required this.amount})
      : super._();
  @override
  ProfitAndLossAccount rebuild(
          void Function(ProfitAndLossAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfitAndLossAccountBuilder toBuilder() =>
      ProfitAndLossAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfitAndLossAccount &&
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
    return (newBuiltValueToStringHelper(r'ProfitAndLossAccount')
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('amount', amount))
        .toString();
  }
}

class ProfitAndLossAccountBuilder
    implements Builder<ProfitAndLossAccount, ProfitAndLossAccountBuilder> {
  _$ProfitAndLossAccount? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  ProfitAndLossAccountBuilder() {
    ProfitAndLossAccount._defaults(this);
  }

  ProfitAndLossAccountBuilder get _$this {
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
  void replace(ProfitAndLossAccount other) {
    _$v = other as _$ProfitAndLossAccount;
  }

  @override
  void update(void Function(ProfitAndLossAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfitAndLossAccount build() => _build();

  _$ProfitAndLossAccount _build() {
    final _$result = _$v ??
        _$ProfitAndLossAccount._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'ProfitAndLossAccount', 'accountId'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'ProfitAndLossAccount', 'accountName'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'ProfitAndLossAccount', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
