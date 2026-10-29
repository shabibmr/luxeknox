//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'body_metric_snapshot.g.dart';

/// BodyMetricSnapshot
///
/// Properties:
/// * [metric] 
/// * [startVal] 
/// * [currentVal] 
/// * [changeVal] - Always `current_val − start_val`.
/// * [targetVal] 
@BuiltValue()
abstract class BodyMetricSnapshot implements Built<BodyMetricSnapshot, BodyMetricSnapshotBuilder> {
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


