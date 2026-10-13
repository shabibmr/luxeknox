//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/day_book_line.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'day_book_journal.g.dart';

/// DayBookJournal
///
/// Properties:
/// * [id] 
/// * [journalNumber] 
/// * [entryDate] 
/// * [sourceType] 
/// * [sourceId] 
/// * [memo] 
/// * [reversesJournalId] 
/// * [lines] 
@BuiltValue()
abstract class DayBookJournal implements Built<DayBookJournal, DayBookJournalBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'journal_number')
  String get journalNumber;

  @BuiltValueField(wireName: r'entry_date')
  Date get entryDate;

  @BuiltValueField(wireName: r'source_type')
  String get sourceType;

  @BuiltValueField(wireName: r'source_id')
  int get sourceId;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'reverses_journal_id')
  int? get reversesJournalId;

  @BuiltValueField(wireName: r'lines')
  BuiltList<DayBookLine> get lines;

  DayBookJournal._();

  factory DayBookJournal([void updates(DayBookJournalBuilder b)]) = _$DayBookJournal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DayBookJournalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DayBookJournal> get serializer => _$DayBookJournalSerializer();
}

class _$DayBookJournalSerializer implements PrimitiveSerializer<DayBookJournal> {
  @override
  final Iterable<Type> types = const [DayBookJournal, _$DayBookJournal];

  @override
  final String wireName = r'DayBookJournal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DayBookJournal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'journal_number';
    yield serializers.serialize(
      object.journalNumber,
      specifiedType: const FullType(String),
    );
    yield r'entry_date';
    yield serializers.serialize(
      object.entryDate,
      specifiedType: const FullType(Date),
    );
    yield r'source_type';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
    yield r'source_id';
    yield serializers.serialize(
      object.sourceId,
      specifiedType: const FullType(int),
    );
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    if (object.reversesJournalId != null) {
      yield r'reverses_journal_id';
      yield serializers.serialize(
        object.reversesJournalId,
        specifiedType: const FullType(int),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(DayBookLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DayBookJournal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DayBookJournalBuilder result,
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
        case r'journal_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.journalNumber = valueDes;
          break;
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
            specifiedType: const FullType(String),
          ) as String;
          result.sourceType = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sourceId = valueDes;
          break;
        case r'memo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memo = valueDes;
          break;
        case r'reverses_journal_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.reversesJournalId = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DayBookLine)]),
          ) as BuiltList<DayBookLine>;
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
  DayBookJournal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayBookJournalBuilder();
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


