//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_write.g.dart';

/// ScheduleWrite
///
/// Properties:
/// * [seriesId] 
/// * [scheduleTypeId] 
/// * [facilityId] 
/// * [trainerId] 
/// * [title] 
/// * [startTime] - UTC ISO-8601
/// * [endTime] - UTC ISO-8601
/// * [maxCapacity] 
/// * [notes] 
/// * [rowVersion] 
/// * [recurUntil] 
@BuiltValue()
abstract class ScheduleWrite implements Built<ScheduleWrite, ScheduleWriteBuilder> {
  @BuiltValueField(wireName: r'series_id')
  int? get seriesId;

  @BuiltValueField(wireName: r'schedule_type_id')
  int? get scheduleTypeId;

  @BuiltValueField(wireName: r'facility_id')
  int? get facilityId;

  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  @BuiltValueField(wireName: r'title')
  String? get title;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'start_time')
  DateTime? get startTime;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'end_time')
  DateTime? get endTime;

  @BuiltValueField(wireName: r'max_capacity')
  int? get maxCapacity;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  @BuiltValueField(wireName: r'recur_until')
  Date? get recurUntil;

  ScheduleWrite._();

  factory ScheduleWrite([void updates(ScheduleWriteBuilder b)]) = _$ScheduleWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleWrite> get serializer => _$ScheduleWriteSerializer();
}

class _$ScheduleWriteSerializer implements PrimitiveSerializer<ScheduleWrite> {
  @override
  final Iterable<Type> types = const [ScheduleWrite, _$ScheduleWrite];

  @override
  final String wireName = r'ScheduleWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.seriesId != null) {
      yield r'series_id';
      yield serializers.serialize(
        object.seriesId,
        specifiedType: const FullType(int),
      );
    }
    if (object.scheduleTypeId != null) {
      yield r'schedule_type_id';
      yield serializers.serialize(
        object.scheduleTypeId,
        specifiedType: const FullType(int),
      );
    }
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
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.startTime != null) {
      yield r'start_time';
      yield serializers.serialize(
        object.startTime,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.endTime != null) {
      yield r'end_time';
      yield serializers.serialize(
        object.endTime,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.maxCapacity != null) {
      yield r'max_capacity';
      yield serializers.serialize(
        object.maxCapacity,
        specifiedType: const FullType(int),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.recurUntil != null) {
      yield r'recur_until';
      yield serializers.serialize(
        object.recurUntil,
        specifiedType: const FullType(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduleWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'start_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startTime = valueDes;
          break;
        case r'end_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        case r'recur_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.recurUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduleWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleWriteBuilder();
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


