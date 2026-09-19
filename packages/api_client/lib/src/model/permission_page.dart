//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/permission.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_page.g.dart';

/// PermissionPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class PermissionPage implements Built<PermissionPage, PermissionPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Permission> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  PermissionPage._();

  factory PermissionPage([void updates(PermissionPageBuilder b)]) = _$PermissionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionPage> get serializer => _$PermissionPageSerializer();
}

class _$PermissionPageSerializer implements PrimitiveSerializer<PermissionPage> {
  @override
  final Iterable<Type> types = const [PermissionPage, _$PermissionPage];

  @override
  final String wireName = r'PermissionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Permission)]),
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
    PermissionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermissionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Permission)]),
          ) as BuiltList<Permission>;
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
  PermissionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionPageBuilder();
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


