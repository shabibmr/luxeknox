//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'par_q_submit.g.dart';

/// Every YES answer requires its `*_details` text.
///
/// Properties:
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
/// * [declarationAccepted] 
@BuiltValue()
abstract class ParQSubmit implements Built<ParQSubmit, ParQSubmitBuilder> {
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

  @BuiltValueField(wireName: r'declaration_accepted')
  ParQSubmitDeclarationAcceptedEnum get declarationAccepted;
  // enum declarationAcceptedEnum {  true,  };

  ParQSubmit._();

  factory ParQSubmit([void updates(ParQSubmitBuilder b)]) = _$ParQSubmit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParQSubmitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParQSubmit> get serializer => _$ParQSubmitSerializer();
}

class _$ParQSubmitSerializer implements PrimitiveSerializer<ParQSubmit> {
  @override
  final Iterable<Type> types = const [ParQSubmit, _$ParQSubmit];

  @override
  final String wireName = r'ParQSubmit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParQSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'declaration_accepted';
    yield serializers.serialize(
      object.declarationAccepted,
      specifiedType: const FullType(ParQSubmitDeclarationAcceptedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ParQSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParQSubmitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'declaration_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ParQSubmitDeclarationAcceptedEnum),
          ) as ParQSubmitDeclarationAcceptedEnum;
          result.declarationAccepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParQSubmit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParQSubmitBuilder();
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


class ParQSubmitDeclarationAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const ParQSubmitDeclarationAcceptedEnum true_ = _$parQSubmitDeclarationAcceptedEnum_true_;

  static Serializer<ParQSubmitDeclarationAcceptedEnum> get serializer => _$parQSubmitDeclarationAcceptedEnumSerializer;

  const ParQSubmitDeclarationAcceptedEnum._(String name): super(name);

  static BuiltSet<ParQSubmitDeclarationAcceptedEnum> get values => _$parQSubmitDeclarationAcceptedEnumValues;
  static ParQSubmitDeclarationAcceptedEnum valueOf(String name) => _$parQSubmitDeclarationAcceptedEnumValueOf(name);
}

