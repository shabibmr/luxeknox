// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentStatus _$pending = const PaymentStatus._('pending');
const PaymentStatus _$partial = const PaymentStatus._('partial');
const PaymentStatus _$paid = const PaymentStatus._('paid');
const PaymentStatus _$refunded = const PaymentStatus._('refunded');

PaymentStatus _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$pending;
    case 'partial':
      return _$partial;
    case 'paid':
      return _$paid;
    case 'refunded':
      return _$refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentStatus> _$values =
    BuiltSet<PaymentStatus>(const <PaymentStatus>[
  _$pending,
  _$partial,
  _$paid,
  _$refunded,
]);

class _$PaymentStatusMeta {
  const _$PaymentStatusMeta();
  PaymentStatus get pending => _$pending;
  PaymentStatus get partial => _$partial;
  PaymentStatus get paid => _$paid;
  PaymentStatus get refunded => _$refunded;
  PaymentStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PaymentStatus> get values => _$values;
}

abstract class _$PaymentStatusMixin {
  // ignore: non_constant_identifier_names
  _$PaymentStatusMeta get PaymentStatus => const _$PaymentStatusMeta();
}

Serializer<PaymentStatus> _$paymentStatusSerializer =
    _$PaymentStatusSerializer();

class _$PaymentStatusSerializer implements PrimitiveSerializer<PaymentStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'partial': 'partial',
    'paid': 'paid',
    'refunded': 'refunded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'partial': 'partial',
    'paid': 'paid',
    'refunded': 'refunded',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentStatus];
  @override
  final String wireName = 'PaymentStatus';

  @override
  Object serialize(Serializers serializers, PaymentStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
