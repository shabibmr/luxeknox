//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/membership_status.dart';
import 'package:api_client/src/model/membership_product.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership.g.dart';

/// Membership
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [productId] 
/// * [startDate] 
/// * [endDate] 
/// * [remainingPtSessions] 
/// * [status] 
/// * [lockerNumber] 
/// * [autoRenew] 
/// * [rowVersion] 
/// * [product] 
@BuiltValue()
abstract class Membership implements Built<Membership, MembershipBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'product_id')
  int get productId;

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  @BuiltValueField(wireName: r'remaining_pt_sessions')
  int? get remainingPtSessions;

  @BuiltValueField(wireName: r'status')
  MembershipStatus get status;
  // enum statusEnum {  active,  expired,  frozen,  cancelled,  };

  @BuiltValueField(wireName: r'locker_number')
  String? get lockerNumber;

  @BuiltValueField(wireName: r'auto_renew')
  bool? get autoRenew;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'product')
  MembershipProduct? get product;

  Membership._();

  factory Membership([void updates(MembershipBuilder b)]) = _$Membership;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Membership> get serializer => _$MembershipSerializer();
}

class _$MembershipSerializer implements PrimitiveSerializer<Membership> {
  @override
  final Iterable<Type> types = const [Membership, _$Membership];

  @override
  final String wireName = r'Membership';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Membership object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
    );
    if (object.remainingPtSessions != null) {
      yield r'remaining_pt_sessions';
      yield serializers.serialize(
        object.remainingPtSessions,
        specifiedType: const FullType(int),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MembershipStatus),
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
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    if (object.product != null) {
      yield r'product';
      yield serializers.serialize(
        object.product,
        specifiedType: const FullType(MembershipProduct),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Membership object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
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
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
          break;
        case r'remaining_pt_sessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.remainingPtSessions = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipStatus),
          ) as MembershipStatus;
          result.status = valueDes;
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
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MembershipProduct),
          ) as MembershipProduct?;
          if (valueDes == null) continue;
          result.product.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Membership deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipBuilder();
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


