//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/tender_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/pt_payment_fields.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_purchase_request.g.dart';

/// PtPurchaseRequest
///
/// Properties:
/// * [discountAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [paymentMethodId] 
/// * [tenders] 
/// * [transactionReference] 
/// * [memberId] 
/// * [ptProductId] 
/// * [trainerId] 
/// * [startDate] 
/// * [weekdays] 
/// * [slotStart] 
@BuiltValue()
abstract class PtPurchaseRequest implements PtPaymentFields, Built<PtPurchaseRequest, PtPurchaseRequestBuilder> {
  @BuiltValueField(wireName: r'pt_product_id')
  int get ptProductId;

  @BuiltValueField(wireName: r'weekdays')
  BuiltList<int> get weekdays;

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'slot_start')
  String get slotStart;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  PtPurchaseRequest._();

  factory PtPurchaseRequest([void updates(PtPurchaseRequestBuilder b)]) = _$PtPurchaseRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtPurchaseRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtPurchaseRequest> get serializer => _$PtPurchaseRequestSerializer();
}

class _$PtPurchaseRequestSerializer implements PrimitiveSerializer<PtPurchaseRequest> {
  @override
  final Iterable<Type> types = const [PtPurchaseRequest, _$PtPurchaseRequest];

  @override
  final String wireName = r'PtPurchaseRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtPurchaseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pt_product_id';
    yield serializers.serialize(
      object.ptProductId,
      specifiedType: const FullType(int),
    );
    if (object.transactionReference != null) {
      yield r'transaction_reference';
      yield serializers.serialize(
        object.transactionReference,
        specifiedType: const FullType(String),
      );
    }
    yield r'weekdays';
    yield serializers.serialize(
      object.weekdays,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
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
    if (object.discountAmount != null) {
      yield r'discount_amount';
      yield serializers.serialize(
        object.discountAmount,
        specifiedType: const FullType(String),
      );
    }
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'slot_start';
    yield serializers.serialize(
      object.slotStart,
      specifiedType: const FullType(String),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtPurchaseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtPurchaseRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pt_product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
        case r'weekdays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.weekdays.replace(valueDes);
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
        case r'discount_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.discountAmount = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'slot_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slotStart = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtPurchaseRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtPurchaseRequestBuilder();
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


