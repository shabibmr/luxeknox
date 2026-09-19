//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_condition_write.g.dart';

/// HealthConditionWrite
///
/// Properties:
/// * [conditionName] 
/// * [riskLevel] 
/// * [contraindications] 
@BuiltValue()
abstract class HealthConditionWrite implements Built<HealthConditionWrite, HealthConditionWriteBuilder> {
  @BuiltValueField(wireName: r'condition_name')
  String get conditionName;

  @BuiltValueField(wireName: r'risk_level')
  String? get riskLevel;

  @BuiltValueField(wireName: r'contraindications')
  String? get contraindications;

  HealthConditionWrite._();

  factory HealthConditionWrite([void updates(HealthConditionWriteBuilder b)]) = _$HealthConditionWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthConditionWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthConditionWrite> get serializer => _$HealthConditionWriteSerializer();
}

class _$HealthConditionWriteSerializer implements PrimitiveSerializer<HealthConditionWrite> {
  @override
  final Iterable<Type> types = const [HealthConditionWrite, _$HealthConditionWrite];

  @override
  final String wireName = r'HealthConditionWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthConditionWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'condition_name';
    yield serializers.serialize(
      object.conditionName,
      specifiedType: const FullType(String),
    );
    if (object.riskLevel != null) {
      yield r'risk_level';
      yield serializers.serialize(
        object.riskLevel,
        specifiedType: const FullType(String),
      );
    }
    if (object.contraindications != null) {
      yield r'contraindications';
      yield serializers.serialize(
        object.contraindications,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthConditionWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthConditionWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'condition_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conditionName = valueDes;
          break;
        case r'risk_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.riskLevel = valueDes;
          break;
        case r'contraindications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contraindications = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HealthConditionWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthConditionWriteBuilder();
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


