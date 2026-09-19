//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/me_response_profile.dart';
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/principal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_response.g.dart';

/// MeResponse
///
/// Properties:
/// * [user] 
/// * [principal] 
/// * [profile] 
@BuiltValue()
abstract class MeResponse implements Built<MeResponse, MeResponseBuilder> {
  @BuiltValueField(wireName: r'user')
  User get user;

  @BuiltValueField(wireName: r'principal')
  Principal get principal;

  @BuiltValueField(wireName: r'profile')
  MeResponseProfile get profile;

  MeResponse._();

  factory MeResponse([void updates(MeResponseBuilder b)]) = _$MeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeResponse> get serializer => _$MeResponseSerializer();
}

class _$MeResponseSerializer implements PrimitiveSerializer<MeResponse> {
  @override
  final Iterable<Type> types = const [MeResponse, _$MeResponse];

  @override
  final String wireName = r'MeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(User),
    );
    yield r'principal';
    yield serializers.serialize(
      object.principal,
      specifiedType: const FullType(Principal),
    );
    yield r'profile';
    yield serializers.serialize(
      object.profile,
      specifiedType: const FullType(MeResponseProfile),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(User),
          ) as User;
          result.user.replace(valueDes);
          break;
        case r'principal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Principal),
          ) as Principal;
          result.principal.replace(valueDes);
          break;
        case r'profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MeResponseProfile),
          ) as MeResponseProfile;
          result.profile.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeResponseBuilder();
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


