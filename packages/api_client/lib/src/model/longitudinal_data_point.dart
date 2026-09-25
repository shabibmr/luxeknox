//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'longitudinal_data_point.g.dart';

/// LongitudinalDataPoint
///
/// Properties:
/// * [measurementId] 
/// * [recordedAt] - UTC ISO-8601
/// * [metricId] 
/// * [metricName] 
/// * [unitOfMeasure] 
/// * [value] 
@BuiltValue()
abstract class LongitudinalDataPoint implements Built<LongitudinalDataPoint, LongitudinalDataPointBuilder> {
  @BuiltValueField(wireName: r'measurement_id')
  int get measurementId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'recorded_at')
  DateTime get recordedAt;

  @BuiltValueField(wireName: r'metric_id')
  int get metricId;

  @BuiltValueField(wireName: r'metric_name')
  String get metricName;

  @BuiltValueField(wireName: r'unit_of_measure')
  String get unitOfMeasure;

  @BuiltValueField(wireName: r'value')
  num get value;

  LongitudinalDataPoint._();

  factory LongitudinalDataPoint([void updates(LongitudinalDataPointBuilder b)]) = _$LongitudinalDataPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LongitudinalDataPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LongitudinalDataPoint> get serializer => _$LongitudinalDataPointSerializer();
}

class _$LongitudinalDataPointSerializer implements PrimitiveSerializer<LongitudinalDataPoint> {
  @override
  final Iterable<Type> types = const [LongitudinalDataPoint, _$LongitudinalDataPoint];

  @override
  final String wireName = r'LongitudinalDataPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LongitudinalDataPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'measurement_id';
    yield serializers.serialize(
      object.measurementId,
      specifiedType: const FullType(int),
    );
    yield r'recorded_at';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'metric_id';
    yield serializers.serialize(
      object.metricId,
      specifiedType: const FullType(int),
    );
    yield r'metric_name';
    yield serializers.serialize(
      object.metricName,
      specifiedType: const FullType(String),
    );
    yield r'unit_of_measure';
    yield serializers.serialize(
      object.unitOfMeasure,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LongitudinalDataPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LongitudinalDataPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'measurement_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.measurementId = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        case r'metric_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.metricId = valueDes;
          break;
        case r'metric_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.metricName = valueDes;
          break;
        case r'unit_of_measure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitOfMeasure = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LongitudinalDataPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LongitudinalDataPointBuilder();
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


