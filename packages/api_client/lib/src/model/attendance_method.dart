//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_method.g.dart';

class AttendanceMethod extends EnumClass {

  @BuiltValueEnumConst(wireName: r'qr_code')
  static const AttendanceMethod qrCode = _$qrCode;
  @BuiltValueEnumConst(wireName: r'rfid')
  static const AttendanceMethod rfid = _$rfid;
  @BuiltValueEnumConst(wireName: r'biometric')
  static const AttendanceMethod biometric = _$biometric;
  @BuiltValueEnumConst(wireName: r'manual_override')
  static const AttendanceMethod manualOverride = _$manualOverride;

  static Serializer<AttendanceMethod> get serializer => _$attendanceMethodSerializer;

  const AttendanceMethod._(String name): super(name);

  static BuiltSet<AttendanceMethod> get values => _$values;
  static AttendanceMethod valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AttendanceMethodMixin = Object with _$AttendanceMethodMixin;

