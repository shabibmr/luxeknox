//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_document_write.g.dart';

/// MemberDocumentWrite
///
/// Properties:
/// * [documentType] 
/// * [title] 
/// * [fileUrl] 
/// * [fileSize] 
@BuiltValue()
abstract class MemberDocumentWrite implements Built<MemberDocumentWrite, MemberDocumentWriteBuilder> {
  @BuiltValueField(wireName: r'document_type')
  MemberDocumentWriteDocumentTypeEnum get documentType;
  // enum documentTypeEnum {  id_proof,  waiver,  medical_cert,  };

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'file_url')
  String get fileUrl;

  @BuiltValueField(wireName: r'file_size')
  int? get fileSize;

  MemberDocumentWrite._();

  factory MemberDocumentWrite([void updates(MemberDocumentWriteBuilder b)]) = _$MemberDocumentWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberDocumentWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberDocumentWrite> get serializer => _$MemberDocumentWriteSerializer();
}

class _$MemberDocumentWriteSerializer implements PrimitiveSerializer<MemberDocumentWrite> {
  @override
  final Iterable<Type> types = const [MemberDocumentWrite, _$MemberDocumentWrite];

  @override
  final String wireName = r'MemberDocumentWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberDocumentWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'document_type';
    yield serializers.serialize(
      object.documentType,
      specifiedType: const FullType(MemberDocumentWriteDocumentTypeEnum),
    );
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    yield r'file_url';
    yield serializers.serialize(
      object.fileUrl,
      specifiedType: const FullType(String),
    );
    if (object.fileSize != null) {
      yield r'file_size';
      yield serializers.serialize(
        object.fileSize,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberDocumentWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberDocumentWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'document_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemberDocumentWriteDocumentTypeEnum),
          ) as MemberDocumentWriteDocumentTypeEnum;
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
            specifiedType: const FullType(String),
          ) as String;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberDocumentWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberDocumentWriteBuilder();
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


class MemberDocumentWriteDocumentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'id_proof')
  static const MemberDocumentWriteDocumentTypeEnum idProof = _$memberDocumentWriteDocumentTypeEnum_idProof;
  @BuiltValueEnumConst(wireName: r'waiver')
  static const MemberDocumentWriteDocumentTypeEnum waiver = _$memberDocumentWriteDocumentTypeEnum_waiver;
  @BuiltValueEnumConst(wireName: r'medical_cert')
  static const MemberDocumentWriteDocumentTypeEnum medicalCert = _$memberDocumentWriteDocumentTypeEnum_medicalCert;

  static Serializer<MemberDocumentWriteDocumentTypeEnum> get serializer => _$memberDocumentWriteDocumentTypeEnumSerializer;

  const MemberDocumentWriteDocumentTypeEnum._(String name): super(name);

  static BuiltSet<MemberDocumentWriteDocumentTypeEnum> get values => _$memberDocumentWriteDocumentTypeEnumValues;
  static MemberDocumentWriteDocumentTypeEnum valueOf(String name) => _$memberDocumentWriteDocumentTypeEnumValueOf(name);
}

