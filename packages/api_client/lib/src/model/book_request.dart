//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'book_request.g.dart';

/// BookRequest
///
/// Properties:
/// * [memberId] - Required when the caller is staff; a member caller books themselves.
@BuiltValue()
abstract class BookRequest implements Built<BookRequest, BookRequestBuilder> {
  /// Required when the caller is staff; a member caller books themselves.
  @BuiltValueField(wireName: r'member_id')
  int? get memberId;

  BookRequest._();

  factory BookRequest([void updates(BookRequestBuilder b)]) = _$BookRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookRequest> get serializer => _$BookRequestSerializer();
}

class _$BookRequestSerializer implements PrimitiveSerializer<BookRequest> {
  @override
  final Iterable<Type> types = const [BookRequest, _$BookRequest];

  @override
  final String wireName = r'BookRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.memberId != null) {
      yield r'member_id';
      yield serializers.serialize(
        object.memberId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BookRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.memberId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookRequestBuilder();
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


