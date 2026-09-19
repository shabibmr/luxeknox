//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_role_request.g.dart';

/// AssignRoleRequest
///
/// Properties:
/// * [roleId] 
@BuiltValue()
abstract class AssignRoleRequest implements Built<AssignRoleRequest, AssignRoleRequestBuilder> {
  @BuiltValueField(wireName: r'role_id')
  int get roleId;

  AssignRoleRequest._();

  factory AssignRoleRequest([void updates(AssignRoleRequestBuilder b)]) = _$AssignRoleRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignRoleRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignRoleRequest> get serializer => _$AssignRoleRequestSerializer();
}

class _$AssignRoleRequestSerializer implements PrimitiveSerializer<AssignRoleRequest> {
  @override
  final Iterable<Type> types = const [AssignRoleRequest, _$AssignRoleRequest];

  @override
  final String wireName = r'AssignRoleRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignRoleRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role_id';
    yield serializers.serialize(
      object.roleId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignRoleRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssignRoleRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  AssignRoleRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignRoleRequestBuilder();
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


