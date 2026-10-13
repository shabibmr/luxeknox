// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountType _$asset = const AccountType._('asset');
const AccountType _$liability = const AccountType._('liability');
const AccountType _$equity = const AccountType._('equity');
const AccountType _$income = const AccountType._('income');
const AccountType _$expense = const AccountType._('expense');

AccountType _$valueOf(String name) {
  switch (name) {
    case 'asset':
      return _$asset;
    case 'liability':
      return _$liability;
    case 'equity':
      return _$equity;
    case 'income':
      return _$income;
    case 'expense':
      return _$expense;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountType> _$values =
    BuiltSet<AccountType>(const <AccountType>[
  _$asset,
  _$liability,
  _$equity,
  _$income,
  _$expense,
]);

class _$AccountTypeMeta {
  const _$AccountTypeMeta();
  AccountType get asset => _$asset;
  AccountType get liability => _$liability;
  AccountType get equity => _$equity;
  AccountType get income => _$income;
  AccountType get expense => _$expense;
  AccountType valueOf(String name) => _$valueOf(name);
  BuiltSet<AccountType> get values => _$values;
}

abstract class _$AccountTypeMixin {
  // ignore: non_constant_identifier_names
  _$AccountTypeMeta get AccountType => const _$AccountTypeMeta();
}

Serializer<AccountType> _$accountTypeSerializer = _$AccountTypeSerializer();

class _$AccountTypeSerializer implements PrimitiveSerializer<AccountType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asset': 'asset',
    'liability': 'liability',
    'equity': 'equity',
    'income': 'income',
    'expense': 'expense',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'asset': 'asset',
    'liability': 'liability',
    'equity': 'equity',
    'income': 'income',
    'expense': 'expense',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountType];
  @override
  final String wireName = 'AccountType';

  @override
  Object serialize(Serializers serializers, AccountType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
