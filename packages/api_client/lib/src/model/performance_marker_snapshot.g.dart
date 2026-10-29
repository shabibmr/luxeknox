// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_marker_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PerformanceMarkerSnapshot extends PerformanceMarkerSnapshot {
  @override
  final String marker;
  @override
  final String? startVal;
  @override
  final String? currentVal;
  @override
  final String? changeVal;
  @override
  final String? targetVal;

  factory _$PerformanceMarkerSnapshot(
          [void Function(PerformanceMarkerSnapshotBuilder)? updates]) =>
      (PerformanceMarkerSnapshotBuilder()..update(updates))._build();

  _$PerformanceMarkerSnapshot._(
      {required this.marker,
      this.startVal,
      this.currentVal,
      this.changeVal,
      this.targetVal})
      : super._();
  @override
  PerformanceMarkerSnapshot rebuild(
          void Function(PerformanceMarkerSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PerformanceMarkerSnapshotBuilder toBuilder() =>
      PerformanceMarkerSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PerformanceMarkerSnapshot &&
        marker == other.marker &&
        startVal == other.startVal &&
        currentVal == other.currentVal &&
        changeVal == other.changeVal &&
        targetVal == other.targetVal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, marker.hashCode);
    _$hash = $jc(_$hash, startVal.hashCode);
    _$hash = $jc(_$hash, currentVal.hashCode);
    _$hash = $jc(_$hash, changeVal.hashCode);
    _$hash = $jc(_$hash, targetVal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PerformanceMarkerSnapshot')
          ..add('marker', marker)
          ..add('startVal', startVal)
          ..add('currentVal', currentVal)
          ..add('changeVal', changeVal)
          ..add('targetVal', targetVal))
        .toString();
  }
}

class PerformanceMarkerSnapshotBuilder
    implements
        Builder<PerformanceMarkerSnapshot, PerformanceMarkerSnapshotBuilder> {
  _$PerformanceMarkerSnapshot? _$v;

  String? _marker;
  String? get marker => _$this._marker;
  set marker(String? marker) => _$this._marker = marker;

  String? _startVal;
  String? get startVal => _$this._startVal;
  set startVal(String? startVal) => _$this._startVal = startVal;

  String? _currentVal;
  String? get currentVal => _$this._currentVal;
  set currentVal(String? currentVal) => _$this._currentVal = currentVal;

  String? _changeVal;
  String? get changeVal => _$this._changeVal;
  set changeVal(String? changeVal) => _$this._changeVal = changeVal;

  String? _targetVal;
  String? get targetVal => _$this._targetVal;
  set targetVal(String? targetVal) => _$this._targetVal = targetVal;

  PerformanceMarkerSnapshotBuilder() {
    PerformanceMarkerSnapshot._defaults(this);
  }

  PerformanceMarkerSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _marker = $v.marker;
      _startVal = $v.startVal;
      _currentVal = $v.currentVal;
      _changeVal = $v.changeVal;
      _targetVal = $v.targetVal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PerformanceMarkerSnapshot other) {
    _$v = other as _$PerformanceMarkerSnapshot;
  }

  @override
  void update(void Function(PerformanceMarkerSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PerformanceMarkerSnapshot build() => _build();

  _$PerformanceMarkerSnapshot _build() {
    final _$result = _$v ??
        _$PerformanceMarkerSnapshot._(
          marker: BuiltValueNullFieldError.checkNotNull(
              marker, r'PerformanceMarkerSnapshot', 'marker'),
          startVal: startVal,
          currentVal: currentVal,
          changeVal: changeVal,
          targetVal: targetVal,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
