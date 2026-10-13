//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unearned_preview_totals.g.dart';

/// UnearnedPreviewTotals
///
/// Properties:
/// * [unearnedMembershipTotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [unearnedPtTotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [combinedTotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class UnearnedPreviewTotals implements Built<UnearnedPreviewTotals, UnearnedPreviewTotalsBuilder> {
  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'unearned_membership_total')
  String get unearnedMembershipTotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'unearned_pt_total')
  String get unearnedPtTotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'combined_total')
  String get combinedTotal;

  UnearnedPreviewTotals._();

  factory UnearnedPreviewTotals([void updates(UnearnedPreviewTotalsBuilder b)]) = _$UnearnedPreviewTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnearnedPreviewTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnearnedPreviewTotals> get serializer => _$UnearnedPreviewTotalsSerializer();
}

class _$UnearnedPreviewTotalsSerializer implements PrimitiveSerializer<UnearnedPreviewTotals> {
  @override
  final Iterable<Type> types = const [UnearnedPreviewTotals, _$UnearnedPreviewTotals];

  @override
  final String wireName = r'UnearnedPreviewTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnearnedPreviewTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'unearned_membership_total';
    yield serializers.serialize(
      object.unearnedMembershipTotal,
      specifiedType: const FullType(String),
    );
    yield r'unearned_pt_total';
    yield serializers.serialize(
      object.unearnedPtTotal,
      specifiedType: const FullType(String),
    );
    yield r'combined_total';
    yield serializers.serialize(
      object.combinedTotal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnearnedPreviewTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UnearnedPreviewTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'unearned_membership_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unearnedMembershipTotal = valueDes;
          break;
        case r'unearned_pt_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unearnedPtTotal = valueDes;
          break;
        case r'combined_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.combinedTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnearnedPreviewTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnearnedPreviewTotalsBuilder();
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


