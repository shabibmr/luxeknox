//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gst_tax_code_summary.g.dart';

/// GstTaxCodeSummary
///
/// Properties:
/// * [taxCodeId] 
/// * [taxCodeName] 
/// * [ratePercent] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxableValue] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [cgstAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [sgstAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [igstAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalTax] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class GstTaxCodeSummary implements Built<GstTaxCodeSummary, GstTaxCodeSummaryBuilder> {
  @BuiltValueField(wireName: r'tax_code_id')
  int get taxCodeId;

  @BuiltValueField(wireName: r'tax_code_name')
  String get taxCodeName;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'rate_percent')
  String get ratePercent;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'taxable_value')
  String get taxableValue;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'cgst_amount')
  String get cgstAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'sgst_amount')
  String get sgstAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'igst_amount')
  String get igstAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_tax')
  String get totalTax;

  GstTaxCodeSummary._();

  factory GstTaxCodeSummary([void updates(GstTaxCodeSummaryBuilder b)]) = _$GstTaxCodeSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GstTaxCodeSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GstTaxCodeSummary> get serializer => _$GstTaxCodeSummarySerializer();
}

class _$GstTaxCodeSummarySerializer implements PrimitiveSerializer<GstTaxCodeSummary> {
  @override
  final Iterable<Type> types = const [GstTaxCodeSummary, _$GstTaxCodeSummary];

  @override
  final String wireName = r'GstTaxCodeSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GstTaxCodeSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tax_code_id';
    yield serializers.serialize(
      object.taxCodeId,
      specifiedType: const FullType(int),
    );
    yield r'tax_code_name';
    yield serializers.serialize(
      object.taxCodeName,
      specifiedType: const FullType(String),
    );
    yield r'rate_percent';
    yield serializers.serialize(
      object.ratePercent,
      specifiedType: const FullType(String),
    );
    yield r'taxable_value';
    yield serializers.serialize(
      object.taxableValue,
      specifiedType: const FullType(String),
    );
    yield r'cgst_amount';
    yield serializers.serialize(
      object.cgstAmount,
      specifiedType: const FullType(String),
    );
    yield r'sgst_amount';
    yield serializers.serialize(
      object.sgstAmount,
      specifiedType: const FullType(String),
    );
    yield r'igst_amount';
    yield serializers.serialize(
      object.igstAmount,
      specifiedType: const FullType(String),
    );
    yield r'total_tax';
    yield serializers.serialize(
      object.totalTax,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GstTaxCodeSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GstTaxCodeSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tax_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxCodeId = valueDes;
          break;
        case r'tax_code_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxCodeName = valueDes;
          break;
        case r'rate_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ratePercent = valueDes;
          break;
        case r'taxable_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxableValue = valueDes;
          break;
        case r'cgst_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cgstAmount = valueDes;
          break;
        case r'sgst_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sgstAmount = valueDes;
          break;
        case r'igst_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.igstAmount = valueDes;
          break;
        case r'total_tax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalTax = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GstTaxCodeSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GstTaxCodeSummaryBuilder();
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


