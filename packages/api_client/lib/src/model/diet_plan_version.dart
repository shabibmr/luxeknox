//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/diet_plan_meal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_version.g.dart';

/// DietPlanVersion
///
/// Properties:
/// * [id] 
/// * [dietPlanId] 
/// * [versionNumber] 
/// * [changelog] 
/// * [createdAt] - UTC ISO-8601
/// * [meals] 
@BuiltValue()
abstract class DietPlanVersion implements Built<DietPlanVersion, DietPlanVersionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'diet_plan_id')
  int get dietPlanId;

  @BuiltValueField(wireName: r'version_number')
  int get versionNumber;

  @BuiltValueField(wireName: r'changelog')
  String? get changelog;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'meals')
  BuiltList<DietPlanMeal>? get meals;

  DietPlanVersion._();

  factory DietPlanVersion([void updates(DietPlanVersionBuilder b)]) = _$DietPlanVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanVersion> get serializer => _$DietPlanVersionSerializer();
}

class _$DietPlanVersionSerializer implements PrimitiveSerializer<DietPlanVersion> {
  @override
  final Iterable<Type> types = const [DietPlanVersion, _$DietPlanVersion];

  @override
  final String wireName = r'DietPlanVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'diet_plan_id';
    yield serializers.serialize(
      object.dietPlanId,
      specifiedType: const FullType(int),
    );
    yield r'version_number';
    yield serializers.serialize(
      object.versionNumber,
      specifiedType: const FullType(int),
    );
    if (object.changelog != null) {
      yield r'changelog';
      yield serializers.serialize(
        object.changelog,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.meals != null) {
      yield r'meals';
      yield serializers.serialize(
        object.meals,
        specifiedType: const FullType(BuiltList, [FullType(DietPlanMeal)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanVersionBuilder result,
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
        case r'diet_plan_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dietPlanId = valueDes;
          break;
        case r'version_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.versionNumber = valueDes;
          break;
        case r'changelog':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changelog = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'meals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DietPlanMeal)]),
          ) as BuiltList<DietPlanMeal>?;
          if (valueDes == null) continue;
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
  DietPlanVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanVersionBuilder();
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


