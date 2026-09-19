//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_write.g.dart';

/// WorkoutPlanWrite
///
/// Properties:
/// * [title] 
/// * [description] 
/// * [memberId] 
/// * [trainerId] 
/// * [targetGoal] 
/// * [difficulty] 
/// * [durationWeeks] 
/// * [isTemplate] 
/// * [rowVersion] 
@BuiltValue()
abstract class WorkoutPlanWrite implements Built<WorkoutPlanWrite, WorkoutPlanWriteBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'member_id')
  int? get memberId;

  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  @BuiltValueField(wireName: r'target_goal')
  String? get targetGoal;

  @BuiltValueField(wireName: r'difficulty')
  String? get difficulty;

  @BuiltValueField(wireName: r'duration_weeks')
  int? get durationWeeks;

  @BuiltValueField(wireName: r'is_template')
  bool? get isTemplate;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  WorkoutPlanWrite._();

  factory WorkoutPlanWrite([void updates(WorkoutPlanWriteBuilder b)]) = _$WorkoutPlanWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanWrite> get serializer => _$WorkoutPlanWriteSerializer();
}

class _$WorkoutPlanWriteSerializer implements PrimitiveSerializer<WorkoutPlanWrite> {
  @override
  final Iterable<Type> types = const [WorkoutPlanWrite, _$WorkoutPlanWrite];

  @override
  final String wireName = r'WorkoutPlanWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.memberId != null) {
      yield r'member_id';
      yield serializers.serialize(
        object.memberId,
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
    if (object.targetGoal != null) {
      yield r'target_goal';
      yield serializers.serialize(
        object.targetGoal,
        specifiedType: const FullType(String),
      );
    }
    if (object.difficulty != null) {
      yield r'difficulty';
      yield serializers.serialize(
        object.difficulty,
        specifiedType: const FullType(String),
      );
    }
    if (object.durationWeeks != null) {
      yield r'duration_weeks';
      yield serializers.serialize(
        object.durationWeeks,
        specifiedType: const FullType(int),
      );
    }
    if (object.isTemplate != null) {
      yield r'is_template';
      yield serializers.serialize(
        object.isTemplate,
        specifiedType: const FullType(bool),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlanWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.memberId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.trainerId = valueDes;
          break;
        case r'target_goal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.targetGoal = valueDes;
          break;
        case r'difficulty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.difficulty = valueDes;
          break;
        case r'duration_weeks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationWeeks = valueDes;
          break;
        case r'is_template':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isTemplate = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutPlanWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanWriteBuilder();
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


