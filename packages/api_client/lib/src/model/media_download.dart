//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_download.g.dart';

/// MediaDownload
///
/// Properties:
/// * [url] 
/// * [expiresAt] - UTC ISO-8601
@BuiltValue()
abstract class MediaDownload implements Built<MediaDownload, MediaDownloadBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  MediaDownload._();

  factory MediaDownload([void updates(MediaDownloadBuilder b)]) = _$MediaDownload;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediaDownloadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediaDownload> get serializer => _$MediaDownloadSerializer();
}

class _$MediaDownloadSerializer implements PrimitiveSerializer<MediaDownload> {
  @override
  final Iterable<Type> types = const [MediaDownload, _$MediaDownload];

  @override
  final String wireName = r'MediaDownload';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediaDownload object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
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
    MediaDownload object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MediaDownloadBuilder result,
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
  MediaDownload deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediaDownloadBuilder();
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


