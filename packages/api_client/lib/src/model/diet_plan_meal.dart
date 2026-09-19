//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/diet_plan_food.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_meal.g.dart';

/// DietPlanMeal
///
/// Properties:
/// * [id] 
/// * [dietPlanVersionId] 
/// * [mealName] 
/// * [scheduledTime] 
/// * [targetCalories] 
/// * [notes] 
/// * [foods] 
@BuiltValue()
abstract class DietPlanMeal implements Built<DietPlanMeal, DietPlanMealBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'diet_plan_version_id')
  int get dietPlanVersionId;

  @BuiltValueField(wireName: r'meal_name')
  String get mealName;

  @BuiltValueField(wireName: r'scheduled_time')
  String? get scheduledTime;

  @BuiltValueField(wireName: r'target_calories')
  int? get targetCalories;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'foods')
  BuiltList<DietPlanFood>? get foods;

  DietPlanMeal._();

  factory DietPlanMeal([void updates(DietPlanMealBuilder b)]) = _$DietPlanMeal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanMealBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanMeal> get serializer => _$DietPlanMealSerializer();
}

class _$DietPlanMealSerializer implements PrimitiveSerializer<DietPlanMeal> {
  @override
  final Iterable<Type> types = const [DietPlanMeal, _$DietPlanMeal];

  @override
  final String wireName = r'DietPlanMeal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanMeal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'diet_plan_version_id';
    yield serializers.serialize(
      object.dietPlanVersionId,
      specifiedType: const FullType(int),
    );
    yield r'meal_name';
    yield serializers.serialize(
      object.mealName,
      specifiedType: const FullType(String),
    );
    if (object.scheduledTime != null) {
      yield r'scheduled_time';
      yield serializers.serialize(
        object.scheduledTime,
        specifiedType: const FullType(String),
      );
    }
    if (object.targetCalories != null) {
      yield r'target_calories';
      yield serializers.serialize(
        object.targetCalories,
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
    if (object.foods != null) {
      yield r'foods';
      yield serializers.serialize(
        object.foods,
        specifiedType: const FullType(BuiltList, [FullType(DietPlanFood)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanMeal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanMealBuilder result,
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
        case r'diet_plan_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dietPlanVersionId = valueDes;
          break;
        case r'meal_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mealName = valueDes;
          break;
        case r'scheduled_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scheduledTime = valueDes;
          break;
        case r'target_calories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.targetCalories = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'foods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DietPlanFood)]),
          ) as BuiltList<DietPlanFood>?;
          if (valueDes == null) continue;
          result.foods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlanMeal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanMealBuilder();
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


