// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ExpenseStatus _$draft = const ExpenseStatus._('draft');
const ExpenseStatus _$posted = const ExpenseStatus._('posted');

ExpenseStatus _$valueOf(String name) {
  switch (name) {
    case 'draft':
      return _$draft;
    case 'posted':
      return _$posted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ExpenseStatus> _$values =
    BuiltSet<ExpenseStatus>(const <ExpenseStatus>[
  _$draft,
  _$posted,
]);

class _$ExpenseStatusMeta {
  const _$ExpenseStatusMeta();
  ExpenseStatus get draft => _$draft;
  ExpenseStatus get posted => _$posted;
  ExpenseStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ExpenseStatus> get values => _$values;
}

abstract class _$ExpenseStatusMixin {
  // ignore: non_constant_identifier_names
  _$ExpenseStatusMeta get ExpenseStatus => const _$ExpenseStatusMeta();
}

Serializer<ExpenseStatus> _$expenseStatusSerializer =
    _$ExpenseStatusSerializer();

class _$ExpenseStatusSerializer implements PrimitiveSerializer<ExpenseStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'posted': 'posted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'posted': 'posted',
  };

  @override
  final Iterable<Type> types = const <Type>[ExpenseStatus];
  @override
  final String wireName = 'ExpenseStatus';

  @override
  Object serialize(Serializers serializers, ExpenseStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ExpenseStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ExpenseStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
