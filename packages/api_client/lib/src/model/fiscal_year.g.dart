// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fiscal_year.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FiscalYear extends FiscalYear {
  @override
  final int id;
  @override
  final String label;
  @override
  final Date startsOn;
  @override
  final Date endsOn;

  factory _$FiscalYear([void Function(FiscalYearBuilder)? updates]) =>
      (FiscalYearBuilder()..update(updates))._build();

  _$FiscalYear._(
      {required this.id,
      required this.label,
      required this.startsOn,
      required this.endsOn})
      : super._();
  @override
  FiscalYear rebuild(void Function(FiscalYearBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FiscalYearBuilder toBuilder() => FiscalYearBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FiscalYear &&
        id == other.id &&
        label == other.label &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FiscalYear')
          ..add('id', id)
          ..add('label', label)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn))
        .toString();
  }
}

class FiscalYearBuilder implements Builder<FiscalYear, FiscalYearBuilder> {
  _$FiscalYear? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  Date? _endsOn;
  Date? get endsOn => _$this._endsOn;
  set endsOn(Date? endsOn) => _$this._endsOn = endsOn;

  FiscalYearBuilder() {
    FiscalYear._defaults(this);
  }

  FiscalYearBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FiscalYear other) {
    _$v = other as _$FiscalYear;
  }

  @override
  void update(void Function(FiscalYearBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FiscalYear build() => _build();

  _$FiscalYear _build() {
    final _$result = _$v ??
        _$FiscalYear._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FiscalYear', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'FiscalYear', 'label'),
          startsOn: BuiltValueNullFieldError.checkNotNull(
              startsOn, r'FiscalYear', 'startsOn'),
          endsOn: BuiltValueNullFieldError.checkNotNull(
              endsOn, r'FiscalYear', 'endsOn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
