// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeasurementValue extends MeasurementValue {
  @override
  final int? id;
  @override
  final int? measurementId;
  @override
  final int metricId;
  @override
  final num value;

  factory _$MeasurementValue(
          [void Function(MeasurementValueBuilder)? updates]) =>
      (MeasurementValueBuilder()..update(updates))._build();

  _$MeasurementValue._(
      {this.id,
      this.measurementId,
      required this.metricId,
      required this.value})
      : super._();
  @override
  MeasurementValue rebuild(void Function(MeasurementValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeasurementValueBuilder toBuilder() =>
      MeasurementValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeasurementValue &&
        id == other.id &&
        measurementId == other.measurementId &&
        metricId == other.metricId &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, measurementId.hashCode);
    _$hash = $jc(_$hash, metricId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeasurementValue')
          ..add('id', id)
          ..add('measurementId', measurementId)
          ..add('metricId', metricId)
          ..add('value', value))
        .toString();
  }
}

class MeasurementValueBuilder
    implements Builder<MeasurementValue, MeasurementValueBuilder> {
  _$MeasurementValue? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _measurementId;
  int? get measurementId => _$this._measurementId;
  set measurementId(int? measurementId) =>
      _$this._measurementId = measurementId;

  int? _metricId;
  int? get metricId => _$this._metricId;
  set metricId(int? metricId) => _$this._metricId = metricId;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  MeasurementValueBuilder() {
    MeasurementValue._defaults(this);
  }

  MeasurementValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _measurementId = $v.measurementId;
      _metricId = $v.metricId;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeasurementValue other) {
    _$v = other as _$MeasurementValue;
  }

  @override
  void update(void Function(MeasurementValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeasurementValue build() => _build();

  _$MeasurementValue _build() {
    final _$result = _$v ??
        _$MeasurementValue._(
          id: id,
          measurementId: measurementId,
          metricId: BuiltValueNullFieldError.checkNotNull(
              metricId, r'MeasurementValue', 'metricId'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'MeasurementValue', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
