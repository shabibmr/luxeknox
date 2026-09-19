//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_note_write.g.dart';

/// ProgressNoteWrite
///
/// Properties:
/// * [noteText] 
/// * [noteType] 
@BuiltValue()
abstract class ProgressNoteWrite implements Built<ProgressNoteWrite, ProgressNoteWriteBuilder> {
  @BuiltValueField(wireName: r'note_text')
  String get noteText;

  @BuiltValueField(wireName: r'note_type')
  ProgressNoteWriteNoteTypeEnum get noteType;
  // enum noteTypeEnum {  member_note,  trainer_assessment,  };

  ProgressNoteWrite._();

  factory ProgressNoteWrite([void updates(ProgressNoteWriteBuilder b)]) = _$ProgressNoteWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressNoteWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressNoteWrite> get serializer => _$ProgressNoteWriteSerializer();
}

class _$ProgressNoteWriteSerializer implements PrimitiveSerializer<ProgressNoteWrite> {
  @override
  final Iterable<Type> types = const [ProgressNoteWrite, _$ProgressNoteWrite];

  @override
  final String wireName = r'ProgressNoteWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressNoteWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'note_text';
    yield serializers.serialize(
      object.noteText,
      specifiedType: const FullType(String),
    );
    yield r'note_type';
    yield serializers.serialize(
      object.noteType,
      specifiedType: const FullType(ProgressNoteWriteNoteTypeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressNoteWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressNoteWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(ProgressNoteWriteNoteTypeEnum),
          ) as ProgressNoteWriteNoteTypeEnum;
          result.noteType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressNoteWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressNoteWriteBuilder();
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


class ProgressNoteWriteNoteTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'member_note')
  static const ProgressNoteWriteNoteTypeEnum memberNote = _$progressNoteWriteNoteTypeEnum_memberNote;
  @BuiltValueEnumConst(wireName: r'trainer_assessment')
  static const ProgressNoteWriteNoteTypeEnum trainerAssessment = _$progressNoteWriteNoteTypeEnum_trainerAssessment;

  static Serializer<ProgressNoteWriteNoteTypeEnum> get serializer => _$progressNoteWriteNoteTypeEnumSerializer;

  const ProgressNoteWriteNoteTypeEnum._(String name): super(name);

  static BuiltSet<ProgressNoteWriteNoteTypeEnum> get values => _$progressNoteWriteNoteTypeEnumValues;
  static ProgressNoteWriteNoteTypeEnum valueOf(String name) => _$progressNoteWriteNoteTypeEnumValueOf(name);
}

