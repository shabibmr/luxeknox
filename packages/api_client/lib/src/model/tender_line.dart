//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tender_line.g.dart';

/// TenderLine
///
/// Properties:
/// * [paymentMethodId] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [transactionReference] 
@BuiltValue()
abstract class TenderLine implements Built<TenderLine, TenderLineBuilder> {
  @BuiltValueField(wireName: r'payment_method_id')
  int get paymentMethodId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'transaction_reference')
  String? get transactionReference;

  TenderLine._();

  factory TenderLine([void updates(TenderLineBuilder b)]) = _$TenderLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TenderLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TenderLine> get serializer => _$TenderLineSerializer();
}

class _$TenderLineSerializer implements PrimitiveSerializer<TenderLine> {
  @override
  final Iterable<Type> types = const [TenderLine, _$TenderLine];

  @override
  final String wireName = r'TenderLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TenderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payment_method_id';
    yield serializers.serialize(
      object.paymentMethodId,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
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
    TenderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TenderLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentMethodId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
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
  TenderLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TenderLineBuilder();
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


