// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_chart_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeasurementChartResponse extends MeasurementChartResponse {
  @override
  final BuiltList<LongitudinalDataPoint> data;
  @override
  final BuiltList<int>? mandatoryMetricIds;

  factory _$MeasurementChartResponse(
          [void Function(MeasurementChartResponseBuilder)? updates]) =>
      (MeasurementChartResponseBuilder()..update(updates))._build();

  _$MeasurementChartResponse._({required this.data, this.mandatoryMetricIds})
      : super._();
  @override
  MeasurementChartResponse rebuild(
          void Function(MeasurementChartResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeasurementChartResponseBuilder toBuilder() =>
      MeasurementChartResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeasurementChartResponse &&
        data == other.data &&
        mandatoryMetricIds == other.mandatoryMetricIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, mandatoryMetricIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeasurementChartResponse')
          ..add('data', data)
          ..add('mandatoryMetricIds', mandatoryMetricIds))
        .toString();
  }
}

class MeasurementChartResponseBuilder
    implements
        Builder<MeasurementChartResponse, MeasurementChartResponseBuilder> {
  _$MeasurementChartResponse? _$v;

  ListBuilder<LongitudinalDataPoint>? _data;
  ListBuilder<LongitudinalDataPoint> get data =>
      _$this._data ??= ListBuilder<LongitudinalDataPoint>();
  set data(ListBuilder<LongitudinalDataPoint>? data) => _$this._data = data;

  ListBuilder<int>? _mandatoryMetricIds;
  ListBuilder<int> get mandatoryMetricIds =>
      _$this._mandatoryMetricIds ??= ListBuilder<int>();
  set mandatoryMetricIds(ListBuilder<int>? mandatoryMetricIds) =>
      _$this._mandatoryMetricIds = mandatoryMetricIds;

  MeasurementChartResponseBuilder() {
    MeasurementChartResponse._defaults(this);
  }

  MeasurementChartResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _mandatoryMetricIds = $v.mandatoryMetricIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeasurementChartResponse other) {
    _$v = other as _$MeasurementChartResponse;
  }

  @override
  void update(void Function(MeasurementChartResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeasurementChartResponse build() => _build();

  _$MeasurementChartResponse _build() {
    _$MeasurementChartResponse _$result;
    try {
      _$result = _$v ??
          _$MeasurementChartResponse._(
            data: data.build(),
            mandatoryMetricIds: _mandatoryMetricIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'mandatoryMetricIds';
        _mandatoryMetricIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MeasurementChartResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
