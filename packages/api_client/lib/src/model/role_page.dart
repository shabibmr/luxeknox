//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/role.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_page.g.dart';

/// RolePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class RolePage implements Built<RolePage, RolePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Role> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  RolePage._();

  factory RolePage([void updates(RolePageBuilder b)]) = _$RolePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RolePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RolePage> get serializer => _$RolePageSerializer();
}

class _$RolePageSerializer implements PrimitiveSerializer<RolePage> {
  @override
  final Iterable<Type> types = const [RolePage, _$RolePage];

  @override
  final String wireName = r'RolePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RolePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Role)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RolePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RolePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Role)]),
          ) as BuiltList<Role>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RolePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RolePageBuilder();
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


