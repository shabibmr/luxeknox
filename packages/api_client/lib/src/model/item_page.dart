//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_page.g.dart';

/// ItemPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ItemPage implements Built<ItemPage, ItemPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Item> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ItemPage._();

  factory ItemPage([void updates(ItemPageBuilder b)]) = _$ItemPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemPage> get serializer => _$ItemPageSerializer();
}

class _$ItemPageSerializer implements PrimitiveSerializer<ItemPage> {
  @override
  final Iterable<Type> types = const [ItemPage, _$ItemPage];

  @override
  final String wireName = r'ItemPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Item)]),
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
    ItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Item)]),
          ) as BuiltList<Item>;
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
  ItemPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemPageBuilder();
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


