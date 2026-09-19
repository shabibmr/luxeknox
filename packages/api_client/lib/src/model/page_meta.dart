//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'page_meta.g.dart';

/// PageMeta
///
/// Properties:
/// * [limit] 
/// * [offset] 
/// * [cursor] 
/// * [nextCursor] 
/// * [hasMore] 
/// * [total] - Present on offset lists; omitted on cursor feeds.
@BuiltValue()
abstract class PageMeta implements Built<PageMeta, PageMetaBuilder> {
  @BuiltValueField(wireName: r'limit')
  int get limit;

  @BuiltValueField(wireName: r'offset')
  int? get offset;

  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  /// Present on offset lists; omitted on cursor feeds.
  @BuiltValueField(wireName: r'total')
  int? get total;

  PageMeta._();

  factory PageMeta([void updates(PageMetaBuilder b)]) = _$PageMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PageMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PageMeta> get serializer => _$PageMetaSerializer();
}

class _$PageMetaSerializer implements PrimitiveSerializer<PageMeta> {
  @override
  final Iterable<Type> types = const [PageMeta, _$PageMeta];

  @override
  final String wireName = r'PageMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
    if (object.offset != null) {
      yield r'offset';
      yield serializers.serialize(
        object.offset,
        specifiedType: const FullType(int),
      );
    }
    if (object.cursor != null) {
      yield r'cursor';
      yield serializers.serialize(
        object.cursor,
        specifiedType: const FullType(String),
      );
    }
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType(String),
      );
    }
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    if (object.total != null) {
      yield r'total';
      yield serializers.serialize(
        object.total,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PageMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        case r'offset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.offset = valueDes;
          break;
        case r'cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PageMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PageMetaBuilder();
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


