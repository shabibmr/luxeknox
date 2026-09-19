//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_history.g.dart';

/// ScheduleHistory
///
/// Properties:
/// * [id] 
/// * [scheduleId] 
/// * [action] 
/// * [changedByUserId] 
/// * [notes] 
/// * [timestamp] - UTC ISO-8601
@BuiltValue()
abstract class ScheduleHistory implements Built<ScheduleHistory, ScheduleHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'schedule_id')
  int get scheduleId;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'changed_by_user_id')
  int? get changedByUserId;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  ScheduleHistory._();

  factory ScheduleHistory([void updates(ScheduleHistoryBuilder b)]) = _$ScheduleHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleHistory> get serializer => _$ScheduleHistorySerializer();
}

class _$ScheduleHistorySerializer implements PrimitiveSerializer<ScheduleHistory> {
  @override
  final Iterable<Type> types = const [ScheduleHistory, _$ScheduleHistory];

  @override
  final String wireName = r'ScheduleHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleHistory object, {
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
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    if (object.changedByUserId != null) {
      yield r'changed_by_user_id';
      yield serializers.serialize(
        object.changedByUserId,
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
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduleHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleHistoryBuilder result,
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
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'changed_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.changedByUserId = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduleHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleHistoryBuilder();
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


