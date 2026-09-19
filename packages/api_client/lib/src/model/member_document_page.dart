//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/member_document.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_document_page.g.dart';

/// MemberDocumentPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MemberDocumentPage implements Built<MemberDocumentPage, MemberDocumentPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MemberDocument> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MemberDocumentPage._();

  factory MemberDocumentPage([void updates(MemberDocumentPageBuilder b)]) = _$MemberDocumentPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberDocumentPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberDocumentPage> get serializer => _$MemberDocumentPageSerializer();
}

class _$MemberDocumentPageSerializer implements PrimitiveSerializer<MemberDocumentPage> {
  @override
  final Iterable<Type> types = const [MemberDocumentPage, _$MemberDocumentPage];

  @override
  final String wireName = r'MemberDocumentPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberDocumentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MemberDocument)]),
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
    MemberDocumentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberDocumentPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MemberDocument)]),
          ) as BuiltList<MemberDocument>;
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
  MemberDocumentPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberDocumentPageBuilder();
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


