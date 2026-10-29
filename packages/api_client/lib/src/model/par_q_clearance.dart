//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'par_q_clearance.g.dart';

/// ParQClearance
///
/// Properties:
/// * [decision] 
@BuiltValue()
abstract class ParQClearance implements Built<ParQClearance, ParQClearanceBuilder> {
  @BuiltValueField(wireName: r'decision')
  ParQClearanceDecisionEnum get decision;
  // enum decisionEnum {  cleared,  rejected,  };

  ParQClearance._();

  factory ParQClearance([void updates(ParQClearanceBuilder b)]) = _$ParQClearance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParQClearanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParQClearance> get serializer => _$ParQClearanceSerializer();
}

class _$ParQClearanceSerializer implements PrimitiveSerializer<ParQClearance> {
  @override
  final Iterable<Type> types = const [ParQClearance, _$ParQClearance];

  @override
  final String wireName = r'ParQClearance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParQClearance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(ParQClearanceDecisionEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ParQClearance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParQClearanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ParQClearanceDecisionEnum),
          ) as ParQClearanceDecisionEnum;
          result.decision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParQClearance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParQClearanceBuilder();
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


class ParQClearanceDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'cleared')
  static const ParQClearanceDecisionEnum cleared = _$parQClearanceDecisionEnum_cleared;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const ParQClearanceDecisionEnum rejected = _$parQClearanceDecisionEnum_rejected;

  static Serializer<ParQClearanceDecisionEnum> get serializer => _$parQClearanceDecisionEnumSerializer;

  const ParQClearanceDecisionEnum._(String name): super(name);

  static BuiltSet<ParQClearanceDecisionEnum> get values => _$parQClearanceDecisionEnumValues;
  static ParQClearanceDecisionEnum valueOf(String name) => _$parQClearanceDecisionEnumValueOf(name);
}

