//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'measurement_value.g.dart';

/// MeasurementValue
///
/// Properties:
/// * [id] 
/// * [measurementId] 
/// * [metricId] 
/// * [value] 
@BuiltValue()
abstract class MeasurementValue implements Built<MeasurementValue, MeasurementValueBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'measurement_id')
  int? get measurementId;

  @BuiltValueField(wireName: r'metric_id')
  int get metricId;

  @BuiltValueField(wireName: r'value')
  num get value;

  MeasurementValue._();

  factory MeasurementValue([void updates(MeasurementValueBuilder b)]) = _$MeasurementValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeasurementValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeasurementValue> get serializer => _$MeasurementValueSerializer();
}

class _$MeasurementValueSerializer implements PrimitiveSerializer<MeasurementValue> {
  @override
  final Iterable<Type> types = const [MeasurementValue, _$MeasurementValue];

  @override
  final String wireName = r'MeasurementValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeasurementValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.measurementId != null) {
      yield r'measurement_id';
      yield serializers.serialize(
        object.measurementId,
        specifiedType: const FullType(int),
      );
    }
    yield r'metric_id';
    yield serializers.serialize(
      object.metricId,
      specifiedType: const FullType(int),
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
    MeasurementValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeasurementValueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'measurement_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.measurementId = valueDes;
          break;
        case r'metric_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.metricId = valueDes;
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
  MeasurementValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeasurementValueBuilder();
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


