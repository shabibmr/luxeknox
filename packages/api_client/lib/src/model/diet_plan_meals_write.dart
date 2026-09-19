//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/diet_plan_meals_write_meals_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_meals_write.g.dart';

/// DietPlanMealsWrite
///
/// Properties:
/// * [changelog] 
/// * [rowVersion] 
/// * [meals] 
@BuiltValue()
abstract class DietPlanMealsWrite implements Built<DietPlanMealsWrite, DietPlanMealsWriteBuilder> {
  @BuiltValueField(wireName: r'changelog')
  String? get changelog;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  @BuiltValueField(wireName: r'meals')
  BuiltList<DietPlanMealsWriteMealsInner> get meals;

  DietPlanMealsWrite._();

  factory DietPlanMealsWrite([void updates(DietPlanMealsWriteBuilder b)]) = _$DietPlanMealsWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanMealsWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanMealsWrite> get serializer => _$DietPlanMealsWriteSerializer();
}

class _$DietPlanMealsWriteSerializer implements PrimitiveSerializer<DietPlanMealsWrite> {
  @override
  final Iterable<Type> types = const [DietPlanMealsWrite, _$DietPlanMealsWrite];

  @override
  final String wireName = r'DietPlanMealsWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanMealsWrite object, {
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
    yield r'meals';
    yield serializers.serialize(
      object.meals,
      specifiedType: const FullType(BuiltList, [FullType(DietPlanMealsWriteMealsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanMealsWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanMealsWriteBuilder result,
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
        case r'meals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DietPlanMealsWriteMealsInner)]),
          ) as BuiltList<DietPlanMealsWriteMealsInner>;
          result.meals.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlanMealsWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanMealsWriteBuilder();
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


