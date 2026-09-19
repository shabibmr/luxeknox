//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_condition.g.dart';

/// HealthCondition
///
/// Properties:
/// * [id] 
/// * [conditionName] 
/// * [riskLevel] 
/// * [contraindications] 
@BuiltValue()
abstract class HealthCondition implements Built<HealthCondition, HealthConditionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'condition_name')
  String get conditionName;

  @BuiltValueField(wireName: r'risk_level')
  String? get riskLevel;

  @BuiltValueField(wireName: r'contraindications')
  String? get contraindications;

  HealthCondition._();

  factory HealthCondition([void updates(HealthConditionBuilder b)]) = _$HealthCondition;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthConditionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthCondition> get serializer => _$HealthConditionSerializer();
}

class _$HealthConditionSerializer implements PrimitiveSerializer<HealthCondition> {
  @override
  final Iterable<Type> types = const [HealthCondition, _$HealthCondition];

  @override
  final String wireName = r'HealthCondition';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthCondition object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    HealthCondition object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthConditionBuilder result,
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
  HealthCondition deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthConditionBuilder();
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


