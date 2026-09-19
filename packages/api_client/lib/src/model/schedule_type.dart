//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_type.g.dart';

/// ScheduleType
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [colorCode] 
/// * [defaultDurationMinutes] 
/// * [requiresTrainer] 
@BuiltValue()
abstract class ScheduleType implements Built<ScheduleType, ScheduleTypeBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'color_code')
  String? get colorCode;

  @BuiltValueField(wireName: r'default_duration_minutes')
  int? get defaultDurationMinutes;

  @BuiltValueField(wireName: r'requires_trainer')
  bool? get requiresTrainer;

  ScheduleType._();

  factory ScheduleType([void updates(ScheduleTypeBuilder b)]) = _$ScheduleType;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleTypeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleType> get serializer => _$ScheduleTypeSerializer();
}

class _$ScheduleTypeSerializer implements PrimitiveSerializer<ScheduleType> {
  @override
  final Iterable<Type> types = const [ScheduleType, _$ScheduleType];

  @override
  final String wireName = r'ScheduleType';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleType object, {
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
    ScheduleType object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleTypeBuilder result,
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
  ScheduleType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleTypeBuilder();
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


