//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/journal_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journal.g.dart';

/// Journal
///
/// Properties:
/// * [id] 
/// * [journalNumber] 
/// * [entryDate] 
/// * [accountingPeriodId] 
/// * [sourceType] 
/// * [sourceId] 
/// * [memo] 
/// * [postedAt] - UTC ISO-8601
/// * [postedByUserId] 
/// * [reversesJournalId] 
/// * [rowVersion] 
/// * [lines] 
@BuiltValue()
abstract class Journal implements Built<Journal, JournalBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'journal_number')
  String get journalNumber;

  @BuiltValueField(wireName: r'entry_date')
  Date get entryDate;

  @BuiltValueField(wireName: r'accounting_period_id')
  int get accountingPeriodId;

  @BuiltValueField(wireName: r'source_type')
  String get sourceType;

  @BuiltValueField(wireName: r'source_id')
  int get sourceId;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'posted_at')
  DateTime get postedAt;

  @BuiltValueField(wireName: r'posted_by_user_id')
  int? get postedByUserId;

  @BuiltValueField(wireName: r'reverses_journal_id')
  int? get reversesJournalId;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'lines')
  BuiltList<JournalLine> get lines;

  Journal._();

  factory Journal([void updates(JournalBuilder b)]) = _$Journal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JournalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Journal> get serializer => _$JournalSerializer();
}

class _$JournalSerializer implements PrimitiveSerializer<Journal> {
  @override
  final Iterable<Type> types = const [Journal, _$Journal];

  @override
  final String wireName = r'Journal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Journal object, {
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
    yield r'accounting_period_id';
    yield serializers.serialize(
      object.accountingPeriodId,
      specifiedType: const FullType(int),
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
    yield r'posted_at';
    yield serializers.serialize(
      object.postedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.postedByUserId != null) {
      yield r'posted_by_user_id';
      yield serializers.serialize(
        object.postedByUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.reversesJournalId != null) {
      yield r'reverses_journal_id';
      yield serializers.serialize(
        object.reversesJournalId,
        specifiedType: const FullType(int),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(JournalLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Journal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JournalBuilder result,
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
        case r'accounting_period_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accountingPeriodId = valueDes;
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
        case r'posted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.postedAt = valueDes;
          break;
        case r'posted_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.postedByUserId = valueDes;
          break;
        case r'reverses_journal_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.reversesJournalId = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(JournalLine)]),
          ) as BuiltList<JournalLine>;
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
  Journal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JournalBuilder();
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


