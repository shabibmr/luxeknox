//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/workout_plan_exercises_write_exercises_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_exercises_write.g.dart';

/// WorkoutPlanExercisesWrite
///
/// Properties:
/// * [changelog] 
/// * [rowVersion] 
/// * [exercises] 
@BuiltValue()
abstract class WorkoutPlanExercisesWrite implements Built<WorkoutPlanExercisesWrite, WorkoutPlanExercisesWriteBuilder> {
  @BuiltValueField(wireName: r'changelog')
  String? get changelog;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  @BuiltValueField(wireName: r'exercises')
  BuiltList<WorkoutPlanExercisesWriteExercisesInner> get exercises;

  WorkoutPlanExercisesWrite._();

  factory WorkoutPlanExercisesWrite([void updates(WorkoutPlanExercisesWriteBuilder b)]) = _$WorkoutPlanExercisesWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanExercisesWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanExercisesWrite> get serializer => _$WorkoutPlanExercisesWriteSerializer();
}

class _$WorkoutPlanExercisesWriteSerializer implements PrimitiveSerializer<WorkoutPlanExercisesWrite> {
  @override
  final Iterable<Type> types = const [WorkoutPlanExercisesWrite, _$WorkoutPlanExercisesWrite];

  @override
  final String wireName = r'WorkoutPlanExercisesWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanExercisesWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.changelog != null) {
      yield r'changelog';
      yield serializers.serialize(
        object.changelog,
        specifiedType: const FullType(String),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
    yield r'exercises';
    yield serializers.serialize(
      object.exercises,
      specifiedType: const FullType(BuiltList, [FullType(WorkoutPlanExercisesWriteExercisesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlanExercisesWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanExercisesWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changelog':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changelog = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        case r'exercises':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkoutPlanExercisesWriteExercisesInner)]),
          ) as BuiltList<WorkoutPlanExercisesWriteExercisesInner>;
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
  WorkoutPlanExercisesWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanExercisesWriteBuilder();
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


