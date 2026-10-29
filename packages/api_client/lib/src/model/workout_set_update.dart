//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_set_update.g.dart';

/// WorkoutSetUpdate
///
/// Properties:
/// * [repsCompleted] 
/// * [weightLiftedKg] 
/// * [rpeScore] 
/// * [targetRir] 
/// * [actualRir] - Defaults to `target_rir` when omitted.
/// * [targetDurationSeconds] 
/// * [actualDurationSeconds] - Defaults to `target_duration_seconds` when omitted.
/// * [isCompleted] 
/// * [notes] 
@BuiltValue()
abstract class WorkoutSetUpdate implements Built<WorkoutSetUpdate, WorkoutSetUpdateBuilder> {
  @BuiltValueField(wireName: r'reps_completed')
  int? get repsCompleted;

  @BuiltValueField(wireName: r'weight_lifted_kg')
  num? get weightLiftedKg;

  @BuiltValueField(wireName: r'rpe_score')
  num? get rpeScore;

  @BuiltValueField(wireName: r'target_rir')
  num? get targetRir;

  /// Defaults to `target_rir` when omitted.
  @BuiltValueField(wireName: r'actual_rir')
  num? get actualRir;

  @BuiltValueField(wireName: r'target_duration_seconds')
  int? get targetDurationSeconds;

  /// Defaults to `target_duration_seconds` when omitted.
  @BuiltValueField(wireName: r'actual_duration_seconds')
  int? get actualDurationSeconds;

  @BuiltValueField(wireName: r'is_completed')
  bool? get isCompleted;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  WorkoutSetUpdate._();

  factory WorkoutSetUpdate([void updates(WorkoutSetUpdateBuilder b)]) = _$WorkoutSetUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutSetUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutSetUpdate> get serializer => _$WorkoutSetUpdateSerializer();
}

class _$WorkoutSetUpdateSerializer implements PrimitiveSerializer<WorkoutSetUpdate> {
  @override
  final Iterable<Type> types = const [WorkoutSetUpdate, _$WorkoutSetUpdate];

  @override
  final String wireName = r'WorkoutSetUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutSetUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.repsCompleted != null) {
      yield r'reps_completed';
      yield serializers.serialize(
        object.repsCompleted,
        specifiedType: const FullType(int),
      );
    }
    if (object.weightLiftedKg != null) {
      yield r'weight_lifted_kg';
      yield serializers.serialize(
        object.weightLiftedKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.rpeScore != null) {
      yield r'rpe_score';
      yield serializers.serialize(
        object.rpeScore,
        specifiedType: const FullType(num),
      );
    }
    if (object.targetRir != null) {
      yield r'target_rir';
      yield serializers.serialize(
        object.targetRir,
        specifiedType: const FullType(num),
      );
    }
    if (object.actualRir != null) {
      yield r'actual_rir';
      yield serializers.serialize(
        object.actualRir,
        specifiedType: const FullType(num),
      );
    }
    if (object.targetDurationSeconds != null) {
      yield r'target_duration_seconds';
      yield serializers.serialize(
        object.targetDurationSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.actualDurationSeconds != null) {
      yield r'actual_duration_seconds';
      yield serializers.serialize(
        object.actualDurationSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.isCompleted != null) {
      yield r'is_completed';
      yield serializers.serialize(
        object.isCompleted,
        specifiedType: const FullType(bool),
      );
    }
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
    WorkoutSetUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutSetUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reps_completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.repsCompleted = valueDes;
          break;
        case r'weight_lifted_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.weightLiftedKg = valueDes;
          break;
        case r'rpe_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.rpeScore = valueDes;
          break;
        case r'target_rir':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.targetRir = valueDes;
          break;
        case r'actual_rir':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.actualRir = valueDes;
          break;
        case r'target_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.targetDurationSeconds = valueDes;
          break;
        case r'actual_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.actualDurationSeconds = valueDes;
          break;
        case r'is_completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isCompleted = valueDes;
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
  WorkoutSetUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutSetUpdateBuilder();
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


