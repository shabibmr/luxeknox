//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_payment_method.g.dart';

/// GoLivePaymentMethod
///
/// Properties:
/// * [id] 
/// * [methodName] 
/// * [isActive] 
/// * [isDigital] 
/// * [accountId] 
/// * [accountCode] 
/// * [accountName] 
@BuiltValue()
abstract class GoLivePaymentMethod implements Built<GoLivePaymentMethod, GoLivePaymentMethodBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'method_name')
  String get methodName;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  @BuiltValueField(wireName: r'is_digital')
  bool get isDigital;

  @BuiltValueField(wireName: r'account_id')
  int? get accountId;

  @BuiltValueField(wireName: r'account_code')
  String? get accountCode;

  @BuiltValueField(wireName: r'account_name')
  String? get accountName;

  GoLivePaymentMethod._();

  factory GoLivePaymentMethod([void updates(GoLivePaymentMethodBuilder b)]) = _$GoLivePaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLivePaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLivePaymentMethod> get serializer => _$GoLivePaymentMethodSerializer();
}

class _$GoLivePaymentMethodSerializer implements PrimitiveSerializer<GoLivePaymentMethod> {
  @override
  final Iterable<Type> types = const [GoLivePaymentMethod, _$GoLivePaymentMethod];

  @override
  final String wireName = r'GoLivePaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLivePaymentMethod object, {
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
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'is_digital';
    yield serializers.serialize(
      object.isDigital,
      specifiedType: const FullType(bool),
    );
    if (object.accountId != null) {
      yield r'account_id';
      yield serializers.serialize(
        object.accountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.accountCode != null) {
      yield r'account_code';
      yield serializers.serialize(
        object.accountCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.accountName != null) {
      yield r'account_name';
      yield serializers.serialize(
        object.accountName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLivePaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLivePaymentMethodBuilder result,
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
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'is_digital':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDigital = valueDes;
          break;
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.accountId = valueDes;
          break;
        case r'account_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountCode = valueDes;
          break;
        case r'account_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLivePaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLivePaymentMethodBuilder();
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


