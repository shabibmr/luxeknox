//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_history.g.dart';

/// GoalHistory
///
/// Properties:
/// * [id] 
/// * [goalId] 
/// * [recordedValue] 
/// * [recordedDate] 
/// * [notes] 
@BuiltValue()
abstract class GoalHistory implements Built<GoalHistory, GoalHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'goal_id')
  int get goalId;

  @BuiltValueField(wireName: r'recorded_value')
  num get recordedValue;

  @BuiltValueField(wireName: r'recorded_date')
  Date get recordedDate;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  GoalHistory._();

  factory GoalHistory([void updates(GoalHistoryBuilder b)]) = _$GoalHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalHistory> get serializer => _$GoalHistorySerializer();
}

class _$GoalHistorySerializer implements PrimitiveSerializer<GoalHistory> {
  @override
  final Iterable<Type> types = const [GoalHistory, _$GoalHistory];

  @override
  final String wireName = r'GoalHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'goal_id';
    yield serializers.serialize(
      object.goalId,
      specifiedType: const FullType(int),
    );
    yield r'recorded_value';
    yield serializers.serialize(
      object.recordedValue,
      specifiedType: const FullType(num),
    );
    yield r'recorded_date';
    yield serializers.serialize(
      object.recordedDate,
      specifiedType: const FullType(Date),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoalHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalHistoryBuilder result,
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
        case r'goal_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.goalId = valueDes;
          break;
        case r'recorded_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.recordedValue = valueDes;
          break;
        case r'recorded_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.recordedDate = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoalHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalHistoryBuilder();
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


