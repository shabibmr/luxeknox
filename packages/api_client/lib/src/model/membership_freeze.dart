//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_freeze.g.dart';

/// MembershipFreeze
///
/// Properties:
/// * [id] 
/// * [membershipId] 
/// * [startDate] 
/// * [endDate] 
/// * [totalFreezeDays] 
/// * [reason] 
/// * [status] 
/// * [reviewedByUserId] 
/// * [reviewedAt] 
@BuiltValue()
abstract class MembershipFreeze implements Built<MembershipFreeze, MembershipFreezeBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'membership_id')
  int get membershipId;

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  @BuiltValueField(wireName: r'total_freeze_days')
  int? get totalFreezeDays;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'status')
  MembershipFreezeStatusEnum get status;
  // enum statusEnum {  pending,  approved,  rejected,  };

  @BuiltValueField(wireName: r'reviewed_by_user_id')
  int? get reviewedByUserId;

  @BuiltValueField(wireName: r'reviewed_at')
  DateTime? get reviewedAt;

  MembershipFreeze._();

  factory MembershipFreeze([void updates(MembershipFreezeBuilder b)]) = _$MembershipFreeze;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipFreezeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipFreeze> get serializer => _$MembershipFreezeSerializer();
}

class _$MembershipFreezeSerializer implements PrimitiveSerializer<MembershipFreeze> {
  @override
  final Iterable<Type> types = const [MembershipFreeze, _$MembershipFreeze];

  @override
  final String wireName = r'MembershipFreeze';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipFreeze object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'membership_id';
    yield serializers.serialize(
      object.membershipId,
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
    if (object.totalFreezeDays != null) {
      yield r'total_freeze_days';
      yield serializers.serialize(
        object.totalFreezeDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MembershipFreezeStatusEnum),
    );
    if (object.reviewedByUserId != null) {
      yield r'reviewed_by_user_id';
      yield serializers.serialize(
        object.reviewedByUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipFreeze object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipFreezeBuilder result,
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
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membershipId = valueDes;
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
        case r'total_freeze_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalFreezeDays = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipFreezeStatusEnum),
          ) as MembershipFreezeStatusEnum;
          result.status = valueDes;
          break;
        case r'reviewed_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.reviewedByUserId = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipFreeze deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipFreezeBuilder();
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


class MembershipFreezeStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const MembershipFreezeStatusEnum pending = _$membershipFreezeStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'approved')
  static const MembershipFreezeStatusEnum approved = _$membershipFreezeStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MembershipFreezeStatusEnum rejected = _$membershipFreezeStatusEnum_rejected;

  static Serializer<MembershipFreezeStatusEnum> get serializer => _$membershipFreezeStatusEnumSerializer;

  const MembershipFreezeStatusEnum._(String name): super(name);

  static BuiltSet<MembershipFreezeStatusEnum> get values => _$membershipFreezeStatusEnumValues;
  static MembershipFreezeStatusEnum valueOf(String name) => _$membershipFreezeStatusEnumValueOf(name);
}

