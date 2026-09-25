//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/occupancy_by_gate_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'occupancy.g.dart';

/// Occupancy
///
/// Properties:
/// * [checkedInNow] 
/// * [asOf] - UTC ISO-8601
/// * [byGate] 
@BuiltValue()
abstract class Occupancy implements Built<Occupancy, OccupancyBuilder> {
  @BuiltValueField(wireName: r'checked_in_now')
  int get checkedInNow;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'as_of')
  DateTime get asOf;

  @BuiltValueField(wireName: r'by_gate')
  BuiltList<OccupancyByGateInner> get byGate;

  Occupancy._();

  factory Occupancy([void updates(OccupancyBuilder b)]) = _$Occupancy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OccupancyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Occupancy> get serializer => _$OccupancySerializer();
}

class _$OccupancySerializer implements PrimitiveSerializer<Occupancy> {
  @override
  final Iterable<Type> types = const [Occupancy, _$Occupancy];

  @override
  final String wireName = r'Occupancy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Occupancy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checked_in_now';
    yield serializers.serialize(
      object.checkedInNow,
      specifiedType: const FullType(int),
    );
    yield r'as_of';
    yield serializers.serialize(
      object.asOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'by_gate';
    yield serializers.serialize(
      object.byGate,
      specifiedType: const FullType(BuiltList, [FullType(OccupancyByGateInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Occupancy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OccupancyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checked_in_now':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.checkedInNow = valueDes;
          break;
        case r'as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.asOf = valueDes;
          break;
        case r'by_gate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OccupancyByGateInner)]),
          ) as BuiltList<OccupancyByGateInner>;
          result.byGate.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Occupancy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OccupancyBuilder();
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


