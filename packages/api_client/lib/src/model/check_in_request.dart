//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/attendance_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_request.g.dart';

/// CheckInRequest
///
/// Properties:
/// * [userId] 
/// * [method] 
/// * [gateIdentifier] 
/// * [payload] - Scanned pass payload for QR.
@BuiltValue()
abstract class CheckInRequest implements Built<CheckInRequest, CheckInRequestBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int? get userId;

  @BuiltValueField(wireName: r'method')
  AttendanceMethod? get method;
  // enum methodEnum {  qr_code,  rfid,  biometric,  manual_override,  };

  @BuiltValueField(wireName: r'gate_identifier')
  String? get gateIdentifier;

  /// Scanned pass payload for QR.
  @BuiltValueField(wireName: r'payload')
  String? get payload;

  CheckInRequest._();

  factory CheckInRequest([void updates(CheckInRequestBuilder b)]) = _$CheckInRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckInRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckInRequest> get serializer => _$CheckInRequestSerializer();
}

class _$CheckInRequestSerializer implements PrimitiveSerializer<CheckInRequest> {
  @override
  final Iterable<Type> types = const [CheckInRequest, _$CheckInRequest];

  @override
  final String wireName = r'CheckInRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckInRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userId != null) {
      yield r'user_id';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(int),
      );
    }
    if (object.method != null) {
      yield r'method';
      yield serializers.serialize(
        object.method,
        specifiedType: const FullType(AttendanceMethod),
      );
    }
    if (object.gateIdentifier != null) {
      yield r'gate_identifier';
      yield serializers.serialize(
        object.gateIdentifier,
        specifiedType: const FullType(String),
      );
    }
    if (object.payload != null) {
      yield r'payload';
      yield serializers.serialize(
        object.payload,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckInRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckInRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AttendanceMethod),
          ) as AttendanceMethod?;
          if (valueDes == null) continue;
          result.method = valueDes;
          break;
        case r'gate_identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gateIdentifier = valueDes;
          break;
        case r'payload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.payload = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckInRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckInRequestBuilder();
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


