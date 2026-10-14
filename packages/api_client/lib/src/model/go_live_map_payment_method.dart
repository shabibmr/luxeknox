//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_map_payment_method.g.dart';

/// GoLiveMapPaymentMethod
///
/// Properties:
/// * [accountId] 
@BuiltValue()
abstract class GoLiveMapPaymentMethod implements Built<GoLiveMapPaymentMethod, GoLiveMapPaymentMethodBuilder> {
  @BuiltValueField(wireName: r'account_id')
  int? get accountId;

  GoLiveMapPaymentMethod._();

  factory GoLiveMapPaymentMethod([void updates(GoLiveMapPaymentMethodBuilder b)]) = _$GoLiveMapPaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveMapPaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveMapPaymentMethod> get serializer => _$GoLiveMapPaymentMethodSerializer();
}

class _$GoLiveMapPaymentMethodSerializer implements PrimitiveSerializer<GoLiveMapPaymentMethod> {
  @override
  final Iterable<Type> types = const [GoLiveMapPaymentMethod, _$GoLiveMapPaymentMethod];

  @override
  final String wireName = r'GoLiveMapPaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveMapPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accountId != null) {
      yield r'account_id';
      yield serializers.serialize(
        object.accountId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveMapPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveMapPaymentMethodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.accountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveMapPaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveMapPaymentMethodBuilder();
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


