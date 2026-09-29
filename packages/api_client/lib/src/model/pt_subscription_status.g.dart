// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_subscription_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtSubscriptionStatus _$scheduled =
    const PtSubscriptionStatus._('scheduled');
const PtSubscriptionStatus _$active = const PtSubscriptionStatus._('active');
const PtSubscriptionStatus _$completed =
    const PtSubscriptionStatus._('completed');
const PtSubscriptionStatus _$cancelled =
    const PtSubscriptionStatus._('cancelled');

PtSubscriptionStatus _$valueOf(String name) {
  switch (name) {
    case 'scheduled':
      return _$scheduled;
    case 'active':
      return _$active;
    case 'completed':
      return _$completed;
    case 'cancelled':
      return _$cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtSubscriptionStatus> _$values =
    BuiltSet<PtSubscriptionStatus>(const <PtSubscriptionStatus>[
  _$scheduled,
  _$active,
  _$completed,
  _$cancelled,
]);

class _$PtSubscriptionStatusMeta {
  const _$PtSubscriptionStatusMeta();
  PtSubscriptionStatus get scheduled => _$scheduled;
  PtSubscriptionStatus get active => _$active;
  PtSubscriptionStatus get completed => _$completed;
  PtSubscriptionStatus get cancelled => _$cancelled;
  PtSubscriptionStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PtSubscriptionStatus> get values => _$values;
}

abstract class _$PtSubscriptionStatusMixin {
  // ignore: non_constant_identifier_names
  _$PtSubscriptionStatusMeta get PtSubscriptionStatus =>
      const _$PtSubscriptionStatusMeta();
}

Serializer<PtSubscriptionStatus> _$ptSubscriptionStatusSerializer =
    _$PtSubscriptionStatusSerializer();

class _$PtSubscriptionStatusSerializer
    implements PrimitiveSerializer<PtSubscriptionStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'scheduled': 'scheduled',
    'active': 'active',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'scheduled': 'scheduled',
    'active': 'active',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[PtSubscriptionStatus];
  @override
  final String wireName = 'PtSubscriptionStatus';

  @override
  Object serialize(Serializers serializers, PtSubscriptionStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtSubscriptionStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtSubscriptionStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
