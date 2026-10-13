//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/fund_transfer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fund_transfer_page.g.dart';

/// FundTransferPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class FundTransferPage implements Built<FundTransferPage, FundTransferPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<FundTransfer> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  FundTransferPage._();

  factory FundTransferPage([void updates(FundTransferPageBuilder b)]) = _$FundTransferPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FundTransferPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FundTransferPage> get serializer => _$FundTransferPageSerializer();
}

class _$FundTransferPageSerializer implements PrimitiveSerializer<FundTransferPage> {
  @override
  final Iterable<Type> types = const [FundTransferPage, _$FundTransferPage];

  @override
  final String wireName = r'FundTransferPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FundTransferPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(FundTransfer)]),
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
    FundTransferPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FundTransferPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FundTransfer)]),
          ) as BuiltList<FundTransfer>;
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
  FundTransferPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FundTransferPageBuilder();
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


