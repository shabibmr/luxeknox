//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/measurement_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'measurement.g.dart';

/// Measurement
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [recordedByUserId] 
/// * [recordedAt] - UTC ISO-8601
/// * [notes] 
/// * [values] 
@BuiltValue()
abstract class Measurement implements Built<Measurement, MeasurementBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'recorded_by_user_id')
  int? get recordedByUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'recorded_at')
  DateTime get recordedAt;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'values')
  BuiltList<MeasurementValue>? get values;

  Measurement._();

  factory Measurement([void updates(MeasurementBuilder b)]) = _$Measurement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeasurementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Measurement> get serializer => _$MeasurementSerializer();
}

class _$MeasurementSerializer implements PrimitiveSerializer<Measurement> {
  @override
  final Iterable<Type> types = const [Measurement, _$Measurement];

  @override
  final String wireName = r'Measurement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Measurement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    if (object.recordedByUserId != null) {
      yield r'recorded_by_user_id';
      yield serializers.serialize(
        object.recordedByUserId,
        specifiedType: const FullType(int),
      );
    }
    yield r'recorded_at';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.values != null) {
      yield r'values';
      yield serializers.serialize(
        object.values,
        specifiedType: const FullType(BuiltList, [FullType(MeasurementValue)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Measurement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeasurementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'recorded_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recordedByUserId = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(MeasurementValue)]),
          ) as BuiltList<MeasurementValue>?;
          if (valueDes == null) continue;
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
  Measurement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeasurementBuilder();
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


