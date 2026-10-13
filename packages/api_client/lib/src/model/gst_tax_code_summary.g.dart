// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gst_tax_code_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GstTaxCodeSummary extends GstTaxCodeSummary {
  @override
  final int taxCodeId;
  @override
  final String taxCodeName;
  @override
  final String ratePercent;
  @override
  final String taxableValue;
  @override
  final String cgstAmount;
  @override
  final String sgstAmount;
  @override
  final String igstAmount;
  @override
  final String totalTax;

  factory _$GstTaxCodeSummary(
          [void Function(GstTaxCodeSummaryBuilder)? updates]) =>
      (GstTaxCodeSummaryBuilder()..update(updates))._build();

  _$GstTaxCodeSummary._(
      {required this.taxCodeId,
      required this.taxCodeName,
      required this.ratePercent,
      required this.taxableValue,
      required this.cgstAmount,
      required this.sgstAmount,
      required this.igstAmount,
      required this.totalTax})
      : super._();
  @override
  GstTaxCodeSummary rebuild(void Function(GstTaxCodeSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GstTaxCodeSummaryBuilder toBuilder() =>
      GstTaxCodeSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GstTaxCodeSummary &&
        taxCodeId == other.taxCodeId &&
        taxCodeName == other.taxCodeName &&
        ratePercent == other.ratePercent &&
        taxableValue == other.taxableValue &&
        cgstAmount == other.cgstAmount &&
        sgstAmount == other.sgstAmount &&
        igstAmount == other.igstAmount &&
        totalTax == other.totalTax;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, taxCodeName.hashCode);
    _$hash = $jc(_$hash, ratePercent.hashCode);
    _$hash = $jc(_$hash, taxableValue.hashCode);
    _$hash = $jc(_$hash, cgstAmount.hashCode);
    _$hash = $jc(_$hash, sgstAmount.hashCode);
    _$hash = $jc(_$hash, igstAmount.hashCode);
    _$hash = $jc(_$hash, totalTax.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GstTaxCodeSummary')
          ..add('taxCodeId', taxCodeId)
          ..add('taxCodeName', taxCodeName)
          ..add('ratePercent', ratePercent)
          ..add('taxableValue', taxableValue)
          ..add('cgstAmount', cgstAmount)
          ..add('sgstAmount', sgstAmount)
          ..add('igstAmount', igstAmount)
          ..add('totalTax', totalTax))
        .toString();
  }
}

class GstTaxCodeSummaryBuilder
    implements Builder<GstTaxCodeSummary, GstTaxCodeSummaryBuilder> {
  _$GstTaxCodeSummary? _$v;

  int? _taxCodeId;
  int? get taxCodeId => _$this._taxCodeId;
  set taxCodeId(int? taxCodeId) => _$this._taxCodeId = taxCodeId;

  String? _taxCodeName;
  String? get taxCodeName => _$this._taxCodeName;
  set taxCodeName(String? taxCodeName) => _$this._taxCodeName = taxCodeName;

  String? _ratePercent;
  String? get ratePercent => _$this._ratePercent;
  set ratePercent(String? ratePercent) => _$this._ratePercent = ratePercent;

  String? _taxableValue;
  String? get taxableValue => _$this._taxableValue;
  set taxableValue(String? taxableValue) => _$this._taxableValue = taxableValue;

  String? _cgstAmount;
  String? get cgstAmount => _$this._cgstAmount;
  set cgstAmount(String? cgstAmount) => _$this._cgstAmount = cgstAmount;

  String? _sgstAmount;
  String? get sgstAmount => _$this._sgstAmount;
  set sgstAmount(String? sgstAmount) => _$this._sgstAmount = sgstAmount;

  String? _igstAmount;
  String? get igstAmount => _$this._igstAmount;
  set igstAmount(String? igstAmount) => _$this._igstAmount = igstAmount;

  String? _totalTax;
  String? get totalTax => _$this._totalTax;
  set totalTax(String? totalTax) => _$this._totalTax = totalTax;

  GstTaxCodeSummaryBuilder() {
    GstTaxCodeSummary._defaults(this);
  }

  GstTaxCodeSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _taxCodeId = $v.taxCodeId;
      _taxCodeName = $v.taxCodeName;
      _ratePercent = $v.ratePercent;
      _taxableValue = $v.taxableValue;
      _cgstAmount = $v.cgstAmount;
      _sgstAmount = $v.sgstAmount;
      _igstAmount = $v.igstAmount;
      _totalTax = $v.totalTax;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GstTaxCodeSummary other) {
    _$v = other as _$GstTaxCodeSummary;
  }

  @override
  void update(void Function(GstTaxCodeSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GstTaxCodeSummary build() => _build();

  _$GstTaxCodeSummary _build() {
    final _$result = _$v ??
        _$GstTaxCodeSummary._(
          taxCodeId: BuiltValueNullFieldError.checkNotNull(
              taxCodeId, r'GstTaxCodeSummary', 'taxCodeId'),
          taxCodeName: BuiltValueNullFieldError.checkNotNull(
              taxCodeName, r'GstTaxCodeSummary', 'taxCodeName'),
          ratePercent: BuiltValueNullFieldError.checkNotNull(
              ratePercent, r'GstTaxCodeSummary', 'ratePercent'),
          taxableValue: BuiltValueNullFieldError.checkNotNull(
              taxableValue, r'GstTaxCodeSummary', 'taxableValue'),
          cgstAmount: BuiltValueNullFieldError.checkNotNull(
              cgstAmount, r'GstTaxCodeSummary', 'cgstAmount'),
          sgstAmount: BuiltValueNullFieldError.checkNotNull(
              sgstAmount, r'GstTaxCodeSummary', 'sgstAmount'),
          igstAmount: BuiltValueNullFieldError.checkNotNull(
              igstAmount, r'GstTaxCodeSummary', 'igstAmount'),
          totalTax: BuiltValueNullFieldError.checkNotNull(
              totalTax, r'GstTaxCodeSummary', 'totalTax'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
