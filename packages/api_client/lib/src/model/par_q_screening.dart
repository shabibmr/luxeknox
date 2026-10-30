//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'par_q_screening.g.dart';

/// ParQScreening
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [version] 
/// * [q1HeartCondition] 
/// * [q1Details] 
/// * [q2ChestPainActivity] 
/// * [q2Details] 
/// * [q3ChestPainRest] 
/// * [q3Details] 
/// * [q4DizzinessConsciousness] 
/// * [q4Details] 
/// * [q5BoneJointProblem] 
/// * [q5Details] 
/// * [q6MedicationCondition] 
/// * [q6Details] 
/// * [q7OtherReason] 
/// * [q7Details] 
/// * [hasPositiveAnswer] 
/// * [trainerScreeningNotes] 
/// * [referralRequired] 
/// * [referralReason] 
/// * [declarationAccepted] 
/// * [clientSignature] 
/// * [clientSignedAt] - UTC ISO-8601
/// * [trainerSignedAt] - UTC ISO-8601
/// * [clearanceStatus] 
/// * [clearedAt] - UTC ISO-8601
/// * [clearedByUserId] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
@BuiltValue()
abstract class ParQScreening implements Built<ParQScreening, ParQScreeningBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'version')
  String get version;

  @BuiltValueField(wireName: r'q1_heart_condition')
  bool get q1HeartCondition;

  @BuiltValueField(wireName: r'q1_details')
  String? get q1Details;

  @BuiltValueField(wireName: r'q2_chest_pain_activity')
  bool get q2ChestPainActivity;

  @BuiltValueField(wireName: r'q2_details')
  String? get q2Details;

  @BuiltValueField(wireName: r'q3_chest_pain_rest')
  bool get q3ChestPainRest;

  @BuiltValueField(wireName: r'q3_details')
  String? get q3Details;

  @BuiltValueField(wireName: r'q4_dizziness_consciousness')
  bool get q4DizzinessConsciousness;

  @BuiltValueField(wireName: r'q4_details')
  String? get q4Details;

  @BuiltValueField(wireName: r'q5_bone_joint_problem')
  bool get q5BoneJointProblem;

  @BuiltValueField(wireName: r'q5_details')
  String? get q5Details;

  @BuiltValueField(wireName: r'q6_medication_condition')
  bool get q6MedicationCondition;

  @BuiltValueField(wireName: r'q6_details')
  String? get q6Details;

  @BuiltValueField(wireName: r'q7_other_reason')
  bool get q7OtherReason;

  @BuiltValueField(wireName: r'q7_details')
  String? get q7Details;

  @BuiltValueField(wireName: r'has_positive_answer')
  bool get hasPositiveAnswer;

  @BuiltValueField(wireName: r'trainer_screening_notes')
  String? get trainerScreeningNotes;

  @BuiltValueField(wireName: r'referral_required')
  bool get referralRequired;

  @BuiltValueField(wireName: r'referral_reason')
  String? get referralReason;

  @BuiltValueField(wireName: r'declaration_accepted')
  bool get declarationAccepted;

  @BuiltValueField(wireName: r'client_signature')
  String get clientSignature;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'client_signed_at')
  DateTime? get clientSignedAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'trainer_signed_at')
  DateTime? get trainerSignedAt;

  @BuiltValueField(wireName: r'clearance_status')
  ParQScreeningClearanceStatusEnum get clearanceStatus;
  // enum clearanceStatusEnum {  passed,  pending_clearance,  cleared,  rejected,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'cleared_at')
  DateTime? get clearedAt;

  @BuiltValueField(wireName: r'cleared_by_user_id')
  int? get clearedByUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  ParQScreening._();

  factory ParQScreening([void updates(ParQScreeningBuilder b)]) = _$ParQScreening;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParQScreeningBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParQScreening> get serializer => _$ParQScreeningSerializer();
}

class _$ParQScreeningSerializer implements PrimitiveSerializer<ParQScreening> {
  @override
  final Iterable<Type> types = const [ParQScreening, _$ParQScreening];

