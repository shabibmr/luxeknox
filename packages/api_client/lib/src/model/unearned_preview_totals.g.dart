// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unearned_preview_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnearnedPreviewTotals extends UnearnedPreviewTotals {
  @override
  final String unearnedMembershipTotal;
  @override
  final String unearnedPtTotal;
  @override
  final String combinedTotal;

  factory _$UnearnedPreviewTotals(
          [void Function(UnearnedPreviewTotalsBuilder)? updates]) =>
      (UnearnedPreviewTotalsBuilder()..update(updates))._build();

  _$UnearnedPreviewTotals._(
      {required this.unearnedMembershipTotal,
      required this.unearnedPtTotal,
      required this.combinedTotal})
      : super._();
  @override
  UnearnedPreviewTotals rebuild(
          void Function(UnearnedPreviewTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnearnedPreviewTotalsBuilder toBuilder() =>
      UnearnedPreviewTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnearnedPreviewTotals &&
        unearnedMembershipTotal == other.unearnedMembershipTotal &&
        unearnedPtTotal == other.unearnedPtTotal &&
        combinedTotal == other.combinedTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unearnedMembershipTotal.hashCode);
    _$hash = $jc(_$hash, unearnedPtTotal.hashCode);
    _$hash = $jc(_$hash, combinedTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnearnedPreviewTotals')
          ..add('unearnedMembershipTotal', unearnedMembershipTotal)
          ..add('unearnedPtTotal', unearnedPtTotal)
          ..add('combinedTotal', combinedTotal))
        .toString();
  }
}

class UnearnedPreviewTotalsBuilder
    implements Builder<UnearnedPreviewTotals, UnearnedPreviewTotalsBuilder> {
  _$UnearnedPreviewTotals? _$v;

  String? _unearnedMembershipTotal;
  String? get unearnedMembershipTotal => _$this._unearnedMembershipTotal;
  set unearnedMembershipTotal(String? unearnedMembershipTotal) =>
      _$this._unearnedMembershipTotal = unearnedMembershipTotal;

  String? _unearnedPtTotal;
  String? get unearnedPtTotal => _$this._unearnedPtTotal;
  set unearnedPtTotal(String? unearnedPtTotal) =>
      _$this._unearnedPtTotal = unearnedPtTotal;

  String? _combinedTotal;
  String? get combinedTotal => _$this._combinedTotal;
  set combinedTotal(String? combinedTotal) =>
      _$this._combinedTotal = combinedTotal;

  UnearnedPreviewTotalsBuilder() {
    UnearnedPreviewTotals._defaults(this);
  }

  UnearnedPreviewTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unearnedMembershipTotal = $v.unearnedMembershipTotal;
      _unearnedPtTotal = $v.unearnedPtTotal;
      _combinedTotal = $v.combinedTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnearnedPreviewTotals other) {
    _$v = other as _$UnearnedPreviewTotals;
  }

  @override
  void update(void Function(UnearnedPreviewTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnearnedPreviewTotals build() => _build();

  _$UnearnedPreviewTotals _build() {
    final _$result = _$v ??
        _$UnearnedPreviewTotals._(
          unearnedMembershipTotal: BuiltValueNullFieldError.checkNotNull(
              unearnedMembershipTotal,
              r'UnearnedPreviewTotals',
              'unearnedMembershipTotal'),
          unearnedPtTotal: BuiltValueNullFieldError.checkNotNull(
              unearnedPtTotal, r'UnearnedPreviewTotals', 'unearnedPtTotal'),
          combinedTotal: BuiltValueNullFieldError.checkNotNull(
              combinedTotal, r'UnearnedPreviewTotals', 'combinedTotal'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
