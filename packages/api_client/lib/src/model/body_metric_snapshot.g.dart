// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_metric_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BodyMetricSnapshot extends BodyMetricSnapshot {
  @override
  final String metric;
  @override
  final num? startVal;
  @override
  final num? currentVal;
  @override
  final num? changeVal;
  @override
  final num? targetVal;

  factory _$BodyMetricSnapshot(
          [void Function(BodyMetricSnapshotBuilder)? updates]) =>
      (BodyMetricSnapshotBuilder()..update(updates))._build();

  _$BodyMetricSnapshot._(
      {required this.metric,
      this.startVal,
      this.currentVal,
      this.changeVal,
      this.targetVal})
      : super._();
  @override
  BodyMetricSnapshot rebuild(
          void Function(BodyMetricSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BodyMetricSnapshotBuilder toBuilder() =>
      BodyMetricSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BodyMetricSnapshot &&
        metric == other.metric &&
        startVal == other.startVal &&
        currentVal == other.currentVal &&
        changeVal == other.changeVal &&
        targetVal == other.targetVal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metric.hashCode);
    _$hash = $jc(_$hash, startVal.hashCode);
    _$hash = $jc(_$hash, currentVal.hashCode);
    _$hash = $jc(_$hash, changeVal.hashCode);
    _$hash = $jc(_$hash, targetVal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BodyMetricSnapshot')
          ..add('metric', metric)
          ..add('startVal', startVal)
          ..add('currentVal', currentVal)
          ..add('changeVal', changeVal)
          ..add('targetVal', targetVal))
        .toString();
  }
}

class BodyMetricSnapshotBuilder
    implements Builder<BodyMetricSnapshot, BodyMetricSnapshotBuilder> {
  _$BodyMetricSnapshot? _$v;

  String? _metric;
  String? get metric => _$this._metric;
  set metric(String? metric) => _$this._metric = metric;

  num? _startVal;
  num? get startVal => _$this._startVal;
  set startVal(num? startVal) => _$this._startVal = startVal;

  num? _currentVal;
  num? get currentVal => _$this._currentVal;
  set currentVal(num? currentVal) => _$this._currentVal = currentVal;

  num? _changeVal;
  num? get changeVal => _$this._changeVal;
  set changeVal(num? changeVal) => _$this._changeVal = changeVal;

  num? _targetVal;
  num? get targetVal => _$this._targetVal;
  set targetVal(num? targetVal) => _$this._targetVal = targetVal;

  BodyMetricSnapshotBuilder() {
    BodyMetricSnapshot._defaults(this);
  }

  BodyMetricSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metric = $v.metric;
      _startVal = $v.startVal;
      _currentVal = $v.currentVal;
      _changeVal = $v.changeVal;
      _targetVal = $v.targetVal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BodyMetricSnapshot other) {
    _$v = other as _$BodyMetricSnapshot;
  }

  @override
  void update(void Function(BodyMetricSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BodyMetricSnapshot build() => _build();

  _$BodyMetricSnapshot _build() {
    final _$result = _$v ??
        _$BodyMetricSnapshot._(
          metric: BuiltValueNullFieldError.checkNotNull(
              metric, r'BodyMetricSnapshot', 'metric'),
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