  @override
  final String wireName = r'ParQScreening';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParQScreening object, {
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
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
    yield r'q1_heart_condition';
    yield serializers.serialize(
      object.q1HeartCondition,
      specifiedType: const FullType(bool),
    );
    if (object.q1Details != null) {
      yield r'q1_details';
      yield serializers.serialize(
        object.q1Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q2_chest_pain_activity';
    yield serializers.serialize(
      object.q2ChestPainActivity,
      specifiedType: const FullType(bool),
    );
    if (object.q2Details != null) {
      yield r'q2_details';
      yield serializers.serialize(
        object.q2Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q3_chest_pain_rest';
    yield serializers.serialize(
      object.q3ChestPainRest,
      specifiedType: const FullType(bool),
    );
    if (object.q3Details != null) {
      yield r'q3_details';
      yield serializers.serialize(
        object.q3Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q4_dizziness_consciousness';
    yield serializers.serialize(
      object.q4DizzinessConsciousness,
      specifiedType: const FullType(bool),
    );
    if (object.q4Details != null) {
      yield r'q4_details';
      yield serializers.serialize(
        object.q4Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q5_bone_joint_problem';
    yield serializers.serialize(
      object.q5BoneJointProblem,
      specifiedType: const FullType(bool),
    );
    if (object.q5Details != null) {
      yield r'q5_details';
      yield serializers.serialize(
        object.q5Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q6_medication_condition';
    yield serializers.serialize(
      object.q6MedicationCondition,
      specifiedType: const FullType(bool),
    );
    if (object.q6Details != null) {
      yield r'q6_details';
      yield serializers.serialize(
        object.q6Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'q7_other_reason';
    yield serializers.serialize(
      object.q7OtherReason,
      specifiedType: const FullType(bool),
    );
    if (object.q7Details != null) {
      yield r'q7_details';
      yield serializers.serialize(
        object.q7Details,
        specifiedType: const FullType(String),
      );
    }
    yield r'has_positive_answer';
    yield serializers.serialize(
      object.hasPositiveAnswer,
      specifiedType: const FullType(bool),
    );
    if (object.trainerScreeningNotes != null) {
      yield r'trainer_screening_notes';
      yield serializers.serialize(
        object.trainerScreeningNotes,
        specifiedType: const FullType(String),
      );
    }
    yield r'referral_required';
    yield serializers.serialize(
      object.referralRequired,
      specifiedType: const FullType(bool),
    );
    if (object.referralReason != null) {
      yield r'referral_reason';
      yield serializers.serialize(
        object.referralReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'declaration_accepted';
    yield serializers.serialize(
      object.declarationAccepted,
      specifiedType: const FullType(bool),
    );
    yield r'client_signature';
    yield serializers.serialize(
      object.clientSignature,
      specifiedType: const FullType(String),
    );
    if (object.clientSignedAt != null) {
      yield r'client_signed_at';
      yield serializers.serialize(
        object.clientSignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.trainerSignedAt != null) {
      yield r'trainer_signed_at';
      yield serializers.serialize(
        object.trainerSignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'clearance_status';
    yield serializers.serialize(
      object.clearanceStatus,
      specifiedType: const FullType(ParQScreeningClearanceStatusEnum),
    );
    if (object.clearedAt != null) {
      yield r'cleared_at';
      yield serializers.serialize(
        object.clearedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.clearedByUserId != null) {
      yield r'cleared_by_user_id';
      yield serializers.serialize(
        object.clearedByUserId,
        specifiedType: const FullType(int),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ParQScreening object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParQScreeningBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        case r'q1_heart_condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q1HeartCondition = valueDes;
          break;
        case r'q1_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q1Details = valueDes;
          break;
        case r'q2_chest_pain_activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q2ChestPainActivity = valueDes;
          break;
        case r'q2_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q2Details = valueDes;
          break;
        case r'q3_chest_pain_rest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q3ChestPainRest = valueDes;
          break;
        case r'q3_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q3Details = valueDes;
          break;
        case r'q4_dizziness_consciousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q4DizzinessConsciousness = valueDes;
          break;
        case r'q4_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q4Details = valueDes;
          break;
        case r'q5_bone_joint_problem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q5BoneJointProblem = valueDes;
          break;
        case r'q5_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q5Details = valueDes;
          break;
        case r'q6_medication_condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q6MedicationCondition = valueDes;
          break;
        case r'q6_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q6Details = valueDes;
          break;
        case r'q7_other_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.q7OtherReason = valueDes;
          break;
        case r'q7_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q7Details = valueDes;
          break;
        case r'has_positive_answer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasPositiveAnswer = valueDes;
          break;
        case r'trainer_screening_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.trainerScreeningNotes = valueDes;
          break;
        case r'referral_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.referralRequired = valueDes;
          break;
        case r'referral_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referralReason = valueDes;
          break;
        case r'declaration_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.declarationAccepted = valueDes;
          break;
        case r'client_signature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientSignature = valueDes;
          break;
        case r'client_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.clientSignedAt = valueDes;
          break;
        case r'trainer_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.trainerSignedAt = valueDes;
          break;
        case r'clearance_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ParQScreeningClearanceStatusEnum),
          ) as ParQScreeningClearanceStatusEnum;
          result.clearanceStatus = valueDes;
          break;
        case r'cleared_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.clearedAt = valueDes;
          break;
        case r'cleared_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.clearedByUserId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParQScreening deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParQScreeningBuilder();
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


class ParQScreeningClearanceStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'passed')
  static const ParQScreeningClearanceStatusEnum passed = _$parQScreeningClearanceStatusEnum_passed;
  @BuiltValueEnumConst(wireName: r'pending_clearance')
  static const ParQScreeningClearanceStatusEnum pendingClearance = _$parQScreeningClearanceStatusEnum_pendingClearance;
  @BuiltValueEnumConst(wireName: r'cleared')
  static const ParQScreeningClearanceStatusEnum cleared = _$parQScreeningClearanceStatusEnum_cleared;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const ParQScreeningClearanceStatusEnum rejected = _$parQScreeningClearanceStatusEnum_rejected;

  static Serializer<ParQScreeningClearanceStatusEnum> get serializer => _$parQScreeningClearanceStatusEnumSerializer;

  const ParQScreeningClearanceStatusEnum._(String name): super(name);

  static BuiltSet<ParQScreeningClearanceStatusEnum> get values => _$parQScreeningClearanceStatusEnumValues;
  static ParQScreeningClearanceStatusEnum valueOf(String name) => _$parQScreeningClearanceStatusEnumValueOf(name);
}

