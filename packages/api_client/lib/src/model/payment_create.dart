//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/tender_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_create.g.dart';

/// PaymentCreate
///
/// Properties:
/// * [memberId] 
/// * [membershipId] 
/// * [productId] - If set, assign/renew membership in the same transaction when paid.
/// * [subtotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [discountAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [paymentMethodId] 
/// * [tenders] - Split tender. Sum becomes amount_paid. payment_method_id on header is null when present.
/// * [transactionReference] 
@BuiltValue()
abstract class PaymentCreate implements Built<PaymentCreate, PaymentCreateBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'membership_id')
  int? get membershipId;

  /// If set, assign/renew membership in the same transaction when paid.
  @BuiltValueField(wireName: r'product_id')
  int? get productId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'discount_amount')
  String? get discountAmount;

  @BuiltValueField(wireName: r'payment_method_id')
  int? get paymentMethodId;

  /// Split tender. Sum becomes amount_paid. payment_method_id on header is null when present.
  @BuiltValueField(wireName: r'tenders')
  BuiltList<TenderLine>? get tenders;

  @BuiltValueField(wireName: r'transaction_reference')
  String? get transactionReference;

  PaymentCreate._();

  factory PaymentCreate([void updates(PaymentCreateBuilder b)]) = _$PaymentCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentCreate> get serializer => _$PaymentCreateSerializer();
}

class _$PaymentCreateSerializer implements PrimitiveSerializer<PaymentCreate> {
  @override
  final Iterable<Type> types = const [PaymentCreate, _$PaymentCreate];

  @override
  final String wireName = r'PaymentCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.productId != null) {
      yield r'product_id';
      yield serializers.serialize(
        object.productId,
        specifiedType: const FullType(int),
      );
    }
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    if (object.discountAmount != null) {
      yield r'discount_amount';
      yield serializers.serialize(
        object.discountAmount,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentMethodId != null) {
      yield r'payment_method_id';
      yield serializers.serialize(
        object.paymentMethodId,
        specifiedType: const FullType(int),
      );
    }
    if (object.tenders != null) {
      yield r'tenders';
      yield serializers.serialize(
        object.tenders,
        specifiedType: const FullType(BuiltList, [FullType(TenderLine)]),
      );
    }
    if (object.transactionReference != null) {
      yield r'transaction_reference';
      yield serializers.serialize(
        object.transactionReference,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.productId = valueDes;
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subtotal = valueDes;
          break;
        case r'discount_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.discountAmount = valueDes;
          break;
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paymentMethodId = valueDes;
          break;
        case r'tenders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(TenderLine)]),
          ) as BuiltList<TenderLine>?;
          if (valueDes == null) continue;
          result.tenders.replace(valueDes);
          break;
        case r'transaction_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.transactionReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentCreateBuilder();
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


