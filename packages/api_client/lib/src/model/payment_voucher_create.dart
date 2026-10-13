//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/payment_allocation_write.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_voucher_create.g.dart';

/// PaymentVoucherCreate
///
/// Properties:
/// * [paymentDate] 
/// * [bankAccountId] 
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [memo] 
/// * [allocations] 
@BuiltValue()
abstract class PaymentVoucherCreate implements Built<PaymentVoucherCreate, PaymentVoucherCreateBuilder> {
  @BuiltValueField(wireName: r'payment_date')
  Date get paymentDate;

  @BuiltValueField(wireName: r'bank_account_id')
  int get bankAccountId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'allocations')
  BuiltList<PaymentAllocationWrite> get allocations;

  PaymentVoucherCreate._();

  factory PaymentVoucherCreate([void updates(PaymentVoucherCreateBuilder b)]) = _$PaymentVoucherCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentVoucherCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentVoucherCreate> get serializer => _$PaymentVoucherCreateSerializer();
}

class _$PaymentVoucherCreateSerializer implements PrimitiveSerializer<PaymentVoucherCreate> {
  @override
  final Iterable<Type> types = const [PaymentVoucherCreate, _$PaymentVoucherCreate];

  @override
  final String wireName = r'PaymentVoucherCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentVoucherCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payment_date';
    yield serializers.serialize(
      object.paymentDate,
      specifiedType: const FullType(Date),
    );
    yield r'bank_account_id';
    yield serializers.serialize(
      object.bankAccountId,
      specifiedType: const FullType(int),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    yield r'allocations';
    yield serializers.serialize(
      object.allocations,
      specifiedType: const FullType(BuiltList, [FullType(PaymentAllocationWrite)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentVoucherCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentVoucherCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.paymentDate = valueDes;
          break;
        case r'bank_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bankAccountId = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(BuiltList, [FullType(PaymentAllocationWrite)]),
          ) as BuiltList<PaymentAllocationWrite>;
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
  PaymentVoucherCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentVoucherCreateBuilder();
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


