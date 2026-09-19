//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/measurement_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'measurement_write.g.dart';

/// MeasurementWrite
///
/// Properties:
/// * [recordedAt] - UTC ISO-8601
/// * [notes] 
/// * [values] 
@BuiltValue()
abstract class MeasurementWrite implements Built<MeasurementWrite, MeasurementWriteBuilder> {
  /// UTC ISO-8601
  @BuiltValueField(wireName: r'recorded_at')
  DateTime? get recordedAt;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'values')
  BuiltList<MeasurementValue> get values;

  MeasurementWrite._();

  factory MeasurementWrite([void updates(MeasurementWriteBuilder b)]) = _$MeasurementWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeasurementWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeasurementWrite> get serializer => _$MeasurementWriteSerializer();
}

class _$MeasurementWriteSerializer implements PrimitiveSerializer<MeasurementWrite> {
  @override
  final Iterable<Type> types = const [MeasurementWrite, _$MeasurementWrite];

  @override
  final String wireName = r'MeasurementWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeasurementWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.recordedAt != null) {
      yield r'recorded_at';
      yield serializers.serialize(
        object.recordedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    yield r'values';
    yield serializers.serialize(
      object.values,
      specifiedType: const FullType(BuiltList, [FullType(MeasurementValue)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MeasurementWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeasurementWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.recordedAt = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MeasurementValue)]),
          ) as BuiltList<MeasurementValue>;
          result.values.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeasurementWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeasurementWriteBuilder();
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


