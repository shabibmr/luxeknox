//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_exercises_write_exercises_inner.g.dart';

/// WorkoutPlanExercisesWriteExercisesInner
///
/// Properties:
/// * [exerciseId] 
/// * [dayNumber] 
/// * [orderIndex] 
/// * [targetSets] 
/// * [targetReps] 
/// * [targetWeightKg] 
/// * [restSeconds] 
/// * [restBetweenExercisesSeconds] 
/// * [targetRir] - Reps in reserve. At most one decimal place. On update, an omitted field is left unchanged. Null or blank stores empty.
/// * [targetDurationSeconds] - Timed-set duration in seconds. On update, an omitted field is left unchanged. Null or blank stores empty.
/// * [notes] - On update, an omitted field is left unchanged. Null or blank stores empty.
@BuiltValue()
abstract class WorkoutPlanExercisesWriteExercisesInner implements Built<WorkoutPlanExercisesWriteExercisesInner, WorkoutPlanExercisesWriteExercisesInnerBuilder> {
  @BuiltValueField(wireName: r'exercise_id')
  int get exerciseId;

  @BuiltValueField(wireName: r'day_number')
  int get dayNumber;

  @BuiltValueField(wireName: r'order_index')
  int get orderIndex;

  @BuiltValueField(wireName: r'target_sets')
  int? get targetSets;

  @BuiltValueField(wireName: r'target_reps')
  String? get targetReps;

  @BuiltValueField(wireName: r'target_weight_kg')
  num? get targetWeightKg;

  @BuiltValueField(wireName: r'rest_seconds')
  int? get restSeconds;

  @BuiltValueField(wireName: r'rest_between_exercises_seconds')
  int? get restBetweenExercisesSeconds;

  /// Reps in reserve. At most one decimal place. On update, an omitted field is left unchanged. Null or blank stores empty.
  @BuiltValueField(wireName: r'target_rir')
  num? get targetRir;

  /// Timed-set duration in seconds. On update, an omitted field is left unchanged. Null or blank stores empty.
  @BuiltValueField(wireName: r'target_duration_seconds')
  int? get targetDurationSeconds;

  /// On update, an omitted field is left unchanged. Null or blank stores empty.
  @BuiltValueField(wireName: r'notes')
  String? get notes;

  WorkoutPlanExercisesWriteExercisesInner._();

  factory WorkoutPlanExercisesWriteExercisesInner([void updates(WorkoutPlanExercisesWriteExercisesInnerBuilder b)]) = _$WorkoutPlanExercisesWriteExercisesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanExercisesWriteExercisesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanExercisesWriteExercisesInner> get serializer => _$WorkoutPlanExercisesWriteExercisesInnerSerializer();
}

class _$WorkoutPlanExercisesWriteExercisesInnerSerializer implements PrimitiveSerializer<WorkoutPlanExercisesWriteExercisesInner> {
  @override
  final Iterable<Type> types = const [WorkoutPlanExercisesWriteExercisesInner, _$WorkoutPlanExercisesWriteExercisesInner];

  @override
  final String wireName = r'WorkoutPlanExercisesWriteExercisesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanExercisesWriteExercisesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'exercise_id';
    yield serializers.serialize(
      object.exerciseId,
      specifiedType: const FullType(int),
    );
    yield r'day_number';
    yield serializers.serialize(
      object.dayNumber,
      specifiedType: const FullType(int),
    );
    yield r'order_index';
    yield serializers.serialize(
      object.orderIndex,
      specifiedType: const FullType(int),
    );
    if (object.targetSets != null) {
      yield r'target_sets';
      yield serializers.serialize(
        object.targetSets,
        specifiedType: const FullType(int),
      );
    }
    if (object.targetReps != null) {
      yield r'target_reps';
      yield serializers.serialize(
        object.targetReps,
        specifiedType: const FullType(String),
      );
    }
    if (object.targetWeightKg != null) {
      yield r'target_weight_kg';
      yield serializers.serialize(
        object.targetWeightKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.restSeconds != null) {
      yield r'rest_seconds';
      yield serializers.serialize(
        object.restSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.restBetweenExercisesSeconds != null) {
      yield r'rest_between_exercises_seconds';
      yield serializers.serialize(
        object.restBetweenExercisesSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.targetRir != null) {
      yield r'target_rir';
      yield serializers.serialize(
        object.targetRir,
        specifiedType: const FullType(num),
      );
    }
    if (object.targetDurationSeconds != null) {
      yield r'target_duration_seconds';
      yield serializers.serialize(
        object.targetDurationSeconds,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlanExercisesWriteExercisesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanExercisesWriteExercisesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'exercise_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.exerciseId = valueDes;
          break;
        case r'day_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dayNumber = valueDes;
          break;
        case r'order_index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orderIndex = valueDes;
          break;
        case r'target_sets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.targetSets = valueDes;
          break;
        case r'target_reps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.targetReps = valueDes;
          break;
        case r'target_weight_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.targetWeightKg = valueDes;
          break;
        case r'rest_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.restSeconds = valueDes;
          break;
        case r'rest_between_exercises_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.restBetweenExercisesSeconds = valueDes;
          break;
        case r'target_rir':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.targetRir = valueDes;
          break;
        case r'target_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.targetDurationSeconds = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutPlanExercisesWriteExercisesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanExercisesWriteExercisesInnerBuilder();
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


