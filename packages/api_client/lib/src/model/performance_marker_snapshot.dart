//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'performance_marker_snapshot.g.dart';

/// PerformanceMarkerSnapshot
///
/// Properties:
/// * [marker] 
/// * [startVal] 
/// * [currentVal] 
/// * [changeVal] 
/// * [targetVal] 
@BuiltValue()
abstract class PerformanceMarkerSnapshot implements Built<PerformanceMarkerSnapshot, PerformanceMarkerSnapshotBuilder> {
  @BuiltValueField(wireName: r'marker')
  String get marker;

  @BuiltValueField(wireName: r'start_val')
  String? get startVal;

  @BuiltValueField(wireName: r'current_val')
  String? get currentVal;

  @BuiltValueField(wireName: r'change_val')
  String? get changeVal;

  @BuiltValueField(wireName: r'target_val')
  String? get targetVal;

  PerformanceMarkerSnapshot._();

  factory PerformanceMarkerSnapshot([void updates(PerformanceMarkerSnapshotBuilder b)]) = _$PerformanceMarkerSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PerformanceMarkerSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PerformanceMarkerSnapshot> get serializer => _$PerformanceMarkerSnapshotSerializer();
}

class _$PerformanceMarkerSnapshotSerializer implements PrimitiveSerializer<PerformanceMarkerSnapshot> {
  @override
  final Iterable<Type> types = const [PerformanceMarkerSnapshot, _$PerformanceMarkerSnapshot];

  @override
  final String wireName = r'PerformanceMarkerSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PerformanceMarkerSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marker';
    yield serializers.serialize(
      object.marker,
      specifiedType: const FullType(String),
    );
    if (object.startVal != null) {
      yield r'start_val';
      yield serializers.serialize(
        object.startVal,
        specifiedType: const FullType(String),
      );
    }
    if (object.currentVal != null) {
      yield r'current_val';
      yield serializers.serialize(
        object.currentVal,
        specifiedType: const FullType(String),
      );
    }
    if (object.changeVal != null) {
      yield r'change_val';
      yield serializers.serialize(
        object.changeVal,
        specifiedType: const FullType(String),
      );
    }
    if (object.targetVal != null) {
      yield r'target_val';
      yield serializers.serialize(
        object.targetVal,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PerformanceMarkerSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PerformanceMarkerSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marker':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.marker = valueDes;
          break;
        case r'start_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.startVal = valueDes;
          break;
        case r'current_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentVal = valueDes;
          break;
        case r'change_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changeVal = valueDes;
          break;
        case r'target_val':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  PerformanceMarkerSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PerformanceMarkerSnapshotBuilder();
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


