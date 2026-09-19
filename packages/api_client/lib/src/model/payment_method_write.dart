//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_method_write.g.dart';

/// PaymentMethodWrite
///
/// Properties:
/// * [methodName] 
/// * [isDigital] 
/// * [isActive] 
@BuiltValue()
abstract class PaymentMethodWrite implements Built<PaymentMethodWrite, PaymentMethodWriteBuilder> {
  @BuiltValueField(wireName: r'method_name')
  String get methodName;

  @BuiltValueField(wireName: r'is_digital')
  bool? get isDigital;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  PaymentMethodWrite._();

  factory PaymentMethodWrite([void updates(PaymentMethodWriteBuilder b)]) = _$PaymentMethodWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentMethodWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentMethodWrite> get serializer => _$PaymentMethodWriteSerializer();
}

class _$PaymentMethodWriteSerializer implements PrimitiveSerializer<PaymentMethodWrite> {
  @override
  final Iterable<Type> types = const [PaymentMethodWrite, _$PaymentMethodWrite];

  @override
  final String wireName = r'PaymentMethodWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentMethodWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'method_name';
    yield serializers.serialize(
      object.methodName,
      specifiedType: const FullType(String),
    );
    if (object.isDigital != null) {
      yield r'is_digital';
      yield serializers.serialize(
        object.isDigital,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentMethodWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentMethodWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'method_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.methodName = valueDes;
          break;
        case r'is_digital':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isDigital = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentMethodWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentMethodWriteBuilder();
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


