//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/item_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_category_page.g.dart';

/// ItemCategoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ItemCategoryPage implements Built<ItemCategoryPage, ItemCategoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ItemCategory> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ItemCategoryPage._();

  factory ItemCategoryPage([void updates(ItemCategoryPageBuilder b)]) = _$ItemCategoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemCategoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemCategoryPage> get serializer => _$ItemCategoryPageSerializer();
}

class _$ItemCategoryPageSerializer implements PrimitiveSerializer<ItemCategoryPage> {
  @override
  final Iterable<Type> types = const [ItemCategoryPage, _$ItemCategoryPage];

  @override
  final String wireName = r'ItemCategoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemCategoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ItemCategory)]),
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
    ItemCategoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemCategoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ItemCategory)]),
          ) as BuiltList<ItemCategory>;
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
  ItemCategoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemCategoryPageBuilder();
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


