// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_package_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MembershipPackageType _$single = const MembershipPackageType._('single');
const MembershipPackageType _$couple = const MembershipPackageType._('couple');

MembershipPackageType _$valueOf(String name) {
  switch (name) {
    case 'single':
      return _$single;
    case 'couple':
      return _$couple;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MembershipPackageType> _$values =
    BuiltSet<MembershipPackageType>(const <MembershipPackageType>[
  _$single,
  _$couple,
]);

class _$MembershipPackageTypeMeta {
  const _$MembershipPackageTypeMeta();
  MembershipPackageType get single => _$single;
  MembershipPackageType get couple => _$couple;
  MembershipPackageType valueOf(String name) => _$valueOf(name);
  BuiltSet<MembershipPackageType> get values => _$values;
}

abstract class _$MembershipPackageTypeMixin {
  // ignore: non_constant_identifier_names
  _$MembershipPackageTypeMeta get MembershipPackageType =>
      const _$MembershipPackageTypeMeta();
}

Serializer<MembershipPackageType> _$membershipPackageTypeSerializer =
    _$MembershipPackageTypeSerializer();

class _$MembershipPackageTypeSerializer
    implements PrimitiveSerializer<MembershipPackageType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'single': 'single',
    'couple': 'couple',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'single': 'single',
    'couple': 'couple',
  };

  @override
  final Iterable<Type> types = const <Type>[MembershipPackageType];
  @override
  final String wireName = 'MembershipPackageType';

  @override
  Object serialize(Serializers serializers, MembershipPackageType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MembershipPackageType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MembershipPackageType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
