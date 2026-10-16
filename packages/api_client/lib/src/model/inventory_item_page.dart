//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/inventory_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_item_page.g.dart';

/// InventoryItemPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class InventoryItemPage implements Built<InventoryItemPage, InventoryItemPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<InventoryItem> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  InventoryItemPage._();

  factory InventoryItemPage([void updates(InventoryItemPageBuilder b)]) = _$InventoryItemPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryItemPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryItemPage> get serializer => _$InventoryItemPageSerializer();
}

class _$InventoryItemPageSerializer implements PrimitiveSerializer<InventoryItemPage> {
  @override
  final Iterable<Type> types = const [InventoryItemPage, _$InventoryItemPage];

  @override
  final String wireName = r'InventoryItemPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(InventoryItem)]),
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
    InventoryItemPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryItemPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InventoryItem)]),
          ) as BuiltList<InventoryItem>;
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
  InventoryItemPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryItemPageBuilder();
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


