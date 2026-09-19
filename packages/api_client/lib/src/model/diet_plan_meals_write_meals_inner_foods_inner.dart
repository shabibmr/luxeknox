//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_meals_write_meals_inner_foods_inner.g.dart';

/// DietPlanMealsWriteMealsInnerFoodsInner
///
/// Properties:
/// * [foodId] 
/// * [quantity] 
/// * [servingUnit] 
@BuiltValue()
abstract class DietPlanMealsWriteMealsInnerFoodsInner implements Built<DietPlanMealsWriteMealsInnerFoodsInner, DietPlanMealsWriteMealsInnerFoodsInnerBuilder> {
  @BuiltValueField(wireName: r'food_id')
  int get foodId;

  @BuiltValueField(wireName: r'quantity')
  num get quantity;

  @BuiltValueField(wireName: r'serving_unit')
  String? get servingUnit;

  DietPlanMealsWriteMealsInnerFoodsInner._();

  factory DietPlanMealsWriteMealsInnerFoodsInner([void updates(DietPlanMealsWriteMealsInnerFoodsInnerBuilder b)]) = _$DietPlanMealsWriteMealsInnerFoodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanMealsWriteMealsInnerFoodsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanMealsWriteMealsInnerFoodsInner> get serializer => _$DietPlanMealsWriteMealsInnerFoodsInnerSerializer();
}

class _$DietPlanMealsWriteMealsInnerFoodsInnerSerializer implements PrimitiveSerializer<DietPlanMealsWriteMealsInnerFoodsInner> {
  @override
  final Iterable<Type> types = const [DietPlanMealsWriteMealsInnerFoodsInner, _$DietPlanMealsWriteMealsInnerFoodsInner];

  @override
  final String wireName = r'DietPlanMealsWriteMealsInnerFoodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanMealsWriteMealsInnerFoodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanMealsWriteMealsInnerFoodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanMealsWriteMealsInnerFoodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlanMealsWriteMealsInnerFoodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanMealsWriteMealsInnerFoodsInnerBuilder();
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


