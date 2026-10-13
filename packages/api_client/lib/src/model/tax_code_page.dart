//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/tax_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_code_page.g.dart';

/// TaxCodePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class TaxCodePage implements Built<TaxCodePage, TaxCodePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<TaxCode> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  TaxCodePage._();

  factory TaxCodePage([void updates(TaxCodePageBuilder b)]) = _$TaxCodePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxCodePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxCodePage> get serializer => _$TaxCodePageSerializer();
}

class _$TaxCodePageSerializer implements PrimitiveSerializer<TaxCodePage> {
  @override
  final Iterable<Type> types = const [TaxCodePage, _$TaxCodePage];

  @override
  final String wireName = r'TaxCodePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxCodePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(TaxCode)]),
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
    TaxCodePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxCodePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaxCode)]),
          ) as BuiltList<TaxCode>;
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
  TaxCodePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxCodePageBuilder();
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


