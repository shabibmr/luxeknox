//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/workout_plan_exercise.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_version.g.dart';

/// WorkoutPlanVersion
///
/// Properties:
/// * [id] 
/// * [workoutPlanId] 
/// * [versionNumber] 
/// * [changelog] 
/// * [createdAt] - UTC ISO-8601
/// * [exercises] 
@BuiltValue()
abstract class WorkoutPlanVersion implements Built<WorkoutPlanVersion, WorkoutPlanVersionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'workout_plan_id')
  int get workoutPlanId;

  @BuiltValueField(wireName: r'version_number')
  int get versionNumber;

  @BuiltValueField(wireName: r'changelog')
  String? get changelog;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'exercises')
  BuiltList<WorkoutPlanExercise>? get exercises;

  WorkoutPlanVersion._();

  factory WorkoutPlanVersion([void updates(WorkoutPlanVersionBuilder b)]) = _$WorkoutPlanVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanVersion> get serializer => _$WorkoutPlanVersionSerializer();
}

class _$WorkoutPlanVersionSerializer implements PrimitiveSerializer<WorkoutPlanVersion> {
  @override
  final Iterable<Type> types = const [WorkoutPlanVersion, _$WorkoutPlanVersion];

  @override
  final String wireName = r'WorkoutPlanVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'workout_plan_id';
    yield serializers.serialize(
      object.workoutPlanId,
      specifiedType: const FullType(int),
    );
    yield r'version_number';
    yield serializers.serialize(
      object.versionNumber,
      specifiedType: const FullType(int),
    );
    if (object.changelog != null) {
      yield r'changelog';
      yield serializers.serialize(
        object.changelog,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.exercises != null) {
      yield r'exercises';
      yield serializers.serialize(
        object.exercises,
        specifiedType: const FullType(BuiltList, [FullType(WorkoutPlanExercise)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlanVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanVersionBuilder result,
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
        case r'workout_plan_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workoutPlanId = valueDes;
          break;
        case r'version_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.versionNumber = valueDes;
          break;
        case r'changelog':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changelog = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'exercises':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(WorkoutPlanExercise)]),
          ) as BuiltList<WorkoutPlanExercise>?;
          if (valueDes == null) continue;
          result.exercises.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutPlanVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanVersionBuilder();
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


