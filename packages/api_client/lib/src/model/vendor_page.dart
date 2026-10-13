//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/vendor.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_page.g.dart';

/// VendorPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class VendorPage implements Built<VendorPage, VendorPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Vendor> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  VendorPage._();

  factory VendorPage([void updates(VendorPageBuilder b)]) = _$VendorPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorPage> get serializer => _$VendorPageSerializer();
}

class _$VendorPageSerializer implements PrimitiveSerializer<VendorPage> {
  @override
  final Iterable<Type> types = const [VendorPage, _$VendorPage];

  @override
  final String wireName = r'VendorPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Vendor)]),
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
    VendorPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Vendor)]),
          ) as BuiltList<Vendor>;
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
  VendorPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorPageBuilder();
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


