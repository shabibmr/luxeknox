//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/debit_note.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'debit_note_page.g.dart';

/// DebitNotePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class DebitNotePage implements Built<DebitNotePage, DebitNotePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DebitNote> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  DebitNotePage._();

  factory DebitNotePage([void updates(DebitNotePageBuilder b)]) = _$DebitNotePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DebitNotePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DebitNotePage> get serializer => _$DebitNotePageSerializer();
}

class _$DebitNotePageSerializer implements PrimitiveSerializer<DebitNotePage> {
  @override
  final Iterable<Type> types = const [DebitNotePage, _$DebitNotePage];

  @override
  final String wireName = r'DebitNotePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DebitNotePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DebitNote)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DebitNotePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DebitNotePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DebitNote)]),
          ) as BuiltList<DebitNote>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DebitNotePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DebitNotePageBuilder();
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


