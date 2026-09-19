//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/user_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'principal.g.dart';

/// Principal
///
/// Properties:
/// * [userId] 
/// * [userType] 
/// * [role] 
/// * [roleId] 
/// * [profileId] 
/// * [permissions] 
@BuiltValue()
abstract class Principal implements Built<Principal, PrincipalBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'user_type')
  UserType get userType;
  // enum userTypeEnum {  member,  trainer,  employee,  admin,  };

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'role_id')
  int? get roleId;

  @BuiltValueField(wireName: r'profile_id')
  int? get profileId;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  Principal._();

  factory Principal([void updates(PrincipalBuilder b)]) = _$Principal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrincipalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Principal> get serializer => _$PrincipalSerializer();
}

class _$PrincipalSerializer implements PrimitiveSerializer<Principal> {
  @override
  final Iterable<Type> types = const [Principal, _$Principal];

  @override
  final String wireName = r'Principal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Principal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'user_type';
    yield serializers.serialize(
      object.userType,
      specifiedType: const FullType(UserType),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    if (object.roleId != null) {
      yield r'role_id';
      yield serializers.serialize(
        object.roleId,
        specifiedType: const FullType(int),
      );
    }
    if (object.profileId != null) {
      yield r'profile_id';
      yield serializers.serialize(
        object.profileId,
        specifiedType: const FullType(int),
      );
    }
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Principal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrincipalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'user_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserType),
          ) as UserType;
          result.userType = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.roleId = valueDes;
          break;
        case r'profile_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.profileId = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Principal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrincipalBuilder();
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


