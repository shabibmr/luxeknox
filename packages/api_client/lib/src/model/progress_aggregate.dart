//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_aggregate.g.dart';

/// ProgressAggregate
///
/// Properties:
/// * [activeGoals] 
/// * [achievedGoals] 
/// * [membersMeasured30d] 
/// * [photos30d] 
@BuiltValue()
abstract class ProgressAggregate implements Built<ProgressAggregate, ProgressAggregateBuilder> {
  @BuiltValueField(wireName: r'active_goals')
  int get activeGoals;

  @BuiltValueField(wireName: r'achieved_goals')
  int get achievedGoals;

  @BuiltValueField(wireName: r'members_measured_30d')
  int get membersMeasured30d;

  @BuiltValueField(wireName: r'photos_30d')
  int get photos30d;

  ProgressAggregate._();

  factory ProgressAggregate([void updates(ProgressAggregateBuilder b)]) = _$ProgressAggregate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressAggregateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressAggregate> get serializer => _$ProgressAggregateSerializer();
}

class _$ProgressAggregateSerializer implements PrimitiveSerializer<ProgressAggregate> {
  @override
  final Iterable<Type> types = const [ProgressAggregate, _$ProgressAggregate];

  @override
  final String wireName = r'ProgressAggregate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressAggregate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active_goals';
    yield serializers.serialize(
      object.activeGoals,
      specifiedType: const FullType(int),
    );
    yield r'achieved_goals';
    yield serializers.serialize(
      object.achievedGoals,
      specifiedType: const FullType(int),
    );
    yield r'members_measured_30d';
    yield serializers.serialize(
      object.membersMeasured30d,
      specifiedType: const FullType(int),
    );
    yield r'photos_30d';
    yield serializers.serialize(
      object.photos30d,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressAggregate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressAggregateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active_goals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeGoals = valueDes;
          break;
        case r'achieved_goals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.achievedGoals = valueDes;
          break;
        case r'members_measured_30d':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membersMeasured30d = valueDes;
          break;
        case r'photos_30d':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.photos30d = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressAggregate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressAggregateBuilder();
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


