// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeStatus _$active = const EmployeeStatus._('active');
const EmployeeStatus _$onProbation = const EmployeeStatus._('onProbation');
const EmployeeStatus _$suspended = const EmployeeStatus._('suspended');
const EmployeeStatus _$terminated = const EmployeeStatus._('terminated');

EmployeeStatus _$valueOf(String name) {
  switch (name) {
    case 'active':
      return _$active;
    case 'onProbation':
      return _$onProbation;
    case 'suspended':
      return _$suspended;
    case 'terminated':
      return _$terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeStatus> _$values =
    BuiltSet<EmployeeStatus>(const <EmployeeStatus>[
  _$active,
  _$onProbation,
  _$suspended,
  _$terminated,
]);

class _$EmployeeStatusMeta {
  const _$EmployeeStatusMeta();
  EmployeeStatus get active => _$active;
  EmployeeStatus get onProbation => _$onProbation;
  EmployeeStatus get suspended => _$suspended;
  EmployeeStatus get terminated => _$terminated;
  EmployeeStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<EmployeeStatus> get values => _$values;
}

abstract class _$EmployeeStatusMixin {
  // ignore: non_constant_identifier_names
  _$EmployeeStatusMeta get EmployeeStatus => const _$EmployeeStatusMeta();
}

Serializer<EmployeeStatus> _$employeeStatusSerializer =
    _$EmployeeStatusSerializer();

class _$EmployeeStatusSerializer
    implements PrimitiveSerializer<EmployeeStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'onProbation': 'on_probation',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'on_probation': 'onProbation',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeStatus];
  @override
  final String wireName = 'EmployeeStatus';

  @override
  Object serialize(Serializers serializers, EmployeeStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EmployeeStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EmployeeStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
