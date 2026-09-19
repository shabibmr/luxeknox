//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_write.g.dart';

/// DeviceWrite
///
/// Properties:
/// * [deviceToken] 
/// * [devicePlatform] 
@BuiltValue()
abstract class DeviceWrite implements Built<DeviceWrite, DeviceWriteBuilder> {
  @BuiltValueField(wireName: r'device_token')
  String get deviceToken;

  @BuiltValueField(wireName: r'device_platform')
  DeviceWriteDevicePlatformEnum get devicePlatform;
  // enum devicePlatformEnum {  ios,  android,  web,  };

  DeviceWrite._();

  factory DeviceWrite([void updates(DeviceWriteBuilder b)]) = _$DeviceWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceWrite> get serializer => _$DeviceWriteSerializer();
}

class _$DeviceWriteSerializer implements PrimitiveSerializer<DeviceWrite> {
  @override
  final Iterable<Type> types = const [DeviceWrite, _$DeviceWrite];

  @override
  final String wireName = r'DeviceWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'device_token';
    yield serializers.serialize(
      object.deviceToken,
      specifiedType: const FullType(String),
    );
    yield r'device_platform';
    yield serializers.serialize(
      object.devicePlatform,
      specifiedType: const FullType(DeviceWriteDevicePlatformEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(DeviceWriteDevicePlatformEnum),
          ) as DeviceWriteDevicePlatformEnum;
          result.devicePlatform = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceWriteBuilder();
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


class DeviceWriteDevicePlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ios')
  static const DeviceWriteDevicePlatformEnum ios = _$deviceWriteDevicePlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'android')
  static const DeviceWriteDevicePlatformEnum android = _$deviceWriteDevicePlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'web')
  static const DeviceWriteDevicePlatformEnum web = _$deviceWriteDevicePlatformEnum_web;

  static Serializer<DeviceWriteDevicePlatformEnum> get serializer => _$deviceWriteDevicePlatformEnumSerializer;

  const DeviceWriteDevicePlatformEnum._(String name): super(name);

  static BuiltSet<DeviceWriteDevicePlatformEnum> get values => _$deviceWriteDevicePlatformEnumValues;
  static DeviceWriteDevicePlatformEnum valueOf(String name) => _$deviceWriteDevicePlatformEnumValueOf(name);
}

