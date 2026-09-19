// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReportType _$members = const ReportType._('members');
const ReportType _$memberships = const ReportType._('memberships');
const ReportType _$attendance = const ReportType._('attendance');
const ReportType _$payments = const ReportType._('payments');
const ReportType _$trainers = const ReportType._('trainers');
const ReportType _$workouts = const ReportType._('workouts');
const ReportType _$diets = const ReportType._('diets');
const ReportType _$progress = const ReportType._('progress');
const ReportType _$trainerOwn = const ReportType._('trainerOwn');

ReportType _$valueOf(String name) {
  switch (name) {
    case 'members':
      return _$members;
    case 'memberships':
      return _$memberships;
    case 'attendance':
      return _$attendance;
    case 'payments':
      return _$payments;
    case 'trainers':
      return _$trainers;
    case 'workouts':
      return _$workouts;
    case 'diets':
      return _$diets;
    case 'progress':
      return _$progress;
    case 'trainerOwn':
      return _$trainerOwn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReportType> _$values = BuiltSet<ReportType>(const <ReportType>[
  _$members,
  _$memberships,
  _$attendance,
  _$payments,
  _$trainers,
  _$workouts,
  _$diets,
  _$progress,
  _$trainerOwn,
]);

class _$ReportTypeMeta {
  const _$ReportTypeMeta();
  ReportType get members => _$members;
  ReportType get memberships => _$memberships;
  ReportType get attendance => _$attendance;
  ReportType get payments => _$payments;
  ReportType get trainers => _$trainers;
  ReportType get workouts => _$workouts;
  ReportType get diets => _$diets;
  ReportType get progress => _$progress;
  ReportType get trainerOwn => _$trainerOwn;
  ReportType valueOf(String name) => _$valueOf(name);
  BuiltSet<ReportType> get values => _$values;
}

abstract class _$ReportTypeMixin {
  // ignore: non_constant_identifier_names
  _$ReportTypeMeta get ReportType => const _$ReportTypeMeta();
}

Serializer<ReportType> _$reportTypeSerializer = _$ReportTypeSerializer();

class _$ReportTypeSerializer implements PrimitiveSerializer<ReportType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'members': 'members',
    'memberships': 'memberships',
    'attendance': 'attendance',
    'payments': 'payments',
    'trainers': 'trainers',
    'workouts': 'workouts',
    'diets': 'diets',
    'progress': 'progress',
    'trainerOwn': 'trainer_own',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'members': 'members',
    'memberships': 'memberships',
    'attendance': 'attendance',
    'payments': 'payments',
    'trainers': 'trainers',
    'workouts': 'workouts',
    'diets': 'diets',
    'progress': 'progress',
    'trainer_own': 'trainerOwn',
  };

  @override
  final Iterable<Type> types = const <Type>[ReportType];
  @override
  final String wireName = 'ReportType';

  @override
  Object serialize(Serializers serializers, ReportType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReportType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReportType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
