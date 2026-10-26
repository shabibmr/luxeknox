//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_create.g.dart';

/// MembershipCreate
///
/// Properties:
/// * [memberId] 
/// * [productId] 
/// * [startDate] 
/// * [paymentMethodId] 
/// * [lockerNumber] 
/// * [autoRenew] 
/// * [partnerMemberId] - Required for a couple product; rejected for a single product.
/// * [replacePartnerMembership] - Must be true when the partner has an active or frozen single membership; it is cancelled.
/// * [discountAmount] - Optional unsigned discount. Payment totals still reject amounts over the subtotal.
@BuiltValue()
abstract class MembershipCreate implements Built<MembershipCreate, MembershipCreateBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'product_id')
  int get productId;

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'payment_method_id')
  int get paymentMethodId;

  @BuiltValueField(wireName: r'locker_number')
  String? get lockerNumber;

  @BuiltValueField(wireName: r'auto_renew')
  bool? get autoRenew;

  /// Required for a couple product; rejected for a single product.
  @BuiltValueField(wireName: r'partner_member_id')
  int? get partnerMemberId;

  /// Must be true when the partner has an active or frozen single membership; it is cancelled.
  @BuiltValueField(wireName: r'replace_partner_membership')
  bool? get replacePartnerMembership;

  /// Optional unsigned discount. Payment totals still reject amounts over the subtotal.
  @BuiltValueField(wireName: r'discount_amount')
  String? get discountAmount;

  MembershipCreate._();

  factory MembershipCreate([void updates(MembershipCreateBuilder b)]) = _$MembershipCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipCreate> get serializer => _$MembershipCreateSerializer();
}

class _$MembershipCreateSerializer implements PrimitiveSerializer<MembershipCreate> {
  @override
  final Iterable<Type> types = const [MembershipCreate, _$MembershipCreate];

  @override
  final String wireName = r'MembershipCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'product_id';
    yield serializers.serialize(
      object.productId,
      specifiedType: const FullType(int),
    );
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'payment_method_id';
    yield serializers.serialize(
      object.paymentMethodId,
      specifiedType: const FullType(int),
    );
    if (object.lockerNumber != null) {
      yield r'locker_number';
      yield serializers.serialize(
        object.lockerNumber,
        specifiedType: const FullType(String),
      );
    }
    if (object.autoRenew != null) {
      yield r'auto_renew';
      yield serializers.serialize(
        object.autoRenew,
        specifiedType: const FullType(bool),
      );
    }
    if (object.partnerMemberId != null) {
      yield r'partner_member_id';
      yield serializers.serialize(
        object.partnerMemberId,
        specifiedType: const FullType(int),
      );
    }
    if (object.replacePartnerMembership != null) {
      yield r'replace_partner_membership';
      yield serializers.serialize(
        object.replacePartnerMembership,
        specifiedType: const FullType(bool),
      );
    }
    if (object.discountAmount != null) {
      yield r'discount_amount';
      yield serializers.serialize(
        object.discountAmount,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productId = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'payment_method_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentMethodId = valueDes;
          break;
        case r'locker_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lockerNumber = valueDes;
          break;
        case r'auto_renew':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.autoRenew = valueDes;
          break;
        case r'partner_member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.partnerMemberId = valueDes;
          break;
        case r'replace_partner_membership':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.replacePartnerMembership = valueDes;
          break;
        case r'discount_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.discountAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipCreateBuilder();
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


