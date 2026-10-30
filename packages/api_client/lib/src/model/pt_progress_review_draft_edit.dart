//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/pt_review_checklist.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_progress_review_draft_edit.g.dart';

/// PtProgressReviewDraftEdit
///
/// Properties:
/// * [progressHighlights] 
/// * [highlightsOtherText] 
/// * [trainerSummary] 
/// * [clientFeedback] 
/// * [nextPhaseGoal] 
/// * [nextPhaseTrainingFocus] 
/// * [nextReviewDate] 
/// * [reviewChecklist] 
@BuiltValue()
abstract class PtProgressReviewDraftEdit implements Built<PtProgressReviewDraftEdit, PtProgressReviewDraftEditBuilder> {
  @BuiltValueField(wireName: r'progress_highlights')
  BuiltSet<PtProgressReviewDraftEditProgressHighlightsEnum>? get progressHighlights;
  // enum progressHighlightsEnum {  improved_technique,  increased_strength,  improved_conditioning,  better_consistency,  improved_mobility,  goal_milestone,  other,  };

  @BuiltValueField(wireName: r'highlights_other_text')
  String? get highlightsOtherText;

  @BuiltValueField(wireName: r'trainer_summary')
  String? get trainerSummary;

  @BuiltValueField(wireName: r'client_feedback')
  String? get clientFeedback;

  @BuiltValueField(wireName: r'next_phase_goal')
  String? get nextPhaseGoal;

  @BuiltValueField(wireName: r'next_phase_training_focus')
  String? get nextPhaseTrainingFocus;

  @BuiltValueField(wireName: r'next_review_date')
  Date? get nextReviewDate;

  @BuiltValueField(wireName: r'review_checklist')
  PtReviewChecklist? get reviewChecklist;

  PtProgressReviewDraftEdit._();

  factory PtProgressReviewDraftEdit([void updates(PtProgressReviewDraftEditBuilder b)]) = _$PtProgressReviewDraftEdit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProgressReviewDraftEditBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProgressReviewDraftEdit> get serializer => _$PtProgressReviewDraftEditSerializer();
}

class _$PtProgressReviewDraftEditSerializer implements PrimitiveSerializer<PtProgressReviewDraftEdit> {
  @override
  final Iterable<Type> types = const [PtProgressReviewDraftEdit, _$PtProgressReviewDraftEdit];

  @override
  final String wireName = r'PtProgressReviewDraftEdit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProgressReviewDraftEdit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.progressHighlights != null) {
      yield r'progress_highlights';
      yield serializers.serialize(
        object.progressHighlights,
        specifiedType: const FullType(BuiltSet, [FullType(PtProgressReviewDraftEditProgressHighlightsEnum)]),
      );
    }
    if (object.highlightsOtherText != null) {
      yield r'highlights_other_text';
      yield serializers.serialize(
        object.highlightsOtherText,
        specifiedType: const FullType(String),
      );
    }
    if (object.trainerSummary != null) {
      yield r'trainer_summary';
      yield serializers.serialize(
        object.trainerSummary,
        specifiedType: const FullType(String),
      );
    }
    if (object.clientFeedback != null) {
      yield r'client_feedback';
      yield serializers.serialize(
        object.clientFeedback,
        specifiedType: const FullType(String),
      );
    }
    if (object.nextPhaseGoal != null) {
      yield r'next_phase_goal';
      yield serializers.serialize(
        object.nextPhaseGoal,
        specifiedType: const FullType(String),
      );
    }
    if (object.nextPhaseTrainingFocus != null) {
      yield r'next_phase_training_focus';
      yield serializers.serialize(
        object.nextPhaseTrainingFocus,
        specifiedType: const FullType(String),
      );
    }
    if (object.nextReviewDate != null) {
      yield r'next_review_date';
      yield serializers.serialize(
        object.nextReviewDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.reviewChecklist != null) {
      yield r'review_checklist';
      yield serializers.serialize(
        object.reviewChecklist,
        specifiedType: const FullType(PtReviewChecklist),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PtProgressReviewDraftEdit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProgressReviewDraftEditBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'progress_highlights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltSet, [FullType(PtProgressReviewDraftEditProgressHighlightsEnum)]),
          ) as BuiltSet<PtProgressReviewDraftEditProgressHighlightsEnum>?;
          if (valueDes == null) continue;
          result.progressHighlights.replace(valueDes);
          break;
        case r'highlights_other_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.highlightsOtherText = valueDes;
          break;
        case r'trainer_summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.trainerSummary = valueDes;
          break;
        case r'client_feedback':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clientFeedback = valueDes;
          break;
        case r'next_phase_goal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextPhaseGoal = valueDes;
          break;
        case r'next_phase_training_focus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextPhaseTrainingFocus = valueDes;
          break;
        case r'next_review_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.nextReviewDate = valueDes;
          break;
        case r'review_checklist':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PtReviewChecklist),
          ) as PtReviewChecklist?;
          if (valueDes == null) continue;
          result.reviewChecklist.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtProgressReviewDraftEdit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProgressReviewDraftEditBuilder();
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


class PtProgressReviewDraftEditProgressHighlightsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'improved_technique')
  static const PtProgressReviewDraftEditProgressHighlightsEnum improvedTechnique = _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedTechnique;
  @BuiltValueEnumConst(wireName: r'increased_strength')
  static const PtProgressReviewDraftEditProgressHighlightsEnum increasedStrength = _$ptProgressReviewDraftEditProgressHighlightsEnum_increasedStrength;
  @BuiltValueEnumConst(wireName: r'improved_conditioning')
  static const PtProgressReviewDraftEditProgressHighlightsEnum improvedConditioning = _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedConditioning;
  @BuiltValueEnumConst(wireName: r'better_consistency')
  static const PtProgressReviewDraftEditProgressHighlightsEnum betterConsistency = _$ptProgressReviewDraftEditProgressHighlightsEnum_betterConsistency;
  @BuiltValueEnumConst(wireName: r'improved_mobility')
  static const PtProgressReviewDraftEditProgressHighlightsEnum improvedMobility = _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedMobility;
  @BuiltValueEnumConst(wireName: r'goal_milestone')
  static const PtProgressReviewDraftEditProgressHighlightsEnum goalMilestone = _$ptProgressReviewDraftEditProgressHighlightsEnum_goalMilestone;
  @BuiltValueEnumConst(wireName: r'other')
  static const PtProgressReviewDraftEditProgressHighlightsEnum other = _$ptProgressReviewDraftEditProgressHighlightsEnum_other;

  static Serializer<PtProgressReviewDraftEditProgressHighlightsEnum> get serializer => _$ptProgressReviewDraftEditProgressHighlightsEnumSerializer;

  const PtProgressReviewDraftEditProgressHighlightsEnum._(String name): super(name);

  static BuiltSet<PtProgressReviewDraftEditProgressHighlightsEnum> get values => _$ptProgressReviewDraftEditProgressHighlightsEnumValues;
  static PtProgressReviewDraftEditProgressHighlightsEnum valueOf(String name) => _$ptProgressReviewDraftEditProgressHighlightsEnumValueOf(name);
}

