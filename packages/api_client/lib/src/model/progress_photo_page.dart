//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/progress_photo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo_page.g.dart';

/// ProgressPhotoPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ProgressPhotoPage implements Built<ProgressPhotoPage, ProgressPhotoPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ProgressPhoto> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ProgressPhotoPage._();

  factory ProgressPhotoPage([void updates(ProgressPhotoPageBuilder b)]) = _$ProgressPhotoPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhotoPage> get serializer => _$ProgressPhotoPageSerializer();
}

class _$ProgressPhotoPageSerializer implements PrimitiveSerializer<ProgressPhotoPage> {
  @override
  final Iterable<Type> types = const [ProgressPhotoPage, _$ProgressPhotoPage];

  @override
  final String wireName = r'ProgressPhotoPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhotoPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
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
    ProgressPhotoPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
          ) as BuiltList<ProgressPhoto>;
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
  ProgressPhotoPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoPageBuilder();
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


