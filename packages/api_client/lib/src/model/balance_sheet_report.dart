//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/balance_sheet_account.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'balance_sheet_report.g.dart';

/// BalanceSheetReport
///
/// Properties:
/// * [asOf] 
/// * [fiscalYearStart] 
/// * [assetAccounts] 
/// * [totalAssets] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [liabilityAccounts] 
/// * [totalLiabilities] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [equityAccounts] 
/// * [currentYearEarnings] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalEquity] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalLiabilitiesAndEquity] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class BalanceSheetReport implements Built<BalanceSheetReport, BalanceSheetReportBuilder> {
  @BuiltValueField(wireName: r'as_of')
  Date get asOf;

  @BuiltValueField(wireName: r'fiscal_year_start')
  Date get fiscalYearStart;

  @BuiltValueField(wireName: r'asset_accounts')
  BuiltList<BalanceSheetAccount> get assetAccounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_assets')
  String get totalAssets;

  @BuiltValueField(wireName: r'liability_accounts')
  BuiltList<BalanceSheetAccount> get liabilityAccounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_liabilities')
  String get totalLiabilities;

  @BuiltValueField(wireName: r'equity_accounts')
  BuiltList<BalanceSheetAccount> get equityAccounts;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'current_year_earnings')
  String get currentYearEarnings;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_equity')
  String get totalEquity;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_liabilities_and_equity')
  String get totalLiabilitiesAndEquity;

  BalanceSheetReport._();

  factory BalanceSheetReport([void updates(BalanceSheetReportBuilder b)]) = _$BalanceSheetReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BalanceSheetReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BalanceSheetReport> get serializer => _$BalanceSheetReportSerializer();
}

class _$BalanceSheetReportSerializer implements PrimitiveSerializer<BalanceSheetReport> {
  @override
  final Iterable<Type> types = const [BalanceSheetReport, _$BalanceSheetReport];

  @override
  final String wireName = r'BalanceSheetReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BalanceSheetReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'as_of';
    yield serializers.serialize(
      object.asOf,
      specifiedType: const FullType(Date),
    );
    yield r'fiscal_year_start';
    yield serializers.serialize(
      object.fiscalYearStart,
      specifiedType: const FullType(Date),
    );
    yield r'asset_accounts';
    yield serializers.serialize(
      object.assetAccounts,
      specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
    );
    yield r'total_assets';
    yield serializers.serialize(
      object.totalAssets,
      specifiedType: const FullType(String),
    );
    yield r'liability_accounts';
    yield serializers.serialize(
      object.liabilityAccounts,
      specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
    );
    yield r'total_liabilities';
    yield serializers.serialize(
      object.totalLiabilities,
      specifiedType: const FullType(String),
    );
    yield r'equity_accounts';
    yield serializers.serialize(
      object.equityAccounts,
      specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
    );
    yield r'current_year_earnings';
    yield serializers.serialize(
      object.currentYearEarnings,
      specifiedType: const FullType(String),
    );
    yield r'total_equity';
    yield serializers.serialize(
      object.totalEquity,
      specifiedType: const FullType(String),
    );
    yield r'total_liabilities_and_equity';
    yield serializers.serialize(
      object.totalLiabilitiesAndEquity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BalanceSheetReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BalanceSheetReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.asOf = valueDes;
          break;
        case r'fiscal_year_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.fiscalYearStart = valueDes;
          break;
        case r'asset_accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
          ) as BuiltList<BalanceSheetAccount>;
          result.assetAccounts.replace(valueDes);
          break;
        case r'total_assets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAssets = valueDes;
          break;
        case r'liability_accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
          ) as BuiltList<BalanceSheetAccount>;
          result.liabilityAccounts.replace(valueDes);
          break;
        case r'total_liabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalLiabilities = valueDes;
          break;
        case r'equity_accounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BalanceSheetAccount)]),
          ) as BuiltList<BalanceSheetAccount>;
          result.equityAccounts.replace(valueDes);
          break;
        case r'current_year_earnings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentYearEarnings = valueDes;
          break;
        case r'total_equity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalEquity = valueDes;
          break;
        case r'total_liabilities_and_equity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalLiabilitiesAndEquity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BalanceSheetReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BalanceSheetReportBuilder();
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


