// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserType _$member = const UserType._('member');
const UserType _$trainer = const UserType._('trainer');
const UserType _$employee = const UserType._('employee');
const UserType _$admin = const UserType._('admin');

UserType _$valueOf(String name) {
  switch (name) {
    case 'member':
      return _$member;
    case 'trainer':
      return _$trainer;
    case 'employee':
      return _$employee;
    case 'admin':
      return _$admin;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserType> _$values = BuiltSet<UserType>(const <UserType>[
  _$member,
  _$trainer,
  _$employee,
  _$admin,
]);

class _$UserTypeMeta {
  const _$UserTypeMeta();
  UserType get member => _$member;
  UserType get trainer => _$trainer;
  UserType get employee => _$employee;
  UserType get admin => _$admin;
  UserType valueOf(String name) => _$valueOf(name);
  BuiltSet<UserType> get values => _$values;
}

abstract class _$UserTypeMixin {
  // ignore: non_constant_identifier_names
  _$UserTypeMeta get UserType => const _$UserTypeMeta();
}

Serializer<UserType> _$userTypeSerializer = _$UserTypeSerializer();

class _$UserTypeSerializer implements PrimitiveSerializer<UserType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'member': 'member',
    'trainer': 'trainer',
    'employee': 'employee',
    'admin': 'admin',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'member': 'member',
    'trainer': 'trainer',
    'employee': 'employee',
    'admin': 'admin',
  };

  @override
  final Iterable<Type> types = const <Type>[UserType];
  @override
  final String wireName = 'UserType';

  @override
  Object serialize(Serializers serializers, UserType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
