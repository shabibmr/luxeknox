//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/lifestyle_priority.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lifestyle_intake.g.dart';

/// LifestyleIntake
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [activityLevel] 
/// * [trainingHistory] 
/// * [currentPainDiscomfort] 
/// * [sleepHoursTypical] - Decimal string.
/// * [stressLevel] 
/// * [workActivityDemands] 
/// * [typicalDailySteps] 
/// * [nutritionApproach] 
/// * [hydrationHabits] 
/// * [recoveryHabits] 
/// * [otherNotes] 
/// * [lifestylePriorities] 
/// * [conductedByTrainerId] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
@BuiltValue()
abstract class LifestyleIntake implements Built<LifestyleIntake, LifestyleIntakeBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'activity_level')
  String? get activityLevel;

  @BuiltValueField(wireName: r'training_history')
  String? get trainingHistory;

  @BuiltValueField(wireName: r'current_pain_discomfort')
  String? get currentPainDiscomfort;

  /// Decimal string.
  @BuiltValueField(wireName: r'sleep_hours_typical')
  String? get sleepHoursTypical;

  @BuiltValueField(wireName: r'stress_level')
  int get stressLevel;

  @BuiltValueField(wireName: r'work_activity_demands')
  String? get workActivityDemands;

  @BuiltValueField(wireName: r'typical_daily_steps')
  int? get typicalDailySteps;

  @BuiltValueField(wireName: r'nutrition_approach')
  String? get nutritionApproach;

  @BuiltValueField(wireName: r'hydration_habits')
  String? get hydrationHabits;

  @BuiltValueField(wireName: r'recovery_habits')
  String? get recoveryHabits;

  @BuiltValueField(wireName: r'other_notes')
  String? get otherNotes;

  @BuiltValueField(wireName: r'lifestyle_priorities')
  BuiltList<LifestylePriority>? get lifestylePriorities;

  @BuiltValueField(wireName: r'conducted_by_trainer_id')
  int? get conductedByTrainerId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  LifestyleIntake._();

  factory LifestyleIntake([void updates(LifestyleIntakeBuilder b)]) = _$LifestyleIntake;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LifestyleIntakeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LifestyleIntake> get serializer => _$LifestyleIntakeSerializer();
}

class _$LifestyleIntakeSerializer implements PrimitiveSerializer<LifestyleIntake> {
  @override
  final Iterable<Type> types = const [LifestyleIntake, _$LifestyleIntake];

  @override
  final String wireName = r'LifestyleIntake';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LifestyleIntake object, {
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
    if (object.activityLevel != null) {
      yield r'activity_level';
      yield serializers.serialize(
        object.activityLevel,
        specifiedType: const FullType(String),
      );
    }
    if (object.trainingHistory != null) {
      yield r'training_history';
      yield serializers.serialize(
        object.trainingHistory,
        specifiedType: const FullType(String),
      );
    }
    if (object.currentPainDiscomfort != null) {
      yield r'current_pain_discomfort';
      yield serializers.serialize(
        object.currentPainDiscomfort,
        specifiedType: const FullType(String),
      );
    }
    if (object.sleepHoursTypical != null) {
      yield r'sleep_hours_typical';
      yield serializers.serialize(
        object.sleepHoursTypical,
        specifiedType: const FullType(String),
      );
    }
    yield r'stress_level';
    yield serializers.serialize(
      object.stressLevel,
      specifiedType: const FullType(int),
    );
    if (object.workActivityDemands != null) {
      yield r'work_activity_demands';
      yield serializers.serialize(
        object.workActivityDemands,
        specifiedType: const FullType(String),
      );
    }
    if (object.typicalDailySteps != null) {
      yield r'typical_daily_steps';
      yield serializers.serialize(
        object.typicalDailySteps,
        specifiedType: const FullType(int),
      );
    }
    if (object.nutritionApproach != null) {
      yield r'nutrition_approach';
      yield serializers.serialize(
        object.nutritionApproach,
        specifiedType: const FullType(String),
      );
    }
    if (object.hydrationHabits != null) {
      yield r'hydration_habits';
      yield serializers.serialize(
        object.hydrationHabits,
        specifiedType: const FullType(String),
      );
    }
    if (object.recoveryHabits != null) {
      yield r'recovery_habits';
      yield serializers.serialize(
        object.recoveryHabits,
        specifiedType: const FullType(String),
      );
    }
    if (object.otherNotes != null) {
      yield r'other_notes';
      yield serializers.serialize(
        object.otherNotes,
        specifiedType: const FullType(String),
      );
    }
    if (object.lifestylePriorities != null) {
      yield r'lifestyle_priorities';
      yield serializers.serialize(
        object.lifestylePriorities,
        specifiedType: const FullType(BuiltList, [FullType(LifestylePriority)]),
      );
    }
    if (object.conductedByTrainerId != null) {
      yield r'conducted_by_trainer_id';
      yield serializers.serialize(
        object.conductedByTrainerId,
        specifiedType: const FullType(int),
      );
    }
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
    LifestyleIntake object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LifestyleIntakeBuilder result,
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
        case r'activity_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activityLevel = valueDes;
          break;
        case r'training_history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.trainingHistory = valueDes;
          break;
        case r'current_pain_discomfort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentPainDiscomfort = valueDes;
          break;
        case r'sleep_hours_typical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sleepHoursTypical = valueDes;
          break;
        case r'stress_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stressLevel = valueDes;
          break;
        case r'work_activity_demands':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.workActivityDemands = valueDes;
          break;
        case r'typical_daily_steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.typicalDailySteps = valueDes;
          break;
        case r'nutrition_approach':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nutritionApproach = valueDes;
          break;
        case r'hydration_habits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hydrationHabits = valueDes;
          break;
        case r'recovery_habits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recoveryHabits = valueDes;
          break;
        case r'other_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otherNotes = valueDes;
          break;
        case r'lifestyle_priorities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(LifestylePriority)]),
          ) as BuiltList<LifestylePriority>?;
          if (valueDes == null) continue;
          result.lifestylePriorities.replace(valueDes);
          break;
        case r'conducted_by_trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.conductedByTrainerId = valueDes;
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
  LifestyleIntake deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LifestyleIntakeBuilder();
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


