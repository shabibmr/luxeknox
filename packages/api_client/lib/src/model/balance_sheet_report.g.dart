// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BalanceSheetReport extends BalanceSheetReport {
  @override
  final Date asOf;
  @override
  final Date fiscalYearStart;
  @override
  final BuiltList<BalanceSheetAccount> assetAccounts;
  @override
  final String totalAssets;
  @override
  final BuiltList<BalanceSheetAccount> liabilityAccounts;
  @override
  final String totalLiabilities;
  @override
  final BuiltList<BalanceSheetAccount> equityAccounts;
  @override
  final String currentYearEarnings;
  @override
  final String totalEquity;
  @override
  final String totalLiabilitiesAndEquity;

  factory _$BalanceSheetReport(
          [void Function(BalanceSheetReportBuilder)? updates]) =>
      (BalanceSheetReportBuilder()..update(updates))._build();

  _$BalanceSheetReport._(
      {required this.asOf,
      required this.fiscalYearStart,
      required this.assetAccounts,
      required this.totalAssets,
      required this.liabilityAccounts,
      required this.totalLiabilities,
      required this.equityAccounts,
      required this.currentYearEarnings,
      required this.totalEquity,
      required this.totalLiabilitiesAndEquity})
      : super._();
  @override
  BalanceSheetReport rebuild(
          void Function(BalanceSheetReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BalanceSheetReportBuilder toBuilder() =>
      BalanceSheetReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BalanceSheetReport &&
        asOf == other.asOf &&
        fiscalYearStart == other.fiscalYearStart &&
        assetAccounts == other.assetAccounts &&
        totalAssets == other.totalAssets &&
        liabilityAccounts == other.liabilityAccounts &&
        totalLiabilities == other.totalLiabilities &&
        equityAccounts == other.equityAccounts &&
        currentYearEarnings == other.currentYearEarnings &&
        totalEquity == other.totalEquity &&
        totalLiabilitiesAndEquity == other.totalLiabilitiesAndEquity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, fiscalYearStart.hashCode);
    _$hash = $jc(_$hash, assetAccounts.hashCode);
    _$hash = $jc(_$hash, totalAssets.hashCode);
    _$hash = $jc(_$hash, liabilityAccounts.hashCode);
    _$hash = $jc(_$hash, totalLiabilities.hashCode);
    _$hash = $jc(_$hash, equityAccounts.hashCode);
    _$hash = $jc(_$hash, currentYearEarnings.hashCode);
    _$hash = $jc(_$hash, totalEquity.hashCode);
    _$hash = $jc(_$hash, totalLiabilitiesAndEquity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BalanceSheetReport')
          ..add('asOf', asOf)
          ..add('fiscalYearStart', fiscalYearStart)
          ..add('assetAccounts', assetAccounts)
          ..add('totalAssets', totalAssets)
          ..add('liabilityAccounts', liabilityAccounts)
          ..add('totalLiabilities', totalLiabilities)
          ..add('equityAccounts', equityAccounts)
          ..add('currentYearEarnings', currentYearEarnings)
          ..add('totalEquity', totalEquity)
          ..add('totalLiabilitiesAndEquity', totalLiabilitiesAndEquity))
        .toString();
  }
}

