//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_participant.g.dart';

/// ScheduleParticipant
///
/// Properties:
/// * [id] 
/// * [scheduleId] 
/// * [memberId] 
/// * [bookingStatus] 
/// * [attended] 
/// * [bookedAt] - UTC ISO-8601
/// * [markedAt] 
@BuiltValue()
abstract class ScheduleParticipant implements Built<ScheduleParticipant, ScheduleParticipantBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'schedule_id')
  int get scheduleId;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'booking_status')
  ScheduleParticipantBookingStatusEnum get bookingStatus;
  // enum bookingStatusEnum {  booked,  waitlisted,  cancelled,  };

  @BuiltValueField(wireName: r'attended')
  bool? get attended;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'booked_at')
  DateTime? get bookedAt;

  @BuiltValueField(wireName: r'marked_at')
  DateTime? get markedAt;

  ScheduleParticipant._();

  factory ScheduleParticipant([void updates(ScheduleParticipantBuilder b)]) = _$ScheduleParticipant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleParticipantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleParticipant> get serializer => _$ScheduleParticipantSerializer();
}

class _$ScheduleParticipantSerializer implements PrimitiveSerializer<ScheduleParticipant> {
  @override
  final Iterable<Type> types = const [ScheduleParticipant, _$ScheduleParticipant];

  @override
  final String wireName = r'ScheduleParticipant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleParticipant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'schedule_id';
    yield serializers.serialize(
      object.scheduleId,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'booking_status';
    yield serializers.serialize(
      object.bookingStatus,
      specifiedType: const FullType(ScheduleParticipantBookingStatusEnum),
    );
    if (object.attended != null) {
      yield r'attended';
      yield serializers.serialize(
        object.attended,
        specifiedType: const FullType(bool),
      );
    }
    if (object.bookedAt != null) {
      yield r'booked_at';
      yield serializers.serialize(
        object.bookedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.markedAt != null) {
      yield r'marked_at';
      yield serializers.serialize(
        object.markedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduleParticipant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleParticipantBuilder result,
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
        case r'schedule_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.scheduleId = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'booking_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScheduleParticipantBookingStatusEnum),
          ) as ScheduleParticipantBookingStatusEnum;
          result.bookingStatus = valueDes;
          break;
        case r'attended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.attended = valueDes;
          break;
        case r'booked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.bookedAt = valueDes;
          break;
        case r'marked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.markedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduleParticipant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleParticipantBuilder();
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


class ScheduleParticipantBookingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'booked')
  static const ScheduleParticipantBookingStatusEnum booked = _$scheduleParticipantBookingStatusEnum_booked;
  @BuiltValueEnumConst(wireName: r'waitlisted')
  static const ScheduleParticipantBookingStatusEnum waitlisted = _$scheduleParticipantBookingStatusEnum_waitlisted;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ScheduleParticipantBookingStatusEnum cancelled = _$scheduleParticipantBookingStatusEnum_cancelled;

  static Serializer<ScheduleParticipantBookingStatusEnum> get serializer => _$scheduleParticipantBookingStatusEnumSerializer;

  const ScheduleParticipantBookingStatusEnum._(String name): super(name);

  static BuiltSet<ScheduleParticipantBookingStatusEnum> get values => _$scheduleParticipantBookingStatusEnumValues;
  static ScheduleParticipantBookingStatusEnum valueOf(String name) => _$scheduleParticipantBookingStatusEnumValueOf(name);
}

