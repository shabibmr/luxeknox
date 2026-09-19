// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentHistoryActionEnum _$paymentHistoryActionEnum_paymentReceived =
    const PaymentHistoryActionEnum._('paymentReceived');
const PaymentHistoryActionEnum _$paymentHistoryActionEnum_refunded =
    const PaymentHistoryActionEnum._('refunded');
const PaymentHistoryActionEnum _$paymentHistoryActionEnum_adjusted =
    const PaymentHistoryActionEnum._('adjusted');

PaymentHistoryActionEnum _$paymentHistoryActionEnumValueOf(String name) {
  switch (name) {
    case 'paymentReceived':
      return _$paymentHistoryActionEnum_paymentReceived;
    case 'refunded':
      return _$paymentHistoryActionEnum_refunded;
    case 'adjusted':
      return _$paymentHistoryActionEnum_adjusted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentHistoryActionEnum> _$paymentHistoryActionEnumValues =
    BuiltSet<PaymentHistoryActionEnum>(const <PaymentHistoryActionEnum>[
  _$paymentHistoryActionEnum_paymentReceived,
  _$paymentHistoryActionEnum_refunded,
  _$paymentHistoryActionEnum_adjusted,
]);

Serializer<PaymentHistoryActionEnum> _$paymentHistoryActionEnumSerializer =
    _$PaymentHistoryActionEnumSerializer();

class _$PaymentHistoryActionEnumSerializer
    implements PrimitiveSerializer<PaymentHistoryActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'paymentReceived': 'payment_received',
    'refunded': 'refunded',
    'adjusted': 'adjusted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'payment_received': 'paymentReceived',
    'refunded': 'refunded',
    'adjusted': 'adjusted',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentHistoryActionEnum];
  @override
  final String wireName = 'PaymentHistoryActionEnum';

  @override
  Object serialize(Serializers serializers, PaymentHistoryActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentHistoryActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentHistoryActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentHistory extends PaymentHistory {
  @override
  final int id;
  @override
  final int paymentId;
  @override
  final int? paymentMethodId;
  @override
  final PaymentHistoryActionEnum action;
  @override
  final String amount;
  @override
  final String? notes;
  @override
  final DateTime timestamp;

  factory _$PaymentHistory([void Function(PaymentHistoryBuilder)? updates]) =>
      (PaymentHistoryBuilder()..update(updates))._build();

  _$PaymentHistory._(
      {required this.id,
      required this.paymentId,
      this.paymentMethodId,
      required this.action,
      required this.amount,
      this.notes,
      required this.timestamp})
      : super._();
  @override
  PaymentHistory rebuild(void Function(PaymentHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentHistoryBuilder toBuilder() => PaymentHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentHistory &&
        id == other.id &&
        paymentId == other.paymentId &&
        paymentMethodId == other.paymentMethodId &&
        action == other.action &&
        amount == other.amount &&
        notes == other.notes &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentHistory')
          ..add('id', id)
          ..add('paymentId', paymentId)
          ..add('paymentMethodId', paymentMethodId)
          ..add('action', action)
          ..add('amount', amount)
          ..add('notes', notes)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaymentHistoryBuilder
    implements Builder<PaymentHistory, PaymentHistoryBuilder> {
  _$PaymentHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _paymentId;
  int? get paymentId => _$this._paymentId;
  set paymentId(int? paymentId) => _$this._paymentId = paymentId;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  PaymentHistoryActionEnum? _action;
  PaymentHistoryActionEnum? get action => _$this._action;
  set action(PaymentHistoryActionEnum? action) => _$this._action = action;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaymentHistoryBuilder() {
    PaymentHistory._defaults(this);
  }

  PaymentHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _paymentId = $v.paymentId;
      _paymentMethodId = $v.paymentMethodId;
      _action = $v.action;
      _amount = $v.amount;
      _notes = $v.notes;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentHistory other) {
    _$v = other as _$PaymentHistory;
  }

  @override
  void update(void Function(PaymentHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentHistory build() => _build();

  _$PaymentHistory _build() {
    final _$result = _$v ??
        _$PaymentHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentHistory', 'id'),
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'PaymentHistory', 'paymentId'),
          paymentMethodId: paymentMethodId,
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'PaymentHistory', 'action'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentHistory', 'amount'),
          notes: notes,
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'PaymentHistory', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
