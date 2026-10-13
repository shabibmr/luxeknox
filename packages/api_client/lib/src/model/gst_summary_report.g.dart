// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gst_summary_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GstSummaryReport extends GstSummaryReport {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final BuiltList<GstTaxCodeSummary> taxCodes;
  @override
  final String totalTaxableValue;
  @override
  final String outputCgst;
  @override
  final String outputSgst;
  @override
  final String outputIgst;
  @override
  final String totalOutputTax;
  @override
  final String inputTaxCredit;
  @override
  final String netPayable;

  factory _$GstSummaryReport(
          [void Function(GstSummaryReportBuilder)? updates]) =>
      (GstSummaryReportBuilder()..update(updates))._build();

  _$GstSummaryReport._(
      {required this.from,
      required this.to,
      required this.taxCodes,
      required this.totalTaxableValue,
      required this.outputCgst,
      required this.outputSgst,
      required this.outputIgst,
      required this.totalOutputTax,
      required this.inputTaxCredit,
      required this.netPayable})
      : super._();
  @override
  GstSummaryReport rebuild(void Function(GstSummaryReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GstSummaryReportBuilder toBuilder() =>
      GstSummaryReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GstSummaryReport &&
        from == other.from &&
        to == other.to &&
        taxCodes == other.taxCodes &&
        totalTaxableValue == other.totalTaxableValue &&
        outputCgst == other.outputCgst &&
        outputSgst == other.outputSgst &&
        outputIgst == other.outputIgst &&
        totalOutputTax == other.totalOutputTax &&
        inputTaxCredit == other.inputTaxCredit &&
        netPayable == other.netPayable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, taxCodes.hashCode);
    _$hash = $jc(_$hash, totalTaxableValue.hashCode);
    _$hash = $jc(_$hash, outputCgst.hashCode);
    _$hash = $jc(_$hash, outputSgst.hashCode);
    _$hash = $jc(_$hash, outputIgst.hashCode);
    _$hash = $jc(_$hash, totalOutputTax.hashCode);
    _$hash = $jc(_$hash, inputTaxCredit.hashCode);
    _$hash = $jc(_$hash, netPayable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GstSummaryReport')
          ..add('from', from)
          ..add('to', to)
          ..add('taxCodes', taxCodes)
          ..add('totalTaxableValue', totalTaxableValue)
          ..add('outputCgst', outputCgst)
          ..add('outputSgst', outputSgst)
          ..add('outputIgst', outputIgst)
          ..add('totalOutputTax', totalOutputTax)
          ..add('inputTaxCredit', inputTaxCredit)
          ..add('netPayable', netPayable))
        .toString();
  }
}

class GstSummaryReportBuilder
    implements Builder<GstSummaryReport, GstSummaryReportBuilder> {
  _$GstSummaryReport? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  ListBuilder<GstTaxCodeSummary>? _taxCodes;
  ListBuilder<GstTaxCodeSummary> get taxCodes =>
      _$this._taxCodes ??= ListBuilder<GstTaxCodeSummary>();
  set taxCodes(ListBuilder<GstTaxCodeSummary>? taxCodes) =>
      _$this._taxCodes = taxCodes;

  String? _totalTaxableValue;
  String? get totalTaxableValue => _$this._totalTaxableValue;
  set totalTaxableValue(String? totalTaxableValue) =>
      _$this._totalTaxableValue = totalTaxableValue;

  String? _outputCgst;
  String? get outputCgst => _$this._outputCgst;
  set outputCgst(String? outputCgst) => _$this._outputCgst = outputCgst;

  String? _outputSgst;
  String? get outputSgst => _$this._outputSgst;
  set outputSgst(String? outputSgst) => _$this._outputSgst = outputSgst;

  String? _outputIgst;
  String? get outputIgst => _$this._outputIgst;
  set outputIgst(String? outputIgst) => _$this._outputIgst = outputIgst;

  String? _totalOutputTax;
  String? get totalOutputTax => _$this._totalOutputTax;
  set totalOutputTax(String? totalOutputTax) =>
      _$this._totalOutputTax = totalOutputTax;

  String? _inputTaxCredit;
  String? get inputTaxCredit => _$this._inputTaxCredit;
  set inputTaxCredit(String? inputTaxCredit) =>
      _$this._inputTaxCredit = inputTaxCredit;

  String? _netPayable;
  String? get netPayable => _$this._netPayable;
  set netPayable(String? netPayable) => _$this._netPayable = netPayable;

  GstSummaryReportBuilder() {
    GstSummaryReport._defaults(this);
  }

  GstSummaryReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _taxCodes = $v.taxCodes.toBuilder();
      _totalTaxableValue = $v.totalTaxableValue;
      _outputCgst = $v.outputCgst;
      _outputSgst = $v.outputSgst;
      _outputIgst = $v.outputIgst;
      _totalOutputTax = $v.totalOutputTax;
      _inputTaxCredit = $v.inputTaxCredit;
      _netPayable = $v.netPayable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GstSummaryReport other) {
    _$v = other as _$GstSummaryReport;
  }

  @override
  void update(void Function(GstSummaryReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GstSummaryReport build() => _build();

  _$GstSummaryReport _build() {
    _$GstSummaryReport _$result;
    try {
      _$result = _$v ??
          _$GstSummaryReport._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'GstSummaryReport', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'GstSummaryReport', 'to'),
            taxCodes: taxCodes.build(),
            totalTaxableValue: BuiltValueNullFieldError.checkNotNull(
                totalTaxableValue, r'GstSummaryReport', 'totalTaxableValue'),
            outputCgst: BuiltValueNullFieldError.checkNotNull(
                outputCgst, r'GstSummaryReport', 'outputCgst'),
            outputSgst: BuiltValueNullFieldError.checkNotNull(
                outputSgst, r'GstSummaryReport', 'outputSgst'),
            outputIgst: BuiltValueNullFieldError.checkNotNull(
                outputIgst, r'GstSummaryReport', 'outputIgst'),
            totalOutputTax: BuiltValueNullFieldError.checkNotNull(
                totalOutputTax, r'GstSummaryReport', 'totalOutputTax'),
            inputTaxCredit: BuiltValueNullFieldError.checkNotNull(
                inputTaxCredit, r'GstSummaryReport', 'inputTaxCredit'),
            netPayable: BuiltValueNullFieldError.checkNotNull(
                netPayable, r'GstSummaryReport', 'netPayable'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'taxCodes';
        taxCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GstSummaryReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
