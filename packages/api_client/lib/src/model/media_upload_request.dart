//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_upload_request.g.dart';

/// MediaUploadRequest
///
/// Properties:
/// * [purpose] 
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class MediaUploadRequest implements Built<MediaUploadRequest, MediaUploadRequestBuilder> {
  @BuiltValueField(wireName: r'purpose')
  MediaUploadRequestPurposeEnum get purpose;
  // enum purposeEnum {  exercise_media,  avatar,  progress_photo,  id_proof,  waiver,  medical_cert,  receipt_pdf,  };

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'size_bytes')
  int get sizeBytes;

  MediaUploadRequest._();

  factory MediaUploadRequest([void updates(MediaUploadRequestBuilder b)]) = _$MediaUploadRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediaUploadRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediaUploadRequest> get serializer => _$MediaUploadRequestSerializer();
}

class _$MediaUploadRequestSerializer implements PrimitiveSerializer<MediaUploadRequest> {
  @override
  final Iterable<Type> types = const [MediaUploadRequest, _$MediaUploadRequest];

  @override
  final String wireName = r'MediaUploadRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediaUploadRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(MediaUploadRequestPurposeEnum),
    );
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'size_bytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MediaUploadRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MediaUploadRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MediaUploadRequestPurposeEnum),
          ) as MediaUploadRequestPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MediaUploadRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediaUploadRequestBuilder();
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


class MediaUploadRequestPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'exercise_media')
  static const MediaUploadRequestPurposeEnum exerciseMedia = _$mediaUploadRequestPurposeEnum_exerciseMedia;
  @BuiltValueEnumConst(wireName: r'avatar')
  static const MediaUploadRequestPurposeEnum avatar = _$mediaUploadRequestPurposeEnum_avatar;
  @BuiltValueEnumConst(wireName: r'progress_photo')
  static const MediaUploadRequestPurposeEnum progressPhoto = _$mediaUploadRequestPurposeEnum_progressPhoto;
  @BuiltValueEnumConst(wireName: r'id_proof')
  static const MediaUploadRequestPurposeEnum idProof = _$mediaUploadRequestPurposeEnum_idProof;
  @BuiltValueEnumConst(wireName: r'waiver')
  static const MediaUploadRequestPurposeEnum waiver = _$mediaUploadRequestPurposeEnum_waiver;
  @BuiltValueEnumConst(wireName: r'medical_cert')
  static const MediaUploadRequestPurposeEnum medicalCert = _$mediaUploadRequestPurposeEnum_medicalCert;
  @BuiltValueEnumConst(wireName: r'receipt_pdf')
  static const MediaUploadRequestPurposeEnum receiptPdf = _$mediaUploadRequestPurposeEnum_receiptPdf;

  static Serializer<MediaUploadRequestPurposeEnum> get serializer => _$mediaUploadRequestPurposeEnumSerializer;

  const MediaUploadRequestPurposeEnum._(String name): super(name);

  static BuiltSet<MediaUploadRequestPurposeEnum> get values => _$mediaUploadRequestPurposeEnumValues;
  static MediaUploadRequestPurposeEnum valueOf(String name) => _$mediaUploadRequestPurposeEnumValueOf(name);
}

