// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PurchaseBillStatus _$draft = const PurchaseBillStatus._('draft');
const PurchaseBillStatus _$posted = const PurchaseBillStatus._('posted');
const PurchaseBillStatus _$void_ = const PurchaseBillStatus._('void_');

PurchaseBillStatus _$valueOf(String name) {
  switch (name) {
    case 'draft':
      return _$draft;
    case 'posted':
      return _$posted;
    case 'void_':
      return _$void_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PurchaseBillStatus> _$values =
    BuiltSet<PurchaseBillStatus>(const <PurchaseBillStatus>[
  _$draft,
  _$posted,
  _$void_,
]);

class _$PurchaseBillStatusMeta {
  const _$PurchaseBillStatusMeta();
  PurchaseBillStatus get draft => _$draft;
  PurchaseBillStatus get posted => _$posted;
  PurchaseBillStatus get void_ => _$void_;
  PurchaseBillStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PurchaseBillStatus> get values => _$values;
}

abstract class _$PurchaseBillStatusMixin {
  // ignore: non_constant_identifier_names
  _$PurchaseBillStatusMeta get PurchaseBillStatus =>
      const _$PurchaseBillStatusMeta();
}

Serializer<PurchaseBillStatus> _$purchaseBillStatusSerializer =
    _$PurchaseBillStatusSerializer();

class _$PurchaseBillStatusSerializer
    implements PrimitiveSerializer<PurchaseBillStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'posted': 'posted',
    'void_': 'void',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'posted': 'posted',
    'void': 'void_',
  };

  @override
  final Iterable<Type> types = const <Type>[PurchaseBillStatus];
  @override
  final String wireName = 'PurchaseBillStatus';

  @override
  Object serialize(Serializers serializers, PurchaseBillStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PurchaseBillStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PurchaseBillStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
