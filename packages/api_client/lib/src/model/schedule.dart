//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/schedule_status.dart';
import 'package:api_client/src/model/schedule_participant.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule.g.dart';

/// Schedule
///
/// Properties:
/// * [id] 
/// * [seriesId] 
/// * [scheduleTypeId] 
/// * [facilityId] 
/// * [trainerId] 
/// * [title] 
/// * [startTime] - UTC ISO-8601
/// * [endTime] - UTC ISO-8601
/// * [maxCapacity] 
/// * [status] 
/// * [notes] 
/// * [rowVersion] 
/// * [participants] 
@BuiltValue()
abstract class Schedule implements Built<Schedule, ScheduleBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'series_id')
  int? get seriesId;

  @BuiltValueField(wireName: r'schedule_type_id')
  int get scheduleTypeId;

  @BuiltValueField(wireName: r'facility_id')
  int? get facilityId;

  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  @BuiltValueField(wireName: r'title')
  String get title;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'start_time')
  DateTime get startTime;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'end_time')
  DateTime get endTime;

  @BuiltValueField(wireName: r'max_capacity')
  int? get maxCapacity;

  @BuiltValueField(wireName: r'status')
  ScheduleStatus get status;
  // enum statusEnum {  scheduled,  ongoing,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'participants')
  BuiltList<ScheduleParticipant>? get participants;

  Schedule._();

  factory Schedule([void updates(ScheduleBuilder b)]) = _$Schedule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Schedule> get serializer => _$ScheduleSerializer();
}

class _$ScheduleSerializer implements PrimitiveSerializer<Schedule> {
  @override
  final Iterable<Type> types = const [Schedule, _$Schedule];

  @override
  final String wireName = r'Schedule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Schedule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    if (object.seriesId != null) {
      yield r'series_id';
      yield serializers.serialize(
        object.seriesId,
        specifiedType: const FullType(int),
      );
    }
    yield r'schedule_type_id';
    yield serializers.serialize(
      object.scheduleTypeId,
      specifiedType: const FullType(int),
    );
    if (object.facilityId != null) {
      yield r'facility_id';
      yield serializers.serialize(
        object.facilityId,
        specifiedType: const FullType(int),
      );
    }
    if (object.trainerId != null) {
      yield r'trainer_id';
      yield serializers.serialize(
        object.trainerId,
        specifiedType: const FullType(int),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'start_time';
    yield serializers.serialize(
      object.startTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'end_time';
    yield serializers.serialize(
      object.endTime,
      specifiedType: const FullType(DateTime),
    );
    if (object.maxCapacity != null) {
      yield r'max_capacity';
      yield serializers.serialize(
        object.maxCapacity,
        specifiedType: const FullType(int),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ScheduleStatus),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    if (object.participants != null) {
      yield r'participants';
      yield serializers.serialize(
        object.participants,
        specifiedType: const FullType(BuiltList, [FullType(ScheduleParticipant)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Schedule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleBuilder result,
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
        case r'series_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.seriesId = valueDes;
          break;
        case r'schedule_type_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.scheduleTypeId = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.facilityId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.trainerId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'start_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startTime = valueDes;
          break;
        case r'end_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endTime = valueDes;
          break;
        case r'max_capacity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxCapacity = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScheduleStatus),
          ) as ScheduleStatus;
          result.status = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ScheduleParticipant)]),
          ) as BuiltList<ScheduleParticipant>?;
          if (valueDes == null) continue;
          result.participants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Schedule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleBuilder();
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


