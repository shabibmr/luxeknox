//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_adjust_request.g.dart';

/// PaymentAdjustRequest
///
/// Properties:
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [paymentMethodId] 
/// * [notes] 
/// * [rowVersion] 
@BuiltValue()
abstract class PaymentAdjustRequest implements Built<PaymentAdjustRequest, PaymentAdjustRequestBuilder> {
  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'payment_method_id')
  int? get paymentMethodId;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  PaymentAdjustRequest._();

  factory PaymentAdjustRequest([void updates(PaymentAdjustRequestBuilder b)]) = _$PaymentAdjustRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentAdjustRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentAdjustRequest> get serializer => _$PaymentAdjustRequestSerializer();
}

class _$PaymentAdjustRequestSerializer implements PrimitiveSerializer<PaymentAdjustRequest> {
  @override
  final Iterable<Type> types = const [PaymentAdjustRequest, _$PaymentAdjustRequest];

  @override
  final String wireName = r'PaymentAdjustRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentAdjustRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    if (object.paymentMethodId != null) {
      yield r'payment_method_id';
      yield serializers.serialize(
        object.paymentMethodId,
        specifiedType: const FullType(int),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentAdjustRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentAdjustRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paymentMethodId = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentAdjustRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentAdjustRequestBuilder();
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


