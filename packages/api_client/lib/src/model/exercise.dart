//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercise.g.dart';

/// Exercise
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [primaryMuscleGroup] 
/// * [secondaryMuscles] 
/// * [equipmentNeeded] 
/// * [instructions] 
/// * [videoUrl] - External https URL. Not an object key.
/// * [gifUrl] 
/// * [difficultyLevel] 
/// * [isActive] 
@BuiltValue()
abstract class Exercise implements Built<Exercise, ExerciseBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'primary_muscle_group')
  String? get primaryMuscleGroup;

  @BuiltValueField(wireName: r'secondary_muscles')
  BuiltList<String>? get secondaryMuscles;

  @BuiltValueField(wireName: r'equipment_needed')
  String? get equipmentNeeded;

  @BuiltValueField(wireName: r'instructions')
  String? get instructions;

  /// External https URL. Not an object key.
  @BuiltValueField(wireName: r'video_url')
  String? get videoUrl;

  @BuiltValueField(wireName: r'gif_url')
  String? get gifUrl;

  @BuiltValueField(wireName: r'difficulty_level')
  String? get difficultyLevel;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  Exercise._();

  factory Exercise([void updates(ExerciseBuilder b)]) = _$Exercise;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Exercise> get serializer => _$ExerciseSerializer();
}

class _$ExerciseSerializer implements PrimitiveSerializer<Exercise> {
  @override
  final Iterable<Type> types = const [Exercise, _$Exercise];

  @override
  final String wireName = r'Exercise';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Exercise object, {
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
    if (object.primaryMuscleGroup != null) {
      yield r'primary_muscle_group';
      yield serializers.serialize(
        object.primaryMuscleGroup,
        specifiedType: const FullType(String),
      );
    }
    if (object.secondaryMuscles != null) {
      yield r'secondary_muscles';
      yield serializers.serialize(
        object.secondaryMuscles,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.equipmentNeeded != null) {
      yield r'equipment_needed';
      yield serializers.serialize(
        object.equipmentNeeded,
        specifiedType: const FullType(String),
      );
    }
    if (object.instructions != null) {
      yield r'instructions';
      yield serializers.serialize(
        object.instructions,
        specifiedType: const FullType(String),
      );
    }
    if (object.videoUrl != null) {
      yield r'video_url';
      yield serializers.serialize(
        object.videoUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.gifUrl != null) {
      yield r'gif_url';
      yield serializers.serialize(
        object.gifUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.difficultyLevel != null) {
      yield r'difficulty_level';
      yield serializers.serialize(
        object.difficultyLevel,
        specifiedType: const FullType(String),
      );
    }
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Exercise object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciseBuilder result,
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
        case r'primary_muscle_group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryMuscleGroup = valueDes;
          break;
        case r'secondary_muscles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.secondaryMuscles.replace(valueDes);
          break;
        case r'equipment_needed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.equipmentNeeded = valueDes;
          break;
        case r'instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.instructions = valueDes;
          break;
        case r'video_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.videoUrl = valueDes;
          break;
        case r'gif_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gifUrl = valueDes;
          break;
        case r'difficulty_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.difficultyLevel = valueDes;
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
  Exercise deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciseBuilder();
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


