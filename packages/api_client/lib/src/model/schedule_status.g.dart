// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScheduleStatus _$scheduled = const ScheduleStatus._('scheduled');
const ScheduleStatus _$ongoing = const ScheduleStatus._('ongoing');
const ScheduleStatus _$completed = const ScheduleStatus._('completed');
const ScheduleStatus _$cancelled = const ScheduleStatus._('cancelled');

ScheduleStatus _$valueOf(String name) {
  switch (name) {
    case 'scheduled':
      return _$scheduled;
    case 'ongoing':
      return _$ongoing;
    case 'completed':
      return _$completed;
    case 'cancelled':
      return _$cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScheduleStatus> _$values =
    BuiltSet<ScheduleStatus>(const <ScheduleStatus>[
  _$scheduled,
  _$ongoing,
  _$completed,
  _$cancelled,
]);

class _$ScheduleStatusMeta {
  const _$ScheduleStatusMeta();
  ScheduleStatus get scheduled => _$scheduled;
  ScheduleStatus get ongoing => _$ongoing;
  ScheduleStatus get completed => _$completed;
  ScheduleStatus get cancelled => _$cancelled;
  ScheduleStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ScheduleStatus> get values => _$values;
}

abstract class _$ScheduleStatusMixin {
  // ignore: non_constant_identifier_names
  _$ScheduleStatusMeta get ScheduleStatus => const _$ScheduleStatusMeta();
}

Serializer<ScheduleStatus> _$scheduleStatusSerializer =
    _$ScheduleStatusSerializer();

class _$ScheduleStatusSerializer
    implements PrimitiveSerializer<ScheduleStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'scheduled': 'scheduled',
    'ongoing': 'ongoing',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'scheduled': 'scheduled',
    'ongoing': 'ongoing',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[ScheduleStatus];
  @override
  final String wireName = 'ScheduleStatus';

  @override
  Object serialize(Serializers serializers, ScheduleStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScheduleStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScheduleStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
