//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_history.g.dart';

/// PaymentHistory
///
/// Properties:
/// * [id] 
/// * [paymentId] 
/// * [paymentMethodId] 
/// * [action] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [notes] 
/// * [timestamp] - UTC ISO-8601
@BuiltValue()
abstract class PaymentHistory implements Built<PaymentHistory, PaymentHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'payment_id')
  int get paymentId;

  @BuiltValueField(wireName: r'payment_method_id')
  int? get paymentMethodId;

  @BuiltValueField(wireName: r'action')
  PaymentHistoryActionEnum get action;
  // enum actionEnum {  payment_received,  refunded,  adjusted,  };

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  PaymentHistory._();

  factory PaymentHistory([void updates(PaymentHistoryBuilder b)]) = _$PaymentHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentHistory> get serializer => _$PaymentHistorySerializer();
}

class _$PaymentHistorySerializer implements PrimitiveSerializer<PaymentHistory> {
  @override
  final Iterable<Type> types = const [PaymentHistory, _$PaymentHistory];

  @override
  final String wireName = r'PaymentHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'payment_id';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(int),
    );
    if (object.paymentMethodId != null) {
      yield r'payment_method_id';
      yield serializers.serialize(
        object.paymentMethodId,
        specifiedType: const FullType(int),
      );
    }
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(PaymentHistoryActionEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentHistoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'payment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentId = valueDes;
          break;
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paymentMethodId = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentHistoryActionEnum),
          ) as PaymentHistoryActionEnum;
          result.action = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentHistoryBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class PaymentHistoryActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'payment_received')
  static const PaymentHistoryActionEnum paymentReceived = _$paymentHistoryActionEnum_paymentReceived;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const PaymentHistoryActionEnum refunded = _$paymentHistoryActionEnum_refunded;
  @BuiltValueEnumConst(wireName: r'adjusted')
  static const PaymentHistoryActionEnum adjusted = _$paymentHistoryActionEnum_adjusted;

  static Serializer<PaymentHistoryActionEnum> get serializer => _$paymentHistoryActionEnumSerializer;

  const PaymentHistoryActionEnum._(String name): super(name);

  static BuiltSet<PaymentHistoryActionEnum> get values => _$paymentHistoryActionEnumValues;
  static PaymentHistoryActionEnum valueOf(String name) => _$paymentHistoryActionEnumValueOf(name);
}

