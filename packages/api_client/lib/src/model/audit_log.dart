//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log.g.dart';

/// AuditLog
///
/// Properties:
/// * [id] 
/// * [actorUserId] 
/// * [action] 
/// * [entityName] 
/// * [entityId] 
/// * [beforeState] 
/// * [afterState] 
/// * [ipAddress] 
/// * [timestamp] - UTC ISO-8601
@BuiltValue()
abstract class AuditLog implements Built<AuditLog, AuditLogBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'actor_user_id')
  int get actorUserId;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'entity_name')
  String get entityName;

  @BuiltValueField(wireName: r'entity_id')
  int? get entityId;

  @BuiltValueField(wireName: r'before_state')
  BuiltMap<String, JsonObject?>? get beforeState;

  @BuiltValueField(wireName: r'after_state')
  BuiltMap<String, JsonObject?>? get afterState;

  @BuiltValueField(wireName: r'ip_address')
  String? get ipAddress;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  AuditLog._();

  factory AuditLog([void updates(AuditLogBuilder b)]) = _$AuditLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLog> get serializer => _$AuditLogSerializer();
}

class _$AuditLogSerializer implements PrimitiveSerializer<AuditLog> {
  @override
  final Iterable<Type> types = const [AuditLog, _$AuditLog];

  @override
  final String wireName = r'AuditLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'actor_user_id';
    yield serializers.serialize(
      object.actorUserId,
      specifiedType: const FullType(int),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'entity_name';
    yield serializers.serialize(
      object.entityName,
      specifiedType: const FullType(String),
    );
    if (object.entityId != null) {
      yield r'entity_id';
      yield serializers.serialize(
        object.entityId,
        specifiedType: const FullType(int),
      );
    }
    if (object.beforeState != null) {
      yield r'before_state';
      yield serializers.serialize(
        object.beforeState,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.afterState != null) {
      yield r'after_state';
      yield serializers.serialize(
        object.afterState,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.ipAddress != null) {
      yield r'ip_address';
      yield serializers.serialize(
        object.ipAddress,
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
    AuditLog object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditLogBuilder result,
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
        case r'actor_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.actorUserId = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'entity_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityName = valueDes;
          break;
        case r'entity_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.entityId = valueDes;
          break;
        case r'before_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.beforeState.replace(valueDes);
          break;
        case r'after_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.afterState.replace(valueDes);
          break;
        case r'ip_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ipAddress = valueDes;
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
  AuditLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogBuilder();
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


