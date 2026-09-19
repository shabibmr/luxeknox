//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/membership_product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_product_page.g.dart';

/// MembershipProductPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MembershipProductPage implements Built<MembershipProductPage, MembershipProductPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MembershipProduct> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MembershipProductPage._();

  factory MembershipProductPage([void updates(MembershipProductPageBuilder b)]) = _$MembershipProductPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipProductPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipProductPage> get serializer => _$MembershipProductPageSerializer();
}

class _$MembershipProductPageSerializer implements PrimitiveSerializer<MembershipProductPage> {
  @override
  final Iterable<Type> types = const [MembershipProductPage, _$MembershipProductPage];

  @override
  final String wireName = r'MembershipProductPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipProductPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MembershipProduct)]),
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
    MembershipProductPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipProductPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MembershipProduct)]),
          ) as BuiltList<MembershipProduct>;
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
  MembershipProductPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipProductPageBuilder();
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


