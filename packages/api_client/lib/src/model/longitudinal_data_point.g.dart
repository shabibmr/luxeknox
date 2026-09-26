// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'longitudinal_data_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LongitudinalDataPoint extends LongitudinalDataPoint {
  @override
  final int measurementId;
  @override
  final DateTime recordedAt;
  @override
  final int metricId;
  @override
  final String metricName;
  @override
  final String unitOfMeasure;
  @override
  final num value;

  factory _$LongitudinalDataPoint(
          [void Function(LongitudinalDataPointBuilder)? updates]) =>
      (LongitudinalDataPointBuilder()..update(updates))._build();

  _$LongitudinalDataPoint._(
      {required this.measurementId,
      required this.recordedAt,
      required this.metricId,
      required this.metricName,
      required this.unitOfMeasure,
      required this.value})
      : super._();
  @override
  LongitudinalDataPoint rebuild(
          void Function(LongitudinalDataPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LongitudinalDataPointBuilder toBuilder() =>
      LongitudinalDataPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LongitudinalDataPoint &&
        measurementId == other.measurementId &&
        recordedAt == other.recordedAt &&
        metricId == other.metricId &&
        metricName == other.metricName &&
        unitOfMeasure == other.unitOfMeasure &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, measurementId.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, metricId.hashCode);
    _$hash = $jc(_$hash, metricName.hashCode);
    _$hash = $jc(_$hash, unitOfMeasure.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LongitudinalDataPoint')
          ..add('measurementId', measurementId)
          ..add('recordedAt', recordedAt)
          ..add('metricId', metricId)
          ..add('metricName', metricName)
          ..add('unitOfMeasure', unitOfMeasure)
          ..add('value', value))
        .toString();
  }
}

class LongitudinalDataPointBuilder
    implements Builder<LongitudinalDataPoint, LongitudinalDataPointBuilder> {
  _$LongitudinalDataPoint? _$v;

  int? _measurementId;
  int? get measurementId => _$this._measurementId;
  set measurementId(int? measurementId) =>
      _$this._measurementId = measurementId;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  int? _metricId;
  int? get metricId => _$this._metricId;
  set metricId(int? metricId) => _$this._metricId = metricId;

  String? _metricName;
  String? get metricName => _$this._metricName;
  set metricName(String? metricName) => _$this._metricName = metricName;

  String? _unitOfMeasure;
  String? get unitOfMeasure => _$this._unitOfMeasure;
  set unitOfMeasure(String? unitOfMeasure) =>
      _$this._unitOfMeasure = unitOfMeasure;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  LongitudinalDataPointBuilder() {
    LongitudinalDataPoint._defaults(this);
  }

  LongitudinalDataPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _measurementId = $v.measurementId;
      _recordedAt = $v.recordedAt;
      _metricId = $v.metricId;
      _metricName = $v.metricName;
      _unitOfMeasure = $v.unitOfMeasure;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LongitudinalDataPoint other) {
    _$v = other as _$LongitudinalDataPoint;
  }

  @override
  void update(void Function(LongitudinalDataPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LongitudinalDataPoint build() => _build();

  _$LongitudinalDataPoint _build() {
    final _$result = _$v ??
        _$LongitudinalDataPoint._(
          measurementId: BuiltValueNullFieldError.checkNotNull(
              measurementId, r'LongitudinalDataPoint', 'measurementId'),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'LongitudinalDataPoint', 'recordedAt'),
          metricId: BuiltValueNullFieldError.checkNotNull(
              metricId, r'LongitudinalDataPoint', 'metricId'),
          metricName: BuiltValueNullFieldError.checkNotNull(
              metricName, r'LongitudinalDataPoint', 'metricName'),
          unitOfMeasure: BuiltValueNullFieldError.checkNotNull(
              unitOfMeasure, r'LongitudinalDataPoint', 'unitOfMeasure'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'LongitudinalDataPoint', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
