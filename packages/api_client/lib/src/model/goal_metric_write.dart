//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_metric_write.g.dart';

/// GoalMetricWrite
///
/// Properties:
/// * [name] 
/// * [unitOfMeasure] 
/// * [category] 
/// * [isActive] 
@BuiltValue()
abstract class GoalMetricWrite implements Built<GoalMetricWrite, GoalMetricWriteBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'unit_of_measure')
  String get unitOfMeasure;

  @BuiltValueField(wireName: r'category')
  GoalMetricWriteCategoryEnum get category;
  // enum categoryEnum {  body_composition,  circumference,  strength,  };

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  GoalMetricWrite._();

  factory GoalMetricWrite([void updates(GoalMetricWriteBuilder b)]) = _$GoalMetricWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalMetricWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalMetricWrite> get serializer => _$GoalMetricWriteSerializer();
}

class _$GoalMetricWriteSerializer implements PrimitiveSerializer<GoalMetricWrite> {
  @override
  final Iterable<Type> types = const [GoalMetricWrite, _$GoalMetricWrite];

  @override
  final String wireName = r'GoalMetricWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalMetricWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'unit_of_measure';
    yield serializers.serialize(
      object.unitOfMeasure,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(GoalMetricWriteCategoryEnum),
    );
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoalMetricWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalMetricWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'unit_of_measure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitOfMeasure = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoalMetricWriteCategoryEnum),
          ) as GoalMetricWriteCategoryEnum;
          result.category = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoalMetricWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalMetricWriteBuilder();
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


class GoalMetricWriteCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'body_composition')
  static const GoalMetricWriteCategoryEnum bodyComposition = _$goalMetricWriteCategoryEnum_bodyComposition;
  @BuiltValueEnumConst(wireName: r'circumference')
  static const GoalMetricWriteCategoryEnum circumference = _$goalMetricWriteCategoryEnum_circumference;
  @BuiltValueEnumConst(wireName: r'strength')
  static const GoalMetricWriteCategoryEnum strength = _$goalMetricWriteCategoryEnum_strength;

  static Serializer<GoalMetricWriteCategoryEnum> get serializer => _$goalMetricWriteCategoryEnumSerializer;

  const GoalMetricWriteCategoryEnum._(String name): super(name);

  static BuiltSet<GoalMetricWriteCategoryEnum> get values => _$goalMetricWriteCategoryEnumValues;
  static GoalMetricWriteCategoryEnum valueOf(String name) => _$goalMetricWriteCategoryEnumValueOf(name);
}

