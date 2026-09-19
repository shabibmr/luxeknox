//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mark_attendance_request.g.dart';

/// MarkAttendanceRequest
///
/// Properties:
/// * [attended] 
@BuiltValue()
abstract class MarkAttendanceRequest implements Built<MarkAttendanceRequest, MarkAttendanceRequestBuilder> {
  @BuiltValueField(wireName: r'attended')
  bool get attended;

  MarkAttendanceRequest._();

  factory MarkAttendanceRequest([void updates(MarkAttendanceRequestBuilder b)]) = _$MarkAttendanceRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MarkAttendanceRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MarkAttendanceRequest> get serializer => _$MarkAttendanceRequestSerializer();
}

class _$MarkAttendanceRequestSerializer implements PrimitiveSerializer<MarkAttendanceRequest> {
  @override
  final Iterable<Type> types = const [MarkAttendanceRequest, _$MarkAttendanceRequest];

  @override
  final String wireName = r'MarkAttendanceRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MarkAttendanceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'attended';
    yield serializers.serialize(
      object.attended,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MarkAttendanceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MarkAttendanceRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'attended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.attended = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MarkAttendanceRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MarkAttendanceRequestBuilder();
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


