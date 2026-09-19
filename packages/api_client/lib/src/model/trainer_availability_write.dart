//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/trainer_availability.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_availability_write.g.dart';

/// TrainerAvailabilityWrite
///
/// Properties:
/// * [slots] 
@BuiltValue()
abstract class TrainerAvailabilityWrite implements Built<TrainerAvailabilityWrite, TrainerAvailabilityWriteBuilder> {
  @BuiltValueField(wireName: r'slots')
  BuiltList<TrainerAvailability> get slots;

  TrainerAvailabilityWrite._();

  factory TrainerAvailabilityWrite([void updates(TrainerAvailabilityWriteBuilder b)]) = _$TrainerAvailabilityWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerAvailabilityWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerAvailabilityWrite> get serializer => _$TrainerAvailabilityWriteSerializer();
}

class _$TrainerAvailabilityWriteSerializer implements PrimitiveSerializer<TrainerAvailabilityWrite> {
  @override
  final Iterable<Type> types = const [TrainerAvailabilityWrite, _$TrainerAvailabilityWrite];

  @override
  final String wireName = r'TrainerAvailabilityWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerAvailabilityWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'slots';
    yield serializers.serialize(
      object.slots,
      specifiedType: const FullType(BuiltList, [FullType(TrainerAvailability)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainerAvailabilityWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerAvailabilityWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TrainerAvailability)]),
          ) as BuiltList<TrainerAvailability>;
          result.slots.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainerAvailabilityWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerAvailabilityWriteBuilder();
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


