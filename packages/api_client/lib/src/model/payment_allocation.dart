//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_allocation.g.dart';

/// PaymentAllocation
///
/// Properties:
/// * [id] 
/// * [paymentVoucherId] 
/// * [purchaseBillId] 
/// * [expenseVoucherId] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class PaymentAllocation implements Built<PaymentAllocation, PaymentAllocationBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'payment_voucher_id')
  int get paymentVoucherId;

  @BuiltValueField(wireName: r'purchase_bill_id')
  int? get purchaseBillId;

  @BuiltValueField(wireName: r'expense_voucher_id')
  int? get expenseVoucherId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  PaymentAllocation._();

  factory PaymentAllocation([void updates(PaymentAllocationBuilder b)]) = _$PaymentAllocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentAllocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentAllocation> get serializer => _$PaymentAllocationSerializer();
}

class _$PaymentAllocationSerializer implements PrimitiveSerializer<PaymentAllocation> {
  @override
  final Iterable<Type> types = const [PaymentAllocation, _$PaymentAllocation];

  @override
  final String wireName = r'PaymentAllocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'payment_voucher_id';
    yield serializers.serialize(
      object.paymentVoucherId,
      specifiedType: const FullType(int),
    );
    if (object.purchaseBillId != null) {
      yield r'purchase_bill_id';
      yield serializers.serialize(
        object.purchaseBillId,
        specifiedType: const FullType(int),
      );
    }
    if (object.expenseVoucherId != null) {
      yield r'expense_voucher_id';
      yield serializers.serialize(
        object.expenseVoucherId,
        specifiedType: const FullType(int),
      );
    }
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentAllocationBuilder result,
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
        case r'payment_voucher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentVoucherId = valueDes;
          break;
        case r'purchase_bill_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.purchaseBillId = valueDes;
          break;
        case r'expense_voucher_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expenseVoucherId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentAllocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentAllocationBuilder();
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


