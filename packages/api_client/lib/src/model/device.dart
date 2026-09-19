//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device.g.dart';

/// Device
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [deviceToken] 
/// * [devicePlatform] 
/// * [lastActiveAt] - UTC ISO-8601
@BuiltValue()
abstract class Device implements Built<Device, DeviceBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'device_token')
  String get deviceToken;

  @BuiltValueField(wireName: r'device_platform')
  DeviceDevicePlatformEnum get devicePlatform;
  // enum devicePlatformEnum {  ios,  android,  web,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'last_active_at')
  DateTime? get lastActiveAt;

  Device._();

  factory Device([void updates(DeviceBuilder b)]) = _$Device;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Device> get serializer => _$DeviceSerializer();
}

class _$DeviceSerializer implements PrimitiveSerializer<Device> {
  @override
  final Iterable<Type> types = const [Device, _$Device];

  @override
  final String wireName = r'Device';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Device object, {
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
    yield r'device_token';
    yield serializers.serialize(
      object.deviceToken,
      specifiedType: const FullType(String),
    );
    yield r'device_platform';
    yield serializers.serialize(
      object.devicePlatform,
      specifiedType: const FullType(DeviceDevicePlatformEnum),
    );
    if (object.lastActiveAt != null) {
      yield r'last_active_at';
      yield serializers.serialize(
        object.lastActiveAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Device object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceBuilder result,
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
        case r'device_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceToken = valueDes;
          break;
        case r'device_platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeviceDevicePlatformEnum),
          ) as DeviceDevicePlatformEnum;
          result.devicePlatform = valueDes;
          break;
        case r'last_active_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastActiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Device deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceBuilder();
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


class DeviceDevicePlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ios')
  static const DeviceDevicePlatformEnum ios = _$deviceDevicePlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'android')
  static const DeviceDevicePlatformEnum android = _$deviceDevicePlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'web')
  static const DeviceDevicePlatformEnum web = _$deviceDevicePlatformEnum_web;

  static Serializer<DeviceDevicePlatformEnum> get serializer => _$deviceDevicePlatformEnumSerializer;

  const DeviceDevicePlatformEnum._(String name): super(name);

  static BuiltSet<DeviceDevicePlatformEnum> get values => _$deviceDevicePlatformEnumValues;
  static DeviceDevicePlatformEnum valueOf(String name) => _$deviceDevicePlatformEnumValueOf(name);
}

