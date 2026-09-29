//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/pt_subscription.dart';
import 'package:api_client/src/model/payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_purchase_result.g.dart';

/// PtPurchaseResult
///
/// Properties:
/// * [subscription] 
/// * [payment] 
@BuiltValue()
abstract class PtPurchaseResult implements Built<PtPurchaseResult, PtPurchaseResultBuilder> {
  @BuiltValueField(wireName: r'subscription')
  PtSubscription get subscription;

  @BuiltValueField(wireName: r'payment')
  Payment get payment;

  PtPurchaseResult._();

  factory PtPurchaseResult([void updates(PtPurchaseResultBuilder b)]) = _$PtPurchaseResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtPurchaseResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtPurchaseResult> get serializer => _$PtPurchaseResultSerializer();
}

class _$PtPurchaseResultSerializer implements PrimitiveSerializer<PtPurchaseResult> {
  @override
  final Iterable<Type> types = const [PtPurchaseResult, _$PtPurchaseResult];

  @override
  final String wireName = r'PtPurchaseResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtPurchaseResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subscription';
    yield serializers.serialize(
      object.subscription,
      specifiedType: const FullType(PtSubscription),
    );
    yield r'payment';
    yield serializers.serialize(
      object.payment,
      specifiedType: const FullType(Payment),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtPurchaseResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtPurchaseResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subscription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PtSubscription),
          ) as PtSubscription;
          result.subscription.replace(valueDes);
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Payment),
          ) as Payment;
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
  PtPurchaseResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtPurchaseResultBuilder();
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


