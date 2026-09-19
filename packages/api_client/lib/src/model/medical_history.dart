//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'medical_history.g.dart';

/// MedicalHistory
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [conditionId] 
/// * [title] 
/// * [description] 
/// * [diagnosedDate] 
/// * [clearanceStatus] 
/// * [documentUrl] 
@BuiltValue()
abstract class MedicalHistory implements Built<MedicalHistory, MedicalHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'condition_id')
  int? get conditionId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'diagnosed_date')
  Date? get diagnosedDate;

  @BuiltValueField(wireName: r'clearance_status')
  String? get clearanceStatus;

  @BuiltValueField(wireName: r'document_url')
  String? get documentUrl;

  MedicalHistory._();

  factory MedicalHistory([void updates(MedicalHistoryBuilder b)]) = _$MedicalHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MedicalHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MedicalHistory> get serializer => _$MedicalHistorySerializer();
}

class _$MedicalHistorySerializer implements PrimitiveSerializer<MedicalHistory> {
  @override
  final Iterable<Type> types = const [MedicalHistory, _$MedicalHistory];

  @override
  final String wireName = r'MedicalHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MedicalHistory object, {
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
    if (object.conditionId != null) {
      yield r'condition_id';
      yield serializers.serialize(
        object.conditionId,
        specifiedType: const FullType(int),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.diagnosedDate != null) {
      yield r'diagnosed_date';
      yield serializers.serialize(
        object.diagnosedDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.clearanceStatus != null) {
      yield r'clearance_status';
      yield serializers.serialize(
        object.clearanceStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.documentUrl != null) {
      yield r'document_url';
      yield serializers.serialize(
        object.documentUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MedicalHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MedicalHistoryBuilder result,
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
        case r'condition_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.conditionId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'diagnosed_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.diagnosedDate = valueDes;
          break;
        case r'clearance_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clearanceStatus = valueDes;
          break;
        case r'document_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MedicalHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MedicalHistoryBuilder();
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


