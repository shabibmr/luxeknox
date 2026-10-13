// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_book_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DayBookReport extends DayBookReport {
  @override
  final Date date;
  @override
  final BuiltList<DayBookJournal> journals;
  @override
  final String totalDebit;
  @override
  final String totalCredit;

  factory _$DayBookReport([void Function(DayBookReportBuilder)? updates]) =>
      (DayBookReportBuilder()..update(updates))._build();

  _$DayBookReport._(
      {required this.date,
      required this.journals,
      required this.totalDebit,
      required this.totalCredit})
      : super._();
  @override
  DayBookReport rebuild(void Function(DayBookReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayBookReportBuilder toBuilder() => DayBookReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayBookReport &&
        date == other.date &&
        journals == other.journals &&
        totalDebit == other.totalDebit &&
        totalCredit == other.totalCredit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, journals.hashCode);
    _$hash = $jc(_$hash, totalDebit.hashCode);
    _$hash = $jc(_$hash, totalCredit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DayBookReport')
          ..add('date', date)
          ..add('journals', journals)
          ..add('totalDebit', totalDebit)
          ..add('totalCredit', totalCredit))
        .toString();
  }
}

class DayBookReportBuilder
    implements Builder<DayBookReport, DayBookReportBuilder> {
  _$DayBookReport? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  ListBuilder<DayBookJournal>? _journals;
  ListBuilder<DayBookJournal> get journals =>
      _$this._journals ??= ListBuilder<DayBookJournal>();
  set journals(ListBuilder<DayBookJournal>? journals) =>
      _$this._journals = journals;

  String? _totalDebit;
  String? get totalDebit => _$this._totalDebit;
  set totalDebit(String? totalDebit) => _$this._totalDebit = totalDebit;

  String? _totalCredit;
  String? get totalCredit => _$this._totalCredit;
  set totalCredit(String? totalCredit) => _$this._totalCredit = totalCredit;

  DayBookReportBuilder() {
    DayBookReport._defaults(this);
  }

  DayBookReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _journals = $v.journals.toBuilder();
      _totalDebit = $v.totalDebit;
      _totalCredit = $v.totalCredit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DayBookReport other) {
    _$v = other as _$DayBookReport;
  }

  @override
  void update(void Function(DayBookReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayBookReport build() => _build();

  _$DayBookReport _build() {
    _$DayBookReport _$result;
    try {
      _$result = _$v ??
          _$DayBookReport._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DayBookReport', 'date'),
            journals: journals.build(),
            totalDebit: BuiltValueNullFieldError.checkNotNull(
                totalDebit, r'DayBookReport', 'totalDebit'),
            totalCredit: BuiltValueNullFieldError.checkNotNull(
                totalCredit, r'DayBookReport', 'totalCredit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'journals';
        journals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DayBookReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
