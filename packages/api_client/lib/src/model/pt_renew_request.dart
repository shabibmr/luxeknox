//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/tender_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/pt_payment_fields.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_renew_request.g.dart';

/// PtRenewRequest
///
/// Properties:
/// * [discountAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [paymentMethodId] 
/// * [tenders] 
/// * [transactionReference] 
/// * [ptProductId] 
@BuiltValue()
abstract class PtRenewRequest implements PtPaymentFields, Built<PtRenewRequest, PtRenewRequestBuilder> {
  @BuiltValueField(wireName: r'pt_product_id')
  int? get ptProductId;

  PtRenewRequest._();

  factory PtRenewRequest([void updates(PtRenewRequestBuilder b)]) = _$PtRenewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtRenewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtRenewRequest> get serializer => _$PtRenewRequestSerializer();
}

class _$PtRenewRequestSerializer implements PrimitiveSerializer<PtRenewRequest> {
  @override
  final Iterable<Type> types = const [PtRenewRequest, _$PtRenewRequest];

  @override
  final String wireName = r'PtRenewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtRenewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.discountAmount != null) {
      yield r'discount_amount';
      yield serializers.serialize(
        object.discountAmount,
        specifiedType: const FullType(String),
      );
    }
    if (object.ptProductId != null) {
      yield r'pt_product_id';
      yield serializers.serialize(
        object.ptProductId,
        specifiedType: const FullType(int),
      );
    }
    if (object.transactionReference != null) {
      yield r'transaction_reference';
      yield serializers.serialize(
        object.transactionReference,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PtRenewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtRenewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'discount_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.discountAmount = valueDes;
          break;
        case r'pt_product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ptProductId = valueDes;
          break;
        case r'transaction_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.transactionReference = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtRenewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtRenewRequestBuilder();
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


