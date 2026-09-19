//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_session_create.g.dart';

/// WorkoutSessionCreate
///
/// Properties:
/// * [memberId] 
/// * [workoutPlanId] 
/// * [workoutPlanVersionId] 
@BuiltValue()
abstract class WorkoutSessionCreate implements Built<WorkoutSessionCreate, WorkoutSessionCreateBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int? get memberId;

  @BuiltValueField(wireName: r'workout_plan_id')
  int? get workoutPlanId;

  @BuiltValueField(wireName: r'workout_plan_version_id')
  int? get workoutPlanVersionId;

  WorkoutSessionCreate._();

  factory WorkoutSessionCreate([void updates(WorkoutSessionCreateBuilder b)]) = _$WorkoutSessionCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutSessionCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutSessionCreate> get serializer => _$WorkoutSessionCreateSerializer();
}

class _$WorkoutSessionCreateSerializer implements PrimitiveSerializer<WorkoutSessionCreate> {
  @override
  final Iterable<Type> types = const [WorkoutSessionCreate, _$WorkoutSessionCreate];

  @override
  final String wireName = r'WorkoutSessionCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutSessionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.memberId != null) {
      yield r'member_id';
      yield serializers.serialize(
        object.memberId,
        specifiedType: const FullType(int),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutSessionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutSessionCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutSessionCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutSessionCreateBuilder();
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


