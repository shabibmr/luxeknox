//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/workout_session_exercise.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercise_history_session.g.dart';

/// ExerciseHistorySession
///
/// Properties:
/// * [sessionId] 
/// * [startedAt] - UTC ISO-8601
/// * [completedAt] - UTC ISO-8601
/// * [sets] 
@BuiltValue()
abstract class ExerciseHistorySession implements Built<ExerciseHistorySession, ExerciseHistorySessionBuilder> {
  @BuiltValueField(wireName: r'session_id')
  int get sessionId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'started_at')
  DateTime get startedAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'sets')
  BuiltList<WorkoutSessionExercise> get sets;

  ExerciseHistorySession._();

  factory ExerciseHistorySession([void updates(ExerciseHistorySessionBuilder b)]) = _$ExerciseHistorySession;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciseHistorySessionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciseHistorySession> get serializer => _$ExerciseHistorySessionSerializer();
}

class _$ExerciseHistorySessionSerializer implements PrimitiveSerializer<ExerciseHistorySession> {
  @override
  final Iterable<Type> types = const [ExerciseHistorySession, _$ExerciseHistorySession];

  @override
  final String wireName = r'ExerciseHistorySession';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciseHistorySession object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(int),
    );
    yield r'started_at';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'sets';
    yield serializers.serialize(
      object.sets,
      specifiedType: const FullType(BuiltList, [FullType(WorkoutSessionExercise)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciseHistorySession object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciseHistorySessionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sessionId = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'sets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkoutSessionExercise)]),
          ) as BuiltList<WorkoutSessionExercise>;
          result.sets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciseHistorySession deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciseHistorySessionBuilder();
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


