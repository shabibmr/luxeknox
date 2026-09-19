//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_receipt.g.dart';

/// PaymentReceipt
///
/// Properties:
/// * [id] 
/// * [paymentId] 
/// * [receiptNumber] 
/// * [receiptPdfUrl] - Null in MVP; receipt is re-rendered from ledger rows (ADR-0005).
/// * [generatedAt] - UTC ISO-8601
/// * [payment] 
@BuiltValue()
abstract class PaymentReceipt implements Built<PaymentReceipt, PaymentReceiptBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'payment_id')
  int get paymentId;

  @BuiltValueField(wireName: r'receipt_number')
  String get receiptNumber;

  /// Null in MVP; receipt is re-rendered from ledger rows (ADR-0005).
  @BuiltValueField(wireName: r'receipt_pdf_url')
  String? get receiptPdfUrl;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'generated_at')
  DateTime? get generatedAt;

  @BuiltValueField(wireName: r'payment')
  Payment? get payment;

  PaymentReceipt._();

  factory PaymentReceipt([void updates(PaymentReceiptBuilder b)]) = _$PaymentReceipt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentReceiptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentReceipt> get serializer => _$PaymentReceiptSerializer();
}

class _$PaymentReceiptSerializer implements PrimitiveSerializer<PaymentReceipt> {
  @override
  final Iterable<Type> types = const [PaymentReceipt, _$PaymentReceipt];

  @override
  final String wireName = r'PaymentReceipt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentReceipt object, {
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
    yield r'receipt_number';
    yield serializers.serialize(
      object.receiptNumber,
      specifiedType: const FullType(String),
    );
    if (object.receiptPdfUrl != null) {
      yield r'receipt_pdf_url';
      yield serializers.serialize(
        object.receiptPdfUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.generatedAt != null) {
      yield r'generated_at';
      yield serializers.serialize(
        object.generatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.payment != null) {
      yield r'payment';
      yield serializers.serialize(
        object.payment,
        specifiedType: const FullType(Payment),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentReceiptBuilder result,
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
        case r'receipt_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.receiptNumber = valueDes;
          break;
        case r'receipt_pdf_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.receiptPdfUrl = valueDes;
          break;
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.generatedAt = valueDes;
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Payment),
          ) as Payment?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentReceipt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentReceiptBuilder();
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


