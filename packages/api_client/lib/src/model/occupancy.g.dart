// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occupancy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Occupancy extends Occupancy {
  @override
  final int checkedInNow;
  @override
  final DateTime asOf;
  @override
  final BuiltList<OccupancyByGateInner> byGate;

  factory _$Occupancy([void Function(OccupancyBuilder)? updates]) =>
      (OccupancyBuilder()..update(updates))._build();

  _$Occupancy._(
      {required this.checkedInNow, required this.asOf, required this.byGate})
      : super._();
  @override
  Occupancy rebuild(void Function(OccupancyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OccupancyBuilder toBuilder() => OccupancyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Occupancy &&
        checkedInNow == other.checkedInNow &&
        asOf == other.asOf &&
        byGate == other.byGate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checkedInNow.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, byGate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Occupancy')
          ..add('checkedInNow', checkedInNow)
          ..add('asOf', asOf)
          ..add('byGate', byGate))
        .toString();
  }
}

class OccupancyBuilder implements Builder<Occupancy, OccupancyBuilder> {
  _$Occupancy? _$v;

  int? _checkedInNow;
  int? get checkedInNow => _$this._checkedInNow;
  set checkedInNow(int? checkedInNow) => _$this._checkedInNow = checkedInNow;

  DateTime? _asOf;
  DateTime? get asOf => _$this._asOf;
  set asOf(DateTime? asOf) => _$this._asOf = asOf;

  ListBuilder<OccupancyByGateInner>? _byGate;
  ListBuilder<OccupancyByGateInner> get byGate =>
      _$this._byGate ??= ListBuilder<OccupancyByGateInner>();
  set byGate(ListBuilder<OccupancyByGateInner>? byGate) =>
      _$this._byGate = byGate;

  OccupancyBuilder() {
    Occupancy._defaults(this);
  }

  OccupancyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checkedInNow = $v.checkedInNow;
      _asOf = $v.asOf;
      _byGate = $v.byGate.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Occupancy other) {
    _$v = other as _$Occupancy;
  }

  @override
  void update(void Function(OccupancyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Occupancy build() => _build();

  _$Occupancy _build() {
    _$Occupancy _$result;
    try {
      _$result = _$v ??
          _$Occupancy._(
            checkedInNow: BuiltValueNullFieldError.checkNotNull(
                checkedInNow, r'Occupancy', 'checkedInNow'),
            asOf: BuiltValueNullFieldError.checkNotNull(
                asOf, r'Occupancy', 'asOf'),
            byGate: byGate.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byGate';
        byGate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Occupancy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
