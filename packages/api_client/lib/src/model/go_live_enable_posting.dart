//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_enable_posting.g.dart';

/// GoLiveEnablePosting
///
/// Properties:
/// * [goLiveDate] 
@BuiltValue()
abstract class GoLiveEnablePosting implements Built<GoLiveEnablePosting, GoLiveEnablePostingBuilder> {
  @BuiltValueField(wireName: r'go_live_date')
  Date? get goLiveDate;

  GoLiveEnablePosting._();

  factory GoLiveEnablePosting([void updates(GoLiveEnablePostingBuilder b)]) = _$GoLiveEnablePosting;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveEnablePostingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveEnablePosting> get serializer => _$GoLiveEnablePostingSerializer();
}

class _$GoLiveEnablePostingSerializer implements PrimitiveSerializer<GoLiveEnablePosting> {
  @override
  final Iterable<Type> types = const [GoLiveEnablePosting, _$GoLiveEnablePosting];

  @override
  final String wireName = r'GoLiveEnablePosting';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveEnablePosting object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.goLiveDate != null) {
      yield r'go_live_date';
      yield serializers.serialize(
        object.goLiveDate,
        specifiedType: const FullType(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveEnablePosting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveEnablePostingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'go_live_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.goLiveDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveEnablePosting deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveEnablePostingBuilder();
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


