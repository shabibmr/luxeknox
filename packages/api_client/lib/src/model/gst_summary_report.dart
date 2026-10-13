//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/gst_tax_code_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gst_summary_report.g.dart';

/// GstSummaryReport
///
/// Properties:
/// * [from] 
/// * [to] 
/// * [taxCodes] 
/// * [totalTaxableValue] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [outputCgst] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [outputSgst] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [outputIgst] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalOutputTax] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [inputTaxCredit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [netPayable] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class GstSummaryReport implements Built<GstSummaryReport, GstSummaryReportBuilder> {
  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'tax_codes')
  BuiltList<GstTaxCodeSummary> get taxCodes;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_taxable_value')
  String get totalTaxableValue;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'output_cgst')
  String get outputCgst;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'output_sgst')
  String get outputSgst;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'output_igst')
  String get outputIgst;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_output_tax')
  String get totalOutputTax;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'input_tax_credit')
  String get inputTaxCredit;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'net_payable')
  String get netPayable;

  GstSummaryReport._();

  factory GstSummaryReport([void updates(GstSummaryReportBuilder b)]) = _$GstSummaryReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GstSummaryReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GstSummaryReport> get serializer => _$GstSummaryReportSerializer();
}

class _$GstSummaryReportSerializer implements PrimitiveSerializer<GstSummaryReport> {
  @override
  final Iterable<Type> types = const [GstSummaryReport, _$GstSummaryReport];

  @override
  final String wireName = r'GstSummaryReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GstSummaryReport object, {
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
    yield r'tax_codes';
    yield serializers.serialize(
      object.taxCodes,
      specifiedType: const FullType(BuiltList, [FullType(GstTaxCodeSummary)]),
    );
    yield r'total_taxable_value';
    yield serializers.serialize(
      object.totalTaxableValue,
      specifiedType: const FullType(String),
    );
    yield r'output_cgst';
    yield serializers.serialize(
      object.outputCgst,
      specifiedType: const FullType(String),
    );
    yield r'output_sgst';
    yield serializers.serialize(
      object.outputSgst,
      specifiedType: const FullType(String),
    );
    yield r'output_igst';
    yield serializers.serialize(
      object.outputIgst,
      specifiedType: const FullType(String),
    );
    yield r'total_output_tax';
    yield serializers.serialize(
      object.totalOutputTax,
      specifiedType: const FullType(String),
    );
    yield r'input_tax_credit';
    yield serializers.serialize(
      object.inputTaxCredit,
      specifiedType: const FullType(String),
    );
    yield r'net_payable';
    yield serializers.serialize(
      object.netPayable,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GstSummaryReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GstSummaryReportBuilder result,
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
        case r'tax_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GstTaxCodeSummary)]),
          ) as BuiltList<GstTaxCodeSummary>;
          result.taxCodes.replace(valueDes);
          break;
        case r'total_taxable_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalTaxableValue = valueDes;
          break;
        case r'output_cgst':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.outputCgst = valueDes;
          break;
        case r'output_sgst':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.outputSgst = valueDes;
          break;
        case r'output_igst':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.outputIgst = valueDes;
          break;
        case r'total_output_tax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalOutputTax = valueDes;
          break;
        case r'input_tax_credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inputTaxCredit = valueDes;
          break;
        case r'net_payable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.netPayable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GstSummaryReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GstSummaryReportBuilder();
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


