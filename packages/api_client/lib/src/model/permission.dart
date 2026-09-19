//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/permission_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission.g.dart';

/// Permission
///
/// Properties:
/// * [id] 
/// * [module] 
/// * [action] 
/// * [slug] 
@BuiltValue()
abstract class Permission implements Built<Permission, PermissionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'module')
  String get module;

  @BuiltValueField(wireName: r'action')
  PermissionAction get action;
  // enum actionEnum {  create,  read,  update,  delete,  approve,  export,  broadcast,  };

  @BuiltValueField(wireName: r'slug')
  String get slug;

  Permission._();

  factory Permission([void updates(PermissionBuilder b)]) = _$Permission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Permission> get serializer => _$PermissionSerializer();
}

class _$PermissionSerializer implements PrimitiveSerializer<Permission> {
  @override
  final Iterable<Type> types = const [Permission, _$Permission];

  @override
  final String wireName = r'Permission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Permission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'module';
    yield serializers.serialize(
      object.module,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(PermissionAction),
    );
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Permission object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermissionBuilder result,
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
        case r'module':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.module = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PermissionAction),
          ) as PermissionAction;
          result.action = valueDes;
          break;
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Permission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionBuilder();
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


