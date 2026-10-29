//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/pt_review_checklist.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/performance_marker_snapshot.dart';
import 'package:api_client/src/model/body_metric_snapshot.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_progress_review.g.dart';

/// PtProgressReview
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [trainerId] 
/// * [reviewPeriodStart] 
/// * [reviewPeriodEnd] 
/// * [bodyMetricsSnapshot] 
/// * [performanceMarkersSnapshot] 
/// * [progressHighlights] 
/// * [highlightsOtherText] 
/// * [trainerSummary] 
/// * [clientFeedback] 
/// * [nextPhaseGoal] 
/// * [nextPhaseTrainingFocus] 
/// * [nextReviewDate] 
/// * [reviewChecklist] 
/// * [finalReviewNotes] 
/// * [clientSignedAt] 
/// * [trainerSignedAt] 
/// * [managerUserId] 
/// * [managerSignedAt] 
/// * [status] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] 
@BuiltValue()
abstract class PtProgressReview implements Built<PtProgressReview, PtProgressReviewBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'review_period_start')
  Date get reviewPeriodStart;

  @BuiltValueField(wireName: r'review_period_end')
  Date get reviewPeriodEnd;

  @BuiltValueField(wireName: r'body_metrics_snapshot')
  BuiltList<BodyMetricSnapshot>? get bodyMetricsSnapshot;

  @BuiltValueField(wireName: r'performance_markers_snapshot')
  BuiltList<PerformanceMarkerSnapshot>? get performanceMarkersSnapshot;

  @BuiltValueField(wireName: r'progress_highlights')
  BuiltList<String>? get progressHighlights;

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

  @BuiltValueField(wireName: r'final_review_notes')
  String? get finalReviewNotes;

  @BuiltValueField(wireName: r'client_signed_at')
  DateTime? get clientSignedAt;

  @BuiltValueField(wireName: r'trainer_signed_at')
  DateTime? get trainerSignedAt;

  @BuiltValueField(wireName: r'manager_user_id')
  int? get managerUserId;

  @BuiltValueField(wireName: r'manager_signed_at')
  DateTime? get managerSignedAt;

  @BuiltValueField(wireName: r'status')
  PtProgressReviewStatusEnum get status;
  // enum statusEnum {  draft,  pending_client_sign,  pending_manager_approval,  approved,  archived,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  PtProgressReview._();

  factory PtProgressReview([void updates(PtProgressReviewBuilder b)]) = _$PtProgressReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProgressReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProgressReview> get serializer => _$PtProgressReviewSerializer();
}

class _$PtProgressReviewSerializer implements PrimitiveSerializer<PtProgressReview> {
  @override
  final Iterable<Type> types = const [PtProgressReview, _$PtProgressReview];

  @override
  final String wireName = r'PtProgressReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProgressReview object, {
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
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
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
    if (object.bodyMetricsSnapshot != null) {
      yield r'body_metrics_snapshot';
      yield serializers.serialize(
        object.bodyMetricsSnapshot,
        specifiedType: const FullType(BuiltList, [FullType(BodyMetricSnapshot)]),
      );
    }
    if (object.performanceMarkersSnapshot != null) {
      yield r'performance_markers_snapshot';
      yield serializers.serialize(
        object.performanceMarkersSnapshot,
        specifiedType: const FullType(BuiltList, [FullType(PerformanceMarkerSnapshot)]),
      );
    }
    if (object.progressHighlights != null) {
      yield r'progress_highlights';
      yield serializers.serialize(
        object.progressHighlights,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    if (object.finalReviewNotes != null) {
      yield r'final_review_notes';
      yield serializers.serialize(
        object.finalReviewNotes,
        specifiedType: const FullType(String),
      );
    }
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
    if (object.managerUserId != null) {
      yield r'manager_user_id';
      yield serializers.serialize(
        object.managerUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.managerSignedAt != null) {
      yield r'manager_signed_at';
      yield serializers.serialize(
        object.managerSignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PtProgressReviewStatusEnum),
    );
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
    PtProgressReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProgressReviewBuilder result,
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
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
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
        case r'body_metrics_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BodyMetricSnapshot)]),
          ) as BuiltList<BodyMetricSnapshot>?;
          if (valueDes == null) continue;
          result.bodyMetricsSnapshot.replace(valueDes);
          break;
        case r'performance_markers_snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PerformanceMarkerSnapshot)]),
          ) as BuiltList<PerformanceMarkerSnapshot>?;
          if (valueDes == null) continue;
          result.performanceMarkersSnapshot.replace(valueDes);
          break;
        case r'progress_highlights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
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
        case r'final_review_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.finalReviewNotes = valueDes;
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
        case r'manager_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.managerUserId = valueDes;
          break;
        case r'manager_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.managerSignedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PtProgressReviewStatusEnum),
          ) as PtProgressReviewStatusEnum;
          result.status = valueDes;
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
  PtProgressReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProgressReviewBuilder();
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


class PtProgressReviewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const PtProgressReviewStatusEnum draft = _$ptProgressReviewStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'pending_client_sign')
  static const PtProgressReviewStatusEnum pendingClientSign = _$ptProgressReviewStatusEnum_pendingClientSign;
  @BuiltValueEnumConst(wireName: r'pending_manager_approval')
  static const PtProgressReviewStatusEnum pendingManagerApproval = _$ptProgressReviewStatusEnum_pendingManagerApproval;
  @BuiltValueEnumConst(wireName: r'approved')
  static const PtProgressReviewStatusEnum approved = _$ptProgressReviewStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'archived')
  static const PtProgressReviewStatusEnum archived = _$ptProgressReviewStatusEnum_archived;

  static Serializer<PtProgressReviewStatusEnum> get serializer => _$ptProgressReviewStatusEnumSerializer;

  const PtProgressReviewStatusEnum._(String name): super(name);

  static BuiltSet<PtProgressReviewStatusEnum> get values => _$ptProgressReviewStatusEnumValues;
  static PtProgressReviewStatusEnum valueOf(String name) => _$ptProgressReviewStatusEnumValueOf(name);
}

