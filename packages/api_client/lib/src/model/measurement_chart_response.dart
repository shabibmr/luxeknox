//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/longitudinal_data_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'measurement_chart_response.g.dart';

/// MeasurementChartResponse
///
/// Properties:
/// * [data] 
/// * [mandatoryMetricIds] 
@BuiltValue()
abstract class MeasurementChartResponse implements Built<MeasurementChartResponse, MeasurementChartResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<LongitudinalDataPoint> get data;

  @BuiltValueField(wireName: r'mandatory_metric_ids')
  BuiltList<int>? get mandatoryMetricIds;

  MeasurementChartResponse._();

  factory MeasurementChartResponse([void updates(MeasurementChartResponseBuilder b)]) = _$MeasurementChartResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeasurementChartResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeasurementChartResponse> get serializer => _$MeasurementChartResponseSerializer();
}

class _$MeasurementChartResponseSerializer implements PrimitiveSerializer<MeasurementChartResponse> {
  @override
  final Iterable<Type> types = const [MeasurementChartResponse, _$MeasurementChartResponse];

  @override
  final String wireName = r'MeasurementChartResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeasurementChartResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(LongitudinalDataPoint)]),
    );
    if (object.mandatoryMetricIds != null) {
      yield r'mandatory_metric_ids';
      yield serializers.serialize(
        object.mandatoryMetricIds,
        specifiedType: const FullType(BuiltList, [FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MeasurementChartResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeasurementChartResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LongitudinalDataPoint)]),
          ) as BuiltList<LongitudinalDataPoint>;
          result.data.replace(valueDes);
          break;
        case r'mandatory_metric_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(int)]),
          ) as BuiltList<int>?;
          if (valueDes == null) continue;
          result.mandatoryMetricIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeasurementChartResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeasurementChartResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


