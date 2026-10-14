//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/membership_status.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_replacement_preview.g.dart';

/// MembershipReplacementPreview
///
/// Properties:
/// * [membershipId] 
/// * [productName] 
/// * [status] 
/// * [endDate] 
/// * [remainingDays] 
/// * [isCouple] 
/// * [suggestedCredit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class MembershipReplacementPreview implements Built<MembershipReplacementPreview, MembershipReplacementPreviewBuilder> {
  @BuiltValueField(wireName: r'membership_id')
  int get membershipId;

  @BuiltValueField(wireName: r'product_name')
  String get productName;

  @BuiltValueField(wireName: r'status')
  MembershipStatus get status;
  // enum statusEnum {  active,  expired,  frozen,  cancelled,  };

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  @BuiltValueField(wireName: r'remaining_days')
  int get remainingDays;

  @BuiltValueField(wireName: r'is_couple')
  bool get isCouple;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'suggested_credit')
  String get suggestedCredit;

  MembershipReplacementPreview._();

  factory MembershipReplacementPreview([void updates(MembershipReplacementPreviewBuilder b)]) = _$MembershipReplacementPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipReplacementPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipReplacementPreview> get serializer => _$MembershipReplacementPreviewSerializer();
}

class _$MembershipReplacementPreviewSerializer implements PrimitiveSerializer<MembershipReplacementPreview> {
  @override
  final Iterable<Type> types = const [MembershipReplacementPreview, _$MembershipReplacementPreview];

  @override
  final String wireName = r'MembershipReplacementPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipReplacementPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'membership_id';
    yield serializers.serialize(
      object.membershipId,
      specifiedType: const FullType(int),
    );
    yield r'product_name';
    yield serializers.serialize(
      object.productName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MembershipStatus),
    );
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
    );
    yield r'remaining_days';
    yield serializers.serialize(
      object.remainingDays,
      specifiedType: const FullType(int),
    );
    yield r'is_couple';
    yield serializers.serialize(
      object.isCouple,
      specifiedType: const FullType(bool),
    );
    yield r'suggested_credit';
    yield serializers.serialize(
      object.suggestedCredit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipReplacementPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipReplacementPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membershipId = valueDes;
          break;
        case r'product_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipStatus),
          ) as MembershipStatus;
          result.status = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
          break;
        case r'remaining_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingDays = valueDes;
          break;
        case r'is_couple':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isCouple = valueDes;
          break;
        case r'suggested_credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.suggestedCredit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipReplacementPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipReplacementPreviewBuilder();
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


