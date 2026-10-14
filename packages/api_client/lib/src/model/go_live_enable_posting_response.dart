//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_enable_posting_response.g.dart';

/// GoLiveEnablePostingResponse
///
/// Properties:
/// * [success] 
/// * [postingEnabled] 
@BuiltValue()
abstract class GoLiveEnablePostingResponse implements Built<GoLiveEnablePostingResponse, GoLiveEnablePostingResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'posting_enabled')
  bool get postingEnabled;

  GoLiveEnablePostingResponse._();

  factory GoLiveEnablePostingResponse([void updates(GoLiveEnablePostingResponseBuilder b)]) = _$GoLiveEnablePostingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveEnablePostingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveEnablePostingResponse> get serializer => _$GoLiveEnablePostingResponseSerializer();
}

class _$GoLiveEnablePostingResponseSerializer implements PrimitiveSerializer<GoLiveEnablePostingResponse> {
  @override
  final Iterable<Type> types = const [GoLiveEnablePostingResponse, _$GoLiveEnablePostingResponse];

  @override
  final String wireName = r'GoLiveEnablePostingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveEnablePostingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'posting_enabled';
    yield serializers.serialize(
      object.postingEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveEnablePostingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveEnablePostingResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'posting_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.postingEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveEnablePostingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveEnablePostingResponseBuilder();
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


