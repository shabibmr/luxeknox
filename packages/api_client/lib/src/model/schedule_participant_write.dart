//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_participant_write.g.dart';

/// ScheduleParticipantWrite
///
/// Properties:
/// * [memberId] 
@BuiltValue()
abstract class ScheduleParticipantWrite implements Built<ScheduleParticipantWrite, ScheduleParticipantWriteBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  ScheduleParticipantWrite._();

  factory ScheduleParticipantWrite([void updates(ScheduleParticipantWriteBuilder b)]) = _$ScheduleParticipantWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleParticipantWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleParticipantWrite> get serializer => _$ScheduleParticipantWriteSerializer();
}

class _$ScheduleParticipantWriteSerializer implements PrimitiveSerializer<ScheduleParticipantWrite> {
  @override
  final Iterable<Type> types = const [ScheduleParticipantWrite, _$ScheduleParticipantWrite];

  @override
  final String wireName = r'ScheduleParticipantWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleParticipantWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduleParticipantWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleParticipantWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduleParticipantWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleParticipantWriteBuilder();
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


