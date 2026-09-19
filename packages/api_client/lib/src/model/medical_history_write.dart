//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'medical_history_write.g.dart';

/// MedicalHistoryWrite
///
/// Properties:
/// * [conditionId] 
/// * [title] 
/// * [description] 
/// * [diagnosedDate] 
/// * [clearanceStatus] 
@BuiltValue()
abstract class MedicalHistoryWrite implements Built<MedicalHistoryWrite, MedicalHistoryWriteBuilder> {
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

  MedicalHistoryWrite._();

  factory MedicalHistoryWrite([void updates(MedicalHistoryWriteBuilder b)]) = _$MedicalHistoryWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MedicalHistoryWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MedicalHistoryWrite> get serializer => _$MedicalHistoryWriteSerializer();
}

class _$MedicalHistoryWriteSerializer implements PrimitiveSerializer<MedicalHistoryWrite> {
  @override
  final Iterable<Type> types = const [MedicalHistoryWrite, _$MedicalHistoryWrite];

  @override
  final String wireName = r'MedicalHistoryWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MedicalHistoryWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    MedicalHistoryWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MedicalHistoryWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MedicalHistoryWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MedicalHistoryWriteBuilder();
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


