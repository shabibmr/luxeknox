//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_metric.g.dart';

/// GoalMetric
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [unitOfMeasure] 
/// * [category] 
/// * [isActive] 
@BuiltValue()
abstract class GoalMetric implements Built<GoalMetric, GoalMetricBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'unit_of_measure')
  String get unitOfMeasure;

  @BuiltValueField(wireName: r'category')
  GoalMetricCategoryEnum get category;
  // enum categoryEnum {  body_composition,  circumference,  strength,  };

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  GoalMetric._();

  factory GoalMetric([void updates(GoalMetricBuilder b)]) = _$GoalMetric;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalMetricBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalMetric> get serializer => _$GoalMetricSerializer();
}

class _$GoalMetricSerializer implements PrimitiveSerializer<GoalMetric> {
  @override
  final Iterable<Type> types = const [GoalMetric, _$GoalMetric];

  @override
  final String wireName = r'GoalMetric';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalMetric object, {
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
    yield r'unit_of_measure';
    yield serializers.serialize(
      object.unitOfMeasure,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(GoalMetricCategoryEnum),
    );
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoalMetric object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalMetricBuilder result,
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
            specifiedType: const FullType(GoalMetricCategoryEnum),
          ) as GoalMetricCategoryEnum;
          result.category = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  GoalMetric deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalMetricBuilder();
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


class GoalMetricCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'body_composition')
  static const GoalMetricCategoryEnum bodyComposition = _$goalMetricCategoryEnum_bodyComposition;
  @BuiltValueEnumConst(wireName: r'circumference')
  static const GoalMetricCategoryEnum circumference = _$goalMetricCategoryEnum_circumference;
  @BuiltValueEnumConst(wireName: r'strength')
  static const GoalMetricCategoryEnum strength = _$goalMetricCategoryEnum_strength;

  static Serializer<GoalMetricCategoryEnum> get serializer => _$goalMetricCategoryEnumSerializer;

  const GoalMetricCategoryEnum._(String name): super(name);

  static BuiltSet<GoalMetricCategoryEnum> get values => _$goalMetricCategoryEnumValues;
  static GoalMetricCategoryEnum valueOf(String name) => _$goalMetricCategoryEnumValueOf(name);
}

