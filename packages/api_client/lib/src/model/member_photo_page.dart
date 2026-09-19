//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/member_photo.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_photo_page.g.dart';

/// MemberPhotoPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MemberPhotoPage implements Built<MemberPhotoPage, MemberPhotoPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MemberPhoto> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MemberPhotoPage._();

  factory MemberPhotoPage([void updates(MemberPhotoPageBuilder b)]) = _$MemberPhotoPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberPhotoPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberPhotoPage> get serializer => _$MemberPhotoPageSerializer();
}

class _$MemberPhotoPageSerializer implements PrimitiveSerializer<MemberPhotoPage> {
  @override
  final Iterable<Type> types = const [MemberPhotoPage, _$MemberPhotoPage];

  @override
  final String wireName = r'MemberPhotoPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberPhotoPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MemberPhoto)]),
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
    MemberPhotoPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberPhotoPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MemberPhoto)]),
          ) as BuiltList<MemberPhoto>;
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
  MemberPhotoPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberPhotoPageBuilder();
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


