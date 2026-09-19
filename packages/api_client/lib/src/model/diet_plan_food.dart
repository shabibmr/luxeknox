//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/food.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_food.g.dart';

/// DietPlanFood
///
/// Properties:
/// * [id] 
/// * [dietPlanMealId] 
/// * [foodId] 
/// * [quantity] 
/// * [servingUnit] 
/// * [food] 
@BuiltValue()
abstract class DietPlanFood implements Built<DietPlanFood, DietPlanFoodBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'diet_plan_meal_id')
  int get dietPlanMealId;

  @BuiltValueField(wireName: r'food_id')
  int get foodId;

  @BuiltValueField(wireName: r'quantity')
  num get quantity;

  @BuiltValueField(wireName: r'serving_unit')
  String? get servingUnit;

  @BuiltValueField(wireName: r'food')
  Food? get food;

  DietPlanFood._();

  factory DietPlanFood([void updates(DietPlanFoodBuilder b)]) = _$DietPlanFood;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanFoodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanFood> get serializer => _$DietPlanFoodSerializer();
}

class _$DietPlanFoodSerializer implements PrimitiveSerializer<DietPlanFood> {
  @override
  final Iterable<Type> types = const [DietPlanFood, _$DietPlanFood];

  @override
  final String wireName = r'DietPlanFood';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanFood object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'diet_plan_meal_id';
    yield serializers.serialize(
      object.dietPlanMealId,
      specifiedType: const FullType(int),
    );
    yield r'food_id';
    yield serializers.serialize(
      object.foodId,
      specifiedType: const FullType(int),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(num),
    );
    if (object.servingUnit != null) {
      yield r'serving_unit';
      yield serializers.serialize(
        object.servingUnit,
        specifiedType: const FullType(String),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType(Food),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanFood object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanFoodBuilder result,
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
        case r'diet_plan_meal_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dietPlanMealId = valueDes;
          break;
        case r'food_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.foodId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.quantity = valueDes;
          break;
        case r'serving_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.servingUnit = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Food),
          ) as Food?;
          if (valueDes == null) continue;
          result.food.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlanFood deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanFoodBuilder();
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


