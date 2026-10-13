//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profit_and_loss_account.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profit_and_loss_report.g.dart';

/// ProfitAndLossReport
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [incomeAccounts] 
/// * [totalIncome] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [expenseAccounts] 
/// * [totalExpense] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [netProfit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class ProfitAndLossReport implements Built<ProfitAndLossReport, ProfitAndLossReportBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'income_accounts')
  BuiltList<ProfitAndLossAccount> get incomeAccounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_income')
  String get totalIncome;

  @BuiltValueField(wireName: r'expense_accounts')
  BuiltList<ProfitAndLossAccount> get expenseAccounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_expense')
  String get totalExpense;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'net_profit')
  String get netProfit;

  ProfitAndLossReport._();

  factory ProfitAndLossReport([void updates(ProfitAndLossReportBuilder b)]) = _$ProfitAndLossReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfitAndLossReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfitAndLossReport> get serializer => _$ProfitAndLossReportSerializer();
}

class _$ProfitAndLossReportSerializer implements PrimitiveSerializer<ProfitAndLossReport> {
  @override
  final Iterable<Type> types = const [ProfitAndLossReport, _$ProfitAndLossReport];

  @override
  final String wireName = r'ProfitAndLossReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfitAndLossReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'income_accounts';
    yield serializers.serialize(
      object.incomeAccounts,
      specifiedType: const FullType(BuiltList, [FullType(ProfitAndLossAccount)]),
    );
    yield r'total_income';
    yield serializers.serialize(
      object.totalIncome,
      specifiedType: const FullType(String),
    );
    yield r'expense_accounts';
    yield serializers.serialize(
      object.expenseAccounts,
      specifiedType: const FullType(BuiltList, [FullType(ProfitAndLossAccount)]),
    );
    yield r'total_expense';
    yield serializers.serialize(
      object.totalExpense,
      specifiedType: const FullType(String),
    );
    yield r'net_profit';
    yield serializers.serialize(
      object.netProfit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfitAndLossReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfitAndLossReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'income_accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfitAndLossAccount)]),
          ) as BuiltList<ProfitAndLossAccount>;
          result.incomeAccounts.replace(valueDes);
          break;
        case r'total_income':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalIncome = valueDes;
          break;
        case r'expense_accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfitAndLossAccount)]),
          ) as BuiltList<ProfitAndLossAccount>;
          result.expenseAccounts.replace(valueDes);
          break;
        case r'total_expense':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalExpense = valueDes;
          break;
        case r'net_profit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.netProfit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfitAndLossReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfitAndLossReportBuilder();
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


