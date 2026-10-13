//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/day_book_journal.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'day_book_report.g.dart';

/// DayBookReport
///
/// Properties:
/// * [date] 
/// * [journals] 
/// * [totalDebit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalCredit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class DayBookReport implements Built<DayBookReport, DayBookReportBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'journals')
  BuiltList<DayBookJournal> get journals;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_debit')
  String get totalDebit;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_credit')
  String get totalCredit;

  DayBookReport._();

  factory DayBookReport([void updates(DayBookReportBuilder b)]) = _$DayBookReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DayBookReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DayBookReport> get serializer => _$DayBookReportSerializer();
}

class _$DayBookReportSerializer implements PrimitiveSerializer<DayBookReport> {
  @override
  final Iterable<Type> types = const [DayBookReport, _$DayBookReport];

  @override
  final String wireName = r'DayBookReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DayBookReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'journals';
    yield serializers.serialize(
      object.journals,
      specifiedType: const FullType(BuiltList, [FullType(DayBookJournal)]),
    );
    yield r'total_debit';
    yield serializers.serialize(
      object.totalDebit,
      specifiedType: const FullType(String),
    );
    yield r'total_credit';
    yield serializers.serialize(
      object.totalCredit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DayBookReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DayBookReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'journals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DayBookJournal)]),
          ) as BuiltList<DayBookJournal>;
          result.journals.replace(valueDes);
          break;
        case r'total_debit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalDebit = valueDes;
          break;
        case r'total_credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalCredit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DayBookReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayBookReportBuilder();
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


