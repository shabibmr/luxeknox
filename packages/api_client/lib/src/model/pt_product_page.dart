//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/pt_product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_product_page.g.dart';

/// PtProductPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class PtProductPage implements Built<PtProductPage, PtProductPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PtProduct> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  PtProductPage._();

  factory PtProductPage([void updates(PtProductPageBuilder b)]) = _$PtProductPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProductPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProductPage> get serializer => _$PtProductPageSerializer();
}

class _$PtProductPageSerializer implements PrimitiveSerializer<PtProductPage> {
  @override
  final Iterable<Type> types = const [PtProductPage, _$PtProductPage];

  @override
  final String wireName = r'PtProductPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProductPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PtProduct)]),
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
    PtProductPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProductPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PtProduct)]),
          ) as BuiltList<PtProduct>;
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
  PtProductPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProductPageBuilder();
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


