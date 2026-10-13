//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/open_ar_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/open_ap_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'open_items_report.g.dart';

/// OpenItemsReport
///
/// Properties:
/// * [kind] 
/// * [arItems] 
/// * [apItems] 
/// * [totalOpenAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class OpenItemsReport implements Built<OpenItemsReport, OpenItemsReportBuilder> {
  @BuiltValueField(wireName: r'kind')
  OpenItemsReportKindEnum get kind;
  // enum kindEnum {  ar,  ap,  };

  @BuiltValueField(wireName: r'ar_items')
  BuiltList<OpenArItem>? get arItems;

  @BuiltValueField(wireName: r'ap_items')
  BuiltList<OpenApItem>? get apItems;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_open_amount')
  String get totalOpenAmount;

  OpenItemsReport._();

  factory OpenItemsReport([void updates(OpenItemsReportBuilder b)]) = _$OpenItemsReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OpenItemsReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OpenItemsReport> get serializer => _$OpenItemsReportSerializer();
}

class _$OpenItemsReportSerializer implements PrimitiveSerializer<OpenItemsReport> {
  @override
  final Iterable<Type> types = const [OpenItemsReport, _$OpenItemsReport];

  @override
  final String wireName = r'OpenItemsReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OpenItemsReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(OpenItemsReportKindEnum),
    );
    if (object.arItems != null) {
      yield r'ar_items';
      yield serializers.serialize(
        object.arItems,
        specifiedType: const FullType(BuiltList, [FullType(OpenArItem)]),
      );
    }
    if (object.apItems != null) {
      yield r'ap_items';
      yield serializers.serialize(
        object.apItems,
        specifiedType: const FullType(BuiltList, [FullType(OpenApItem)]),
      );
    }
    yield r'total_open_amount';
    yield serializers.serialize(
      object.totalOpenAmount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OpenItemsReport object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OpenItemsReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OpenItemsReportKindEnum),
          ) as OpenItemsReportKindEnum;
          result.kind = valueDes;
          break;
        case r'ar_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OpenArItem)]),
          ) as BuiltList<OpenArItem>?;
          if (valueDes == null) continue;
          result.arItems.replace(valueDes);
          break;
        case r'ap_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OpenApItem)]),
          ) as BuiltList<OpenApItem>?;
          if (valueDes == null) continue;
          result.apItems.replace(valueDes);
          break;
        case r'total_open_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalOpenAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OpenItemsReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OpenItemsReportBuilder();
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


class OpenItemsReportKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ar')
  static const OpenItemsReportKindEnum ar = _$openItemsReportKindEnum_ar;
  @BuiltValueEnumConst(wireName: r'ap')
  static const OpenItemsReportKindEnum ap = _$openItemsReportKindEnum_ap;

  static Serializer<OpenItemsReportKindEnum> get serializer => _$openItemsReportKindEnumSerializer;

  const OpenItemsReportKindEnum._(String name): super(name);

  static BuiltSet<OpenItemsReportKindEnum> get values => _$openItemsReportKindEnumValues;
  static OpenItemsReportKindEnum valueOf(String name) => _$openItemsReportKindEnumValueOf(name);
}

