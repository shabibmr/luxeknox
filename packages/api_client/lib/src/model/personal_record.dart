//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'personal_record.g.dart';

/// PersonalRecord
///
/// Properties:
/// * [exerciseId] 
/// * [exerciseName] 
/// * [maxWeightKg] 
/// * [maxReps] 
/// * [bestSetVolumeKg] 
/// * [achievedAt] - UTC ISO-8601
@BuiltValue()
abstract class PersonalRecord implements Built<PersonalRecord, PersonalRecordBuilder> {
  @BuiltValueField(wireName: r'exercise_id')
  int get exerciseId;

  @BuiltValueField(wireName: r'exercise_name')
  String get exerciseName;

  @BuiltValueField(wireName: r'max_weight_kg')
  num get maxWeightKg;

  @BuiltValueField(wireName: r'max_reps')
  int get maxReps;

  @BuiltValueField(wireName: r'best_set_volume_kg')
  num get bestSetVolumeKg;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'achieved_at')
  DateTime get achievedAt;

  PersonalRecord._();

  factory PersonalRecord([void updates(PersonalRecordBuilder b)]) = _$PersonalRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonalRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonalRecord> get serializer => _$PersonalRecordSerializer();
}

class _$PersonalRecordSerializer implements PrimitiveSerializer<PersonalRecord> {
  @override
  final Iterable<Type> types = const [PersonalRecord, _$PersonalRecord];

  @override
  final String wireName = r'PersonalRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonalRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'exercise_id';
    yield serializers.serialize(
      object.exerciseId,
      specifiedType: const FullType(int),
    );
    yield r'exercise_name';
    yield serializers.serialize(
      object.exerciseName,
      specifiedType: const FullType(String),
    );
    yield r'max_weight_kg';
    yield serializers.serialize(
      object.maxWeightKg,
      specifiedType: const FullType(num),
    );
    yield r'max_reps';
    yield serializers.serialize(
      object.maxReps,
      specifiedType: const FullType(int),
    );
    yield r'best_set_volume_kg';
    yield serializers.serialize(
      object.bestSetVolumeKg,
      specifiedType: const FullType(num),
    );
    yield r'achieved_at';
    yield serializers.serialize(
      object.achievedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonalRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonalRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'exercise_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.exerciseId = valueDes;
          break;
        case r'exercise_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.exerciseName = valueDes;
          break;
        case r'max_weight_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxWeightKg = valueDes;
          break;
        case r'max_reps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxReps = valueDes;
          break;
        case r'best_set_volume_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.bestSetVolumeKg = valueDes;
          break;
        case r'achieved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.achievedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonalRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonalRecordBuilder();
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


