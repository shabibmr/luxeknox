//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_permissions_write.g.dart';

/// RolePermissionsWrite
///
/// Properties:
/// * [permissionIds] 
@BuiltValue()
abstract class RolePermissionsWrite implements Built<RolePermissionsWrite, RolePermissionsWriteBuilder> {
  @BuiltValueField(wireName: r'permission_ids')
  BuiltList<int> get permissionIds;

  RolePermissionsWrite._();

  factory RolePermissionsWrite([void updates(RolePermissionsWriteBuilder b)]) = _$RolePermissionsWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RolePermissionsWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RolePermissionsWrite> get serializer => _$RolePermissionsWriteSerializer();
}

class _$RolePermissionsWriteSerializer implements PrimitiveSerializer<RolePermissionsWrite> {
  @override
  final Iterable<Type> types = const [RolePermissionsWrite, _$RolePermissionsWrite];

  @override
  final String wireName = r'RolePermissionsWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RolePermissionsWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'permission_ids';
    yield serializers.serialize(
      object.permissionIds,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RolePermissionsWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RolePermissionsWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'permission_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.permissionIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RolePermissionsWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RolePermissionsWriteBuilder();
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