class BalanceSheetReportBuilder
    implements Builder<BalanceSheetReport, BalanceSheetReportBuilder> {
  _$BalanceSheetReport? _$v;

  Date? _asOf;
  Date? get asOf => _$this._asOf;
  set asOf(Date? asOf) => _$this._asOf = asOf;

  Date? _fiscalYearStart;
  Date? get fiscalYearStart => _$this._fiscalYearStart;
  set fiscalYearStart(Date? fiscalYearStart) =>
      _$this._fiscalYearStart = fiscalYearStart;

  ListBuilder<BalanceSheetAccount>? _assetAccounts;
  ListBuilder<BalanceSheetAccount> get assetAccounts =>
      _$this._assetAccounts ??= ListBuilder<BalanceSheetAccount>();
  set assetAccounts(ListBuilder<BalanceSheetAccount>? assetAccounts) =>
      _$this._assetAccounts = assetAccounts;

  String? _totalAssets;
  String? get totalAssets => _$this._totalAssets;
  set totalAssets(String? totalAssets) => _$this._totalAssets = totalAssets;

  ListBuilder<BalanceSheetAccount>? _liabilityAccounts;
  ListBuilder<BalanceSheetAccount> get liabilityAccounts =>
      _$this._liabilityAccounts ??= ListBuilder<BalanceSheetAccount>();
  set liabilityAccounts(ListBuilder<BalanceSheetAccount>? liabilityAccounts) =>
      _$this._liabilityAccounts = liabilityAccounts;

  String? _totalLiabilities;
  String? get totalLiabilities => _$this._totalLiabilities;
  set totalLiabilities(String? totalLiabilities) =>
      _$this._totalLiabilities = totalLiabilities;

  ListBuilder<BalanceSheetAccount>? _equityAccounts;
  ListBuilder<BalanceSheetAccount> get equityAccounts =>
      _$this._equityAccounts ??= ListBuilder<BalanceSheetAccount>();
  set equityAccounts(ListBuilder<BalanceSheetAccount>? equityAccounts) =>
      _$this._equityAccounts = equityAccounts;

  String? _currentYearEarnings;
  String? get currentYearEarnings => _$this._currentYearEarnings;
  set currentYearEarnings(String? currentYearEarnings) =>
      _$this._currentYearEarnings = currentYearEarnings;

  String? _totalEquity;
  String? get totalEquity => _$this._totalEquity;
  set totalEquity(String? totalEquity) => _$this._totalEquity = totalEquity;

  String? _totalLiabilitiesAndEquity;
  String? get totalLiabilitiesAndEquity => _$this._totalLiabilitiesAndEquity;
  set totalLiabilitiesAndEquity(String? totalLiabilitiesAndEquity) =>
      _$this._totalLiabilitiesAndEquity = totalLiabilitiesAndEquity;

  BalanceSheetReportBuilder() {
    BalanceSheetReport._defaults(this);
  }

  BalanceSheetReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _asOf = $v.asOf;
      _fiscalYearStart = $v.fiscalYearStart;
      _assetAccounts = $v.assetAccounts.toBuilder();
      _totalAssets = $v.totalAssets;
      _liabilityAccounts = $v.liabilityAccounts.toBuilder();
      _totalLiabilities = $v.totalLiabilities;
      _equityAccounts = $v.equityAccounts.toBuilder();
      _currentYearEarnings = $v.currentYearEarnings;
      _totalEquity = $v.totalEquity;
      _totalLiabilitiesAndEquity = $v.totalLiabilitiesAndEquity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BalanceSheetReport other) {
    _$v = other as _$BalanceSheetReport;
  }

  @override
  void update(void Function(BalanceSheetReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BalanceSheetReport build() => _build();

  _$BalanceSheetReport _build() {
    _$BalanceSheetReport _$result;
    try {
      _$result = _$v ??
          _$BalanceSheetReport._(
            asOf: BuiltValueNullFieldError.checkNotNull(
                asOf, r'BalanceSheetReport', 'asOf'),
            fiscalYearStart: BuiltValueNullFieldError.checkNotNull(
                fiscalYearStart, r'BalanceSheetReport', 'fiscalYearStart'),
            assetAccounts: assetAccounts.build(),
            totalAssets: BuiltValueNullFieldError.checkNotNull(
                totalAssets, r'BalanceSheetReport', 'totalAssets'),
            liabilityAccounts: liabilityAccounts.build(),
            totalLiabilities: BuiltValueNullFieldError.checkNotNull(
                totalLiabilities, r'BalanceSheetReport', 'totalLiabilities'),
            equityAccounts: equityAccounts.build(),
            currentYearEarnings: BuiltValueNullFieldError.checkNotNull(
                currentYearEarnings,
                r'BalanceSheetReport',
                'currentYearEarnings'),
            totalEquity: BuiltValueNullFieldError.checkNotNull(
                totalEquity, r'BalanceSheetReport', 'totalEquity'),
            totalLiabilitiesAndEquity: BuiltValueNullFieldError.checkNotNull(
                totalLiabilitiesAndEquity,
                r'BalanceSheetReport',
                'totalLiabilitiesAndEquity'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'assetAccounts';
        assetAccounts.build();

        _$failedField = 'liabilityAccounts';
        liabilityAccounts.build();

        _$failedField = 'equityAccounts';
        equityAccounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BalanceSheetReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
