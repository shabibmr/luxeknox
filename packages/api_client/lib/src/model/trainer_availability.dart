//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_availability.g.dart';

/// TrainerAvailability
///
/// Properties:
/// * [id] 
/// * [trainerId] 
/// * [dayOfWeek] 
/// * [startTime] 
/// * [endTime] 
/// * [isRecurring] 
/// * [overrideDate] 
/// * [isAvailable] 
@BuiltValue()
abstract class TrainerAvailability implements Built<TrainerAvailability, TrainerAvailabilityBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'day_of_week')
  int? get dayOfWeek;

  @BuiltValueField(wireName: r'start_time')
  String? get startTime;

  @BuiltValueField(wireName: r'end_time')
  String? get endTime;

  @BuiltValueField(wireName: r'is_recurring')
  bool? get isRecurring;

  @BuiltValueField(wireName: r'override_date')
  Date? get overrideDate;

  @BuiltValueField(wireName: r'is_available')
  bool get isAvailable;

  TrainerAvailability._();

  factory TrainerAvailability([void updates(TrainerAvailabilityBuilder b)]) = _$TrainerAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerAvailability> get serializer => _$TrainerAvailabilitySerializer();
}

class _$TrainerAvailabilitySerializer implements PrimitiveSerializer<TrainerAvailability> {
  @override
  final Iterable<Type> types = const [TrainerAvailability, _$TrainerAvailability];

  @override
  final String wireName = r'TrainerAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
    if (object.dayOfWeek != null) {
      yield r'day_of_week';
      yield serializers.serialize(
        object.dayOfWeek,
        specifiedType: const FullType(int),
      );
    }
    if (object.startTime != null) {
      yield r'start_time';
      yield serializers.serialize(
        object.startTime,
        specifiedType: const FullType(String),
      );
    }
    if (object.endTime != null) {
      yield r'end_time';
      yield serializers.serialize(
        object.endTime,
        specifiedType: const FullType(String),
      );
    }
    if (object.isRecurring != null) {
      yield r'is_recurring';
      yield serializers.serialize(
        object.isRecurring,
        specifiedType: const FullType(bool),
      );
    }
    if (object.overrideDate != null) {
      yield r'override_date';
      yield serializers.serialize(
        object.overrideDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'is_available';
    yield serializers.serialize(
      object.isAvailable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainerAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerAvailabilityBuilder result,
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
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
        case r'day_of_week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dayOfWeek = valueDes;
          break;
        case r'start_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.startTime = valueDes;
          break;
        case r'end_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endTime = valueDes;
          break;
        case r'is_recurring':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isRecurring = valueDes;
          break;
        case r'override_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.overrideDate = valueDes;
          break;
        case r'is_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAvailable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainerAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerAvailabilityBuilder();
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


