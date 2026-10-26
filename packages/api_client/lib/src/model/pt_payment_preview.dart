//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_payment_preview.g.dart';

/// PtPaymentPreview
///
/// Properties:
/// * [subtotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [discount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [tax] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [total] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class PtPaymentPreview implements Built<PtPaymentPreview, PtPaymentPreviewBuilder> {
  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'discount')
  String get discount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'tax')
  String get tax;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total')
  String get total;

  PtPaymentPreview._();

  factory PtPaymentPreview([void updates(PtPaymentPreviewBuilder b)]) = _$PtPaymentPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtPaymentPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtPaymentPreview> get serializer => _$PtPaymentPreviewSerializer();
}

class _$PtPaymentPreviewSerializer implements PrimitiveSerializer<PtPaymentPreview> {
  @override
  final Iterable<Type> types = const [PtPaymentPreview, _$PtPaymentPreview];

  @override
  final String wireName = r'PtPaymentPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtPaymentPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
    yield r'tax';
    yield serializers.serialize(
      object.tax,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtPaymentPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtPaymentPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subtotal = valueDes;
          break;
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discount = valueDes;
          break;
        case r'tax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tax = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtPaymentPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtPaymentPreviewBuilder();
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


