//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'broadcast_request.g.dart';

/// BroadcastRequest
///
/// Properties:
/// * [notificationTypeId] 
/// * [title] 
/// * [message] 
/// * [dataPayload] 
/// * [audience] 
/// * [roleId] 
@BuiltValue()
abstract class BroadcastRequest implements Built<BroadcastRequest, BroadcastRequestBuilder> {
  @BuiltValueField(wireName: r'notification_type_id')
  int? get notificationTypeId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'data_payload')
  BuiltMap<String, JsonObject?>? get dataPayload;

  @BuiltValueField(wireName: r'audience')
  BroadcastRequestAudienceEnum? get audience;
  // enum audienceEnum {  all_members,  assigned_clients,  role,  };

  @BuiltValueField(wireName: r'role_id')
  int? get roleId;

  BroadcastRequest._();

  factory BroadcastRequest([void updates(BroadcastRequestBuilder b)]) = _$BroadcastRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BroadcastRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BroadcastRequest> get serializer => _$BroadcastRequestSerializer();
}

class _$BroadcastRequestSerializer implements PrimitiveSerializer<BroadcastRequest> {
  @override
  final Iterable<Type> types = const [BroadcastRequest, _$BroadcastRequest];

  @override
  final String wireName = r'BroadcastRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BroadcastRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.audience != null) {
      yield r'audience';
      yield serializers.serialize(
        object.audience,
        specifiedType: const FullType(BroadcastRequestAudienceEnum),
      );
    }
    if (object.roleId != null) {
      yield r'role_id';
      yield serializers.serialize(
        object.roleId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BroadcastRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BroadcastRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BroadcastRequestAudienceEnum),
          ) as BroadcastRequestAudienceEnum?;
          if (valueDes == null) continue;
          result.audience = valueDes;
          break;
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.roleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BroadcastRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BroadcastRequestBuilder();
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


class BroadcastRequestAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'all_members')
  static const BroadcastRequestAudienceEnum allMembers = _$broadcastRequestAudienceEnum_allMembers;
  @BuiltValueEnumConst(wireName: r'assigned_clients')
  static const BroadcastRequestAudienceEnum assignedClients = _$broadcastRequestAudienceEnum_assignedClients;
  @BuiltValueEnumConst(wireName: r'role')
  static const BroadcastRequestAudienceEnum role = _$broadcastRequestAudienceEnum_role;

  static Serializer<BroadcastRequestAudienceEnum> get serializer => _$broadcastRequestAudienceEnumSerializer;

  const BroadcastRequestAudienceEnum._(String name): super(name);

  static BuiltSet<BroadcastRequestAudienceEnum> get values => _$broadcastRequestAudienceEnumValues;
  static BroadcastRequestAudienceEnum valueOf(String name) => _$broadcastRequestAudienceEnumValueOf(name);
}

