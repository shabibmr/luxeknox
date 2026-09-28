//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancel_booking_request.g.dart';

/// CancelBookingRequest
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class CancelBookingRequest implements Built<CancelBookingRequest, CancelBookingRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CancelBookingRequest._();

  factory CancelBookingRequest([void updates(CancelBookingRequestBuilder b)]) = _$CancelBookingRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelBookingRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelBookingRequest> get serializer => _$CancelBookingRequestSerializer();
}

class _$CancelBookingRequestSerializer implements PrimitiveSerializer<CancelBookingRequest> {
  @override
  final Iterable<Type> types = const [CancelBookingRequest, _$CancelBookingRequest];

  @override
  final String wireName = r'CancelBookingRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelBookingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelBookingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancelBookingRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancelBookingRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelBookingRequestBuilder();
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


