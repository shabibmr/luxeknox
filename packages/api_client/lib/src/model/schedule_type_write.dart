//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_type_write.g.dart';

/// ScheduleTypeWrite
///
/// Properties:
/// * [name] 
/// * [colorCode] 
/// * [defaultDurationMinutes] 
/// * [requiresTrainer] 
@BuiltValue()
abstract class ScheduleTypeWrite implements Built<ScheduleTypeWrite, ScheduleTypeWriteBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'color_code')
  String? get colorCode;

  @BuiltValueField(wireName: r'default_duration_minutes')
  int? get defaultDurationMinutes;

  @BuiltValueField(wireName: r'requires_trainer')
  bool? get requiresTrainer;

  ScheduleTypeWrite._();

  factory ScheduleTypeWrite([void updates(ScheduleTypeWriteBuilder b)]) = _$ScheduleTypeWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleTypeWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleTypeWrite> get serializer => _$ScheduleTypeWriteSerializer();
}

class _$ScheduleTypeWriteSerializer implements PrimitiveSerializer<ScheduleTypeWrite> {
  @override
  final Iterable<Type> types = const [ScheduleTypeWrite, _$ScheduleTypeWrite];

  @override
  final String wireName = r'ScheduleTypeWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleTypeWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.colorCode != null) {
      yield r'color_code';
      yield serializers.serialize(
        object.colorCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.defaultDurationMinutes != null) {
      yield r'default_duration_minutes';
      yield serializers.serialize(
        object.defaultDurationMinutes,
        specifiedType: const FullType(int),
      );
    }
    if (object.requiresTrainer != null) {
      yield r'requires_trainer';
      yield serializers.serialize(
        object.requiresTrainer,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduleTypeWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleTypeWriteBuilder result,
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
        case r'color_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.colorCode = valueDes;
          break;
        case r'default_duration_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.defaultDurationMinutes = valueDes;
          break;
        case r'requires_trainer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.requiresTrainer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduleTypeWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleTypeWriteBuilder();
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


