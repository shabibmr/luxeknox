//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_check_in_write.g.dart';

/// GoalCheckInWrite
///
/// Properties:
/// * [recordedValue] 
/// * [recordedDate] 
/// * [notes] 
@BuiltValue()
abstract class GoalCheckInWrite implements Built<GoalCheckInWrite, GoalCheckInWriteBuilder> {
  @BuiltValueField(wireName: r'recorded_value')
  num get recordedValue;

  @BuiltValueField(wireName: r'recorded_date')
  Date? get recordedDate;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  GoalCheckInWrite._();

  factory GoalCheckInWrite([void updates(GoalCheckInWriteBuilder b)]) = _$GoalCheckInWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalCheckInWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalCheckInWrite> get serializer => _$GoalCheckInWriteSerializer();
}

class _$GoalCheckInWriteSerializer implements PrimitiveSerializer<GoalCheckInWrite> {
  @override
  final Iterable<Type> types = const [GoalCheckInWrite, _$GoalCheckInWrite];

  @override
  final String wireName = r'GoalCheckInWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalCheckInWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recorded_value';
    yield serializers.serialize(
      object.recordedValue,
      specifiedType: const FullType(num),
    );
    if (object.recordedDate != null) {
      yield r'recorded_date';
      yield serializers.serialize(
        object.recordedDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoalCheckInWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalCheckInWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recorded_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.recordedValue = valueDes;
          break;
        case r'recorded_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.recordedDate = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoalCheckInWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalCheckInWriteBuilder();
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


