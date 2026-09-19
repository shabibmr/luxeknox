//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/food.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food_page.g.dart';

/// FoodPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class FoodPage implements Built<FoodPage, FoodPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Food> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  FoodPage._();

  factory FoodPage([void updates(FoodPageBuilder b)]) = _$FoodPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoodPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FoodPage> get serializer => _$FoodPageSerializer();
}

class _$FoodPageSerializer implements PrimitiveSerializer<FoodPage> {
  @override
  final Iterable<Type> types = const [FoodPage, _$FoodPage];

  @override
  final String wireName = r'FoodPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FoodPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Food)]),
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
    FoodPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FoodPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Food)]),
          ) as BuiltList<Food>;
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
  FoodPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoodPageBuilder();
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


