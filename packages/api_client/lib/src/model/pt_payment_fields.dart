//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/tender_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_payment_fields.g.dart';

/// PtPaymentFields
///
/// Properties:
/// * [discountAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [paymentMethodId] 
/// * [tenders] 
/// * [transactionReference] 
@BuiltValue(instantiable: false)
abstract class PtPaymentFields  {
  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'discount_amount')
  String? get discountAmount;

  @BuiltValueField(wireName: r'payment_method_id')
  int? get paymentMethodId;

  @BuiltValueField(wireName: r'tenders')
  BuiltList<TenderLine>? get tenders;

  @BuiltValueField(wireName: r'transaction_reference')
  String? get transactionReference;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtPaymentFields> get serializer => _$PtPaymentFieldsSerializer();
}

class _$PtPaymentFieldsSerializer implements PrimitiveSerializer<PtPaymentFields> {
  @override
  final Iterable<Type> types = const [PtPaymentFields];

  @override
  final String wireName = r'PtPaymentFields';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtPaymentFields object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    PtPaymentFields object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  PtPaymentFields deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($PtPaymentFields)) as $PtPaymentFields;
  }
}


/// a concrete implementation of [PtPaymentFields], since [PtPaymentFields] is not instantiable
@BuiltValue(instantiable: true)
abstract class $PtPaymentFields implements PtPaymentFields, Built<$PtPaymentFields, $PtPaymentFieldsBuilder> {
  $PtPaymentFields._();

  factory $PtPaymentFields([void Function($PtPaymentFieldsBuilder)? updates]) = _$$PtPaymentFields;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($PtPaymentFieldsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$PtPaymentFields> get serializer => _$$PtPaymentFieldsSerializer();
}

class _$$PtPaymentFieldsSerializer implements PrimitiveSerializer<$PtPaymentFields> {
  @override
  final Iterable<Type> types = const [$PtPaymentFields, _$$PtPaymentFields];

  @override
  final String wireName = r'$PtPaymentFields';

  @override
  Object serialize(
    Serializers serializers,
    $PtPaymentFields object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(PtPaymentFields))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtPaymentFieldsBuilder result,
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
  $PtPaymentFields deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $PtPaymentFieldsBuilder();
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

