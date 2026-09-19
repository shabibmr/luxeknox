//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_history.g.dart';

/// MembershipHistory
///
/// Properties:
/// * [id] 
/// * [membershipId] 
/// * [action] 
/// * [oldEndDate] 
/// * [newEndDate] 
/// * [performedByUserId] 
/// * [timestamp] - UTC ISO-8601
@BuiltValue()
abstract class MembershipHistory implements Built<MembershipHistory, MembershipHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'membership_id')
  int get membershipId;

  @BuiltValueField(wireName: r'action')
  MembershipHistoryActionEnum get action;
  // enum actionEnum {  created,  renewed,  upgraded,  frozen,  expired,  cancelled,  extended,  };

  @BuiltValueField(wireName: r'old_end_date')
  Date? get oldEndDate;

  @BuiltValueField(wireName: r'new_end_date')
  Date? get newEndDate;

  @BuiltValueField(wireName: r'performed_by_user_id')
  int? get performedByUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  MembershipHistory._();

  factory MembershipHistory([void updates(MembershipHistoryBuilder b)]) = _$MembershipHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipHistory> get serializer => _$MembershipHistorySerializer();
}

class _$MembershipHistorySerializer implements PrimitiveSerializer<MembershipHistory> {
  @override
  final Iterable<Type> types = const [MembershipHistory, _$MembershipHistory];

  @override
  final String wireName = r'MembershipHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipHistory object, {
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
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(MembershipHistoryActionEnum),
    );
    if (object.oldEndDate != null) {
      yield r'old_end_date';
      yield serializers.serialize(
        object.oldEndDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.newEndDate != null) {
      yield r'new_end_date';
      yield serializers.serialize(
        object.newEndDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.performedByUserId != null) {
      yield r'performed_by_user_id';
      yield serializers.serialize(
        object.performedByUserId,
        specifiedType: const FullType(int),
      );
    }
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipHistoryBuilder result,
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
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipHistoryActionEnum),
          ) as MembershipHistoryActionEnum;
          result.action = valueDes;
          break;
        case r'old_end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.oldEndDate = valueDes;
          break;
        case r'new_end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.newEndDate = valueDes;
          break;
        case r'performed_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.performedByUserId = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipHistoryBuilder();
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


class MembershipHistoryActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'created')
  static const MembershipHistoryActionEnum created = _$membershipHistoryActionEnum_created;
  @BuiltValueEnumConst(wireName: r'renewed')
  static const MembershipHistoryActionEnum renewed = _$membershipHistoryActionEnum_renewed;
  @BuiltValueEnumConst(wireName: r'upgraded')
  static const MembershipHistoryActionEnum upgraded = _$membershipHistoryActionEnum_upgraded;
  @BuiltValueEnumConst(wireName: r'frozen')
  static const MembershipHistoryActionEnum frozen = _$membershipHistoryActionEnum_frozen;
  @BuiltValueEnumConst(wireName: r'expired')
  static const MembershipHistoryActionEnum expired = _$membershipHistoryActionEnum_expired;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MembershipHistoryActionEnum cancelled = _$membershipHistoryActionEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'extended')
  static const MembershipHistoryActionEnum extended = _$membershipHistoryActionEnum_extended;

  static Serializer<MembershipHistoryActionEnum> get serializer => _$membershipHistoryActionEnumSerializer;

  const MembershipHistoryActionEnum._(String name): super(name);

  static BuiltSet<MembershipHistoryActionEnum> get values => _$membershipHistoryActionEnumValues;
  static MembershipHistoryActionEnum valueOf(String name) => _$membershipHistoryActionEnumValueOf(name);
}

