// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ItemKind _$service = const ItemKind._('service');
const ItemKind _$goods = const ItemKind._('goods');

ItemKind _$valueOf(String name) {
  switch (name) {
    case 'service':
      return _$service;
    case 'goods':
      return _$goods;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ItemKind> _$values = BuiltSet<ItemKind>(const <ItemKind>[
  _$service,
  _$goods,
]);

class _$ItemKindMeta {
  const _$ItemKindMeta();
  ItemKind get service => _$service;
  ItemKind get goods => _$goods;
  ItemKind valueOf(String name) => _$valueOf(name);
  BuiltSet<ItemKind> get values => _$values;
}

abstract class _$ItemKindMixin {
  // ignore: non_constant_identifier_names
  _$ItemKindMeta get ItemKind => const _$ItemKindMeta();
}

Serializer<ItemKind> _$itemKindSerializer = _$ItemKindSerializer();

class _$ItemKindSerializer implements PrimitiveSerializer<ItemKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'service': 'service',
    'goods': 'goods',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'service': 'service',
    'goods': 'goods',
  };

  @override
  final Iterable<Type> types = const <Type>[ItemKind];
  @override
  final String wireName = 'ItemKind';

  @override
  Object serialize(Serializers serializers, ItemKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ItemKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ItemKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
