// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_and_loss_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfitAndLossReport extends ProfitAndLossReport {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final BuiltList<ProfitAndLossAccount> incomeAccounts;
  @override
  final String totalIncome;
  @override
  final BuiltList<ProfitAndLossAccount> expenseAccounts;
  @override
  final String totalExpense;
  @override
  final String netProfit;

  factory _$ProfitAndLossReport(
          [void Function(ProfitAndLossReportBuilder)? updates]) =>
      (ProfitAndLossReportBuilder()..update(updates))._build();

  _$ProfitAndLossReport._(
      {required this.from,
      required this.to,
      required this.incomeAccounts,
      required this.totalIncome,
      required this.expenseAccounts,
      required this.totalExpense,
      required this.netProfit})
      : super._();
  @override
  ProfitAndLossReport rebuild(
          void Function(ProfitAndLossReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfitAndLossReportBuilder toBuilder() =>
      ProfitAndLossReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfitAndLossReport &&
        from == other.from &&
        to == other.to &&
        incomeAccounts == other.incomeAccounts &&
        totalIncome == other.totalIncome &&
        expenseAccounts == other.expenseAccounts &&
        totalExpense == other.totalExpense &&
        netProfit == other.netProfit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, incomeAccounts.hashCode);
    _$hash = $jc(_$hash, totalIncome.hashCode);
    _$hash = $jc(_$hash, expenseAccounts.hashCode);
    _$hash = $jc(_$hash, totalExpense.hashCode);
    _$hash = $jc(_$hash, netProfit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfitAndLossReport')
          ..add('from', from)
          ..add('to', to)
          ..add('incomeAccounts', incomeAccounts)
          ..add('totalIncome', totalIncome)
          ..add('expenseAccounts', expenseAccounts)
          ..add('totalExpense', totalExpense)
          ..add('netProfit', netProfit))
        .toString();
  }
}

class ProfitAndLossReportBuilder
    implements Builder<ProfitAndLossReport, ProfitAndLossReportBuilder> {
  _$ProfitAndLossReport? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  ListBuilder<ProfitAndLossAccount>? _incomeAccounts;
  ListBuilder<ProfitAndLossAccount> get incomeAccounts =>
      _$this._incomeAccounts ??= ListBuilder<ProfitAndLossAccount>();
  set incomeAccounts(ListBuilder<ProfitAndLossAccount>? incomeAccounts) =>
      _$this._incomeAccounts = incomeAccounts;

  String? _totalIncome;
  String? get totalIncome => _$this._totalIncome;
  set totalIncome(String? totalIncome) => _$this._totalIncome = totalIncome;

  ListBuilder<ProfitAndLossAccount>? _expenseAccounts;
  ListBuilder<ProfitAndLossAccount> get expenseAccounts =>
      _$this._expenseAccounts ??= ListBuilder<ProfitAndLossAccount>();
  set expenseAccounts(ListBuilder<ProfitAndLossAccount>? expenseAccounts) =>
      _$this._expenseAccounts = expenseAccounts;

  String? _totalExpense;
  String? get totalExpense => _$this._totalExpense;
  set totalExpense(String? totalExpense) => _$this._totalExpense = totalExpense;

  String? _netProfit;
  String? get netProfit => _$this._netProfit;
  set netProfit(String? netProfit) => _$this._netProfit = netProfit;

  ProfitAndLossReportBuilder() {
    ProfitAndLossReport._defaults(this);
  }

  ProfitAndLossReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _incomeAccounts = $v.incomeAccounts.toBuilder();
      _totalIncome = $v.totalIncome;
      _expenseAccounts = $v.expenseAccounts.toBuilder();
      _totalExpense = $v.totalExpense;
      _netProfit = $v.netProfit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfitAndLossReport other) {
    _$v = other as _$ProfitAndLossReport;
  }

  @override
  void update(void Function(ProfitAndLossReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfitAndLossReport build() => _build();

  _$ProfitAndLossReport _build() {
    _$ProfitAndLossReport _$result;
    try {
      _$result = _$v ??
          _$ProfitAndLossReport._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'ProfitAndLossReport', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'ProfitAndLossReport', 'to'),
            incomeAccounts: incomeAccounts.build(),
            totalIncome: BuiltValueNullFieldError.checkNotNull(
                totalIncome, r'ProfitAndLossReport', 'totalIncome'),
            expenseAccounts: expenseAccounts.build(),
            totalExpense: BuiltValueNullFieldError.checkNotNull(
                totalExpense, r'ProfitAndLossReport', 'totalExpense'),
            netProfit: BuiltValueNullFieldError.checkNotNull(
                netProfit, r'ProfitAndLossReport', 'netProfit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'incomeAccounts';
        incomeAccounts.build();

        _$failedField = 'expenseAccounts';
        expenseAccounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProfitAndLossReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
