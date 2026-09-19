//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/exercise.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_exercise.g.dart';

/// WorkoutPlanExercise
///
/// Properties:
/// * [id] 
/// * [workoutPlanVersionId] 
/// * [dayNumber] 
/// * [exerciseId] 
/// * [orderIndex] 
/// * [targetSets] 
/// * [targetReps] 
/// * [targetWeightKg] 
/// * [restSeconds] 
/// * [notes] 
/// * [exercise] 
@BuiltValue()
abstract class WorkoutPlanExercise implements Built<WorkoutPlanExercise, WorkoutPlanExerciseBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'workout_plan_version_id')
  int get workoutPlanVersionId;

  @BuiltValueField(wireName: r'day_number')
  int get dayNumber;

  @BuiltValueField(wireName: r'exercise_id')
  int get exerciseId;

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

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'exercise')
  Exercise? get exercise;

  WorkoutPlanExercise._();

  factory WorkoutPlanExercise([void updates(WorkoutPlanExerciseBuilder b)]) = _$WorkoutPlanExercise;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanExerciseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanExercise> get serializer => _$WorkoutPlanExerciseSerializer();
}

class _$WorkoutPlanExerciseSerializer implements PrimitiveSerializer<WorkoutPlanExercise> {
  @override
  final Iterable<Type> types = const [WorkoutPlanExercise, _$WorkoutPlanExercise];

  @override
  final String wireName = r'WorkoutPlanExercise';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanExercise object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'workout_plan_version_id';
    yield serializers.serialize(
      object.workoutPlanVersionId,
      specifiedType: const FullType(int),
    );
    yield r'day_number';
    yield serializers.serialize(
      object.dayNumber,
      specifiedType: const FullType(int),
    );
    yield r'exercise_id';
    yield serializers.serialize(
      object.exerciseId,
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
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.exercise != null) {
      yield r'exercise';
      yield serializers.serialize(
        object.exercise,
        specifiedType: const FullType(Exercise),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlanExercise object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanExerciseBuilder result,
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
        case r'workout_plan_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workoutPlanVersionId = valueDes;
          break;
        case r'day_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dayNumber = valueDes;
          break;
        case r'exercise_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.exerciseId = valueDes;
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
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'exercise':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Exercise),
          ) as Exercise?;
          if (valueDes == null) continue;
          result.exercise.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutPlanExercise deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanExerciseBuilder();
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


