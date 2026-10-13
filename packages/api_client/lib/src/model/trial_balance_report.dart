//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/trial_balance_account.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trial_balance_report.g.dart';

/// TrialBalanceReport
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [accounts] 
/// * [totalDebit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalCredit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class TrialBalanceReport implements Built<TrialBalanceReport, TrialBalanceReportBuilder> {
  @BuiltValueField(wireName: r'from')
  Date? get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'accounts')
  BuiltList<TrialBalanceAccount> get accounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_debit')
  String get totalDebit;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_credit')
  String get totalCredit;

  TrialBalanceReport._();

  factory TrialBalanceReport([void updates(TrialBalanceReportBuilder b)]) = _$TrialBalanceReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrialBalanceReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrialBalanceReport> get serializer => _$TrialBalanceReportSerializer();
}

class _$TrialBalanceReportSerializer implements PrimitiveSerializer<TrialBalanceReport> {
  @override
  final Iterable<Type> types = const [TrialBalanceReport, _$TrialBalanceReport];

  @override
  final String wireName = r'TrialBalanceReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrialBalanceReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.from != null) {
      yield r'from';
      yield serializers.serialize(
        object.from,
        specifiedType: const FullType(Date),
      );
    }
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'accounts';
    yield serializers.serialize(
      object.accounts,
      specifiedType: const FullType(BuiltList, [FullType(TrialBalanceAccount)]),
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
    TrialBalanceReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrialBalanceReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TrialBalanceAccount)]),
          ) as BuiltList<TrialBalanceAccount>;
          result.accounts.replace(valueDes);
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
  TrialBalanceReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrialBalanceReportBuilder();
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


