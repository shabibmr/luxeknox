//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/uom.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'uom_page.g.dart';

/// UomPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class UomPage implements Built<UomPage, UomPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Uom> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  UomPage._();

  factory UomPage([void updates(UomPageBuilder b)]) = _$UomPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UomPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UomPage> get serializer => _$UomPageSerializer();
}

class _$UomPageSerializer implements PrimitiveSerializer<UomPage> {
  @override
  final Iterable<Type> types = const [UomPage, _$UomPage];

  @override
  final String wireName = r'UomPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UomPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Uom)]),
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
    UomPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UomPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Uom)]),
          ) as BuiltList<Uom>;
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
  UomPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UomPageBuilder();
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


