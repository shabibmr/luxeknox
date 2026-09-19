//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_note.g.dart';

/// ProgressNote
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [authorUserId] 
/// * [noteText] 
/// * [noteType] 
/// * [createdAt] - UTC ISO-8601
@BuiltValue()
abstract class ProgressNote implements Built<ProgressNote, ProgressNoteBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'author_user_id')
  int get authorUserId;

  @BuiltValueField(wireName: r'note_text')
  String get noteText;

  @BuiltValueField(wireName: r'note_type')
  ProgressNoteNoteTypeEnum get noteType;
  // enum noteTypeEnum {  member_note,  trainer_assessment,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  ProgressNote._();

  factory ProgressNote([void updates(ProgressNoteBuilder b)]) = _$ProgressNote;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressNoteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressNote> get serializer => _$ProgressNoteSerializer();
}

class _$ProgressNoteSerializer implements PrimitiveSerializer<ProgressNote> {
  @override
  final Iterable<Type> types = const [ProgressNote, _$ProgressNote];

  @override
  final String wireName = r'ProgressNote';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressNote object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'author_user_id';
    yield serializers.serialize(
      object.authorUserId,
      specifiedType: const FullType(int),
    );
    yield r'note_text';
    yield serializers.serialize(
      object.noteText,
      specifiedType: const FullType(String),
    );
    yield r'note_type';
    yield serializers.serialize(
      object.noteType,
      specifiedType: const FullType(ProgressNoteNoteTypeEnum),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressNote object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressNoteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'author_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.authorUserId = valueDes;
          break;
        case r'note_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.noteText = valueDes;
          break;
        case r'note_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProgressNoteNoteTypeEnum),
          ) as ProgressNoteNoteTypeEnum;
          result.noteType = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressNote deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressNoteBuilder();
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


class ProgressNoteNoteTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'member_note')
  static const ProgressNoteNoteTypeEnum memberNote = _$progressNoteNoteTypeEnum_memberNote;
  @BuiltValueEnumConst(wireName: r'trainer_assessment')
  static const ProgressNoteNoteTypeEnum trainerAssessment = _$progressNoteNoteTypeEnum_trainerAssessment;

  static Serializer<ProgressNoteNoteTypeEnum> get serializer => _$progressNoteNoteTypeEnumSerializer;

  const ProgressNoteNoteTypeEnum._(String name): super(name);

  static BuiltSet<ProgressNoteNoteTypeEnum> get values => _$progressNoteNoteTypeEnumValues;
  static ProgressNoteNoteTypeEnum valueOf(String name) => _$progressNoteNoteTypeEnumValueOf(name);
}

