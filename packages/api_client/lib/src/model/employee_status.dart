//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_status.g.dart';

class EmployeeStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const EmployeeStatus active = _$active;
  @BuiltValueEnumConst(wireName: r'on_probation')
  static const EmployeeStatus onProbation = _$onProbation;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const EmployeeStatus suspended = _$suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const EmployeeStatus terminated = _$terminated;

  static Serializer<EmployeeStatus> get serializer => _$employeeStatusSerializer;

  const EmployeeStatus._(String name): super(name);

  static BuiltSet<EmployeeStatus> get values => _$values;
  static EmployeeStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class EmployeeStatusMixin = Object with _$EmployeeStatusMixin;

