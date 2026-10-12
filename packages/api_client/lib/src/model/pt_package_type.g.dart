// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_package_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtPackageType _$single = const PtPackageType._('single');
const PtPackageType _$couple = const PtPackageType._('couple');

PtPackageType _$valueOf(String name) {
  switch (name) {
    case 'single':
      return _$single;
    case 'couple':
      return _$couple;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtPackageType> _$values =
    BuiltSet<PtPackageType>(const <PtPackageType>[
  _$single,
  _$couple,
]);

class _$PtPackageTypeMeta {
  const _$PtPackageTypeMeta();
  PtPackageType get single => _$single;
  PtPackageType get couple => _$couple;
  PtPackageType valueOf(String name) => _$valueOf(name);
  BuiltSet<PtPackageType> get values => _$values;
}

abstract class _$PtPackageTypeMixin {
  // ignore: non_constant_identifier_names
  _$PtPackageTypeMeta get PtPackageType => const _$PtPackageTypeMeta();
}

Serializer<PtPackageType> _$ptPackageTypeSerializer =
    _$PtPackageTypeSerializer();

class _$PtPackageTypeSerializer implements PrimitiveSerializer<PtPackageType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'single': 'single',
    'couple': 'couple',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'single': 'single',
    'couple': 'couple',
  };

  @override
  final Iterable<Type> types = const <Type>[PtPackageType];
  @override
  final String wireName = 'PtPackageType';

  @override
  Object serialize(Serializers serializers, PtPackageType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtPackageType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtPackageType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
