//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_method.g.dart';

/// PaymentMethod
///
/// Properties:
/// * [id] 
/// * [methodName] 
/// * [isDigital] 
/// * [isActive] 
@BuiltValue()
abstract class PaymentMethod implements Built<PaymentMethod, PaymentMethodBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'method_name')
  String get methodName;

  @BuiltValueField(wireName: r'is_digital')
  bool? get isDigital;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  PaymentMethod._();

  factory PaymentMethod([void updates(PaymentMethodBuilder b)]) = _$PaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentMethod> get serializer => _$PaymentMethodSerializer();
}

class _$PaymentMethodSerializer implements PrimitiveSerializer<PaymentMethod> {
  @override
  final Iterable<Type> types = const [PaymentMethod, _$PaymentMethod];

  @override
  final String wireName = r'PaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentMethodBuilder result,
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
            specifiedType: const FullType(bool),
          ) as bool;
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
  PaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentMethodBuilder();
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


