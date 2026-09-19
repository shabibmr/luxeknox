// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeviceWriteDevicePlatformEnum _$deviceWriteDevicePlatformEnum_ios =
    const DeviceWriteDevicePlatformEnum._('ios');
const DeviceWriteDevicePlatformEnum _$deviceWriteDevicePlatformEnum_android =
    const DeviceWriteDevicePlatformEnum._('android');
const DeviceWriteDevicePlatformEnum _$deviceWriteDevicePlatformEnum_web =
    const DeviceWriteDevicePlatformEnum._('web');

DeviceWriteDevicePlatformEnum _$deviceWriteDevicePlatformEnumValueOf(
    String name) {
  switch (name) {
    case 'ios':
      return _$deviceWriteDevicePlatformEnum_ios;
    case 'android':
      return _$deviceWriteDevicePlatformEnum_android;
    case 'web':
      return _$deviceWriteDevicePlatformEnum_web;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeviceWriteDevicePlatformEnum>
    _$deviceWriteDevicePlatformEnumValues = BuiltSet<
        DeviceWriteDevicePlatformEnum>(const <DeviceWriteDevicePlatformEnum>[
  _$deviceWriteDevicePlatformEnum_ios,
  _$deviceWriteDevicePlatformEnum_android,
  _$deviceWriteDevicePlatformEnum_web,
]);

Serializer<DeviceWriteDevicePlatformEnum>
    _$deviceWriteDevicePlatformEnumSerializer =
    _$DeviceWriteDevicePlatformEnumSerializer();

class _$DeviceWriteDevicePlatformEnumSerializer
    implements PrimitiveSerializer<DeviceWriteDevicePlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ios': 'ios',
    'android': 'android',
    'web': 'web',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ios': 'ios',
    'android': 'android',
    'web': 'web',
  };

  @override
  final Iterable<Type> types = const <Type>[DeviceWriteDevicePlatformEnum];
  @override
  final String wireName = 'DeviceWriteDevicePlatformEnum';

  @override
  Object serialize(
          Serializers serializers, DeviceWriteDevicePlatformEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeviceWriteDevicePlatformEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeviceWriteDevicePlatformEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeviceWrite extends DeviceWrite {
  @override
  final String deviceToken;
  @override
  final DeviceWriteDevicePlatformEnum devicePlatform;

  factory _$DeviceWrite([void Function(DeviceWriteBuilder)? updates]) =>
      (DeviceWriteBuilder()..update(updates))._build();

  _$DeviceWrite._({required this.deviceToken, required this.devicePlatform})
      : super._();
  @override
  DeviceWrite rebuild(void Function(DeviceWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceWriteBuilder toBuilder() => DeviceWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceWrite &&
        deviceToken == other.deviceToken &&
        devicePlatform == other.devicePlatform;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceToken.hashCode);
    _$hash = $jc(_$hash, devicePlatform.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceWrite')
          ..add('deviceToken', deviceToken)
          ..add('devicePlatform', devicePlatform))
        .toString();
  }
}

class DeviceWriteBuilder implements Builder<DeviceWrite, DeviceWriteBuilder> {
  _$DeviceWrite? _$v;

  String? _deviceToken;
  String? get deviceToken => _$this._deviceToken;
  set deviceToken(String? deviceToken) => _$this._deviceToken = deviceToken;

  DeviceWriteDevicePlatformEnum? _devicePlatform;
  DeviceWriteDevicePlatformEnum? get devicePlatform => _$this._devicePlatform;
  set devicePlatform(DeviceWriteDevicePlatformEnum? devicePlatform) =>
      _$this._devicePlatform = devicePlatform;

  DeviceWriteBuilder() {
    DeviceWrite._defaults(this);
  }

  DeviceWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceToken = $v.deviceToken;
      _devicePlatform = $v.devicePlatform;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceWrite other) {
    _$v = other as _$DeviceWrite;
  }

  @override
  void update(void Function(DeviceWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceWrite build() => _build();

  _$DeviceWrite _build() {
    final _$result = _$v ??
        _$DeviceWrite._(
          deviceToken: BuiltValueNullFieldError.checkNotNull(
              deviceToken, r'DeviceWrite', 'deviceToken'),
          devicePlatform: BuiltValueNullFieldError.checkNotNull(
              devicePlatform, r'DeviceWrite', 'devicePlatform'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
