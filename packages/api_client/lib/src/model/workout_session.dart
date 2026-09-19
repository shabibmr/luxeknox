//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/workout_session_exercise.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_session.g.dart';

/// WorkoutSession
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [workoutPlanId] 
/// * [workoutPlanVersionId] 
/// * [trainerId] 
/// * [startedAt] - UTC ISO-8601
/// * [completedAt] 
/// * [totalVolumeKg] 
/// * [durationMinutes] 
/// * [clientFeedbackRating] 
/// * [notes] 
/// * [sets] 
@BuiltValue()
abstract class WorkoutSession implements Built<WorkoutSession, WorkoutSessionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'workout_plan_id')
  int? get workoutPlanId;

  @BuiltValueField(wireName: r'workout_plan_version_id')
  int? get workoutPlanVersionId;

  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'started_at')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'total_volume_kg')
  num? get totalVolumeKg;

  @BuiltValueField(wireName: r'duration_minutes')
  int? get durationMinutes;

  @BuiltValueField(wireName: r'client_feedback_rating')
  int? get clientFeedbackRating;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'sets')
  BuiltList<WorkoutSessionExercise>? get sets;

  WorkoutSession._();

  factory WorkoutSession([void updates(WorkoutSessionBuilder b)]) = _$WorkoutSession;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutSessionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutSession> get serializer => _$WorkoutSessionSerializer();
}

class _$WorkoutSessionSerializer implements PrimitiveSerializer<WorkoutSession> {
  @override
  final Iterable<Type> types = const [WorkoutSession, _$WorkoutSession];

  @override
  final String wireName = r'WorkoutSession';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutSession object, {
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
    if (object.workoutPlanId != null) {
      yield r'workout_plan_id';
      yield serializers.serialize(
        object.workoutPlanId,
        specifiedType: const FullType(int),
      );
    }
    if (object.workoutPlanVersionId != null) {
      yield r'workout_plan_version_id';
      yield serializers.serialize(
        object.workoutPlanVersionId,
        specifiedType: const FullType(int),
      );
    }
    if (object.trainerId != null) {
      yield r'trainer_id';
      yield serializers.serialize(
        object.trainerId,
        specifiedType: const FullType(int),
      );
    }
    yield r'started_at';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.totalVolumeKg != null) {
      yield r'total_volume_kg';
      yield serializers.serialize(
        object.totalVolumeKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.durationMinutes != null) {
      yield r'duration_minutes';
      yield serializers.serialize(
        object.durationMinutes,
        specifiedType: const FullType(int),
      );
    }
    if (object.clientFeedbackRating != null) {
      yield r'client_feedback_rating';
      yield serializers.serialize(
        object.clientFeedbackRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.sets != null) {
      yield r'sets';
      yield serializers.serialize(
        object.sets,
        specifiedType: const FullType(BuiltList, [FullType(WorkoutSessionExercise)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutSession object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutSessionBuilder result,
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
        case r'workout_plan_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.workoutPlanId = valueDes;
          break;
        case r'workout_plan_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.workoutPlanVersionId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.trainerId = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'total_volume_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.totalVolumeKg = valueDes;
          break;
        case r'duration_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationMinutes = valueDes;
          break;
        case r'client_feedback_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.clientFeedbackRating = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'sets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(WorkoutSessionExercise)]),
          ) as BuiltList<WorkoutSessionExercise>?;
          if (valueDes == null) continue;
          result.sets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutSession deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutSessionBuilder();
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


