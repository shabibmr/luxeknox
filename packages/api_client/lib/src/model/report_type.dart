//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_type.g.dart';

class ReportType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'members')
  static const ReportType members = _$members;
  @BuiltValueEnumConst(wireName: r'memberships')
  static const ReportType memberships = _$memberships;
  @BuiltValueEnumConst(wireName: r'attendance')
  static const ReportType attendance = _$attendance;
  @BuiltValueEnumConst(wireName: r'payments')
  static const ReportType payments = _$payments;
  @BuiltValueEnumConst(wireName: r'trainers')
  static const ReportType trainers = _$trainers;
  @BuiltValueEnumConst(wireName: r'workouts')
  static const ReportType workouts = _$workouts;
  @BuiltValueEnumConst(wireName: r'diets')
  static const ReportType diets = _$diets;
  @BuiltValueEnumConst(wireName: r'progress')
  static const ReportType progress = _$progress;
  @BuiltValueEnumConst(wireName: r'trainer_own')
  static const ReportType trainerOwn = _$trainerOwn;

  static Serializer<ReportType> get serializer => _$reportTypeSerializer;

  const ReportType._(String name): super(name);

  static BuiltSet<ReportType> get values => _$values;
  static ReportType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ReportTypeMixin = Object with _$ReportTypeMixin;

