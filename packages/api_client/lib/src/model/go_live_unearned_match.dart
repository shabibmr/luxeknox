//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_unearned_match.g.dart';

/// GoLiveUnearnedMatch
///
/// Properties:
/// * [preview] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [actual] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [matched] 
@BuiltValue()
abstract class GoLiveUnearnedMatch implements Built<GoLiveUnearnedMatch, GoLiveUnearnedMatchBuilder> {
  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'preview')
  String get preview;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'actual')
  String get actual;

  @BuiltValueField(wireName: r'matched')
  bool get matched;

  GoLiveUnearnedMatch._();

  factory GoLiveUnearnedMatch([void updates(GoLiveUnearnedMatchBuilder b)]) = _$GoLiveUnearnedMatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveUnearnedMatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveUnearnedMatch> get serializer => _$GoLiveUnearnedMatchSerializer();
}

class _$GoLiveUnearnedMatchSerializer implements PrimitiveSerializer<GoLiveUnearnedMatch> {
  @override
  final Iterable<Type> types = const [GoLiveUnearnedMatch, _$GoLiveUnearnedMatch];

  @override
  final String wireName = r'GoLiveUnearnedMatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveUnearnedMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'preview';
    yield serializers.serialize(
      object.preview,
      specifiedType: const FullType(String),
    );
    yield r'actual';
    yield serializers.serialize(
      object.actual,
      specifiedType: const FullType(String),
    );
    yield r'matched';
    yield serializers.serialize(
      object.matched,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveUnearnedMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveUnearnedMatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'preview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preview = valueDes;
          break;
        case r'actual':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actual = valueDes;
          break;
        case r'matched':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.matched = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveUnearnedMatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveUnearnedMatchBuilder();
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


