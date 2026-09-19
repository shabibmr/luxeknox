//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/attendance_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance.g.dart';

/// Attendance
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [checkInTime] - UTC ISO-8601
/// * [checkOutTime] 
/// * [method] 
/// * [gateIdentifier] 
/// * [verifiedByUserId] 
@BuiltValue()
abstract class Attendance implements Built<Attendance, AttendanceBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'check_in_time')
  DateTime get checkInTime;

  @BuiltValueField(wireName: r'check_out_time')
  DateTime? get checkOutTime;

  @BuiltValueField(wireName: r'method')
  AttendanceMethod get method;
  // enum methodEnum {  qr_code,  rfid,  biometric,  manual_override,  };

  @BuiltValueField(wireName: r'gate_identifier')
  String? get gateIdentifier;

  @BuiltValueField(wireName: r'verified_by_user_id')
  int? get verifiedByUserId;

  Attendance._();

  factory Attendance([void updates(AttendanceBuilder b)]) = _$Attendance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Attendance> get serializer => _$AttendanceSerializer();
}

class _$AttendanceSerializer implements PrimitiveSerializer<Attendance> {
  @override
  final Iterable<Type> types = const [Attendance, _$Attendance];

  @override
  final String wireName = r'Attendance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Attendance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'check_in_time';
    yield serializers.serialize(
      object.checkInTime,
      specifiedType: const FullType(DateTime),
    );
    if (object.checkOutTime != null) {
      yield r'check_out_time';
      yield serializers.serialize(
        object.checkOutTime,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(AttendanceMethod),
    );
    if (object.gateIdentifier != null) {
      yield r'gate_identifier';
      yield serializers.serialize(
        object.gateIdentifier,
        specifiedType: const FullType(String),
      );
    }
    if (object.verifiedByUserId != null) {
      yield r'verified_by_user_id';
      yield serializers.serialize(
        object.verifiedByUserId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Attendance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendanceBuilder result,
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
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'check_in_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.checkInTime = valueDes;
          break;
        case r'check_out_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkOutTime = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AttendanceMethod),
          ) as AttendanceMethod;
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
        case r'verified_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.verifiedByUserId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Attendance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceBuilder();
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


