//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/purchase_bill.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill_page.g.dart';

/// PurchaseBillPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class PurchaseBillPage implements Built<PurchaseBillPage, PurchaseBillPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PurchaseBill> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  PurchaseBillPage._();

  factory PurchaseBillPage([void updates(PurchaseBillPageBuilder b)]) = _$PurchaseBillPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseBillPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseBillPage> get serializer => _$PurchaseBillPageSerializer();
}

class _$PurchaseBillPageSerializer implements PrimitiveSerializer<PurchaseBillPage> {
  @override
  final Iterable<Type> types = const [PurchaseBillPage, _$PurchaseBillPage];

  @override
  final String wireName = r'PurchaseBillPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseBillPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PurchaseBill)]),
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
    PurchaseBillPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseBillPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PurchaseBill)]),
          ) as BuiltList<PurchaseBill>;
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
  PurchaseBillPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseBillPageBuilder();
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


