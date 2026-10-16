// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_balance_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrialBalanceAccount extends TrialBalanceAccount {
  @override
  final int accountId;
  @override
  final String accountName;
  @override
  final String accountType;
  @override
  final String debit;
  @override
  final String credit;

  factory _$TrialBalanceAccount(
          [void Function(TrialBalanceAccountBuilder)? updates]) =>
      (TrialBalanceAccountBuilder()..update(updates))._build();

  _$TrialBalanceAccount._(
      {required this.accountId,
      required this.accountName,
      required this.accountType,
      required this.debit,
      required this.credit})
      : super._();
  @override
  TrialBalanceAccount rebuild(
          void Function(TrialBalanceAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrialBalanceAccountBuilder toBuilder() =>
      TrialBalanceAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrialBalanceAccount &&
        accountId == other.accountId &&
        accountName == other.accountName &&
        accountType == other.accountType &&
        debit == other.debit &&
        credit == other.credit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, debit.hashCode);
    _$hash = $jc(_$hash, credit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrialBalanceAccount')
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('accountType', accountType)
          ..add('debit', debit)
          ..add('credit', credit))
        .toString();
  }
}

class TrialBalanceAccountBuilder
    implements Builder<TrialBalanceAccount, TrialBalanceAccountBuilder> {
  _$TrialBalanceAccount? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _accountType;
  String? get accountType => _$this._accountType;
  set accountType(String? accountType) => _$this._accountType = accountType;

  String? _debit;
  String? get debit => _$this._debit;
  set debit(String? debit) => _$this._debit = debit;

  String? _credit;
  String? get credit => _$this._credit;
  set credit(String? credit) => _$this._credit = credit;

  TrialBalanceAccountBuilder() {
    TrialBalanceAccount._defaults(this);
  }

  TrialBalanceAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _accountName = $v.accountName;
      _accountType = $v.accountType;
      _debit = $v.debit;
      _credit = $v.credit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrialBalanceAccount other) {
    _$v = other as _$TrialBalanceAccount;
  }

  @override
  void update(void Function(TrialBalanceAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrialBalanceAccount build() => _build();

  _$TrialBalanceAccount _build() {
    final _$result = _$v ??
        _$TrialBalanceAccount._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'TrialBalanceAccount', 'accountId'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'TrialBalanceAccount', 'accountName'),
          accountType: BuiltValueNullFieldError.checkNotNull(
              accountType, r'TrialBalanceAccount', 'accountType'),
          debit: BuiltValueNullFieldError.checkNotNull(
              debit, r'TrialBalanceAccount', 'debit'),
          credit: BuiltValueNullFieldError.checkNotNull(
              credit, r'TrialBalanceAccount', 'credit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
