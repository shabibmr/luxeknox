//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'body_metric_snapshot.g.dart';

/// BodyMetricSnapshot
///
/// Properties:
/// * [row] - Absent on reviews drafted before the five-row card.
/// * [metric] - Null when no metric matched the row.
/// * [startVal] 
/// * [currentVal] 
/// * [changeVal] - Always `current_val − start_val`.
/// * [targetVal] 
@BuiltValue()
abstract class BodyMetricSnapshot implements Built<BodyMetricSnapshot, BodyMetricSnapshotBuilder> {
  /// Absent on reviews drafted before the five-row card.
  @BuiltValueField(wireName: r'row')
  BodyMetricSnapshotRowEnum? get row;
  // enum rowEnum {  weight,  waist,  strength,  cardio,  other,  };

  /// Null when no metric matched the row.
  @BuiltValueField(wireName: r'metric')
  String get metric;

  @BuiltValueField(wireName: r'start_val')
  num? get startVal;

  @BuiltValueField(wireName: r'current_val')
  num? get currentVal;

  /// Always `current_val − start_val`.
  @BuiltValueField(wireName: r'change_val')
  num? get changeVal;

  @BuiltValueField(wireName: r'target_val')
  num? get targetVal;

  BodyMetricSnapshot._();

  factory BodyMetricSnapshot([void updates(BodyMetricSnapshotBuilder b)]) = _$BodyMetricSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BodyMetricSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BodyMetricSnapshot> get serializer => _$BodyMetricSnapshotSerializer();
}

class _$BodyMetricSnapshotSerializer implements PrimitiveSerializer<BodyMetricSnapshot> {
  @override
  final Iterable<Type> types = const [BodyMetricSnapshot, _$BodyMetricSnapshot];

  @override
  final String wireName = r'BodyMetricSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BodyMetricSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.row != null) {
      yield r'row';
      yield serializers.serialize(
        object.row,
        specifiedType: const FullType(BodyMetricSnapshotRowEnum),
      );
    }
    yield r'metric';
    yield serializers.serialize(
      object.metric,
      specifiedType: const FullType(String),
    );
    if (object.startVal != null) {
      yield r'start_val';
      yield serializers.serialize(
        object.startVal,
        specifiedType: const FullType(num),
      );
    }
    if (object.currentVal != null) {
      yield r'current_val';
      yield serializers.serialize(
        object.currentVal,
        specifiedType: const FullType(num),
      );
    }
    if (object.changeVal != null) {
      yield r'change_val';
      yield serializers.serialize(
        object.changeVal,
        specifiedType: const FullType(num),
      );
    }
    if (object.targetVal != null) {
      yield r'target_val';
      yield serializers.serialize(
        object.targetVal,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BodyMetricSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BodyMetricSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BodyMetricSnapshotRowEnum),
          ) as BodyMetricSnapshotRowEnum?;
          if (valueDes == null) continue;
          result.row = valueDes;
          break;
        case r'metric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.metric = valueDes;
          break;
        case r'start_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.startVal = valueDes;
          break;
        case r'current_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.currentVal = valueDes;
          break;
        case r'change_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.changeVal = valueDes;
          break;
        case r'target_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.targetVal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BodyMetricSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BodyMetricSnapshotBuilder();
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


/// Absent on reviews drafted before the five-row card.
class BodyMetricSnapshotRowEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'weight')
  static const BodyMetricSnapshotRowEnum weight = _$bodyMetricSnapshotRowEnum_weight;
  @BuiltValueEnumConst(wireName: r'waist')
  static const BodyMetricSnapshotRowEnum waist = _$bodyMetricSnapshotRowEnum_waist;
  @BuiltValueEnumConst(wireName: r'strength')
  static const BodyMetricSnapshotRowEnum strength = _$bodyMetricSnapshotRowEnum_strength;
  @BuiltValueEnumConst(wireName: r'cardio')
  static const BodyMetricSnapshotRowEnum cardio = _$bodyMetricSnapshotRowEnum_cardio;
  @BuiltValueEnumConst(wireName: r'other')
  static const BodyMetricSnapshotRowEnum other = _$bodyMetricSnapshotRowEnum_other;

  static Serializer<BodyMetricSnapshotRowEnum> get serializer => _$bodyMetricSnapshotRowEnumSerializer;

  const BodyMetricSnapshotRowEnum._(String name): super(name);

  static BuiltSet<BodyMetricSnapshotRowEnum> get values => _$bodyMetricSnapshotRowEnumValues;
  static BodyMetricSnapshotRowEnum valueOf(String name) => _$bodyMetricSnapshotRowEnumValueOf(name);
}

