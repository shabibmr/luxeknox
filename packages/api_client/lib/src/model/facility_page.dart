//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/facility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'facility_page.g.dart';

/// FacilityPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class FacilityPage implements Built<FacilityPage, FacilityPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Facility> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  FacilityPage._();

  factory FacilityPage([void updates(FacilityPageBuilder b)]) = _$FacilityPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacilityPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacilityPage> get serializer => _$FacilityPageSerializer();
}

class _$FacilityPageSerializer implements PrimitiveSerializer<FacilityPage> {
  @override
  final Iterable<Type> types = const [FacilityPage, _$FacilityPage];

  @override
  final String wireName = r'FacilityPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacilityPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Facility)]),
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
    FacilityPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FacilityPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Facility)]),
          ) as BuiltList<Facility>;
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
  FacilityPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacilityPageBuilder();
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


