//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/journal_line_write.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journal_create.g.dart';

/// JournalCreate
///
/// Properties:
/// * [entryDate] 
/// * [sourceType] 
/// * [memo] 
/// * [lines] 
@BuiltValue()
abstract class JournalCreate implements Built<JournalCreate, JournalCreateBuilder> {
  @BuiltValueField(wireName: r'entry_date')
  Date get entryDate;

  @BuiltValueField(wireName: r'source_type')
  JournalCreateSourceTypeEnum get sourceType;
  // enum sourceTypeEnum {  manual,  opening_balance,  };

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'lines')
  BuiltList<JournalLineWrite> get lines;

  JournalCreate._();

  factory JournalCreate([void updates(JournalCreateBuilder b)]) = _$JournalCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JournalCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JournalCreate> get serializer => _$JournalCreateSerializer();
}

class _$JournalCreateSerializer implements PrimitiveSerializer<JournalCreate> {
  @override
  final Iterable<Type> types = const [JournalCreate, _$JournalCreate];

  @override
  final String wireName = r'JournalCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JournalCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entry_date';
    yield serializers.serialize(
      object.entryDate,
      specifiedType: const FullType(Date),
    );
    yield r'source_type';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(JournalCreateSourceTypeEnum),
    );
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(JournalLineWrite)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JournalCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JournalCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.entryDate = valueDes;
          break;
        case r'source_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JournalCreateSourceTypeEnum),
          ) as JournalCreateSourceTypeEnum;
          result.sourceType = valueDes;
          break;
        case r'memo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memo = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(JournalLineWrite)]),
          ) as BuiltList<JournalLineWrite>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JournalCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JournalCreateBuilder();
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


class JournalCreateSourceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'manual')
  static const JournalCreateSourceTypeEnum manual = _$journalCreateSourceTypeEnum_manual;
  @BuiltValueEnumConst(wireName: r'opening_balance')
  static const JournalCreateSourceTypeEnum openingBalance = _$journalCreateSourceTypeEnum_openingBalance;

  static Serializer<JournalCreateSourceTypeEnum> get serializer => _$journalCreateSourceTypeEnumSerializer;

  const JournalCreateSourceTypeEnum._(String name): super(name);

  static BuiltSet<JournalCreateSourceTypeEnum> get values => _$journalCreateSourceTypeEnumValues;
  static JournalCreateSourceTypeEnum valueOf(String name) => _$journalCreateSourceTypeEnumValueOf(name);
}

