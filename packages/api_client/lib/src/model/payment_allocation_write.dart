//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_allocation_write.g.dart';

/// PaymentAllocationWrite
///
/// Properties:
/// * [purchaseBillId] 
/// * [expenseVoucherId] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class PaymentAllocationWrite implements Built<PaymentAllocationWrite, PaymentAllocationWriteBuilder> {
  @BuiltValueField(wireName: r'purchase_bill_id')
  int? get purchaseBillId;

  @BuiltValueField(wireName: r'expense_voucher_id')
  int? get expenseVoucherId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  PaymentAllocationWrite._();

  factory PaymentAllocationWrite([void updates(PaymentAllocationWriteBuilder b)]) = _$PaymentAllocationWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentAllocationWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentAllocationWrite> get serializer => _$PaymentAllocationWriteSerializer();
}

class _$PaymentAllocationWriteSerializer implements PrimitiveSerializer<PaymentAllocationWrite> {
  @override
  final Iterable<Type> types = const [PaymentAllocationWrite, _$PaymentAllocationWrite];

  @override
  final String wireName = r'PaymentAllocationWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentAllocationWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    PaymentAllocationWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentAllocationWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  PaymentAllocationWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentAllocationWriteBuilder();
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


