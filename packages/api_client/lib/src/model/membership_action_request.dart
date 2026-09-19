//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_action_request.g.dart';

/// MembershipActionRequest
///
/// Properties:
/// * [productId] 
/// * [rowVersion] 
/// * [reason] 
@BuiltValue()
abstract class MembershipActionRequest implements Built<MembershipActionRequest, MembershipActionRequestBuilder> {
  @BuiltValueField(wireName: r'product_id')
  int? get productId;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  MembershipActionRequest._();

  factory MembershipActionRequest([void updates(MembershipActionRequestBuilder b)]) = _$MembershipActionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipActionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipActionRequest> get serializer => _$MembershipActionRequestSerializer();
}

class _$MembershipActionRequestSerializer implements PrimitiveSerializer<MembershipActionRequest> {
  @override
  final Iterable<Type> types = const [MembershipActionRequest, _$MembershipActionRequest];

  @override
  final String wireName = r'MembershipActionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipActionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.productId != null) {
      yield r'product_id';
      yield serializers.serialize(
        object.productId,
        specifiedType: const FullType(int),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipActionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipActionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.productId = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  MembershipActionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipActionRequestBuilder();
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


