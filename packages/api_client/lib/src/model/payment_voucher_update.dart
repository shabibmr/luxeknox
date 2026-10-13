//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/payment_allocation_write.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_voucher_update.g.dart';

/// PaymentVoucherUpdate
///
/// Properties:
/// * [paymentDate] 
/// * [bankAccountId] 
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [memo] 
/// * [allocations] 
@BuiltValue()
abstract class PaymentVoucherUpdate implements Built<PaymentVoucherUpdate, PaymentVoucherUpdateBuilder> {
  @BuiltValueField(wireName: r'payment_date')
  Date? get paymentDate;

  @BuiltValueField(wireName: r'bank_account_id')
  int? get bankAccountId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String? get totalAmount;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'allocations')
  BuiltList<PaymentAllocationWrite>? get allocations;

  PaymentVoucherUpdate._();

  factory PaymentVoucherUpdate([void updates(PaymentVoucherUpdateBuilder b)]) = _$PaymentVoucherUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentVoucherUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentVoucherUpdate> get serializer => _$PaymentVoucherUpdateSerializer();
}

class _$PaymentVoucherUpdateSerializer implements PrimitiveSerializer<PaymentVoucherUpdate> {
  @override
  final Iterable<Type> types = const [PaymentVoucherUpdate, _$PaymentVoucherUpdate];

  @override
  final String wireName = r'PaymentVoucherUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentVoucherUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.paymentDate != null) {
      yield r'payment_date';
      yield serializers.serialize(
        object.paymentDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.bankAccountId != null) {
      yield r'bank_account_id';
      yield serializers.serialize(
        object.bankAccountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalAmount != null) {
      yield r'total_amount';
      yield serializers.serialize(
        object.totalAmount,
        specifiedType: const FullType(String),
      );
    }
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    if (object.allocations != null) {
      yield r'allocations';
      yield serializers.serialize(
        object.allocations,
        specifiedType: const FullType(BuiltList, [FullType(PaymentAllocationWrite)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentVoucherUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentVoucherUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.paymentDate = valueDes;
          break;
        case r'bank_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.bankAccountId = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.totalAmount = valueDes;
          break;
        case r'memo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memo = valueDes;
          break;
        case r'allocations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PaymentAllocationWrite)]),
          ) as BuiltList<PaymentAllocationWrite>?;
          if (valueDes == null) continue;
          result.allocations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentVoucherUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentVoucherUpdateBuilder();
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


