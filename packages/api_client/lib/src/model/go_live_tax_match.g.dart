// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_tax_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveTaxMatch extends GoLiveTaxMatch {
  @override
  final String gymTaxRate;
  @override
  final String defaultTaxCode;
  @override
  final String defaultTaxRate;
  @override
  final bool matched;

  factory _$GoLiveTaxMatch([void Function(GoLiveTaxMatchBuilder)? updates]) =>
      (GoLiveTaxMatchBuilder()..update(updates))._build();

  _$GoLiveTaxMatch._(
      {required this.gymTaxRate,
      required this.defaultTaxCode,
      required this.defaultTaxRate,
      required this.matched})
      : super._();
  @override
  GoLiveTaxMatch rebuild(void Function(GoLiveTaxMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveTaxMatchBuilder toBuilder() => GoLiveTaxMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveTaxMatch &&
        gymTaxRate == other.gymTaxRate &&
        defaultTaxCode == other.defaultTaxCode &&
        defaultTaxRate == other.defaultTaxRate &&
        matched == other.matched;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gymTaxRate.hashCode);
    _$hash = $jc(_$hash, defaultTaxCode.hashCode);
    _$hash = $jc(_$hash, defaultTaxRate.hashCode);
    _$hash = $jc(_$hash, matched.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveTaxMatch')
          ..add('gymTaxRate', gymTaxRate)
          ..add('defaultTaxCode', defaultTaxCode)
          ..add('defaultTaxRate', defaultTaxRate)
          ..add('matched', matched))
        .toString();
  }
}

class GoLiveTaxMatchBuilder
    implements Builder<GoLiveTaxMatch, GoLiveTaxMatchBuilder> {
  _$GoLiveTaxMatch? _$v;

  String? _gymTaxRate;
  String? get gymTaxRate => _$this._gymTaxRate;
  set gymTaxRate(String? gymTaxRate) => _$this._gymTaxRate = gymTaxRate;

  String? _defaultTaxCode;
  String? get defaultTaxCode => _$this._defaultTaxCode;
  set defaultTaxCode(String? defaultTaxCode) =>
      _$this._defaultTaxCode = defaultTaxCode;

  String? _defaultTaxRate;
  String? get defaultTaxRate => _$this._defaultTaxRate;
  set defaultTaxRate(String? defaultTaxRate) =>
      _$this._defaultTaxRate = defaultTaxRate;

  bool? _matched;
  bool? get matched => _$this._matched;
  set matched(bool? matched) => _$this._matched = matched;

  GoLiveTaxMatchBuilder() {
    GoLiveTaxMatch._defaults(this);
  }

  GoLiveTaxMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gymTaxRate = $v.gymTaxRate;
      _defaultTaxCode = $v.defaultTaxCode;
      _defaultTaxRate = $v.defaultTaxRate;
      _matched = $v.matched;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveTaxMatch other) {
    _$v = other as _$GoLiveTaxMatch;
  }

  @override
  void update(void Function(GoLiveTaxMatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveTaxMatch build() => _build();

  _$GoLiveTaxMatch _build() {
    final _$result = _$v ??
        _$GoLiveTaxMatch._(
          gymTaxRate: BuiltValueNullFieldError.checkNotNull(
              gymTaxRate, r'GoLiveTaxMatch', 'gymTaxRate'),
          defaultTaxCode: BuiltValueNullFieldError.checkNotNull(
              defaultTaxCode, r'GoLiveTaxMatch', 'defaultTaxCode'),
          defaultTaxRate: BuiltValueNullFieldError.checkNotNull(
              defaultTaxRate, r'GoLiveTaxMatch', 'defaultTaxRate'),
          matched: BuiltValueNullFieldError.checkNotNull(
              matched, r'GoLiveTaxMatch', 'matched'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
