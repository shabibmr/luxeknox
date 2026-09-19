//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_document.g.dart';

/// MemberDocument
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [documentType] 
/// * [title] 
/// * [fileUrl] 
/// * [fileSize] 
/// * [verifiedByUserId] 
/// * [verifiedAt] 
@BuiltValue()
abstract class MemberDocument implements Built<MemberDocument, MemberDocumentBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'document_type')
  MemberDocumentDocumentTypeEnum get documentType;
  // enum documentTypeEnum {  id_proof,  waiver,  medical_cert,  };

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'file_url')
  String? get fileUrl;

  @BuiltValueField(wireName: r'file_size')
  int? get fileSize;

  @BuiltValueField(wireName: r'verified_by_user_id')
  int? get verifiedByUserId;

  @BuiltValueField(wireName: r'verified_at')
  DateTime? get verifiedAt;

  MemberDocument._();

  factory MemberDocument([void updates(MemberDocumentBuilder b)]) = _$MemberDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberDocument> get serializer => _$MemberDocumentSerializer();
}

class _$MemberDocumentSerializer implements PrimitiveSerializer<MemberDocument> {
  @override
  final Iterable<Type> types = const [MemberDocument, _$MemberDocument];

  @override
  final String wireName = r'MemberDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'document_type';
    yield serializers.serialize(
      object.documentType,
      specifiedType: const FullType(MemberDocumentDocumentTypeEnum),
    );
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.fileUrl != null) {
      yield r'file_url';
      yield serializers.serialize(
        object.fileUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.fileSize != null) {
      yield r'file_size';
      yield serializers.serialize(
        object.fileSize,
        specifiedType: const FullType(int),
      );
    }
    if (object.verifiedByUserId != null) {
      yield r'verified_by_user_id';
      yield serializers.serialize(
        object.verifiedByUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.verifiedAt != null) {
      yield r'verified_at';
      yield serializers.serialize(
        object.verifiedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberDocumentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'document_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemberDocumentDocumentTypeEnum),
          ) as MemberDocumentDocumentTypeEnum;
          result.documentType = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'file_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileUrl = valueDes;
          break;
        case r'file_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fileSize = valueDes;
          break;
        case r'verified_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.verifiedByUserId = valueDes;
          break;
        case r'verified_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.verifiedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberDocumentBuilder();
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


class MemberDocumentDocumentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'id_proof')
  static const MemberDocumentDocumentTypeEnum idProof = _$memberDocumentDocumentTypeEnum_idProof;
  @BuiltValueEnumConst(wireName: r'waiver')
  static const MemberDocumentDocumentTypeEnum waiver = _$memberDocumentDocumentTypeEnum_waiver;
  @BuiltValueEnumConst(wireName: r'medical_cert')
  static const MemberDocumentDocumentTypeEnum medicalCert = _$memberDocumentDocumentTypeEnum_medicalCert;

  static Serializer<MemberDocumentDocumentTypeEnum> get serializer => _$memberDocumentDocumentTypeEnumSerializer;

  const MemberDocumentDocumentTypeEnum._(String name): super(name);

  static BuiltSet<MemberDocumentDocumentTypeEnum> get values => _$memberDocumentDocumentTypeEnumValues;
  static MemberDocumentDocumentTypeEnum valueOf(String name) => _$memberDocumentDocumentTypeEnumValueOf(name);
}

