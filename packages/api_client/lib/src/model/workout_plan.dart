//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/workout_plan_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan.g.dart';

/// WorkoutPlan
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [description] 
/// * [memberId] 
/// * [trainerId] 
/// * [targetGoal] 
/// * [difficulty] 
/// * [durationWeeks] 
/// * [isTemplate] 
/// * [status] 
/// * [createdAt] - UTC ISO-8601
/// * [rowVersion] 
/// * [currentVersion] 
@BuiltValue()
abstract class WorkoutPlan implements Built<WorkoutPlan, WorkoutPlanBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'title')
  String get title;

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
  bool get isTemplate;

  @BuiltValueField(wireName: r'status')
  WorkoutPlanStatusEnum get status;
  // enum statusEnum {  active,  archived,  draft,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'current_version')
  WorkoutPlanVersion? get currentVersion;

  WorkoutPlan._();

  factory WorkoutPlan([void updates(WorkoutPlanBuilder b)]) = _$WorkoutPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlan> get serializer => _$WorkoutPlanSerializer();
}

class _$WorkoutPlanSerializer implements PrimitiveSerializer<WorkoutPlan> {
  @override
  final Iterable<Type> types = const [WorkoutPlan, _$WorkoutPlan];

  @override
  final String wireName = r'WorkoutPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
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
    yield r'is_template';
    yield serializers.serialize(
      object.isTemplate,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WorkoutPlanStatusEnum),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    if (object.currentVersion != null) {
      yield r'current_version';
      yield serializers.serialize(
        object.currentVersion,
        specifiedType: const FullType(WorkoutPlanVersion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.isTemplate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkoutPlanStatusEnum),
          ) as WorkoutPlanStatusEnum;
          result.status = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'current_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkoutPlanVersion),
          ) as WorkoutPlanVersion?;
          if (valueDes == null) continue;
          result.currentVersion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanBuilder();
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


class WorkoutPlanStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const WorkoutPlanStatusEnum active = _$workoutPlanStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const WorkoutPlanStatusEnum archived = _$workoutPlanStatusEnum_archived;
  @BuiltValueEnumConst(wireName: r'draft')
  static const WorkoutPlanStatusEnum draft = _$workoutPlanStatusEnum_draft;

  static Serializer<WorkoutPlanStatusEnum> get serializer => _$workoutPlanStatusEnumSerializer;

  const WorkoutPlanStatusEnum._(String name): super(name);

  static BuiltSet<WorkoutPlanStatusEnum> get values => _$workoutPlanStatusEnumValues;
  static WorkoutPlanStatusEnum valueOf(String name) => _$workoutPlanStatusEnumValueOf(name);
}

