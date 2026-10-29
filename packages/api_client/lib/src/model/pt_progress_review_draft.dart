//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_progress_review_draft.g.dart';

/// PtProgressReviewDraft
///
/// Properties:
/// * [reviewPeriodStart] 
/// * [reviewPeriodEnd] - Must not be before `review_period_start`.
/// * [trainerSummary] 
/// * [clientFeedback] 
/// * [nextPhaseGoal] 
/// * [nextPhaseTrainingFocus] 
/// * [nextReviewDate] 
@BuiltValue()
abstract class PtProgressReviewDraft implements Built<PtProgressReviewDraft, PtProgressReviewDraftBuilder> {
  @BuiltValueField(wireName: r'review_period_start')
  Date get reviewPeriodStart;

  /// Must not be before `review_period_start`.
  @BuiltValueField(wireName: r'review_period_end')
  Date get reviewPeriodEnd;

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

  PtProgressReviewDraft._();

  factory PtProgressReviewDraft([void updates(PtProgressReviewDraftBuilder b)]) = _$PtProgressReviewDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProgressReviewDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProgressReviewDraft> get serializer => _$PtProgressReviewDraftSerializer();
}

class _$PtProgressReviewDraftSerializer implements PrimitiveSerializer<PtProgressReviewDraft> {
  @override
  final Iterable<Type> types = const [PtProgressReviewDraft, _$PtProgressReviewDraft];

  @override
  final String wireName = r'PtProgressReviewDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProgressReviewDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review_period_start';
    yield serializers.serialize(
      object.reviewPeriodStart,
      specifiedType: const FullType(Date),
    );
    yield r'review_period_end';
    yield serializers.serialize(
      object.reviewPeriodEnd,
      specifiedType: const FullType(Date),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PtProgressReviewDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProgressReviewDraftBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review_period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.reviewPeriodStart = valueDes;
          break;
        case r'review_period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.reviewPeriodEnd = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtProgressReviewDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProgressReviewDraftBuilder();
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


