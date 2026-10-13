// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_balance_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrialBalanceReport extends TrialBalanceReport {
  @override
  final Date? from;
  @override
  final Date to;
  @override
  final BuiltList<TrialBalanceAccount> accounts;
  @override
  final String totalDebit;
  @override
  final String totalCredit;

  factory _$TrialBalanceReport(
          [void Function(TrialBalanceReportBuilder)? updates]) =>
      (TrialBalanceReportBuilder()..update(updates))._build();

  _$TrialBalanceReport._(
      {this.from,
      required this.to,
      required this.accounts,
      required this.totalDebit,
      required this.totalCredit})
      : super._();
  @override
  TrialBalanceReport rebuild(
          void Function(TrialBalanceReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrialBalanceReportBuilder toBuilder() =>
      TrialBalanceReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrialBalanceReport &&
        from == other.from &&
        to == other.to &&
        accounts == other.accounts &&
        totalDebit == other.totalDebit &&
        totalCredit == other.totalCredit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, accounts.hashCode);
    _$hash = $jc(_$hash, totalDebit.hashCode);
    _$hash = $jc(_$hash, totalCredit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrialBalanceReport')
          ..add('from', from)
          ..add('to', to)
          ..add('accounts', accounts)
          ..add('totalDebit', totalDebit)
          ..add('totalCredit', totalCredit))
        .toString();
  }
}

class TrialBalanceReportBuilder
    implements Builder<TrialBalanceReport, TrialBalanceReportBuilder> {
  _$TrialBalanceReport? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  ListBuilder<TrialBalanceAccount>? _accounts;
  ListBuilder<TrialBalanceAccount> get accounts =>
      _$this._accounts ??= ListBuilder<TrialBalanceAccount>();
  set accounts(ListBuilder<TrialBalanceAccount>? accounts) =>
      _$this._accounts = accounts;

  String? _totalDebit;
  String? get totalDebit => _$this._totalDebit;
  set totalDebit(String? totalDebit) => _$this._totalDebit = totalDebit;

  String? _totalCredit;
  String? get totalCredit => _$this._totalCredit;
  set totalCredit(String? totalCredit) => _$this._totalCredit = totalCredit;

  TrialBalanceReportBuilder() {
    TrialBalanceReport._defaults(this);
  }

  TrialBalanceReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _accounts = $v.accounts.toBuilder();
      _totalDebit = $v.totalDebit;
      _totalCredit = $v.totalCredit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrialBalanceReport other) {
    _$v = other as _$TrialBalanceReport;
  }

  @override
  void update(void Function(TrialBalanceReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrialBalanceReport build() => _build();

  _$TrialBalanceReport _build() {
    _$TrialBalanceReport _$result;
    try {
      _$result = _$v ??
          _$TrialBalanceReport._(
            from: from,
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'TrialBalanceReport', 'to'),
            accounts: accounts.build(),
            totalDebit: BuiltValueNullFieldError.checkNotNull(
                totalDebit, r'TrialBalanceReport', 'totalDebit'),
            totalCredit: BuiltValueNullFieldError.checkNotNull(
                totalCredit, r'TrialBalanceReport', 'totalCredit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'accounts';
        accounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TrialBalanceReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
