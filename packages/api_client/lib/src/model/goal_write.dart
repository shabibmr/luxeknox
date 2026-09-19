//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_write.g.dart';

/// GoalWrite
///
/// Properties:
/// * [metricId] 
/// * [baselineValue] 
/// * [targetValue] 
/// * [startDate] 
/// * [targetDate] 
/// * [status] 
@BuiltValue()
abstract class GoalWrite implements Built<GoalWrite, GoalWriteBuilder> {
  @BuiltValueField(wireName: r'metric_id')
  int? get metricId;

  @BuiltValueField(wireName: r'baseline_value')
  num? get baselineValue;

  @BuiltValueField(wireName: r'target_value')
  num? get targetValue;

  @BuiltValueField(wireName: r'start_date')
  Date? get startDate;

  @BuiltValueField(wireName: r'target_date')
  Date? get targetDate;

  @BuiltValueField(wireName: r'status')
  GoalWriteStatusEnum? get status;
  // enum statusEnum {  in_progress,  achieved,  abandoned,  };

  GoalWrite._();

  factory GoalWrite([void updates(GoalWriteBuilder b)]) = _$GoalWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalWrite> get serializer => _$GoalWriteSerializer();
}

class _$GoalWriteSerializer implements PrimitiveSerializer<GoalWrite> {
  @override
  final Iterable<Type> types = const [GoalWrite, _$GoalWrite];

  @override
  final String wireName = r'GoalWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.metricId != null) {
      yield r'metric_id';
      yield serializers.serialize(
        object.metricId,
        specifiedType: const FullType(int),
      );
    }
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
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(GoalWriteStatusEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoalWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metric_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(GoalWriteStatusEnum),
          ) as GoalWriteStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoalWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalWriteBuilder();
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


class GoalWriteStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'in_progress')
  static const GoalWriteStatusEnum inProgress = _$goalWriteStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'achieved')
  static const GoalWriteStatusEnum achieved = _$goalWriteStatusEnum_achieved;
  @BuiltValueEnumConst(wireName: r'abandoned')
  static const GoalWriteStatusEnum abandoned = _$goalWriteStatusEnum_abandoned;

  static Serializer<GoalWriteStatusEnum> get serializer => _$goalWriteStatusEnumSerializer;

  const GoalWriteStatusEnum._(String name): super(name);

  static BuiltSet<GoalWriteStatusEnum> get values => _$goalWriteStatusEnumValues;
  static GoalWriteStatusEnum valueOf(String name) => _$goalWriteStatusEnumValueOf(name);
}

