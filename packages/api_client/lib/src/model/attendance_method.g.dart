// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AttendanceMethod _$qrCode = const AttendanceMethod._('qrCode');
const AttendanceMethod _$rfid = const AttendanceMethod._('rfid');
const AttendanceMethod _$biometric = const AttendanceMethod._('biometric');
const AttendanceMethod _$manualOverride =
    const AttendanceMethod._('manualOverride');

AttendanceMethod _$valueOf(String name) {
  switch (name) {
    case 'qrCode':
      return _$qrCode;
    case 'rfid':
      return _$rfid;
    case 'biometric':
      return _$biometric;
    case 'manualOverride':
      return _$manualOverride;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AttendanceMethod> _$values =
    BuiltSet<AttendanceMethod>(const <AttendanceMethod>[
  _$qrCode,
  _$rfid,
  _$biometric,
  _$manualOverride,
]);

class _$AttendanceMethodMeta {
  const _$AttendanceMethodMeta();
  AttendanceMethod get qrCode => _$qrCode;
  AttendanceMethod get rfid => _$rfid;
  AttendanceMethod get biometric => _$biometric;
  AttendanceMethod get manualOverride => _$manualOverride;
  AttendanceMethod valueOf(String name) => _$valueOf(name);
  BuiltSet<AttendanceMethod> get values => _$values;
}

abstract class _$AttendanceMethodMixin {
  // ignore: non_constant_identifier_names
  _$AttendanceMethodMeta get AttendanceMethod => const _$AttendanceMethodMeta();
}

Serializer<AttendanceMethod> _$attendanceMethodSerializer =
    _$AttendanceMethodSerializer();

class _$AttendanceMethodSerializer
    implements PrimitiveSerializer<AttendanceMethod> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'qrCode': 'qr_code',
    'rfid': 'rfid',
    'biometric': 'biometric',
    'manualOverride': 'manual_override',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'qr_code': 'qrCode',
    'rfid': 'rfid',
    'biometric': 'biometric',
    'manual_override': 'manualOverride',
  };

  @override
  final Iterable<Type> types = const <Type>[AttendanceMethod];
  @override
  final String wireName = 'AttendanceMethod';

  @override
  Object serialize(Serializers serializers, AttendanceMethod object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttendanceMethod deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttendanceMethod.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
