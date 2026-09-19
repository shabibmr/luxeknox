// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MembershipStatus _$active = const MembershipStatus._('active');
const MembershipStatus _$expired = const MembershipStatus._('expired');
const MembershipStatus _$frozen = const MembershipStatus._('frozen');
const MembershipStatus _$cancelled = const MembershipStatus._('cancelled');

MembershipStatus _$valueOf(String name) {
  switch (name) {
    case 'active':
      return _$active;
    case 'expired':
      return _$expired;
    case 'frozen':
      return _$frozen;
    case 'cancelled':
      return _$cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MembershipStatus> _$values =
    BuiltSet<MembershipStatus>(const <MembershipStatus>[
  _$active,
  _$expired,
  _$frozen,
  _$cancelled,
]);

class _$MembershipStatusMeta {
  const _$MembershipStatusMeta();
  MembershipStatus get active => _$active;
  MembershipStatus get expired => _$expired;
  MembershipStatus get frozen => _$frozen;
  MembershipStatus get cancelled => _$cancelled;
  MembershipStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<MembershipStatus> get values => _$values;
}

abstract class _$MembershipStatusMixin {
  // ignore: non_constant_identifier_names
  _$MembershipStatusMeta get MembershipStatus => const _$MembershipStatusMeta();
}

Serializer<MembershipStatus> _$membershipStatusSerializer =
    _$MembershipStatusSerializer();

class _$MembershipStatusSerializer
    implements PrimitiveSerializer<MembershipStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'expired': 'expired',
    'frozen': 'frozen',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'expired': 'expired',
    'frozen': 'frozen',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[MembershipStatus];
  @override
  final String wireName = 'MembershipStatus';

  @override
  Object serialize(Serializers serializers, MembershipStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MembershipStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MembershipStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
