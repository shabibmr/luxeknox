//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food.g.dart';

/// Food
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [servingUnit] 
/// * [servingSize] 
/// * [calories] 
/// * [proteinGrams] 
/// * [carbsGrams] 
/// * [fatGrams] 
/// * [fiberGrams] 
/// * [isVerified] 
@BuiltValue()
abstract class Food implements Built<Food, FoodBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'serving_unit')
  String get servingUnit;

  @BuiltValueField(wireName: r'serving_size')
  num? get servingSize;

  @BuiltValueField(wireName: r'calories')
  num? get calories;

  @BuiltValueField(wireName: r'protein_grams')
  num? get proteinGrams;

  @BuiltValueField(wireName: r'carbs_grams')
  num? get carbsGrams;

  @BuiltValueField(wireName: r'fat_grams')
  num? get fatGrams;

  @BuiltValueField(wireName: r'fiber_grams')
  num? get fiberGrams;

  @BuiltValueField(wireName: r'is_verified')
  bool? get isVerified;

  Food._();

  factory Food([void updates(FoodBuilder b)]) = _$Food;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FoodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Food> get serializer => _$FoodSerializer();
}

class _$FoodSerializer implements PrimitiveSerializer<Food> {
  @override
  final Iterable<Type> types = const [Food, _$Food];

  @override
  final String wireName = r'Food';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Food object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'serving_unit';
    yield serializers.serialize(
      object.servingUnit,
      specifiedType: const FullType(String),
    );
    if (object.servingSize != null) {
      yield r'serving_size';
      yield serializers.serialize(
        object.servingSize,
        specifiedType: const FullType(num),
      );
    }
    if (object.calories != null) {
      yield r'calories';
      yield serializers.serialize(
        object.calories,
        specifiedType: const FullType(num),
      );
    }
    if (object.proteinGrams != null) {
      yield r'protein_grams';
      yield serializers.serialize(
        object.proteinGrams,
        specifiedType: const FullType(num),
      );
    }
    if (object.carbsGrams != null) {
      yield r'carbs_grams';
      yield serializers.serialize(
        object.carbsGrams,
        specifiedType: const FullType(num),
      );
    }
    if (object.fatGrams != null) {
      yield r'fat_grams';
      yield serializers.serialize(
        object.fatGrams,
        specifiedType: const FullType(num),
      );
    }
    if (object.fiberGrams != null) {
      yield r'fiber_grams';
      yield serializers.serialize(
        object.fiberGrams,
        specifiedType: const FullType(num),
      );
    }
    if (object.isVerified != null) {
      yield r'is_verified';
      yield serializers.serialize(
        object.isVerified,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Food object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FoodBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'serving_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.servingUnit = valueDes;
          break;
        case r'serving_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.servingSize = valueDes;
          break;
        case r'calories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.calories = valueDes;
          break;
        case r'protein_grams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.proteinGrams = valueDes;
          break;
        case r'carbs_grams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.carbsGrams = valueDes;
          break;
        case r'fat_grams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.fatGrams = valueDes;
          break;
        case r'fiber_grams':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.fiberGrams = valueDes;
          break;
        case r'is_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isVerified = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Food deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FoodBuilder();
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


