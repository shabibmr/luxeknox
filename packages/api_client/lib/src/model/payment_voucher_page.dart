//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/payment_voucher.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_voucher_page.g.dart';

/// PaymentVoucherPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class PaymentVoucherPage implements Built<PaymentVoucherPage, PaymentVoucherPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PaymentVoucher> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  PaymentVoucherPage._();

  factory PaymentVoucherPage([void updates(PaymentVoucherPageBuilder b)]) = _$PaymentVoucherPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentVoucherPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentVoucherPage> get serializer => _$PaymentVoucherPageSerializer();
}

class _$PaymentVoucherPageSerializer implements PrimitiveSerializer<PaymentVoucherPage> {
  @override
  final Iterable<Type> types = const [PaymentVoucherPage, _$PaymentVoucherPage];

  @override
  final String wireName = r'PaymentVoucherPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentVoucherPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PaymentVoucher)]),
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
    PaymentVoucherPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentVoucherPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentVoucher)]),
          ) as BuiltList<PaymentVoucher>;
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
  PaymentVoucherPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentVoucherPageBuilder();
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


