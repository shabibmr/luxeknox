// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SettingCategory _$general = const SettingCategory._('general');
const SettingCategory _$membership = const SettingCategory._('membership');
const SettingCategory _$attendanceGate =
    const SettingCategory._('attendanceGate');
const SettingCategory _$bookingRules = const SettingCategory._('bookingRules');
const SettingCategory _$billing = const SettingCategory._('billing');
const SettingCategory _$workout = const SettingCategory._('workout');
const SettingCategory _$diet = const SettingCategory._('diet');
const SettingCategory _$notification = const SettingCategory._('notification');
const SettingCategory _$measurement = const SettingCategory._('measurement');

SettingCategory _$valueOf(String name) {
  switch (name) {
    case 'general':
      return _$general;
    case 'membership':
      return _$membership;
    case 'attendanceGate':
      return _$attendanceGate;
    case 'bookingRules':
      return _$bookingRules;
    case 'billing':
      return _$billing;
    case 'workout':
      return _$workout;
    case 'diet':
      return _$diet;
    case 'notification':
      return _$notification;
    case 'measurement':
      return _$measurement;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SettingCategory> _$values =
    BuiltSet<SettingCategory>(const <SettingCategory>[
  _$general,
  _$membership,
  _$attendanceGate,
  _$bookingRules,
  _$billing,
  _$workout,
  _$diet,
  _$notification,
  _$measurement,
]);

class _$SettingCategoryMeta {
  const _$SettingCategoryMeta();
  SettingCategory get general => _$general;
  SettingCategory get membership => _$membership;
  SettingCategory get attendanceGate => _$attendanceGate;
  SettingCategory get bookingRules => _$bookingRules;
  SettingCategory get billing => _$billing;
  SettingCategory get workout => _$workout;
  SettingCategory get diet => _$diet;
  SettingCategory get notification => _$notification;
  SettingCategory get measurement => _$measurement;
  SettingCategory valueOf(String name) => _$valueOf(name);
  BuiltSet<SettingCategory> get values => _$values;
}

abstract class _$SettingCategoryMixin {
  // ignore: non_constant_identifier_names
  _$SettingCategoryMeta get SettingCategory => const _$SettingCategoryMeta();
}

Serializer<SettingCategory> _$settingCategorySerializer =
    _$SettingCategorySerializer();

class _$SettingCategorySerializer
    implements PrimitiveSerializer<SettingCategory> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'general': 'general',
    'membership': 'membership',
    'attendanceGate': 'attendance_gate',
    'bookingRules': 'booking_rules',
    'billing': 'billing',
    'workout': 'workout',
    'diet': 'diet',
    'notification': 'notification',
    'measurement': 'measurement',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'general': 'general',
    'membership': 'membership',
    'attendance_gate': 'attendanceGate',
    'booking_rules': 'bookingRules',
    'billing': 'billing',
    'workout': 'workout',
    'diet': 'diet',
    'notification': 'notification',
    'measurement': 'measurement',
  };

  @override
  final Iterable<Type> types = const <Type>[SettingCategory];
  @override
  final String wireName = 'SettingCategory';

  @override
  Object serialize(Serializers serializers, SettingCategory object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SettingCategory deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SettingCategory.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
