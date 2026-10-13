//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/unearned_preview_totals.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/unearned_preview_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unearned_preview_response.g.dart';

/// UnearnedPreviewResponse
///
/// Properties:
/// * [goLiveDate] 
/// * [totals] 
/// * [items] 
@BuiltValue()
abstract class UnearnedPreviewResponse implements Built<UnearnedPreviewResponse, UnearnedPreviewResponseBuilder> {
  @BuiltValueField(wireName: r'go_live_date')
  Date get goLiveDate;

  @BuiltValueField(wireName: r'totals')
  UnearnedPreviewTotals get totals;

  @BuiltValueField(wireName: r'items')
  BuiltList<UnearnedPreviewItem> get items;

  UnearnedPreviewResponse._();

  factory UnearnedPreviewResponse([void updates(UnearnedPreviewResponseBuilder b)]) = _$UnearnedPreviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnearnedPreviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnearnedPreviewResponse> get serializer => _$UnearnedPreviewResponseSerializer();
}

class _$UnearnedPreviewResponseSerializer implements PrimitiveSerializer<UnearnedPreviewResponse> {
  @override
  final Iterable<Type> types = const [UnearnedPreviewResponse, _$UnearnedPreviewResponse];

  @override
  final String wireName = r'UnearnedPreviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnearnedPreviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'go_live_date';
    yield serializers.serialize(
      object.goLiveDate,
      specifiedType: const FullType(Date),
    );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(UnearnedPreviewTotals),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(UnearnedPreviewItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnearnedPreviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UnearnedPreviewResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'go_live_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.goLiveDate = valueDes;
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UnearnedPreviewTotals),
          ) as UnearnedPreviewTotals;
          result.totals.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UnearnedPreviewItem)]),
          ) as BuiltList<UnearnedPreviewItem>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnearnedPreviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnearnedPreviewResponseBuilder();
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


