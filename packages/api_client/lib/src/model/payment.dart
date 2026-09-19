//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/payment_history.dart';
import 'package:api_client/src/model/payment_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment.g.dart';

/// Payment
///
/// Properties:
/// * [id] 
/// * [invoiceNumber] 
/// * [memberId] 
/// * [membershipId] 
/// * [paymentMethodId] 
/// * [subtotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [discountAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [amountPaid] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [status] 
/// * [transactionReference] 
/// * [cashierUserId] 
/// * [paymentDate] - UTC ISO-8601
/// * [rowVersion] 
/// * [histories] 
@BuiltValue()
abstract class Payment implements Built<Payment, PaymentBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'invoice_number')
  String get invoiceNumber;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'membership_id')
  int? get membershipId;

  @BuiltValueField(wireName: r'payment_method_id')
  int? get paymentMethodId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'tax_amount')
  String get taxAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'discount_amount')
  String get discountAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount_paid')
  String get amountPaid;

  @BuiltValueField(wireName: r'status')
  PaymentStatus get status;
  // enum statusEnum {  pending,  partial,  paid,  refunded,  };

  @BuiltValueField(wireName: r'transaction_reference')
  String? get transactionReference;

  @BuiltValueField(wireName: r'cashier_user_id')
  int? get cashierUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'payment_date')
  DateTime? get paymentDate;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'histories')
  BuiltList<PaymentHistory>? get histories;

  Payment._();

  factory Payment([void updates(PaymentBuilder b)]) = _$Payment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Payment> get serializer => _$PaymentSerializer();
}

class _$PaymentSerializer implements PrimitiveSerializer<Payment> {
  @override
  final Iterable<Type> types = const [Payment, _$Payment];

  @override
  final String wireName = r'Payment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Payment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'invoice_number';
    yield serializers.serialize(
      object.invoiceNumber,
      specifiedType: const FullType(String),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    if (object.membershipId != null) {
      yield r'membership_id';
      yield serializers.serialize(
        object.membershipId,
        specifiedType: const FullType(int),
      );
    }
    if (object.paymentMethodId != null) {
      yield r'payment_method_id';
      yield serializers.serialize(
        object.paymentMethodId,
        specifiedType: const FullType(int),
      );
    }
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    yield r'tax_amount';
    yield serializers.serialize(
      object.taxAmount,
      specifiedType: const FullType(String),
    );
    yield r'discount_amount';
    yield serializers.serialize(
      object.discountAmount,
      specifiedType: const FullType(String),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    yield r'amount_paid';
    yield serializers.serialize(
      object.amountPaid,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentStatus),
    );
    if (object.transactionReference != null) {
      yield r'transaction_reference';
      yield serializers.serialize(
        object.transactionReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.cashierUserId != null) {
      yield r'cashier_user_id';
      yield serializers.serialize(
        object.cashierUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.paymentDate != null) {
      yield r'payment_date';
      yield serializers.serialize(
        object.paymentDate,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    if (object.histories != null) {
      yield r'histories';
      yield serializers.serialize(
        object.histories,
        specifiedType: const FullType(BuiltList, [FullType(PaymentHistory)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Payment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentBuilder result,
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
        case r'invoice_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceNumber = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.membershipId = valueDes;
          break;
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paymentMethodId = valueDes;
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subtotal = valueDes;
          break;
        case r'tax_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxAmount = valueDes;
          break;
        case r'discount_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discountAmount = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAmount = valueDes;
          break;
        case r'amount_paid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amountPaid = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentStatus),
          ) as PaymentStatus;
          result.status = valueDes;
          break;
        case r'transaction_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.transactionReference = valueDes;
          break;
        case r'cashier_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cashierUserId = valueDes;
          break;
        case r'payment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paymentDate = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'histories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PaymentHistory)]),
          ) as BuiltList<PaymentHistory>?;
          if (valueDes == null) continue;
          result.histories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Payment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentBuilder();
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


