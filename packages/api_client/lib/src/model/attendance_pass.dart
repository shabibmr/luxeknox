//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_pass.g.dart';

/// AttendancePass
///
/// Properties:
/// * [userId] 
/// * [payload] - Opaque value rendered as QR/barcode.
/// * [expiresAt] - UTC ISO-8601
@BuiltValue()
abstract class AttendancePass implements Built<AttendancePass, AttendancePassBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  /// Opaque value rendered as QR/barcode.
  @BuiltValueField(wireName: r'payload')
  String get payload;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  AttendancePass._();

  factory AttendancePass([void updates(AttendancePassBuilder b)]) = _$AttendancePass;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendancePassBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendancePass> get serializer => _$AttendancePassSerializer();
}

class _$AttendancePassSerializer implements PrimitiveSerializer<AttendancePass> {
  @override
  final Iterable<Type> types = const [AttendancePass, _$AttendancePass];

  @override
  final String wireName = r'AttendancePass';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendancePass object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'payload';
    yield serializers.serialize(
      object.payload,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AttendancePass object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendancePassBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'payload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payload = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttendancePass deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendancePassBuilder();
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


