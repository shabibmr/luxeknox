//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/progress_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_note_page.g.dart';

/// ProgressNotePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ProgressNotePage implements Built<ProgressNotePage, ProgressNotePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ProgressNote> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ProgressNotePage._();

  factory ProgressNotePage([void updates(ProgressNotePageBuilder b)]) = _$ProgressNotePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressNotePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressNotePage> get serializer => _$ProgressNotePageSerializer();
}

class _$ProgressNotePageSerializer implements PrimitiveSerializer<ProgressNotePage> {
  @override
  final Iterable<Type> types = const [ProgressNotePage, _$ProgressNotePage];

  @override
  final String wireName = r'ProgressNotePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressNotePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ProgressNote)]),
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
    ProgressNotePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressNotePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProgressNote)]),
          ) as BuiltList<ProgressNote>;
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
  ProgressNotePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressNotePageBuilder();
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


