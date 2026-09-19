//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/user_type.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard.g.dart';

/// Widgets present depend on the principal. Missing keys mean unauthorized or empty, not an error.
///
/// Properties:
/// * [role] 
/// * [member] 
/// * [trainer] 
/// * [admin] 
@BuiltValue()
abstract class Dashboard implements Built<Dashboard, DashboardBuilder> {
  @BuiltValueField(wireName: r'role')
  UserType? get role;
  // enum roleEnum {  member,  trainer,  employee,  admin,  };

  @BuiltValueField(wireName: r'member')
  BuiltMap<String, JsonObject?>? get member;

  @BuiltValueField(wireName: r'trainer')
  BuiltMap<String, JsonObject?>? get trainer;

  @BuiltValueField(wireName: r'admin')
  BuiltMap<String, JsonObject?>? get admin;

  Dashboard._();

  factory Dashboard([void updates(DashboardBuilder b)]) = _$Dashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Dashboard> get serializer => _$DashboardSerializer();
}

class _$DashboardSerializer implements PrimitiveSerializer<Dashboard> {
  @override
  final Iterable<Type> types = const [Dashboard, _$Dashboard];

  @override
  final String wireName = r'Dashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Dashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(UserType),
      );
    }
    if (object.member != null) {
      yield r'member';
      yield serializers.serialize(
        object.member,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.trainer != null) {
      yield r'trainer';
      yield serializers.serialize(
        object.trainer,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.admin != null) {
      yield r'admin';
      yield serializers.serialize(
        object.admin,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Dashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserType),
          ) as UserType?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'member':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.member.replace(valueDes);
          break;
        case r'trainer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.trainer.replace(valueDes);
          break;
        case r'admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.admin.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Dashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardBuilder();
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


