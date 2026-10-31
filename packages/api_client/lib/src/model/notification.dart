//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification.g.dart';

/// Notification
///
/// Properties:
/// * [id] 
/// * [notificationTypeId] 
/// * [title] 
/// * [message] 
/// * [dataPayload] 
/// * [senderUserId] 
/// * [createdAt] - UTC ISO-8601
/// * [priority] 
/// * [typeCode] 
/// * [isRead] 
/// * [readAt] 
@BuiltValue()
abstract class Notification implements Built<Notification, NotificationBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'notification_type_id')
  int? get notificationTypeId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'data_payload')
  BuiltMap<String, JsonObject?>? get dataPayload;

  @BuiltValueField(wireName: r'sender_user_id')
  int? get senderUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'priority')
  NotificationPriorityEnum? get priority;
  // enum priorityEnum {  normal,  high,  };

  @BuiltValueField(wireName: r'type_code')
  NotificationTypeCodeEnum? get typeCode;
  // enum typeCodeEnum {  membership_expiry,  session_reminder,  payment_due,  announcement,  freeze_pending,  booking_confirmed,  booking_cancelled,  session_waitlist_promoted,  trainer_assigned,  broadcast,  workout_safety_alert,  };

  @BuiltValueField(wireName: r'is_read')
  bool? get isRead;

  @BuiltValueField(wireName: r'read_at')
  DateTime? get readAt;

  Notification._();

  factory Notification([void updates(NotificationBuilder b)]) = _$Notification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationBuilder b) => b
      ..priority = NotificationPriorityEnum.valueOf('normal');

  @BuiltValueSerializer(custom: true)
  static Serializer<Notification> get serializer => _$NotificationSerializer();
}

class _$NotificationSerializer implements PrimitiveSerializer<Notification> {
  @override
  final Iterable<Type> types = const [Notification, _$Notification];

  @override
  final String wireName = r'Notification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Notification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    if (object.notificationTypeId != null) {
      yield r'notification_type_id';
      yield serializers.serialize(
        object.notificationTypeId,
        specifiedType: const FullType(int),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    if (object.dataPayload != null) {
      yield r'data_payload';
      yield serializers.serialize(
        object.dataPayload,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.senderUserId != null) {
      yield r'sender_user_id';
      yield serializers.serialize(
        object.senderUserId,
        specifiedType: const FullType(int),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType: const FullType(NotificationPriorityEnum),
      );
    }
    if (object.typeCode != null) {
      yield r'type_code';
      yield serializers.serialize(
        object.typeCode,
        specifiedType: const FullType(NotificationTypeCodeEnum),
      );
    }
    if (object.isRead != null) {
      yield r'is_read';
      yield serializers.serialize(
        object.isRead,
        specifiedType: const FullType(bool),
      );
    }
    if (object.readAt != null) {
      yield r'read_at';
      yield serializers.serialize(
        object.readAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Notification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationBuilder result,
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
        case r'notification_type_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.notificationTypeId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'data_payload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.dataPayload.replace(valueDes);
          break;
        case r'sender_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.senderUserId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NotificationPriorityEnum),
          ) as NotificationPriorityEnum?;
          if (valueDes == null) continue;
          result.priority = valueDes;
          break;
        case r'type_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NotificationTypeCodeEnum),
          ) as NotificationTypeCodeEnum?;
          if (valueDes == null) continue;
          result.typeCode = valueDes;
          break;
        case r'is_read':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isRead = valueDes;
          break;
        case r'read_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Notification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationBuilder();
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


class NotificationPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'normal')
  static const NotificationPriorityEnum normal = _$notificationPriorityEnum_normal;
  @BuiltValueEnumConst(wireName: r'high')
  static const NotificationPriorityEnum high = _$notificationPriorityEnum_high;

  static Serializer<NotificationPriorityEnum> get serializer => _$notificationPriorityEnumSerializer;

  const NotificationPriorityEnum._(String name): super(name);

  static BuiltSet<NotificationPriorityEnum> get values => _$notificationPriorityEnumValues;
  static NotificationPriorityEnum valueOf(String name) => _$notificationPriorityEnumValueOf(name);
}

class NotificationTypeCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'membership_expiry')
  static const NotificationTypeCodeEnum membershipExpiry = _$notificationTypeCodeEnum_membershipExpiry;
  @BuiltValueEnumConst(wireName: r'session_reminder')
  static const NotificationTypeCodeEnum sessionReminder = _$notificationTypeCodeEnum_sessionReminder;
  @BuiltValueEnumConst(wireName: r'payment_due')
  static const NotificationTypeCodeEnum paymentDue = _$notificationTypeCodeEnum_paymentDue;
  @BuiltValueEnumConst(wireName: r'announcement')
  static const NotificationTypeCodeEnum announcement = _$notificationTypeCodeEnum_announcement;
  @BuiltValueEnumConst(wireName: r'freeze_pending')
  static const NotificationTypeCodeEnum freezePending = _$notificationTypeCodeEnum_freezePending;
  @BuiltValueEnumConst(wireName: r'booking_confirmed')
  static const NotificationTypeCodeEnum bookingConfirmed = _$notificationTypeCodeEnum_bookingConfirmed;
  @BuiltValueEnumConst(wireName: r'booking_cancelled')
  static const NotificationTypeCodeEnum bookingCancelled = _$notificationTypeCodeEnum_bookingCancelled;
  @BuiltValueEnumConst(wireName: r'session_waitlist_promoted')
  static const NotificationTypeCodeEnum sessionWaitlistPromoted = _$notificationTypeCodeEnum_sessionWaitlistPromoted;
  @BuiltValueEnumConst(wireName: r'trainer_assigned')
  static const NotificationTypeCodeEnum trainerAssigned = _$notificationTypeCodeEnum_trainerAssigned;
  @BuiltValueEnumConst(wireName: r'broadcast')
  static const NotificationTypeCodeEnum broadcast = _$notificationTypeCodeEnum_broadcast;
  @BuiltValueEnumConst(wireName: r'workout_safety_alert')
  static const NotificationTypeCodeEnum workoutSafetyAlert = _$notificationTypeCodeEnum_workoutSafetyAlert;

  static Serializer<NotificationTypeCodeEnum> get serializer => _$notificationTypeCodeEnumSerializer;

  const NotificationTypeCodeEnum._(String name): super(name);

  static BuiltSet<NotificationTypeCodeEnum> get values => _$notificationTypeCodeEnumValues;
  static NotificationTypeCodeEnum valueOf(String name) => _$notificationTypeCodeEnumValueOf(name);
}

