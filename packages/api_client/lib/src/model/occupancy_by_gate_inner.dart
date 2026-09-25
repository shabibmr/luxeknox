//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'occupancy_by_gate_inner.g.dart';

/// OccupancyByGateInner
///
/// Properties:
/// * [gateIdentifier] 
/// * [count] 
@BuiltValue()
abstract class OccupancyByGateInner implements Built<OccupancyByGateInner, OccupancyByGateInnerBuilder> {
  @BuiltValueField(wireName: r'gate_identifier')
  String get gateIdentifier;

  @BuiltValueField(wireName: r'count')
  int get count;

  OccupancyByGateInner._();

  factory OccupancyByGateInner([void updates(OccupancyByGateInnerBuilder b)]) = _$OccupancyByGateInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OccupancyByGateInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OccupancyByGateInner> get serializer => _$OccupancyByGateInnerSerializer();
}

class _$OccupancyByGateInnerSerializer implements PrimitiveSerializer<OccupancyByGateInner> {
  @override
  final Iterable<Type> types = const [OccupancyByGateInner, _$OccupancyByGateInner];

  @override
  final String wireName = r'OccupancyByGateInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OccupancyByGateInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gate_identifier';
    yield serializers.serialize(
      object.gateIdentifier,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OccupancyByGateInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OccupancyByGateInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gate_identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gateIdentifier = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OccupancyByGateInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OccupancyByGateInnerBuilder();
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


