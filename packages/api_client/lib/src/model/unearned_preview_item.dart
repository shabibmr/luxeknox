//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unearned_preview_item.g.dart';

/// UnearnedPreviewItem
///
/// Properties:
/// * [kind] 
/// * [sourceId] 
/// * [paymentId] 
/// * [memberId] 
/// * [startsOn] 
/// * [endsOn] 
/// * [unearnedAccountId] 
/// * [incomeAccountId] 
/// * [accountCode] 
/// * [totalNet] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [unexpiredAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class UnearnedPreviewItem implements Built<UnearnedPreviewItem, UnearnedPreviewItemBuilder> {
  @BuiltValueField(wireName: r'kind')
  UnearnedPreviewItemKindEnum get kind;
  // enum kindEnum {  membership,  pt,  };

  @BuiltValueField(wireName: r'source_id')
  int get sourceId;

  @BuiltValueField(wireName: r'payment_id')
  int get paymentId;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'starts_on')
  Date get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  Date get endsOn;

  @BuiltValueField(wireName: r'unearned_account_id')
  int get unearnedAccountId;

  @BuiltValueField(wireName: r'income_account_id')
  int get incomeAccountId;

  @BuiltValueField(wireName: r'account_code')
  String get accountCode;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_net')
  String get totalNet;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'unexpired_amount')
  String get unexpiredAmount;

  UnearnedPreviewItem._();

  factory UnearnedPreviewItem([void updates(UnearnedPreviewItemBuilder b)]) = _$UnearnedPreviewItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnearnedPreviewItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnearnedPreviewItem> get serializer => _$UnearnedPreviewItemSerializer();
}

class _$UnearnedPreviewItemSerializer implements PrimitiveSerializer<UnearnedPreviewItem> {
  @override
  final Iterable<Type> types = const [UnearnedPreviewItem, _$UnearnedPreviewItem];

  @override
  final String wireName = r'UnearnedPreviewItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnearnedPreviewItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(UnearnedPreviewItemKindEnum),
    );
    yield r'source_id';
    yield serializers.serialize(
      object.sourceId,
      specifiedType: const FullType(int),
    );
    yield r'payment_id';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'starts_on';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'ends_on';
    yield serializers.serialize(
      object.endsOn,
      specifiedType: const FullType(Date),
    );
    yield r'unearned_account_id';
    yield serializers.serialize(
      object.unearnedAccountId,
      specifiedType: const FullType(int),
    );
    yield r'income_account_id';
    yield serializers.serialize(
      object.incomeAccountId,
      specifiedType: const FullType(int),
    );
    yield r'account_code';
    yield serializers.serialize(
      object.accountCode,
      specifiedType: const FullType(String),
    );
    yield r'total_net';
    yield serializers.serialize(
      object.totalNet,
      specifiedType: const FullType(String),
    );
    yield r'unexpired_amount';
    yield serializers.serialize(
      object.unexpiredAmount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnearnedPreviewItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UnearnedPreviewItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UnearnedPreviewItemKindEnum),
          ) as UnearnedPreviewItemKindEnum;
          result.kind = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sourceId = valueDes;
          break;
        case r'payment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentId = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startsOn = valueDes;
          break;
        case r'ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endsOn = valueDes;
          break;
        case r'unearned_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unearnedAccountId = valueDes;
          break;
        case r'income_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.incomeAccountId = valueDes;
          break;
        case r'account_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountCode = valueDes;
          break;
        case r'total_net':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalNet = valueDes;
          break;
        case r'unexpired_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unexpiredAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnearnedPreviewItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnearnedPreviewItemBuilder();
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


class UnearnedPreviewItemKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'membership')
  static const UnearnedPreviewItemKindEnum membership = _$unearnedPreviewItemKindEnum_membership;
  @BuiltValueEnumConst(wireName: r'pt')
  static const UnearnedPreviewItemKindEnum pt = _$unearnedPreviewItemKindEnum_pt;

  static Serializer<UnearnedPreviewItemKindEnum> get serializer => _$unearnedPreviewItemKindEnumSerializer;

  const UnearnedPreviewItemKindEnum._(String name): super(name);

  static BuiltSet<UnearnedPreviewItemKindEnum> get values => _$unearnedPreviewItemKindEnumValues;
  static UnearnedPreviewItemKindEnum valueOf(String name) => _$unearnedPreviewItemKindEnumValueOf(name);
}

