//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/diet_plan_meals_write_meals_inner_foods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_meals_write_meals_inner.g.dart';

/// DietPlanMealsWriteMealsInner
///
/// Properties:
/// * [mealName] 
/// * [scheduledTime] 
/// * [targetCalories] 
/// * [notes] 
/// * [foods] 
@BuiltValue()
abstract class DietPlanMealsWriteMealsInner implements Built<DietPlanMealsWriteMealsInner, DietPlanMealsWriteMealsInnerBuilder> {
  @BuiltValueField(wireName: r'meal_name')
  String get mealName;

  @BuiltValueField(wireName: r'scheduled_time')
  String? get scheduledTime;

  @BuiltValueField(wireName: r'target_calories')
  int? get targetCalories;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'foods')
  BuiltList<DietPlanMealsWriteMealsInnerFoodsInner>? get foods;

  DietPlanMealsWriteMealsInner._();

  factory DietPlanMealsWriteMealsInner([void updates(DietPlanMealsWriteMealsInnerBuilder b)]) = _$DietPlanMealsWriteMealsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanMealsWriteMealsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanMealsWriteMealsInner> get serializer => _$DietPlanMealsWriteMealsInnerSerializer();
}

class _$DietPlanMealsWriteMealsInnerSerializer implements PrimitiveSerializer<DietPlanMealsWriteMealsInner> {
  @override
  final Iterable<Type> types = const [DietPlanMealsWriteMealsInner, _$DietPlanMealsWriteMealsInner];

  @override
  final String wireName = r'DietPlanMealsWriteMealsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanMealsWriteMealsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
        specifiedType: const FullType(BuiltList, [FullType(DietPlanMealsWriteMealsInnerFoodsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanMealsWriteMealsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanMealsWriteMealsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(DietPlanMealsWriteMealsInnerFoodsInner)]),
          ) as BuiltList<DietPlanMealsWriteMealsInnerFoodsInner>?;
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
  DietPlanMealsWriteMealsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanMealsWriteMealsInnerBuilder();
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


