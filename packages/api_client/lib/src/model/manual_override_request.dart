//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manual_override_request.g.dart';

/// ManualOverrideRequest
///
/// Properties:
/// * [userId] 
/// * [gateIdentifier] 
/// * [reason] 
@BuiltValue()
abstract class ManualOverrideRequest implements Built<ManualOverrideRequest, ManualOverrideRequestBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'gate_identifier')
  String? get gateIdentifier;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ManualOverrideRequest._();

  factory ManualOverrideRequest([void updates(ManualOverrideRequestBuilder b)]) = _$ManualOverrideRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManualOverrideRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManualOverrideRequest> get serializer => _$ManualOverrideRequestSerializer();
}

class _$ManualOverrideRequestSerializer implements PrimitiveSerializer<ManualOverrideRequest> {
  @override
  final Iterable<Type> types = const [ManualOverrideRequest, _$ManualOverrideRequest];

  @override
  final String wireName = r'ManualOverrideRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManualOverrideRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    if (object.gateIdentifier != null) {
      yield r'gate_identifier';
      yield serializers.serialize(
        object.gateIdentifier,
        specifiedType: const FullType(String),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ManualOverrideRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManualOverrideRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'gate_identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gateIdentifier = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ManualOverrideRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManualOverrideRequestBuilder();
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


