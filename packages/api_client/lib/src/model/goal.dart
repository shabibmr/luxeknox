//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/goal_metric.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal.g.dart';

/// Goal
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [metricId] 
/// * [baselineValue] 
/// * [targetValue] 
/// * [currentValue] 
/// * [startDate] 
/// * [targetDate] 
/// * [status] 
/// * [metric] 
@BuiltValue()
abstract class Goal implements Built<Goal, GoalBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'metric_id')
  int get metricId;

  @BuiltValueField(wireName: r'baseline_value')
  num? get baselineValue;

  @BuiltValueField(wireName: r'target_value')
  num? get targetValue;

  @BuiltValueField(wireName: r'current_value')
  num? get currentValue;

  @BuiltValueField(wireName: r'start_date')
  Date? get startDate;

  @BuiltValueField(wireName: r'target_date')
  Date? get targetDate;

  @BuiltValueField(wireName: r'status')
  GoalStatusEnum get status;
  // enum statusEnum {  in_progress,  achieved,  abandoned,  };

  @BuiltValueField(wireName: r'metric')
  GoalMetric? get metric;

  Goal._();

  factory Goal([void updates(GoalBuilder b)]) = _$Goal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Goal> get serializer => _$GoalSerializer();
}

class _$GoalSerializer implements PrimitiveSerializer<Goal> {
  @override
  final Iterable<Type> types = const [Goal, _$Goal];

  @override
  final String wireName = r'Goal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Goal object, {
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
    yield r'metric_id';
    yield serializers.serialize(
      object.metricId,
      specifiedType: const FullType(int),
    );
    if (object.baselineValue != null) {
      yield r'baseline_value';
      yield serializers.serialize(
        object.baselineValue,
        specifiedType: const FullType(num),
      );
    }
    if (object.targetValue != null) {
      yield r'target_value';
      yield serializers.serialize(
        object.targetValue,
        specifiedType: const FullType(num),
      );
    }
    if (object.currentValue != null) {
      yield r'current_value';
      yield serializers.serialize(
        object.currentValue,
        specifiedType: const FullType(num),
      );
    }
    if (object.startDate != null) {
      yield r'start_date';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.targetDate != null) {
      yield r'target_date';
      yield serializers.serialize(
        object.targetDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GoalStatusEnum),
    );
    if (object.metric != null) {
      yield r'metric';
      yield serializers.serialize(
        object.metric,
        specifiedType: const FullType(GoalMetric),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Goal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalBuilder result,
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
        case r'metric_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.metricId = valueDes;
          break;
        case r'baseline_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.baselineValue = valueDes;
          break;
        case r'target_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.targetValue = valueDes;
          break;
        case r'current_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.currentValue = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.startDate = valueDes;
          break;
        case r'target_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.targetDate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoalStatusEnum),
          ) as GoalStatusEnum;
          result.status = valueDes;
          break;
        case r'metric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GoalMetric),
          ) as GoalMetric?;
          if (valueDes == null) continue;
          result.metric.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Goal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalBuilder();
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


class GoalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'in_progress')
  static const GoalStatusEnum inProgress = _$goalStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'achieved')
  static const GoalStatusEnum achieved = _$goalStatusEnum_achieved;
  @BuiltValueEnumConst(wireName: r'abandoned')
  static const GoalStatusEnum abandoned = _$goalStatusEnum_abandoned;

  static Serializer<GoalStatusEnum> get serializer => _$goalStatusEnumSerializer;

  const GoalStatusEnum._(String name): super(name);

  static BuiltSet<GoalStatusEnum> get values => _$goalStatusEnumValues;
  static GoalStatusEnum valueOf(String name) => _$goalStatusEnumValueOf(name);
}

