// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occupancy_by_gate_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OccupancyByGateInner extends OccupancyByGateInner {
  @override
  final String gateIdentifier;
  @override
  final int count;

  factory _$OccupancyByGateInner(
          [void Function(OccupancyByGateInnerBuilder)? updates]) =>
      (OccupancyByGateInnerBuilder()..update(updates))._build();

  _$OccupancyByGateInner._({required this.gateIdentifier, required this.count})
      : super._();
  @override
  OccupancyByGateInner rebuild(
          void Function(OccupancyByGateInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OccupancyByGateInnerBuilder toBuilder() =>
      OccupancyByGateInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OccupancyByGateInner &&
        gateIdentifier == other.gateIdentifier &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gateIdentifier.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OccupancyByGateInner')
          ..add('gateIdentifier', gateIdentifier)
          ..add('count', count))
        .toString();
  }
}

class OccupancyByGateInnerBuilder
    implements Builder<OccupancyByGateInner, OccupancyByGateInnerBuilder> {
  _$OccupancyByGateInner? _$v;

  String? _gateIdentifier;
  String? get gateIdentifier => _$this._gateIdentifier;
  set gateIdentifier(String? gateIdentifier) =>
      _$this._gateIdentifier = gateIdentifier;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  OccupancyByGateInnerBuilder() {
    OccupancyByGateInner._defaults(this);
  }

  OccupancyByGateInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gateIdentifier = $v.gateIdentifier;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OccupancyByGateInner other) {
    _$v = other as _$OccupancyByGateInner;
  }

  @override
  void update(void Function(OccupancyByGateInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OccupancyByGateInner build() => _build();

  _$OccupancyByGateInner _build() {
    final _$result = _$v ??
        _$OccupancyByGateInner._(
          gateIdentifier: BuiltValueNullFieldError.checkNotNull(
              gateIdentifier, r'OccupancyByGateInner', 'gateIdentifier'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'OccupancyByGateInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
