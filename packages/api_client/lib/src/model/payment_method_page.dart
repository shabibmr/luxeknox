//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/payment_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_method_page.g.dart';

/// PaymentMethodPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class PaymentMethodPage implements Built<PaymentMethodPage, PaymentMethodPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PaymentMethod> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  PaymentMethodPage._();

  factory PaymentMethodPage([void updates(PaymentMethodPageBuilder b)]) = _$PaymentMethodPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentMethodPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentMethodPage> get serializer => _$PaymentMethodPageSerializer();
}

class _$PaymentMethodPageSerializer implements PrimitiveSerializer<PaymentMethodPage> {
  @override
  final Iterable<Type> types = const [PaymentMethodPage, _$PaymentMethodPage];

  @override
  final String wireName = r'PaymentMethodPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentMethodPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PaymentMethod)]),
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
    PaymentMethodPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentMethodPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentMethod)]),
          ) as BuiltList<PaymentMethod>;
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
  PaymentMethodPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentMethodPageBuilder();
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


