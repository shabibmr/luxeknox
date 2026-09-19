// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeviceDevicePlatformEnum _$deviceDevicePlatformEnum_ios =
    const DeviceDevicePlatformEnum._('ios');
const DeviceDevicePlatformEnum _$deviceDevicePlatformEnum_android =
    const DeviceDevicePlatformEnum._('android');
const DeviceDevicePlatformEnum _$deviceDevicePlatformEnum_web =
    const DeviceDevicePlatformEnum._('web');

DeviceDevicePlatformEnum _$deviceDevicePlatformEnumValueOf(String name) {
  switch (name) {
    case 'ios':
      return _$deviceDevicePlatformEnum_ios;
    case 'android':
      return _$deviceDevicePlatformEnum_android;
    case 'web':
      return _$deviceDevicePlatformEnum_web;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeviceDevicePlatformEnum> _$deviceDevicePlatformEnumValues =
    BuiltSet<DeviceDevicePlatformEnum>(const <DeviceDevicePlatformEnum>[
  _$deviceDevicePlatformEnum_ios,
  _$deviceDevicePlatformEnum_android,
  _$deviceDevicePlatformEnum_web,
]);

Serializer<DeviceDevicePlatformEnum> _$deviceDevicePlatformEnumSerializer =
    _$DeviceDevicePlatformEnumSerializer();

class _$DeviceDevicePlatformEnumSerializer
    implements PrimitiveSerializer<DeviceDevicePlatformEnum> {
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
  final Iterable<Type> types = const <Type>[DeviceDevicePlatformEnum];
  @override
  final String wireName = 'DeviceDevicePlatformEnum';

  @override
  Object serialize(Serializers serializers, DeviceDevicePlatformEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeviceDevicePlatformEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeviceDevicePlatformEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Device extends Device {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String deviceToken;
  @override
  final DeviceDevicePlatformEnum devicePlatform;
  @override
  final DateTime? lastActiveAt;

  factory _$Device([void Function(DeviceBuilder)? updates]) =>
      (DeviceBuilder()..update(updates))._build();

  _$Device._(
      {required this.id,
      required this.userId,
      required this.deviceToken,
      required this.devicePlatform,
      this.lastActiveAt})
      : super._();
  @override
  Device rebuild(void Function(DeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceBuilder toBuilder() => DeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Device &&
        id == other.id &&
        userId == other.userId &&
        deviceToken == other.deviceToken &&
        devicePlatform == other.devicePlatform &&
        lastActiveAt == other.lastActiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, deviceToken.hashCode);
    _$hash = $jc(_$hash, devicePlatform.hashCode);
    _$hash = $jc(_$hash, lastActiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Device')
          ..add('id', id)
          ..add('userId', userId)
          ..add('deviceToken', deviceToken)
          ..add('devicePlatform', devicePlatform)
          ..add('lastActiveAt', lastActiveAt))
        .toString();
  }
}

class DeviceBuilder implements Builder<Device, DeviceBuilder> {
  _$Device? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _deviceToken;
  String? get deviceToken => _$this._deviceToken;
  set deviceToken(String? deviceToken) => _$this._deviceToken = deviceToken;

  DeviceDevicePlatformEnum? _devicePlatform;
  DeviceDevicePlatformEnum? get devicePlatform => _$this._devicePlatform;
  set devicePlatform(DeviceDevicePlatformEnum? devicePlatform) =>
      _$this._devicePlatform = devicePlatform;

  DateTime? _lastActiveAt;
  DateTime? get lastActiveAt => _$this._lastActiveAt;
  set lastActiveAt(DateTime? lastActiveAt) =>
      _$this._lastActiveAt = lastActiveAt;

  DeviceBuilder() {
    Device._defaults(this);
  }

  DeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _deviceToken = $v.deviceToken;
      _devicePlatform = $v.devicePlatform;
      _lastActiveAt = $v.lastActiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Device other) {
    _$v = other as _$Device;
  }

  @override
  void update(void Function(DeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Device build() => _build();

  _$Device _build() {
    final _$result = _$v ??
        _$Device._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Device', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'Device', 'userId'),
          deviceToken: BuiltValueNullFieldError.checkNotNull(
              deviceToken, r'Device', 'deviceToken'),
          devicePlatform: BuiltValueNullFieldError.checkNotNull(
              devicePlatform, r'Device', 'devicePlatform'),
          lastActiveAt: lastActiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
