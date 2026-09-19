//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_upload.g.dart';

/// MediaUpload
///
/// Properties:
/// * [url] 
/// * [objectKey] 
/// * [expiresAt] - UTC ISO-8601
@BuiltValue()
abstract class MediaUpload implements Built<MediaUpload, MediaUploadBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'object_key')
  String get objectKey;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  MediaUpload._();

  factory MediaUpload([void updates(MediaUploadBuilder b)]) = _$MediaUpload;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediaUploadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediaUpload> get serializer => _$MediaUploadSerializer();
}

class _$MediaUploadSerializer implements PrimitiveSerializer<MediaUpload> {
  @override
  final Iterable<Type> types = const [MediaUpload, _$MediaUpload];

  @override
  final String wireName = r'MediaUpload';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediaUpload object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'object_key';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MediaUpload object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MediaUploadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'object_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MediaUpload deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediaUploadBuilder();
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


