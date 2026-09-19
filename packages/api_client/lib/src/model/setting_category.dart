//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_category.g.dart';

class SettingCategory extends EnumClass {

  @BuiltValueEnumConst(wireName: r'general')
  static const SettingCategory general = _$general;
  @BuiltValueEnumConst(wireName: r'membership')
  static const SettingCategory membership = _$membership;
  @BuiltValueEnumConst(wireName: r'attendance_gate')
  static const SettingCategory attendanceGate = _$attendanceGate;
  @BuiltValueEnumConst(wireName: r'booking_rules')
  static const SettingCategory bookingRules = _$bookingRules;
  @BuiltValueEnumConst(wireName: r'billing')
  static const SettingCategory billing = _$billing;
  @BuiltValueEnumConst(wireName: r'workout')
  static const SettingCategory workout = _$workout;
  @BuiltValueEnumConst(wireName: r'diet')
  static const SettingCategory diet = _$diet;
  @BuiltValueEnumConst(wireName: r'notification')
  static const SettingCategory notification = _$notification;
  @BuiltValueEnumConst(wireName: r'measurement')
  static const SettingCategory measurement = _$measurement;

  static Serializer<SettingCategory> get serializer => _$settingCategorySerializer;

  const SettingCategory._(String name): super(name);

  static BuiltSet<SettingCategory> get values => _$values;
  static SettingCategory valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SettingCategoryMixin = Object with _$SettingCategoryMixin;

